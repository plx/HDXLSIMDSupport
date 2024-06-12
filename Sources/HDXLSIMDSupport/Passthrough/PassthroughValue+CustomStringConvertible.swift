import Foundation

extension Passthrough where Self: CustomStringConvertible {
  
  @inlinable
  public var description: String {
    String(describing: passthroughValue)
  }
  
}
