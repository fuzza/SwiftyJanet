import SwiftyJanet
import XCTest

class ActionStateTests: XCTestCase {
  
  // MARK: Action tests

  func test_action_start() {
    // Arrange
    let action = "test_start"
    let sut = ActionState.start(action)
    
    // Act
    let result = sut.action()
    
    // Assert
    XCTAssertEqual(result, "test_start")
  }
  
  func test_action_progress() {
    // Arrange
    let action = "test_progress"
    let sut = ActionState.progress(action, 0.8)
    
    // Act
    let result = sut.action()
    
    // Assert
    XCTAssertEqual(result, "test_progress")
  }
  
  func test_action_success() {
    // Arrange
    let action = "test_success"
    let sut = ActionState.success(action)
    
    // Act
    let result = sut.action()
    
    // Assert
    XCTAssertEqual(result, "test_success")
  }
  
  func test_action_failure() {
    // Arrange
    let action = "test_error"
    let sut = ActionState.error(action, TestError.test)
    
    // Act
    let result = sut.action()
    
    // Assert
    XCTAssertEqual(result, "test_error")
  }
}
