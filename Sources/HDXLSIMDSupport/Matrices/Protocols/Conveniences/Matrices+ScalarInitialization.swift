//
//  Matrices+ScalarInitialization.swift
//

import Foundation
import simd

// -------------------------------------------------------------------------- //
// MARK: Scalar Construction Support
// -------------------------------------------------------------------------- //

internal extension MatrixProtocol {
  
  /// Validates the *shape* of `scalars` vis-a-vis the shape of `Self`.
  @inlinable
  static func canConstruct(from scalars: [[Scalar]]) -> Bool {
    guard
      scalars.count == Self.rowCount,
      scalars.allSatisfy({ $0.count == Self.columnCount })
    else {
      return false
    }
    return true
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: 2x2 Scalar Construction
// -------------------------------------------------------------------------- //

public extension Matrix2x2Protocol {
  
  @inlinable
  init(scalars: [[Scalar]]) {
    precondition(Self.canConstruct(from: scalars))
    self.init(
      columns: (
        ColumnVector(
          scalars[0][0],
          scalars[1][0]
        ),
        ColumnVector(
          scalars[0][1],
          scalars[1][1]
        )
      )
    )
  }
    
}

// -------------------------------------------------------------------------- //
// MARK: 2x3 Scalar Construction
// -------------------------------------------------------------------------- //

public extension Matrix2x3Protocol {
  
  @inlinable
  init(scalars: [[Scalar]]) {
    precondition(Self.canConstruct(from: scalars))
    self.init(
      columns: (
        ColumnVector(
          scalars[0][0],
          scalars[1][0],
          scalars[2][0]
        ),
        ColumnVector(
          scalars[0][1],
          scalars[1][1],
          scalars[2][1]
        )
      )
    )
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: 2x4 Scalar Construction
// -------------------------------------------------------------------------- //

public extension Matrix2x4Protocol {
  
  @inlinable
  init(scalars: [[Scalar]]) {
    precondition(Self.canConstruct(from: scalars))
    self.init(
      columns: (
        ColumnVector(
          scalars[0][0],
          scalars[1][0],
          scalars[2][0],
          scalars[3][0]
        ),
        ColumnVector(
          scalars[0][1],
          scalars[1][1],
          scalars[2][1],
          scalars[3][1]
        )
      )
    )
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: 3x2 Scalar Construction
// -------------------------------------------------------------------------- //

public extension Matrix3x2Protocol {
  
  @inlinable
  init(scalars: [[Scalar]]) {
    precondition(Self.canConstruct(from: scalars))
    self.init(
      columns: (
        ColumnVector(
          scalars[0][0],
          scalars[1][0]
        ),
        ColumnVector(
          scalars[0][1],
          scalars[1][1]
        ),
        ColumnVector(
          scalars[0][2],
          scalars[1][2]
        )
      )
    )
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: 3x3 Scalar Construction
// -------------------------------------------------------------------------- //

public extension Matrix3x3Protocol {
  
  @inlinable
  init(scalars: [[Scalar]]) {
    precondition(Self.canConstruct(from: scalars))
    self.init(
      columns: (
        ColumnVector(
          scalars[0][0],
          scalars[1][0],
          scalars[2][0]
        ),
        ColumnVector(
          scalars[0][1],
          scalars[1][1],
          scalars[2][1]
        ),
        ColumnVector(
          scalars[0][2],
          scalars[1][2],
          scalars[2][2]
        )
      )
    )
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: 3x4 Scalar Construction
// -------------------------------------------------------------------------- //

public extension Matrix3x4Protocol {
  
  @inlinable
  init(scalars: [[Scalar]]) {
    precondition(Self.canConstruct(from: scalars))
    self.init(
      columns: (
        ColumnVector(
          scalars[0][0],
          scalars[1][0],
          scalars[2][0],
          scalars[3][0]
        ),
        ColumnVector(
          scalars[0][1],
          scalars[1][1],
          scalars[2][1],
          scalars[3][1]
        ),
        ColumnVector(
          scalars[0][2],
          scalars[1][2],
          scalars[2][2],
          scalars[3][2]
        )
      )
    )
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: 4x2 Scalar Construction
// -------------------------------------------------------------------------- //

public extension Matrix4x2Protocol {
  
  @inlinable
  init(scalars: [[Scalar]]) {
    precondition(Self.canConstruct(from: scalars))
    self.init(
      columns: (
        ColumnVector(
          scalars[0][0],
          scalars[1][0]
        ),
        ColumnVector(
          scalars[0][1],
          scalars[1][1]
        ),
        ColumnVector(
          scalars[0][2],
          scalars[1][2]
        ),
        ColumnVector(
          scalars[0][3],
          scalars[1][3]
        )
      )
    )
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: 4x3 Scalar Construction
// -------------------------------------------------------------------------- //

public extension Matrix4x3Protocol {
  
  @inlinable
  init(scalars: [[Scalar]]) {
    precondition(Self.canConstruct(from: scalars))
    self.init(
      columns: (
        ColumnVector(
          scalars[0][0],
          scalars[1][0],
          scalars[2][0]
        ),
        ColumnVector(
          scalars[0][1],
          scalars[1][1],
          scalars[2][1]
        ),
        ColumnVector(
          scalars[0][2],
          scalars[1][2],
          scalars[2][2]
        ),
        ColumnVector(
          scalars[0][3],
          scalars[1][3],
          scalars[2][3]
        )
      )
    )
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: 4x4 Scalar Construction
// -------------------------------------------------------------------------- //

public extension Matrix4x4Protocol {
  
  @inlinable
  init(scalars: [[Scalar]]) {
    precondition(Self.canConstruct(from: scalars))
    self.init(
      columns: (
        ColumnVector(
          scalars[0][0],
          scalars[1][0],
          scalars[2][0],
          scalars[3][0]
        ),
        ColumnVector(
          scalars[0][1],
          scalars[1][1],
          scalars[2][1],
          scalars[3][1]
        ),
        ColumnVector(
          scalars[0][2],
          scalars[1][2],
          scalars[2][2],
          scalars[3][2]
        ),
        ColumnVector(
          scalars[0][3],
          scalars[1][3],
          scalars[2][3],
          scalars[3][3]
        )
      )
    )
  }
  
}
