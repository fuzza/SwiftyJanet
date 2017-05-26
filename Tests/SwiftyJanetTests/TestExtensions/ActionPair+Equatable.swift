@testable import SwiftyJanet

func == <T: Equatable> (lhs: ActionPair<T>, rhs: ActionPair<T>) -> Bool {
  return (lhs.0 == rhs.0) && (lhs.1 == rhs.1)
}
