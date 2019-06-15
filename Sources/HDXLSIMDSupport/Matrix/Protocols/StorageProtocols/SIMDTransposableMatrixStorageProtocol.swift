//
//  SIMDTransposableMatrixStorageProtocol.swift
//

import Foundation

// -------------------------------------------------------------------------- //
// MARK: SIMDTransposableMatrixStorageProtocol - Definition
// -------------------------------------------------------------------------- //

/// "Doubly-artificial" protocol. Morally-speaking (a) this *should* be part of `SIMDMatrixStorageProtocol`
/// and also (b) there should be no need for `SIMDPreTransposableMatrixStorageProtocol`, but
/// unfortunately this is how it is.
///
/// For (a), including the "crossover-constraints" like `.RowVector == ColumnVector` into the basic
/// basic `SIMDMatrixStorageProtocol` makes constraints like `RowVector.Scalar == Scalar`
/// redundant to the compiler...and it warns you about them. As I like a "zero-warning policy" I'd either have
/// to heed the compiler and wind up with an artificial-looking protocol declaration *or* I can introduce this
/// artificial protocol and keep the base declaration clean...I kept the base declaration clean.
///
/// For (b), I get a compiler segfault if I do a single `SIMDTransposableMatrixStorageProtocol` that
/// includes the `TransposeStorage: SIMDPreTransposableMatrixStorageProtocol` and
/// the `TransposeStorage.TransposeStorage == Self` constraints within it; it compiles ok, though,
/// if I split things into the weaker base protocol and then add the final constraint here...so I did.
///
/// In practice *all* usable matrix storage types *will* adopt `SIMDTransposableMatrixStorageProtocol`,
/// so you may as well consider it part of the underlying type.
///
public protocol SIMDTransposableMatrixStorageProtocol : SIMDPreTransposableMatrixStorageProtocol
  where
  TransposeStorage: SIMDPreTransposableMatrixStorageProtocol,
  TransposeStorage.TransposeStorage == Self {
  
}

// -------------------------------------------------------------------------- //
// MARK: SIMDPreTransposableMatrixStorageProtocol - Definition
// -------------------------------------------------------------------------- //

/// "Artificial" protocol: this *should* be `SIMDMatrixStorageProtocol` but if you put these in there,
/// the crossover-constraints like `.RowVector == ColumnVector` make half of the type constraints
/// redundant to the compiler...and it lets you know.
///
/// Moving this into an auxiliary protocol suppresses those warnings, ergo...thus I moved it.
///
/// Morally-speaking this is part of `SIMDMatrixStorageProtocol`, though.
///
public protocol SIMDPreTransposableMatrixStorageProtocol : SIMDMatrixStorageProtocol {
  
  associatedtype TransposeStorage: SIMDMatrixStorageProtocol
    where
    TransposeStorage.Scalar == Scalar,
    TransposeStorage.RowVector == ColumnVector,
    TransposeStorage.ColumnVector == RowVector,
    TransposeStorage.Columns == Rows,
    TransposeStorage.Rows == Columns,
    TransposeStorage.ShorterAxisVector == LongerAxisVector,
    TransposeStorage.LongerAxisVector == ShorterAxisVector
  
  var transpose: TransposeStorage { get }
  
}
