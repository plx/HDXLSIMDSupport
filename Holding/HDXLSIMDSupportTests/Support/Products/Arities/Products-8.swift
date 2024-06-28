import Foundation

@usableFromInline
typealias Homogeneous8<T> = (
  T,T,T,T,
  T,T,T,T
)

@inlinable
func isNonZero<T>(_ values: Homogeneous8<T>) -> Bool where T: Numeric {
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
    ||
    values.6 != 0
    ||
    values.7 != 0
  )
}

@inlinable
func arity8Power<A>(of a: some Collection<A>) -> AsyncStream<Homogeneous8<A>> {
  return cartesianProduct(of: a, a, a, a, a, a, a, a)
}

@inlinable
func arity8EnumeratedPower<A>(of a: some Collection<A>) -> AsyncStream<EnumeratedValue<Homogeneous8<A>>> {
  return enumeratedCartesianProduct(of: a, a, a, a, a, a, a, a)
}

@inlinable
func cartesianProduct<A,B,C,D,E,F,G,H>(
  of a: some Collection<A>,
  _  b: some Collection<B>,
  _  c: some Collection<C>,
  _  d: some Collection<D>,
  _  e: some Collection<E>,
  _  f: some Collection<F>,
  _  g: some Collection<G>,
  _  h: some Collection<H>
) -> AsyncStream<(
  A,
  B,
  C,
  D,
  E,
  F,
  G,
  H
)> {
  return AsyncStream<(
    A,
    B,
    C,
    D,
    E,
    F,
    G,
    H
  )> { continuation in
    for aa in a {
      for bb in b {
        for cc in c {
          for dd in d {
            for ee in e {
              for ff in f {
                for gg in g {
                  for hh in h {
                    continuation.yield(
                      (
                        aa,
                        bb,
                        cc,
                        dd,
                        ee,
                        ff,
                        gg,
                        hh
                      )
                    )
                  }
                }
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
func enumeratedCartesianProduct<A,B,C,D,E,F,G,H>(
  of a: some Collection<A>,
  _  b: some Collection<B>,
  _  c: some Collection<C>,
  _  d: some Collection<D>,
  _  e: some Collection<E>,
  _  f: some Collection<F>,
  _  g: some Collection<G>,
  _  h: some Collection<H>
) -> AsyncStream<
  EnumeratedValue<(
    A,
    B,
    C,
    D,
    E,
    F,
    G,
    H
  )>
> {
  return AsyncStream<
    EnumeratedValue<(
      A,
      B,
      C,
      D,
      E,
      F,
      G,
      H
    )>
  > { continuation in
    var index: Int = 0
    for aa in a {
      for bb in b {
        for cc in c {
          for dd in d {
            for ee in e {
              for ff in f {
                for gg in g {
                  for hh in h {
                    continuation.yield(
                      EnumeratedValue(
                        index: index,
                        value: (
                          aa,
                          bb,
                          cc,
                          dd,
                          ee,
                          ff,
                          gg,
                          hh
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
      }
    }
    continuation.finish()
  }
}
