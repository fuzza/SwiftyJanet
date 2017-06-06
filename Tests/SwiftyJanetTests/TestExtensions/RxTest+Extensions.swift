import SwiftyJanet
import RxSwift
import RxTest

typealias TestStateObservable<T: Equatable> = TestableObservable<ActionState<T>>
typealias TestStateObserver<T: Equatable> = TestableObserver<ActionState<T>>

typealias TestStateEvent<T: Equatable> = RxSwift.Event<ActionState<T>>
typealias TestStateRecorded<T: Equatable> = RxTest.Recorded<TestStateEvent<T>>
