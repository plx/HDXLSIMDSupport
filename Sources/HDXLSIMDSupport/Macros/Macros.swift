//
//  Macros.swift
//
//  Public macro declarations exposed by HDXLSIMDSupport. Each macro forwards
//  to a concrete implementation in `HDXLSIMDSupportMacroPlugin`. The plugin
//  is a build-time-only dependency; users do not see it.
//

/// `MatrixRepresentation` is mirrored here as a `String`-raw enum so we can
/// take it as a macro argument from outside the plugin. The plugin parses the
/// same `.half | .float | .double` cases at expansion time.
@frozen
public enum MatrixRepresentation: String, Sendable {
  case half
  case float
  case double
}

/// Attached member macro that emits the protocol-conformance members for a
/// native `simd_floatNxM`-style matrix type.
///
/// Apply to an extension whose self type is the appropriate native simd
/// matrix; the macro fills in `rowCount`, `columnCount`, etc.
///
/// Example:
///
///     @AddNativeMatrixConformance(rowCount: 2, columnCount: 2, representation: .float)
///     extension simd_float2x2 { }
@attached(member, names: arbitrary)
public macro AddNativeMatrixConformance(
  rowCount: Int,
  columnCount: Int,
  representation: MatrixRepresentation
) = #externalMacro(
  module: "HDXLSIMDSupportMacroPlugin",
  type: "AddNativeMatrixConformanceMacro"
)

/// Attached member macro that emits the protocol-conformance members for a
/// per-(shape, representation) storage struct (e.g. `FloatMatrix2x2Storage`).
///
/// Example:
///
///     @AddStorageMatrixConformance(rowCount: 2, columnCount: 2, representation: .float)
///     internal struct FloatMatrix2x2Storage { }
@attached(member, names: arbitrary)
public macro AddStorageMatrixConformance(
  rowCount: Int,
  columnCount: Int,
  representation: MatrixRepresentation
) = #externalMacro(
  module: "HDXLSIMDSupportMacroPlugin",
  type: "AddStorageMatrixConformanceMacro"
)

/// Attached member macro that emits the protocol-conformance members for the
/// public generic wrapper type (e.g. `Matrix2x2<Scalar>`).
///
/// No `representation:` argument — the wrapper is generic over `Scalar`.
///
/// Example:
///
///     @AddWrapperMatrixConformance(rowCount: 2, columnCount: 2)
///     public struct Matrix2x2<Scalar: ExtendedSIMDScalar> { }
@attached(member, names: arbitrary)
public macro AddWrapperMatrixConformance(
  rowCount: Int,
  columnCount: Int
) = #externalMacro(
  module: "HDXLSIMDSupportMacroPlugin",
  type: "AddWrapperMatrixConformanceMacro"
)

/// Attached member macro emitting the QuaternionProtocol conformance for a
/// native `simd_quat{f,d,h}` extension.
@attached(member, names: arbitrary)
public macro AddNativeQuaternionConformance(
  representation: MatrixRepresentation
) = #externalMacro(
  module: "HDXLSIMDSupportMacroPlugin",
  type: "AddNativeQuaternionConformanceMacro"
)

/// Attached member macro emitting the QuaternionProtocol conformance for a
/// per-representation storage struct (`FloatQuaternionStorage`, etc.).
@attached(member, names: arbitrary)
public macro AddStorageQuaternionConformance(
  representation: MatrixRepresentation
) = #externalMacro(
  module: "HDXLSIMDSupportMacroPlugin",
  type: "AddStorageQuaternionConformanceMacro"
)

/// Attached member macro emitting the QuaternionProtocol conformance for the
/// generic `Quaternion<Scalar>` wrapper.
@attached(member, names: arbitrary)
public macro AddWrapperQuaternionConformance() = #externalMacro(
  module: "HDXLSIMDSupportMacroPlugin",
  type: "AddWrapperQuaternionConformanceMacro"
)

/// Freestanding declaration macro that emits an XCTest test-method suite
/// validating a particular (shape, representation) combination of the
/// macro-generated matrix conformance.
///
/// Each emitted method compares the macro-generated wrapper
/// (`Matrix2x2<Float>`, etc.) against the corresponding native simd matrix
/// (`simd_float2x2`, etc.) on a deterministic sweep of inputs. A failure
/// indicates the generated forwarding doesn't agree with the simd routine.
///
/// We emit XCTest methods rather than `swift-testing` `@Test` methods
/// because the latter's macro expansion fights with nested macro emission:
/// when `@Test` is applied to a method that was itself introduced by an
/// outer macro, the testing library's auto-generated metadata properties
/// can't reference the test function. XCTest's runtime discovery
/// (test method names starting with `test`) sidesteps the conflict.
///
/// Invoke at type scope inside an XCTestCase subclass:
///
///     class Matrix2x2FloatValidationTests: XCTestCase {
///       #generateMatrixConformanceTests(rowCount: 2, columnCount: 2, representation: .float)
///     }
@freestanding(declaration, names: arbitrary)
public macro generateMatrixConformanceTests(
  rowCount: Int,
  columnCount: Int,
  representation: MatrixRepresentation
) = #externalMacro(
  module: "HDXLSIMDSupportMacroPlugin",
  type: "GenerateMatrixConformanceTestsMacro"
)
