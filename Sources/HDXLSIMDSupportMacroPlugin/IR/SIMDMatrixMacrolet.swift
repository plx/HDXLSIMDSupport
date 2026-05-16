//
//  SIMDMatrixMacrolet.swift
//

import SwiftSyntax

/// One unit of matrix-related code-generation. A macrolet describes a "slice"
/// of the matrix API — for example, componentwise addition, or determinants —
/// and knows how to:
///
/// 1. emit the SwiftSyntax for the *implementation* of that slice (the
///    `implementationDeclarations` method), and
/// 2. emit the SwiftSyntax for the matching *validation tests* that prove the
///    wrapped implementation matches what the C-level simd routines do
///    (`validationTestDeclarations`).
///
/// A whole matrix conformance is just a list of macrolets, each emitting its
/// slice. The same list drives the test target's generated case suite, which
/// is what makes the test coverage track the implementation 1:1.
///
/// Each conformance has a single `descriptor` baked in — macrolets are
/// instantiated per descriptor and per layer, then consulted at expansion time
/// via a list typed as `[any SIMDMatrixMacrolet]`.
protocol SIMDMatrixMacrolet {

  /// Emit the declarations that implement this slice of the matrix API for
  /// the layer described by `context`.
  ///
  /// - Returns: an array of `DeclSyntax`. Empty is fine — a macrolet that
  ///   only contributes tests (or that's a no-op at a given layer) may return
  ///   an empty array here.
  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax]

  /// Emit the declarations that validate this slice of the matrix API for
  /// the layer described by `context`.
  ///
  /// - Returns: an array of `DeclSyntax`, expected to be `@Test`-annotated
  ///   `swift-testing` functions. Empty is fine — many "structural" macrolets
  ///   (shape constants, type aliases) have no behavior worth validating.
  func validationTestDeclarations(in context: MatrixLayerContext) -> [DeclSyntax]
}

/// Default-empty validation. Override only when there's something meaningful
/// to test.
extension SIMDMatrixMacrolet {
  func validationTestDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    []
  }
}
