@testable import SwiftyJanet
import XCTest
import Nimble
import RxSwift

// swiftlint:disable force_cast
// swiftlint:disable force_unwrapping
class TypedActionServiceTests: XCTestCase {
  
  var callback: ActionServiceCallback!
  var mockService: MockService<String>!
  
  var sut: ActionService {
    return mockService
  }
  
  override func setUp() {
    super.setUp()
    callback = ActionServiceCallback(pipeline: PublishSubject())
    mockService = MockService<String>()
    mockService.callback = callback
  }
  
  // MARK: Sending tests
  func test_send_throwsRoutingError_ifActionHolderHasInvalidType() {
    let action = ActionHolder.create(action: 3)

    expect { self.sut.send(action: action) }.to(throwAssertion())
  }
  
  func test_send_triesInternalSend() {
    // Arrange
    let action = ActionHolder.create(action: "test")
    mockService.sendStub = { _, holder in
      XCTAssertEqual(holder, action)
    }
    
    // Act
    sut.send(action: action)
    
    // Assert
    XCTAssertTrue(mockService.didCallSend)
  }
  
  func test_send_catchesServiceError_andSendsToPipeline() {
    // Arrange
    mockService.sendStub = {_, _ in
      throw JanetError.serviceError
    }
    
    let action = ActionHolder.create(action: "test")
    let expectedPair = (action, ActionState.error("test", JanetError.serviceError))
    
    var resultPair: ActionPair<String>? = nil
    _ = callback.pipeline.take(1).subscribe(onNext: { pair in
      resultPair = pair as? ActionPair<String>
    })
    
    // Act
    sut.send(action: action)
    
    // Assert
    XCTAssertNotNil(resultPair)
    XCTAssertTrue(resultPair! == expectedPair)
  }
  
  // MARK: Cancellation tests
  func test_cancel_returns_ifActionHolderHasInvalidType() {
    // Arrange
    let action = ActionHolder.create(action: 3)
    
    // Act
    sut.cancel(action: action)
    
    // Assert
    XCTAssertFalse(mockService.didCallCancel)
  }
  
  func test_cancel_callsInternalCancel() {
    // Arrange
    let action = ActionHolder.create(action: "canceled_action")
    mockService.cancelStub = { holder in
      XCTAssertEqual(holder, action)
    }
    
    // Act
    sut.cancel(action: action)
    
    // Assert
    XCTAssertTrue(mockService.didCallCancel)
  }
  
  // MARK: Supported actions test
  func test_acceptsAction_checksForAssociatedType() {
    XCTAssertTrue(sut.acceptsAction(of: String.self))
    XCTAssertFalse(sut.acceptsAction(of: Int.self))
  }
}
// swiftlint:enable force_cast
// swiftlint:enable force_unwrapping
