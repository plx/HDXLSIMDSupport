import Foundation
import XCTest

class ValidationTestCase: XCTestCase {
  
  enum FailureReaction {
    case haltImmediately
    case continueExecution
    
    var continueAfterFailure: Bool {
      switch self {
      case .continueExecution:
        true
      case .haltImmediately:
        false
      }
    }
    
    init(continueAfterFailure: Bool) {
      switch continueAfterFailure {
      case true:
        self = .continueExecution
      case false:
        self = .haltImmediately
      }
    }
  }
  
  var failureReaction: FailureReaction {
    get {
      FailureReaction(continueAfterFailure: continueAfterFailure)
    }
    set {
      continueAfterFailure = newValue.continueAfterFailure
    }
  }
  
  func withFailureReaction<R>(
    _ failureReaction: FailureReaction,
    _ work: () async throws -> R
  ) async rethrows -> R {
    let previousReaction = self.failureReaction
    self.failureReaction = failureReaction
    defer { self.failureReaction = previousReaction }
    return try await work()
  }
  
}
