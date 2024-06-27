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

// MARK: AddNativeSIMDMatrixBacking

@attached(
  member,
  names: named(Storage), named(storage), named(init(storage:))
)
@attached(
  extension,
  conformances: NativeSIMDRepresentable,
  names: named(NativeSIMDRepresentation), named(nativeSIMDRepresentation), named(init(nativeSIMDRepresentation:))
)
package macro AddNativeSIMDMatrixBacking() = #externalMacro(
  module: "HDXLSIMDSupportMacrosPlugin",
  type: "AddNativeSIMDMatrixBackingMacro"
)

// MARK: AddNativeSIMDQuaternionBacking

@attached(
  member,
  names: named(Storage), named(storage), named(init(storage:))
)
@attached(
  extension,
  conformances: NativeSIMDRepresentable,
  names: named(NativeSIMDRepresentation), named(nativeSIMDRepresentation), named(init(nativeSIMDRepresentation:))
)
package macro AddNativeSIMDQuaternionBacking() = #externalMacro(
  module: "HDXLSIMDSupportMacrosPlugin",
  type: "AddNativeSIMDQuaternionBackingMacro"
)
