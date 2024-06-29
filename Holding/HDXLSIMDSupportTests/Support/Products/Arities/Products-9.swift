import Foundation

@usableFromInline
typealias Homogeneous9<T> = (
  T,T,T,
  T,T,T,
  T,T,T
)

@inlinable
func isNonZero<T>(_ values: Homogeneous9<T>) -> Bool where T: Numeric {
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
    ||
    values.8 != 0
  )
}

@inlinable
func arity9Power<A>(of a: some Collection<A>) -> AsyncStream<Homogeneous9<A>> {
  return cartesianProduct(of: a, a, a, a, a, a, a, a, a)
}

@inlinable
func arity9EnumeratedPower<A>(of a: some Collection<A>) -> AsyncStream<EnumeratedValue<Homogeneous9<A>>> {
  return enumeratedCartesianProduct(of: a, a, a, a, a, a, a, a, a)
}

@inlinable
func cartesianProduct<A,B,C,D,E,F,G,H,I>(
  of a: some Collection<A>,
  _  b: some Collection<B>,
  _  c: some Collection<C>,
  _  d: some Collection<D>,
  _  e: some Collection<E>,
  _  f: some Collection<F>,
  _  g: some Collection<G>,
  _  h: some Collection<H>,
  _  i: some Collection<I>
) -> AsyncStream<(
  A,
  B,
  C,
  D,
  E,
  F,
  G,
  H,
  I
)> {
  return AsyncStream<(
    A,
    B,
    C,
    D,
    E,
    F,
    G,
    H,
    I
  )> { continuation in
    for aa in a {
      for bb in b {
        for cc in c {
          for dd in d {
            for ee in e {
              for ff in f {
                for gg in g {
                  for hh in h {
                    for ii in i {
                      continuation.yield(
                        (
                          aa,
                          bb,
                          cc,
                          dd,
                          ee,
                          ff,
                          gg,
                          hh,
                          ii
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
    }
    continuation.finish()
  }
}

@inlinable
func enumeratedCartesianProduct<A,B,C,D,E,F,G,H,I>(
  of a: some Collection<A>,
  _  b: some Collection<B>,
  _  c: some Collection<C>,
  _  d: some Collection<D>,
  _  e: some Collection<E>,
  _  f: some Collection<F>,
  _  g: some Collection<G>,
  _  h: some Collection<H>,
  _  i: some Collection<I>
) -> AsyncStream<
  EnumeratedValue<(
    A,
    B,
    C,
    D,
    E,
    F,
    G,
    H,
    I
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
      H,
      I
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
                    for ii in i {
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
                            hh,
                            ii
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
    }
    continuation.finish()
  }
}
