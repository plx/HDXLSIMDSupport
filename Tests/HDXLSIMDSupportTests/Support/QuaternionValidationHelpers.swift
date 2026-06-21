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
      "[≡ native simd] \(name): L∞ distance \(distance) >= \(epsilon) for probe \(probe). wrapped=\(wrappedResult), native=\(nativeResult)",
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
        "[≡ native simd] \(name): L∞ distance \(distance) >= \(epsilon) for lhs=\(lhs), rhs=\(rhs)",
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
        "[≡ native simd] \(name): L∞ distance \(distance) >= \(epsilon) for probe=\(probe), scalar=\(scalar)",
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
          "[≡ native simd] \(name): L∞ distance \(distance) >= \(epsilon) for lhs=\(lhs), rhs=\(rhs), scalar=\(scalar)",
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
      "[≡ native simd] \(name): |Δ| \(distance) >= \(epsilon) for probe=\(probe). wrapped=\(wrappedResult), native=\(nativeResult)",
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
        "[≡ native simd] \(name): |Δ| \(distance) >= \(epsilon) for lhs=\(lhs), rhs=\(rhs). wrapped=\(wrappedResult), native=\(nativeResult)",
        file: file,
        line: line
      )
    }
  }
}

/// Validates the rotation action `apply(to:)` against a native one (`simd_act`)
/// over a sweep of (quaternion, vector) probes. The vector result type is shared
/// across the wrapper / native chain.
func validateQuaternionApplyEquivalence<Wrapper, Native, Scalar>(
  _ name: String,
  probes: [[Scalar]],
  vectors: [[Scalar]],
  epsilon: Scalar,
  wrapped: (Wrapper, SIMD3<Scalar>) -> SIMD3<Scalar>,
  native: (Native, SIMD3<Scalar>) -> SIMD3<Scalar>,
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
    for vectorEntries in vectors {
      let wrappedQ: Wrapper = makeQuaternionWrapper(Wrapper.self, from: probe)
      let nativeQ = wrappedQ.nativeSIMDRepresentation
      let vector = SIMD3<Scalar>(vectorEntries[0], vectorEntries[1], vectorEntries[2])
      let wrappedResult = wrapped(wrappedQ, vector)
      let nativeResult = native(nativeQ, vector)
      let distance = max(
        abs(wrappedResult.x - nativeResult.x),
        max(abs(wrappedResult.y - nativeResult.y), abs(wrappedResult.z - nativeResult.z))
      )
      XCTAssertLessThan(
        distance,
        epsilon,
        "[≡ native simd] \(name): L∞ Δ \(distance) ≥ \(epsilon) for q=\(probe), v=\(vectorEntries). wrapped=\(wrappedResult), native=\(nativeResult)",
        file: file,
        line: line
      )
    }
  }
}

/// Validates a `(q0, q1, t) -> q` interpolation (slerp variants) against a
/// native one. Inputs are unit-normalized first (slerp is defined on unit
/// quaternions); the same normalized value feeds both the wrapper and native
/// sides, so the comparison stays an honest wrapper ≡ native check.
func validateQuaternionInterpolationEquivalence<Wrapper, Native, Scalar>(
  _ name: String,
  probes: [[Scalar]],
  parameters: [Scalar],
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
  for lhs in probes {
    for rhs in probes {
      let wrappedL: Wrapper = makeQuaternionWrapper(Wrapper.self, from: lhs).normalized()
      let wrappedR: Wrapper = makeQuaternionWrapper(Wrapper.self, from: rhs).normalized()
      let nativeL = wrappedL.nativeSIMDRepresentation
      let nativeR = wrappedR.nativeSIMDRepresentation
      for t in parameters {
        let wrappedResult = wrapped(wrappedL, wrappedR, t)
        let nativeResult = native(nativeL, nativeR, t)
        let nativeAsWrapped = Wrapper(nativeSIMDRepresentation: nativeResult)
        let distance = wrappedResult.lInfinityDistance(to: nativeAsWrapped)
        XCTAssertLessThan(
          distance,
          epsilon,
          "[≡ native simd] \(name): L∞ Δ \(distance) ≥ \(epsilon) for q0=\(lhs), q1=\(rhs), t=\(t)",
          file: file,
          line: line
        )
      }
    }
  }
}

/// Validates a `(q0, q1, q2, q3, t) -> q` spline interpolation (bezier / spline)
/// against a native one. To avoid a 4-way cross product, control polygons are
/// sliding windows over the (unit-normalized) probe list.
func validateQuaternionSplineEquivalence<Wrapper, Native, Scalar>(
  _ name: String,
  probes: [[Scalar]],
  parameters: [Scalar],
  epsilon: Wrapper.LInfinityDistance,
  wrapped: (Wrapper, Wrapper, Wrapper, Wrapper, Scalar) -> Wrapper,
  native: (Native, Native, Native, Native, Scalar) -> Native,
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
  let count = probes.count
  guard count >= 4 else { return }
  for start in 0..<count {
    let q0: Wrapper = makeQuaternionWrapper(Wrapper.self, from: probes[start]).normalized()
    let q1: Wrapper = makeQuaternionWrapper(Wrapper.self, from: probes[(start + 1) % count]).normalized()
    let q2: Wrapper = makeQuaternionWrapper(Wrapper.self, from: probes[(start + 2) % count]).normalized()
    let q3: Wrapper = makeQuaternionWrapper(Wrapper.self, from: probes[(start + 3) % count]).normalized()
    let n0 = q0.nativeSIMDRepresentation
    let n1 = q1.nativeSIMDRepresentation
    let n2 = q2.nativeSIMDRepresentation
    let n3 = q3.nativeSIMDRepresentation
    for t in parameters {
      let wrappedResult = wrapped(q0, q1, q2, q3, t)
      let nativeResult = native(n0, n1, n2, n3, t)
      let nativeAsWrapped = Wrapper(nativeSIMDRepresentation: nativeResult)
      let distance = wrappedResult.lInfinityDistance(to: nativeAsWrapped)
      XCTAssertLessThan(
        distance,
        epsilon,
        "[≡ native simd] \(name): L∞ Δ \(distance) ≥ \(epsilon) for control polygon starting at \(start), t=\(t)",
        file: file,
        line: line
      )
    }
  }
}
