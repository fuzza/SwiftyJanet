import SwiftyJanet
import Foundation

class MockService<T: JanetAction>: TypedActionService {
  typealias ServiceAction = T
  typealias SendableStub = (ActionServiceCallback?, ActionHolder<ServiceAction>) throws -> Void
  typealias CancelableStub = (ActionHolder<ServiceAction>) -> Void
  
  // MARK: TypedActionService
  var callback: ActionServiceCallback?
  
  func send(action: ActionHolder<ServiceAction>) throws {
    didCallSend = true
    try sendStub?(callback, action)
  }
  
  func cancel(action: ActionHolder<T>) {
    didCallCancel = true
    cancelStub?(action)
  }
  
  // MARK: Stubbing
  private(set) var didCallSend = false
  private(set) var didCallCancel = false
  
  var sendStub: SendableStub?
  var cancelStub: CancelableStub?
}
