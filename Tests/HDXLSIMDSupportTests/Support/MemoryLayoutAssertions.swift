//
//  MemoryLayoutAssertions.swift
//

import XCTest
// TODO: setup an HDXLTestingSupport package, move these there?

internal func AssertMemoryEquivalentMemoryLayouts<A,B>(_ a: A.Type, _ b: B.Type) {
  XCTAssertEqual(
    MemoryLayout<A>.size,
    MemoryLayout<B>.size,
    """
    Expected identical `.size`, but got `(\(MemoryLayout<A>.size), \(MemoryLayout<B>.size))` for (\(String(reflecting: A.self)) and \(String(reflecting: B.self))), respectively.
    """
  )
  XCTAssertEqual(
    MemoryLayout<A>.alignment,
    MemoryLayout<B>.alignment,
    """
    Expected identical `.alignment`, but got `(\(MemoryLayout<A>.alignment), \(MemoryLayout<B>.alignment))` for (\(String(reflecting: A.self)) and \(String(reflecting: B.self))), respectively.
    """
  )
  XCTAssertEqual(
    MemoryLayout<A>.stride,
    MemoryLayout<B>.stride,
    """
    Expected identical `.stride`, but got `(\(MemoryLayout<A>.stride), \(MemoryLayout<B>.stride))` for (\(String(reflecting: A.self)) and \(String(reflecting: B.self))), respectively.
    """
  )
}

internal func AssertMemoryEquivalentMemoryLayouts<A,B,C>(_ a: A.Type, _ b: B.Type, _ c: C.Type) {
  AssertMemoryEquivalentMemoryLayouts(a,b)
  AssertMemoryEquivalentMemoryLayouts(b,c)
  AssertMemoryEquivalentMemoryLayouts(a,c)
}


