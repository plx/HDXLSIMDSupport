import Foundation
import HDXLSIMDSupportProtocols

// MARK: StorageNumericAggregate

@attached(
  extension,
  conformances: NumericAggregate,
  names: named(allNumericEntriesSatisfy(_:)), named(NumericEntryRepresentation)
)
package macro StorageNumericAggregate() = #externalMacro(
  module: "HDXLSIMDSupportMacrosPlugin",
  type: "StorageNumericAggregateMacro"
)

// MARK: Columnar Aggregates

@attached(
  extension,
  conformances: NumericAggregate,
  names: named(allNumericEntriesSatisfy(_:)), named(NumericEntryRepresentation)
)
package macro TwoColumnNumericAggregate() = #externalMacro(
  module: "HDXLSIMDSupportMacrosPlugin",
  type: "TwoColumnNumericAggregateMacro"
)

@attached(
  extension,
  conformances: NumericAggregate,
  names: named(allNumericEntriesSatisfy(_:)), named(NumericEntryRepresentation)
)
package macro ThreeColumnNumericAggregate() = #externalMacro(
  module: "HDXLSIMDSupportMacrosPlugin",
  type: "ThreeColumnNumericAggregateMacro"
)

@attached(
  extension,
  conformances: NumericAggregate,
  names: named(allNumericEntriesSatisfy(_:)), named(NumericEntryRepresentation)
)
package macro FourColumnNumericAggregate() = #externalMacro(
  module: "HDXLSIMDSupportMacrosPlugin",
  type: "FourColumnNumericAggregateMacro"
)

