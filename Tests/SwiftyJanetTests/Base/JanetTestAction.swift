import Foundation
import SwiftyJanet

class JanetTestAction { }

extension JanetTestAction: Equatable {
  static func == (lhs: JanetTestAction, rhs: JanetTestAction) -> Bool {
    return lhs === rhs
  }
}
