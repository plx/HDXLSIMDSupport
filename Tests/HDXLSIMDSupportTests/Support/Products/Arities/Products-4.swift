import Foundation

@usableFromInline
typealias Homogeneous4<T> = (
  T,T,
  T,T
)

@inlinable
func isNonZero<T>(_ values: Homogeneous4<T>) -> Bool where T: Numeric {
  return (
    values.0 != 0
    ||
    values.1 != 0
    ||
    values.2 != 0
    ||
    values.3 != 0
  )
}

@inlinable
func arity4Power<A>(of a: some Collection<A>) -> AsyncStream<Homogeneous4<A>> {
  return cartesianProduct(of: a, a, a, a)
}

@inlinable
func nonZeroArity4Power<A>(of a: some Collection<A>) -> AsyncStream<Homogeneous4<A>>
where A: Numeric {
  return filteredCartesianProduct(of: a, a, a, a) {
    return isNonZero(($0, $1, $2, $3))
  }
}

@inlinable
func filteredArity4Power<A>(
  of a: some Collection<A>,
  filter: (Homogeneous4<A>) -> Bool
) -> AsyncStream<Homogeneous4<A>> {
  return cartesianProduct(of: a, a, a, a)
}

@inlinable
func arity4EnumeratedPower<A>(of a: some Collection<A>) -> AsyncStream<EnumeratedValue<Homogeneous4<A>>> {
  return enumeratedCartesianProduct(of: a, a, a, a)
}

@inlinable
func cartesianProduct<A,B,C,D>(
  of a: some Collection<A>,
  _  b: some Collection<B>,
  _  c: some Collection<C>,
  _  d: some Collection<D>
) -> AsyncStream<(
  A,
  B,
  C,
  D
)> {
  return AsyncStream<(
    A,
    B,
    C,
    D
  )> { continuation in
    for aa in a {
      for bb in b {
        for cc in c {
          for dd in d {
            continuation.yield(
              (
                aa,
                bb,
                cc,
                dd
              )
            )
          }
        }
      }
    }
    continuation.finish()
  }
}

@inlinable
func filteredCartesianProduct<A,B,C,D>(
  of a: some Collection<A>,
  _  b: some Collection<B>,
  _  c: some Collection<C>,
  _  d: some Collection<D>,
  filteredBy filter: (A,B,C,D) -> Bool
) -> AsyncStream<(
  A,
  B,
  C,
  D
)> {
  return AsyncStream<(
    A,
    B,
    C,
    D
  )> { continuation in
    for aa in a {
      for bb in b {
        for cc in c {
          for dd in d {
            if filter(aa, bb, cc, dd) {
              continuation.yield(
                (
                  aa,
                  bb,
                  cc,
                  dd
                )
              )
            }
          }
        }
      }
    }
    continuation.finish()
  }
}

@inlinable
func enumeratedCartesianProduct<A,B,C,D>(
  of a: some Collection<A>,
  _  b: some Collection<B>,
  _  c: some Collection<C>,
  _  d: some Collection<D>
) -> AsyncStream<
  EnumeratedValue<(
    A,
    B,
    C,
    D
  )>
> {
  return AsyncStream<
    EnumeratedValue<(
      A,
      B,
      C,
      D
    )>
  > { continuation in
    var index: Int = 0
    for aa in a {
      for bb in b {
        for cc in c {
          for dd in d {
            continuation.yield(
              EnumeratedValue(
                index: index,
                value: (
                  aa,
                  bb,
                  cc,
                  dd
                )
              )
            )
            index += 1
          }
        }
      }
    }
    continuation.finish()
  }
}
