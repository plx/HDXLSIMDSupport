//
//  QuaternionMacroletComposition.swift
//

import SwiftSyntax

enum QuaternionMacroletComposition {
  static func macrolets(
    for descriptor: QuaternionDescriptor,
    layer: MatrixLayer
  ) -> [any SIMDQuaternionMacrolet] {
    var result: [any SIMDQuaternionMacrolet] = []
    result.append(QuaternionTypealiasesMacrolet(descriptor: descriptor))
    result.append(QuaternionStorageBackingMacrolet(descriptor: descriptor))
    result.append(QuaternionNativeSIMDRepresentableMacrolet(descriptor: descriptor))
    result.append(QuaternionInitializationMacrolet(descriptor: descriptor))
    result.append(QuaternionInterpolationMacrolet(descriptor: descriptor))
    result.append(QuaternionBasicPropertiesMacrolet(descriptor: descriptor))
    result.append(QuaternionUnaryOperationsMacrolet(descriptor: descriptor))
    result.append(QuaternionArithmeticMacrolet(descriptor: descriptor))
    result.append(QuaternionNumericAggregateMacrolet(descriptor: descriptor))
    result.append(QuaternionHashableMacrolet(descriptor: descriptor))
    result.append(QuaternionCodableMacrolet(descriptor: descriptor))
    result.append(QuaternionDescriptionMacrolet(descriptor: descriptor))
    result.append(QuaternionVectorArithmeticMacrolet(descriptor: descriptor))
    _ = layer
    return result
  }
}
