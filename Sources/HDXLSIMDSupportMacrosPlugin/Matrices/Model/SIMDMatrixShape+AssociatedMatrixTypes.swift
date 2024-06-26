import Foundation

extension SIMDMatrixShape {

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
      .map { _ in "ColumnCount" }
      .joined(separator: ", ")
    return "(\(interior))"
  }

}
