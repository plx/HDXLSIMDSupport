import Foundation
import HDXLSIMDSupportProtocols

@attached(
  member,
  names:
    named(QVector),
    named(qVectorRepresentation),
    named(init(qVectorRepresentation:))
)
@attached(
  extension,
  conformances: Codable,
  names:
    named(encode(into:)),
    named(init(from:))
)
package macro AddQVectorSerialization() = #externalMacro(
  module: "HDXLSIMDSupportMacrosPlugin",
  type: "AddQVectorSerializationMacro"
)

@attached(
  member,
  names: 
    named(CompatibleMatrix3x3),
    named(CompatibleMatrix4x4)
)
package macro AddQuaternionCompatibleMatrices() = #externalMacro(
  module: "HDXLSIMDSupportMacrosPlugin",
  type: "AddQuaternionCompatibleMatrixDeclarationsMacro"
)
