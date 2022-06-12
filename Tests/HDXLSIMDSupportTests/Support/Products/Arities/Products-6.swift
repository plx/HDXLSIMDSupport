import Foundation

@usableFromInline
typealias Homogeneous6<T> = (
  T,T,T,
  T,T,T
)

@inlinable
func isNonZero<T>(_ values: Homogeneous6<T>) -> Bool where T: Numeric {
  return (
    values.0 != 0
    ||
    values.1 != 0
    ||
    values.2 != 0
    ||
    values.3 != 0
    ||
    values.4 != 0
    ||
    values.5 != 0
  )
}

@inlinable
func arity6Power<A>(of a: some Collection<A>) -> AsyncStream<Homogeneous6<A>> {
  return cartesianProduct(of: a, a, a, a, a, a)
}

@inlinable
func arity6EnumeratedPower<A>(of a: some Collection<A>) -> AsyncStream<EnumeratedValue<Homogeneous6<A>>> {
  return enumeratedCartesianProduct(of: a, a, a, a, a, a)
}

@inlinable
func cartesianProduct<A,B,C,D,E,F>(
  of a: some Collection<A>,
  _  b: some Collection<B>,
  _  c: some Collection<C>,
  _  d: some Collection<D>,
  _  e: some Collection<E>,
  _  f: some Collection<F>
) -> AsyncStream<(
  A,
  B,
  C,
  D,
  E,
  F
)> {
  return AsyncStream<(
    A,
    B,
    C,
    D,
    E,
    F
  )> { continuation in
    for aa in a {
      for bb in b {
        for cc in c {
          for dd in d {
            for ee in e {
              for ff in f {
                continuation.yield(
                  (
                    aa,
                    bb,
                    cc,
                    dd,
                    ee,
                    ff
                  )
                )
              }
            }
          }
        }
      }
    }
    continuation.finish()
  }
}

@inlinable
func enumeratedCartesianProduct<A,B,C,D,E,F>(
  of a: some Collection<A>,
  _  b: some Collection<B>,
  _  c: some Collection<C>,
  _  d: some Collection<D>,
  _  e: some Collection<E>,
  _  f: some Collection<F>
) -> AsyncStream<
  EnumeratedValue<(
    A,
    B,
    C,
    D,
    E,
    F
  )>
> {
  return AsyncStream<
    EnumeratedValue<(
      A,
      B,
      C,
      D,
      E,
      F
    )>
  > { continuation in
    var index: Int = 0
    for aa in a {
      for bb in b {
        for cc in c {
          for dd in d {
            for ee in e {
              for ff in f {
                continuation.yield(
                  EnumeratedValue(
                    index: index,
                    value: (
                      aa,
                      bb,
                      cc,
                      dd,
                      ee,
                      ff
                    )
                  )
                )
                index += 1
              }
            }
          }
        }
      }
    }
    continuation.finish()
  }
}
