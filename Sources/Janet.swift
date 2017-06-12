import Foundation
import RxSwift

public final class Janet {
  internal let pipeline: SharedPipeline = SharedPipeline()
  private let callback: ActionServiceCallback
  
  var services: [ActionService]
  
  public init(services: [ActionService]) {
    self.callback = ActionServiceCallback(pipeline: pipeline)
    self.services = services
    self.services.forEach {
      $0.callback = self.callback
    }
  }
  
  public func createPipe<A>(of type: A.Type) -> ActionPipe<A> {
    return self.createPipe(of: type, subscribeOn: nil)
  }
  
  public func createPipe<A>(of type: A.Type,
                            subscribeOn: SchedulerType? = nil) -> ActionPipe<A> {
    let statePipe = pipeline.asObservable()
      .filter { pair in
        pair.cast(to: type) != nil
      }.map { pair in
        pair.cast(to: type)! // swiftlint:disable:this force_cast
      }.map { pair in
        pair.state
      }.filter { state in
        let action = state.action()
        return type(of: action) == A.self
      }
    
    return ActionPipe(statePipe: statePipe,
                      defaultScheduler: subscribeOn,
                      actionSender: self.send,
                      actionCancel: self.doCancel)
  }
  
  private func send<A>(action: A) -> Observable<ActionState<A>> {
    return pipeline.asObservable()
      .filter { pair in
        pair.cast(to: A.self) != nil
      }.map { pair in
        pair.cast(to: A.self)! // swiftlint:disable:this force_cast
      }.filter { pair in
        pair.holder.origin == action
      }.map { pair in
        pair.state
      }.do(onSubscribed: { [weak self] in
        self?.doSend(action: action)
      }).takeWhileInclusive { state in
        !state.isCompleted
      }
  }
  
  private func send<A>(action: A) -> Observable<ActionState<A>> {
    return pipeline.asObservable()
      .filter { pair in
        pair.cast(to: A.self) != nil
      }.map { pair in
        pair.cast(to: A.self)! // swiftlint:disable:this force_cast
      }.filter { pair in
        pair.holder.origin === action
      }.map { pair in
        pair.state
      }.do(onSubscribed: { [weak self] in
        self?.doSend(action: action)
      }).takeWhileInclusive { state in
        !state.isCompleted
    }
  }
  
  private func doSend<A>(action: A) {
    let serviceOptional = findService(action: action)
    guard let service = serviceOptional else {
      assertionFailure("Could not found service for \(action)")
      return
    }
    service.send(action: ActionHolder.create(action: action))
  }
  
  private func doCancel<A>(action: A) {
    let actionHolder = ActionHolder.create(action: action)
    callback.onError(holder: actionHolder, error: JanetError.cancelled)
    let serviceOptional = findService(action: action)
    guard let service = serviceOptional else {
      assertionFailure("Could not found service for \(action)")
      return
    }
    service.cancel(action: actionHolder)
  }
  
  private func findService<A>(action: A) -> ActionService? {
    return self.services.first(where: {
      $0.accepts(action: action)
    })
  }
}
