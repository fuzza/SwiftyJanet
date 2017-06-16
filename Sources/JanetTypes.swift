import Foundation
import RxSwift

struct ActionPair <Action> {
  let holder: ActionHolder<Action>
  let state: ActionState<Action>
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
