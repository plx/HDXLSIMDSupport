import Foundation

@usableFromInline
typealias Homogeneous16<T> = (
  T,T,T,T,
  T,T,T,T,
  T,T,T,T,
  T,T,T,T
)

@inlinable
func isNonZero<T>(_ values: Homogeneous16<T>) -> Bool where T: Numeric {
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
    ||
    values.12 != 0
    ||
    values.13 != 0
    ||
    values.14 != 0
    ||
    values.15 != 0
  )
}

@inlinable
func arity16Power<A>(of a: some Collection<A>) -> AsyncStream<Homogeneous16<A>> {
  return cartesianProduct(of: a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a)
}

@inlinable
func arity16EnumeratedPower<A>(of a: some Collection<A>) -> AsyncStream<EnumeratedValue<Homogeneous16<A>>> {
  return enumeratedCartesianProduct(of: a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a)
}

@inlinable
func cartesianProduct<A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P>(
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
  _  l: some Collection<L>,
  _  m: some Collection<M>,
  _  n: some Collection<N>,
  _  o: some Collection<O>,
  _  p: some Collection<P>
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
  L,
  M,
  N,
  O,
  P
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
    L,
    M,
    N,
    O,
    P
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
                            for mm in m {
                              for nn in n {
                                for oo in o {
                                  for pp in p {
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
                                        ll,
                                        mm,
                                        nn,
                                        oo,
                                        pp
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
          }
        }
      }
    }
    continuation.finish()
  }
}

@inlinable
func enumeratedCartesianProduct<A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P>(
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
  _  l: some Collection<L>,
  _  m: some Collection<M>,
  _  n: some Collection<N>,
  _  o: some Collection<O>,
  _  p: some Collection<P>
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
    L,
    M,
    N,
    O,
    P
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
      L,
      M,
      N,
      O,
      P
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
                            for mm in m {
                              for nn in n {
                                for oo in o {
                                  for pp in p {
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
                                          ll,
                                          mm,
                                          nn,
                                          oo,
                                          pp
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
          }
        }
      }
    }
    continuation.finish()
  }
}
