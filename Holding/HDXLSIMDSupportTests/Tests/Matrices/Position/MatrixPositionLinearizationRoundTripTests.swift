import Testing
import XCTest
import simd
@testable import HDXLSIMDSupport

func validateRoundTrip<Matrix>(
  of matrixPosition: MatrixPosition,
  in matrixType: Matrix.Type
) where Matrix: MatrixProtocol {
  let linearizedScalarIndex = matrixType.linearizedScalarIndex(
    forMatrixPosition: matrixPosition
  )
  let roundTrippedMatrixPosition = matrixType.matrixPosition(
    forLinearizedScalarIndex: linearizedScalarIndex
  )
  #expect(roundTrippedMatrixPosition == matrixPosition)
}

func validateMatrixPositionRoundTrips<Matrix>(
  in matrixType: Matrix.Type
) where Matrix: MatrixProtocol {
  for matrixPosition in matrixType.matrixPositions {
    validateRoundTrip(
      of: matrixPosition,
      in: matrixType
    )
  }
}

func validateRoundTrip<Matrix>(
  of linearizedScalarIndex: Int,
  in matrixType: Matrix.Type
) where Matrix: MatrixProtocol {
  let matrixPosition = matrixType.matrixPosition(
    forLinearizedScalarIndex: linearizedScalarIndex
  )
  let roundTrippedLinearizedScalarIndex = matrixType.linearizedScalarIndex(
    forMatrixPosition: matrixPosition
  )
  #expect(linearizedScalarIndex == roundTrippedLinearizedScalarIndex)
}

func validateLinearizedScalarIndexRoundTrips<Matrix>(
  in matrixType: Matrix.Type
) where Matrix: MatrixProtocol {
  for linearizedScalarIndex in matrixType.linearizedScalarIndexRange {
    validateRoundTrip(
      of: linearizedScalarIndex,
      in: matrixType
    )
  }
}

func validateMatrixPositionLinearization<each Matrix: MatrixProtocol>(
  forMatrixTypes matrixTypes: (repeat (each Matrix).Type)
) {
  for matrixType in repeat each matrixTypes {
    validateMatrixPositionRoundTrips(
      in: matrixType
    )
    validateLinearizedScalarIndexRoundTrips(
      in: matrixType
    )
  }
}

@Test("MatrixPosition linearizations round-trip.")
func testMatrixPositionLinearizationRoundTrips() {
  validateMatrixPositionLinearization(
    forMatrixTypes: (
      Matrix2x2<Float>.self,
      Matrix2x3<Float>.self,
      Matrix2x4<Float>.self,
      Matrix3x2<Float>.self,
      Matrix3x3<Float>.self,
      Matrix3x4<Float>.self,
      Matrix4x2<Float>.self,
      Matrix4x3<Float>.self,
      Matrix4x4<Float>.self,

      Matrix2x2<Double>.self,
      Matrix2x3<Double>.self,
      Matrix2x4<Double>.self,
      Matrix3x2<Double>.self,
      Matrix3x3<Double>.self,
      Matrix3x4<Double>.self,
      Matrix4x2<Double>.self,
      Matrix4x3<Double>.self,
      Matrix4x4<Double>.self
    )
  )
}
