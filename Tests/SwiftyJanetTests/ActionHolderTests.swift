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
    XCTAssertEqual(sut.modified, "test_action")
  }
  
  func test_action_mutatesHolder() {
    // Arrange
    let action = "test_action"
    var sut = ActionHolder.create(action: action)
    
    // Act
    sut.modified = "modified_test_action"
    
    // Assert
    XCTAssertEqual(sut.origin, "test_action")
    XCTAssertEqual(sut.modified, "modified_test_action")
  }
}
