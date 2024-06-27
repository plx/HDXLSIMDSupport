
extension Collection {
  
  func obtainsDistinctValues<T>(for transformation: (Element) throws -> T) rethrows -> Bool where T: Hashable {
    count == Set(try map(transformation)).count
  }
  
}


extension [String] {
  func bulkPrepending(_ prefix: String) -> [String] {
    map { "\(prefix)\($0)" }
  }
}
