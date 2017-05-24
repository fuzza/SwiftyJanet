import Foundation

public enum JanetError: Error {
  case actionRoutingError
  case serviceLookupError
  case serviceError
  case cancelled
}
