import Foundation
import RxSwift

public enum ActionState<A: Equatable> {
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
}
