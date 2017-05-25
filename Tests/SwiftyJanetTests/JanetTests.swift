@testable import SwiftyJanet
import XCTest
import Nimble
import RxTest
import RxSwift

// swiftlint:disable force_cast
// swiftlint:disable force_unwrapping
// swiftlint:disable file_length
class JanetTests: XCTestCase {
  
  var sut: Janet!
  var stringService: MockService<String>!
  var intService: MockService<Int>!
  
  var bag: DisposeBag! = DisposeBag()
  var scheduler: TestScheduler! = TestScheduler(initialClock: 0)
  var observer: TestableObserver<ActionState<String>>!
  
  override func setUp() {
    super.setUp()
    
    bag = DisposeBag()
    scheduler = TestScheduler(initialClock: 0)
    observer = scheduler.createObserver(ActionState<String>.self)
    
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
    sut.doSend(action: "action")
    
    // Assert
    XCTAssertTrue(stringService.didCallSend)
    XCTAssertFalse(intService.didCallSend)
  }
  
  func test_doSend_assertsIfServiceNotFound() {
    // Arrange
    let unknownAction = 2.0
    
    // Act
    expect { self.sut.doSend(action: unknownAction) }.to(throwAssertion())
    
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
     sut.doCancel(action: "cancel_test")
    
    // Assert
    XCTAssertNotNil(result)
    XCTAssertTrue(result! == expectedPair)

    XCTAssertTrue(stringService.didCallCancel)
    XCTAssertFalse(intService.didCallCancel)
  }
  
  func test_doCancel_sendsErrorToPipeline_andAssertsIfServiceNotFound() {
    // Arrange
    let unknownAction = 2.0
    let expectedPair = (ActionHolder.create(action: 2.0),
                        ActionState.error(2.0, JanetError.cancelled))
    
    var result: ActionPair<Double>?
    _ = sut.pipeline.take(1).subscribe(onNext: { pair in
      result = pair as? ActionPair<Double>
    })
    
    // Act
    expect { self.sut.doCancel(action: unknownAction) }.to(throwAssertion())
    
    // Assert
    XCTAssertNotNil(result)
    XCTAssertTrue(result! == expectedPair)
    
    XCTAssertFalse(stringService.didCallCancel)
    XCTAssertFalse(intService.didCallCancel)
  }
  
  func test_send_retrievesStartStateFromPipelineUntilSuccess() {
    stringService.sendStub = { callback, holder in
      callback?.onStart(holder: holder)
      callback?.onProgress(holder: holder, progress: 0.3)
      callback?.onProgress(holder: holder, progress: 0.8)
      callback?.onSuccess(holder: holder)
    }
    
    // Act
    sut.send(action: "test_action").subscribe(observer).disposed(by: bag)
    scheduler.start()
    
    // Assert
    let expected = [
      next(0, ActionState.start("test_action")),
      next(0, ActionState.progress("test_action", 0.3)),
      next(0, ActionState.progress("test_action", 0.8)),
      next(0, ActionState.success("test_action")),
      completed(0)
    ]
    XCTAssertEqual(observer.events, expected)
  }
  
  func test_send_retrievesStartStateFromPipelineUntilFailure() {
    stringService.sendStub = { callback, holder in
      callback?.onStart(holder: holder)
      callback?.onProgress(holder: holder, progress: 0.3)
      callback?.onProgress(holder: holder, progress: 0.8)
      callback?.onError(holder: holder, error: TestError.test)
    }
    
    // Act
    sut.send(action: "test_action").subscribe(observer).disposed(by: bag)
    scheduler.start()
    
    // Assert
    let expected = [
      next(0, ActionState.start("test_action")),
      next(0, ActionState.progress("test_action", 0.3)),
      next(0, ActionState.progress("test_action", 0.8)),
      next(0, ActionState.error("test_action", TestError.test)),
      completed(0)
    ]
    XCTAssertEqual(observer.events, expected)
  }
  
  func test_send_ignoresIrrelevantActions() {
    stringService.sendStub = { callback, holder in
      callback?.onStart(holder: holder)
      callback?.onProgress(holder: ActionHolder.create(action: 25), progress: 0.8)
      callback?.onError(holder: holder, error: TestError.test)
    }
    
    // Act
    sut.send(action: "test_action").subscribe(observer).disposed(by: bag)
    scheduler.start()
    
    // Assert
    let expected = [
      next(0, ActionState.start("test_action")),
      next(0, ActionState.error("test_action", TestError.test)),
      completed(0)
    ]
    XCTAssertEqual(observer.events, expected)
  }
  
  func test_send_retrievesModifiedAction() {
    stringService.sendStub = { callback, holder in
      var mutableHolder = holder
      mutableHolder.modified = "modified_action"
      callback?.onStart(holder: mutableHolder)
    }
    
    // Act
    sut.send(action: "test_action").subscribe(observer).disposed(by: bag)
    scheduler.start()
    
    // Assert
    let expected = [
      next(0, ActionState.start("modified_action"))
    ]
    XCTAssertEqual(observer.events, expected)
  }
}

// swiftlint:enable force_cast
// swiftlint:enable force_unwrapping
// swiftlint:enable file_length
