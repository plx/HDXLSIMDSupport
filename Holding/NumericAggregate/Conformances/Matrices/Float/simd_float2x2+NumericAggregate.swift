import Foundation
import simd
import HDXLSIMDSupportProtocols
import HDXLSIMDSupportMacros

extension simd_float2x2 : @retroactive NumericAggregate {
  
  public typealias NumericEntryRepresentation = Float
  
  @inlinable
  public func allNumericEntriesSatisfy(
    _ predicate: (NumericEntryRepresentation) throws -> Bool
  ) rethrows -> Bool {
    try (
      columns.0.allNumericEntriesSatisfy(predicate)
      &&
      columns.1.allNumericEntriesSatisfy(predicate)
    )
  }

}
