//
//  MatrixPositionLinearizationRoundTripTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class MatrixPositionLinearizationRoundTripTests: XCTestCase {
  
  // ------------------------------------------------------------------------ //
  // MARK: Test Management
  // ------------------------------------------------------------------------ //
  
  override func setUp() {
    super.setUp()
    self.continueAfterFailure = false
  }
  
  override func tearDown() {
    super.tearDown()
    self.continueAfterFailure = true
  }

  // ------------------------------------------------------------------------ //
  // MARK: Test Support
  // ------------------------------------------------------------------------ //

  internal func validateLPLRoundTrip<Matrix:MatrixProtocol>(
    forMatrix matrix: Matrix.Type) {
    for origin in matrix.linearizedScalarIndexRange {
      let position = matrix.matrixPosition(
        forLinearizedScalarIndex: origin
      )
      XCTAssertTrue(position.isValid)
      let destination = matrix.linearizedScalarIndex(
        forMatrixPosition: position
      )
      XCTAssertEqual(
        origin,
        destination,
        "LPL round-trip failed for `\(String(reflecting: matrix))`: \(origin) -> \(position.description) -> \(destination)!"
      )
    }
  }

  internal func validatePLPRoundTrip<Matrix:MatrixProtocol>(
    forMatrix matrix: Matrix.Type) {
    for origin in matrix.matrixPositions {
      let linearizedScalarIndex = matrix.linearizedScalarIndex(
        forMatrixPosition: origin
      )
      let destination = matrix.matrixPosition(
        forLinearizedScalarIndex: linearizedScalarIndex
      )
      XCTAssertEqual(
        origin,
        destination,
        "PLP round-trip failed for `\(String(reflecting: matrix))`: \(origin.description) -> \(linearizedScalarIndex) -> \(destination.description)!"
      )
    }
  }
  
  internal func validateRoundTrips<Matrix:MatrixProtocol>(forMatrix matrix: Matrix.Type) {
    self.validateLPLRoundTrip(
      forMatrix: matrix
    )
    self.validatePLPRoundTrip(
      forMatrix: matrix
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: (2, _) Round Trips
  // ------------------------------------------------------------------------ //
  
  func testMatrix2x2RoundTrips() {
    self.validateRoundTrips(
      forMatrix: Matrix2x2<Double>.self
    )
    self.validateRoundTrips(
      forMatrix: Matrix2x2<Float>.self
    )
  }
  
  func testMatrix2x3RoundTrip() {
    self.validateRoundTrips(
      forMatrix: Matrix2x3<Double>.self
    )
    self.validateRoundTrips(
      forMatrix: Matrix2x3<Float>.self
    )
  }
  
  func testMatrix2x4RoundTrip() {
    self.validateRoundTrips(
      forMatrix: Matrix2x4<Double>.self
    )
    self.validateRoundTrips(
      forMatrix: Matrix2x4<Float>.self
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: (3, _) Round Trips
  // ------------------------------------------------------------------------ //
  
  func testMatrix3x2RoundTrips() {
    self.validateRoundTrips(
      forMatrix: Matrix3x2<Double>.self
    )
    self.validateRoundTrips(
      forMatrix: Matrix3x2<Float>.self
    )
  }
  
  func testMatrix3x3RoundTrip() {
    self.validateRoundTrips(
      forMatrix: Matrix3x3<Double>.self
    )
    self.validateRoundTrips(
      forMatrix: Matrix3x3<Float>.self
    )
  }
  
  func testMatrix3x4RoundTrip() {
    self.validateRoundTrips(
      forMatrix: Matrix3x4<Double>.self
    )
    self.validateRoundTrips(
      forMatrix: Matrix3x4<Float>.self
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: (4, _) Round Trips
  // ------------------------------------------------------------------------ //
  
  func testMatrix4x2RoundTrips() {
    self.validateRoundTrips(
      forMatrix: Matrix4x2<Double>.self
    )
    self.validateRoundTrips(
      forMatrix: Matrix4x2<Float>.self
    )
  }
  
  func testMatrix4x3RoundTrip() {
    self.validateRoundTrips(
      forMatrix: Matrix4x3<Double>.self
    )
    self.validateRoundTrips(
      forMatrix: Matrix4x3<Float>.self
    )
  }
  
  func testMatrix4x4RoundTrip() {
    self.validateRoundTrips(
      forMatrix: Matrix4x4<Double>.self
    )
    self.validateRoundTrips(
      forMatrix: Matrix4x4<Float>.self
    )
  }

}
