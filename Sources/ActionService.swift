import Foundation
import RxSwift

public protocol ActionService: class {
  var callback: ActionServiceCallback? { get set }
  
  func send<T: JanetAction>(action: ActionHolder<T>)
  func sendInternal<T: JanetAction>(action: ActionHolder<T>) throws
  
  func cancel<T: JanetAction>(action: ActionHolder<T>)
  func accepts<T: JanetAction>(action: T) -> Bool
}

public extension ActionService {
  func send<T: JanetAction>(action: ActionHolder<T>) {
    do {
      try sendInternal(action: action)
    } catch {
      self.callback?.onError(holder: action, error: error)
    }
  }
}
