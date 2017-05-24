import Foundation
import RxSwift

public final class Janet {
  internal let pipeline: PublishSubject<Any> = PublishSubject()
  private let callback: ActionServiceCallback
  
  var services: [ActionService]
  
  init(services: [ActionService]) {
    self.callback = ActionServiceCallback(pipeline: pipeline)
    self.services = services
    self.services.forEach {
      $0.callback = self.callback
    }
  }
  
  func doSend<A: Equatable>(action: A) throws {
    let service = try findService(A.self)
    try service.send(action: ActionHolder.create(action: action))
  }

  func doCancel<A: Equatable>(action: A) throws {
    let actionHolder = ActionHolder.create(action: action)
    callback.onError(holder: actionHolder, error: JanetError.cancelled)
    let service = try findService(A.self)
    service.cancel(action: actionHolder)
  }
  
  private func findService(_ actionType: Any.Type) throws -> ActionService {
    let service = self.services.first(where: {
      $0.acceptsAction(of: actionType)
    })
    
    guard let uwrappedService = service else {
      throw JanetError.serviceLookupError
    }
    
    return uwrappedService
  }
}
