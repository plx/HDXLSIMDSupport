import Foundation

extension Passthrough where Self: CustomDebugStringConvertible {
  
  @inlinable
  public var debugDescription: String {
    "\(String(reflecting: type(of: self)))(passthroughValue:\(String(reflecting: passthroughValue)))"
  }
  
}
