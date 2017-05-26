import Foundation
import RxSwift

public final class Janet {
  internal let pipeline: SharedPipeline = SharedPipeline()
  private let callback: ActionServiceCallback
  
  var services: [ActionService]
  
  init(services: [ActionService]) {
    self.callback = ActionServiceCallback(pipeline: pipeline)
    self.services = services
    self.services.forEach {
      $0.callback = self.callback
    }
  }
  
  func send<A: Equatable>(action: A) -> Observable<ActionState<A>> {
    return pipeline.asObservable()
      .filter { pair in
        pair is ActionPair<A>
      }.map { pair in
        pair as! ActionPair<A> // swiftlint:disable:this force_cast
      }.filter { (holder, _) in
        holder.isOrigin(action: action)
      }.map { (_, state) in
        state
      }.do(onSubscribed: { [weak self] in
        self?.doSend(action: action)
      }).takeWhileInclusive { state in
        !state.isCompleted
      }
  }
  
  func doSend<A: Equatable>(action: A) {
    let serviceOptional = findService(A.self)
    guard let service = serviceOptional else {
      assertionFailure("Could not found service for \(action)")
      return
    }
    service.send(action: ActionHolder.create(action: action))
  }

  func doCancel<A: Equatable>(action: A) {
    let actionHolder = ActionHolder.create(action: action)
    callback.onError(holder: actionHolder, error: JanetError.cancelled)
    let serviceOptional = findService(A.self)
    guard let service = serviceOptional else {
      assertionFailure("Could not found service for \(action)")
      return
    }
    service.cancel(action: actionHolder)
  }
  
  private func findService(_ actionType: Any.Type) -> ActionService? {
    return self.services.first(where: {
      $0.acceptsAction(of: actionType)
    })
  }
}
