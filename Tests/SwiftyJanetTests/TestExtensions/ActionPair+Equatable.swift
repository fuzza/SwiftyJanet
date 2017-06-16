@testable import SwiftyJanet

extension ActionPair where Action: Equatable {
  static func == (lhs: ActionPair<Action>, rhs: ActionPair<Action>) -> Bool {
    return lhs.holder.origin == rhs.holder.origin &&
           lhs.holder.modified == rhs.holder.modified &&
           lhs.state == rhs.state
  }
}
