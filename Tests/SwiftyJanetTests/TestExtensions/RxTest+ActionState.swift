import SwiftyJanet
import RxTest
import Foundation

extension TestableObserver {

  // MARK: Assertions

  func verifySuccessSequence<A>(action: A,
                                             time: TestTime = 0,
                                             file: StaticString = #file,
                                             line: UInt = #line) where Element == ActionState<A> {
    verifyEvents(events: successSequence(action: action, time: time),
                 file: file,
                 line: line)
  }

  func verifyErrorSequence<A>(action: A,
                                           error: Error,
                                           time: TestTime = 0,
                                           file: StaticString = #file,
                                           line: UInt = #line) where Element == ActionState<A> {

    verifyEvents(events: errorSequence(action: action, error: error, time: time),
                 file: file,
                 line: line)
  }

  func verifySuccessSequenceCompleted<A>(action: A,
                                                      time: TestTime = 0,
                                                      file: StaticString = #file,
                                                      line: UInt = #line)
    where Element == ActionState<A> {
    verifyEvents(events: successSequenceCompleted(action: action, time: time),
                 file: file,
                 line: line)
  }

  func verifyErrorSequenceCompleted<A>(action: A,
                                                    error: Error,
                                                    time: TestTime = 0,
                                                    file: StaticString = #file,
                                                    line: UInt = #line)
    where Element == ActionState<A> {
    verifyEvents(events: errorSequenceCompleted(action: action, error: error, time: time),
                 file: file,
                 line: line)
  }

  func verifyCancelled<A>(action: A,
                                       time: TestTime = 0,
                                       file: StaticString = #file,
                                       line: UInt = #line) where Element == ActionState<A> {
    verifyEvents(events: cancelled(action: action, time: time),
                 file: file,
                 line: line)
  }

  func verifyEvents<A>(events: [TestStateRecorded<A>],
                                    file: StaticString = #file,
                                    line: UInt = #line) where Element == ActionState<A> {
    XCTAssertEqual(self.events,
                   events,
                   file: file,
                   line: line)
  }

  // MARK: ActionState sequences stub

  func cancelled<A>(action: A,
                                 time: TestTime = 0)
    -> [TestStateRecorded<A>] {
      return [
        next(time, ActionState.error(action, JanetError.cancelled))
      ]
  }

  func successSequence<A>(action: A,
                                       time: TestTime = 0)
    -> [TestStateRecorded<A>] {
      return [
        next(time, ActionState.start(action)),
        next(time, ActionState.progress(action, 0.01)),
        next(time, ActionState.progress(action, 0.99)),
        next(time, ActionState.success(action))
      ]
  }

  func errorSequence<A>(action: A,
                                     error: Error,
                                     time: TestTime = 0) -> [TestStateRecorded<A>] {
    return [
      next(time, ActionState.start(action)),
      next(time, ActionState.progress(action, 0.01)),
      next(time, ActionState.progress(action, 0.99)),
      next(time, ActionState.error(action, error))
    ]
  }

  func successSequenceCompleted<A>(action: A,
                                                time: TestTime = 0) -> [TestStateRecorded<A>] {
    let events: [TestStateRecorded<A>]  = successSequence(action: action, time: time)
    let event = completed(time, ActionState<A>.self)
    return events + [event]
  }

  func errorSequenceCompleted<A>(action: A,
                                              error: Error,
                                              time: TestTime = 0) -> [TestStateRecorded<A>] {
    let events = errorSequence(action: action, error: error, time: time)
    let event = completed(time, ActionState<A>.self)
    return events + [event]
  }
}
