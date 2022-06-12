import Foundation

protocol IntegerTupleConstructible {
  associatedtype IntegerTuple
  
  init(integerTuple: IntegerTuple)
}
