import Foundation

protocol IntegerTupleConstructible<IntegerTuple> {
  associatedtype IntegerTuple
  
  init(integerTuple: IntegerTuple)
}
