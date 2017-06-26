import Foundation
import SwiftyJanet

class JanetTestAction: JanetAction { }

extension JanetTestAction {
  static func == (lhs: JanetTestAction, rhs: JanetTestAction) -> Bool {
    return lhs === rhs
  }
}
