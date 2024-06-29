import Foundation
import HDXLSIMDSupport

extension NativeSIMDRepresentable where
Self: IntegerTupleConstructible,
NativeSIMDRepresentation: IntegerTupleConstructible,
IntegerTuple == NativeSIMDRepresentation.IntegerTuple
{
  init(integerTuple: IntegerTuple) {
    self.init(
      nativeSIMDRepresentation: NativeSIMDRepresentation(
        integerTuple: integerTuple
      )
    )
  }
}

extension Matrix2x2: IntegerTupleConstructible where
Scalar.Matrix2x2Storage.PassthroughValue: IntegerTupleConstructible
{
  typealias IntegerTuple = NativeSIMDRepresentation.IntegerTuple
}

extension Matrix2x3: IntegerTupleConstructible where
Scalar.Matrix2x3Storage.PassthroughValue: IntegerTupleConstructible
{
  typealias IntegerTuple = NativeSIMDRepresentation.IntegerTuple
}

extension Matrix2x4: IntegerTupleConstructible where
Scalar.Matrix2x4Storage.PassthroughValue: IntegerTupleConstructible
{
  typealias IntegerTuple = NativeSIMDRepresentation.IntegerTuple
}

extension Matrix3x2: IntegerTupleConstructible where
Scalar.Matrix3x2Storage.PassthroughValue: IntegerTupleConstructible
{
  typealias IntegerTuple = NativeSIMDRepresentation.IntegerTuple
}

extension Matrix3x3: IntegerTupleConstructible where
Scalar.Matrix3x3Storage.PassthroughValue: IntegerTupleConstructible
{
  typealias IntegerTuple = NativeSIMDRepresentation.IntegerTuple
}

extension Matrix3x4: IntegerTupleConstructible where
Scalar.Matrix3x4Storage.PassthroughValue: IntegerTupleConstructible
{
  typealias IntegerTuple = NativeSIMDRepresentation.IntegerTuple
}

extension Matrix4x2: IntegerTupleConstructible where
Scalar.Matrix4x2Storage.PassthroughValue: IntegerTupleConstructible
{
  typealias IntegerTuple = NativeSIMDRepresentation.IntegerTuple
}

extension Matrix4x3: IntegerTupleConstructible where
Scalar.Matrix4x3Storage.PassthroughValue: IntegerTupleConstructible
{
  typealias IntegerTuple = NativeSIMDRepresentation.IntegerTuple
}

extension Matrix4x4: IntegerTupleConstructible where
Scalar.Matrix4x4Storage.PassthroughValue: IntegerTupleConstructible
{
  typealias IntegerTuple = NativeSIMDRepresentation.IntegerTuple
}

