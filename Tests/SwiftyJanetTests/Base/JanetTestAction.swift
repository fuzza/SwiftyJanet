import Foundation
import SwiftyJanet

class JanetTestAction { }

extension JanetTestAction {
  static func == (lhs: JanetTestAction, rhs: JanetTestAction) -> Bool {
    return lhs === rhs
  }
}
