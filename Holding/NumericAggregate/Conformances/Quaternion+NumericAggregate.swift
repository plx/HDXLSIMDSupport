import Foundation
import simd
import HDXLSIMDSupportProtocols

// -------------------------------------------------------------------------- //
// MARK: simd_quatf - NumericAggregate
// -------------------------------------------------------------------------- //

extension simd_quatf : @retroactive NumericAggregate {
  
  public typealias NumericEntryRepresentation = Float
  
  @inlinable
  public func allNumericEntriesSatisfy(
    _ predicate: (NumericEntryRepresentation) throws -> Bool
  ) rethrows -> Bool {
    try (
      predicate(real)
      &&
      imag.allNumericEntriesSatisfy(predicate)
    )
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: simd_quatd - NumericAggregate
// -------------------------------------------------------------------------- //

extension simd_quatd : @retroactive NumericAggregate {
  
  public typealias NumericEntryRepresentation = Double
  
  @inlinable
  public func allNumericEntriesSatisfy(
    _ predicate: (NumericEntryRepresentation) throws -> Bool
  ) rethrows -> Bool {
    try (
      predicate(real)
      &&
      imag.allNumericEntriesSatisfy(predicate)
    )
  }

}
