import Foundation
import RxSwift

public enum ActionState <Action> {
  case start(Action)
  case progress(Action, Double)
  case success(Action)
  case error(Action, Error)
  
  public func action() -> Action {
    switch self {
    case .start(let action):
      return action
    case .progress(let action, _):
      return action
    case .success(let action):
      return action
    case .error(let action, _):
      return action
    }
  }
  
  public var isCompleted: Bool {
    switch self {
    case .start:
      fallthrough
    case .progress:
      return false
    case .success:
      fallthrough
    case .error:
      return true
    }
  }
  
  internal func cast<T>(to type: T.Type) -> ActionState<T>? {
    guard canCast(to: type) else {
      return nil
    }
    
    // swiftlint:disable force_cast
    switch self {
    case .start(let action):
      return ActionState<T>.start(action as! T)
    case .progress(let action, let progress):
      return ActionState<T>.progress(action as! T, progress)
    case .success(let action):
      return ActionState<T>.success(action as! T)
    case .error(let action, let error):
      return ActionState<T>.error(action as! T, error)
    }
    // swiftlint:enable force_cast
  }
  
  private func canCast<T>(to type: T.Type) -> Bool {
    switch self {
    case .start(let action):
      return action is T
    case .progress(let action, _):
      return action is T
    case .success(let action):
      return action is T
    case .error(let action, _):
      return action is T
    }
  }
}
