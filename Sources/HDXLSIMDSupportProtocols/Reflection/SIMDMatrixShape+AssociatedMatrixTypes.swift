import Foundation

extension SIMDMatrixShape {
  
  @inlinable
  package func rowVectorTypeName(scalar: SIMDAggregateScalar) -> String {
    rowVectorTypeName(genericParameterName: scalar.swiftTypeName)
  }
  
  @inlinable
  package func columnVectorTypeName(scalar: SIMDAggregateScalar) -> String {
    columnVectorTypeName(genericParameterName: scalar.swiftTypeName)
  }
  
  @inlinable
  package func diagonalVectorTypeName(scalar: SIMDAggregateScalar) -> String {
    diagonalVectorTypeName(genericParameterName: scalar.swiftTypeName)
  }

  @inlinable
  package func rowVectorTypeName(genericParameterName: String = "Scalar") -> String {
    "SIMD\(rowLength)<\(genericParameterName)>"
  }
  
  @inlinable
  package func columnVectorTypeName(genericParameterName: String = "Scalar") -> String {
    "SIMD\(columnLength)<\(genericParameterName)>"
  }
  
  @inlinable
  package func diagonalVectorTypeName(genericParameterName: String = "Scalar") -> String {
    "SIMD\(diagonalLength)<\(genericParameterName)>"
  }

  @inlinable
  package var rowsTypeName: String {
    let interior = (0..<rowCount)
      .lazy
      .map { _ in "RowVector" }
      .joined(separator: ", ")
    return "(\(interior))"
  }
  
  @inlinable
  package var columnsTypeName: String {
    let interior = (0..<columnCount)
      .lazy
      .map { _ in "ColumnVector" }
      .joined(separator: ", ")
    return "(\(interior))"
  }

}
