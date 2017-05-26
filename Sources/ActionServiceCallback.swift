import Foundation
import RxSwift

public final class ActionServiceCallback {
  let pipeline: SharedPipeline
  
  init(pipeline: PublishSubject<Any>) {
    self.pipeline = pipeline
  }
  
  func onStart<T: Equatable>(holder: ActionHolder<T>) {
    pipeline.onNext(
      (holder, ActionState.start(holder.modified))
    )
  }
  
  func onProgress<T: Equatable>(holder: ActionHolder<T>, progress: Double) {
    pipeline.onNext(
      (holder, ActionState.progress(holder.modified, progress))
    )
  }
  
  func onSuccess<T: Equatable>(holder: ActionHolder<T>) {
    pipeline.onNext(
      (holder, ActionState.success(holder.modified))
    )
  }
  
  func onError<T: Equatable>(holder: ActionHolder<T>, error: Error) {
    pipeline.onNext(
      (holder, ActionState.error(holder.modified, error))
    )
  }
}
