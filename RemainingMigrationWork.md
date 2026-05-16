# Remaining Migration Work

Status as of commit `c54a394`. The macro-driven refactor is functionally complete — every matrix and quaternion conformance is macro-generated, the `Passthrough` protocol and its forwarding extensions are gone, and 325 tests pass. The items below are deferred cleanups and coverage extensions that were intentionally scoped out of the main migration. None of them are required for correctness; they tighten the API surface and broaden the validation safety net.

---

## 1. Demote concrete storage types to `@usableFromInline internal`

**Status.** Partially done. The wrapper's `Storage` typealias, `storage` field, and `init(storage:)` are now `@usableFromInline internal`, so external code can no longer reach the storage layer via a `Matrix2x2<Float>` (or `Quaternion<Float>`) value. The storage TYPES themselves (`FloatMatrix2x2Storage`, etc.) remain `public` because the `ExtendedSIMDScalar` protocol exposes them as public associated-type witnesses (`public typealias Matrix2x2Storage = FloatMatrix2x2Storage`); Swift requires the witness type to be at least as accessible as the protocol, so we can't demote the typealias without also restructuring the protocol.

**Goal.** Reduce the public API surface to just the generic wrappers (`Matrix2x2<Scalar>` through `Matrix4x4<Scalar>`, `Quaternion<Scalar>`). The concrete per-representation storage types (`FloatMatrix2x2Storage` … `HalfMatrix4x4Storage`, plus the three quaternion storages) become implementation details exposed via `@usableFromInline internal` so the `@inlinable` macro-emitted code can still reach them.

**Architectural blocker.** `ExtendedSIMDScalar` is currently a `public protocol` with `associatedtype Matrix2x2Storage: Matrix2x2Protocol, ...` style requirements. To make the concrete witnesses internal, the protocol's associated-type requirements would have to be reformulated so the witness types are no longer publicly nameable — e.g., by making the protocol itself `@usableFromInline internal` (which forces the wrappers' generic constraints to follow suit), or by refactoring the protocol to expose only an *abstract* storage interface and hiding the concrete witnesses behind a sealed bridge type.

That refactor is a meaningful architectural shift and was not in scope here. The infrastructure for the eventual full demotion is in place (`MatrixLayerContext.emittedVisibility`, `QuaternionLayerContext.emittedVisibility`), so a future session can finish the job once the protocol design is sorted.

**Scope (30 types).**

- `Sources/HDXLSIMDSupport/Matrices/Storages/Float/FloatMatrix{2x2,2x3,2x4,3x2,3x3,3x4,4x2,4x3,4x4}Storage.swift`
- `Sources/HDXLSIMDSupport/Matrices/Storages/Double/DoubleMatrix{2x2..4x4}Storage.swift`
- `Sources/HDXLSIMDSupport/Matrices/Storages/Half/HalfMatrix{2x2..4x4}Storage.swift`
- `Sources/HDXLSIMDSupport/Quaternion/Storages/{Float,Double,Half}QuaternionStorage.swift`

**Mechanical edit.** In each file, change

```swift
@frozen
@AddStorageMatrixConformance(rowCount: ?, columnCount: ?, representation: .?)
public struct FloatMatrix2x2Storage:
  Matrix2x2Protocol,
  MatrixOperatorSupportProtocol,
  Matrix2x2OperatorSupportProtocol,
  NativeSIMDRepresentable,
  NumericAggregate,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable
{ }
```

to

```swift
@frozen
@usableFromInline
@AddStorageMatrixConformance(rowCount: ?, columnCount: ?, representation: .?)
internal struct FloatMatrix2x2Storage:
  Matrix2x2Protocol,
  MatrixOperatorSupportProtocol,
  Matrix2x2OperatorSupportProtocol,
  NativeSIMDRepresentable,
  NumericAggregate,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable
{ }
```

A `sed -i` over the 30 files works (look for `^public struct {Float,Double,Half}Matrix.*Storage:`).

**Macro emissions that need to follow.** The macros currently emit `public` members. When the type is `internal`, Swift requires the members to be `internal` too (you can't have a public member on an internal type), or `@usableFromInline internal`. The simplest fix is to make every macro-emitted member `@usableFromInline internal` rather than `public`. The macrolets to touch in `Sources/HDXLSIMDSupportMacroPlugin/Macrolets/`:

- `StorageBackingMacrolet.swift` — the `storage` stored property + `init(storage:)`, currently `public`.
- `TypealiasMacrolet.swift`, `CompatibleMatricesMacrolet.swift`, `ShapeConstantsMacrolet.swift`, `PositionHelpersMacrolet.swift`, `InitializationMacrolet.swift`, `SubscriptingMacrolet.swift`, `BulkPropertiesMacrolet.swift`, every arithmetic macrolet, plus `HashableMacrolet`, `CodableMacrolet`, `DescriptionMacrolet`, `NumericAggregateMacrolet`, `NativeSIMDRepresentableMacrolet`, `LinearCombinationMacrolet`, `AlmostEqualElementsMacrolet`, `ComponentwiseMagnitudeSquaredMacrolet`, `TransposeMacrolet`, `DeterminantMacrolet`, `InversionMacrolet`, `SquareMultiplicationMacrolet`, `SquareDivisionMacrolet`, `CrossShapeMultiplicationMacrolet`, `VectorMultiplicationMacrolet`, `QuaternionConstructorMacrolet`, `VectorArithmeticMacrolet`, `QuaternionMacrolets.swift`.

The cleanest fix is a `MatrixLayerContext` (and matching `QuaternionLayerContext`) helper:

```swift
extension MatrixLayerContext {
  /// Visibility for macro-emitted declarations on this layer.
  /// - `.native`: `public` (extensions on simd_* types; user-facing).
  /// - `.storage`: `@usableFromInline internal`.
  /// - `.wrapper`: `public` (user-facing wrapper).
  var emittedVisibility: String {
    switch layer {
    case .native, .wrapper: return "public"
    case .storage: return "@usableFromInline internal"
    }
  }
}
```

then in each macrolet emit `\(raw: context.emittedVisibility) func ...` instead of a hardcoded `public func ...`. Touching every macrolet is mechanical but tedious; do it before deleting any tests so the regression coverage holds.

**Verification.** After the change:

1. `swift build` should succeed — if it doesn't, the most likely failure is a `@inlinable` member referencing the storage type from a `public` context that needs to acquire `@usableFromInline`. The compiler diagnostics name the exact site.
2. `swift test` should still report 325 tests passing.
3. Verify that `FloatMatrix2x2Storage` is no longer in the module's public surface: `swift package -Xswiftc -emit-module-interface` and grep the resulting `.swiftinterface` for the storage type names.

**Breaking-change note.** Any downstream code that names a concrete storage type (e.g., `FloatMatrix2x2Storage`) will break. The migration guide for downstream consumers is "stop naming the concrete storage; use `Scalar.Matrix2x2Storage` via the protocol, or stick to `Matrix2x2<Float>`."

---

## 2. Additional validation-slice coverage

The macro-emitted validation suite currently covers 8 slices: negation, matrix +/-, scalar × / ÷, FMA, FMS, square multiplication, transpose, inversion. The macrolets below either need a `validationTestDeclarations(in:)` body added or need a new helper in `Tests/HDXLSIMDSupportTests/Support/MatrixValidationHelpers.swift` because their input/output shapes don't fit an existing helper.

### 2a. Scalar add / scalar subtract

**Files.** `Sources/HDXLSIMDSupportMacroPlugin/Macrolets/ScalarAdditionMacrolet.swift`, `ScalarSubtractionMacrolet.swift`.

**Helper.** `validateMatrixScalarEquivalence` already exists (used by scalar mul/div). It's reusable as-is.

**Implementation.** Add a `validationTestDeclarations(in:)` to each macrolet mirroring `ScalarMultiplicationMacrolet`'s, but using `adding(scalar:)` / `subtracting(scalar:)` on the wrapped side. The native side computes via column-vector adds; for float/double `m.columns.0 + s, m.columns.1 + s, ...` is the ground truth (or build a `m + Native(columns:( SIMD<n>(repeating: s), ... ))`). For half, the existing per-column SIMD vector add is the only choice.

**Estimated cost.** 30 minutes per macrolet. Each emits ~12 lines.

### 2b. Linear combination

**File.** `Sources/HDXLSIMDSupportMacroPlugin/Macrolets/LinearCombinationMacrolet.swift`.

**Helper needed.** None of the existing helpers takes two matrices and two scalars. Add to `MatrixValidationHelpers.swift`:

```swift
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
) where /* same conformances as validateBinaryEquivalence */
```

The native ground truth is `simd_linear_combination(firstWeight, first, otherWeight, other)` for float/double; for half use `first.adding(other.scalingBy: ...)` style hand-built equivalent.

**Estimated cost.** 1 hour (helper + macrolet edit + verify across 27 emissions).

### 2c. Vector multiplication

**File.** `Sources/HDXLSIMDSupportMacroPlugin/Macrolets/VectorMultiplicationMacrolet.swift`.

**Helper needed.** Results are vectors (`RowVector` / `ColumnVector`), not matrices. Add:

```swift
func validateMatrixVectorEquivalence<Wrapper, Native, Vec, Scalar>(
  _ name: String,
  matrices: [[[Scalar]]],
  vectors: [[Scalar]],          // raw [Scalar] of the right length
  epsilon: Scalar,
  wrapped: (Wrapper, Vec) -> Vec,
  native: (Native, Vec) -> Vec,
  ...
)
```

where `Vec` is `SIMD<n><Scalar>`. The L∞ distance for a SIMD vector is the max absolute coordinate difference.

**Estimated cost.** 1.5 hours (helper + two test methods — left-mult and right-mult — in macrolet + cross-shape verification of vector lengths).

### 2d. Cross-shape multiplication

**File.** `Sources/HDXLSIMDSupportMacroPlugin/Macrolets/CrossShapeMultiplicationMacrolet.swift`.

The most intricate slice. Per-shape it generates up to ~6 multiplication variants (right-mult by `(X, M)` for X ∈ {2,3,4} and left-mult by `(N, X)` for X ∈ {2,3,4}, minus the square case which `SquareMultiplicationMacrolet` covers). Each variant has its own result shape, which means the validation helper can't be the simple "wrapper-and-native-are-the-same-type" form `validateBinaryEquivalence`.

**Helper needed.** Heterogeneous version of `validateBinaryEquivalence`:

```swift
func validateHeterogeneousBinaryEquivalence<
  LhsWrapper, LhsNative, RhsWrapper, RhsNative, ResultWrapper, ResultNative, Scalar
>(
  _ name: String,
  lhses: [[[Scalar]]],          // raw scalars for a LhsWrapper shape
  rhses: [[[Scalar]]],          // raw scalars for a RhsWrapper shape
  epsilon: ResultWrapper.LInfinityDistance,
  wrapped: (LhsWrapper, RhsWrapper) -> ResultWrapper,
  native: (LhsNative, RhsNative) -> ResultNative,
  ...
) where
  LhsWrapper: MatrixProtocol & NativeSIMDRepresentable, LhsWrapper.NativeSIMDRepresentation == LhsNative,
  RhsWrapper: MatrixProtocol & NativeSIMDRepresentable, RhsWrapper.NativeSIMDRepresentation == RhsNative,
  ResultWrapper: MatrixProtocol & NativeSIMDRepresentable & LInfinityDistanceMeasureable,
  ResultWrapper.NativeSIMDRepresentation == ResultNative,
  LhsWrapper.Scalar == Scalar, RhsWrapper.Scalar == Scalar, ResultWrapper.Scalar == Scalar
```

**Macrolet emission.** For each `(X, direction, isHalfBuggyResult)` triple per shape, emit a test:

```swift
func test_rightMult_by_3x2() {
  let lhses: [[[Float]]] = /* probes for self shape */
  let rhses: [[[Float]]] = /* probes for 3x2 shape */
  validateHeterogeneousBinaryEquivalence(
    "multiplied(onRightBy: CompatibleMatrix3x2)",
    lhses: lhses, rhses: rhses,
    epsilon: 0.0001,
    wrapped: { (a: Matrix2x3<Float>, b: Matrix3x2<Float>) -> Matrix3x3<Float> in a.multiplied(onRightBy: b) },
    native: { (a: simd_float2x3, b: simd_float3x2) -> simd_float3x3 in a * b }
  )
}
```

Probes for the rhs shape need to be built per shape (not just self's probes); add a `probeMatricesArrayExpression(forShape:)` helper in `ValidationTestSupport.swift` that takes an arbitrary `MatrixDescriptor`.

**Skip rules.** Same as the implementation side — `isBuggyHalf` (result is half-3-row) means we have no independent ground truth, so skip the test rather than compare against the same column-wise formula.

**Estimated cost.** 3-4 hours (helper, probe-array generalisation, X-iteration in macrolet, verifying the expected ~80-100 new test cases pass). The biggest risk is type-inference issues with the heterogeneous wrapped/native closures; explicit closure parameter types are mandatory.

### 2e. Determinant + `hasAlmostEqualElements` + `componentwiseMagnitudeSquared`

**Files.** `Sources/HDXLSIMDSupportMacroPlugin/Macrolets/DeterminantMacrolet.swift`, `AlmostEqualElementsMacrolet.swift`, `ComponentwiseMagnitudeSquaredMacrolet.swift`.

**Helper needed.** Scalar-result form:

```swift
func validateUnaryToScalarEquivalence<Wrapper, Native, Scalar>(
  _ name: String,
  probes: [[[Scalar]]],
  epsilon: Scalar,
  wrapped: (Wrapper) -> Scalar,
  native: (Native) -> Scalar,
  ...
)
```

For `hasAlmostEqualElements` the result is `Bool`, so a third helper:

```swift
func validateBinaryToBoolEquivalence<...>(
  _ name: String,
  lhses: ..., rhses: ..., tolerance: Scalar,
  wrapped: (Wrapper, Wrapper, Scalar) -> Bool,
  native: (Native, Native, Scalar) -> Bool,
  ...
)
```

with `#expect(wrapped == native, ...)`.

**Estimated cost.** 1.5 hours combined.

### 2f. Subscripting + bulk properties + initialization

These macrolets are largely "structural" — they emit field access and constructor patterns rather than computational behaviour. The protocol tests in `Tests/HDXLSIMDSupportTests/Tests/Matrices/Matrices/MatrixInitRepeatingTests.swift`, `MatrixShapeSanityTests.swift`, etc., already cover them across all 27 (shape, rep) combos via parameterised XCTestCase methods. Macro-generating equivalent tests would duplicate that coverage without catching anything new; leave the hand-written tests in place.

---

## 3. Half-3-row cross-validation via Float widening

**Status.** Done for every same-shape arithmetic slice: negation, matrix +/-, scalar +/-, scalar mul/div, FMA, FMS, square multiplication (half-3x3), and linear combination. Each emits a `*_widened` test on the half-3-row case via the new `validateHalfThreeRowUnaryViaFloatWidening` / `validateHalfThreeRowBinaryViaFloatWidening` / `validateHalfThreeRowMatrixScalarViaFloatWidening` / `validateHalfThreeRowBinaryScalarViaFloatWidening` / `validateHalfThreeRowLinearCombinationViaFloatWidening` helpers in `MatrixValidationHelpers.swift`. Test count delta: +31.

**Remaining gap.** Cross-shape multiplication (`CrossShapeMultiplicationMacrolet`) still skips its half-3-row-result variants. A heterogeneous widening helper (lhs, rhs, result each with a distinct shape, in two precisions) was attempted but hit the Swift generic-rewrite-system limit when written as a single function — six `MatrixProtocol`-constrained generic parameters times their associated types blows past the compiler's rule budget. The next attempt should emit the per-test widening body inline in the macrolet (no shared generic helper), which sidesteps the constraint-system limit at the cost of more verbose generated source.

---

## 4. Quaternion validation tests

The quaternion conformance is fully macro-generated, but no macrolet currently emits `validationTestDeclarations`. The existing hand-written `Tests/HDXLSIMDSupportTests/Tests/Quaternions/FloatQuaternionValidationTests.swift` and `HalfQuaternionValidationTests.swift` exercise the wrapper against the native simd routines, so coverage isn't zero — but it's all hand-written and only covers Float and Half (no Double).

**Goal.** Add macro-driven quaternion validation: a `#generateQuaternionConformanceTests(representation:)` freestanding macro that emits XCTest methods, mirroring `#generateMatrixConformanceTests`.

**Files to add / change.**

- New macro: `Sources/HDXLSIMDSupportMacroPlugin/Macros/AddQuaternionConformanceTestsMacro.swift` (peer to the matrix-tests version, calls `QuaternionMacroletComposition.macrolets(for:layer:)` with `.wrapper` layer and routes each macrolet's `validationTestDeclarations(in:)` output).
- Public macro declaration in `Sources/HDXLSIMDSupport/Macros/Macros.swift`.
- Plugin registration in `Sources/HDXLSIMDSupportMacroPlugin/Plugin.swift`.
- Per-macrolet `validationTestDeclarations(in:)` implementations in `QuaternionMacrolets.swift` for at least: negation, addition, subtraction, FMA, FMS, scalar mul/div, quaternion mul/div, conjugation, inversion, normalisation, dot product. Skip slerp / bezier / spline initially (no clean "reverse" oracle).
- New test files `Tests/HDXLSIMDSupportTests/Tests/Quaternions/Validation/Quaternion{Float,Double,Half}ValidationTests.swift` that invoke the freestanding macro.

**Helper needed.** Quaternion-specific versions of the unary / binary / matrix-scalar validators (the existing helpers constrain `Wrapper: MatrixProtocol`, which quaternions don't satisfy). Cleanest is to introduce a `QuaternionValidationHelpers.swift` in the test target with quaternion-shaped signatures, or a `where`-relaxed shared helper that constrains only on `NativeSIMDRepresentable` + `LInfinityDistanceMeasureable`.

**Probe inputs.** Quaternions are 4-tuples of scalars (i, j, k, real). Hardcode 6–8 representative probes (zero quaternion, identity, rotations about axes, etc.) and one or two non-unit-length quaternions for division / inversion edge cases.

**Estimated cost.** 4–6 hours total; mostly mechanical once the helper is in place.

---

## 5. Stale documentation / cosmetic comment cleanup

Three files still mention `Passthrough` in their comments / doc-strings, but `Passthrough` itself is gone:

- `Sources/HDXLSIMDSupport/NativeSIMDRepresentable/NativeSIMDRepresentable.swift` — the doc-comment for the protocol references the old Passthrough overlap.
- `Sources/HDXLSIMDSupport/Matrices/Protocols/MatrixProtocol.swift` — the doc-comment for `MatrixProtocol` describes the "extension Passthrough where PassthroughValue: MatrixProtocol" pattern as the rationale.
- `Sources/HDXLSIMDSupport/Matrices/NativeConformances/Half/HalfNativeMatrices+Equatable.swift` and `Sources/HDXLSIMDSupport/Quaternion/NativeConformances/simd_quath+Equatable.swift` — both say "the `Passthrough+Equatable` default in this package relies on `PassthroughValue: Equatable`".

These files all still need to exist (they provide non-trivial functionality), but the rationale paragraphs are now historical. Rewrite the comments to reflect "the macro-generated `==` lives on each storage / wrapper; native simd_half* types don't get a synthesised Equatable from the overlay, so we add it explicitly here for symmetry with `simd_quatf` / `simd_quatd` / `simd_floatNxM`".

Also in the macro plugin:

- `Sources/HDXLSIMDSupportMacroPlugin/Macrolets/StorageBackingMacrolet.swift` — the doc-comment still describes the "transitional `passthroughValue` field name during migration" rationale. The migration is complete; the field is permanently named `storage`. Rewrite.
- `Sources/HDXLSIMDSupportMacroPlugin/Macrolets/QuaternionConstructorMacrolet.swift` — mentions "the Passthrough chain"; should say "the storage chain".

**Estimated cost.** 30 minutes.

---

## 6. Other small follow-ups

- **`XCTestManifests.swift`** at `Tests/HDXLSIMDSupportTests/XCTestManifests.swift` looks Linux-test-discovery-related. Audit whether the macro-generated `test_*` methods get picked up automatically (Apple platforms use Objective-C runtime discovery, so they should). If Linux support matters, the manifest needs regeneration.
- **`Sources/HDXLSIMDSupport/Matrices/Operators/Matrix*OperatorSupportProtocol.swift`** — currently a vacuous refinement of `MatrixNxMProtocol` used to host operator overloads (`+`, `-`, `*`, `*=`, ...). Could be folded into the per-shape protocol now that macros emit the conformance directly, but it works as-is.
- **`Sources/HDXLSIMDSupport/Matrices/Protocols/MatrixProtocol.swift`** — has a long comment explaining why earlier "fine-grained protocol hierarchy" designs blew up compile times. The macros now generate explicit per-type conformance, so a thinner protocol hierarchy might be re-attempted. Risky and not required.
- The macro plugin's `MatrixMacroletComposition` and `QuaternionMacroletComposition` ignore their `layer:` parameter (everything is composed unconditionally and each macrolet decides per-layer behaviour internally). The parameter could be deleted, but keeping it makes the call site explicit and future-proof against layer-conditional composition.

---

## Recommended order for a follow-up session

1. **Comment cleanup** (§5). Quick, no behaviour change.
2. **Scalar add/sub validation** (§2a). Smallest validation-coverage win.
3. **Quaternion validation tests** (§4). Biggest single coverage gain, uses the pattern already established.
4. **Determinant / hasAlmostEqual / componentwiseMagnitudeSquared validation** (§2e). Brings the "easy" remaining matrix slices to parity.
5. **Cross-shape multiplication validation** (§2d). Hardest, biggest payoff for catching mult bugs.
6. **Linear combination + vector multiplication** (§2b, §2c). Round out the matrix slices.
7. **Storage-type privacy demotion** (§1). Do this last — it's the most disruptive and is the only step here that's a breaking API change for downstream consumers.
8. **Half-3-row float-widening cross-validation** (§3). Optional polish.
