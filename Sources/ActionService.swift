import Foundation
import RxSwift

public protocol ActionService: class {
  var callback: ActionServiceCallback? { get set }
  func send(action: Any)
  func cancel(action: Any)
  func acceptsAction(of type: Any.Type) -> Bool
}

public protocol TypedActionService: ActionService {
  associatedtype ServiceAction: JanetAction
  func send(action: ActionHolder<ServiceAction>) throws
  func cancel(action: ActionHolder<ServiceAction>)
}

public extension TypedActionService {
  func send(action: Any) {
    guard let castedAction = action as? ActionHolder<ServiceAction> else {
      assertionFailure("\(self) got unexpected action \(action)")
      return
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
