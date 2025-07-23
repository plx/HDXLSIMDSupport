# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build and Test Commands

This is a Swift Package Manager project. Use these commands for development:

```bash
# Building
swift build              # Build in debug mode
swift build -c release   # Build in release mode
swift build -v          # Build with verbose output

# Testing
swift test              # Run all tests
swift test -v           # Run tests with verbose output
swift test --filter TestName  # Run specific test
swift test --parallel   # Run tests in parallel

# Package Management
swift package clean     # Clean build artifacts
swift package reset     # Reset complete cache/build directory
swift package update    # Update dependencies (note: this project has no dependencies)
```

## Architecture Overview

HDXLSIMDSupport provides generic Swift wrappers for Apple's non-generic SIMD matrix and quaternion types. Understanding the three-layer architecture is crucial:

### Three-Layer Type System
1. **Generic Wrapper** (e.g., `Matrix4x4<Scalar>`) - User-facing generic types
2. **Storage Type** (e.g., `FloatMatrix4x4Storage`) - Adds Hashable/Codable to native types
3. **Native SIMD** (e.g., `simd_float4x4`) - Apple's C-based SIMD types

### Key Design Patterns

**Passthrough Protocol**: Central to the architecture, eliminates forwarding boilerplate:
- Storage types and generic wrappers both conform to `Passthrough`
- Extensions on `Passthrough` implement forwarding logic once
- Used extensively throughout matrix and quaternion implementations

**Flat Protocol Hierarchy**: Deliberately avoids deep protocol hierarchies due to Swift compiler limitations:
- Base protocols: `MatrixProtocol`, `QuaternionProtocol`
- Size-specific: `Matrix2x2Protocol`, `Matrix3x3Protocol`, etc.
- Separate operator protocols to avoid ambiguity

**Type Compatibility**: `ExtendedSIMDScalar` links all storage types for a given scalar:
- Ensures `Matrix2x2<Float>` can multiply with `Matrix2x3<Float>`
- Manual type-linking simulates higher-kinded types

### Important Implementation Notes

- Heavy use of `@inlinable` for zero-cost abstractions
- Method pairs: `operation()` returns new value, `formOperation()` mutates in place
- Consistent naming: `multiplied(by:)`, `divided(by:)`, `adding(_:)`
- Liberal use of preconditions for runtime safety
- All types target Swift 6 with full Sendable compliance

### Working with the Codebase

When adding functionality:
1. Start with the appropriate protocol
2. Implement in a `Passthrough` extension if possible
3. Only add to concrete types if necessary

When modifying existing code:
- Maintain the three-layer architecture
- Follow existing naming conventions
- Ensure Sendable compliance is maintained
- Add comprehensive tests for new functionality

### Future Direction

The project is planning a migration to macro-based code generation to:
- Reduce protocol complexity and compilation times
- Eliminate copy-paste boilerplate
- Co-generate implementation and tests

Until then, maintain the current protocol-based architecture.