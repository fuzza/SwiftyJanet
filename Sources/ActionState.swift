import Foundation
import RxSwift

public enum ActionState<A> {
  case start(A)
  case progress(A, Double)
  case success(A)
  case error(A, Error)
  
  public func action() -> A {
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
  
  public func castTo<T>() throws -> ActionState<T> {
    switch self {
    case let .start(action as T):
      return ActionState<T>.start(action)
    case let .progress(action as T, progress):
      return ActionState<T>.progress(action, progress)
    case let .success(action as T):
      return ActionState<T>.success(action)
    case let .error(action as T, error):
      return ActionState<T>.error(action, error)
    default:
      throw JanetError.actionStateCastError
    }
  }
}
