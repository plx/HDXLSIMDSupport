import Foundation

@usableFromInline
typealias Homogeneous3<T> = (
  T,T,T
)

@inlinable
func isNonZero<T>(_ values: Homogeneous3<T>) -> Bool where T: Numeric {
  return (
    values.0 != 0
    ||
    values.1 != 0
    ||
    values.2 != 0
  )
}

@inlinable
func arity3Power<A>(of a: some Collection<A>) -> AsyncStream<Homogeneous3<A>> {
  return cartesianProduct(of: a, a, a)
}

@inlinable
func arity3EnumeratedPower<A>(of a: some Collection<A>) -> AsyncStream<EnumeratedValue<Homogeneous3<A>>> {
  return enumeratedCartesianProduct(of: a, a, a)
}

@inlinable
func cartesianProduct<A,B,C>(
  of a: some Collection<A>,
  _  b: some Collection<B>,
  _  c: some Collection<C>
) -> AsyncStream<(
  A,
  B,
  C
)> {
  return AsyncStream<(
    A,
    B,
    C
  )> { continuation in
    for aa in a {
      for bb in b {
        for cc in c {
          continuation.yield(
            (
              aa,
              bb,
              cc
            )
          )
        }
      }
    }
    continuation.finish()
  }
}

@inlinable
func enumeratedCartesianProduct<A,B,C>(
  of a: some Collection<A>,
  _  b: some Collection<B>,
  _  c: some Collection<C>
) -> AsyncStream<
  EnumeratedValue<(
    A,
    B,
    C
  )>
> {
  return AsyncStream<
    EnumeratedValue<(
      A,
      B,
      C
    )>
  > { continuation in
    var index: Int = 0
    for aa in a {
      for bb in b {
        for cc in c {
          continuation.yield(
            EnumeratedValue(
              index: index,
              value: (
                aa,
                bb,
                cc
              )
            )
          )
          index += 1
        }
      }
    }
    continuation.finish()
  }
}
