import Foundation
import SwiftUI
import HDXLSIMDSupportProtocols

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
