import SwiftyJanet

extension ActionState: Equatable {
  public static func == (lhs: ActionState, rhs: ActionState) -> Bool {
    switch (lhs, rhs) {
    case (let .start(a1), let .start(a2)):
      return a1.isEqual(to: a2)
    case (let .progress(a1, p1), let .progress(a2, p2)):
      return a1.isEqual(to: a2) && p1 == p2
    case (let .success(a1), let .success(a2)):
      return a1.isEqual(to: a2)
    case (let .error(a1, e1), let .error(a2, e2)):
      return a1.isEqual(to: a2) && type(of: e1.self) == type(of: e2.self)
    default:
      return false
    }
  }
}
