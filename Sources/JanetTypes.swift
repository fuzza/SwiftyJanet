import Foundation
import RxSwift

public typealias JanetAction = Equatable

internal typealias ActionPair <Action: JanetAction> = (ActionHolder<Action>, ActionState<Action>)
internal typealias SharedPipeline = PublishSubject<Any>
