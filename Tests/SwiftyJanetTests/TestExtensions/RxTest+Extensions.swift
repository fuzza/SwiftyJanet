import SwiftyJanet
import RxSwift
import RxTest

typealias TestStateObservable<T> = TestableObservable<ActionState<T>>
typealias TestStateObserver<T> = TestableObserver<ActionState<T>>

typealias TestStateEvent<T> = RxSwift.Event<ActionState<T>>
typealias TestStateRecorded<T> = RxTest.Recorded<TestStateEvent<T>>

public func == <T: Equatable>(lhs: Event<ActionState<T>>, rhs: Event<ActionState<T>>) -> Bool {
  switch (lhs, rhs) {
  case (.completed, .completed):
    return true
  case (.error(let e1), .error(let e2)):
    return  "\(e1)" == "\(e2)"
  case (.next(let v1), .next(let v2)):
    return v1 == v2
  default:
    return false
  }
}

public func == <T: Equatable>(lhs: Recorded<Event<ActionState<T>>>,
                              rhs: Recorded<Event<ActionState<T>>>) -> Bool {
  return lhs.time == rhs.time && lhs.value == rhs.value
}
