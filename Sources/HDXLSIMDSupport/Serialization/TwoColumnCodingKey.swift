import Foundation

@usableFromInline
package enum TwoColumnCodingKey: String, CodingKey {
  
  case c0 = "c0"
  case c1 = "c1"
  
  @inlinable
  package var intValue: Int? {
    switch self {
    case .c0: 0
    case .c1: 1
    }
  }
  
  @inlinable
  package init?(intValue: Int) {
    switch intValue {
    case 0: 
      self = .c0
    case 1:
      self = .c1
    default:
      return nil
    }
  }
  
}

