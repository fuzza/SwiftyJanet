import SwiftyJanet
import RxSwift
import RxTest

typealias TestStateObservable<T> = TestableObservable<ActionState<T>>
typealias TestStateObserver<T> = TestableObserver<ActionState<T>>

typealias TestStateEvent<T> = RxSwift.Event<ActionState<T>>
typealias TestStateRecorded<T> = RxTest.Recorded<TestStateEvent<T>>
