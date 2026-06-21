//
//  QuaternionManualValidation.swift
//
//  Hand-written algebraic-invariant suite for `Quaternion<T>`, executed via the
//  concrete leaves below. Quaternions have no shape tiers, so a single generic
//  base over the scalar `T` suffices (and `Quaternion<T>` already names its
//  compatible 3x3 / 4x4 matrices concretely, so the rotation-matrix conversions
//  are expressible here).
//
//  The quaternion *geometric* surface (`apply`, axis/angle, `rotating:onto:`,
//  rotation-matrix conversions, slerp) is NOT covered by the macro-generated
//  equivalence suites, so these invariants are its primary safety net.
//

import Foundation
import XCTest
import simd
@testable import HDXLSIMDSupport

// -------------------------------------------------------------------------- //
// MARK: QuaternionManualValidation
// -------------------------------------------------------------------------- //

class QuaternionManualValidation<T: ExtendedSIMDScalar>: XCTestCase {

  typealias Q = Quaternion<T>
  typealias V = SIMD3<T>

  // ------------------------------------------------------------------------ //
  // MARK: Helpers
  // ------------------------------------------------------------------------ //

  final func s(_ value: Int) -> T { T(value) }
  final func s(_ value: Double) -> T { T(value) }
  final func vec(_ x: Double, _ y: Double, _ z: Double) -> V { V(s(x), s(y), s(z)) }
  final func quat(i: Double, j: Double, k: Double, real: Double) -> Q {
    Q(i: s(i), j: s(j), k: s(k), real: s(real))
  }

  /// Tolerance for exact-ish algebraic invariants.
  var absoluteTolerance: T { T.validationTestTolerance }

  /// Looser tolerance for trig-heavy geometric invariants (rotation, slerp,
  /// angle/axis). Overridden per representation in the leaves.
  var geometricTolerance: T { T.validationTestTolerance }

  // Named non-zero probes.
  var qA: Q { quat(i: 1, j: 2, k: 3, real: 4) }
  var qB: Q { quat(i: 2, j: -1, k: 0, real: 3) }
  var qC: Q { quat(i: 0, j: 1, k: -2, real: 1) }

  final func assertQuatAlmostEqual(
    _ lhs: Q, _ rhs: Q,
    _ property: @autoclosure () -> String,
    tolerance: T? = nil,
    file: StaticString = #filePath, line: UInt = #line, function: StaticString = #function
  ) {
    let tol = tolerance ?? absoluteTolerance
    let distance = lhs.lInfinityDistance(to: rhs)
    XCTAssertLessThanOrEqual(
      distance, tol,
      "[invariant] \(property()) — quaternions differ: L∞ Δ = \(distance) > tol \(tol); lhs=\(lhs), rhs=\(rhs) in \(function)",
      file: file, line: line
    )
  }

  final func assertScalarAlmostEqual(
    _ lhs: T, _ rhs: T,
    _ property: @autoclosure () -> String,
    tolerance: T? = nil,
    file: StaticString = #filePath, line: UInt = #line, function: StaticString = #function
  ) {
    let tol = tolerance ?? absoluteTolerance
    XCTAssertLessThanOrEqual(
      abs(lhs - rhs), tol,
      "[invariant] \(property()) — |Δ| = \(abs(lhs - rhs)) > tol \(tol): \(lhs) vs \(rhs) in \(function)",
      file: file, line: line
    )
  }

  final func assertVectorAlmostEqual(
    _ lhs: V, _ rhs: V,
    _ property: @autoclosure () -> String,
    tolerance: T? = nil,
    file: StaticString = #filePath, line: UInt = #line, function: StaticString = #function
  ) {
    let tol = tolerance ?? geometricTolerance
    let distance = max(abs(lhs.x - rhs.x), abs(lhs.y - rhs.y), abs(lhs.z - rhs.z))
    XCTAssertLessThanOrEqual(
      distance, tol,
      "[invariant] \(property()) — vectors differ: L∞ Δ = \(distance) > tol \(tol); lhs=\(lhs), rhs=\(rhs) in \(function)",
      file: file, line: line
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: Constructors & Component Accessors
  // ------------------------------------------------------------------------ //

  /// `init(i:j:k:real:)` places components and the accessors read them back.
  func testComponentPlacement() {
    let q = quat(i: 1, j: 2, k: 3, real: 4)
    assertScalarAlmostEqual(q.realComponent, s(4), "realComponent == 4")
    assertVectorAlmostEqual(q.imaginaryComponent, vec(1, 2, 3), "imaginaryComponent == (1,2,3)")
  }

  /// `init(x:y:z:real:)` is a synonym for `init(i:j:k:real:)`.
  func testXYZRealInitEquivalence() {
    assertQuatAlmostEqual(
      Q(x: s(1), y: s(2), z: s(3), real: s(4)),
      quat(i: 1, j: 2, k: 3, real: 4),
      "init(x:y:z:real:) == init(i:j:k:real:)"
    )
  }

  /// `init(realComponent:imaginaryComponent:)` agrees with `init(i:j:k:real:)`.
  func testRealImaginaryInitEquivalence() {
    assertQuatAlmostEqual(
      Q(realComponent: s(4), imaginaryComponent: vec(1, 2, 3)),
      quat(i: 1, j: 2, k: 3, real: 4),
      "init(realComponent:imaginaryComponent:) == init(i:j:k:real:)"
    )
  }

  /// The unit constants have their documented components (anchors every "== identity").
  func testUnitConstants() {
    assertQuatAlmostEqual(Q.one, quat(i: 0, j: 0, k: 0, real: 1), ".one == (real 1, imag 0)")
    assertQuatAlmostEqual(Q.identity, Q.one, ".identity == .one")
    assertQuatAlmostEqual(Q.i, quat(i: 1, j: 0, k: 0, real: 0), ".i == (1,0,0,0)")
    assertQuatAlmostEqual(Q.j, quat(i: 0, j: 1, k: 0, real: 0), ".j == (0,1,0,0)")
    assertQuatAlmostEqual(Q.k, quat(i: 0, j: 0, k: 1, real: 0), ".k == (0,0,1,0)")
    assertQuatAlmostEqual(Q.x, Q.i, ".x == .i")
    assertQuatAlmostEqual(Q.y, Q.j, ".y == .j")
    assertQuatAlmostEqual(Q.z, Q.k, ".z == .k")
    assertQuatAlmostEqual(Q(), quat(i: 0, j: 0, k: 0, real: 0), "Q() == zero")
  }

  /// Component setters round-trip and don't disturb the other part.
  func testComponentSetters() {
    var q = qA
    q.realComponent = s(9)
    assertScalarAlmostEqual(q.realComponent, s(9), "realComponent setter")
    assertVectorAlmostEqual(q.imaginaryComponent, vec(1, 2, 3), "realComponent setter leaves imaginary alone")
    q.imaginaryComponent = vec(7, 8, 9)
    assertVectorAlmostEqual(q.imaginaryComponent, vec(7, 8, 9), "imaginaryComponent setter")
    assertScalarAlmostEqual(q.realComponent, s(9), "imaginaryComponent setter leaves real alone")
  }

  // ------------------------------------------------------------------------ //
  // MARK: Hamilton Multiplication Table
  // ------------------------------------------------------------------------ //

  /// The Hamilton relations pin the multiplication convention AND prove
  /// `multiplied(onRightBy:)` is `self·other` (since `i·j` must be `k`, not `-k`).
  func testHamiltonTable() {
    assertQuatAlmostEqual(Q.i.multiplied(onRightBy: Q.j), Q.k, "i·j == k")
    assertQuatAlmostEqual(Q.j.multiplied(onRightBy: Q.k), Q.i, "j·k == i")
    assertQuatAlmostEqual(Q.k.multiplied(onRightBy: Q.i), Q.j, "k·i == j")
    assertQuatAlmostEqual(Q.j.multiplied(onRightBy: Q.i), Q.k.negated(), "j·i == -k")
    assertQuatAlmostEqual(Q.k.multiplied(onRightBy: Q.j), Q.i.negated(), "k·j == -i")
    assertQuatAlmostEqual(Q.i.multiplied(onRightBy: Q.k), Q.j.negated(), "i·k == -j")
    assertQuatAlmostEqual(Q.i.multiplied(onRightBy: Q.i), Q.one.negated(), "i·i == -1")
    assertQuatAlmostEqual(Q.j.multiplied(onRightBy: Q.j), Q.one.negated(), "j·j == -1")
    assertQuatAlmostEqual(Q.k.multiplied(onRightBy: Q.k), Q.one.negated(), "k·k == -1")
  }

  /// `multiplied(onLeftBy:)` is `multiplied(onRightBy:)` with operands swapped.
  func testMultiplicationLeftRightDuality() {
    assertQuatAlmostEqual(qA.multiplied(onLeftBy: qB), qB.multiplied(onRightBy: qA), "a.onLeftBy(b) == b.onRightBy(a)")
  }

  /// Quaternion multiplication is non-commutative (`i·j ≠ j·i`).
  func testMultiplicationIsNonCommutative() {
    let ij = Q.i.multiplied(onRightBy: Q.j)
    let ji = Q.j.multiplied(onRightBy: Q.i)
    XCTAssertGreaterThan(
      ij.lInfinityDistance(to: ji), absoluteTolerance,
      "[invariant] Non-commutativity witness: i·j (\(ij)) should differ from j·i (\(ji))"
    )
  }

  /// Associativity of multiplication.
  func testMultiplicationIsAssociative() {
    assertQuatAlmostEqual(
      qA.multiplied(onRightBy: qB).multiplied(onRightBy: qC),
      qA.multiplied(onRightBy: qB.multiplied(onRightBy: qC)),
      "(a·b)·c == a·(b·c)"
    )
  }

  /// Multiplicative identity.
  func testMultiplicationIdentity() {
    assertQuatAlmostEqual(qA.multiplied(onRightBy: Q.one), qA, "a·1 == a")
    assertQuatAlmostEqual(qA.multiplied(onLeftBy: Q.one), qA, "1·a == a")
  }

  /// Multiplication distributes over addition.
  func testMultiplicationDistributesOverAddition() {
    assertQuatAlmostEqual(
      qA.multiplied(onRightBy: qB.adding(qC)),
      qA.multiplied(onRightBy: qB).adding(qA.multiplied(onRightBy: qC)),
      "a·(b + c) == a·b + a·c"
    )
  }

  /// In-place multiplication matches out-of-place.
  func testInPlaceMultiplicationMatches() {
    var right = qA; right.formMultiplication(onRightBy: qB)
    assertQuatAlmostEqual(right, qA.multiplied(onRightBy: qB), "formMultiplication(onRightBy:) matches")
    var left = qA; left.formMultiplication(onLeftBy: qB)
    assertQuatAlmostEqual(left, qA.multiplied(onLeftBy: qB), "formMultiplication(onLeftBy:) matches")
  }

  // ------------------------------------------------------------------------ //
  // MARK: Additive Group & Scalar Arithmetic
  // ------------------------------------------------------------------------ //

  func testAdditionIsCommutative() {
    assertQuatAlmostEqual(qA.adding(qB), qB.adding(qA), "a + b == b + a")
  }

  func testAdditionIsAssociative() {
    assertQuatAlmostEqual(qA.adding(qB).adding(qC), qA.adding(qB.adding(qC)), "(a + b) + c == a + (b + c)")
  }

  func testAdditiveIdentityAndInverse() {
    assertQuatAlmostEqual(qA.adding(Q()), qA, "a + 0 == a")
    assertQuatAlmostEqual(qA.adding(qA.negated()), Q(), "a + (-a) == 0")
  }

  func testSubtractionDefinition() {
    assertQuatAlmostEqual(qA.subtracting(qB), qA.adding(qB.negated()), "a - b == a + (-b)")
    assertQuatAlmostEqual(qA.subtracting(qA), Q(), "a - a == 0")
  }

  func testFusedMultiplyAddSubtract() {
    let f = s(2)
    assertQuatAlmostEqual(qA.adding(qB, multipliedBy: f), qA.adding(qB.multiplied(by: f)), "FMA: a + f·b")
    assertQuatAlmostEqual(qA.subtracting(qB, multipliedBy: f), qA.subtracting(qB.multiplied(by: f)), "FMS: a - f·b")
  }

  func testScalarArithmetic() {
    let f = s(3)
    assertQuatAlmostEqual(
      qA.adding(qB).multiplied(by: f),
      qA.multiplied(by: f).adding(qB.multiplied(by: f)),
      "f·(a + b) == f·a + f·b"
    )
    assertQuatAlmostEqual(qA.multiplied(by: s(1)), qA, "a·1 == a")
    assertQuatAlmostEqual(qA.multiplied(by: s(2)).divided(by: s(2)), qA, "(a·2)/2 == a")
  }

  func testInPlaceArithmeticMatches() {
    var negated = qA; negated.formNegation()
    assertQuatAlmostEqual(negated, qA.negated(), "formNegation matches")
    var sum = qA; sum.formAddition(of: qB)
    assertQuatAlmostEqual(sum, qA.adding(qB), "formAddition matches")
    var scaled = qA; scaled.formMultiplication(by: s(2))
    assertQuatAlmostEqual(scaled, qA.multiplied(by: s(2)), "formMultiplication(by:) matches")
  }

  // ------------------------------------------------------------------------ //
  // MARK: Conjugation / Norm / Inverse
  // ------------------------------------------------------------------------ //

  /// Conjugation negates the imaginary part and keeps the real part (concrete).
  func testConjugateConcrete() {
    assertQuatAlmostEqual(qA.conjugated(), quat(i: -1, j: -2, k: -3, real: 4), "(1,2,3,4)* == (-1,-2,-3,4)")
  }

  func testConjugateInvolutionAndAntihomomorphism() {
    assertQuatAlmostEqual(qA.conjugated().conjugated(), qA, "(a*)* == a")
    assertQuatAlmostEqual(
      qA.multiplied(onRightBy: qB).conjugated(),
      qB.conjugated().multiplied(onRightBy: qA.conjugated()),
      "(a·b)* == b*·a*"
    )
  }

  /// `q·q* == |q|²·one`.
  func testQuaternionTimesConjugateIsNormSquared() {
    assertQuatAlmostEqual(
      qA.multiplied(onRightBy: qA.conjugated()),
      Q(realComponent: qA.componentwiseMagnitudeSquared, imaginaryComponent: .zero),
      "q·q* == |q|²·one"
    )
  }

  /// Norm: `|q|² == Σ component²` and `length == √(|q|²)` (concrete `(1,2,2,0)` ⇒ 9, 3).
  func testNormConcrete() {
    let q = quat(i: 1, j: 2, k: 2, real: 0)
    assertScalarAlmostEqual(q.componentwiseMagnitudeSquared, s(9), "|（1,2,2,0)|² == 9")
    assertScalarAlmostEqual(q.length, s(3), "|(1,2,2,0)| == 3")
    assertScalarAlmostEqual(qA.conjugated().length, qA.length, "|q*| == |q|")
  }

  /// Inverse definition and round-trip.
  func testInverse() {
    assertQuatAlmostEqual(
      qA.inverted(),
      qA.conjugated().divided(by: qA.componentwiseMagnitudeSquared),
      "q⁻¹ == q*/|q|²"
    )
    assertQuatAlmostEqual(qA.multiplied(onRightBy: qA.inverted()), Q.one, "q·q⁻¹ == 1", tolerance: geometricTolerance)
    assertQuatAlmostEqual(qA.inverted().multiplied(onRightBy: qA), Q.one, "q⁻¹·q == 1", tolerance: geometricTolerance)
    var inverted = qA; inverted.formInverse()
    assertQuatAlmostEqual(inverted, qA.inverted(), "formInverse matches")
  }

  /// For a *unit* quaternion, the inverse equals the conjugate.
  func testUnitInverseEqualsConjugate() {
    let unit = quat(i: 1, j: 2, k: 2, real: 0).normalized()  // |·| == 1
    assertQuatAlmostEqual(unit.inverted(), unit.conjugated(), "unit q⁻¹ == q*", tolerance: geometricTolerance)
  }

  // ------------------------------------------------------------------------ //
  // MARK: Normalization
  // ------------------------------------------------------------------------ //

  func testNormalization() {
    let normalized = qA.normalized()
    assertScalarAlmostEqual(normalized.length, s(1), "|normalized| == 1", tolerance: geometricTolerance)
    assertQuatAlmostEqual(normalized, qA.divided(by: qA.length), "normalized == q/|q|", tolerance: geometricTolerance)
    var inPlace = qA; inPlace.formNormalization()
    assertQuatAlmostEqual(inPlace, qA.normalized(), "formNormalization matches")
  }

  // ------------------------------------------------------------------------ //
  // MARK: Division
  // ------------------------------------------------------------------------ //

  /// Right division is `a·b⁻¹`; left division is `b⁻¹·a` (NOT `a·b⁻¹`).
  func testDivision() {
    assertQuatAlmostEqual(qA.divided(onRightBy: qB), qA.multiplied(onRightBy: qB.inverted()), "a/ᵣb == a·b⁻¹", tolerance: geometricTolerance)
    assertQuatAlmostEqual(qA.divided(onLeftBy: qB), qB.inverted().multiplied(onRightBy: qA), "a/ₗb == b⁻¹·a", tolerance: geometricTolerance)
    assertQuatAlmostEqual(qA.divided(onRightBy: qA), Q.one, "a/ᵣa == 1", tolerance: geometricTolerance)
    var inPlace = qA; inPlace.formDivision(onRightBy: qB)
    assertQuatAlmostEqual(inPlace, qA.divided(onRightBy: qB), "formDivision(onRightBy:) matches", tolerance: geometricTolerance)
  }

  // ------------------------------------------------------------------------ //
  // MARK: Dot Product
  // ------------------------------------------------------------------------ //

  /// Dot is the 4-component Euclidean dot (concrete: `qA·qB == 12`).
  func testDotProduct() {
    assertScalarAlmostEqual(qA.dotted(with: qB), s(12), "qA·qB == 12")
    assertScalarAlmostEqual(qA.dotted(with: qA), qA.componentwiseMagnitudeSquared, "q·q == |q|²")
    assertScalarAlmostEqual(qA.dotted(with: qB), qB.dotted(with: qA), "dot symmetric")
  }

  // ------------------------------------------------------------------------ //
  // MARK: Rotation Action
  // ------------------------------------------------------------------------ //

  /// A 90° rotation about +z sends (1,0,0) to (0,1,0) (concrete; fixes handedness).
  func testRotationConcrete() {
    let q = Q(angleInRadians: s(Double.pi / 2), rotationAxis: vec(0, 0, 1))
    assertVectorAlmostEqual(q.apply(to: vec(1, 0, 0)), vec(0, 1, 0), "90°-about-z sends (1,0,0) → (0,1,0)")
    assertVectorAlmostEqual(q.apply(to: vec(0, 0, 1)), vec(0, 0, 1), "rotation fixes its axis")
  }

  /// Rotation preserves length, the identity quaternion is a no-op, and the
  /// double-cover `q` / `-q` act identically.
  func testRotationProperties() {
    let q = Q(angleInRadians: s(Double.pi / 3), rotationAxis: vec(0, 0, 1))
    let v = vec(1, 2, 0)
    let rotated = q.apply(to: v)
    let lengthIn = (v.x * v.x + v.y * v.y + v.z * v.z).squareRoot()
    let lengthOut = (rotated.x * rotated.x + rotated.y * rotated.y + rotated.z * rotated.z).squareRoot()
    assertScalarAlmostEqual(lengthOut, lengthIn, "rotation preserves length", tolerance: geometricTolerance)
    assertVectorAlmostEqual(Q.one.apply(to: v), v, "identity rotation is a no-op")
    assertVectorAlmostEqual(q.negated().apply(to: v), q.apply(to: v), "double cover: q and -q act identically")
  }

  /// Composition order: `(p·q).apply(v) == p.apply(q.apply(v))`.
  func testRotationComposition() {
    let p = Q(angleInRadians: s(Double.pi / 2), rotationAxis: vec(0, 0, 1))
    let q = Q(angleInRadians: s(Double.pi / 2), rotationAxis: vec(1, 0, 0))
    let v = vec(0, 0, 1)
    assertVectorAlmostEqual(
      p.multiplied(onRightBy: q).apply(to: v),
      p.apply(to: q.apply(to: v)),
      "(p·q).apply(v) == p.apply(q.apply(v))",
      tolerance: geometricTolerance
    )
  }

  /// `init(angleInRadians:rotationAxis:)` round-trips through `angleInRadians` /
  /// `rotationAxis` (away from the degenerate θ=0/π endpoints).
  func testAngleAxisRoundTrip() {
    let angle = s(Double.pi / 2)
    let axis = vec(0, 0, 1)
    let q = Q(angleInRadians: angle, rotationAxis: axis)
    assertScalarAlmostEqual(q.angleInRadians, angle, "angle round-trip", tolerance: geometricTolerance)
    assertVectorAlmostEqual(q.rotationAxis, axis, "axis round-trip", tolerance: geometricTolerance)
  }

  /// `init(rotating:onto:)` builds a rotation taking one direction to the other.
  func testRotatingOnto() {
    let q = Q(rotating: vec(1, 0, 0), onto: vec(0, 1, 0))
    assertVectorAlmostEqual(q.apply(to: vec(1, 0, 0)), vec(0, 1, 0), "rotating (1,0,0) onto (0,1,0)", tolerance: geometricTolerance)
  }

  // ------------------------------------------------------------------------ //
  // MARK: Quaternion ↔ Rotation Matrix
  // ------------------------------------------------------------------------ //

  /// `Matrix3x3(quaternion: q90z)` is the known 90°-about-z rotation matrix, and
  /// the matrix's action matches `q.apply(to:)`.
  func testQuaternionToMatrix3x3() {
    let q = Q(angleInRadians: s(Double.pi / 2), rotationAxis: vec(0, 0, 1))
    let matrix = Matrix3x3<T>(quaternion: q)
    // 90°-about-z rotation matrix (columns): (0,1,0), (-1,0,0), (0,0,1).
    let expected = Matrix3x3<T>(
      scalars: [[0, -1, 0], [1, 0, 0], [0, 0, 1]].map { $0.map { s(Double($0)) } }
    )
    assertMatricesAlmostEqual(matrix, expected, "Matrix3x3(quaternion: 90°-about-z)", tolerance: geometricTolerance)
    // The matrix's action on a vector matches the quaternion's.
    let v = vec(1, 2, 3)
    assertVectorAlmostEqual(matrix.multiplied(onRightBy: v), q.apply(to: v), "M(q)·v == q.apply(v)", tolerance: geometricTolerance)
  }

  /// The top-left 3x3 block of `Matrix4x4(quaternion:)` equals `Matrix3x3(quaternion:)`.
  func testQuaternionToMatrix4x4Consistency() {
    let q = Q(angleInRadians: s(Double.pi / 3), rotationAxis: vec(0, 1, 0))
    let m3 = Matrix3x3<T>(quaternion: q)
    let m4 = Matrix4x4<T>(quaternion: q)
    for r in 0..<3 {
      for c in 0..<3 {
        assertScalarAlmostEqual(
          m4[columnIndex: c, rowIndex: r],
          m3[columnIndex: c, rowIndex: r],
          "4x4 top-left block (col \(c), row \(r)) == 3x3",
          tolerance: geometricTolerance
        )
      }
    }
  }

  /// Round-trip `q → Matrix → q'` recovers `q` up to sign (the double cover).
  func testMatrixToQuaternionRoundTrip() {
    let q = Q(angleInRadians: s(Double.pi / 2), rotationAxis: vec(0, 0, 1))  // already unit
    let recovered = Quaternion<T>(rotationMatrix: Matrix3x3<T>(quaternion: q))
    let direct = recovered.lInfinityDistance(to: q)
    let flipped = recovered.lInfinityDistance(to: q.negated())
    XCTAssertLessThanOrEqual(
      min(direct, flipped), geometricTolerance,
      "[invariant] matrix→quaternion round-trip recovers q up to sign: min(\(direct), \(flipped)) > tol \(geometricTolerance); recovered=\(recovered), q=\(q)"
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: Interpolation
  // ------------------------------------------------------------------------ //

  /// Slerp endpoints and `strategy: .automatic == shortest`.
  func testSlerpEndpointsAndStrategy() {
    let q0 = Q(angleInRadians: s(0), rotationAxis: vec(0, 0, 1))            // identity-ish
    let q1 = Q(angleInRadians: s(Double.pi / 2), rotationAxis: vec(0, 0, 1))
    assertQuatAlmostEqual(Q.slerpShortest(q0, q1, s(0)), q0, "slerp(t=0) == q0", tolerance: geometricTolerance)
    assertQuatAlmostEqual(Q.slerpShortest(q0, q1, s(1)), q1, "slerp(t=1) == q1", tolerance: geometricTolerance)
    assertQuatAlmostEqual(
      Q.slerp(q0, q1, s(0.5), strategy: .automatic),
      Q.slerpShortest(q0, q1, s(0.5)),
      "slerp(.automatic) == slerpShortest",
      tolerance: geometricTolerance
    )
    assertScalarAlmostEqual(Q.slerpShortest(q0, q1, s(0.5)).length, s(1), "slerp midpoint is unit-length", tolerance: geometricTolerance)
  }
}
