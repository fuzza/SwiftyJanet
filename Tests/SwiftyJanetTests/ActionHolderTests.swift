@testable import SwiftyJanet
import Foundation
import XCTest

class ActionHolderTests: XCTestCase {
  
  func test_create_returnsNewHolderWithAction() {
    // Arrange
    let action = "test_action"
    
    // Act
    let sut = ActionHolder.create(action: action)
    
    // Assert
    XCTAssertEqual(sut.origin, "test_action")
    XCTAssertEqual(sut.action, "test_action")
  }
  
  func test_action_mutatesHolder() {
    // Arrange
    let action = "test_action"
    var sut = ActionHolder.create(action: action)
    
    // Act
    sut.action = "modified_test_action"
    
    // Assert
    XCTAssertEqual(sut.origin, "test_action")
    XCTAssertEqual(sut.action, "modified_test_action")
  }
    
  func test_isOrigin_checksForEqualityToOrigin() {
    // Arrange
    let origin = "origin"
    let modified = "modified"
    let sut = ActionHolder(origin: origin, action: modified)
    
    // Act
    let result1 = sut.isOrigin(action: origin)
    let result2 = sut.isOrigin(action: modified)
    
    // Assert
    XCTAssertTrue(result1)
    XCTAssertFalse(result2)
  }
  
  func test_isOrigin_returnsFalseForIncompatibleTypes() {
    // Arrange
    let origin = "origin"
    let modified = "modified"
    let nonSupported: Int = 25
    let sut = ActionHolder(origin: origin, action: modified)
    
    // Act
    let result = sut.isOrigin(action: nonSupported)
    
    // Assert
    XCTAssertFalse(result)
  }
  
  func test_equatable_sameOriginsAndAction_areEqual() {
    // Arrange
    let first = ActionHolder(origin: 1, action: 2)
    let second = ActionHolder(origin: 1, action: 2)
    XCTAssertTrue(first == second)
  }
  
  func test_equatable_sameOriginsDifferentActions_areNotEqual() {
    let first = ActionHolder(origin: 1, action: 2)
    let second = ActionHolder(origin: 1, action: 3)

    XCTAssertFalse(first == second)
  }
  
  func test_equatable_sameActionsDifferentOrigins_areNotEqual() {
    let first = ActionHolder(origin: 1, action: 3)
    let second = ActionHolder(origin: 2, action: 3)
    
    XCTAssertFalse(first == second)
  }
  
  func test_equatable_allDifferent_areNotEqual() {
    let first = ActionHolder(origin: 1, action: 3)
    let second = ActionHolder(origin: 2, action: 4)
    
    XCTAssertFalse(first == second)
  }
}
