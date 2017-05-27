import Foundation
import RxSwift

public enum ActionState <Action: JanetAction> {
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
}
