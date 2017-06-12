import SwiftyJanet
import RxSwift
import RxTest
import Nimble
import XCTest

class ActionMock: JanetTestAction {}

// swiftlint:disable force_try
// swiftlint:disable force_unwrapping
class JanetTestsSubclassing: JanetTestCase<ActionMock> {
  
  func test_sendSupportsActionDowncasting() {
    // Arrange
    service.sendStub = { callback, holder in
      let downcastedHolder = holder.cast(to: JanetTestAction.self)!
      callback?.stubSuccessSequence(holder: downcastedHolder)
    }
    
    let action = ActionMock()
    
    // Act
    actionPipe.sendDeferred(action).subscribe(observer).disposed(by:self.bag)
    scheduler.start()
    
    // Asser
    observer.verifySuccessSequenceCompleted(action: action)
  }
  
}
// swiftlint:enable force_try
// swiftlint:enable force_unwrapping
