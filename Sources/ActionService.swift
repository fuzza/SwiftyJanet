import Foundation
import RxSwift

public protocol ActionService: class {
  var callback: ActionServiceCallback? { get set }
  func send(action: Any) throws
  func cancel(action: Any)
  func acceptsAction(of type: Any.Type) -> Bool
}

public protocol TypedActionService: ActionService {
  associatedtype ServiceAction: Equatable
  func send(action: ActionHolder<ServiceAction>) throws
  func cancel(action: ActionHolder<ServiceAction>)
}

public extension TypedActionService {
  func send(action: Any) throws {
    guard let castedAction = action as? ActionHolder<ServiceAction> else {
      throw JanetError.actionRoutingError
    }
    
    do {
      try send(action: castedAction)
    } catch {
      self.callback?.onError(holder: castedAction, error: error)
    }
  }
  
  func cancel(action: Any) {
    guard let castedAction = action as? ActionHolder<ServiceAction> else {
      return
    }
    cancel(action: castedAction)
  }
  
  func acceptsAction(of type: Any.Type) -> Bool {
    return type is ServiceAction.Type
  }
}
