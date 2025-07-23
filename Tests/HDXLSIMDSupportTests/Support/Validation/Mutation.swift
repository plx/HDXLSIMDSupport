
func mutation<T>(of value: T, by mutation: (inout T) throws -> Void) rethrows -> T {
  var mutatee = value
  try mutation(&mutatee)
  return mutatee
}

