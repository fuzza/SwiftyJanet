import Foundation
import RxSwift

public final class ActionPipe <Action> {
  public typealias ActionSender<T> = (T) -> Observable<ActionState<T>>
  public typealias ActionCancel<T> = (T) -> Void
  public typealias StatePipeline<T> = Observable<ActionState<T>>
  
  private let bag: DisposeBag = DisposeBag()
  private let defaultScheduler: SchedulerType?
  
  private var actionSender: ActionSender<Action>!
  private var actionCancel: ActionCancel<Action>!
  private let statePipe: StatePipeline<Action>
  
  internal init(statePipe: StatePipeline<Action>,
                defaultScheduler: SchedulerType?  = nil,
                actionCancel: @escaping ActionCancel<Action>,
                actionSender: @escaping ActionSender<Action>) {
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
