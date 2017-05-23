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
  
  // MARK: Typecasting tests
  
  func test_castTo_start() {
    // Arrange
    let anyState = ActionState<Any>.start("test_start")
    let state: ActionState<String>
    
    do {
      // Act
      state = try anyState.castTo()
      
      // Assert
      switch state {
      case let .start(action) where action != "test_start":
        XCTFail("Expected casted \(anyState), got \(state)")
      default:
        break
      }
    } catch {
      XCTFail("Got \(error) while casting to ActionState<String>")
    }
  }
  
  func test_castTo_progress() {
    // Arrange
    let anyState = ActionState<Any>.progress("test_progress", 0.25)
    let state: ActionState<String>
    
    do {
      // Act
      state = try anyState.castTo()
      
      // Assert
      switch state {
      case let .progress(action, progress) where action != "test_progress" || progress != 0.25:
        XCTFail("Expected casted \(anyState), got \(state)")
      default:
        break
      }
    } catch {
      XCTFail("Got \(error) while casting to ActionState<String>")
    }
  }
  
  func test_castTo_success() {
    // Arrange
    let anyState = ActionState<Any>.success("test_success")
    let state: ActionState<String>
    
    do {
      // Act
      state = try anyState.castTo()
      
      // Assert
      switch state {
      case let .success(action) where action != "test_success":
        XCTFail("Expected casted \(anyState), got \(state)")
      default:
        break
      }
    } catch {
      XCTFail("Got \(error) while casting to ActionState<String>")
    }
  }
  
  func test_castTo_error() {
    // Arrange
    let anyState = ActionState<Any>.error("test_success", TestError.test)
    let state: ActionState<String>
    
    do {
      // Act
      state = try anyState.castTo()
      
      // Assert
      switch state {
      case let .error(action, _ as TestError) where action != "test_success":
        XCTFail("Expected casted \(anyState), got \(state)")
      default:
        break
      }
    } catch {
      XCTFail("Got \(error) while casting to ActionState<String>")
    }
    
  }
}
