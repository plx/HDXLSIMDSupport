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

// MARK: AddMatrixRowsAndColumns

@attached(
  member,
  names: 
    named(RowVector),
    named(ColumnVector),
    named(DiagonalVector),
    named(Rows),
    named(Columns)
)
package macro AddMatrixRowsAndColumns() = #externalMacro(
  module: "HDXLSIMDSupportMacrosPlugin",
  type: "AddMatrixRowsAndColumnsMacro"
)

// MARK: AddInferredScalar

@attached(
  member,
  names: named(Scalar)
)
package macro AddInferredScalar() = #externalMacro(
  module: "HDXLSIMDSupportMacrosPlugin",
  type: "AddInferredScalarMacro"
)


