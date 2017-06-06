import Foundation

public protocol OriginComparable {
  associatedtype Act: JanetAction
  
  var origin: Act { get }
  func isOrigin(action: Any) -> Bool
}

public struct ActionHolder <Action: JanetAction>: OriginComparable {
  public typealias Act = Action
  
  public let origin: Action
  public var modified: Action
  
  public static func create(action: Action) -> ActionHolder<Action> {
    return ActionHolder(origin: action,
                        modified: action)
  }
  
  public func isOrigin(action: Any) -> Bool {
    guard let castedAction = action as? Action else {
      return false
    }
    return self.origin.isEqual(to: castedAction)
  }
}

extension ActionHolder: Equatable {
  public static func == (lhs: ActionHolder<Action>, rhs: ActionHolder<Action>) -> Bool {
    return lhs.origin.isEqual(to: rhs.origin) &&
           lhs.modified.isEqual(to: rhs.modified)
  }
}
