import SwiftyJanet

extension ActionServiceCallback {
  
  func stubSuccess<A: JanetAction>(holder: ActionHolder<A>, modified: A) {
    var mutableHolder = holder
    mutableHolder.modified = modified
    self.stubSuccessSequence(holder: mutableHolder)
  }
  
  func stubSuccessSequence<A: JanetAction>(holder: ActionHolder<A>) {
    self.onStart(holder: holder)
    self.onProgress(holder: holder, progress: 0.01)
    self.onProgress(holder: holder, progress: 0.99)
    self.onSuccess(holder: holder)
  }
  
  func stubErrorSequence<A: JanetAction>(holder: ActionHolder<A>,
                                         error: Error) {
    self.onStart(holder: holder)
    self.onProgress(holder: holder, progress: 0.01)
    self.onProgress(holder: holder, progress: 0.99)
    self.onError(holder: holder, error: error)
  }
  
  func stubStart<A: JanetAction>(_ action: A) {
    self.onStart(holder: ActionHolder.create(action: action))
  }
  
  func stubProgress<A: JanetAction>(_ action: A, _ progress: Double) {
    self.onProgress(holder: ActionHolder.create(action: action), progress: progress)
  }
}
