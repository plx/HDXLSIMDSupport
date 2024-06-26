import Foundation
import HDXLSIMDSupportProtocols

// MARK: NativeSIMDRepresentable

@attached(
  extension,
  conformances: NativeSIMDRepresentable,
  names: named(NativeSIMDRepresentation), named(nativeSIMDRepresentation), named(init(nativeSIMDRepresentation:))
)
package macro StorageNativeSIMDRepresentable() = #externalMacro(
  module: "HDXLSIMDSupportMacrosPlugin",
  type: "StorageNativeSIMDRepresentableMacro"
)

// MARK: AddNativeSIMDBacking

@attached(
  member,
  names: named(Storage), named(storage), named(init(storage:))
)
@attached(
  extension,
  conformances: NativeSIMDRepresentable,
  names: named(NativeSIMDRepresentation), named(nativeSIMDRepresentation), named(init(nativeSIMDRepresentation:))
)
package macro AddNativeSIMDBacking() = #externalMacro(
  module: "HDXLSIMDSupportMacrosPlugin",
  type: "AddNativeSIMDBackingMacro"
)
