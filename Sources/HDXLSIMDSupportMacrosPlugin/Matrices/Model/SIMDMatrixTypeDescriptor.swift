import Foundation

public struct SIMDMatrixTypeDescriptor {
  
  public var scalar: SIMDMatrixScalar
  public var shape: SIMDMatrixShape
  
  public init(
    scalar: SIMDMatrixScalar,
    shape: SIMDMatrixShape
  ) {
    self.scalar = scalar
    self.shape = shape
  }
}

extension SIMDMatrixTypeDescriptor : Sendable { }
extension SIMDMatrixTypeDescriptor : Equatable { }
extension SIMDMatrixTypeDescriptor : Hashable { }
extension SIMDMatrixTypeDescriptor : Codable { }

extension SIMDMatrixTypeDescriptor : CaseIterable {
  
  public static let allCases: [Self] = {
    var result: [Self] = []
    let allScalars = SIMDMatrixScalar.allCases
    let allShapes = SIMDMatrixShape.allCases
    result.reserveCapacity(allScalars.count * allShapes.count)
    
    for scalar in allScalars {
      for shape in allShapes {
        result.append(
          Self(
            scalar: scalar,
            shape: shape
          )
        )
      }
    }
    
    return result
  }()
}

extension SIMDMatrixTypeDescriptor: CustomStringConvertible {
  
  public var description: String {
    "(\(String(describing: scalar)), \(String(describing: shape)))"
  }
  
}

extension SIMDMatrixTypeDescriptor: CustomDebugStringConvertible {
  
  public var debugDescription: String {
    "SIMDMatrixTypeDescriptor(scalar: \(String(describing: scalar)), shape: \(String(describing: shape)))"
  }
  
}

extension SIMDMatrixTypeDescriptor {
  
  public static func extracting(
    fromSwiftTypeName swiftTypeName: String
  ) -> Self? {
    guard
      let scalar = SIMDMatrixScalar.extracting(
        fromSwiftTypeName: swiftTypeName
      ),
      let shape = SIMDMatrixShape.extracting(
        fromTypeName: swiftTypeName
      )
    else {
      return nil
    }
    
    return Self(
      scalar: scalar,
      shape: shape
    )
  }
  
  public var nativeSIMDMatrixTypeName: String {
    "simd_\(scalar.simdInfixTypeName)\(shape.typeNameComponent)"
  }
  
}
