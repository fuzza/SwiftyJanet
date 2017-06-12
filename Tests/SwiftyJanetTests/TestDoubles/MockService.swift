import SwiftyJanet
import Foundation

class MockService<Action>: ActionService {
  typealias SendableStub = (ActionServiceCallback?, ActionHolder<Action>) throws -> Void
  typealias CancelableStub = (ActionHolder<Action>) -> Void
  
  // MARK: TypedActionService
  var callback: ActionServiceCallback?
  
  func sendInternal<T>(action: ActionHolder<T>) throws {
    didCallSend = true
    let casted = action.cast(to: Action.self)! //swiftlint:disable:this force_unwrapping
    try sendStub?(callback, casted)
  }
  
  func cancel<T>(action: ActionHolder<T>) {
    didCallCancel = true
    let casted = action.cast(to: Action.self)! //swiftlint:disable:this force_unwrapping
    cancelStub?(casted)
  }
  
  func accepts<T>(action: T) -> Bool {
    return action is Action
  }
  
  // MARK: Stubbing
  private(set) var didCallSend = false
  private(set) var didCallCancel = false
  
  var sendStub: SendableStub?
  var cancelStub: CancelableStub?
}
