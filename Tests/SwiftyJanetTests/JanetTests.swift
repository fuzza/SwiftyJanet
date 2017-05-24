@testable import SwiftyJanet
import XCTest
import RxSwift

class JanetTests: XCTestCase {
  
  var sut: Janet!
  var stringService: MockService<String>!
  var intService: MockService<Int>!
  
  override func setUp() {
    super.setUp()
    
    stringService = MockService<String>()
    intService = MockService<Int>()
    
    sut = Janet(services: [stringService, intService])
  }
  
  func test_init_registersServicesWithCallback() {
    XCTAssertNotNil(stringService.callback)
    XCTAssertNotNil(intService.callback)
  }
  
  func test_doSend_findsServiceByActionType_andSendsHolder() {
    // Arrange
    stringService.sendStub = { _, holder in
      XCTAssertEqual(holder, ActionHolder.create(action: "action"))
    }
    
    // Act
    XCTAssertNoThrow(try sut.doSend(action: "action"))
    
    
    // Assert
    XCTAssertTrue(stringService.didCallSend)
    XCTAssertFalse(intService.didCallSend)
  }
  
  func test_doSend_throwsIfServiceNotFound() {
    // Arrange
    let unknownAction = 2.0
    
    // Act
    XCTAssertThrowsError(try sut.doSend(action: unknownAction), "") { error in
      XCTAssertTrue(error is JanetError)
      XCTAssertTrue(error as! JanetError == .serviceLookupError)
    }
    
    // Assert
    XCTAssertFalse(stringService.didCallSend)
    XCTAssertFalse(intService.didCallSend)
  }
  
  func test_doCancel_sendsErrorToPipeline_andCancels() {
    // Arrange
    let expectedPair = (ActionHolder.create(action: "cancel_test"),
                        ActionState.error("cancel_test", JanetError.cancelled))
    
    var result: ActionPair<String>?
    _ = sut.pipeline.take(1).subscribe(onNext: { pair in
      result = pair as? ActionPair<String>
    })
    
    // Act
    XCTAssertNoThrow(try sut.doCancel(action: "cancel_test"))
    
    // Assert
    XCTAssertNotNil(result)
    XCTAssertTrue(result! == expectedPair)

    XCTAssertTrue(stringService.didCallCancel)
    XCTAssertFalse(intService.didCallCancel)
  }
  
  func test_doCancel_sendsErrorToPipeline_andThrowsIfServiceNotFound() {
    // Arrange
    let unknownAction = 2.0
    let expectedPair = (ActionHolder.create(action: 2.0),
                        ActionState.error(2.0, JanetError.cancelled))
    
    var result: ActionPair<Double>?
    _ = sut.pipeline.take(1).subscribe(onNext: { pair in
      result = pair as? ActionPair<Double>
    })
    
    // Act
    XCTAssertThrowsError(try sut.doCancel(action: unknownAction)) { error in
      XCTAssertTrue(error is JanetError)
      XCTAssertTrue(error as! JanetError == .serviceLookupError)
    }
    
    // Assert
    XCTAssertNotNil(result)
    XCTAssertTrue(result! == expectedPair)
    
    XCTAssertFalse(stringService.didCallCancel)
    XCTAssertFalse(intService.didCallCancel)
  }
}
