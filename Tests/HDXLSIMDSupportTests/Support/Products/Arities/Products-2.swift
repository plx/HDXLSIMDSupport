import Foundation

@usableFromInline
typealias Homogeneous2<T> = (
  T,T
)

@inlinable
func isNonZero<T>(_ values: Homogeneous2<T>) -> Bool where T: Numeric {
  return (
    values.0 != 0
    ||
    values.1 != 0
  )
}

@inlinable
func arity2Power<A>(of a: some Collection<A>) -> AsyncStream<Homogeneous2<A>> {
  return cartesianProduct(of: a, a)
}

@inlinable
func arity2EnumeratedPower<A>(of a: some Collection<A>) -> AsyncStream<EnumeratedValue<Homogeneous2<A>>> {
  return enumeratedCartesianProduct(of: a, a)
}

@inlinable
func cartesianProduct<A,B>(
  of a: some Collection<A>,
  _  b: some Collection<B>
) -> AsyncStream<(
  A,
  B
)> {
  return AsyncStream<(
    A,
    B
  )> { continuation in
    for aa in a {
      for bb in b {
        continuation.yield(
          (
            aa,
            bb
          )
        )
      }
    }
    continuation.finish()
  }
}

@inlinable
func enumeratedCartesianProduct<A,B>(
  of a: some Collection<A>,
  _  b: some Collection<B>
) -> AsyncStream<
  EnumeratedValue<(
    A,
    B
  )>
> {
  return AsyncStream<
    EnumeratedValue<(
      A,
      B
    )>
  > { continuation in
    var index: Int = 0
    for aa in a {
      for bb in b {
        continuation.yield(
          EnumeratedValue(
            index: index,
            value: (
              aa,
              bb
            )
          )
        )
        index += 1
      }
    }
    continuation.finish()
  }
}
