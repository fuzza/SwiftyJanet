import Foundation
import RxSwift

//public protocol JanetAction {
//  func isEqual(to action: Self) -> Bool
//}
//
//extension JanetAction where Self: AnyObject {
//  public func isEqual(to action: Self) -> Bool {
//    return self === action
//  }
//}
//
//extension JanetAction where Self: Equatable {
//  public func isEqual(to action: Self) -> Bool {
//    return self == action
//  }
//}

protocol AnyPair {
  var anyHolder: Any { get }
  var anyState: Any { get }
}

struct ActionPair <Action>: AnyPair {
  let holder: ActionHolder<Action>
  let state: ActionState<Action>
  
  var anyHolder: Any {
    return holder as Any
  }
  
  var anyState: Any {
    return state as Any
  }
}

extension ActionPair {
  func cast<T>(to type: T.Type) -> ActionPair<T>? {
    guard let castedHolder = holder.cast(to: type),
          let castedState = state.cast(to: type) else {
      return nil
    }
    return ActionPair<T>(holder: castedHolder,
                         state: castedState)
  }
}

internal typealias SharedPipeline = PublishSubject<ActionPair<Any>>
