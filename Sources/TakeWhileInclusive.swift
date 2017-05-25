import Foundation
import RxSwift

public extension ObservableType {
  public func takeWhileInclusive(_ predicate: @escaping (E) -> Bool) -> Observable<E> {
    let untilSignal = self.skipWhile(predicate)
    return self.takeWhile(predicate).concat(untilSignal.take(1))
  }
}
