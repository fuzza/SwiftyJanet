import Foundation
import RxSwift

public final class ActionServiceCallback {
  let pipeline: SharedPipeline
  
  init(pipeline: SharedPipeline) {
    self.pipeline = pipeline
  }
  
  func onStart<T: JanetAction>(holder: ActionHolder<T>) {
    pipeline.onNext(
      (holder, ActionState.start(holder.modified))
    )
  }
  
  func onProgress<T: JanetAction>(holder: ActionHolder<T>, progress: Double) {
    pipeline.onNext(
      (holder, ActionState.progress(holder.modified, progress))
    )
  }
  
  func onSuccess<T: JanetAction>(holder: ActionHolder<T>) {
    pipeline.onNext(
      (holder, ActionState.success(holder.modified))
    )
  }
  
  func onError<T: JanetAction>(holder: ActionHolder<T>, error: Error) {
    pipeline.onNext(
      (holder, ActionState.error(holder.modified, error))
    )
  }
}
