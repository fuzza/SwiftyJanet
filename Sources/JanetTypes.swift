import Foundation
import RxSwift

internal typealias ActionPair<T: Equatable> = (ActionHolder<T>, ActionState<T>)
internal typealias SharedPipeline = PublishSubject<Any>
