# HDXLSIMDSupport Macro Migration Prompts

This document provides specific prompts and guidance for implementing each phase of the macro migration.

## Phase 1: Foundation Setup

### Prompt 1.1: Create Macro Plugin Structure

```
I need to set up the macro plugin infrastructure for HDXLSIMDSupport. Please:

1. Add SwiftSyntax dependencies to Package.swift
2. Create the macro plugin target structure
3. Set up the basic plugin entry point
4. Create a simple test macro to verify the setup works

The plugin should be named HDXLSIMDSupportMacrosPlugin and should follow Swift macro best practices.
```

### Prompt 1.2: Create Operation Type System

```
I need to create an operation type system for co-generating implementations and tests. Please create:

1. A protocol `SIMDOperation` that describes an operation
2. A concrete type `MatrixAdditionOperation` that implements this protocol
3. Methods on the protocol to:
   - Generate implementation syntax (generateImplementation())
   - Generate test syntax (generateTest())
   
The operation should know how to generate both the Swift code for matrix addition and a corresponding test that verifies the operation works correctly.
```

### Prompt 1.3: Implement First Macro

```
Using the operation type system, implement a macro @GenerateMatrixOperations that:

1. Can be applied to a matrix type (e.g., Matrix2x2)
2. Reads a list of operations to generate
3. Generates the implementation methods
4. Stores metadata for test generation

Start with just addition for Matrix2x2 as a proof of concept. The macro should generate:
- An addition operator method
- A formAddition mutating method
```

## Phase 2: Core Types Migration

### Prompt 2.1: Storage Type Macros

```
Create a macro @MatrixStorage that generates the complete storage type implementation. When applied like:

@MatrixStorage(rows: 2, columns: 2, scalar: Float)
struct FloatMatrix2x2Storage { }

It should generate:
1. The passthrough value property
2. All required protocol conformances
3. Initialization methods
4. Subscript implementations
5. Automatic Sendable conformance when appropriate

Include proper error handling for invalid dimensions.
```

### Prompt 2.2: Protocol Conformance Macros

```
Create macros for generating common protocol conformances:

1. @GenerateNumericAggregate - generates all NumericAggregate requirements
2. @GenerateNativeSIMDRepresentable - generates the SIMD bridging code
3. @GenerateMatrixProtocol(rows: Int, columns: Int) - generates matrix protocol requirements

Each macro should:
- Validate that prerequisites are met
- Generate efficient implementations
- Include appropriate inline annotations
- Generate the Sendable conformance pattern we established
```

### Prompt 2.3: Operator Generation

```
Enhance the operation system to generate all arithmetic operators. Create operation types for:

1. Addition (already done)
2. Subtraction
3. Scalar multiplication
4. Matrix multiplication (with dimension validation)
5. Element-wise operations

The macro should generate both the operator and the corresponding mutating form method. Also generate tests that verify:
- Correctness against the native SIMD implementation
- Proper dimension checking
- Performance characteristics
```

## Phase 3: Complex Patterns

### Prompt 3.1: Matrix Multiplication Handling

```
Implement sophisticated matrix multiplication generation that:

1. Validates dimension compatibility at macro expansion time
2. Generates optimized implementations based on matrix size
3. Creates specialized paths for square matrices
4. Generates comprehensive tests including:
   - Identity matrix properties
   - Associativity tests
   - Dimension mismatch error tests

The macro should be smart about which multiplication operations are valid for each matrix size.
```

### Prompt 3.2: Specialized Operations

```
Create a @SquareMatrixOperations macro that generates operations only valid for square matrices:

1. Transpose (in-place and out-of-place)
2. Determinant calculation
3. Inverse calculation (with singularity checking)
4. Trace calculation
5. Diagonal extraction

Each operation should include:
- Comprehensive error handling
- Performance-optimized implementation
- Full test coverage including edge cases
```

### Prompt 3.3: Serialization Macros

```
Create serialization macros that generate:

1. @ColumnarCodable - generates Codable with column-major encoding
2. @CompactCodable - generates space-efficient encoding
3. Custom CodingKey enums for each encoding strategy

The macros should:
- Support both JSON and binary encoding
- Generate decoding validation
- Include round-trip tests
- Handle backwards compatibility
```

## Phase 4: Test Coverage Expansion

### Prompt 4.1: Property Test Generation

```
Create a @GeneratePropertyTests macro that creates property-based tests for mathematical laws:

1. Associativity: (a + b) + c == a + (b + c)
2. Commutativity: a + b == b + a (where applicable)
3. Identity elements: a + 0 == a
4. Inverse elements: a + (-a) == 0

The macro should:
- Use Swift Testing's parameterized tests
- Generate value generators for matrix types
- Include edge cases (zero, identity, maximum values)
- Generate performance benchmarks
```

### Prompt 4.2: Cross-Type Validation

```
Create test generation for validating consistency across types:

1. Float vs Double precision comparisons
2. Matrix vs native SIMD operation equivalence
3. Storage format compatibility
4. Serialization round-trip accuracy

Generate tests that:
- Use appropriate tolerances for floating-point comparison
- Cover the full range of representable values
- Validate special values (NaN, infinity)
- Check performance characteristics
```

## Phase 5: Advanced Features

### Prompt 5.1: Quaternion Macro System

```
Apply the macro system to quaternion types:

1. @QuaternionStorage - generates storage with vector/scalar parts
2. @QuaternionOperations - generates rotation operations
3. @QuaternionInterpolation - generates SLERP/LERP methods

The macros should:
- Maintain quaternion invariants (unit length for rotations)
- Generate conversion to/from matrices
- Include Euler angle conversions
- Generate comprehensive rotation tests
```

### Prompt 5.2: SwiftUI Integration

```
Create macros for SwiftUI integration:

1. @AnimatableMatrix - generates VectorArithmetic conformance
2. @PreviewableMatrix - generates preview helpers
3. @BindableMatrix - generates property wrappers

Focus on:
- Smooth animation support
- Preview data generation
- Two-way bindings for UI controls
- Performance optimization for frequent updates
```

## Phase 6: Documentation and Polish

### Prompt 6.1: Documentation Generation

```
Create a @GenerateDocumentation macro that:

1. Extracts operation metadata
2. Generates comprehensive DocC documentation
3. Creates usage examples
4. Generates a feature compatibility matrix

The documentation should include:
- Mathematical formulas (using LaTeX notation)
- Performance characteristics
- Usage examples
- Cross-references to related operations
```

### Prompt 6.2: Diagnostic Enhancement

```
Enhance all macros with superior diagnostics:

1. Clear error messages for invalid usage
2. Fix-it suggestions for common mistakes
3. Performance warnings for suboptimal patterns
4. Migration helpers from old code patterns

Include:
- Source location preservation
- Contextual error information
- Suggested alternatives
- Links to documentation
```

## Testing and Validation Prompts

### Integration Testing

```
Create an integration test suite that:

1. Validates all macro combinations work together
2. Ensures generated code compiles under all supported platforms
3. Verifies performance meets or exceeds manual implementation
4. Checks binary size impact

The tests should be automated and run in CI.
```

### Migration Validation

```
Create a validation suite that ensures:

1. The macro-generated API matches the original API exactly
2. Performance characteristics are maintained or improved
3. All existing tests pass with macro-generated code
4. Binary compatibility is maintained where required

Include automated migration testing that can compare old vs new implementations.
```

## Incremental Migration Strategy

### Parallel Development Prompt

```
Set up the project to support parallel development:

1. Use #if MACRO_MIGRATION flags to switch implementations
2. Create a compatibility layer for gradual migration
3. Set up A/B testing infrastructure for performance comparison
4. Create automated validation of behavioral equivalence

The system should allow switching between implementations at compile time for testing.
```

## Best Practices Reminders

When implementing each phase:

1. **Start Small**: Always begin with the simplest case
2. **Test First**: Write the test generation before the implementation
3. **Iterate**: Get basic functionality working before optimizing
4. **Document**: Include clear comments explaining the generation logic
5. **Validate**: Always compare generated code against manual implementation
6. **Measure**: Track compilation time and runtime performance impacts

## Troubleshooting Guide

Common issues and solutions:

1. **Macro Not Found**: Ensure the plugin is properly declared in Package.swift
2. **Syntax Generation Errors**: Use SwiftSyntaxBuilder for robust syntax creation
3. **Type Checking Failures**: Validate types at macro expansion time
4. **Performance Regression**: Profile and optimize the generated code
5. **Test Failures**: Ensure test generation matches implementation updates