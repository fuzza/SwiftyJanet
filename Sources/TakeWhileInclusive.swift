import Foundation
import RxSwift

extension ObservableType {
  func takeWhileInclusive(_ predicate: @escaping (E) -> Bool) -> Observable<E> {
    return Observable.create { observer in
      let disposable = self.subscribe(onNext: { element in
        observer.onNext(element)
        if !predicate(element) {
          observer.onCompleted()
        }
      }, onError: observer.onError,
         onCompleted: observer.onCompleted
      )
      
      return Disposables.create {
        disposable.dispose()
      }
    }
  }
}
