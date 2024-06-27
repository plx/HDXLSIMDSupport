import Foundation

extension SIMDMatrixShape {

  
  public func rowVectorTypeName(scalar: SIMDAggregateScalar) -> String {
    rowVectorTypeName(genericParameterName: scalar.swiftTypeName)
  }
  
  public func columnVectorTypeName(scalar: SIMDAggregateScalar) -> String {
    columnVectorTypeName(genericParameterName: scalar.swiftTypeName)
  }
  
  public func diagonalVectorTypeName(scalar: SIMDAggregateScalar) -> String {
    diagonalVectorTypeName(genericParameterName: scalar.swiftTypeName)
  }

  public func rowVectorTypeName(genericParameterName: String = "Scalar") -> String {
    "SIMD\(rowLength)<\(genericParameterName)>"
  }
  
  public func columnVectorTypeName(genericParameterName: String = "Scalar") -> String {
    "SIMD\(columnLength)<\(genericParameterName)>"
  }
  
  public func diagonalVectorTypeName(genericParameterName: String = "Scalar") -> String {
    "SIMD\(diagonalLength)<\(genericParameterName)>"
  }

  public var rowsTypeName: String {
    let interior = (0..<rowCount)
      .lazy
      .map { _ in "RowVector" }
      .joined(separator: ", ")
    return "(\(interior))"
  }
  
  public var columnsTypeName: String {
    let interior = (0..<columnCount)
      .lazy
      .map { _ in "ColumnVector" }
      .joined(separator: ", ")
    return "(\(interior))"
  }

}
