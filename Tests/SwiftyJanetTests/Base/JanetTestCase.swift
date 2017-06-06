import SwiftyJanet
import RxSwift
import RxTest
import XCTest

class JanetTestCase <Action: JanetAction>: XCTestCase {
  
  var janet: Janet!
  var service: MockService<Action>!
  var actionPipe: ActionPipe<Action>!
  
  var bag: DisposeBag!
  var scheduler: TestScheduler!
  var observer: TestableObserver<ActionState<String>>!
  
  override func setUp() {
    super.setUp()
    bag = DisposeBag()
    scheduler = TestScheduler(initialClock: 0)
    observer = scheduler.createObserver(ActionState<String>.self)
    
    service = provideService()
    janet = provideJanet(service: service)
    actionPipe = providePipe(janet: janet)
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  public func provideService() -> MockService<Action> {
    let service = MockService<Action>()
    service.sendStub = { callback, holder in
      callback?.stubSuccessSequence(holder: holder)
    }
    return service
  }
  
  public func provideJanet(service: ActionService) -> Janet {
    return Janet(services: [service])
  }
  
  public func providePipe(janet: Janet) -> ActionPipe<Action> {
    return providePipe(janet: janet, scheduler: nil)
  }
  
  public func providePipe(janet: Janet, scheduler: SchedulerType? = nil) -> ActionPipe<Action> {
    return janet.createPipe(of: Action.self, subscribeOn: scheduler)
  }
}
