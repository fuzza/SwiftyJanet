import Foundation
import RxSwift

public protocol JanetAction {
  func isEqual(to action: Self) -> Bool
}

extension JanetAction where Self: AnyObject {
  public func isEqual(to action: Self) -> Bool {
    return self === action
  }
}

extension JanetAction where Self: Equatable {
  public func isEqual(to action: Self) -> Bool {
    return self == action
  }
}

internal typealias ActionPair <Action: JanetAction> = (ActionHolder<Action>, ActionState<Action>)
internal typealias SharedPipeline = PublishSubject<Any>
