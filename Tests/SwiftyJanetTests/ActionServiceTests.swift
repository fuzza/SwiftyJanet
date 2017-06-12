@testable import SwiftyJanet
import XCTest
import Nimble
import RxSwift

// swiftlint:disable force_cast
// swiftlint:disable force_unwrapping
class ActionServiceTests: XCTestCase {
  
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
}
// swiftlint:enable force_cast
// swiftlint:enable force_unwrapping
