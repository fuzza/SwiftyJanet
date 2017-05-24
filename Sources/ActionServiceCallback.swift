import Foundation
import RxSwift

public final class ActionServiceCallback {
  let pipeline: PublishSubject<Any>
  
  init(pipeline: PublishSubject<Any>) {
    self.pipeline = pipeline
  }
  
  func onStart<T: Equatable>(holder: ActionHolder<T>) {
    pipeline.onNext(
      (holder, ActionState.start(holder.action))
    )
  }
  
  func onProgress<T: Equatable>(holder: ActionHolder<T>, progress: Double) {
    pipeline.onNext(
      (holder, ActionState.progress(holder.action, progress))
    )
  }
  
  func onSuccess<T: Equatable>(holder: ActionHolder<T>) {
    pipeline.onNext(
      (holder, ActionState.success(holder.action))
    )
  }
  
  func onError<T: Equatable>(holder: ActionHolder<T>, error: Error) {
    pipeline.onNext(
      (holder, ActionState.error(holder.action, error))
    )
  }
}
