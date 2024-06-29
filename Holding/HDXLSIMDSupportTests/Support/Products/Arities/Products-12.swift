import Foundation

@usableFromInline
typealias Homogeneous12<T> = (
  T,T,T,T,
  T,T,T,T,
  T,T,T,T
)

@inlinable
func isNonZero<T>(_ values: Homogeneous12<T>) -> Bool where T: Numeric {
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
    ||
    values.9 != 0
    ||
    values.10 != 0
    ||
    values.11 != 0
  )
}

@inlinable
func arity12Power<A>(of a: some Collection<A>) -> AsyncStream<Homogeneous12<A>> {
  return cartesianProduct(of: a, a, a, a, a, a, a, a, a, a, a, a)
}

@inlinable
func arity12EnumeratedPower<A>(of a: some Collection<A>) -> AsyncStream<EnumeratedValue<Homogeneous12<A>>> {
  return enumeratedCartesianProduct(of: a, a, a, a, a, a, a, a, a, a, a, a)
}

@inlinable
func cartesianProduct<A,B,C,D,E,F,G,H,I,J,K,L>(
  of a: some Collection<A>,
  _  b: some Collection<B>,
  _  c: some Collection<C>,
  _  d: some Collection<D>,
  _  e: some Collection<E>,
  _  f: some Collection<F>,
  _  g: some Collection<G>,
  _  h: some Collection<H>,
  _  i: some Collection<I>,
  _  j: some Collection<J>,
  _  k: some Collection<K>,
  _  l: some Collection<L>
) -> AsyncStream<(
  A,
  B,
  C,
  D,
  E,
  F,
  G,
  H,
  I,
  J,
  K,
  L
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
    I,
    J,
    K,
    L
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
                      for jj in j {
                        for kk in k {
                          for ll in l {
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
                                ii,
                                jj,
                                kk,
                                ll
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
        }
      }
    }
    continuation.finish()
  }
}

@inlinable
func enumeratedCartesianProduct<A,B,C,D,E,F,G,H,I,J,K,L>(
  of a: some Collection<A>,
  _  b: some Collection<B>,
  _  c: some Collection<C>,
  _  d: some Collection<D>,
  _  e: some Collection<E>,
  _  f: some Collection<F>,
  _  g: some Collection<G>,
  _  h: some Collection<H>,
  _  i: some Collection<I>,
  _  j: some Collection<J>,
  _  k: some Collection<K>,
  _  l: some Collection<L>
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
    I,
    J,
    K,
    L
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
      I,
      J,
      K,
      L
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
                      for jj in j {
                        for kk in k {
                          for ll in l {
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
                                  ii,
                                  jj,
                                  kk,
                                  ll
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
        }
      }
    }
    continuation.finish()
  }
}
