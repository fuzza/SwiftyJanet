@testable import SwiftyJanet
import RxSwift
import RxTest

extension ActionState where Action: Equatable {
  static func == (lhs: ActionState, rhs: ActionState) -> Bool {
    switch (lhs, rhs) {
    case (let .start(a1), let .start(a2)):
      return a1 == a2
    case (let .progress(a1, p1), let .progress(a2, p2)):
      return a1 == a2 && p1 == p2
    case (let .success(a1), let .success(a2)):
      return a1 == a2
    case (let .error(a1, e1), let .error(a2, e2)):
      return a1 == a2 && type(of: e1.self) == type(of: e2.self)
    default:
      return false
    }
  }
}

extension ActionHolder where Action: Equatable {
  static func == (lhs: ActionHolder, rhs: ActionHolder) -> Bool {
    return lhs.origin == rhs.origin &&
           lhs.modified == rhs.modified
  }
}

public func == <T: Equatable>(lhs: Event<ActionState<T>>, rhs: Event<ActionState<T>>) -> Bool {
  switch (lhs, rhs) {
  case (.completed, .completed):
    return true
  case (.error(let e1), .error(let e2)):
    return  "\(e1)" == "\(e2)"
  case (.next(let v1), .next(let v2)):
    return v1 == v2
  default:
    return false
  }
}

public func == <T: Equatable>(lhs: Recorded<Event<ActionState<T>>>,
                              rhs: Recorded<Event<ActionState<T>>>) -> Bool {
  return lhs.time == rhs.time && lhs.value == rhs.value
}
