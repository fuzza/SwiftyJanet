import SwiftyJanet
import RxSwift
import RxTest
import Nimble
import XCTest

class JanetTestsSendDeferred: JanetTestCase<String> {

  func test_success_runsOnSubscribeAndCompletes() {
    // Act
    sendDeferred(action: "test_action")
    
    // Assert
    observer.verifySuccessSequenceCompleted(action: "test_action")
  }
  
  func test_failure_runsOnSubscribeAndCompletes() {
    // Act
    sendDeferred(action: "test_action")
    
    // Assert
    observer.verifySuccessSequenceCompleted(action: "test_action")
  }
  
  func test_skipsOtherActions() {
    // Arrange
    service.sendStub = { callback, holder in
      callback?.stubStart("another_action")
      callback?.stubProgress(22, 18.4)
      callback?.stubSuccessSequence(holder: holder)
    }

    // Act
    sendDeferred(action: "test_action")
    
    // Assert
    observer.verifySuccessSequenceCompleted(action: "test_action")
  }
  
  func test_retrievesModifiedAction() {
    // Arrange
    service.sendStub = { callback, holder in
      callback?.stubSuccess(holder: holder, modified: "modified_action")
    }

    // Act
    sendDeferred(action: "test_action")
    
    // Assert
    observer.verifySuccessSequenceCompleted(action: "modified_action")
  }
  
  func test_assertsIfServiceNotFound() {
    let pipe = janet.createPipe(of: Double.self)
    
    expect(pipe.sendDeferred(4.44).subscribe().disposed(by:self.bag))
      .to(throwAssertion())
  }
  
  func test_subscribesOnDefaultScheduler() {
    // Arrange
    let pipe = self.providePipe(janet: janet, scheduler: scheduler)
    
    // Act
    pipe.sendDeferred("test_action").subscribe(observer).disposed(by:self.bag)
    scheduler.start()
    
    // Asser
    observer.verifySuccessSequenceCompleted(action: "test_action", time: 1)
  }
  
  func test_mirrorsEventsToPipeline() {
    // Arrange
    let pipelineObserver = scheduler.createObserver(ActionState<String>.self)
    actionPipe.observe().subscribe(pipelineObserver).disposed(by: bag)
    
    // Act
    sendDeferred(action: "mirror_action")
    
    // Assert
    observer.verifySuccessSequenceCompleted(action: "mirror_action")
    pipelineObserver.verifySuccessSequence(action: "mirror_action")
  }
  
  // MARK: Private helpers
  private func sendDeferred(action: String) {
    actionPipe.sendDeferred(action).subscribe(observer).disposed(by: bag)
  }
}
