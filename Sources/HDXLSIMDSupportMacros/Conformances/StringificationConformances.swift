import Foundation
import HDXLSIMDSupportProtocols

// MARK: DescriptionFromStorage

@attached(
  extension,
  conformances: CustomStringConvertible,
  names: named(description)
)
package macro DescriptionFromStorage() = #externalMacro(
  module: "HDXLSIMDSupportMacrosPlugin",
  type: "DescriptionFromStorageMacro"
)

// MARK: DescriptionFromStorage

@attached(
  extension,
  conformances: CustomDebugStringConvertible,
  names: named(debugDescription)
)
package macro DebugDescriptionFromNativeSIMDRepresentation() = #externalMacro(
  module: "HDXLSIMDSupportMacrosPlugin",
  type: "DebugDescriptionFromNativeSIMDRepresentationMacro"
)
