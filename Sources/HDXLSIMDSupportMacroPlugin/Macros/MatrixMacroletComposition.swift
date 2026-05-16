//
//  MatrixMacroletComposition.swift
//

import SwiftSyntax

/// Composes the ordered list of macrolets that contribute to a matrix
/// conformance, given a descriptor and a layer. Each entry is a slice of the
/// API; together they fill out the entire `MatrixProtocol` (plus the
/// concrete-shape protocols, plus `Hashable`/`Codable`/`Description`/...).
///
/// The ordering here drives the emit order in the generated source. We keep
/// related slices adjacent (typealiases first, then init suite, then arith,
/// then square-matrix-specific bits) so the expanded source remains readable.
enum MatrixMacroletComposition {

  static func macrolets(
    for descriptor: MatrixDescriptor,
    layer: MatrixLayer
  ) -> [any SIMDMatrixMacrolet] {
    var result: [any SIMDMatrixMacrolet] = []

    // 1) Structural: typealiases + storage backing + compat aliases + shape.
    result.append(TypealiasMacrolet(descriptor: descriptor))
    result.append(StorageBackingMacrolet(descriptor: descriptor))
    result.append(NativeSIMDRepresentableMacrolet(descriptor: descriptor))
    result.append(CompatibleMatricesMacrolet(descriptor: descriptor))
    result.append(ShapeConstantsMacrolet(descriptor: descriptor))
    result.append(PositionHelpersMacrolet(descriptor: descriptor))

    // 2) Initialization + subscripting + bulk properties.
    result.append(InitializationMacrolet(descriptor: descriptor))
    result.append(SubscriptingMacrolet(descriptor: descriptor))
    result.append(BulkPropertiesMacrolet(descriptor: descriptor))

    // 3) Componentwise arithmetic (all shapes).
    result.append(NegationMacrolet(descriptor: descriptor))
    result.append(MatrixAdditionMacrolet(descriptor: descriptor))
    result.append(MatrixSubtractionMacrolet(descriptor: descriptor))
    result.append(ScalarAdditionMacrolet(descriptor: descriptor))
    result.append(ScalarSubtractionMacrolet(descriptor: descriptor))
    result.append(FMAMacrolet(descriptor: descriptor))
    result.append(FMSMacrolet(descriptor: descriptor))
    result.append(ScalarMultiplicationMacrolet(descriptor: descriptor))
    result.append(ScalarDivisionMacrolet(descriptor: descriptor))
    result.append(VectorMultiplicationMacrolet(descriptor: descriptor))
    result.append(LinearCombinationMacrolet(descriptor: descriptor))

    // 4) Comparisons / norms.
    result.append(AlmostEqualElementsMacrolet(descriptor: descriptor))
    result.append(ComponentwiseMagnitudeSquaredMacrolet(descriptor: descriptor))

    // 5) Square-matrix-specific (only emit if descriptor is square).
    result.append(TransposeMacrolet(descriptor: descriptor))
    result.append(DeterminantMacrolet(descriptor: descriptor))
    result.append(InversionMacrolet(descriptor: descriptor))
    result.append(QuaternionConstructorMacrolet(descriptor: descriptor))
    result.append(SquareMultiplicationMacrolet(descriptor: descriptor))
    result.append(SquareDivisionMacrolet(descriptor: descriptor))

    // 6) Cross-shape multiplication.
    result.append(CrossShapeMultiplicationMacrolet(descriptor: descriptor))

    // 7) Cross-cutting conformances.
    result.append(NumericAggregateMacrolet(descriptor: descriptor))
    result.append(HashableMacrolet(descriptor: descriptor))
    result.append(CodableMacrolet(descriptor: descriptor))
    result.append(DescriptionMacrolet(descriptor: descriptor))
    result.append(VectorArithmeticMacrolet(descriptor: descriptor))

    _ = layer
    return result
  }
}
