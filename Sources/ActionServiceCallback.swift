import Foundation
import RxSwift

public final class ActionServiceCallback {
  let pipeline: SharedPipeline
  
  init(pipeline: SharedPipeline) {
    self.pipeline = pipeline
  }
  
  public func onStart<T>(holder: ActionHolder<T>) {
    let pair = ActionPair(holder: holder,
                          state: ActionState.start(holder.modified))
    pipeline.onNext(pair.cast(to: Any.self)!)
  }
  
  public func onProgress<T>(holder: ActionHolder<T>, progress: Double) {
    let pair = ActionPair(holder: holder,
                          state: ActionState.progress(holder.modified, progress))
    pipeline.onNext(pair.cast(to: Any.self)!)
  }
  
  public func onSuccess<T>(holder: ActionHolder<T>) {
    let pair = ActionPair(holder: holder,
                          state: ActionState.success(holder.modified))
    pipeline.onNext(pair.cast(to: Any.self)!)
  }
  
  public func onError<T>(holder: ActionHolder<T>, error: Error) {
    let pair = ActionPair(holder: holder,
                          state:ActionState.error(holder.modified, error))
    pipeline.onNext(pair.cast(to: Any.self)!)
  }
}
