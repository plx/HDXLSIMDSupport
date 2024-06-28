import Testing
import simd
@testable import HDXLSIMDSupportProtocols

@Test("`SIMDAggregateScalar.simdInfixTypeName`")
func testSIMDAggregateScalarSIMDInfixTypeName() throws {
  #expect(
    "double" == SIMDAggregateScalar.double.simdInfixTypeName
  )
  #expect(
    "float" == SIMDAggregateScalar.float.simdInfixTypeName
  )
  #expect(
    "half" == SIMDAggregateScalar.half.simdInfixTypeName
  )
  
  // then double-check ourselves for uniqueness:
  #expect(
    try SIMDAggregateScalar
      .allCases
      .obtainsDistinctValues(for: \.simdInfixTypeName)
  )
}

@Test("`SIMDAggregateScalar.simdSuffixTypeCode`")
func testSIMDAggregateScalarSIMDSuffixTypeCode() throws {
  #expect(
    "d" == SIMDAggregateScalar.double.simdSuffixTypeCode
  )
  #expect(
    "f" == SIMDAggregateScalar.float.simdSuffixTypeCode
  )
  #expect(
    "h" == SIMDAggregateScalar.half.simdSuffixTypeCode
  )
  
  // then double-check ourselves for uniqueness:
  #expect(
    try SIMDAggregateScalar
      .allCases
      .obtainsDistinctValues(for: \.simdSuffixTypeCode)
  )
}

@Test(
  "`SIMDAggregateScalar.quaternionStorageTypeName`",
  arguments: zip(
    [SIMDAggregateScalar.double, SIMDAggregateScalar.float, SIMDAggregateScalar.half],
    ["DoubleQuaternionStorage", "FloatQuaternionStorage", "Float16QuaternionStorage"]
  )
)
func testSIMDAggregateScalarQuaternionStorageTypeName(
  scalar: SIMDAggregateScalar,
  expectedTypeName: String
) {
  #expect(
    scalar.quaternionStorageTypeName == expectedTypeName
  )
}

@Test("`SIMDAggregateScalar.nativeSIMDQuaternionTypeName`")
func testSIMDAggregateScalarNativeSIMDQuaternionTypeName() throws {
  // check we get the expected results:
  #expect(
    "simd_quatd" == SIMDAggregateScalar.double.nativeSIMDQuaternionTypeName
  )
  #expect(
    "simd_quatf" == SIMDAggregateScalar.float.nativeSIMDQuaternionTypeName
  )
  #expect(
    "simd_quath" == SIMDAggregateScalar.half.nativeSIMDQuaternionTypeName
  )
  
  // double-check we have the names correct:
  #expect(
    String(describing: simd_quatd.self) == "simd_quatd"
  )
  #expect(
    String(describing: simd_quatf.self) == "simd_quatf"
  )
  #expect(
    String(describing: simd_quath.self) == "simd_quath"
  )

  // triple-check we get the expected results:
  #expect(
    String(describing: simd_quatd.self) == SIMDAggregateScalar.double.nativeSIMDQuaternionTypeName
  )
  #expect(
    String(describing: simd_quatf.self) == SIMDAggregateScalar.float.nativeSIMDQuaternionTypeName
  )
  #expect(
    String(describing: simd_quath.self) == SIMDAggregateScalar.half.nativeSIMDQuaternionTypeName
  )

  // then quadruple-check ourselves for uniqueness:
  #expect(
    try SIMDAggregateScalar
      .allCases
      .obtainsDistinctValues(for: \.nativeSIMDQuaternionTypeName)
  )
}

@Test("`SIMDAggregateScalar.swiftTypeName`")
func testSIMDAggregateScalarSIMDSwiftTypeName() throws {
  #expect(
    "Double" == SIMDAggregateScalar.double.swiftTypeName
  )
  #expect(
    "Float" == SIMDAggregateScalar.float.swiftTypeName
  )
  #expect(
    "Float16" == SIMDAggregateScalar.half.swiftTypeName
  )
  
  // then double-check ourselves for uniqueness:
  #expect(
    try SIMDAggregateScalar
      .allCases
      .obtainsDistinctValues(for: \.swiftTypeName)
  )
}

fileprivate let typeNameStubs: [String] = [
  "Matrix2x2Storage",
  "Matrix2x3Storage",
  "Matrix2x4Storage",
  "Matrix3x2Storage",
  "Matrix3x3Storage",
  "Matrix3x4Storage",
  "Matrix4x2Storage",
  "Matrix4x3Storage",
  "Matrix4x4Storage",
  "QuaternionStorage"
]

@Test(
  "`SIMDAggregateScalar.extracting(fromSwiftTypeName:)`",
  arguments: zip(
    [
      SIMDAggregateScalar.double,
      SIMDAggregateScalar.float,
      SIMDAggregateScalar.half
    ],
    [
      typeNameStubs.bulkPrepending("Double"),
      typeNameStubs.bulkPrepending("Float"),
      typeNameStubs.bulkPrepending("Float16"),
    ]
  )
)
func testSIMDAggregateScalarExtractingFromSwiftTypeName(
  expectation: SIMDAggregateScalar,
  examples: [String]
) throws {
  for example in examples {
    let result = try #require(SIMDAggregateScalar.extracting(fromSwiftTypeName: example))
    #expect(expectation == result)
  }
}

@Test(
  "`SIMDAggregateScalar.extracting(fromSwiftTypeName:)` (invalid inputs)",
  arguments: [
    "NotASIMDType",
    "HalfMatrix2x2",
    "MatrixDoubleQuaternion"
  ]
)
func testSIMDAggregateScalarExtractingFromSwiftTypeNameOnInvalidInput(
  example: String
) throws {
  #expect(nil == SIMDAggregateScalar.extracting(fromSwiftTypeName: example))
}
