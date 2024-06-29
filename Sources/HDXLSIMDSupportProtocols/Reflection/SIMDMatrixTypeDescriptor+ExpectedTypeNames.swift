import Foundation

@usableFromInline
package enum SIMDMatrixTypeNameArchetype {
  
  case publicWrapper
  case publicWrapperWithGenericParameter
  case publicWrapperWithExplicitScalarType
  case scalarStorage
  case nativeSIMD
  
}

@usableFromInline
package enum SIMDMatrixTier {
  case publicWrapper
  case scalarStorage
}

extension SIMDMatrixTypeDescriptor {
  
  @inlinable
  package func expectedTypeName(
    forArchetype archetype: SIMDMatrixTypeNameArchetype
  ) -> String {
    switch archetype {
    case .publicWrapper:
      publicWrapperTypeName
    case .publicWrapperWithGenericParameter:
      publicWrapperWithGenericParameterTypeName
    case .publicWrapperWithExplicitScalarType:
      publicWrapperWithExplicitScalarTypeName
    case .scalarStorage:
      scalarStorageTypeName
    case .nativeSIMD:
      nativeSIMDMatrixTypeName
    }
  }

  @inlinable
  package var publicWrapperTypeName: String {
    "Matrix\(shape.typeNameComponent)"
  }

  @inlinable
  package var publicWrapperWithGenericParameterTypeName: String {
    "Matrix\(shape.typeNameComponent)<Scalar>"
  }
  
  @inlinable
  package var publicWrapperWithExplicitScalarTypeName: String {
    "Matrix\(shape.typeNameComponent)<\(scalar.swiftTypeName)>"
  }
  
  @inlinable
  package var scalarStorageTypeName: String {
    "\(scalar.swiftTypeName)Matrix\(shape.typeNameComponent)Storage"
  }
  
  @inlinable
  package var nativeSIMDMatrixTypeName: String {
    "simd_\(scalar.simdInfixTypeName)\(shape.typeNameComponent)"
  }

  @inlinable
  package func testMethodSuffix(
    forTier tier: SIMDMatrixTier
  ) -> String {
    switch tier {
    case .scalarStorage:
      scalarStorageTypeName
    case .publicWrapper:
      "\(publicWrapperTypeName)_\(scalar.swiftTypeName)"
    }
  }

}
