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

/// Validates a wrapped `(matrix, vector) -> vector` operation
/// (matrix-vector multiplication). The wrapper and native both return the
/// same SIMD vector type (the vector layer is shared across the chain).
func validateMatrixVectorEquivalence<Wrapper, Native, InVec, OutVec, Scalar>(
  _ name: String,
  matrices: [[[Scalar]]],
  vectors: [[Scalar]],
  epsilon: Scalar,
  buildInVec: ([Scalar]) -> InVec,
  wrapped: (Wrapper, InVec) -> OutVec,
  native: (Native, InVec) -> OutVec,
  file: StaticString = #filePath,
  line: UInt = #line
) where
  Wrapper: NativeSIMDRepresentable,
  Wrapper.NativeSIMDRepresentation == Native,
  Wrapper: MatrixProtocol,
  Wrapper.Scalar == Scalar,
  OutVec: LInfinityDistanceMeasureable,
  OutVec.LInfinityDistance == Scalar,
  Scalar: SIMDScalar & BinaryFloatingPoint
{
  for probe in matrices {
    for vector in vectors {
      let wrappedM = Wrapper(scalars: probe)
      let nativeM = wrappedM.nativeSIMDRepresentation
      let v: InVec = buildInVec(vector)
      let wrappedResult = wrapped(wrappedM, v)
      let nativeResult = native(nativeM, v)
      let distance = wrappedResult.lInfinityDistance(to: nativeResult)
      XCTAssertLessThan(
        distance,
        epsilon,
        "[\(name)] L∞ distance \(distance) >= \(epsilon) for matrix=\(probe), vector=\(vector)",
        file: file,
        line: line
      )
    }
  }
}

/// Validates a `linearCombination(of:weight:with:weight:)` operation. Sweeps
/// over (first × other × firstWeight × otherWeight).
func validateLinearCombinationEquivalence<Wrapper, Native, Scalar>(
  _ name: String,
  firsts: [[[Scalar]]],
  others: [[[Scalar]]],
  firstWeights: [Scalar],
  otherWeights: [Scalar],
  epsilon: Wrapper.LInfinityDistance,
  wrapped: (Wrapper, Scalar, Wrapper, Scalar) -> Wrapper,
  native: (Native, Scalar, Native, Scalar) -> Native,
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
  for first in firsts {
    for other in others {
      for fw in firstWeights {
        for ow in otherWeights {
          let wrappedFirst = Wrapper(scalars: first)
          let wrappedOther = Wrapper(scalars: other)
          let nativeFirst = wrappedFirst.nativeSIMDRepresentation
          let nativeOther = wrappedOther.nativeSIMDRepresentation
          let wrappedResult = wrapped(wrappedFirst, fw, wrappedOther, ow)
          let nativeResult = native(nativeFirst, fw, nativeOther, ow)
          let nativeAsWrapped = Wrapper(nativeSIMDRepresentation: nativeResult)
          let distance = wrappedResult.lInfinityDistance(to: nativeAsWrapped)
          XCTAssertLessThan(
            distance,
            epsilon,
            "[\(name)] L∞ distance \(distance) >= \(epsilon) for first=\(first), firstWeight=\(fw), other=\(other), otherWeight=\(ow)",
            file: file,
            line: line
          )
        }
      }
    }
  }
}

// MARK: - Float-widened cross-validation for half-3-row shapes
//
// The simd_halfNx3 result-producing routines are miscomputed by the macOS 26
// overlay, so the validation suites for shapes whose result is half-3-row
// (negation, +/-, FMA/FMS, scalar mul/div on 2x3 / 3x3 / 4x3 half) can't use
// the C bridge as ground truth — our own pure-Swift implementation IS the
// formula.
//
// These helpers cross-validate by widening Float16 probes to Float, running
// the operation in single precision, narrowing back, and comparing against
// the wrapper's half-precision answer. The epsilon is necessarily loose
// (~5e-2) — Float16 has roughly three significant decimal digits.

/// Float-widened cross-validation for a unary operation that produces a
/// half-3-row matrix. Compares the wrapper's half-precision result against
/// the same operation performed in single precision and narrowed back.
func validateHalfThreeRowUnaryViaFloatWidening<HalfWrapper, FloatWrapper>(
  _ name: String,
  probes: [[[Float16]]],
  epsilon: Float16,
  halfOp: (HalfWrapper) -> HalfWrapper,
  floatOp: (FloatWrapper) -> FloatWrapper,
  file: StaticString = #filePath,
  line: UInt = #line
) where
  HalfWrapper: MatrixProtocol,
  HalfWrapper.Scalar == Float16,
  HalfWrapper: LInfinityDistanceMeasureable,
  HalfWrapper.LInfinityDistance == Float16,
  FloatWrapper: MatrixProtocol,
  FloatWrapper.Scalar == Float
{
  for probe in probes {
    let floatProbe: [[Float]] = probe.map { $0.map { Float($0) } }
    let halfInput = HalfWrapper(scalars: probe)
    let floatInput = FloatWrapper(scalars: floatProbe)
    let halfResult = halfOp(halfInput)
    let floatResult = floatOp(floatInput)
    let narrowedFloatLinearized = floatResult.linearizedScalars.map { Float16($0) }
    let halfReference = HalfWrapper(linearizedScalars: narrowedFloatLinearized)
    let distance = halfResult.lInfinityDistance(to: halfReference)
    XCTAssertLessThan(
      distance,
      epsilon,
      "[\(name)] L∞ distance \(distance) >= \(epsilon) for probe \(probe). half=\(halfResult), narrowed-float=\(halfReference)",
      file: file,
      line: line
    )
  }
}

/// Float-widened cross-validation for a binary operation that produces a
/// half-3-row matrix.
func validateHalfThreeRowBinaryViaFloatWidening<HalfWrapper, FloatWrapper>(
  _ name: String,
  lhses: [[[Float16]]],
  rhses: [[[Float16]]],
  epsilon: Float16,
  halfOp: (HalfWrapper, HalfWrapper) -> HalfWrapper,
  floatOp: (FloatWrapper, FloatWrapper) -> FloatWrapper,
  file: StaticString = #filePath,
  line: UInt = #line
) where
  HalfWrapper: MatrixProtocol,
  HalfWrapper.Scalar == Float16,
  HalfWrapper: LInfinityDistanceMeasureable,
  HalfWrapper.LInfinityDistance == Float16,
  FloatWrapper: MatrixProtocol,
  FloatWrapper.Scalar == Float
{
  for lhs in lhses {
    for rhs in rhses {
      let floatLhs: [[Float]] = lhs.map { $0.map { Float($0) } }
      let floatRhs: [[Float]] = rhs.map { $0.map { Float($0) } }
      let halfL = HalfWrapper(scalars: lhs)
      let halfR = HalfWrapper(scalars: rhs)
      let floatL = FloatWrapper(scalars: floatLhs)
      let floatR = FloatWrapper(scalars: floatRhs)
      let halfResult = halfOp(halfL, halfR)
      let floatResult = floatOp(floatL, floatR)
      let narrowedFloatLinearized = floatResult.linearizedScalars.map { Float16($0) }
      let halfReference = HalfWrapper(linearizedScalars: narrowedFloatLinearized)
      let distance = halfResult.lInfinityDistance(to: halfReference)
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

/// Float-widened cross-validation for a `(matrix, scalar) -> matrix` operation
/// that produces a half-3-row matrix.
func validateHalfThreeRowMatrixScalarViaFloatWidening<HalfWrapper, FloatWrapper>(
  _ name: String,
  matrices: [[[Float16]]],
  scalars: [Float16],
  epsilon: Float16,
  halfOp: (HalfWrapper, Float16) -> HalfWrapper,
  floatOp: (FloatWrapper, Float) -> FloatWrapper,
  file: StaticString = #filePath,
  line: UInt = #line
) where
  HalfWrapper: MatrixProtocol,
  HalfWrapper.Scalar == Float16,
  HalfWrapper: LInfinityDistanceMeasureable,
  HalfWrapper.LInfinityDistance == Float16,
  FloatWrapper: MatrixProtocol,
  FloatWrapper.Scalar == Float
{
  for probe in matrices {
    for s in scalars {
      let floatProbe: [[Float]] = probe.map { $0.map { Float($0) } }
      let halfM = HalfWrapper(scalars: probe)
      let floatM = FloatWrapper(scalars: floatProbe)
      let halfResult = halfOp(halfM, s)
      let floatResult = floatOp(floatM, Float(s))
      let narrowedFloatLinearized = floatResult.linearizedScalars.map { Float16($0) }
      let halfReference = HalfWrapper(linearizedScalars: narrowedFloatLinearized)
      let distance = halfResult.lInfinityDistance(to: halfReference)
      XCTAssertLessThan(
        distance,
        epsilon,
        "[\(name)] L∞ distance \(distance) >= \(epsilon) for matrix=\(probe), scalar=\(s)",
        file: file,
        line: line
      )
    }
  }
}

/// Float-widened cross-validation for `linearCombination(of:weight:with:weight:)`
/// on a half-3-row matrix.
func validateHalfThreeRowLinearCombinationViaFloatWidening<HalfWrapper, FloatWrapper>(
  _ name: String,
  firsts: [[[Float16]]],
  others: [[[Float16]]],
  firstWeights: [Float16],
  otherWeights: [Float16],
  epsilon: Float16,
  halfOp: (HalfWrapper, Float16, HalfWrapper, Float16) -> HalfWrapper,
  floatOp: (FloatWrapper, Float, FloatWrapper, Float) -> FloatWrapper,
  file: StaticString = #filePath,
  line: UInt = #line
) where
  HalfWrapper: MatrixProtocol,
  HalfWrapper.Scalar == Float16,
  HalfWrapper: LInfinityDistanceMeasureable,
  HalfWrapper.LInfinityDistance == Float16,
  FloatWrapper: MatrixProtocol,
  FloatWrapper.Scalar == Float
{
  for first in firsts {
    for other in others {
      for fw in firstWeights {
        for ow in otherWeights {
          let floatFirst: [[Float]] = first.map { $0.map { Float($0) } }
          let floatOther: [[Float]] = other.map { $0.map { Float($0) } }
          let halfFirst = HalfWrapper(scalars: first)
          let halfOther = HalfWrapper(scalars: other)
          let floatFirstW = FloatWrapper(scalars: floatFirst)
          let floatOtherW = FloatWrapper(scalars: floatOther)
          let halfResult = halfOp(halfFirst, fw, halfOther, ow)
          let floatResult = floatOp(floatFirstW, Float(fw), floatOtherW, Float(ow))
          let narrowedFloatLinearized = floatResult.linearizedScalars.map { Float16($0) }
          let halfReference = HalfWrapper(linearizedScalars: narrowedFloatLinearized)
          let distance = halfResult.lInfinityDistance(to: halfReference)
          XCTAssertLessThan(
            distance,
            epsilon,
            "[\(name)] L∞ distance \(distance) >= \(epsilon) for first=\(first), firstWeight=\(fw), other=\(other), otherWeight=\(ow)",
            file: file,
            line: line
          )
        }
      }
    }
  }
}

/// Float-widened cross-validation for an `(M, M, scalar) -> M` operation
/// that produces a half-3-row matrix (FMA / FMS).
func validateHalfThreeRowBinaryScalarViaFloatWidening<HalfWrapper, FloatWrapper>(
  _ name: String,
  lhses: [[[Float16]]],
  rhses: [[[Float16]]],
  scalars: [Float16],
  epsilon: Float16,
  halfOp: (HalfWrapper, HalfWrapper, Float16) -> HalfWrapper,
  floatOp: (FloatWrapper, FloatWrapper, Float) -> FloatWrapper,
  file: StaticString = #filePath,
  line: UInt = #line
) where
  HalfWrapper: MatrixProtocol,
  HalfWrapper.Scalar == Float16,
  HalfWrapper: LInfinityDistanceMeasureable,
  HalfWrapper.LInfinityDistance == Float16,
  FloatWrapper: MatrixProtocol,
  FloatWrapper.Scalar == Float
{
  for lhs in lhses {
    for rhs in rhses {
      for s in scalars {
        let floatLhs: [[Float]] = lhs.map { $0.map { Float($0) } }
        let floatRhs: [[Float]] = rhs.map { $0.map { Float($0) } }
        let halfL = HalfWrapper(scalars: lhs)
        let halfR = HalfWrapper(scalars: rhs)
        let floatL = FloatWrapper(scalars: floatLhs)
        let floatR = FloatWrapper(scalars: floatRhs)
        let halfResult = halfOp(halfL, halfR, s)
        let floatResult = floatOp(floatL, floatR, Float(s))
        let narrowedFloatLinearized = floatResult.linearizedScalars.map { Float16($0) }
        let halfReference = HalfWrapper(linearizedScalars: narrowedFloatLinearized)
        let distance = halfResult.lInfinityDistance(to: halfReference)
        XCTAssertLessThan(
          distance,
          epsilon,
          "[\(name)] L∞ distance \(distance) >= \(epsilon) for lhs=\(lhs), rhs=\(rhs), scalar=\(s)",
          file: file,
          line: line
        )
      }
    }
  }
}

/// Validates a wrapped binary operation that produces a *different*-shape
/// result. The wrapper, the rhs, and the result all have their own native /
/// wrapper / scalar types; only the scalar type is required to match across.
func validateHeterogeneousBinaryEquivalence<
  LhsWrapper, LhsNative,
  RhsWrapper, RhsNative,
  ResultWrapper, ResultNative,
  Scalar
>(
  _ name: String,
  lhses: [[[Scalar]]],
  rhses: [[[Scalar]]],
  epsilon: ResultWrapper.LInfinityDistance,
  wrapped: (LhsWrapper, RhsWrapper) -> ResultWrapper,
  native: (LhsNative, RhsNative) -> ResultNative,
  file: StaticString = #filePath,
  line: UInt = #line
) where
  LhsWrapper: NativeSIMDRepresentable,
  LhsWrapper.NativeSIMDRepresentation == LhsNative,
  LhsWrapper: MatrixProtocol,
  LhsWrapper.Scalar == Scalar,
  RhsWrapper: NativeSIMDRepresentable,
  RhsWrapper.NativeSIMDRepresentation == RhsNative,
  RhsWrapper: MatrixProtocol,
  RhsWrapper.Scalar == Scalar,
  ResultWrapper: NativeSIMDRepresentable,
  ResultWrapper.NativeSIMDRepresentation == ResultNative,
  ResultWrapper: MatrixProtocol,
  ResultWrapper.Scalar == Scalar,
  ResultWrapper: LInfinityDistanceMeasureable,
  ResultWrapper.LInfinityDistance: BinaryFloatingPoint,
  Scalar: SIMDScalar & BinaryFloatingPoint
{
  for lhs in lhses {
    for rhs in rhses {
      let wrappedLhs = LhsWrapper(scalars: lhs)
      let wrappedRhs = RhsWrapper(scalars: rhs)
      let nativeLhs = wrappedLhs.nativeSIMDRepresentation
      let nativeRhs = wrappedRhs.nativeSIMDRepresentation
      let wrappedResult = wrapped(wrappedLhs, wrappedRhs)
      let nativeResult = native(nativeLhs, nativeRhs)
      let nativeAsWrapped = ResultWrapper(nativeSIMDRepresentation: nativeResult)
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

/// Validates a wrapped `(matrix) -> Scalar` operation (e.g. `determinant`,
/// `componentwiseMagnitudeSquared`).
func validateUnaryToScalarEquivalence<Wrapper, Native, Scalar>(
  _ name: String,
  probes: [[[Scalar]]],
  epsilon: Scalar,
  wrapped: (Wrapper) -> Scalar,
  native: (Native) -> Scalar,
  file: StaticString = #filePath,
  line: UInt = #line
) where
  Wrapper: NativeSIMDRepresentable,
  Wrapper.NativeSIMDRepresentation == Native,
  Wrapper: MatrixProtocol,
  Wrapper.Scalar == Scalar,
  Scalar: SIMDScalar & BinaryFloatingPoint
{
  for probe in probes {
    let wrappedInput = Wrapper(scalars: probe)
    let nativeInput = wrappedInput.nativeSIMDRepresentation
    let wrappedResult = wrapped(wrappedInput)
    let nativeResult = native(nativeInput)
    let distance = abs(wrappedResult - nativeResult)
    XCTAssertLessThan(
      distance,
      epsilon,
      "[\(name)] |Δ| \(distance) >= \(epsilon) for probe \(probe). wrapped=\(wrappedResult), native=\(nativeResult)",
      file: file,
      line: line
    )
  }
}

/// Validates a wrapped `(matrix, matrix, scalar) -> Bool` operation
/// (e.g. `hasAlmostEqualElements`).
func validateBinaryToBoolEquivalence<Wrapper, Native, Scalar>(
  _ name: String,
  lhses: [[[Scalar]]],
  rhses: [[[Scalar]]],
  tolerances: [Scalar],
  wrapped: (Wrapper, Wrapper, Scalar) -> Bool,
  native: (Native, Native, Scalar) -> Bool,
  file: StaticString = #filePath,
  line: UInt = #line
) where
  Wrapper: NativeSIMDRepresentable,
  Wrapper.NativeSIMDRepresentation == Native,
  Wrapper: MatrixProtocol,
  Wrapper.Scalar == Scalar,
  Scalar: SIMDScalar & BinaryFloatingPoint
{
  for lhs in lhses {
    for rhs in rhses {
      for tolerance in tolerances {
        let wrappedL = Wrapper(scalars: lhs)
        let wrappedR = Wrapper(scalars: rhs)
        let nativeL = wrappedL.nativeSIMDRepresentation
        let nativeR = wrappedR.nativeSIMDRepresentation
        let wrappedResult = wrapped(wrappedL, wrappedR, tolerance)
        let nativeResult = native(nativeL, nativeR, tolerance)
        XCTAssertEqual(
          wrappedResult,
          nativeResult,
          "[\(name)] wrapped=\(wrappedResult) but native=\(nativeResult) for lhs=\(lhs), rhs=\(rhs), tolerance=\(tolerance)",
          file: file,
          line: line
        )
      }
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
