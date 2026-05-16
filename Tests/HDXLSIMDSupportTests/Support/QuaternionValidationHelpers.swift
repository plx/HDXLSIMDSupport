//
//  QuaternionValidationHelpers.swift
//
//  Imported by macro-generated quaternion validation suites. Mirror of
//  `MatrixValidationHelpers` but typed against `QuaternionProtocol` rather
//  than `MatrixProtocol`. Each probe is a length-4 `[Scalar]` array shaped
//  as `[i, j, k, real]`.
//

import Foundation
import XCTest
import simd
@testable import HDXLSIMDSupport

@inlinable
func makeQuaternionWrapper<Wrapper: QuaternionProtocol>(
  _ type: Wrapper.Type,
  from probe: [Wrapper.Scalar]
) -> Wrapper {
  precondition(probe.count == 4)
  return Wrapper(i: probe[0], j: probe[1], k: probe[2], real: probe[3])
}

/// Validates a wrapped unary quaternion operation against a native one.
func validateQuaternionUnaryEquivalence<Wrapper, Native, Scalar>(
  _ name: String,
  probes: [[Scalar]],
  epsilon: Wrapper.LInfinityDistance,
  wrapped: (Wrapper) -> Wrapper,
  native: (Native) -> Native,
  file: StaticString = #filePath,
  line: UInt = #line
) where
  Wrapper: NativeSIMDRepresentable,
  Wrapper.NativeSIMDRepresentation == Native,
  Wrapper: QuaternionProtocol,
  Wrapper.Scalar == Scalar,
  Wrapper: LInfinityDistanceMeasureable,
  Wrapper.LInfinityDistance: BinaryFloatingPoint,
  Scalar: SIMDScalar & BinaryFloatingPoint
{
  for probe in probes {
    let wrappedInput: Wrapper = makeQuaternionWrapper(Wrapper.self, from: probe)
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

/// Validates a wrapped binary quaternion operation (same shape in/out).
func validateQuaternionBinaryEquivalence<Wrapper, Native, Scalar>(
  _ name: String,
  lhses: [[Scalar]],
  rhses: [[Scalar]],
  epsilon: Wrapper.LInfinityDistance,
  wrapped: (Wrapper, Wrapper) -> Wrapper,
  native: (Native, Native) -> Native,
  file: StaticString = #filePath,
  line: UInt = #line
) where
  Wrapper: NativeSIMDRepresentable,
  Wrapper.NativeSIMDRepresentation == Native,
  Wrapper: QuaternionProtocol,
  Wrapper.Scalar == Scalar,
  Wrapper: LInfinityDistanceMeasureable,
  Wrapper.LInfinityDistance: BinaryFloatingPoint,
  Scalar: SIMDScalar & BinaryFloatingPoint
{
  for lhs in lhses {
    for rhs in rhses {
      let wrappedL: Wrapper = makeQuaternionWrapper(Wrapper.self, from: lhs)
      let wrappedR: Wrapper = makeQuaternionWrapper(Wrapper.self, from: rhs)
      let nativeL = wrappedL.nativeSIMDRepresentation
      let nativeR = wrappedR.nativeSIMDRepresentation
      let wrappedResult = wrapped(wrappedL, wrappedR)
      let nativeResult = native(nativeL, nativeR)
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

/// Validates a wrapped `(quaternion, scalar) -> quaternion` operation.
func validateQuaternionScalarEquivalence<Wrapper, Native, Scalar>(
  _ name: String,
  probes: [[Scalar]],
  scalars: [Scalar],
  epsilon: Wrapper.LInfinityDistance,
  wrapped: (Wrapper, Scalar) -> Wrapper,
  native: (Native, Scalar) -> Native,
  file: StaticString = #filePath,
  line: UInt = #line
) where
  Wrapper: NativeSIMDRepresentable,
  Wrapper.NativeSIMDRepresentation == Native,
  Wrapper: QuaternionProtocol,
  Wrapper.Scalar == Scalar,
  Wrapper: LInfinityDistanceMeasureable,
  Wrapper.LInfinityDistance: BinaryFloatingPoint,
  Scalar: SIMDScalar & BinaryFloatingPoint
{
  for probe in probes {
    for scalar in scalars {
      let wrappedQ: Wrapper = makeQuaternionWrapper(Wrapper.self, from: probe)
      let nativeQ = wrappedQ.nativeSIMDRepresentation
      let wrappedResult = wrapped(wrappedQ, scalar)
      let nativeResult = native(nativeQ, scalar)
      let nativeAsWrapped = Wrapper(nativeSIMDRepresentation: nativeResult)
      let distance = wrappedResult.lInfinityDistance(to: nativeAsWrapped)
      XCTAssertLessThan(
        distance,
        epsilon,
        "[\(name)] L∞ distance \(distance) >= \(epsilon) for probe=\(probe), scalar=\(scalar)",
        file: file,
        line: line
      )
    }
  }
}

/// Validates a wrapped `(q, q, scalar) -> q` operation (FMA / FMS).
func validateQuaternionBinaryScalarEquivalence<Wrapper, Native, Scalar>(
  _ name: String,
  lhses: [[Scalar]],
  rhses: [[Scalar]],
  scalars: [Scalar],
  epsilon: Wrapper.LInfinityDistance,
  wrapped: (Wrapper, Wrapper, Scalar) -> Wrapper,
  native: (Native, Native, Scalar) -> Native,
  file: StaticString = #filePath,
  line: UInt = #line
) where
  Wrapper: NativeSIMDRepresentable,
  Wrapper.NativeSIMDRepresentation == Native,
  Wrapper: QuaternionProtocol,
  Wrapper.Scalar == Scalar,
  Wrapper: LInfinityDistanceMeasureable,
  Wrapper.LInfinityDistance: BinaryFloatingPoint,
  Scalar: SIMDScalar & BinaryFloatingPoint
{
  for lhs in lhses {
    for rhs in rhses {
      for scalar in scalars {
        let wrappedL: Wrapper = makeQuaternionWrapper(Wrapper.self, from: lhs)
        let wrappedR: Wrapper = makeQuaternionWrapper(Wrapper.self, from: rhs)
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

/// Validates a wrapped `(quaternion) -> Scalar` operation (e.g. `componentwiseMagnitudeSquared`).
func validateQuaternionUnaryScalarOutEquivalence<Wrapper, Native, Scalar>(
  _ name: String,
  probes: [[Scalar]],
  epsilon: Scalar,
  wrapped: (Wrapper) -> Scalar,
  native: (Native) -> Scalar,
  file: StaticString = #filePath,
  line: UInt = #line
) where
  Wrapper: NativeSIMDRepresentable,
  Wrapper.NativeSIMDRepresentation == Native,
  Wrapper: QuaternionProtocol,
  Wrapper.Scalar == Scalar,
  Scalar: SIMDScalar & BinaryFloatingPoint
{
  for probe in probes {
    let wrappedQ: Wrapper = makeQuaternionWrapper(Wrapper.self, from: probe)
    let nativeQ = wrappedQ.nativeSIMDRepresentation
    let wrappedResult = wrapped(wrappedQ)
    let nativeResult = native(nativeQ)
    let distance = abs(wrappedResult - nativeResult)
    XCTAssertLessThan(
      distance,
      epsilon,
      "[\(name)] |Δ| \(distance) >= \(epsilon) for probe=\(probe). wrapped=\(wrappedResult), native=\(nativeResult)",
      file: file,
      line: line
    )
  }
}

/// Validates a wrapped `(q, q) -> Scalar` operation (e.g. `dotted(with:)`).
func validateQuaternionBinaryScalarOutEquivalence<Wrapper, Native, Scalar>(
  _ name: String,
  lhses: [[Scalar]],
  rhses: [[Scalar]],
  epsilon: Scalar,
  wrapped: (Wrapper, Wrapper) -> Scalar,
  native: (Native, Native) -> Scalar,
  file: StaticString = #filePath,
  line: UInt = #line
) where
  Wrapper: NativeSIMDRepresentable,
  Wrapper.NativeSIMDRepresentation == Native,
  Wrapper: QuaternionProtocol,
  Wrapper.Scalar == Scalar,
  Scalar: SIMDScalar & BinaryFloatingPoint
{
  for lhs in lhses {
    for rhs in rhses {
      let wrappedL: Wrapper = makeQuaternionWrapper(Wrapper.self, from: lhs)
      let wrappedR: Wrapper = makeQuaternionWrapper(Wrapper.self, from: rhs)
      let nativeL = wrappedL.nativeSIMDRepresentation
      let nativeR = wrappedR.nativeSIMDRepresentation
      let wrappedResult = wrapped(wrappedL, wrappedR)
      let nativeResult = native(nativeL, nativeR)
      let distance = abs(wrappedResult - nativeResult)
      XCTAssertLessThan(
        distance,
        epsilon,
        "[\(name)] |Δ| \(distance) >= \(epsilon) for lhs=\(lhs), rhs=\(rhs). wrapped=\(wrappedResult), native=\(nativeResult)",
        file: file,
        line: line
      )
    }
  }
}
