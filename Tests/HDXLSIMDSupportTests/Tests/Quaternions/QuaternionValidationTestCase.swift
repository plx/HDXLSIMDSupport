import Foundation
import XCTest
import simd

@testable import HDXLSIMDSupport

class QuaternionValidationTestCase: ValidationTestCase {
  var probeCoordinates: ClosedRange<Int> {
    return -2...2
  }
  
  typealias ProbeTuple = Homogeneous4<Int>
  
  var probeTuples: AsyncStream<ProbeTuple> {
    return arity4Power(of: probeCoordinates)
  }
  
  var nonZeroProbeTuples: AsyncStream<ProbeTuple> {
    return nonZeroArity4Power(of: probeCoordinates)
  }
}
