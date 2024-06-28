import Foundation

@usableFromInline
package struct SIMDMatrixTypeDescriptor {
  
  @usableFromInline
  package var scalar: SIMDAggregateScalar
  
  @usableFromInline
  package var shape: SIMDMatrixShape
  
  @inlinable
  package init(
    scalar: SIMDAggregateScalar,
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
  
  @usableFromInline
  package static let allCases: [Self] = {
    var result: [Self] = []
    let allScalars = SIMDAggregateScalar.allCases
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
  
  @inlinable
  package var description: String {
    "(\(String(describing: scalar)), \(String(describing: shape)))"
  }
  
}

extension SIMDMatrixTypeDescriptor: CustomDebugStringConvertible {
  
  @inlinable
  package var debugDescription: String {
    "SIMDMatrixTypeDescriptor(scalar: \(String(describing: scalar)), shape: \(String(describing: shape)))"
  }
  
}

extension SIMDMatrixTypeDescriptor {
  
  @inlinable
  package static func extracting(
    fromSwiftTypeName swiftTypeName: String
  ) -> Self? {
    guard
      let scalar = SIMDAggregateScalar.extracting(
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
  
  @inlinable
  package var nativeSIMDMatrixTypeName: String {
    "simd_\(scalar.simdInfixTypeName)\(shape.typeNameComponent)"
  }
  
}
