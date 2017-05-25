import Foundation

public struct ActionHolder <A: Equatable> {
  let origin: A
  var modified: A
  
  public static func create(action: A) -> ActionHolder<A> {
    return ActionHolder(origin: action,
                        modified: action)
  }
  
  func isOrigin(action: Any) -> Bool {
    guard let castedAction = action as? A else {
      return false
    }
    return self.origin == castedAction
  }
}

extension ActionHolder: Equatable {
  public static func == (lhs: ActionHolder<A>, rhs: ActionHolder<A>) -> Bool {
    return lhs.origin == rhs.origin && lhs.modified == rhs.modified
  }
}