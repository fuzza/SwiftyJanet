import Foundation
import RxSwift

internal typealias SharedPipeline = PublishSubject<ActionPair<Any>>

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
  
  public func createPipe<A: Equatable>(of type: A.Type,
                                       subscribeOn: SchedulerType? = nil)
                                       -> ActionPipe<A> {
    return createPipe(of: type, actionSender: self.send)
  }
  
  public func createPipe<A: AnyObject>(of type: A.Type,
                                       subscribeOn: SchedulerType? = nil)
    -> ActionPipe<A> {
      return createPipe(of: type, actionSender: self.send)
  }
  
  public func createPipe<A: AnyObject & Equatable>(of type: A.Type,
                                                   subscribeOn: SchedulerType? = nil)
    -> ActionPipe<A> {
      return createPipe(of: type, actionSender: self.send)
  }
  
  private func createPipe<A>(of type: A.Type,
                             subscribeOn: SchedulerType? = nil,
                             actionSender: @escaping (A) -> Observable<ActionState<A>>)
                             -> ActionPipe<A> {
    let statePipe = pipeline.asObservable()
      .filter { pair in
        pair.cast(to: type) != nil
      }.map { pair in
        pair.cast(to: type)! // swiftlint:disable:this force_unwrapping
      }.map { pair in
        pair.state
      }.filter { state in
        let action = state.action()
        return type(of: action) == A.self
      }
    
    return ActionPipe(statePipe: statePipe,
                      defaultScheduler: subscribeOn,
                      actionCancel: self.doCancel,
                      actionSender: actionSender)
  }
  
  private func send<A>(action: A,
                       comparator: @escaping (A, A) -> Bool)
                       -> Observable<ActionState<A>> {
    return pipeline.asObservable()
      .filter { pair in
        pair.cast(to: A.self) != nil
      }.map { pair in
        pair.cast(to: A.self)! // swiftlint:disable:this force_unwrapping
      }.filter { pair in
        return comparator(pair.holder.origin, action)
      }.map { pair in
        pair.state
      }.do(onSubscribed: { [weak self] in
        self?.doSend(action: action)
      }).takeWhileInclusive { state in
        !state.isCompleted
      }
  }
  
  private func send<A: Equatable>(action: A) -> Observable<ActionState<A>> {
    return send(action: action, comparator: ==)
  }
  
  private func send<A: AnyObject>(action: A) -> Observable<ActionState<A>> {
    return send(action: action, comparator: ===)
  }
  
  private func send<A: AnyObject & Equatable>(action: A) -> Observable<ActionState<A>> {
    return send(action: action, comparator: ===)
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
