import Foundation
import RxSwift

public final class ActionPipe <Action: JanetAction> {
  public typealias ActionSender<T: Equatable> = (T) -> Observable<ActionState<T>>
  public typealias ActionCancel<T: Equatable> = (T) -> Void
  
  private let bag: DisposeBag = DisposeBag()
  private let defaultScheduler: SchedulerType?
  
  private let actionSender: ActionSender<Action>
  private let actionCancel: ActionCancel<Action>
  private let statePipe: Observable<ActionState<Action>>
  
  internal init(statePipe: Observable<ActionState<Action>>,
                actionSender: @escaping ActionSender<Action>,
                actionCancel: @escaping ActionCancel<Action>,
                defaultScheduler: SchedulerType?  = nil) {
    self.statePipe = statePipe
    self.actionSender = actionSender
    self.actionCancel = actionCancel
    self.defaultScheduler = defaultScheduler
  }
  
  public func observe() -> Observable<ActionState<Action>> {
    return statePipe
  }
  
  public func send(_ action: Action, subscribeOn: SchedulerType? = nil) {
    var scheduler = defaultScheduler
    if let customScheduler = subscribeOn {
      scheduler = customScheduler
    }
    
    sendDeferred(action: action, subscribeOn:scheduler)
      .subscribe()
      .disposed(by: bag)
  }
  
  public func sendDeferred(_ action: Action) -> Observable<ActionState<Action>> {
    return sendDeferred(action: action, subscribeOn:defaultScheduler)
  }
  
  public func cancel(_ action: Action) {
    actionCancel(action)
  }
  
  private func sendDeferred(action: Action,
                            subscribeOn: SchedulerType?)
    -> Observable<ActionState<Action>> {
      var observable = actionSender(action)
      if let scheduler = subscribeOn {
        observable = observable.subscribeOn(scheduler)
      }
      return observable
  }
}
