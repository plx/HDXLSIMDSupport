import Foundation

@usableFromInline
package enum ThreeColumnCodingKey: String, CodingKey {
  
  case c0 = "c0"
  case c1 = "c1"
  case c2 = "c2"
  
  @inlinable
  package var intValue: Int? {
    switch self {
    case .c0: 0
    case .c1: 1
    case .c2: 2
    }
  }
  
  @inlinable
  package init?(intValue: Int) {
    switch intValue {
    case 0: 
      self = .c0
    case 1:
      self = .c1
    case 2:
      self = .c2
    default:
      return nil
    }
  }
  
}

