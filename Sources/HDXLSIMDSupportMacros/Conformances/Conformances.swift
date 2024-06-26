import Foundation
import SwiftUI
import HDXLSIMDSupportProtocols

//@freestanding(declaration, names: arbitrary)
//public macro ExtendedSIMDScalar<T:BinaryFloatingPoint>() = #externalMacro(
//  module: "HDXLSIMDSupportMacrosPlugin",
//  type: "ExtendedSIMDScalarMacro"
//)
//

@attached(extension, conformances: ExtendedSIMDScalar, names: arbitrary)
public macro ExtendedSIMDScalar() = #externalMacro(
  module: "HDXLSIMDSupportMacrosPlugin",
  type: "ExtendedSIMDScalarMacro"
)

// MARK: SwiftUIVectorArithmetic

@attached(
  extension,
  conformances: VectorArithmetic,
  names: named(magnitudeSquared), named(scale(by:))
)
package macro SwiftUIVectorArithmetic() = #externalMacro(
  module: "HDXLSIMDSupportMacrosPlugin",
  type: "SwiftUIVectorArithmeticMacro"
)

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

// MARK: NumericAggregate

@attached(
  extension,
  conformances: NumericAggregate,
  names: named(allNumericEntriesSatisfy(_:)), named(NumericEntryRepresentation)
)
package macro StorageNumericAggregate() = #externalMacro(
  module: "HDXLSIMDSupportMacrosPlugin",
  type: "StorageNumericAggregateMacro"
)

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

// MARK: Hashable

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

// MARK: Codable

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
  conformances: Hashable,
  names: named(hash(into:))
)
package macro ThreeColumnNativeSIMDCodable() = #externalMacro(
  module: "HDXLSIMDSupportMacrosPlugin",
  type: "ThreeColumnNativeSIMDCodableMacro"
)

@attached(
  extension,
  conformances: Hashable,
  names: named(hash(into:))
)
package macro FourColumnNativeSIMDCodable() = #externalMacro(
  module: "HDXLSIMDSupportMacrosPlugin",
  type: "FourColumnNativeSIMDCodableMacro"
)
