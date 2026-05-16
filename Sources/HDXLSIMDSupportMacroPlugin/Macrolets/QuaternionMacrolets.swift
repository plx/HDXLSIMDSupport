//
//  QuaternionMacrolets.swift
//
//  All quaternion-specific macrolets, bundled in one file for compactness.
//  Each struct implements a single slice of `QuaternionProtocol` (or a
//  cross-cutting conformance like Hashable/Codable) and emits the matching
//  code for native / storage / wrapper layers.
//

import SwiftSyntax

// MARK: - Typealiases

struct QuaternionTypealiasesMacrolet: SIMDQuaternionMacrolet {
  let descriptor: QuaternionDescriptor

  func implementationDeclarations(in context: QuaternionLayerContext) -> [DeclSyntax] {
    let scalar = context.scalarTypeName
    let mat3x3 = context.compatibleMatrix3x3TypeName
    let mat4x4 = context.compatibleMatrix4x4TypeName
    return [
      "public typealias Scalar = \(raw: scalar)",
      "public typealias CompatibleMatrix3x3 = \(raw: mat3x3)",
      "public typealias CompatibleMatrix4x4 = \(raw: mat4x4)"
    ]
  }
}

// MARK: - StorageBacking (storage/wrapper) + NativeSIMDRepresentable (wrapper)

struct QuaternionStorageBackingMacrolet: SIMDQuaternionMacrolet {
  let descriptor: QuaternionDescriptor

  func implementationDeclarations(in context: QuaternionLayerContext) -> [DeclSyntax] {
    guard let wrapped = context.wrappedTypeName else { return [] }
    return [
      "public typealias Storage = \(raw: wrapped)",
      "public var storage: Storage",
      """
      @inlinable
      public init(storage: Storage) {
        self.storage = storage
      }
      """
    ]
  }
}

struct QuaternionNumericAggregateMacrolet: SIMDQuaternionMacrolet {
  let descriptor: QuaternionDescriptor

  func implementationDeclarations(in context: QuaternionLayerContext) -> [DeclSyntax] {
    let scalar = context.scalarTypeName
    let typealiasDecl: DeclSyntax = "public typealias NumericEntryRepresentation = \(raw: scalar)"
    switch context.layer {
    case .native:
      return [
        typealiasDecl,
        """
        @inlinable
        public func allNumericEntriesSatisfy(
          _ predicate: (NumericEntryRepresentation) -> Bool
        ) -> Bool {
          vector.allNumericEntriesSatisfy(predicate)
        }
        """
      ]
    case .storage, .wrapper:
      return [
        typealiasDecl,
        """
        @inlinable
        public func allNumericEntriesSatisfy(
          _ predicate: (NumericEntryRepresentation) -> Bool
        ) -> Bool {
          storage.allNumericEntriesSatisfy(predicate)
        }
        """
      ]
    }
  }
}

// MARK: - NativeSIMDRepresentable (storage + wrapper)

struct QuaternionNativeSIMDRepresentableMacrolet: SIMDQuaternionMacrolet {
  let descriptor: QuaternionDescriptor

  func implementationDeclarations(in context: QuaternionLayerContext) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      return []
    case .storage:
      return [
        "public typealias NativeSIMDRepresentation = \(raw: descriptor.nativeTypeName)",
        """
        @inlinable
        public var nativeSIMDRepresentation: NativeSIMDRepresentation {
          get { storage }
          set { storage = newValue }
          _modify { yield &storage }
        }
        """,
        """
        @inlinable
        public init(nativeSIMDRepresentation: NativeSIMDRepresentation) {
          self.init(storage: nativeSIMDRepresentation)
        }
        """
      ]
    case .wrapper:
      return [
        "public typealias NativeSIMDRepresentation = Scalar.QuaternionStorage.NativeSIMDRepresentation",
        """
        @inlinable
        public var nativeSIMDRepresentation: NativeSIMDRepresentation {
          get { storage.nativeSIMDRepresentation }
          set { storage.nativeSIMDRepresentation = newValue }
          _modify { yield &storage.nativeSIMDRepresentation }
        }
        """,
        """
        @inlinable
        public init(nativeSIMDRepresentation: NativeSIMDRepresentation) {
          self.init(storage: Scalar.QuaternionStorage(nativeSIMDRepresentation: nativeSIMDRepresentation))
        }
        """
      ]
    }
  }
}

// MARK: - Initialization

struct QuaternionInitializationMacrolet: SIMDQuaternionMacrolet {
  let descriptor: QuaternionDescriptor

  func implementationDeclarations(in context: QuaternionLayerContext) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      return nativeInits(in: context)
    case .storage, .wrapper:
      return forwardingInits(in: context)
    }
  }

  private func nativeInits(in context: QuaternionLayerContext) -> [DeclSyntax] {
    // `init()` already exists for the simd_quat* types via Swift defaults.
    if descriptor.requiresCSwiftCalls {
      // simd_quath: only C-level `simd_quaternion(...)` entry points work.
      return [
        """
        @inlinable
        public init(i: Scalar, j: Scalar, k: Scalar, real: Scalar) {
          self = simd_quaternion(i, j, k, real)
        }
        """,
        """
        @inlinable
        public init(x: Scalar, y: Scalar, z: Scalar, real: Scalar) {
          self = simd_quaternion(x, y, z, real)
        }
        """,
        """
        @inlinable
        public init(realComponent: Scalar, imaginaryComponent: Vector3) {
          self = simd_quaternion(SIMD4<Scalar>(imaginaryComponent.x, imaginaryComponent.y, imaginaryComponent.z, realComponent))
        }
        """,
        """
        @inlinable
        public init(angleInRadians angle: Scalar, rotationAxis axis: Vector3) {
          self = simd_quaternion(angle, axis)
        }
        """,
        """
        @inlinable
        public init(rotating origin: Vector3, onto destination: Vector3) {
          self = simd_quaternion(origin, destination)
        }
        """,
        """
        @inlinable
        public init(rotationMatrix matrix: CompatibleMatrix3x3) {
          self = simd_quaternion(matrix)
        }
        """,
        """
        @inlinable
        public init(rotationMatrix matrix: CompatibleMatrix4x4) {
          self = simd_quaternion(matrix)
        }
        """
      ]
    }
    // simd_quatf / simd_quatd: Swift overlay provides labelled inits.
    return [
      """
      @inlinable
      public init(i: Scalar, j: Scalar, k: Scalar, real: Scalar) {
        self.init(ix: i, iy: j, iz: k, r: real)
      }
      """,
      """
      @inlinable
      public init(x: Scalar, y: Scalar, z: Scalar, real: Scalar) {
        self.init(ix: x, iy: y, iz: z, r: real)
      }
      """,
      """
      @inlinable
      public init(realComponent: Scalar, imaginaryComponent: Vector3) {
        self.init(real: realComponent, imag: imaginaryComponent)
      }
      """,
      """
      @inlinable
      public init(angleInRadians angle: Scalar, rotationAxis axis: Vector3) {
        self.init(angle: angle, axis: axis)
      }
      """,
      """
      @inlinable
      public init(rotating origin: Vector3, onto destination: Vector3) {
        self.init(from: origin, to: destination)
      }
      """,
      """
      @inlinable
      public init(rotationMatrix matrix: CompatibleMatrix3x3) {
        self.init(matrix)
      }
      """,
      """
      @inlinable
      public init(rotationMatrix matrix: CompatibleMatrix4x4) {
        self.init(matrix)
      }
      """
    ]
  }

  private func forwardingInits(in context: QuaternionLayerContext) -> [DeclSyntax] {
    guard let wrapped = context.wrappedTypeName else { return [] }
    // The compat-matrix inits walk through `matrix.storage` because
    // at storage/wrapper level the compatible matrix is also a wrapping type
    // (and its `storage` is exactly the underlying simd matrix /
    // matrix-storage).
    return [
      """
      @inlinable
      public init() {
        self.init(storage: \(raw: wrapped)())
      }
      """,
      """
      @inlinable
      public init(i: Scalar, j: Scalar, k: Scalar, real: Scalar) {
        self.init(storage: \(raw: wrapped)(i: i, j: j, k: k, real: real))
      }
      """,
      """
      @inlinable
      public init(x: Scalar, y: Scalar, z: Scalar, real: Scalar) {
        self.init(storage: \(raw: wrapped)(x: x, y: y, z: z, real: real))
      }
      """,
      """
      @inlinable
      public init(realComponent: Scalar, imaginaryComponent: Vector3) {
        self.init(storage: \(raw: wrapped)(realComponent: realComponent, imaginaryComponent: imaginaryComponent))
      }
      """,
      """
      @inlinable
      public init(angleInRadians angle: Scalar, rotationAxis axis: Vector3) {
        self.init(storage: \(raw: wrapped)(angleInRadians: angle, rotationAxis: axis))
      }
      """,
      """
      @inlinable
      public init(rotating origin: Vector3, onto destination: Vector3) {
        self.init(storage: \(raw: wrapped)(rotating: origin, onto: destination))
      }
      """,
      """
      @inlinable
      public init(rotationMatrix matrix: CompatibleMatrix3x3) {
        self.init(storage: \(raw: wrapped)(rotationMatrix: matrix.storage))
      }
      """,
      """
      @inlinable
      public init(rotationMatrix matrix: CompatibleMatrix4x4) {
        self.init(storage: \(raw: wrapped)(rotationMatrix: matrix.storage))
      }
      """
    ]
  }
}

// MARK: - Interpolation (slerp / bezier / spline)

struct QuaternionInterpolationMacrolet: SIMDQuaternionMacrolet {
  let descriptor: QuaternionDescriptor

  func implementationDeclarations(in context: QuaternionLayerContext) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      return [
        """
        @inlinable
        public static func slerp(
          _ q0: Self, _ q1: Self, _ t: Scalar, strategy: QuaternionSlerpStrategy
        ) -> Self {
          switch strategy {
          case .automatic, .shortest: return slerpShortest(q0, q1, t)
          case .longest: return slerpLongest(q0, q1, t)
          }
        }
        """,
        """
        @inlinable
        public static func slerpShortest(_ q0: Self, _ q1: Self, _ t: Scalar) -> Self {
          simd_slerp(q0, q1, t)
        }
        """,
        """
        @inlinable
        public static func slerpLongest(_ q0: Self, _ q1: Self, _ t: Scalar) -> Self {
          simd_slerp_longest(q0, q1, t)
        }
        """,
        """
        @inlinable
        public static func bezier(q0: Self, q1: Self, q2: Self, q3: Self, t: Scalar) -> Self {
          simd_bezier(q0, q1, q2, q3, t)
        }
        """,
        """
        @inlinable
        public static func spline(q0: Self, q1: Self, q2: Self, q3: Self, t: Scalar) -> Self {
          simd_spline(q0, q1, q2, q3, t)
        }
        """
      ]
    case .storage, .wrapper:
      guard let wrapped = context.wrappedTypeName else { return [] }
      return [
        """
        @inlinable
        public static func slerp(
          _ q0: Self, _ q1: Self, _ t: Scalar, strategy: QuaternionSlerpStrategy
        ) -> Self {
          switch strategy {
          case .automatic, .shortest: return slerpShortest(q0, q1, t)
          case .longest: return slerpLongest(q0, q1, t)
          }
        }
        """,
        """
        @inlinable
        public static func slerpShortest(_ q0: Self, _ q1: Self, _ t: Scalar) -> Self {
          Self(storage: \(raw: wrapped).slerpShortest(q0.storage, q1.storage, t))
        }
        """,
        """
        @inlinable
        public static func slerpLongest(_ q0: Self, _ q1: Self, _ t: Scalar) -> Self {
          Self(storage: \(raw: wrapped).slerpLongest(q0.storage, q1.storage, t))
        }
        """,
        """
        @inlinable
        public static func bezier(q0: Self, q1: Self, q2: Self, q3: Self, t: Scalar) -> Self {
          Self(storage: \(raw: wrapped).bezier(q0: q0.storage, q1: q1.storage, q2: q2.storage, q3: q3.storage, t: t))
        }
        """,
        """
        @inlinable
        public static func spline(q0: Self, q1: Self, q2: Self, q3: Self, t: Scalar) -> Self {
          Self(storage: \(raw: wrapped).spline(q0: q0.storage, q1: q1.storage, q2: q2.storage, q3: q3.storage, t: t))
        }
        """
      ]
    }
  }
}

// MARK: - Basic properties + apply

struct QuaternionBasicPropertiesMacrolet: SIMDQuaternionMacrolet {
  let descriptor: QuaternionDescriptor

  func implementationDeclarations(in context: QuaternionLayerContext) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      if descriptor.requiresCSwiftCalls {
        // simd_quath: use C entry points + direct vector accessor for set.
        return [
          """
          @inlinable
          public var realComponent: Scalar {
            get { simd_real(self) }
            set { vector.w = newValue }
            _modify { yield &vector.w }
          }
          """,
          """
          @inlinable
          public var imaginaryComponent: Vector3 {
            get { simd_imag(self) }
            set {
              vector.x = newValue.x
              vector.y = newValue.y
              vector.z = newValue.z
            }
          }
          """,
          """
          @inlinable
          public var angleInRadians: Scalar { get { simd_angle(self) } }
          """,
          """
          @inlinable
          public var rotationAxis: Vector3 { get { simd_axis(self) } }
          """,
          """
          @inlinable
          public var length: Scalar { get { simd_length(self) } }
          """,
          """
          @inlinable
          public func apply(to vector: Vector3) -> Vector3 { simd_act(self, vector) }
          """
        ]
      }
      // float/double: Swift overlay provides `.real`, `.imag`, etc.
      return [
        """
        @inlinable
        public var realComponent: Scalar {
          get { real }
          set { real = newValue }
          _modify { yield &real }
        }
        """,
        """
        @inlinable
        public var imaginaryComponent: Vector3 {
          get { imag }
          set { imag = newValue }
          _modify { yield &imag }
        }
        """,
        """
        @inlinable
        public var angleInRadians: Scalar { get { angle } }
        """,
        """
        @inlinable
        public var rotationAxis: Vector3 { get { axis } }
        """,
        """
        @inlinable
        public func apply(to vector: Vector3) -> Vector3 { act(vector) }
        """
        // `length` is provided by the simd overlay's `.length` for float/double.
      ]
    case .storage, .wrapper:
      return [
        """
        @inlinable
        public var realComponent: Scalar {
          get { storage.realComponent }
          set { storage.realComponent = newValue }
          _modify { yield &storage.realComponent }
        }
        """,
        """
        @inlinable
        public var imaginaryComponent: Vector3 {
          get { storage.imaginaryComponent }
          set { storage.imaginaryComponent = newValue }
          _modify { yield &storage.imaginaryComponent }
        }
        """,
        """
        @inlinable
        public var angleInRadians: Scalar { get { storage.angleInRadians } }
        """,
        """
        @inlinable
        public var rotationAxis: Vector3 { get { storage.rotationAxis } }
        """,
        """
        @inlinable
        public var length: Scalar { get { storage.length } }
        """,
        """
        @inlinable
        public func apply(to vector: Vector3) -> Vector3 { storage.apply(to: vector) }
        """
      ]
    }
  }
}

// MARK: - Normalization / Norms / Inversion / Conjugation / Negation

struct QuaternionUnaryOperationsMacrolet: SIMDQuaternionMacrolet {
  let descriptor: QuaternionDescriptor

  func implementationDeclarations(in context: QuaternionLayerContext) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      let normalized: String
      let inverted: String
      let conjugated: String
      let negated: String
      let formNegation: String
      if descriptor.requiresCSwiftCalls {
        normalized = "simd_normalize(self)"
        inverted = "simd_inverse(self)"
        conjugated = "simd_conjugate(self)"
        negated = "Self(vector: -vector)"
        formNegation = "vector = -vector"
      } else {
        normalized = "normalized"
        inverted = "inverse"
        conjugated = "conjugate"
        negated = "-self"
        formNegation = "self = -self"
      }
      return [
        """
        @inlinable
        public func normalized() -> Self { \(raw: normalized) }
        """,
        """
        @inlinable
        public mutating func formNormalization() { self = \(raw: normalized) }
        """,
        """
        @inlinable
        public var componentwiseMagnitudeSquared: Scalar {
          get { simd_length_squared(vector) }
        }
        """,
        """
        @inlinable
        public func inverted() -> Self { \(raw: inverted) }
        """,
        """
        @inlinable
        public mutating func formInverse() { self = \(raw: inverted) }
        """,
        """
        @inlinable
        public func conjugated() -> Self { \(raw: conjugated) }
        """,
        """
        @inlinable
        public mutating func formConjugate() { self = \(raw: conjugated) }
        """,
        """
        @inlinable
        public func negated() -> Self { \(raw: negated) }
        """,
        """
        @inlinable
        public mutating func formNegation() { \(raw: formNegation) }
        """
      ]
    case .storage, .wrapper:
      return [
        """
        @inlinable
        public func normalized() -> Self { Self(storage: storage.normalized()) }
        """,
        """
        @inlinable
        public mutating func formNormalization() { storage.formNormalization() }
        """,
        """
        @inlinable
        public var componentwiseMagnitudeSquared: Scalar {
          get { storage.componentwiseMagnitudeSquared }
        }
        """,
        """
        @inlinable
        public func inverted() -> Self { Self(storage: storage.inverted()) }
        """,
        """
        @inlinable
        public mutating func formInverse() { storage.formInverse() }
        """,
        """
        @inlinable
        public func conjugated() -> Self { Self(storage: storage.conjugated()) }
        """,
        """
        @inlinable
        public mutating func formConjugate() { storage.formConjugate() }
        """,
        """
        @inlinable
        public func negated() -> Self { Self(storage: storage.negated()) }
        """,
        """
        @inlinable
        public mutating func formNegation() { storage.formNegation() }
        """
      ]
    }
  }

  func validationTestDeclarations(in context: QuaternionLayerContext) -> [DeclSyntax] {
    let wrapper = descriptor.wrapperTypeInstantiation
    let native = descriptor.nativeTypeName
    let scalar = descriptor.representation.swiftScalarTypeName
    let nativeNormalize: String
    let nativeInverse: String
    let nativeConjugate: String
    let nativeNegate: String
    switch descriptor.representation {
    case .half:
      nativeNormalize = "simd_normalize(q)"
      nativeInverse = "simd_inverse(q)"
      nativeConjugate = "simd_conjugate(q)"
      nativeNegate = "\(native)(vector: -q.vector)"
    case .float, .double:
      nativeNormalize = "q.normalized"
      nativeInverse = "q.inverse"
      nativeConjugate = "q.conjugate"
      nativeNegate = "-q"
    }
    return [
      """
      func test_negation() {
        let probes: [[\(raw: scalar)]] = \(raw: descriptor.probeQuaternionsArrayExpression)
        validateQuaternionUnaryEquivalence(
          "negated()",
          probes: probes,
          epsilon: \(raw: descriptor.defaultEpsilonLiteral),
          wrapped: { (q: \(raw: wrapper)) -> \(raw: wrapper) in q.negated() },
          native: { (q: \(raw: native)) -> \(raw: native) in \(raw: nativeNegate) }
        )
      }
      """,
      """
      func test_conjugation() {
        let probes: [[\(raw: scalar)]] = \(raw: descriptor.probeQuaternionsArrayExpression)
        validateQuaternionUnaryEquivalence(
          "conjugated()",
          probes: probes,
          epsilon: \(raw: descriptor.defaultEpsilonLiteral),
          wrapped: { (q: \(raw: wrapper)) -> \(raw: wrapper) in q.conjugated() },
          native: { (q: \(raw: native)) -> \(raw: native) in \(raw: nativeConjugate) }
        )
      }
      """,
      """
      func test_normalization() {
        let probes: [[\(raw: scalar)]] = \(raw: descriptor.nonZeroProbeQuaternionsArrayExpression)
        validateQuaternionUnaryEquivalence(
          "normalized()",
          probes: probes,
          epsilon: \(raw: descriptor.divisionEpsilonLiteral),
          wrapped: { (q: \(raw: wrapper)) -> \(raw: wrapper) in q.normalized() },
          native: { (q: \(raw: native)) -> \(raw: native) in \(raw: nativeNormalize) }
        )
      }
      """,
      """
      func test_inversion() {
        let probes: [[\(raw: scalar)]] = \(raw: descriptor.nonZeroProbeQuaternionsArrayExpression)
        validateQuaternionUnaryEquivalence(
          "inverted()",
          probes: probes,
          epsilon: \(raw: descriptor.divisionEpsilonLiteral),
          wrapped: { (q: \(raw: wrapper)) -> \(raw: wrapper) in q.inverted() },
          native: { (q: \(raw: native)) -> \(raw: native) in \(raw: nativeInverse) }
        )
      }
      """,
      """
      func test_componentwiseMagnitudeSquared() {
        let probes: [[\(raw: scalar)]] = \(raw: descriptor.probeQuaternionsArrayExpression)
        validateQuaternionUnaryScalarOutEquivalence(
          "componentwiseMagnitudeSquared",
          probes: probes,
          epsilon: \(raw: descriptor.defaultEpsilonLiteral),
          wrapped: { (q: \(raw: wrapper)) -> \(raw: scalar) in q.componentwiseMagnitudeSquared },
          native: { (q: \(raw: native)) -> \(raw: scalar) in simd_length_squared(q.vector) }
        )
      }
      """
    ]
  }
}

// MARK: - Add / Sub / FMA / FMS / Scalar mul-div / Quaternion mul-div / Dot

struct QuaternionArithmeticMacrolet: SIMDQuaternionMacrolet {
  let descriptor: QuaternionDescriptor

  func implementationDeclarations(in context: QuaternionLayerContext) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      // For simd_quath we work via the underlying `vector` and `simd_mul`.
      // For simd_quatf / simd_quatd Swift operators exist on the quaternion.
      if descriptor.requiresCSwiftCalls {
        return [
          """
          @inlinable
          public func adding(_ other: Self) -> Self { Self(vector: vector + other.vector) }
          """,
          """
          @inlinable
          public mutating func formAddition(of other: Self) { vector += other.vector }
          """,
          """
          @inlinable
          public func adding(_ other: Self, multipliedBy factor: Scalar) -> Self {
            Self(vector: vector + (other.vector * factor))
          }
          """,
          """
          @inlinable
          public mutating func formAddition(of other: Self, multipliedBy factor: Scalar) {
            vector += (other.vector * factor)
          }
          """,
          """
          @inlinable
          public func subtracting(_ other: Self) -> Self { Self(vector: vector - other.vector) }
          """,
          """
          @inlinable
          public mutating func formSubtraction(of other: Self) { vector -= other.vector }
          """,
          """
          @inlinable
          public func subtracting(_ other: Self, multipliedBy factor: Scalar) -> Self {
            Self(vector: vector - (other.vector * factor))
          }
          """,
          """
          @inlinable
          public mutating func formSubtraction(of other: Self, multipliedBy factor: Scalar) {
            vector -= (other.vector * factor)
          }
          """,
          """
          @inlinable
          public func multiplied(by factor: Scalar) -> Self { simd_mul(self, factor) }
          """,
          """
          @inlinable
          public mutating func formMultiplication(by factor: Scalar) { self = simd_mul(self, factor) }
          """,
          """
          @inlinable
          public func divided(by factor: Scalar) -> Self { Self(vector: vector / factor) }
          """,
          """
          @inlinable
          public mutating func formDivision(by factor: Scalar) { vector /= factor }
          """,
          """
          @inlinable
          public func multiplied(onRightBy other: Self) -> Self { simd_mul(self, other) }
          """,
          """
          @inlinable
          public func multiplied(onLeftBy other: Self) -> Self { simd_mul(other, self) }
          """,
          """
          @inlinable
          public mutating func formMultiplication(onRightBy other: Self) { self = simd_mul(self, other) }
          """,
          """
          @inlinable
          public mutating func formMultiplication(onLeftBy other: Self) { self = simd_mul(other, self) }
          """,
          """
          @inlinable
          public func divided(onRightBy other: Self) -> Self { simd_mul(self, simd_inverse(other)) }
          """,
          """
          @inlinable
          public func divided(onLeftBy other: Self) -> Self { simd_mul(simd_inverse(other), self) }
          """,
          """
          @inlinable
          public mutating func formDivision(onRightBy other: Self) { self = simd_mul(self, simd_inverse(other)) }
          """,
          """
          @inlinable
          public mutating func formDivision(onLeftBy other: Self) { self = simd_mul(simd_inverse(other), self) }
          """,
          """
          @inlinable
          public func dotted(with other: Self) -> Scalar { simd_dot(self, other) }
          """
        ]
      }
      return [
        """
        @inlinable
        public func adding(_ other: Self) -> Self { self + other }
        """,
        """
        @inlinable
        public mutating func formAddition(of other: Self) { self += other }
        """,
        """
        @inlinable
        public func adding(_ other: Self, multipliedBy factor: Scalar) -> Self {
          self + (other * factor)
        }
        """,
        """
        @inlinable
        public mutating func formAddition(of other: Self, multipliedBy factor: Scalar) {
          self += (other * factor)
        }
        """,
        """
        @inlinable
        public func subtracting(_ other: Self) -> Self { self - other }
        """,
        """
        @inlinable
        public mutating func formSubtraction(of other: Self) { self -= other }
        """,
        """
        @inlinable
        public func subtracting(_ other: Self, multipliedBy factor: Scalar) -> Self {
          self - (other * factor)
        }
        """,
        """
        @inlinable
        public mutating func formSubtraction(of other: Self, multipliedBy factor: Scalar) {
          self -= (other * factor)
        }
        """,
        """
        @inlinable
        public func multiplied(by factor: Scalar) -> Self { self * factor }
        """,
        """
        @inlinable
        public mutating func formMultiplication(by factor: Scalar) { self *= factor }
        """,
        """
        @inlinable
        public func divided(by factor: Scalar) -> Self { self / factor }
        """,
        """
        @inlinable
        public mutating func formDivision(by factor: Scalar) { self /= factor }
        """,
        """
        @inlinable
        public func multiplied(onRightBy other: Self) -> Self { self * other }
        """,
        """
        @inlinable
        public func multiplied(onLeftBy other: Self) -> Self { other * self }
        """,
        """
        @inlinable
        public mutating func formMultiplication(onRightBy other: Self) { self = self * other }
        """,
        """
        @inlinable
        public mutating func formMultiplication(onLeftBy other: Self) { self = other * self }
        """,
        """
        @inlinable
        public func divided(onRightBy other: Self) -> Self { self / other }
        """,
        """
        @inlinable
        public func divided(onLeftBy other: Self) -> Self { other.inverse * self }
        """,
        """
        @inlinable
        public mutating func formDivision(onRightBy other: Self) { self /= other }
        """,
        """
        @inlinable
        public mutating func formDivision(onLeftBy other: Self) { self = other.inverse * self }
        """,
        """
        @inlinable
        public func dotted(with other: Self) -> Scalar { simd_dot(self, other) }
        """
      ]
    case .storage, .wrapper:
      return [
        """
        @inlinable
        public func adding(_ other: Self) -> Self {
          Self(storage: storage.adding(other.storage))
        }
        """,
        """
        @inlinable
        public mutating func formAddition(of other: Self) {
          storage.formAddition(of: other.storage)
        }
        """,
        """
        @inlinable
        public func adding(_ other: Self, multipliedBy factor: Scalar) -> Self {
          Self(storage: storage.adding(other.storage, multipliedBy: factor))
        }
        """,
        """
        @inlinable
        public mutating func formAddition(of other: Self, multipliedBy factor: Scalar) {
          storage.formAddition(of: other.storage, multipliedBy: factor)
        }
        """,
        """
        @inlinable
        public func subtracting(_ other: Self) -> Self {
          Self(storage: storage.subtracting(other.storage))
        }
        """,
        """
        @inlinable
        public mutating func formSubtraction(of other: Self) {
          storage.formSubtraction(of: other.storage)
        }
        """,
        """
        @inlinable
        public func subtracting(_ other: Self, multipliedBy factor: Scalar) -> Self {
          Self(storage: storage.subtracting(other.storage, multipliedBy: factor))
        }
        """,
        """
        @inlinable
        public mutating func formSubtraction(of other: Self, multipliedBy factor: Scalar) {
          storage.formSubtraction(of: other.storage, multipliedBy: factor)
        }
        """,
        """
        @inlinable
        public func multiplied(by factor: Scalar) -> Self {
          Self(storage: storage.multiplied(by: factor))
        }
        """,
        """
        @inlinable
        public mutating func formMultiplication(by factor: Scalar) {
          storage.formMultiplication(by: factor)
        }
        """,
        """
        @inlinable
        public func divided(by factor: Scalar) -> Self {
          Self(storage: storage.divided(by: factor))
        }
        """,
        """
        @inlinable
        public mutating func formDivision(by factor: Scalar) {
          storage.formDivision(by: factor)
        }
        """,
        """
        @inlinable
        public func multiplied(onRightBy other: Self) -> Self {
          Self(storage: storage.multiplied(onRightBy: other.storage))
        }
        """,
        """
        @inlinable
        public func multiplied(onLeftBy other: Self) -> Self {
          Self(storage: storage.multiplied(onLeftBy: other.storage))
        }
        """,
        """
        @inlinable
        public mutating func formMultiplication(onRightBy other: Self) {
          storage.formMultiplication(onRightBy: other.storage)
        }
        """,
        """
        @inlinable
        public mutating func formMultiplication(onLeftBy other: Self) {
          storage.formMultiplication(onLeftBy: other.storage)
        }
        """,
        """
        @inlinable
        public func divided(onRightBy other: Self) -> Self {
          Self(storage: storage.divided(onRightBy: other.storage))
        }
        """,
        """
        @inlinable
        public func divided(onLeftBy other: Self) -> Self {
          Self(storage: storage.divided(onLeftBy: other.storage))
        }
        """,
        """
        @inlinable
        public mutating func formDivision(onRightBy other: Self) {
          storage.formDivision(onRightBy: other.storage)
        }
        """,
        """
        @inlinable
        public mutating func formDivision(onLeftBy other: Self) {
          storage.formDivision(onLeftBy: other.storage)
        }
        """,
        """
        @inlinable
        public func dotted(with other: Self) -> Scalar {
          storage.dotted(with: other.storage)
        }
        """
      ]
    }
  }

  func validationTestDeclarations(in context: QuaternionLayerContext) -> [DeclSyntax] {
    let wrapper = descriptor.wrapperTypeInstantiation
    let native = descriptor.nativeTypeName
    let scalar = descriptor.representation.swiftScalarTypeName

    let nativeAdd: String
    let nativeSub: String
    let nativeFMA: String
    let nativeFMS: String
    let nativeScalarMul: String
    let nativeScalarDiv: String
    let nativeMulRight: String
    let nativeMulLeft: String
    let nativeDivRight: String
    let nativeDivLeft: String

    switch descriptor.representation {
    case .half:
      nativeAdd = "\(native)(vector: a.vector + b.vector)"
      nativeSub = "\(native)(vector: a.vector - b.vector)"
      nativeFMA = "\(native)(vector: a.vector + (b.vector * s))"
      nativeFMS = "\(native)(vector: a.vector - (b.vector * s))"
      nativeScalarMul = "simd_mul(q, s)"
      nativeScalarDiv = "\(native)(vector: q.vector / s)"
      nativeMulRight = "simd_mul(a, b)"
      nativeMulLeft = "simd_mul(b, a)"
      nativeDivRight = "simd_mul(a, simd_inverse(b))"
      nativeDivLeft = "simd_mul(simd_inverse(b), a)"
    case .float, .double:
      nativeAdd = "a + b"
      nativeSub = "a - b"
      nativeFMA = "a + (b * s)"
      nativeFMS = "a - (b * s)"
      nativeScalarMul = "q * s"
      nativeScalarDiv = "q / s"
      nativeMulRight = "a * b"
      nativeMulLeft = "b * a"
      nativeDivRight = "a / b"
      nativeDivLeft = "b.inverse * a"
    }

    return [
      """
      func test_quaternionAddition() {
        let probes: [[\(raw: scalar)]] = \(raw: descriptor.probeQuaternionsArrayExpression)
        validateQuaternionBinaryEquivalence(
          "adding(_:)",
          lhses: probes,
          rhses: probes,
          epsilon: \(raw: descriptor.defaultEpsilonLiteral),
          wrapped: { (a: \(raw: wrapper), b: \(raw: wrapper)) -> \(raw: wrapper) in a.adding(b) },
          native: { (a: \(raw: native), b: \(raw: native)) -> \(raw: native) in \(raw: nativeAdd) }
        )
      }
      """,
      """
      func test_quaternionSubtraction() {
        let probes: [[\(raw: scalar)]] = \(raw: descriptor.probeQuaternionsArrayExpression)
        validateQuaternionBinaryEquivalence(
          "subtracting(_:)",
          lhses: probes,
          rhses: probes,
          epsilon: \(raw: descriptor.defaultEpsilonLiteral),
          wrapped: { (a: \(raw: wrapper), b: \(raw: wrapper)) -> \(raw: wrapper) in a.subtracting(b) },
          native: { (a: \(raw: native), b: \(raw: native)) -> \(raw: native) in \(raw: nativeSub) }
        )
      }
      """,
      """
      func test_fusedMultiplyAdd() {
        let probes: [[\(raw: scalar)]] = \(raw: descriptor.probeQuaternionsArrayExpression)
        let scalars: [\(raw: scalar)] = \(raw: descriptor.probeScalarsArrayExpression)
        validateQuaternionBinaryScalarEquivalence(
          "adding(_:multipliedBy:)",
          lhses: probes,
          rhses: probes,
          scalars: scalars,
          epsilon: \(raw: descriptor.defaultEpsilonLiteral),
          wrapped: { (a: \(raw: wrapper), b: \(raw: wrapper), s: \(raw: scalar)) -> \(raw: wrapper) in a.adding(b, multipliedBy: s) },
          native: { (a: \(raw: native), b: \(raw: native), s: \(raw: scalar)) -> \(raw: native) in \(raw: nativeFMA) }
        )
      }
      """,
      """
      func test_fusedMultiplySubtract() {
        let probes: [[\(raw: scalar)]] = \(raw: descriptor.probeQuaternionsArrayExpression)
        let scalars: [\(raw: scalar)] = \(raw: descriptor.probeScalarsArrayExpression)
        validateQuaternionBinaryScalarEquivalence(
          "subtracting(_:multipliedBy:)",
          lhses: probes,
          rhses: probes,
          scalars: scalars,
          epsilon: \(raw: descriptor.defaultEpsilonLiteral),
          wrapped: { (a: \(raw: wrapper), b: \(raw: wrapper), s: \(raw: scalar)) -> \(raw: wrapper) in a.subtracting(b, multipliedBy: s) },
          native: { (a: \(raw: native), b: \(raw: native), s: \(raw: scalar)) -> \(raw: native) in \(raw: nativeFMS) }
        )
      }
      """,
      """
      func test_scalarMultiplication() {
        let probes: [[\(raw: scalar)]] = \(raw: descriptor.probeQuaternionsArrayExpression)
        let scalars: [\(raw: scalar)] = \(raw: descriptor.probeScalarsArrayExpression)
        validateQuaternionScalarEquivalence(
          "multiplied(by:)",
          probes: probes,
          scalars: scalars,
          epsilon: \(raw: descriptor.defaultEpsilonLiteral),
          wrapped: { (q: \(raw: wrapper), s: \(raw: scalar)) -> \(raw: wrapper) in q.multiplied(by: s) },
          native: { (q: \(raw: native), s: \(raw: scalar)) -> \(raw: native) in \(raw: nativeScalarMul) }
        )
      }
      """,
      """
      func test_scalarDivision() {
        let probes: [[\(raw: scalar)]] = \(raw: descriptor.probeQuaternionsArrayExpression)
        let scalars: [\(raw: scalar)] = \(raw: descriptor.nonZeroProbeScalarsArrayExpression)
        validateQuaternionScalarEquivalence(
          "divided(by:)",
          probes: probes,
          scalars: scalars,
          epsilon: \(raw: descriptor.defaultEpsilonLiteral),
          wrapped: { (q: \(raw: wrapper), s: \(raw: scalar)) -> \(raw: wrapper) in q.divided(by: s) },
          native: { (q: \(raw: native), s: \(raw: scalar)) -> \(raw: native) in \(raw: nativeScalarDiv) }
        )
      }
      """,
      """
      func test_quaternionMultiplicationRight() {
        let probes: [[\(raw: scalar)]] = \(raw: descriptor.probeQuaternionsArrayExpression)
        validateQuaternionBinaryEquivalence(
          "multiplied(onRightBy:)",
          lhses: probes,
          rhses: probes,
          epsilon: \(raw: descriptor.defaultEpsilonLiteral),
          wrapped: { (a: \(raw: wrapper), b: \(raw: wrapper)) -> \(raw: wrapper) in a.multiplied(onRightBy: b) },
          native: { (a: \(raw: native), b: \(raw: native)) -> \(raw: native) in \(raw: nativeMulRight) }
        )
      }
      """,
      """
      func test_quaternionMultiplicationLeft() {
        let probes: [[\(raw: scalar)]] = \(raw: descriptor.probeQuaternionsArrayExpression)
        validateQuaternionBinaryEquivalence(
          "multiplied(onLeftBy:)",
          lhses: probes,
          rhses: probes,
          epsilon: \(raw: descriptor.defaultEpsilonLiteral),
          wrapped: { (a: \(raw: wrapper), b: \(raw: wrapper)) -> \(raw: wrapper) in a.multiplied(onLeftBy: b) },
          native: { (a: \(raw: native), b: \(raw: native)) -> \(raw: native) in \(raw: nativeMulLeft) }
        )
      }
      """,
      """
      func test_quaternionDivisionRight() {
        let lhses: [[\(raw: scalar)]] = \(raw: descriptor.probeQuaternionsArrayExpression)
        let rhses: [[\(raw: scalar)]] = \(raw: descriptor.nonZeroProbeQuaternionsArrayExpression)
        validateQuaternionBinaryEquivalence(
          "divided(onRightBy:)",
          lhses: lhses,
          rhses: rhses,
          epsilon: \(raw: descriptor.divisionEpsilonLiteral),
          wrapped: { (a: \(raw: wrapper), b: \(raw: wrapper)) -> \(raw: wrapper) in a.divided(onRightBy: b) },
          native: { (a: \(raw: native), b: \(raw: native)) -> \(raw: native) in \(raw: nativeDivRight) }
        )
      }
      """,
      """
      func test_quaternionDivisionLeft() {
        let lhses: [[\(raw: scalar)]] = \(raw: descriptor.probeQuaternionsArrayExpression)
        let rhses: [[\(raw: scalar)]] = \(raw: descriptor.nonZeroProbeQuaternionsArrayExpression)
        validateQuaternionBinaryEquivalence(
          "divided(onLeftBy:)",
          lhses: lhses,
          rhses: rhses,
          epsilon: \(raw: descriptor.divisionEpsilonLiteral),
          wrapped: { (a: \(raw: wrapper), b: \(raw: wrapper)) -> \(raw: wrapper) in a.divided(onLeftBy: b) },
          native: { (a: \(raw: native), b: \(raw: native)) -> \(raw: native) in \(raw: nativeDivLeft) }
        )
      }
      """,
      """
      func test_quaternionDotProduct() {
        let probes: [[\(raw: scalar)]] = \(raw: descriptor.probeQuaternionsArrayExpression)
        validateQuaternionBinaryScalarOutEquivalence(
          "dotted(with:)",
          lhses: probes,
          rhses: probes,
          epsilon: \(raw: descriptor.defaultEpsilonLiteral),
          wrapped: { (a: \(raw: wrapper), b: \(raw: wrapper)) -> \(raw: scalar) in a.dotted(with: b) },
          native: { (a: \(raw: native), b: \(raw: native)) -> \(raw: scalar) in simd_dot(a, b) }
        )
      }
      """
    ]
  }
}

// MARK: - Hashable / Codable / Description (storage / wrapper only)

struct QuaternionHashableMacrolet: SIMDQuaternionMacrolet {
  let descriptor: QuaternionDescriptor

  func implementationDeclarations(in context: QuaternionLayerContext) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      return []
    case .storage:
      return [
        """
        @inlinable
        public func hash(into hasher: inout Hasher) {
          storage.vector.hash(into: &hasher)
        }
        """,
        """
        @inlinable
        public static func == (lhs: Self, rhs: Self) -> Bool {
          lhs.storage.vector == rhs.storage.vector
        }
        """
      ]
    case .wrapper:
      return [
        """
        @inlinable
        public func hash(into hasher: inout Hasher) {
          storage.hash(into: &hasher)
        }
        """,
        """
        @inlinable
        public static func == (lhs: Self, rhs: Self) -> Bool {
          lhs.storage == rhs.storage
        }
        """
      ]
    }
  }
}

struct QuaternionCodableMacrolet: SIMDQuaternionMacrolet {
  let descriptor: QuaternionDescriptor

  func implementationDeclarations(in context: QuaternionLayerContext) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      return []
    case .storage:
      return [
        """
        @inlinable
        public func encode(to encoder: Encoder) throws {
          var container = encoder.singleValueContainer()
          try container.encode(storage.vector)
        }
        """,
        """
        @inlinable
        public init(from decoder: Decoder) throws {
          let container = try decoder.singleValueContainer()
          let vector = try container.decode(SIMD4<Scalar>.self)
          self.init(storage: Storage(vector: vector))
        }
        """
      ]
    case .wrapper:
      return [
        """
        @inlinable
        public func encode(to encoder: Encoder) throws {
          try storage.encode(to: encoder)
        }
        """,
        """
        @inlinable
        public init(from decoder: Decoder) throws {
          self.init(storage: try Storage(from: decoder))
        }
        """
      ]
    }
  }
}

struct QuaternionDescriptionMacrolet: SIMDQuaternionMacrolet {
  let descriptor: QuaternionDescriptor

  func implementationDeclarations(in context: QuaternionLayerContext) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      return []
    case .storage:
      let typename = descriptor.storageTypeName
      return [
        """
        @inlinable
        public var description: String {
          get { "\(raw: typename): \\(String(describing: storage))" }
        }
        """,
        """
        @inlinable
        public var debugDescription: String {
          get { "\(raw: typename)(storage: \\(String(reflecting: storage)))" }
        }
        """
      ]
    case .wrapper:
      return [
        """
        @inlinable
        public var description: String {
          get { "Quaternion: \\(String(describing: nativeSIMDRepresentation))" }
        }
        """,
        """
        @inlinable
        public var debugDescription: String {
          get { "Quaternion<\\(String(reflecting: Scalar.self))>(nativeSIMDRepresentation: \\(String(reflecting: nativeSIMDRepresentation)))" }
        }
        """
      ]
    }
  }
}

// MARK: - VectorArithmetic (wrapper only)

struct QuaternionVectorArithmeticMacrolet: SIMDQuaternionMacrolet {
  let descriptor: QuaternionDescriptor

  func implementationDeclarations(in context: QuaternionLayerContext) -> [DeclSyntax] {
    guard context.layer == .wrapper else { return [] }
    return [
      """
      @inlinable
      public static var zero: Quaternion<Scalar> { get { Quaternion<Scalar>() } }
      """,
      """
      @inlinable
      public var magnitudeSquared: Double { get { Double(componentwiseMagnitudeSquared) } }
      """,
      """
      @inlinable
      public mutating func scale(by factor: Double) { formMultiplication(by: Scalar(factor)) }
      """
    ]
  }
}
