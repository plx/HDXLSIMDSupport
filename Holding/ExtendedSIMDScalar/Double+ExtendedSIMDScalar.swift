import Foundation
import simd
import HDXLSIMDSupportProtocols

extension Double : @retroactive ExtendedSIMDScalar {
  
  public typealias QuaternionStorage = DoubleQuaternionStorage
  
  public typealias Matrix2x2Storage = DoubleMatrix2x2Storage
  public typealias Matrix2x3Storage = DoubleMatrix2x3Storage
  public typealias Matrix2x4Storage = DoubleMatrix2x4Storage
  public typealias Matrix3x2Storage = DoubleMatrix3x2Storage
  public typealias Matrix3x3Storage = DoubleMatrix3x3Storage
  public typealias Matrix3x4Storage = DoubleMatrix3x4Storage
  public typealias Matrix4x2Storage = DoubleMatrix4x2Storage
  public typealias Matrix4x3Storage = DoubleMatrix4x3Storage
  public typealias Matrix4x4Storage = DoubleMatrix4x4Storage
  
}
