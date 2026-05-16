//
//  MatrixValidationHelpers.swift
//
//  Imported by macro-generated validation suites (XCTest-based). Each
//  generated method constructs probe matrices inline (as `[[Scalar]]`
//  arrays), then invokes one of these helpers which compares the
//  macro-generated wrapper output against a "ground truth" native-simd
//  computation.
//

import Foundation
import XCTest
import simd
@testable import HDXLSIMDSupport

/// Validates a wrapped unary operation against a native one across an array
/// of `[[Scalar]]` probe inputs.
func validateUnaryEquivalence<Wrapper, Native, Scalar>(
  _ name: String,
  probes: [[[Scalar]]],
  epsilon: Wrapper.LInfinityDistance,
  wrapped: (Wrapper) -> Wrapper,
  native: (Native) -> Native,
  file: StaticString = #filePath,
  line: UInt = #line
) where
  Wrapper: NativeSIMDRepresentable,
  Wrapper.NativeSIMDRepresentation == Native,
  Wrapper: MatrixProtocol,
  Wrapper.Scalar == Scalar,
  Wrapper: LInfinityDistanceMeasureable,
  Wrapper.LInfinityDistance: BinaryFloatingPoint,
  Scalar: SIMDScalar & BinaryFloatingPoint
{
  for probe in probes {
    let wrappedInput = Wrapper(scalars: probe)
    let nativeInput = wrappedInput.nativeSIMDRepresentation
    let wrappedResult = wrapped(wrappedInput)
    let nativeResult = native(nativeInput)
    let nativeAsWrapped = Wrapper(nativeSIMDRepresentation: nativeResult)
    let distance = wrappedResult.lInfinityDistance(to: nativeAsWrapped)
    XCTAssertLessThan(
      distance,
      epsilon,
      "[\(name)] L∞ distance \(distance) >= \(epsilon) for probe \(probe). wrapped=\(wrappedResult), native=\(nativeResult)",
      file: file,
      line: line
    )
  }
}

/// Validates a wrapped binary operation (same input shape, same output shape).
func validateBinaryEquivalence<Wrapper, Native, Scalar>(
  _ name: String,
  lhses: [[[Scalar]]],
  rhses: [[[Scalar]]],
  epsilon: Wrapper.LInfinityDistance,
  wrapped: (Wrapper, Wrapper) -> Wrapper,
  native: (Native, Native) -> Native,
  file: StaticString = #filePath,
  line: UInt = #line
) where
  Wrapper: NativeSIMDRepresentable,
  Wrapper.NativeSIMDRepresentation == Native,
  Wrapper: MatrixProtocol,
  Wrapper.Scalar == Scalar,
  Wrapper: LInfinityDistanceMeasureable,
  Wrapper.LInfinityDistance: BinaryFloatingPoint,
  Scalar: SIMDScalar & BinaryFloatingPoint
{
  for lhs in lhses {
    for rhs in rhses {
      let wrappedLHS = Wrapper(scalars: lhs)
      let wrappedRHS = Wrapper(scalars: rhs)
      let nativeLHS = wrappedLHS.nativeSIMDRepresentation
      let nativeRHS = wrappedRHS.nativeSIMDRepresentation
      let wrappedResult = wrapped(wrappedLHS, wrappedRHS)
      let nativeResult = native(nativeLHS, nativeRHS)
      let nativeAsWrapped = Wrapper(nativeSIMDRepresentation: nativeResult)
      let distance = wrappedResult.lInfinityDistance(to: nativeAsWrapped)
      XCTAssertLessThan(
        distance,
        epsilon,
        "[\(name)] L∞ distance \(distance) >= \(epsilon) for lhs=\(lhs), rhs=\(rhs)",
        file: file,
        line: line
      )
    }
  }
}

/// Validates a wrapped `(matrix, scalar) -> matrix` operation.
func validateMatrixScalarEquivalence<Wrapper, Native, Scalar>(
  _ name: String,
  matrices: [[[Scalar]]],
  scalars: [Scalar],
  epsilon: Wrapper.LInfinityDistance,
  wrapped: (Wrapper, Scalar) -> Wrapper,
  native: (Native, Scalar) -> Native,
  file: StaticString = #filePath,
  line: UInt = #line
) where
  Wrapper: NativeSIMDRepresentable,
  Wrapper.NativeSIMDRepresentation == Native,
  Wrapper: MatrixProtocol,
  Wrapper.Scalar == Scalar,
  Wrapper: LInfinityDistanceMeasureable,
  Wrapper.LInfinityDistance: BinaryFloatingPoint,
  Scalar: SIMDScalar & BinaryFloatingPoint
{
  for probe in matrices {
    for scalar in scalars {
      let wrappedM = Wrapper(scalars: probe)
      let nativeM = wrappedM.nativeSIMDRepresentation
      let wrappedResult = wrapped(wrappedM, scalar)
      let nativeResult = native(nativeM, scalar)
      let nativeAsWrapped = Wrapper(nativeSIMDRepresentation: nativeResult)
      let distance = wrappedResult.lInfinityDistance(to: nativeAsWrapped)
      XCTAssertLessThan(
        distance,
        epsilon,
        "[\(name)] L∞ distance \(distance) >= \(epsilon) for matrix=\(probe), scalar=\(scalar)",
        file: file,
        line: line
      )
    }
  }
}

/// Validates an `(M, M, scalar) -> M` operation (FMA / FMS).
func validateMatrixMatrixScalarEquivalence<Wrapper, Native, Scalar>(
  _ name: String,
  lhses: [[[Scalar]]],
  rhses: [[[Scalar]]],
  scalars: [Scalar],
  epsilon: Wrapper.LInfinityDistance,
  wrapped: (Wrapper, Wrapper, Scalar) -> Wrapper,
  native: (Native, Native, Scalar) -> Native,
  file: StaticString = #filePath,
  line: UInt = #line
) where
  Wrapper: NativeSIMDRepresentable,
  Wrapper.NativeSIMDRepresentation == Native,
  Wrapper: MatrixProtocol,
  Wrapper.Scalar == Scalar,
  Wrapper: LInfinityDistanceMeasureable,
  Wrapper.LInfinityDistance: BinaryFloatingPoint,
  Scalar: SIMDScalar & BinaryFloatingPoint
{
  for lhs in lhses {
    for rhs in rhses {
      for scalar in scalars {
        let wrappedL = Wrapper(scalars: lhs)
        let wrappedR = Wrapper(scalars: rhs)
        let nativeL = wrappedL.nativeSIMDRepresentation
        let nativeR = wrappedR.nativeSIMDRepresentation
        let wrappedResult = wrapped(wrappedL, wrappedR, scalar)
        let nativeResult = native(nativeL, nativeR, scalar)
        let nativeAsWrapped = Wrapper(nativeSIMDRepresentation: nativeResult)
        let distance = wrappedResult.lInfinityDistance(to: nativeAsWrapped)
        XCTAssertLessThan(
          distance,
          epsilon,
          "[\(name)] L∞ distance \(distance) >= \(epsilon) for lhs=\(lhs), rhs=\(rhs), scalar=\(scalar)",
          file: file,
          line: line
        )
      }
    }
  }
}
