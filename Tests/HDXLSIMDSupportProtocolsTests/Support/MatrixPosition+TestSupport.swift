import HDXLSIMDSupportProtocols

extension MatrixPosition {
  
  static let allValidMatrixPositions: [MatrixPosition] = [MatrixPosition].allValidMatrixPositions
}

extension [MatrixPosition] {
  
  static let allValidMatrixPositions: [MatrixPosition] = {
    var result: [MatrixPosition] = []
    result.reserveCapacity(9)
    for rowIndex in 0..<3 {
      for columnIndex in 0..<3 {
        result.append(
          MatrixPosition(
            rowIndex: rowIndex,
            columnIndex: columnIndex
          )
        )
      }
    }
    
    return result
  }()
  
  
}
