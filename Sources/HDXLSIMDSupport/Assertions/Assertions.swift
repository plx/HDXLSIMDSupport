//
//  Assertions.swift
//

import Foundation

// flip commented/uncommented to verify it passes even under `HEAVY_DEBUG`.
//#if true
#if HEAVY_DEBUG

@inline(__always)
@usableFromInline
internal func pedantic_assert(
  _ condition: @autoclosure () -> Bool,
  _ message: @autoclosure () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) {
  assert(condition(), message(), file: file, line: line)
}

#endif

