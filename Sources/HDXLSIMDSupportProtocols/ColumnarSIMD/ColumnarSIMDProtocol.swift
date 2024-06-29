import Foundation
import simd

package protocol ColumnarSIMDAggregateProtocol<Scalar,SIMDColumn> {
  
  associatedtype Scalar: SIMDScalar
  associatedtype SIMDColumn: SIMD<Scalar>
}

package protocol TwoColumnSIMDAggregateProtocol<Scalar,SIMDColumn> : ColumnarSIMDAggregateProtocol {
  var columns: (SIMDColumn, SIMDColumn) { get set }
  
  init(
    columns: (SIMDColumn, SIMDColumn)
  )
}

package protocol ThreeColumnSIMDAggregateProtocol<Scalar,SIMDColumn> : ColumnarSIMDAggregateProtocol {
  var columns: (SIMDColumn, SIMDColumn, SIMDColumn) { get set }
  
  init(
    columns: (SIMDColumn, SIMDColumn, SIMDColumn)
  )
}

package protocol FourColumnSIMDAggregateProtocol<Scalar,SIMDColumn> : ColumnarSIMDAggregateProtocol {
  var columns: (SIMDColumn, SIMDColumn, SIMDColumn, SIMDColumn) { get set }
  
  init(
    columns: (SIMDColumn, SIMDColumn, SIMDColumn, SIMDColumn)
  )
}

