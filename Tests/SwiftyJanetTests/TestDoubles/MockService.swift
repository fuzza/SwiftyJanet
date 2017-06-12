import SwiftyJanet
import Foundation

class MockService<Action: JanetAction>: ActionService {
  typealias SendableStub = (ActionServiceCallback?, ActionHolder<Action>) throws -> Void
  typealias CancelableStub = (ActionHolder<Action>) -> Void
  
  // MARK: TypedActionService
  var callback: ActionServiceCallback?
  
  func sendInternal<T>(action: ActionHolder<T>) throws where T : JanetAction {
    didCallSend = true
    let casted: ActionHolder<Action> = try! ActionHolder(action) //swiftlint:disable:this force_try
    try sendStub?(callback, casted)
  }
  
  func cancel<T>(action: ActionHolder<T>) where T : JanetAction {
    didCallCancel = true
    let casted: ActionHolder<Action> = try! ActionHolder(action) //swiftlint:disable:this force_try
    cancelStub?(casted)
  }
  
  func accepts<T>(action: T) -> Bool where T : JanetAction {
    return action is Action
  }
  
  // MARK: Stubbing
  private(set) var didCallSend = false
  private(set) var didCallCancel = false
  
  var sendStub: SendableStub?
  var cancelStub: CancelableStub?
}
