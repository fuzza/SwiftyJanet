@testable import SwiftyJanet

extension ActionPair: Equatable {
  public static func == (lhs: ActionPair<Action>, rhs: ActionPair<Action>) -> Bool {
    return lhs.holder == rhs.holder &&
           lhs.state == rhs.state
  }
}
