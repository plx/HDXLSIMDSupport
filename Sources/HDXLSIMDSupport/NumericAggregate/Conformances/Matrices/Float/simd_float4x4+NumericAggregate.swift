import Foundation
import simd
import HDXLSIMDSupportProtocols

extension simd_float4x4 : @retroactive NumericAggregate {
  
  public typealias NumericEntryRepresentation = Float
  
  @inlinable
  public func allNumericEntriesSatisfy(
    _ predicate: (NumericEntryRepresentation) throws -> Bool
  ) rethrows -> Bool {
    try (
      columns.0.allNumericEntriesSatisfy(predicate)
      &&
      columns.1.allNumericEntriesSatisfy(predicate)
      &&
      columns.2.allNumericEntriesSatisfy(predicate)
      &&
      columns.3.allNumericEntriesSatisfy(predicate)
    )
  }

}
