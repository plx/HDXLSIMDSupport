
extension BinaryFloatingPoint {
  
  @inlinable
  internal func confirmIsNumeric(name: String) throws {
    if isNaN || isSignalingNaN || !isFinite {
      throw DistanceMetricError.nonNumericValue("Encountered non-numeric value: `\(name)`: \(self)!")
    }
  }
  
}
