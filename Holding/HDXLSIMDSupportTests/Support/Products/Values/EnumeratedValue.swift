import Foundation

extension Collection {
  @inlinable
  var enumeratedValues: [EnumeratedValue<Element>] {
    enumerated().map { index, value in
      EnumeratedValue(index: index, value: value)
    }
  }
}

@usableFromInline
internal struct EnumeratedValue<Value> {
  @usableFromInline
  var index: Int
  
  @usableFromInline
  var value: Value
  
  @inlinable
  init(index: Int, value: Value) {
    self.index = index
    self.value = value
  }
}

extension EnumeratedValue: Sendable where Value: Sendable { }
