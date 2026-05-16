//
//  ExtendedSIMDScalar.swift
//

import Foundation
import simd

/// `ExtendedSIMDScalar` extends `SIMDScalar` with mutually-compatible
/// storage types for a quaternion and the nine `MxN` matrix shapes. The
/// associated types pin down which concrete storage is used for each
/// `Quaternion<Scalar>` / `MatrixNxM<Scalar>` wrapper, and the `where`
/// clauses ensure the cross-shape "compatible matrix" hooks line up.
///
/// Each storage is required to be both `MatrixNxMProtocol` /
/// `QuaternionProtocol` AND `NativeSIMDRepresentable`, the latter so the
/// wrapper can reach through to the native simd value via
/// `Storage.NativeSIMDRepresentation`.
public protocol ExtendedSIMDScalar : SIMDScalar, BinaryFloatingPoint, Codable {

  associatedtype QuaternionStorage: QuaternionProtocol, NativeSIMDRepresentable, NumericAggregate, Hashable, Codable
    where
    QuaternionStorage.Scalar == Self,
    QuaternionStorage.NumericEntryRepresentation == Self,
    QuaternionStorage.CompatibleMatrix4x4 == Self.Matrix4x4Storage,
    QuaternionStorage.CompatibleMatrix3x3 == Self.Matrix3x3Storage

  associatedtype Matrix2x2Storage: Matrix2x2Protocol, NativeSIMDRepresentable, NumericAggregate, Hashable, Codable
    where
    Matrix2x2Storage.Scalar == Self,
    Matrix2x2Storage.NumericEntryRepresentation == Self,
    Matrix2x2Storage.CompatibleMatrix2x3 == Self.Matrix2x3Storage,
    Matrix2x2Storage.CompatibleMatrix3x2 == Self.Matrix3x2Storage,
    Matrix2x2Storage.CompatibleMatrix2x4 == Self.Matrix2x4Storage,
    Matrix2x2Storage.CompatibleMatrix4x2 == Self.Matrix4x2Storage

  associatedtype Matrix2x3Storage: Matrix2x3Protocol, NativeSIMDRepresentable, NumericAggregate, Hashable, Codable
    where
    Matrix2x3Storage.Scalar == Self,
    Matrix2x3Storage.NumericEntryRepresentation == Self,
    Matrix2x3Storage.CompatibleMatrix2x2 == Self.Matrix2x2Storage,
    Matrix2x3Storage.CompatibleMatrix3x3 == Self.Matrix3x3Storage,
    Matrix2x3Storage.CompatibleMatrix3x2 == Self.Matrix3x2Storage,
    Matrix2x3Storage.CompatibleMatrix2x4 == Self.Matrix2x4Storage,
    Matrix2x3Storage.CompatibleMatrix4x2 == Self.Matrix4x2Storage,
    Matrix2x3Storage.CompatibleMatrix3x4 == Self.Matrix3x4Storage,
    Matrix2x3Storage.CompatibleMatrix4x3 == Self.Matrix4x3Storage

  associatedtype Matrix2x4Storage: Matrix2x4Protocol, NativeSIMDRepresentable, NumericAggregate, Hashable, Codable
    where
    Matrix2x4Storage.Scalar == Self,
    Matrix2x4Storage.NumericEntryRepresentation == Self,
    Matrix2x4Storage.CompatibleMatrix2x2 == Self.Matrix2x2Storage,
    Matrix2x4Storage.CompatibleMatrix4x4 == Self.Matrix4x4Storage,
    Matrix2x4Storage.CompatibleMatrix2x3 == Self.Matrix2x3Storage,
    Matrix2x4Storage.CompatibleMatrix4x2 == Self.Matrix4x2Storage,
    Matrix2x4Storage.CompatibleMatrix3x2 == Self.Matrix3x2Storage,
    Matrix2x4Storage.CompatibleMatrix3x4 == Self.Matrix3x4Storage,
    Matrix2x4Storage.CompatibleMatrix4x3 == Self.Matrix4x3Storage

  associatedtype Matrix3x2Storage: Matrix3x2Protocol, NativeSIMDRepresentable, NumericAggregate, Hashable, Codable
    where
    Matrix3x2Storage.Scalar == Self,
    Matrix3x2Storage.NumericEntryRepresentation == Self,
    Matrix3x2Storage.CompatibleMatrix2x2 == Self.Matrix2x2Storage,
    Matrix3x2Storage.CompatibleMatrix3x3 == Self.Matrix3x3Storage,
    Matrix3x2Storage.CompatibleMatrix2x3 == Self.Matrix2x3Storage,
    Matrix3x2Storage.CompatibleMatrix2x4 == Self.Matrix2x4Storage,
    Matrix3x2Storage.CompatibleMatrix4x2 == Self.Matrix4x2Storage,
    Matrix3x2Storage.CompatibleMatrix3x4 == Self.Matrix3x4Storage,
    Matrix3x2Storage.CompatibleMatrix4x3 == Self.Matrix4x3Storage

  associatedtype Matrix3x3Storage: Matrix3x3Protocol, NativeSIMDRepresentable, NumericAggregate, Hashable, Codable
    where
    Matrix3x3Storage.Scalar == Self,
    Matrix3x3Storage.NumericEntryRepresentation == Self,
    Matrix3x3Storage.CompatibleQuaternion == Self.QuaternionStorage,
    Matrix3x3Storage.CompatibleMatrix2x3 == Self.Matrix2x3Storage,
    Matrix3x3Storage.CompatibleMatrix3x2 == Self.Matrix3x2Storage,
    Matrix3x3Storage.CompatibleMatrix3x4 == Self.Matrix3x4Storage,
    Matrix3x3Storage.CompatibleMatrix4x3 == Self.Matrix4x3Storage

  associatedtype Matrix3x4Storage: Matrix3x4Protocol, NativeSIMDRepresentable, NumericAggregate, Hashable, Codable
    where
    Matrix3x4Storage.Scalar == Self,
    Matrix3x4Storage.NumericEntryRepresentation == Self,
    Matrix3x4Storage.CompatibleMatrix4x4 == Self.Matrix4x4Storage,
    Matrix3x4Storage.CompatibleMatrix3x3 == Self.Matrix3x3Storage,
    Matrix3x4Storage.CompatibleMatrix2x3 == Self.Matrix2x3Storage,
    Matrix3x4Storage.CompatibleMatrix3x2 == Self.Matrix3x2Storage,
    Matrix3x4Storage.CompatibleMatrix2x4 == Self.Matrix2x4Storage,
    Matrix3x4Storage.CompatibleMatrix4x2 == Self.Matrix4x2Storage,
    Matrix3x4Storage.CompatibleMatrix4x3 == Self.Matrix4x3Storage

  associatedtype Matrix4x2Storage: Matrix4x2Protocol, NativeSIMDRepresentable, NumericAggregate, Hashable, Codable
    where
    Matrix4x2Storage.Scalar == Self,
    Matrix4x2Storage.NumericEntryRepresentation == Self,
    Matrix4x2Storage.CompatibleMatrix4x4 == Self.Matrix4x4Storage,
    Matrix4x2Storage.CompatibleMatrix2x2 == Self.Matrix2x2Storage,
    Matrix4x2Storage.CompatibleMatrix2x3 == Self.Matrix2x3Storage,
    Matrix4x2Storage.CompatibleMatrix3x2 == Self.Matrix3x2Storage,
    Matrix4x2Storage.CompatibleMatrix2x4 == Self.Matrix2x4Storage,
    Matrix4x2Storage.CompatibleMatrix3x4 == Self.Matrix3x4Storage,
    Matrix4x2Storage.CompatibleMatrix4x3 == Self.Matrix4x3Storage

  associatedtype Matrix4x3Storage: Matrix4x3Protocol, NativeSIMDRepresentable, NumericAggregate, Hashable, Codable
    where
    Matrix4x3Storage.Scalar == Self,
    Matrix4x3Storage.NumericEntryRepresentation == Self,
    Matrix4x3Storage.CompatibleMatrix4x4 == Self.Matrix4x4Storage,
    Matrix4x3Storage.CompatibleMatrix3x3 == Self.Matrix3x3Storage,
    Matrix4x3Storage.CompatibleMatrix2x3 == Self.Matrix2x3Storage,
    Matrix4x3Storage.CompatibleMatrix3x2 == Self.Matrix3x2Storage,
    Matrix4x3Storage.CompatibleMatrix2x4 == Self.Matrix2x4Storage,
    Matrix4x3Storage.CompatibleMatrix4x2 == Self.Matrix4x2Storage,
    Matrix4x3Storage.CompatibleMatrix3x4 == Self.Matrix3x4Storage

  associatedtype Matrix4x4Storage: Matrix4x4Protocol, NativeSIMDRepresentable, NumericAggregate, Hashable, Codable
    where
    Matrix4x4Storage.Scalar == Self,
    Matrix4x4Storage.NumericEntryRepresentation == Self,
    Matrix4x4Storage.CompatibleQuaternion == Self.QuaternionStorage,
    Matrix4x4Storage.CompatibleMatrix2x4 == Self.Matrix2x4Storage,
    Matrix4x4Storage.CompatibleMatrix4x2 == Self.Matrix4x2Storage,
    Matrix4x4Storage.CompatibleMatrix3x4 == Self.Matrix3x4Storage,
    Matrix4x4Storage.CompatibleMatrix4x3 == Self.Matrix4x3Storage

}
