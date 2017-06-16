import Foundation

public struct ActionHolder <Action> {
  public typealias Act = Action
  
  public let origin: Action
  public var modified: Action
  
  public static func create(action: Action) -> ActionHolder<Action> {
    return ActionHolder(origin: action,
                        modified: action)
  }
  
  public init(origin: Action, modified: Action) {
    self.origin = origin
    self.modified = modified
  }
  
  public func cast<T>(to type: T.Type) -> ActionHolder<T>? {
    guard let castedOrigin = self.origin as? T,
          let castedModified = self.modified as? T else {
      return nil
    }
    return ActionHolder<T>(origin: castedOrigin,
                           modified: castedModified)
  }
}
