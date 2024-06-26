import Foundation
import simd

// ------------------------------------------------------------------------ //
// MARK: MatrixProtocol - Supporting Defines
// ------------------------------------------------------------------------ //

/// Shorthand for a 2-tuple with all types identically-`T`.
public typealias T2<T> = (T,T)

/// Shorthand for a 3-tuple with all types identically-`T`.
public typealias T3<T> = (T,T,T)

/// Shorthand for a 4-tuple with all types identically-`T`.
public typealias T4<T> = (T,T,T,T)

// ------------------------------------------------------------------------ //
// MARK: MatrixProtocol - Definition
// ------------------------------------------------------------------------ //

/// Basic protocol for *adoption* by (a) the native SIMD matrices, (b) the "storage" types, and (c) the generic
/// wrappers *around* those types. The design is somewhat artificial because on the one hand (a) I want to
/// use `extension Passthrough where PassthroughValue:MatrixProtocol` to minimize the
/// repetive boilerplate I need to write, but (b) the native SIMD types implement their math operations as
/// *operators* and thus defining operators directly, here, risks shadowing/ambiguity/etc. (e.g.: annoyances).
///
/// So the final *conformances* will look like this:
///
/// - native-simd types: `MatrixProtocol`
/// - storage types: `MatrixProtocol` + `MatrixOperatorSupportProtocol`
/// - matrix types: `MatrixProtocol` + `MatrixOperatorSupportProtocol`
///
/// ...with a similar *conformance* pattern applying to the size-specific protocol refinements.
///
/// Secondly, note that numerous early designs (a) had a fine-grained protocol hierarchy but (b) something
/// about that lead to multi-hour compilation times (and SourceKitService using, no joke, 56gb of RAM—or more!—
/// just while trying to edit the thing). As a work-around I've simplified-and-flattened the protocol hierarchy, which
/// makes it a bit more boilerplate-ish—and a bit less abstract/elegant—but I want tihs to be usable...it is what it is.
///
/// As an example of what's lost, though, there used to be protocols for square vs non-square matrices, and
/// e.g. protocols for 2xn, 3xn, 4xn, nx2, nx3, nx4, etc.; the original matrix 4x4 protocol inherited from square,
/// 4xn, and nx4 (etc.). That blows up compile times and doesn't result in *that much* code saving: you repeat
/// less code, sure, but the code you save is about as much as the hassle of declaring the MxN protocols and
/// extensions thereof, so...I'll take sub-hour compile times, thanks.
///
public protocol MatrixProtocol<Scalar> {

  // ------------------------------------------------------------------------ //
  // MARK: Scalar
  // ------------------------------------------------------------------------ //

  /// The scalar of-which the matrix is formed.
  associatedtype Scalar: SIMDScalar & BinaryFloatingPoint

  // ------------------------------------------------------------------------ //
  // MARK: Vectors
  // ------------------------------------------------------------------------ //

  /// The type of a column-vector within this matrix.
  associatedtype ColumnVector: SIMD
    where
    Scalar == ColumnVector.Scalar,
    ColumnVector.MaskStorage == ColumnVector.MaskStorage.MaskStorage
  
  /// The type of a row-vector within this matrix.
  associatedtype RowVector: SIMD
    where
    Scalar == RowVector.Scalar,
    RowVector.MaskStorage == RowVector.MaskStorage.MaskStorage
  
  /// The type of a diagonal vector within this matrix.
  associatedtype DiagonalVector: SIMD
    where
    Scalar == DiagonalVector.Scalar,
    DiagonalVector.MaskStorage == DiagonalVector.MaskStorage.MaskStorage

  // ------------------------------------------------------------------------ //
  // MARK: Components
  // ------------------------------------------------------------------------ //

  /// The type of the columns tuple.
  ///
  /// - note: An abstraction leak insofar as the `simd_double2x2`, etc., types being built as tuples of SIMD vectors leaks out.
  ///
  associatedtype Columns

  /// The type of the rows tuple.
  associatedtype Rows
  
  // ------------------------------------------------------------------------ //
  // MARK: Shape Parameters
  // ------------------------------------------------------------------------ //

  /// The number of rows in matrices of this type.
  static var rowCount: Int { get }
  
  /// The length of a row in matrices of this type.
  static var rowLength: Int { get }

  /// The number of columns in matrices of this type.
  static var columnCount: Int { get }
  
  /// The length of a column in matrices of this type.
  static var columnLength: Int { get }
  
  /// Number of scalars within matrices of this type.
  static var scalarCount: Int { get }

  // ------------------------------------------------------------------------ //
  // MARK: Shape Ranges
  // ------------------------------------------------------------------------ //
  
  /// Range of the valid row indices.
  static var rowIndexRange: Range<Int> { get }
  
  /// Range of the valid column indices.
  static var columnIndexRange: Range<Int> { get }
  
  /// Range of the valid linearized-scalar indices.
  static var linearizedScalarIndexRange: Range<Int> { get }

  // ------------------------------------------------------------------------ //
  // MARK: Initialization
  // ------------------------------------------------------------------------ //

  /// Constructs a zero-filled matrix.
  init()
  
  /// Constructs a matrix with `scalar` inserted into all entries.
  init(repeating scalar: Scalar)
  
  /// Constructs a matrix with `diagonal` on the diagonal and zeros elsewhere.
  init(diagonal: DiagonalVector)
  
  /// Constructs a matrix from the provided columns.
  init(columns: Columns)
  
  /// Constructs a matrix from the provided column-vectors.
  ///
  /// - note: Changed from the native SIMD name to disambiguate vis-a-vis `init(columns:)`.
  ///
  init(columnVectors: [ColumnVector])

  /// Constructs a matrix from the provided rows.
  ///
  /// - note: Missing from the underlying type, added for consistency with `columns`.
  /// - note: That this is inefficient *is* an abstraction leak, but...it's slow.
  ///
  init(rows: Rows)

  /// Constructs a matrix from the provided row-vectors.
  ///
  /// - note: Changed from the native SIMD name to be consistent with `init(columnVectors:)`.
  ///
  init(rowVectors: [RowVector])
  
  /// Constructs a matrix from a previously-obtained linearized-scalar-array. The ordering of
  /// `linearizedScalars` should be treated as a private implmentation detail.
  ///
  /// - parameter linearizedScalars: An array obtained from a previous call to `linearizedScalars`.
  ///
  /// - returns: A matrix equivalent-to the source of the `linearizedScalars`.
  ///
  /// - note: Treat `linearizedScalars`
  init(linearizedScalars: [Scalar])

  /// Constructs a matrix from an array-of-arrays of scalars. More-specifically,
  /// the interpreation will be identical to that of the visual structure:
  ///
  /// ```swift
  /// let foo = Self(
  ///   scalars: [
  ///     [a, b, c],
  ///     [d, e, f],
  ///     [g, h, i]
  ///   ]
  /// )
  /// ```
  ///
  /// ...will have:
  ///
  /// - rows `(a,b,c)`, `(d,e,f)` and `(g,h,i)`
  /// - columns: `(a,d,g)`, `(b,e,h)`, and `(c,f,i)`
  ///
  /// This isn't an efficient constructor, but it's very handy when you want
  /// to write out, say, a literal matrix of some kind.
  init(scalars: [[Scalar]])

  // ------------------------------------------------------------------------ //
  // MARK: Linear Combinations
  // ------------------------------------------------------------------------ //
  
  /// Returns a weighted linear combination of `first` and `other`.
  ///
  /// - parameter first: The first matrix to combine
  /// - parameter firstWeight: The weight for the first matrix
  /// - parameter other: The second matrix to combine
  /// - parameter otherWeight: The other matrix to combine
  ///
  /// - returns: A value equivalent-to `(first*firstWeight) + (other*otherWeight)`.
  ///
  /// - note: That this isn't an `init` is (a) an abstraction leak and (b) due to difficulty giving it a good name.
  ///
  static func linearCombination(
    of first: Self,
    weight firstWeight: Scalar,
    with other: Self,
    weight otherWeight: Scalar
  ) -> Self

  // ------------------------------------------------------------------------ //
  // MARK: Subscripting - Columns
  // ------------------------------------------------------------------------ //
  
  /// Get-or-set a column vector at a time.
  ///
  /// - precondition: `columnIndex` is a valid row index.
  ///
  subscript(columnIndex columnIndex: Int) -> ColumnVector { get set }

  // ------------------------------------------------------------------------ //
  // MARK: Subscripting - Rows
  // ------------------------------------------------------------------------ //

  /// Get-or-set a row vector at a time.
  ///
  /// - precondition: `rowIndex` is a valid row index.
  /// - warning: *Inefficient*; this is an abstraction leak, but it's also *true*!.
  ///
  subscript(rowIndex rowIndex: Int) -> RowVector { get set }

  // ------------------------------------------------------------------------ //
  // MARK: Subscripting - Scalars
  // ------------------------------------------------------------------------ //

  /// Get-or-set a scalar value by its "linearized scalar index".
  subscript(linearizedScalarIndex linearizedScalarIndex: Int) -> Scalar { get set }
  
  /// Get-or-set the scalar value at the indicated `columnIndex`, `rowIndex` pair.
  subscript(
    columnIndex columnIndex: Int,
    rowIndex rowIndex: Int
  ) -> Scalar { get set }

  /// Get-or-set a scalar value by the indicated matrix position.
  subscript(position position: MatrixPosition) -> Scalar { get set }
  
  // ------------------------------------------------------------------------ //
  // MARK: Position & Linearization
  // ------------------------------------------------------------------------ //

  /// Obtain the `linearizedScalarIndex` equivalent-to  `(columnIndex, rowIndex)`.
  ///
  /// - precondition: `matrixPosition` is a valid, subscriptable `matrixPosition`.
  ///
  static func linearizedScalarIndex(
    forColumnIndex columnIndex: Int,
    rowIndex: Int
  ) -> Int
  
  /// Obtain the `(columnIndex,rowIndex)` pair equivalent-to `linearScalarIndex`.
  ///
  /// - precondition: `linearizedScalarIndex` is a valid, subscriptable `linearizedScalarIndex`.
  ///
  static func columnRowIndex(forLinearizedScalarIndex linearizedScalarIndex: Int) -> (Int,Int)

  /// Obtain the `linearizedScalarIndex` equivalent-to  `MatrixPosition`.
  ///
  /// - precondition: `matrixPosition` is a valid, subscriptable `matrixPosition`.
  ///
  static func linearizedScalarIndex(forMatrixPosition matrixPosition: MatrixPosition) -> Int
  
  /// Obtain the `MatrixPosition` equivalent-to `linearizedScalarIndex`.
  ///
  /// - precondition: `linearizedScalarIndex` is a valid, subscriptable `linearizedScalarIndex`.
  ///
  static func matrixPosition(forLinearizedScalarIndex linearizedScalarIndex: Int) -> MatrixPosition
  
  /// An array containing all *valid* matrix positions for matrices of this type.
  static var matrixPositions: [MatrixPosition] { get }

  // ------------------------------------------------------------------------ //
  // MARK: Linearized Scalars <=> Arrays
  // ------------------------------------------------------------------------ //
  
  /// Converts a *proper* `linearizedScalars` to the equivalent array of `ColumnVectors`.
  static func columnVectors(forLinearizedScalars linearizedScalars: [Scalar]) -> [ColumnVector]
  
  /// Converts a *proper* `linearizedScalars` to the equivalent array of `RowVectors`.
  static func rowVectors(forLinearizedScalars linearizedScalars: [Scalar]) -> [RowVector]

  // ------------------------------------------------------------------------ //
  // MARK: Bulk Properties
  // ------------------------------------------------------------------------ //

  /// Get the packed columns.
  var columns: Columns { get set }

  /// Get the packed rows.
  ///
  /// - note: Inefficient; that this is inefficient is an abstraction leak, but it's still true!
  var rows: Rows { get }

  /// Get an array of all column vectors (in order).
  var columnVectors: [ColumnVector] { get }
  
  /// Get an array of all row vectors (in order).
  var rowVectors: [RowVector] { get }
  
  /// Get an array of all scalars (in order).
  var linearizedScalars: [Scalar] { get }
  
  // ------------------------------------------------------------------------ //
  // MARK: Almost Equal Elements
  // ------------------------------------------------------------------------ //
  
  /// `true` iff `self` and `other` have almost-equal elements within an *absolute* `tolerance`.
  ///
  /// - note: Abstraction leak: does whatever `simd_almost_equal_elements` does.
  ///
  func hasAlmostEqualElements(
    to other: Self,
    absoluteTolerance tolerance: Scalar
  ) -> Bool

  /// `true` iff `self` and `other` have almost-equal elements within a *relative* `tolerance`.
  ///
  /// - note: Abstraction leak: does whatever `simd_almost_equal_elements_relative` does.
  ///
  func hasAlmostEqualElements(
    to other: Self,
    relativeTolerance tolerance: Scalar
  ) -> Bool
  
  // ------------------------------------------------------------------------ //
  // MARK: Norms
  // ------------------------------------------------------------------------ //
  
  /// Returns the sum of the squares of the components of `self`.
  var componentwiseMagnitudeSquared: Scalar { get }

  // ------------------------------------------------------------------------ //
  // MARK: Negation
  // ------------------------------------------------------------------------ //
  
  /// Returns `-self`.
  ///
  /// - note: Abstraction leak in that this doesn't make sense for unsigned-integers. Oh well.
  ///
  func negated() -> Self
  
  /// In-place sets `self` equal-to `-self`.
  ///
  /// - note: Abstraction leak in that this doesn't make sense for unsigned-integers. Oh well.
  ///
  mutating func formNegation()

  // ------------------------------------------------------------------------ //
  // MARK: Addition - Matrix
  // ------------------------------------------------------------------------ //
  
  /// Obtain the component-wise addition of `self` and `other`.
  func adding(_ other: Self) -> Self
  
  /// In-place component-wise adds `other` into `self`.
  mutating func formAddition(of other: Self)

  // ------------------------------------------------------------------------ //
  // MARK: Addition - Scalar
  // ------------------------------------------------------------------------ //

  /// Returns `self` with `scalar` identically-added-to *all entries*.
  func adding(scalar: Scalar) -> Self
  
  /// In-place adds `scalar` to *all entries* in self.
  ///
  /// - todo: *Consider* adding a masked variant of this (if there's a need).
  ///
  mutating func formAddition(ofScalar scalar: Scalar)

  // ------------------------------------------------------------------------ //
  // MARK: FMA
  // ------------------------------------------------------------------------ //

  /// Returns `self + (scalar * other)`.
  ///
  /// - note: A distinct operation in case we get a (useful) FMA operation at some point.
  ///
  func adding(
    _ other: Self,
    multipliedBy scalar: Scalar
  ) -> Self

  /// In-place adds `scalar * other` to `self`.
  ///
  /// - note: A distinct operation in case we get a (useful) FMA operation at some point.
  ///
  mutating func formAddition(
    of other: Self,
    multipliedBy scalar: Scalar
  )
  
  // ------------------------------------------------------------------------ //
  // MARK: Subtraction - Matrix
  // ------------------------------------------------------------------------ //

  /// Obtain the component-wise subtraction of `other` from `self`.
  func subtracting(_ other: Self) -> Self
  
  /// In-place component-wise subtracts `other` from `self`.
  mutating func formSubtraction(of other: Self)

  // ------------------------------------------------------------------------ //
  // MARK: Subtraction - Scalar
  // ------------------------------------------------------------------------ //

  /// Returns `self` with `scalar` identically-subtracted-from *all entries*.
  func subtracting(scalar: Scalar) -> Self

  /// In-place subtracts `scalar` from *all entries* in self.
  ///
  /// - todo: *Consider* adding a masked variant of this (if there's a need).
  ///
  mutating func formSubtraction(ofScalar scalar: Scalar)

  // ------------------------------------------------------------------------ //
  // MARK: FMS
  // ------------------------------------------------------------------------ //
  
  /// Returns `self - (other * scalar)`.
  ///
  /// - note: A distinct operation in case we get a (useful) FMA operation at some point.
  ///
  func subtracting(
    _ other: Self,
    multipliedBy scalar: Scalar
  ) -> Self
  
  /// In place does `self = self - (other * scalar)`.
  ///
  /// - note: A distinct operation in case we get a (useful) FMA operation at some point.
  ///
  mutating func formSubtraction(
    of other: Self,
    multipliedBy scalar: Scalar
  )

  // ------------------------------------------------------------------------ //
  // MARK: Scalar Multiplication
  // ------------------------------------------------------------------------ //
  
  /// Returns `self` with all components identically-multiplied-by `scalar`.
  func multiplied(by scalar: Scalar) -> Self
  
  /// In-place multiplies all components in `self` by `scalar`.
  mutating func formMultiplication(by scalar: Scalar)

  // ------------------------------------------------------------------------ //
  // MARK: Scalar Division
  // ------------------------------------------------------------------------ //

  /// Returns `self` with all components identically-divided-by `scalar`.
  func divided(by scalar: Scalar) -> Self
  
  /// In-place divides all components in `self` by `scalar`.
  mutating func formDivision(by scalar: Scalar)

  // ------------------------------------------------------------------------ //
  // MARK: Vector Multiplication
  // ------------------------------------------------------------------------ //
  
  /// Returns the `RowVector` result of `columnVector * self`.
  func multiplied(onLeftBy columnVector: ColumnVector) -> RowVector
  
  /// Returns the `ColumnVector` result of `self * rowVector`.
  func multiplied(onRightBy rowVector: RowVector) -> ColumnVector

}
