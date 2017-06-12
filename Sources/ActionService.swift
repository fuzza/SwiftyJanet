import Foundation
import RxSwift

public protocol ActionService: class {
  var callback: ActionServiceCallback? { get set }
  
  func send<T>(action: ActionHolder<T>)
  func sendInternal<T>(action: ActionHolder<T>) throws
  
  func cancel<T>(action: ActionHolder<T>)
  func accepts<T>(action: T) -> Bool
}

public extension ActionService {
  func send<T>(action: ActionHolder<T>) {
    do {
      try sendInternal(action: action)
    } catch {
      self.callback?.onError(holder: action, error: error)
    }
  }
}
