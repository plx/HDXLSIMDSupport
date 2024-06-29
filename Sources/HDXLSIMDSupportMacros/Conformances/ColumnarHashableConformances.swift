import Foundation
import HDXLSIMDSupportProtocols

@attached(
  extension,
  conformances: Hashable,
  names: named(hash(into:))
)
package macro TwoColumnNativeSIMDHashable() = #externalMacro(
  module: "HDXLSIMDSupportMacrosPlugin",
  type: "TwoColumnNativeSIMDHashableMacro"
)

@attached(
  extension,
  conformances: Hashable,
  names: named(hash(into:))
)
package macro ThreeColumnNativeSIMDHashable() = #externalMacro(
  module: "HDXLSIMDSupportMacrosPlugin",
  type: "ThreeColumnNativeSIMDHashableMacro"
)

@attached(
  extension,
  conformances: Hashable,
  names: named(hash(into:))
)
package macro FourColumnNativeSIMDHashable() = #externalMacro(
  module: "HDXLSIMDSupportMacrosPlugin",
  type: "FourColumnNativeSIMDHashableMacro"
)
