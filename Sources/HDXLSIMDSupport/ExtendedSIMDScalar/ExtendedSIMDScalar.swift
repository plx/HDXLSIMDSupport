//
//  ExtendedSIMDScalar.swift
//

import Foundation
import simd
import HDXLCommonUtilities

/// `ExtendedSIMDScalar` extends `SIMDScalar` by adding *mutually-compatible* storages for
/// (a) a quaternion and also (b) all of the currently-available matrix types (2x2 ... 4x4). The key point here
/// being that *mutually-compatible*: the 2x2 matrix storage's compatible 2x3 matrix must be the
/// 2x3 matrix, and so on down the line.
///
/// Note that—for now—this is where those "compatible types" get pinned-down with constraints like
/// `: Matrix4x4Protocol` and `: Scalar == ...`; in a perfect world the compatible types would
/// already have such `where`-clauses attached at the point of definition...but we don't live in that perfect world
/// (or even a neighborhood thereof). Including those constraints within the individual `MatrixMxNProtocol`
/// types seems to pretty-reliably trigger superexponential blow-ups in our compile-times.
///
/// That's not an exaggeration, either: right now the project takes a few minutes to compile, which is already
/// quite long for this quantity of Swift code (as measured in lines/files). Adding more `where` clauses, etc.,
/// pretty reliably got me into hours-or-days to compile the thing, blowing through all my 64gb of RAM, and
/// made everything hilariously-unusable.
///
/// I still intend to *experiment* with refining the declarations to more-perfectly match the intent, but the
/// state of the tools leaves me with low expectations for those experiemnts.
///
/// Anyways, this protocol exists as the bound on `Scalar` for `Matrix4x4<Scalar>`, etc., with the
/// interlocking, mutually-compatible storages being basically a manual emulation of something that could be
/// done almost-trivially if Swift gained higher-kinded types. Oh well.
///
public protocol ExtendedSIMDScalar : ExtendedFloatingPointMath  /* redundant : SIMDScalar, BinaryFloatingPoint */ {
  
  associatedtype QuaternionStorage: QuaternionProtocol, Passthrough, NumericAggregate, Hashable, Codable
    where
    QuaternionStorage.Scalar == Self,
    QuaternionStorage.NumericEntryRepresentation == Self,
    QuaternionStorage.CompatibleMatrix4x4 == Self.Matrix4x4Storage,
    QuaternionStorage.CompatibleMatrix3x3 == Self.Matrix3x3Storage,
    QuaternionStorage.PassthroughValue: QuaternionProtocol,
    QuaternionStorage.PassthroughValue.Scalar == Self,
    QuaternionStorage.PassthroughValue.CompatibleMatrix4x4 == Self.Matrix4x4Storage.PassthroughValue,
    QuaternionStorage.PassthroughValue.CompatibleMatrix3x3 == Self.Matrix3x3Storage.PassthroughValue
  
  associatedtype Matrix2x2Storage: Matrix2x2Protocol, Passthrough, NumericAggregate, Hashable, Codable
    where
    Matrix2x2Storage.Scalar == Self,
    Matrix2x2Storage.NumericEntryRepresentation == Self,
    Matrix2x2Storage.CompatibleMatrix2x3 == Self.Matrix2x3Storage,
    Matrix2x2Storage.CompatibleMatrix3x2 == Self.Matrix3x2Storage,
    Matrix2x2Storage.CompatibleMatrix2x4 == Self.Matrix2x4Storage,
    Matrix2x2Storage.CompatibleMatrix4x2 == Self.Matrix4x2Storage,
    Matrix2x2Storage.PassthroughValue:Matrix2x2Protocol,
    Matrix2x2Storage.PassthroughValue.Scalar == Self,
    Matrix2x2Storage.PassthroughValue.CompatibleMatrix2x3 == Self.Matrix2x3Storage.PassthroughValue,
    Matrix2x2Storage.PassthroughValue.CompatibleMatrix3x2 == Self.Matrix3x2Storage.PassthroughValue,
    Matrix2x2Storage.PassthroughValue.CompatibleMatrix2x4 == Self.Matrix2x4Storage.PassthroughValue,
    Matrix2x2Storage.PassthroughValue.CompatibleMatrix4x2 == Self.Matrix4x2Storage.PassthroughValue

  associatedtype Matrix2x3Storage: Matrix2x3Protocol, Passthrough, NumericAggregate, Hashable, Codable
    where
    Matrix2x3Storage.Scalar == Self,
    Matrix2x3Storage.NumericEntryRepresentation == Self,
    Matrix2x3Storage.CompatibleMatrix2x2 == Self.Matrix2x2Storage,
    Matrix2x3Storage.CompatibleMatrix3x3 == Self.Matrix3x3Storage,
    Matrix2x3Storage.CompatibleMatrix3x2 == Self.Matrix3x2Storage,
    Matrix2x3Storage.CompatibleMatrix2x4 == Self.Matrix2x4Storage,
    Matrix2x3Storage.CompatibleMatrix4x2 == Self.Matrix4x2Storage,
    Matrix2x3Storage.CompatibleMatrix3x4 == Self.Matrix3x4Storage,
    Matrix2x3Storage.CompatibleMatrix4x3 == Self.Matrix4x3Storage,
    Matrix2x3Storage.PassthroughValue: Matrix2x3Protocol,
    Matrix2x3Storage.PassthroughValue.Scalar == Self,
    Matrix2x3Storage.PassthroughValue.CompatibleMatrix2x2 == Self.Matrix2x2Storage.PassthroughValue,
    Matrix2x3Storage.PassthroughValue.CompatibleMatrix3x3 == Self.Matrix3x3Storage.PassthroughValue,
    Matrix2x3Storage.PassthroughValue.CompatibleMatrix3x2 == Self.Matrix3x2Storage.PassthroughValue,
    Matrix2x3Storage.PassthroughValue.CompatibleMatrix2x4 == Self.Matrix2x4Storage.PassthroughValue,
    Matrix2x3Storage.PassthroughValue.CompatibleMatrix4x2 == Self.Matrix4x2Storage.PassthroughValue,
    Matrix2x3Storage.PassthroughValue.CompatibleMatrix3x4 == Self.Matrix3x4Storage.PassthroughValue,
    Matrix2x3Storage.PassthroughValue.CompatibleMatrix4x3 == Self.Matrix4x3Storage.PassthroughValue


  associatedtype Matrix2x4Storage: Matrix2x4Protocol, Passthrough, NumericAggregate, Hashable, Codable
    where
    Matrix2x4Storage.Scalar == Self,
    Matrix2x4Storage.NumericEntryRepresentation == Self,
    Matrix2x4Storage.CompatibleMatrix2x2 == Self.Matrix2x2Storage,
    Matrix2x4Storage.CompatibleMatrix4x4 == Self.Matrix4x4Storage,
    Matrix2x4Storage.CompatibleMatrix2x3 == Self.Matrix2x3Storage,
    Matrix2x4Storage.CompatibleMatrix4x2 == Self.Matrix4x2Storage,
    Matrix2x4Storage.CompatibleMatrix3x2 == Self.Matrix3x2Storage,
    Matrix2x4Storage.CompatibleMatrix3x4 == Self.Matrix3x4Storage,
    Matrix2x4Storage.CompatibleMatrix4x3 == Self.Matrix4x3Storage,
    Matrix2x4Storage.PassthroughValue: Matrix2x4Protocol,
    Matrix2x4Storage.PassthroughValue.Scalar == Self,
    Matrix2x4Storage.PassthroughValue.CompatibleMatrix2x2 == Self.Matrix2x2Storage.PassthroughValue,
    Matrix2x4Storage.PassthroughValue.CompatibleMatrix4x4 == Self.Matrix4x4Storage.PassthroughValue,
    Matrix2x4Storage.PassthroughValue.CompatibleMatrix2x3 == Self.Matrix2x3Storage.PassthroughValue,
    Matrix2x4Storage.PassthroughValue.CompatibleMatrix4x2 == Self.Matrix4x2Storage.PassthroughValue,
    Matrix2x4Storage.PassthroughValue.CompatibleMatrix3x2 == Self.Matrix3x2Storage.PassthroughValue,
    Matrix2x4Storage.PassthroughValue.CompatibleMatrix3x4 == Self.Matrix3x4Storage.PassthroughValue,
    Matrix2x4Storage.PassthroughValue.CompatibleMatrix4x3 == Self.Matrix4x3Storage.PassthroughValue

  associatedtype Matrix3x2Storage: Matrix3x2Protocol, Passthrough, NumericAggregate, Hashable, Codable
    where
    Matrix3x2Storage.Scalar == Self,
    Matrix3x2Storage.NumericEntryRepresentation == Self,
    Matrix3x2Storage.CompatibleMatrix2x2 == Self.Matrix2x2Storage,
    Matrix3x2Storage.CompatibleMatrix3x3 == Self.Matrix3x3Storage,
    Matrix3x2Storage.CompatibleMatrix2x3 == Self.Matrix2x3Storage,
    Matrix3x2Storage.CompatibleMatrix2x4 == Self.Matrix2x4Storage,
    Matrix3x2Storage.CompatibleMatrix4x2 == Self.Matrix4x2Storage,
    Matrix3x2Storage.CompatibleMatrix3x4 == Self.Matrix3x4Storage,
    Matrix3x2Storage.CompatibleMatrix4x3 == Self.Matrix4x3Storage,
    Matrix3x2Storage.PassthroughValue: Matrix3x2Protocol,
    Matrix3x2Storage.PassthroughValue.Scalar == Self,
    Matrix3x2Storage.PassthroughValue.CompatibleMatrix2x2 == Self.Matrix2x2Storage.PassthroughValue,
    Matrix3x2Storage.PassthroughValue.CompatibleMatrix3x3 == Self.Matrix3x3Storage.PassthroughValue,
    Matrix3x2Storage.PassthroughValue.CompatibleMatrix2x3 == Self.Matrix2x3Storage.PassthroughValue,
    Matrix3x2Storage.PassthroughValue.CompatibleMatrix2x4 == Self.Matrix2x4Storage.PassthroughValue,
    Matrix3x2Storage.PassthroughValue.CompatibleMatrix4x2 == Self.Matrix4x2Storage.PassthroughValue,
    Matrix3x2Storage.PassthroughValue.CompatibleMatrix3x4 == Self.Matrix3x4Storage.PassthroughValue,
    Matrix3x2Storage.PassthroughValue.CompatibleMatrix4x3 == Self.Matrix4x3Storage.PassthroughValue

  associatedtype Matrix3x3Storage: Matrix3x3Protocol, Passthrough, NumericAggregate, Hashable, Codable
    where
    Matrix3x3Storage.Scalar == Self,
    Matrix3x3Storage.NumericEntryRepresentation == Self,
    Matrix3x3Storage.CompatibleQuaternion == Self.QuaternionStorage,
    Matrix3x3Storage.CompatibleMatrix2x3 == Self.Matrix2x3Storage,
    Matrix3x3Storage.CompatibleMatrix3x2 == Self.Matrix3x2Storage,
    Matrix3x3Storage.CompatibleMatrix3x4 == Self.Matrix3x4Storage,
    Matrix3x3Storage.CompatibleMatrix4x3 == Self.Matrix4x3Storage,
    Matrix3x3Storage.PassthroughValue: Matrix3x3Protocol,
    Matrix3x3Storage.PassthroughValue.Scalar == Self,
    Matrix3x3Storage.PassthroughValue.CompatibleQuaternion == Self.QuaternionStorage.PassthroughValue,
    Matrix3x3Storage.PassthroughValue.CompatibleMatrix2x3 == Self.Matrix2x3Storage.PassthroughValue,
    Matrix3x3Storage.PassthroughValue.CompatibleMatrix3x2 == Self.Matrix3x2Storage.PassthroughValue,
    Matrix3x3Storage.PassthroughValue.CompatibleMatrix3x4 == Self.Matrix3x4Storage.PassthroughValue,
    Matrix3x3Storage.PassthroughValue.CompatibleMatrix4x3 == Self.Matrix4x3Storage.PassthroughValue

  associatedtype Matrix3x4Storage: Matrix3x4Protocol, Passthrough, NumericAggregate, Hashable, Codable
    where
    Matrix3x4Storage.Scalar == Self,
    Matrix3x4Storage.NumericEntryRepresentation == Self,
    Matrix3x4Storage.CompatibleMatrix4x4 == Self.Matrix4x4Storage,
    Matrix3x4Storage.CompatibleMatrix3x3 == Self.Matrix3x3Storage,
    Matrix3x4Storage.CompatibleMatrix2x3 == Self.Matrix2x3Storage,
    Matrix3x4Storage.CompatibleMatrix3x2 == Self.Matrix3x2Storage,
    Matrix3x4Storage.CompatibleMatrix2x4 == Self.Matrix2x4Storage,
    Matrix3x4Storage.CompatibleMatrix4x2 == Self.Matrix4x2Storage,
    Matrix3x4Storage.CompatibleMatrix4x3 == Self.Matrix4x3Storage,
    Matrix3x4Storage.PassthroughValue: Matrix3x4Protocol,
    Matrix3x4Storage.PassthroughValue.Scalar == Self,
    Matrix3x4Storage.PassthroughValue.CompatibleMatrix4x4 == Self.Matrix4x4Storage.PassthroughValue,
    Matrix3x4Storage.PassthroughValue.CompatibleMatrix3x3 == Self.Matrix3x3Storage.PassthroughValue,
    Matrix3x4Storage.PassthroughValue.CompatibleMatrix2x3 == Self.Matrix2x3Storage.PassthroughValue,
    Matrix3x4Storage.PassthroughValue.CompatibleMatrix3x2 == Self.Matrix3x2Storage.PassthroughValue,
    Matrix3x4Storage.PassthroughValue.CompatibleMatrix2x4 == Self.Matrix2x4Storage.PassthroughValue,
    Matrix3x4Storage.PassthroughValue.CompatibleMatrix4x2 == Self.Matrix4x2Storage.PassthroughValue,
    Matrix3x4Storage.PassthroughValue.CompatibleMatrix4x3 == Self.Matrix4x3Storage.PassthroughValue

  associatedtype Matrix4x2Storage: Matrix4x2Protocol, Passthrough, NumericAggregate, Hashable, Codable
    where
    Matrix4x2Storage.Scalar == Self,
    Matrix4x2Storage.NumericEntryRepresentation == Self,
    Matrix4x2Storage.CompatibleMatrix4x4 == Self.Matrix4x4Storage,
    Matrix4x2Storage.CompatibleMatrix2x2 == Self.Matrix2x2Storage,
    Matrix4x2Storage.CompatibleMatrix2x3 == Self.Matrix2x3Storage,
    Matrix4x2Storage.CompatibleMatrix3x2 == Self.Matrix3x2Storage,
    Matrix4x2Storage.CompatibleMatrix2x4 == Self.Matrix2x4Storage,
    Matrix4x2Storage.CompatibleMatrix3x4 == Self.Matrix3x4Storage,
    Matrix4x2Storage.CompatibleMatrix4x3 == Self.Matrix4x3Storage,
    Matrix4x2Storage.PassthroughValue: Matrix4x2Protocol,
    Matrix4x2Storage.PassthroughValue.Scalar == Self,
    Matrix4x2Storage.PassthroughValue.CompatibleMatrix4x4 == Self.Matrix4x4Storage.PassthroughValue,
    Matrix4x2Storage.PassthroughValue.CompatibleMatrix2x2 == Self.Matrix2x2Storage.PassthroughValue,
    Matrix4x2Storage.PassthroughValue.CompatibleMatrix2x3 == Self.Matrix2x3Storage.PassthroughValue,
    Matrix4x2Storage.PassthroughValue.CompatibleMatrix3x2 == Self.Matrix3x2Storage.PassthroughValue,
    Matrix4x2Storage.PassthroughValue.CompatibleMatrix2x4 == Self.Matrix2x4Storage.PassthroughValue,
    Matrix4x2Storage.PassthroughValue.CompatibleMatrix3x4 == Self.Matrix3x4Storage.PassthroughValue,
    Matrix4x2Storage.PassthroughValue.CompatibleMatrix4x3 == Self.Matrix4x3Storage.PassthroughValue

  associatedtype Matrix4x3Storage: Matrix4x3Protocol, Passthrough, NumericAggregate, Hashable, Codable
    where
    Matrix4x3Storage.Scalar == Self,
    Matrix4x3Storage.NumericEntryRepresentation == Self,
    Matrix4x3Storage.CompatibleMatrix4x4 == Self.Matrix4x4Storage,
    Matrix4x3Storage.CompatibleMatrix3x3 == Self.Matrix3x3Storage,
    Matrix4x3Storage.CompatibleMatrix2x3 == Self.Matrix2x3Storage,
    Matrix4x3Storage.CompatibleMatrix3x2 == Self.Matrix3x2Storage,
    Matrix4x3Storage.CompatibleMatrix2x4 == Self.Matrix2x4Storage,
    Matrix4x3Storage.CompatibleMatrix4x2 == Self.Matrix4x2Storage,
    Matrix4x3Storage.CompatibleMatrix3x4 == Self.Matrix3x4Storage,
    Matrix4x3Storage.PassthroughValue: Matrix4x3Protocol,
    Matrix4x3Storage.PassthroughValue.Scalar == Self,
    Matrix4x3Storage.PassthroughValue.CompatibleMatrix4x4 == Self.Matrix4x4Storage.PassthroughValue,
    Matrix4x3Storage.PassthroughValue.CompatibleMatrix3x3 == Self.Matrix3x3Storage.PassthroughValue,
    Matrix4x3Storage.PassthroughValue.CompatibleMatrix2x3 == Self.Matrix2x3Storage.PassthroughValue,
    Matrix4x3Storage.PassthroughValue.CompatibleMatrix3x2 == Self.Matrix3x2Storage.PassthroughValue,
    Matrix4x3Storage.PassthroughValue.CompatibleMatrix2x4 == Self.Matrix2x4Storage.PassthroughValue,
    Matrix4x3Storage.PassthroughValue.CompatibleMatrix4x2 == Self.Matrix4x2Storage.PassthroughValue,
    Matrix4x3Storage.PassthroughValue.CompatibleMatrix3x4 == Self.Matrix3x4Storage.PassthroughValue

  associatedtype Matrix4x4Storage: Matrix4x4Protocol, Passthrough, NumericAggregate, Hashable, Codable
    where
    Matrix4x4Storage.Scalar == Self,
    Matrix4x4Storage.NumericEntryRepresentation == Self,
    Matrix4x4Storage.CompatibleQuaternion == Self.QuaternionStorage,
    Matrix4x4Storage.CompatibleMatrix2x4 == Self.Matrix2x4Storage,
    Matrix4x4Storage.CompatibleMatrix4x2 == Self.Matrix4x2Storage,
    Matrix4x4Storage.CompatibleMatrix3x4 == Self.Matrix3x4Storage,
    Matrix4x4Storage.CompatibleMatrix4x3 == Self.Matrix4x3Storage,
    Matrix4x4Storage.PassthroughValue: Matrix4x4Protocol,
    Matrix4x4Storage.PassthroughValue.Scalar == Self,
    Matrix4x4Storage.PassthroughValue.CompatibleQuaternion == Self.QuaternionStorage.PassthroughValue,
    Matrix4x4Storage.PassthroughValue.CompatibleMatrix2x4 == Self.Matrix2x4Storage.PassthroughValue,
    Matrix4x4Storage.PassthroughValue.CompatibleMatrix4x2 == Self.Matrix4x2Storage.PassthroughValue,
    Matrix4x4Storage.PassthroughValue.CompatibleMatrix3x4 == Self.Matrix3x4Storage.PassthroughValue,
    Matrix4x4Storage.PassthroughValue.CompatibleMatrix4x3 == Self.Matrix4x3Storage.PassthroughValue

}
