import Foundation

public enum SIMDMatrixShape: Int {
  
  case _2x2 = 22
  case _2x3 = 23
  case _2x4 = 24
  case _3x2 = 32
  case _3x3 = 33
  case _3x4 = 34
  case _4x2 = 42
  case _4x3 = 43
  case _4x4 = 44
  
}

extension SIMDMatrixShape: Sendable { }
extension SIMDMatrixShape: Equatable { }
extension SIMDMatrixShape: Hashable { }
extension SIMDMatrixShape: CaseIterable { }
extension SIMDMatrixShape: Codable { }

extension SIMDMatrixShape: Comparable {
  public static func < (
    lhs: Self,
    rhs: Self
  ) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
}

extension SIMDMatrixShape: Identifiable {
  public typealias ID = Self
  
  public var id: ID { self }
}

extension SIMDMatrixShape: CustomStringConvertible {
  
  public var description: String {
    typeNameComponent
  }
  
}

extension SIMDMatrixShape: CustomDebugStringConvertible {

  public var debugDescription: String {
    switch self {
    case ._2x2:
      "SIMDMatrixShape._2x2"
    case ._2x3:
      "SIMDMatrixShape._2x3"
    case ._2x4:
      "SIMDMatrixShape._2x4"
    case ._3x2:
      "SIMDMatrixShape._3x2"
    case ._3x3:
      "SIMDMatrixShape._3x3"
    case ._3x4:
      "SIMDMatrixShape._3x4"
    case ._4x2:
      "SIMDMatrixShape._4x2"
    case ._4x3:
      "SIMDMatrixShape._4x3"
    case ._4x4:
      "SIMDMatrixShape._4x4"
    }
  }
  
}

extension SIMDMatrixShape {
  
  /// This shape's representation within type names, e.g. the `4x4` within `simd_float4x4`.
  public var typeNameComponent: String {
    switch self {
    case ._2x2:
      "2x2"
    case ._2x3:
      "2x3"
    case ._2x4:
      "2x4"
    case ._3x2:
      "3x2"
    case ._3x3:
      "3x3"
    case ._3x4:
      "3x4"
    case ._4x2:
      "4x2"
    case ._4x3:
      "4x3"
    case ._4x4:
      "4x4"
    }
  }

}

extension SIMDMatrixShape {
  
  static func extracting(fromTypeName typeName: String) -> Self? {
    guard typeName.count >= 3 else {
      return nil
    }
    
    for candidate in allCases where typeName.contains(candidate.typeNameComponent) {
      return candidate
    }
    
    return nil
  }
  
}

extension SIMDMatrixShape {
  
  public var columnCount: Int {
    switch self {
    case ._2x2:
      2
    case ._2x3:
      2
    case ._2x4:
      2
    case ._3x2:
      3
    case ._3x3:
      3
    case ._3x4:
      3
    case ._4x2:
      4
    case ._4x3:
      4
    case ._4x4:
      4
    }
  }
  
  public var rowCount: Int {
    switch self {
    case ._2x2:
      2
    case ._2x3:
      3
    case ._2x4:
      4
    case ._3x2:
      2
    case ._3x3:
      3
    case ._3x4:
      4
    case ._4x2:
      2
    case ._4x3:
      3
    case ._4x4:
      4
    }
  }

  public var rowLength: Int {
    switch self {
    case ._2x2:
      2
    case ._2x3:
      2
    case ._2x4:
      2
    case ._3x2:
      3
    case ._3x3:
      3
    case ._3x4:
      3
    case ._4x2:
      4
    case ._4x3:
      4
    case ._4x4:
      4
    }
  }
  
  public var columnLength: Int {
    switch self {
    case ._2x2:
      2
    case ._2x3:
      3
    case ._2x4:
      4
    case ._3x2:
      2
    case ._3x3:
      3
    case ._3x4:
      4
    case ._4x2:
      2
    case ._4x3:
      3
    case ._4x4:
      4
    }
  }
  
  public var isCompatibleWithQuaternions: Bool {
    switch self {
    case ._3x3, ._4x4:
      return true
    default:
      return false
    }
  }

  public var diagonalLength: Int {
    Swift.min(rowLength, columnLength)
  }
  
  public var isSquare: Bool {
    switch self {
    case ._2x2, ._3x3, ._4x4:
      true
    default:
      false
    }
  }
  
  public var transpose: Self {
    switch self {
    case ._2x2:
      ._2x2
    case ._2x3:
      ._3x2
    case ._2x4:
      ._4x2
    case ._3x2:
      ._2x3
    case ._3x3:
      ._3x3
    case ._3x4:
      ._4x3
    case ._4x2:
      ._2x4
    case ._4x3:
      ._3x4
    case ._4x4:
      ._4x4
    }
  }
  
  public var allAxisLengths: Set<Int> {
    [ rowCount, columnCount ]
  }
  
  public func isCompatible(with other: Self) -> Bool {
    !allAxisLengths.isDisjoint(with: other.allAxisLengths)
  }
  
  public var allCompatibleMatrixShapes: Set<Self> {
    Set(
      Self
      .allCases
      .filter { otherShape in
        self != otherShape
        &&
        isCompatible(with: otherShape)
      }
    )
  }
  
  public var allCompatibleMatrixShapesInAestheticOrdering: [Self] {
    let allCompatibleMatrixShapes = allCompatibleMatrixShapes
    let shapesOrderedAscending = allCompatibleMatrixShapes.sorted()
    
    var shapesOrderedAesthetically: [Self] = []
    shapesOrderedAesthetically.reserveCapacity(shapesOrderedAscending.count)
    
    var unhandledShapes = allCompatibleMatrixShapes
    for compatibleShape in shapesOrderedAscending where unhandledShapes.contains(compatibleShape) {
      shapesOrderedAesthetically.append(compatibleShape)
      unhandledShapes.remove(compatibleShape)
      if !compatibleShape.isSquare {
        let transposedCompatibleShape = compatibleShape.transpose
        shapesOrderedAesthetically.append(transposedCompatibleShape.transpose)
        unhandledShapes.remove(transposedCompatibleShape.transpose)
      }
    }
    
    assert(shapesOrderedAesthetically.count == shapesOrderedAscending.count)
    return shapesOrderedAesthetically
  }
  
}
