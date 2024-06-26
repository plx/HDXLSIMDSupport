import Foundation
import HDXLSIMDSupportProtocols

@attached(
  extension,
  conformances: Codable,
  names: named(SerializationKeys), named(encode(into:)), named(init(from:))
)
package macro TwoColumnNativeSIMDCodable() = #externalMacro(
  module: "HDXLSIMDSupportMacrosPlugin",
  type: "TwoColumnNativeSIMDCodableMacro"
)

@attached(
  extension,
  conformances: Codable,
  names: named(SerializationKeys), named(encode(into:)), named(init(from:))
)
package macro ThreeColumnNativeSIMDCodable() = #externalMacro(
  module: "HDXLSIMDSupportMacrosPlugin",
  type: "ThreeColumnNativeSIMDCodableMacro"
)

@attached(
  extension,
  conformances: Codable,
  names: named(SerializationKeys), named(encode(into:)), named(init(from:))
)
package macro FourColumnNativeSIMDCodable() = #externalMacro(
  module: "HDXLSIMDSupportMacrosPlugin",
  type: "FourColumnNativeSIMDCodableMacro"
)
