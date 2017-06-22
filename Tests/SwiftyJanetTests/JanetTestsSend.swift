import SwiftyJanet
import RxSwift
import RxTest
import Nimble
import XCTest

class JanetTestsSend: JanetTestCase<String> {

  // MARK: Setup
  override public func providePipe(janet: Janet) -> ActionPipe<String> {
    let actionPipe = super.providePipe(janet: janet)
    actionPipe.observe().subscribe(observer).disposed(by: bag)
    return actionPipe
  }
  
  // MARK: Tests
  
  func test_success_startsImmediately() {
    // Act
    actionPipe.send("test_action")
    
    // Assert
    observer.verifySuccessSequence(action: "test_action")
  }
  
  func test_error_startsImmediately() {
    // Arrange
    service.sendStub = { callback, holder in
      callback?.stubErrorSequence(holder: holder, error: TestError.test)
    }
    
    // Act
    actionPipe.send("test_action")
    
    // Assert
    observer.verifyErrorSequence(action: "test_action", error: TestError.test)
  }
  
  func test_assertsIfThereIsNoService() {
    let pipe = janet.createPipe(of: Double.self)
    expect(pipe.send(1.15)).to(throwAssertion())
  }
  
  func test_subscribesOnDefaultScheduler() {
    // Arrange
    let localScheduler = TestScheduler(initialClock: 55)
    let localObserver = localScheduler.createObserver(ActionState<String>.self)
    let pipe = self.providePipe(janet: janet, scheduler: localScheduler)
    pipe.observe().subscribe(localObserver).disposed(by: bag)
    
    // Act
    pipe.send("test_action")
    localScheduler.start()
    
    // Asser
    localObserver.verifySuccessSequence(action: "test_action", time: 55)
  }
  
  func test_observesAllActionsOfGivenType() {
    // Arrange
    service.sendStub = { callback, holder in
      callback?.onStart(holder: holder)
      callback?.onStart(holder: ActionHolder.create(action: "another_action"))
      callback?.onProgress(holder: ActionHolder.create(action: 25), progress: 0.8)
      callback?.onError(holder: holder, error: TestError.test)
    }
    
    // Act
    actionPipe.send("test_action")
    
    // Assert
    observer.verifyEvents(events: [
      next(0, ActionState.start("test_action")),
      next(0, ActionState.start("another_action")),
      next(0, ActionState.error("test_action", TestError.test))
    ])
  }
  
  func test_subscribesOnProvidedScheduler() {
    // Act
    actionPipe.send("test_action", subscribeOn: scheduler)
    scheduler.start()
    
    // Assert
    observer.verifySuccessSequence(action: "test_action", time: 1)
  }
}
