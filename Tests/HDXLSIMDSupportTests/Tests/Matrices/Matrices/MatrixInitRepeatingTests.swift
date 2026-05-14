//
//  MatrixInitRepeatingTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

/// Exercises `MatrixProtocol.init(repeating:)` across the native, storage, and
/// wrapper layers for `Float16`, `Float`, and `Double`.
///
/// The protocol contract says `init(repeating: s)` "constructs a matrix with
/// `scalar` inserted into *all entries*" — not just the diagonal. The
/// half-precision conformances originally delegated to `init(diagonal:)`, which
/// silently produced a diagonal-only matrix with zeros off-diagonal; these
/// tests would fail under that implementation.
class MatrixInitRepeatingTests: XCTestCase {

  // ------------------------------------------------------------------------ //
  // MARK: Helper
  // ------------------------------------------------------------------------ //

  /// Builds `Matrix(repeating: scalar)` and asserts every linearized scalar
  /// equals `scalar`. A diagonal-only result fails on every off-diagonal slot.
  internal func validateInitRepeating<Matrix:MatrixProtocol>(
    forMatrix matrix: Matrix.Type,
    scalar: Matrix.Scalar,
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    let populated = Matrix(repeating: scalar)
    let scalars = populated.linearizedScalars
    XCTAssertEqual(
      scalars.count,
      Matrix.scalarCount,
      "`\(String(reflecting: matrix))`: linearizedScalars length should match scalarCount.",
      file: file,
      line: line
    )
    for (index, value) in scalars.enumerated() {
      XCTAssertEqual(
        value,
        scalar,
        "`\(String(reflecting: matrix))`: entry \(index) was \(value), expected \(scalar) (init(repeating:) must fill every entry).",
        file: file,
        line: line
      )
    }
  }

  /// Runs `validateInitRepeating` against three representative scalar values
  /// (including a negative and zero) for every layer of a given shape.
  internal func validateInitRepeatingAcrossLayers<
    Native:MatrixProtocol,
    Storage:MatrixProtocol,
    Wrapper:MatrixProtocol
  >(
    native: Native.Type,
    storage: Storage.Type,
    wrapper: Wrapper.Type,
    scalars: [Native.Scalar],
    file: StaticString = #filePath,
    line: UInt = #line
  ) where
    Native.Scalar == Storage.Scalar,
    Storage.Scalar == Wrapper.Scalar
  {
    for scalar in scalars {
      validateInitRepeating(
        forMatrix: native,
        scalar: scalar,
        file: file,
        line: line
      )
      validateInitRepeating(
        forMatrix: storage,
        scalar: scalar as Storage.Scalar,
        file: file,
        line: line
      )
      validateInitRepeating(
        forMatrix: wrapper,
        scalar: scalar as Wrapper.Scalar,
        file: file,
        line: line
      )
    }
  }

  // ------------------------------------------------------------------------ //
  // MARK: Float16
  // ------------------------------------------------------------------------ //

  private let halfScalars: [Float16] = [-1.5, 0, 2.25]

  func testHalfMatrix2x2InitRepeating() {
    validateInitRepeatingAcrossLayers(
      native: simd_half2x2.self,
      storage: HalfMatrix2x2Storage.self,
      wrapper: Matrix2x2<Float16>.self,
      scalars: halfScalars
    )
  }

  func testHalfMatrix2x3InitRepeating() {
    validateInitRepeatingAcrossLayers(
      native: simd_half2x3.self,
      storage: HalfMatrix2x3Storage.self,
      wrapper: Matrix2x3<Float16>.self,
      scalars: halfScalars
    )
  }

  func testHalfMatrix2x4InitRepeating() {
    validateInitRepeatingAcrossLayers(
      native: simd_half2x4.self,
      storage: HalfMatrix2x4Storage.self,
      wrapper: Matrix2x4<Float16>.self,
      scalars: halfScalars
    )
  }

  func testHalfMatrix3x2InitRepeating() {
    validateInitRepeatingAcrossLayers(
      native: simd_half3x2.self,
      storage: HalfMatrix3x2Storage.self,
      wrapper: Matrix3x2<Float16>.self,
      scalars: halfScalars
    )
  }

  func testHalfMatrix3x3InitRepeating() {
    validateInitRepeatingAcrossLayers(
      native: simd_half3x3.self,
      storage: HalfMatrix3x3Storage.self,
      wrapper: Matrix3x3<Float16>.self,
      scalars: halfScalars
    )
  }

  func testHalfMatrix3x4InitRepeating() {
    validateInitRepeatingAcrossLayers(
      native: simd_half3x4.self,
      storage: HalfMatrix3x4Storage.self,
      wrapper: Matrix3x4<Float16>.self,
      scalars: halfScalars
    )
  }

  func testHalfMatrix4x2InitRepeating() {
    validateInitRepeatingAcrossLayers(
      native: simd_half4x2.self,
      storage: HalfMatrix4x2Storage.self,
      wrapper: Matrix4x2<Float16>.self,
      scalars: halfScalars
    )
  }

  func testHalfMatrix4x3InitRepeating() {
    validateInitRepeatingAcrossLayers(
      native: simd_half4x3.self,
      storage: HalfMatrix4x3Storage.self,
      wrapper: Matrix4x3<Float16>.self,
      scalars: halfScalars
    )
  }

  func testHalfMatrix4x4InitRepeating() {
    validateInitRepeatingAcrossLayers(
      native: simd_half4x4.self,
      storage: HalfMatrix4x4Storage.self,
      wrapper: Matrix4x4<Float16>.self,
      scalars: halfScalars
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: Float (baseline — confirms the contract is encoded the same way)
  // ------------------------------------------------------------------------ //

  private let floatScalars: [Float] = [-1.5, 0, 2.25]

  func testFloatMatrix2x2InitRepeating() {
    validateInitRepeatingAcrossLayers(
      native: simd_float2x2.self,
      storage: FloatMatrix2x2Storage.self,
      wrapper: Matrix2x2<Float>.self,
      scalars: floatScalars
    )
  }

  func testFloatMatrix3x3InitRepeating() {
    validateInitRepeatingAcrossLayers(
      native: simd_float3x3.self,
      storage: FloatMatrix3x3Storage.self,
      wrapper: Matrix3x3<Float>.self,
      scalars: floatScalars
    )
  }

  func testFloatMatrix4x4InitRepeating() {
    validateInitRepeatingAcrossLayers(
      native: simd_float4x4.self,
      storage: FloatMatrix4x4Storage.self,
      wrapper: Matrix4x4<Float>.self,
      scalars: floatScalars
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: Double (baseline)
  // ------------------------------------------------------------------------ //

  private let doubleScalars: [Double] = [-1.5, 0, 2.25]

  func testDoubleMatrix2x2InitRepeating() {
    validateInitRepeatingAcrossLayers(
      native: simd_double2x2.self,
      storage: DoubleMatrix2x2Storage.self,
      wrapper: Matrix2x2<Double>.self,
      scalars: doubleScalars
    )
  }

  func testDoubleMatrix3x3InitRepeating() {
    validateInitRepeatingAcrossLayers(
      native: simd_double3x3.self,
      storage: DoubleMatrix3x3Storage.self,
      wrapper: Matrix3x3<Double>.self,
      scalars: doubleScalars
    )
  }

  func testDoubleMatrix4x4InitRepeating() {
    validateInitRepeatingAcrossLayers(
      native: simd_double4x4.self,
      storage: DoubleMatrix4x4Storage.self,
      wrapper: Matrix4x4<Double>.self,
      scalars: doubleScalars
    )
  }

}
