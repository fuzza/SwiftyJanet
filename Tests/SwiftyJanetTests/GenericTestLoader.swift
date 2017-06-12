import XCTest

@objc
class GenericTestLoader: NSObject, XCTestObservation {
  override init() {
    super.init()
    XCTestObservationCenter.shared().addTestObserver(self)
  }
  
  func testBundleWillStart(_ testBundle: Bundle) {
    genericTests().forEach { testClass in
      let testCase = XCTestSuite(forTestCaseClass: testClass)
      testCase.run()
    }
  }
  
  func genericTests() -> [Swift.AnyClass] {
    return [
      JanetTestsSend.self,
      JanetTestsCancel.self,
      JanetTestsSendDeferred.self,
      JanetTestsSubclassing.self
    ]
  }
}
