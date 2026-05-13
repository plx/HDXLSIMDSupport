//
//  Float16+ExtendedSIMDScalar.swift
//

import Foundation
import simd

extension Float16 : ExtendedSIMDScalar {

  public typealias QuaternionStorage = HalfQuaternionStorage

  public typealias Matrix2x2Storage = HalfMatrix2x2Storage
  public typealias Matrix2x3Storage = HalfMatrix2x3Storage
  public typealias Matrix2x4Storage = HalfMatrix2x4Storage
  public typealias Matrix3x2Storage = HalfMatrix3x2Storage
  public typealias Matrix3x3Storage = HalfMatrix3x3Storage
  public typealias Matrix3x4Storage = HalfMatrix3x4Storage
  public typealias Matrix4x2Storage = HalfMatrix4x2Storage
  public typealias Matrix4x3Storage = HalfMatrix4x3Storage
  public typealias Matrix4x4Storage = HalfMatrix4x4Storage

}
