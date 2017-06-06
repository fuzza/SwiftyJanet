@testable import SwiftyJanet
import XCTest
import Nimble
import RxTest
import RxSwift

class JanetTestsCancel: JanetTestCase<String> {

  // MARK: Action pipe - cancellation
  
  func test_actionPipe_cancel_cancelsAction() {
    // Arrange
    service.cancelStub = { holder in
      expect(holder.origin) == "test_action"
    }
    
    actionPipe.observe().subscribe(observer).disposed(by: bag)
    
    // Act
    actionPipe.cancel("test_action")
    
    // Assert
    expect(self.service.didCallCancel).to(beTruthy())
    observer.verifyCancelled(action: "test_action")
  }
  
  func test_actionPipe_cancel_assertsIfServiceNotFound() {
    // Arrange
    let unknownAction = JanetTestAction()
    let localObserver = scheduler.createObserver(ActionState<JanetTestAction>.self)
    
    let pipe = janet.createPipe(of: JanetTestAction.self)
    pipe.observe().subscribe(localObserver).disposed(by: bag)
    
    // Act
    expect(pipe.cancel(unknownAction)).to(throwAssertion())
    
    // Assert
    expect(self.service.didCallCancel).to(beFalsy())
    localObserver.verifyCancelled(action: unknownAction)
  }
}
