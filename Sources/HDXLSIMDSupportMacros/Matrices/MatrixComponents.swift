import Foundation
import SwiftUI
import HDXLSIMDSupportProtocols

// MARK: AddMatrixStorage

@attached(
  member,
  names: named(Storage), named(storage), named(init(storage:))
)
package macro AddMatrixStorage() = #externalMacro(
  module: "HDXLSIMDSupportMacrosPlugin",
  type: "AddMatrixStorageMacro"
)

@attached(
  member,
  names: named(Storage), named(storage), named(init(storage:))
)
package macro AddNativeSIMDBacking() = #externalMacro(
  module: "HDXLSIMDSupportMacrosPlugin",
  type: "AddNativeSIMDBackingMacro"
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

// MARK: 2xN - Add Compatible

@attached(
  member,
  names: 
    named(CompatibleMatrix2x3),
    named(CompatibleMatrix3x2),
    named(CompatibleMatrix2x4),
    named(CompatibleMatrix4x2)
)
package macro Add2x2CompatibleMatrices() = #externalMacro(
  module: "HDXLSIMDSupportMacrosPlugin",
  type: "AddCompatibleMatrixDeclarationsMacro"
)

@attached(
  member,
  names:
    named(CompatibleMatrix2x2),
    named(CompatibleMatrix3x3),
    named(CompatibleMatrix3x2),
    named(CompatibleMatrix2x4),
    named(CompatibleMatrix4x2),
    named(CompatibleMatrix3x4),
    named(CompatibleMatrix4x3)
)
package macro Add2x3CompatibleMatrices() = #externalMacro(
  module: "HDXLSIMDSupportMacrosPlugin",
  type: "AddCompatibleMatrixDeclarationsMacro"
)

@attached(
  member,
  names:
    named(CompatibleMatrix2x2),
    named(CompatibleMatrix4x4),
    named(CompatibleMatrix2x3),
    named(CompatibleMatrix4x2),
    named(CompatibleMatrix3x2),
    named(CompatibleMatrix3x4),
    named(CompatibleMatrix4x3)
)
package macro Add2x4CompatibleMatrices() = #externalMacro(
  module: "HDXLSIMDSupportMacrosPlugin",
  type: "AddCompatibleMatrixDeclarationsMacro"
)

// MARK: 3xN - Add Compatible

@attached(
  member,
  names:
    named(CompatibleMatrix2x2),
    named(CompatibleMatrix3x3),
    named(CompatibleMatrix2x3),
    named(CompatibleMatrix2x4),
    named(CompatibleMatrix4x2),
    named(CompatibleMatrix3x4),
    named(CompatibleMatrix4x3)
)
package macro Add3x2CompatibleMatrices() = #externalMacro(
  module: "HDXLSIMDSupportMacrosPlugin",
  type: "AddCompatibleMatrixDeclarationsMacro"
)

@attached(
  member,
  names:
    named(CompatibleMatrix2x3),
    named(CompatibleMatrix3x2),
    named(CompatibleMatrix3x4),
    named(CompatibleMatrix4x3)
)
package macro Add3x3CompatibleMatrices() = #externalMacro(
  module: "HDXLSIMDSupportMacrosPlugin",
  type: "AddCompatibleMatrixDeclarationsMacro"
)

@attached(
  member,
  names:
    named(CompatibleMatrix4x4),
    named(CompatibleMatrix3x3),
    named(CompatibleMatrix2x3),
    named(CompatibleMatrix3x2),
    named(CompatibleMatrix2x4),
    named(CompatibleMatrix4x2),
    named(CompatibleMatrix4x3)
)
package macro Add3x4CompatibleMatrices() = #externalMacro(
  module: "HDXLSIMDSupportMacrosPlugin",
  type: "AddCompatibleMatrixDeclarationsMacro"
)

// MARK: 4xN - Add Compatible

@attached(
  member,
  names:
    named(CompatibleMatrix4x4),
    named(CompatibleMatrix2x2),
    named(CompatibleMatrix2x3),
    named(CompatibleMatrix3x2),
    named(CompatibleMatrix2x4),
    named(CompatibleMatrix3x4),
    named(CompatibleMatrix4x3)
)
package macro Add4x2CompatibleMatrices() = #externalMacro(
  module: "HDXLSIMDSupportMacrosPlugin",
  type: "AddCompatibleMatrixDeclarationsMacro"
)

@attached(
  member,
  names:
    named(CompatibleMatrix4x4),
    named(CompatibleMatrix3x3),
    named(CompatibleMatrix2x3),
    named(CompatibleMatrix3x2),
    named(CompatibleMatrix2x4),
    named(CompatibleMatrix4x2),
    named(CompatibleMatrix3x4)
)
package macro Add4x3CompatibleMatrices() = #externalMacro(
  module: "HDXLSIMDSupportMacrosPlugin",
  type: "AddCompatibleMatrixDeclarationsMacro"
)

@attached(
  member,
  names:
    named(CompatibleMatrix2x4),
    named(CompatibleMatrix4x2),
    named(CompatibleMatrix3x4),
    named(CompatibleMatrix4x3)
)
package macro Add4x4CompatibleMatrices() = #externalMacro(
  module: "HDXLSIMDSupportMacrosPlugin",
  type: "AddCompatibleMatrixDeclarationsMacro"
)
