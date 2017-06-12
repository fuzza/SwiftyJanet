@testable import SwiftyJanet
import XCTest
import RxSwift

// swiftlint:disable force_unwrapping
class ActionServiceCallbackTests: XCTestCase {
  var disposeBag: DisposeBag!
  var pipeline: SharedPipeline!
  var sut: ActionServiceCallback!
  
  override func setUp() {
    super.setUp()
    disposeBag = DisposeBag()
    pipeline = SharedPipeline()
    sut = ActionServiceCallback(pipeline: pipeline)
  }
  
  func test_onStart() {
    // Arrange
    let holder = ActionHolder(origin: "test_origin", modified: "test_action")
    let expectedResult = ActionPair(holder: holder,
                                    state: ActionState.start("test_action"))
    
    var result: ActionPair<String>? = nil
    
    pipeline.subscribe(onNext: { pair in
      result = pair as? ActionPair<String>
    }).disposed(by: disposeBag)
    
    // Act
    sut.onStart(holder: holder)
    
    // Assert
    XCTAssertNotNil(result)
    XCTAssertTrue(result! == expectedResult)
  }
  
  func test_onProgress() {
    // Arrange
    let holder = ActionHolder(origin: "test_origin", modified: "test_action")
    let expectedResult = ActionPair(holder: holder,
                                    state: ActionState.progress("test_action", 2.3))
    
    var result: ActionPair<String>? = nil
    
    pipeline.subscribe(onNext: { pair in
      result = pair as? ActionPair <String>
    }).disposed(by: disposeBag)
    
    // Act
    sut.onProgress(holder: holder, progress: 2.3)
    
    // Assert
    XCTAssertNotNil(result)
    XCTAssertTrue(result! == expectedResult)
  }
  
  func test_onSuccess() {
    // Arrange
    let holder = ActionHolder(origin: "test_origin", modified: "test_action")
    let expectedResult = ActionPair(holder: holder,
                                    state: ActionState.success("test_action"))
    
    var result: ActionPair<String>? = nil
    
    pipeline.subscribe(onNext: { pair in
      result = pair as? ActionPair<String>
    }).disposed(by: disposeBag)
    
    // Act
    sut.onSuccess(holder: holder)
    
    // Assert
    XCTAssertNotNil(result)
    XCTAssertTrue(result! == expectedResult)
  }
  
  func test_onError() {
    // Arrange
    let holder = ActionHolder(origin: "test_origin", modified: "test_action")
    let expectedResult = ActionPair(holder: holder,
                                    state: ActionState.error("test_action", TestError.test))
    
    var result: ActionPair<String>? = nil
    pipeline.subscribe(onNext: { pair in
      result = pair as? ActionPair<String>
    }).disposed(by: disposeBag)
    
    // Act
    sut.onError(holder: holder, error: TestError.test)
    
    // Assert
    XCTAssertNotNil(result)
    XCTAssertTrue(result! == expectedResult)
  }
}
// swiftlint:enable force_unwrapping
