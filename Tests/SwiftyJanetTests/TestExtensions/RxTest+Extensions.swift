import SwiftyJanet
import RxSwift
import RxTest

typealias TestStateObservable<T: JanetAction> = TestableObservable<ActionState<T>>
typealias TestStateObserver<T: JanetAction> = TestableObserver<ActionState<T>>

typealias TestStateEvent<T: JanetAction> = RxSwift.Event<ActionState<T>>
typealias TestStateRecorded<T: JanetAction> = RxTest.Recorded<TestStateEvent<T>>
