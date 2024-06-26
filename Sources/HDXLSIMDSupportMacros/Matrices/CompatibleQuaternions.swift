import Foundation
import HDXLSIMDSupportProtocols

@attached(
  member,
  names: named(CompatibleQuaternion)
)
package macro AddCompatibleQuaternion() = #externalMacro(
  module: "HDXLSIMDSupportMacrosPlugin",
  type: "AddCompatibleQuaternionDeclarationsMacro"
)
