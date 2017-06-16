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
    push(pair)
  }
  
  public func onProgress<T>(holder: ActionHolder<T>, progress: Double) {
    let pair = ActionPair(holder: holder,
                          state: ActionState.progress(holder.modified, progress))
    push(pair)
  }
  
  public func onSuccess<T>(holder: ActionHolder<T>) {
    let pair = ActionPair(holder: holder,
                          state: ActionState.success(holder.modified))
    push(pair)
  }
  
  public func onError<T>(holder: ActionHolder<T>, error: Error) {
    let pair = ActionPair(holder: holder,
                          state:ActionState.error(holder.modified, error))
    push(pair)
  }
  
  private func push<T>(_ pair: ActionPair<T>) {
    let castedPair = pair.cast(to: Any.self)! // swiftlint:disable:this force_unwrapping
    pipeline.onNext(castedPair)
  }
}
