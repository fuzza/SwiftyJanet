import SwiftyJanet
import RxSwift
import RxTest
import XCTest
import Foundation

extension TestableObserver {
  // MARK: Assertions
  func verifySuccessSequence<A: Equatable>(action: A,
                                           time: TestTime = 0,
                                           file: StaticString = #file,
                                           line: UInt = #line) where Element == ActionState<A> {
    verifyEvents(events: successSequence(action: action, time: time),
                 file: file,
                 line: line)
  }

  func verifyErrorSequence<A: Equatable>(action: A,
                                         error: Error,
                                         time: TestTime = 0,
                                         file: StaticString = #file,
                                         line: UInt = #line) where Element == ActionState<A> {

    verifyEvents(events: errorSequence(action: action, error: error, time: time),
                 file: file,
                 line: line)
  }

  func verifySuccessSequenceCompleted<A: Equatable>(action: A,
                                                    time: TestTime = 0,
                                                    file: StaticString = #file,
                                                    line: UInt = #line)
    where Element == ActionState<A> {
    verifyEvents(events: successSequenceCompleted(action: action, time: time),
                 file: file,
                 line: line)
  }

  func verifyErrorSequenceCompleted<A: Equatable>(action: A,
                                                  error: Error,
                                                  time: TestTime = 0,
                                                  file: StaticString = #file,
                                                  line: UInt = #line)
    where Element == ActionState<A> {
    verifyEvents(events: errorSequenceCompleted(action: action, error: error, time: time),
                 file: file,
                 line: line)
  }

  func verifyCancelled<A: Equatable>(action: A,
                                     time: TestTime = 0,
                                     file: StaticString = #file,
                                     line: UInt = #line) where Element == ActionState<A> {
    verifyEvents(events: cancelled(action: action, time: time),
                 file: file,
                 line: line)
  }

  func verifyEvents<A: Equatable>(events: [TestStateRecorded<A>],
                                  file: StaticString = #file,
                                  line: UInt = #line) where Element == ActionState<A> {
    guard self.events.count == events.count else {
      failEvents(events: events, file: file, line: line)
      return
    }
    
    for event in self.events {
      var hasPair = false
      for anotherEvent in events where anotherEvent == event {
          hasPair = true
          break
      }
      guard hasPair == true else {
        failEvents(events: events, file: file, line: line)
        return
      }
    }
  }

  func failEvents<A: Equatable>(events: [TestStateRecorded<A>],
                                file: StaticString = #file,
                                line: UInt = #line) where Element == ActionState<A> {
    XCTFail("\(self.events.debugDescription) not equal to expected \(events.debugDescription)",
      file: file, line: line)
  }
  
  // MARK: ActionState sequences stub
  func cancelled<A: Equatable>(action: A,
                               time: TestTime = 0)
    -> [TestStateRecorded<A>] {
      return [
        next(time, ActionState.error(action, JanetError.cancelled))
      ]
  }

  func successSequence<A: Equatable>(action: A,
                                     time: TestTime = 0)
    -> [TestStateRecorded<A>] {
      return [
        next(time, ActionState.start(action)),
        next(time, ActionState.progress(action, 0.01)),
        next(time, ActionState.progress(action, 0.99)),
        next(time, ActionState.success(action))
      ]
  }

  func errorSequence<A: Equatable>(action: A,
                                   error: Error,
                                   time: TestTime = 0) -> [TestStateRecorded<A>] {
    return [
      next(time, ActionState.start(action)),
      next(time, ActionState.progress(action, 0.01)),
      next(time, ActionState.progress(action, 0.99)),
      next(time, ActionState.error(action, error))
    ]
  }

  func successSequenceCompleted<A: Equatable>(action: A,
                                              time: TestTime = 0) -> [TestStateRecorded<A>] {
    let events: [TestStateRecorded<A>]  = successSequence(action: action, time: time)
    let event = completed(time, ActionState<A>.self)
    return events + [event]
  }

  func errorSequenceCompleted<A: Equatable>(action: A,
                                            error: Error,
                                            time: TestTime = 0) -> [TestStateRecorded<A>] {
    let events = errorSequence(action: action, error: error, time: time)
    let event = completed(time, ActionState<A>.self)
    return events + [event]
  }
}
