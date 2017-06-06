import Foundation

public struct ActionHolder <Action: JanetAction> {
  public let origin: Action
  public var modified: Action
  
  public static func create(action: Action) -> ActionHolder<Action> {
    return ActionHolder(origin: action,
                        modified: action)
  }
  
  func isOrigin(action: Any) -> Bool {
    guard let castedAction = action as? Action else {
      return false
    }
    return self.origin == castedAction
  }
}

extension ActionHolder: Equatable {
  public static func == (lhs: ActionHolder<Action>, rhs: ActionHolder<Action>) -> Bool {
    return lhs.origin == rhs.origin && lhs.modified == rhs.modified
  }
}
