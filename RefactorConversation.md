 ▐▛███▜▌   Claude Code v2.1.141
▝▜█████▛▘  Opus 4.7 · Claude Max
  ▘▘ ▝▝    ~/conductor/workspaces/HDXLSIMDSupport/raleigh

❯ /clear                                                                        
  ⎿  (no content)

❯ /effort max                                                                   
  ⎿  Set effort level to max (this session only): Maximum capability with deepest
      reasoning

❯ /goal The largest remaining deficit is the lack of test coverage: the initial implementation only contains a small number of tests, and they're *mostly* about things that don't actually verify the meaningful behavior. Since most of the code is written as copy-and-paste-and-edited boilerplate, this means the implementation likely contains a lot of code that isn't actually correct—you can look at the most-recently-merged PR for a good example of this (wherein multiple methods were discovered to be wildly off base, due to having never been meaningfully exercised—they were only caught by code review). 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
The way I'd like to address this is to refactor the entire implementation away from being mostly "protocol-oriented" to, instead, being mostly implemented by Swift macros (and specifically Swift macros, and e.g. not via some jinja-based external system). At a practical level, this *probably* means dropping things like `Passthrough` protocol and all of its method-forwarding extensions (etc.), and instead using macros to generate the forwarding logic.                                                                                                                                                          
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
For example, roughly-speaking we do this:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
```swift                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
extension Passthrough where Self: Hashable, PassthroughValue: Hashable {                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
  func hash(into hasher: inout Hasher) {                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    passthroughValue.hash(into: &hasher)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
  }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
// and then have two conformances to `Passthrough` per matrix:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
// - there's a `Passthrough` conformance on our public-facing matrix type (exposing the underlying storage type)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
// - there's a `Passthrough` conformance on that "storage type", wrapping the underlying raw matrix type                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
```                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
After this migration we *would* keep the combination of the outward matrix type and inward storage type, but wouldn't use the passthrough concept anymore (and could make those types `@usableFromInline internal`, etc.); instead, we'd have macros that generate the forwarding boilerplate.                                                                                                                                                                                                                                                                                                                                 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
That's not the interesting part, however. The intereresting part, here, is the way I want the macros to work:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
- over in the macro plugin we have a lightweight IR (e.g. a `MatrixDescriptor` struct that takes three fields: `rowCount`, `columnCount`, and `representation` (which is just an enum like `.half`, `.float`, or `.double`))                                                                                                                                                                                                                                                                                                                                                                                                   
- over in the macro plugin we have a large number of "macrolets"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
- each "macrolet" corresponds to a single "slice" of an API (e.g. maybe it's just "componentwise matrix addition", or similar)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
- each "macrolet" has at least two APIs on it:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
    - a helper method to emit the SwiftSyntax for the *implementation* (e.g. to implement the forwarding boilerplate)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
    - a helper method to emit the SwiftSyntax for various validation tests (see below)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
Exact details are TBD, but the idea is that we'd have a family of very generic and reusable "validation skeletons", one for each arity we care about (probably 1 and 2, I think); the basic concept having a family of helper methods like these:                                                                                                                                                                                                                                                                                                                                                                              
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
```swift                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
func validateOutOfPlaceMatrixOperationEquivalence<T: MatrixProtocol, NativeSIMDRepresentable>(                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
  lhs nativeLHS: T.NativeSIMDRepresentation,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
  rhs nativeRHS: T.NativeSIMDRepresentation,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
  epsilon: T.Representation = 0.0001, // or whatever                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
  file: StaticString = #file,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
  line: UInt = #line,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
  _ operation: (T, T) throws -> T,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
  nativeSIMD nativeOperation: (T.NativeSIMDRepresentation, T.NativeSIMDRepresentation) throws -> T.NativeSIMDRepresentation,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
  additionalValidation: ((T) throws -> Void)? = nil                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
) rethrows {                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
  let wrappedLHS = T(nativeSIMDRepresentation: nativeLHS)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
  let wrappedRHS = T(nativeSIMDRepresentation: nativeRHS)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
  let nativeResult = try nativeOperation(nativeLHS, nativeRHS)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
  let wrappedResult = try operation(wrappedLHS, wrappedRHS)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
  let delta = T(nativeSIMDREepresentation: nativeResult).lInfinityDistance(to: wrappedResult)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
  XCTAssertLessThan(delta, epsilon, "$put a good explanation here", file: file, line: line)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
  try additionalValidation?(nativeResult)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
```                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
...and then using the macrolets to code-generate those equivalent operations (e.g. to code-generate the snippet that goes in the `operation` closure as well as the matching snippet that goes in the `nativeOperation` closure).                                                                                                                                                                                                                                                                                                                                                                                              
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
Within the macros themselves, the workflow for e.g. a hypothetical `@AddMatrix2x2Conformance` would be to instantiate the right sequence of macrolets and then invoke them to emit the syntax that goes into the body to fill out the implementation. The implementation of the matching `@AddMatrix2x2ConformanceTests` would be to instantiate that same list of macrolets and then use them to emit the syntax needed to fill out the unit test logic (as per the above) sketch.                                                                                                                                            
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
Conceptually (a) macrolets should be a common macrolet protocol, (b) individual macrolet conformances should be initialized with the descriptors and other parameters they need to know what to generate, and then (c) during expansion time we would be invoking them via that protocol (e.g. via a list like `[any SIMDMatrixMacrolet]` or similar). Thus for example "addition methods" would look like:                                                                                                                                                                                                                    
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
```swift                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
struct MatrixAdditionAPI: SIMDMacrolet {                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
  var matrixDescriptor: MatrixDescriptor                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
```                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
That's the goal, keep working until (a) the project has been compeletely refactored along these lines, (b) our test coverage is as close to 100% as can be achieved, and (c) our new unit tests are all passing.                                                                                                                                                                                                                                                                                                                                                                                                               
  ⎿  Goal condition is limited to 4000 characters (got 5269)

❯ The largest remaining deficit is the lack of test coverage: the initial       
  implementation only contains a small number of tests, and they're *mostly*    
  about things that don't actually verify the meaningful behavior. Since most   
  of the code is written as copy-and-paste-and-edited boilerplate, this means   
  the implementation likely contains a lot of code that isn't actually          
  correct—you can look at the most-recently-merged PR for a good example of     
  this (wherein multiple methods were discovered to be wildly off base, due to  
  having never been meaningfully exercised—they were only caught by code        
  review).                                                                      
                                                                                
  The way I'd like to address this is to refactor the entire implementation     
  away from being mostly "protocol-oriented" to, instead, being mostly          
  implemented by Swift macros (and specifically Swift macros, and e.g. not via  
  some jinja-based external system). At a practical level, this *probably*      
  means dropping things like `Passthrough` protocol and all of its              
  method-forwarding extensions (etc.), and instead using macros to generate the 
   forwarding logic.                                                            
                                                                                
  After this migration we *would* keep the combination of the outward matrix    
  type and inward storage type, but wouldn't use the passthrough concept        
  anymore (and could make those types `@usableFromInline internal`, etc.);      
  instead, we'd have macros that generate the forwarding boilerplate.           
                                                                                
  That's not the interesting part, however. The intereresting part, here, is    
  the way I want the macros to work:                                            
                                                                                
  - over in the macro plugin we have a lightweight IR (e.g. a                   
  `MatrixDescriptor` struct that takes three fields: `rowCount`, `columnCount`, 
   and `representation` (which is just an enum like `.half`, `.float`, or       
  `.double`))                                                                   
  - over in the macro plugin we have a large number of "macrolets"              
  - each "macrolet" corresponds to a single "slice" of an API (e.g. maybe it's  
  just "componentwise matrix addition", or similar)                             
  - each "macrolet" has at least two APIs on it:                                
      - a helper method to emit the SwiftSyntax for the *implementation* (e.g.  
  to implement the forwarding boilerplate)                                      
      - a helper method to emit the SwiftSyntax for various validation tests    
  (see below)                                                                   
                                                                                
  Exact details are TBD, but the idea is that we'd have a family of very        
  generic and reusable "validation skeletons", one for each arity we care about 
   (probably 1 and 2, I think); the basic concept having a family of helper     
  methods like these:                                                           
                                                                                
  ```swift                                                                      
  func validateOutOfPlaceMatrixOperationEquivalence<T: MatrixProtocol,          
  NativeSIMDRepresentable>(                                                     
    lhs nativeLHS: T.NativeSIMDRepresentation,                                  
    rhs nativeRHS: T.NativeSIMDRepresentation,                                  
    epsilon: T.Representation = 0.0001, // or whatever                          
    file: StaticString = #file,                                                 
    line: UInt = #line,                                                         
    _ operation: (T, T) throws -> T,                                            
    nativeSIMD nativeOperation: (T.NativeSIMDRepresentation,                    
  T.NativeSIMDRepresentation) throws -> T.NativeSIMDRepresentation,             
    additionalValidation: ((T) throws -> Void)? = nil                           
  ) rethrows {                                                                  
    let wrappedLHS = T(nativeSIMDRepresentation: nativeLHS)                     
    let wrappedRHS = T(nativeSIMDRepresentation: nativeRHS)                     
    let nativeResult = try nativeOperation(nativeLHS, nativeRHS)                
    let wrappedResult = try operation(wrappedLHS, wrappedRHS)                   
    let delta = T(nativeSIMDREepresentation:                                    
  nativeResult).lInfinityDistance(to: wrappedResult)                            
    XCTAssertLessThan(delta, epsilon, "$put a good explanation here", file:     
  file, line: line)                                                             
    try additionalValidation?(nativeResult)                                     
  }                                                                             
  ```                                                                           
                                                                                
  ...and then using the macrolets to code-generate those equivalent operations  
  (e.g. to code-generate the snippet that goes in the `operation` closure as    
  well as the matching snippet that goes in the `nativeOperation` closure).     
                                                                                
  Within the macros themselves, the workflow for e.g. a hypothetical            
  `@AddMatrix2x2Conformance` would be to instantiate the right sequence of      
  macrolets and then invoke them to emit the syntax that goes into the body to  
  fill out the implementation. The implementation of the matching               
  `@AddMatrix2x2ConformanceTests` would be to instantiate that same list of     
  macrolets and then use them to emit the syntax needed to fill out the unit    
  test logic (as per the above) sketch.                                         
                                                                                
  Conceptually (a) macrolets should be a common macrolet protocol, (b)          
  individual macrolet conformances should be initialized with the descriptors   
  and other parameters they need to know what to generate, and then (c) during  
  expansion time we would be invoking them via that protocol (e.g. via a list   
  like `[any SIMDMatrixMacrolet]` or similar). Thus for example "addition       
  methods" would look like:                                                     
                                                                                
  ```swift                                                                      
  struct MatrixAdditionAPI: SIMDMacrolet {                                      
                                                                                
    var matrixDescriptor: MatrixDescriptor                                      
  }                                                                             
  ```                                                                           
                                                                                
  That's the goal, keep working until (a) the project has been compeletely      
  refactored along these lines, (b) our test coverage is as close to 100% as    
  can be achieved, and (c) our new unit tests are all passing.                  

  Searched for 5 patterns, read 1 file, listed 1 directory (ctrl+o to expand)

⏺ Let me look at relevant memory and key project structure first.

  Read 1 file, listed 5 directories (ctrl+o to expand)

⏺ No memory files yet. Let me dig into the project's most-recently-merged PR and
   current code structure to understand what we're working with.

⏺ Bash(git log --oneline -20)
  ⎿  c9d2020 Add Float16 support to ExtendedSIMDScalar (#5)
     9860129 Add _modify accessors to passthrough/wrapper computed properti
     es (#4)
     … +17 lines (ctrl+o to expand)

⏺ Bash(git show --stat c9d2020 | head -60)
  ⎿  commit c9d202004fd526bfc1ec57610972c02aebbed44a
     Author: Paul B <plx@users.noreply.github.com>
     Date:   Thu May 14 13:24:02 2026 -0700
     … +41 lines (ctrl+o to expand)

⏺ Bash(git show --stat c9d2020 | tail -80)
  ⎿          [[2.5, 0], [0, 2.5]], not a uniformly-filled matrix.

         This propagated up through the Storage and Matrix<N>x<M> wrappers
     … +67 lines (ctrl+o to expand)

⏺ Now let me understand the existing Matrix protocol, storage, and passthrough
  patterns:

  Read 1 file (ctrl+o to expand)

⏺ Let me look at the key files to understand the patterns and scope better.

  Read 7 files (ctrl+o to expand)

⏺ Let me look at the existing validation test infrastructure:

  Read 1 file (ctrl+o to expand)

⏺ Now I have a comprehensive understanding. Let me create a structured task list
   and verify the baseline before diving in.
⏺ Now let me verify the baseline before diving in. Two things in parallel: the
  build and a quick check on what Swift toolchain is available.

⏺ Bash(swift --version 2>&1 | head -5)
  ⎿  swift-driver version: 1.148.6 Apple Swift version 6.3.1 (swiftlang-6.3
     .1.1.2 clang-2100.0.123.102)
     Target: arm64-apple-macosx26.0

⏺ Bash(swift build 2>&1 | tail -40)
  ⎿  [135/173] Compiling HDXLSIMDSupport FloatMatrix4x2Storage.swift
     [136/173] Compiling HDXLSIMDSupport FloatMatrix4x3Storage.swift
     [137/173] Compiling HDXLSIMDSupport FloatMatrix4x4Storage.swift
     … +33 lines (ctrl+o to expand)
  ⎿  (timeout 10m)

⏺ Baseline builds clean (Swift 6.3.1, target arm64-apple-macosx26.0). Let me
  also verify tests pass and check one or two quick things before committing to
  an implementation plan.

⏺ Bash(swift test 2>&1 | tail -30)
  ⎿  Test Case '-[HDXLSIMDSupportTests.MatrixShapeSanityTests testMatrix4x2
     Shape]' started.
     Test Case '-[HDXLSIMDSupportTests.MatrixShapeSanityTests testMatrix4x2
     … +33 lines (ctrl+o to expand)
  ⎿  (timeout 10m)

⏺ Baseline: 133 tests pass on Swift 6.3.1. Let me make two key architectural
  decisions explicit before locking them in.

⏺ User answered Claude's questions:
  ⎿  · Which test framework should the generated validation tests target? → 
     Swift Testing (Recommended)
     · Should the macros and macrolet types be exposed as public API of the 
     package? → Public macros, internal IR (Recommended)

⏺ Excellent. Locking in Swift Testing + public macros / internal IR. Let me get
  into it.

⏺ First, I need a complete picture of one matrix end-to-end before designing the
   macro plugin. Let me read the other key bits in parallel:
  NativeSIMDRepresentable, the existing 2x2 Passthrough overlay, the operators,
  the default support, ExtendedSIMDScalar, and the test-target validation
  skeleton so I understand all the moving pieces.

  Searched for 1 pattern, read 12 files (ctrl+o to expand)

⏺ I have the full picture. Time to start building. Let me update the
  Package.swift to add a macro plugin target.

  Read 1 file (ctrl+o to expand)

⏺ Bash(curl -sL
      "https://api.github.com/repos/swiftlang/swift-syntax/releases?per_page=10"
       2>&1 | python3 -c "import sys, json; data = json.load(sys.stdin);
      print('\n'…)
  ⎿  604.0.0-prerelease-2026-04-21: 604.0.0-prerelease-2026-04-21 (2026-04-
     21)
     603.0.1: 603.0.1 (2026-04-21)
     … +15 lines (ctrl+o to expand)

⏺ Using swift-syntax 603.0.1 (matches Swift 6.3). Let me update the
  Package.swift.

⏺ Write(Package.swift)
  ⎿  Added 15 lines, removed 1 line
      2  // The swift-tools-version declares the minimum version of Swift
          required to build this package.
      3  
      4  import PackageDescription
      5 +import CompilerPluginSupport                                    
      6  
      7  let package = Package(
      8    name: "HDXLSIMDSupport",
     ...
      21      )
      22    ],
      23    dependencies: [
      24 +    .package(                                                  
      25 +      url: "https://github.com/swiftlang/swift-syntax.git",    
      26 +      from: "603.0.1"                                          
      27 +    )                                                          
      28    ],
      29    targets: [
      30 +    .macro(                                                    
      31 +      name: "HDXLSIMDSupportMacroPlugin",                      
      32 +      dependencies: [                                          
      33 +        .product(name: "SwiftSyntax", package: "swift-syntax"),
      34 +        .product(name: "SwiftSyntaxBuilder", package: "swift-sy
         +ntax"),                                                        
      35 +        .product(name: "SwiftSyntaxMacros", package: "swift-syn
         +tax"),                                                         
      36 +        .product(name: "SwiftCompilerPlugin", package: "swift-s
         +yntax")                                                        
      37 +      ]                                                        
      38 +    ),                                                         
      39      .target(
      40        name: "HDXLSIMDSupport",
      27 -      dependencies: []                                         
      41 +      dependencies: ["HDXLSIMDSupportMacroPlugin"]             
      42      ),
      43      .testTarget(
      44        name: "HDXLSIMDSupportTests",

⏺ Now I'll lay out the macro plugin directory structure and create the
  foundational pieces: MatrixDescriptor IR, SIMDMatrixMacrolet protocol, the
  compiler plugin entry point, and a trivial proof-of-concept macrolet.

⏺ Bash(mkdir -p /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/
      HDXLSIMDSupportMacroPlugin/IR
      /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/S…)
  ⎿  Done
⏺ Now let me write the IR types:

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/IR/MatrixRepresentation.swift)
  ⎿  Wrote 54 lines to
     Sources/HDXLSIMDSupportMacroPlugin/IR/MatrixRepresentation.swift
       2 //  MatrixRepresentation.swift
       3 //
       4 
       6 import SwiftSyntax
       7 /// Which scalar precision a matrix uses. Determines the C-level
          type prefix
         ft `Scalar`halfNxM`, `simd_floatNxM`, `simd_doubleNxM`), the Swi
       9 /// type, and the Swift storage type name (`HalfMatrixNxMStorage
         `, etc).
      10 enum MatrixRepresentation: String, CaseIterable {
     … +51 lines (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/IR/MatrixDescriptor.swift)
  ⎿  Wrote 90 lines to
     Sources/HDXLSIMDSupportMacroPlugin/IR/MatrixDescriptor.swift
       2 //  MatrixDescriptor.swift
       3 //
       4 
       5 import SwiftSyntax
       6 
       7 /// The minimal IR that drives matrix macro expansion. Three fie
         lds name *every*
       8 /// distinguishing property of a concrete matrix shape:
       9 ///
      10 /// - `rowCount`: number of rows (2, 3, or 4)
     … +98 lines (ctrl+o to expand)

⏺ Wait — I need to double-check the matrix-naming convention. Let me look at
  Matrix2x3Protocol:

  Read 1 file (ctrl+o to expand)

⏺ My descriptor is correct. Now let me write the macrolet protocol and the
  layer-context abstraction. A macrolet needs to know which layer it's emitting
  code for (native vs storage vs wrapper) because the forwarding shape differs.

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/IR/MatrixLayer.swift)
  ⎿  Wrote 120 lines to
     Sources/HDXLSIMDSupportMacroPlugin/IR/MatrixLayer.swift
       2 //  MatrixLayer.swift
       3 //
       5 /// The three layers at which matrix conformances live, in order
          of decreasing
       6 /// concreteness:
       8 /// - `.native`: the C-bridged `simd_floatNxM` types. Implementa
         tions dispatch
         `self.inverse`,to native SIMD operators (`return self + other`, 
      10 ///   etc.). These conformances are added in `extension simd_flo
         atNxM`.
     … +132 lines (ctrl+o to expand)

⏺ Now the SIMDMatrixMacrolet protocol:

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/IR/SIMDMatrixMacrolet.swift)
  ⎿  Wrote 49 lines to
     Sources/HDXLSIMDSupportMacroPlugin/IR/SIMDMatrixMacrolet.swift
       2 //  SIMDMatrixMacrolet.swift
       3 //
       4 
       5 import SwiftSyntax
       6 
         ibes a "slice"f matrix-related code-generation. A macrolet descr
       8 /// of the matrix API — for example, componentwise addition, or 
         determinants —
       9 /// and knows how to:
      10 ///
     … +59 lines (ctrl+o to expand)

⏺ Now let me write the first macrolet — ShapeConstants — and the macro plugin
  registration to verify the pipeline works end-to-end before scaling up.

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/ShapeConstantsMacrolet.swif
       t)
  ⎿  Wrote 58 lines to Sources/HDXLSIMDSupportMacroPlugin/Macrolets/ShapeCo
     nstantsMacrolet.swift
       1 //
       2 //  ShapeConstantsMacrolet.swift
       3 //
       4 
       5 import SwiftSyntax
       6 
       7 /// Emits the constant shape properties of a matrix:
       8 ///
       9 ///   - `rowCount`, `columnCount`
      10 ///   - `rowLength`, `columnLength`
     … +54 lines (ctrl+o to expand)

⏺ Now let me write the proof-of-concept attached macro and the plugin entry
  point:

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macros/MacroArgumentParsing.swift)
  ⎿  Wrote 76 lines to
     Sources/HDXLSIMDSupportMacroPlugin/Macros/MacroArgumentParsing.swift
       2 //  MacroArgumentParsing.swift
       3 //
       4 
       5 import SwiftSyntax
       6 import SwiftSyntaxMacros
       8 /// Errors raised by the matrix macros when they can't parse the
         ir attribute
       9 /// arguments. Re-thrown as Swift diagnostics by the macro expan
         sion path.
      10 enum MacroArgumentError: Error, CustomStringConvertible {
     … +78 lines (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macros/MatrixMacroletComposition.swif
       t)
  ⎿  Wrote 23 lines to Sources/HDXLSIMDSupportMacroPlugin/Macros/MatrixMacr
     oletComposition.swift
       2 //  MatrixMacroletComposition.swift
       3 //
       5 import SwiftSyntax
       6 
       7 /// Compose the list of macrolets to invoke for a given descript
       8 /// The composition currently focuses on the proof-of-concept sl
         ice
         ore scaling up;tantsMacrolet`) so we can verify the pipeline bef
      10 /// additional macrolets are added here as the migration proceed
         s.
     … +15 lines (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macros/AddMatrixConformanceMacros.swi
       ft)
  ⎿  Wrote 87 lines to Sources/HDXLSIMDSupportMacroPlugin/Macros/AddMatrixC
     onformanceMacros.swift
       2 //  AddMatrixConformanceMacros.swift
       3 //
       4 
       5 import SwiftSyntax
       6 import SwiftSyntaxMacros
       7 
       8 /// Attached member macro that expands into the conformance code
          for a
       9 /// *native* matrix type (an `extension simd_floatNxM` etc.).
      10 ///
     … +99 lines (ctrl+o to expand)

⏺ Now the compiler plugin entry point:

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Plugin.swift)
  ⎿  Wrote 15 lines to Sources/HDXLSIMDSupportMacroPlugin/Plugin.swift
       1 //
       2 //  Plugin.swift
       3 //
       4 
       5 import SwiftCompilerPlugin
       6 import SwiftSyntaxMacros
       7 
       8 @main
       9 struct HDXLSIMDSupportMacroPlugin: CompilerPlugin {
      10   let providingMacros: [any Macro.Type] = [
     … +5 lines (ctrl+o to expand)

⏺ Now I need to declare the macros in the main library so they can be used:

⏺ Bash(mkdir -p /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/
      HDXLSIMDSupport/Macros)
  ⎿  Done

⏺ Write(Sources/HDXLSIMDSupport/Macros/Macros.swift)
  ⎿  Wrote 72 lines to Sources/HDXLSIMDSupport/Macros/Macros.swift
       2 //  Macros.swift
       3 //
         acro forwardscro declarations exposed by HDXLSIMDSupport. Each m
       5 //  to a concrete implementation in `HDXLSIMDSupportMacroPlugin`
         . The plugin
       7 //  is a build-time-only dependency; users do not see it.
       8 
         um so we canepresentation` is mirrored here as a `String`-raw en
      10 /// take it as a macro argument from outside the plugin. The plu
         gin parses the
     … +74 lines (ctrl+o to expand)

⏺ Now let me verify the package builds with the new macro plugin target:

⏺ Bash(swift build 2>&1 | tail -40)
  ⎿  Running in the background (↓ to manage)
  ⎿  (timeout 10m)
⏺ I'll wait for the build notification. Meanwhile, let me sketch the next
  macrolets to write — the architecture matters and there's many of them.

⏺ Bash(echo "waiting for build")
  ⎿  waiting for build

  Read 1 file (ctrl+o to expand)

⏺ Background command "Build with new macro plugin" completed (exit code 0)

⏺ Build succeeded — macro plugin compiles, swift-syntax pulled in. Now let me
  add a smoke test to verify macro expansion actually works:

⏺ Write(Sources/HDXLSIMDSupport/Macros/_MacroSmokeTest.swift)
  ⎿  Wrote 30 lines to Sources/HDXLSIMDSupport/Macros/_MacroSmokeTest.swift
      2 //  _MacroSmokeTest.swift
      3 //
      4 //  Throwaway probe — verifies that the macro plugin expands an a
        ttached member
      5 //  macro on a dummy struct. Once the real migration begins this 
        file goes
      6 //  away.
      7 //
      8 
      9 internal struct _MacroSmokeTest {
     … +23 lines (ctrl+o to expand)

⏺ Bash(swift build 2>&1 | tail -40)
  ⎿  Running in the background (↓ to manage)
  ⎿  (timeout 10m)

  Read 1 file, listed 1 directory (ctrl+o to expand)

⏺ Background command "Verify macro expansion smoke test" completed (exit code 0)

⏺ Smoke test passed — the macro expansion pipeline works. Phase 1 done. On to
  Phase 2: building out enough macrolets to fully replace one type end-to-end.

⏺ Now I'll batch-write the core macrolets. There are many — to make progress,
  I'll write a thoughtfully complete set in parallel. Let me start with
  foundational structure (typealiases, storage backing, compatible matrices,
  position helpers), then arithmetic, then square-matrix-specific.

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/StorageBackingMacrolet.swif
       t)
  ⎿  Wrote 35 lines to Sources/HDXLSIMDSupportMacroPlugin/Macrolets/Storage
     BackingMacrolet.swift
       2 //  StorageBackingMacrolet.swift
       3 //
       4 
       5 import SwiftSyntax
       6 
         ng layers the stored property and initializer that ties a wrappi
       8 /// (storage or wrapper) to its underlying value.
       9 ///
      10 /// - Native layer: emits nothing (a `simd_float2x2` doesn't wra
         p anything).
     … +31 lines (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/TypealiasMacrolet.swift)
  ⎿  Wrote 45 lines to
     Sources/HDXLSIMDSupportMacroPlugin/Macrolets/TypealiasMacrolet.swift
       1 //
       2 //  TypealiasMacrolet.swift
       3 //
       4 
       5 import SwiftSyntax
       6 
       7 /// Emits the standard MatrixProtocol typealiases:
       8 ///
       9 ///   - `Scalar`
      10 ///   - `RowVector` (= SIMD<columnCount><Scalar>)
     … +46 lines (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/CompatibleMatricesMacrolet.
       swift)
  ⎿  Wrote 113 lines to Sources/HDXLSIMDSupportMacroPlugin/Macrolets/Compat
     ibleMatricesMacrolet.swift
       2 //  CompatibleMatricesMacrolet.swift
       3 //
       4 
       5 import SwiftSyntax
       6 
         `MatrixNxMProtocol`atibleMatrixMxN` typealiases that a concrete 
       8 /// requires. Which compat aliases are required depends on the s
         hape:
       9 ///
      10 /// - 2x2 needs: 2x3, 3x2, 2x4, 4x2
     … +127 lines (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/PositionHelpersMacrolet.swi
       ft)
  ⎿  Wrote 96 lines to Sources/HDXLSIMDSupportMacroPlugin/Macrolets/Positio
     nHelpersMacrolet.swift
       2 //  PositionHelpersMacrolet.swift
       3 //
       4 
       6 import SwiftSyntax
       7 /// Emits the position / linearized-scalar-index helpers. These 
         are all derived
         n order: the descriptor's shape, with deterministic linearizatio
       9 ///
      10 ///   linearizedIndex(columnIndex c, rowIndex r) = c * columnLen
         gth + r
     … +102 lines (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/InitializationMacrolet.swif
       t)
  ⎿  Wrote 306 lines to Sources/HDXLSIMDSupportMacroPlugin/Macrolets/Initia
     lizationMacrolet.swift
       2 //  InitializationMacrolet.swift
       3 //
       4 
       5 import SwiftSyntax
       6 
       7 /// Emits the initializer suite required by MatrixProtocol:
       8 ///
       9 ///   - `init()` — zero matrix
      10 ///   - `init(repeating: Scalar)` — every entry set to the scala
         r
     … +340 lines (ctrl+o to expand)

⏺ Now the subscripting, bulk properties, and arithmetic macrolets. I'll write
  them in parallel groups since they don't depend on each other.

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/SubscriptingMacrolet.swift)
  ⎿  Wrote 163 lines to Sources/HDXLSIMDSupportMacroPlugin/Macrolets/Subscr
     iptingMacrolet.swift
       1 //
       2 //  SubscriptingMacrolet.swift
       3 //
       4 
       5 import SwiftSyntax
       6 
       7 /// Emits the subscript suite required by MatrixProtocol:
       8 ///
       9 ///   - `[columnIndex:]` -> ColumnVector
      10 ///   - `[rowIndex:]` -> RowVector
     … +176 lines (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/BulkPropertiesMacrolet.swif
       t)
  ⎿  Wrote 118 lines to Sources/HDXLSIMDSupportMacroPlugin/Macrolets/BulkPr
     opertiesMacrolet.swift
       2 //  BulkPropertiesMacrolet.swift
       3 //
       4 
       5 import SwiftSyntax
       6 
       7 /// Emits the bulk-access properties from MatrixProtocol:
       8 ///
       9 ///   - `var columns: Columns { get set }`
      10 ///   - `var rows: Rows { get }` (computed; rebuilds row vectors
          per access)
     … +121 lines (ctrl+o to expand)
  ⎿  Interrupted · What should Claude do instead?
❯ Just checking in on how it's going.                                           

⏺ Going well. Quick status:

  Phase 1 (done): Macro plugin scaffold in place — HDXLSIMDSupportMacroPlugin
  target compiles, swift-syntax 603.0.1 wired up, MatrixDescriptor IR +
  MatrixLayer/MatrixLayerContext + SIMDMatrixMacrolet protocol defined, 3
  attached-member macros published (@AddNativeMatrixConformance,
  @AddStorageMatrixConformance, @AddWrapperMatrixConformance). Smoke test
  verified expansion works on a probe type.

  Phase 2 (in progress): Writing the macrolet library. So far:
  - ShapeConstantsMacrolet ✓ (rowCount/columnCount/scalarCount/ranges)
  - StorageBackingMacrolet ✓ (stored prop + init)
  - TypealiasMacrolet ✓ (Scalar, RowVector, etc.)
  - CompatibleMatricesMacrolet ✓ (CompatibleMatrix2x3 etc.)
  - PositionHelpersMacrolet ✓ (linearizedScalarIndex, matrixPositions)
  - InitializationMacrolet ✓ (all 9 init variants)
  - SubscriptingMacrolet ✓ (all 5 subscripts)
  - BulkPropertiesMacrolet ✓ (columns, rows, linearizedScalars)

  Still to write before one matrix is end-to-end: Negation, MatrixAddition,
  MatrixSubtraction, ScalarAddition/Subtraction, FMA/FMS,
  ScalarMultiplication/Division, VectorMultiplication, LinearCombination,
  AlmostEqual, ComponentwiseMagnitudeSquared,
  Hashable/Equatable/Codable/Description, NativeSIMDRepresentable
  (wrapper-only), and the square-matrix-specific group (Transpose, Determinant,
  Inversion, square Multiplication/Division). Then wire
  MatrixMacroletComposition to dispatch on descriptor+layer, swap the existing
  FloatMatrix2x2Storage + Matrix2x2 to use macros, run tests.

  Each macrolet is ~50 lines. I'm working through them in fast succession; the
  tricky bit will be the validation-test emission once the impl side is settled.
   Want me to keep pushing or adjust direction?

✻ Baked for 12s

❯ Cool, please continue.                                                        

⏺ Continuing. Batching the next group of macrolets — they share a similar
  pattern (componentwise arithmetic with different operator-or-forwarding bodies
   per layer).

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/NegationMacrolet.swift)
  ⎿  Wrote 44 lines to
     Sources/HDXLSIMDSupportMacroPlugin/Macrolets/NegationMacrolet.swift
       1 //
       2 //  NegationMacrolet.swift
       3 //
       4 
       5 import SwiftSyntax
       6 
       7 /// Emits `negated() -> Self` and `formNegation()`.
       8 ///
       9 /// - Native: implements `-self` directly.
      10 /// - Storage/Wrapper: forwards to `storage.negated()`.
     … +35 lines (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/MatrixAdditionMacrolet.swif
       t)
  ⎿  Wrote 41 lines to Sources/HDXLSIMDSupportMacroPlugin/Macrolets/MatrixA
     dditionMacrolet.swift
      1 //
      2 //  MatrixAdditionMacrolet.swift
      3 //
      4 
      5 import SwiftSyntax
      6 
      7 /// Componentwise matrix-matrix addition: `adding(_:)` and `formA
        ddition(of:)`.
      8 struct MatrixAdditionMacrolet: SIMDMatrixMacrolet {
      9   let descriptor: MatrixDescriptor
     … +34 lines (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/MatrixSubtractionMacrolet.s
       wift)
  ⎿  Wrote 41 lines to Sources/HDXLSIMDSupportMacroPlugin/Macrolets/MatrixS
     ubtractionMacrolet.swift
      1 //
      2 //  MatrixSubtractionMacrolet.swift
      3 //
      4 
      5 import SwiftSyntax
      6 
      7 /// Componentwise matrix-matrix subtraction: `subtracting(_:)` an
        d `formSubtraction(of:)`.
      8 struct MatrixSubtractionMacrolet: SIMDMatrixMacrolet {
      9   let descriptor: MatrixDescriptor
     … +35 lines (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/ScalarAdditionMacrolet.swif
       t)
  ⎿  Wrote 62 lines to Sources/HDXLSIMDSupportMacroPlugin/Macrolets/ScalarA
     dditionMacrolet.swift
       2 //  ScalarAdditionMacrolet.swift
       3 //
       4 
       5 import SwiftSyntax
       6 
         ition(ofScalar:)`.to every entry: `adding(scalar:)` and `formAdd
       8 ///
       9 /// - Native: builds a fresh column-tuple where each column is s
         hifted by the
      10 ///   scalar (SIMD vectors support `vec + scalar`).
     … +58 lines (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/ScalarSubtractionMacrolet.s
       wift)
  ⎿  Wrote 51 lines to Sources/HDXLSIMDSupportMacroPlugin/Macrolets/ScalarS
     ubtractionMacrolet.swift
      1 //
      2 //  ScalarSubtractionMacrolet.swift
      3 //
      4 
      5 import SwiftSyntax
      6 
      7 /// Subtracts a scalar from every entry.
      8 struct ScalarSubtractionMacrolet: SIMDMatrixMacrolet {
      9   let descriptor: MatrixDescriptor
     … +45 lines (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/FMAMacrolet.swift)
  ⎿  Wrote 45 lines to
     Sources/HDXLSIMDSupportMacroPlugin/Macrolets/FMAMacrolet.swift
      1 //
      2 //  FMAMacrolet.swift
      3 //
      4 
      5 import SwiftSyntax
      6 
      7 /// Fused-multiply-add: `adding(_:multipliedBy:)` and the mutatin
        g variant.
      8 struct FMAMacrolet: SIMDMatrixMacrolet {
      9   let descriptor: MatrixDescriptor
     … +43 lines (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/FMSMacrolet.swift)
  ⎿  Wrote 45 lines to
     Sources/HDXLSIMDSupportMacroPlugin/Macrolets/FMSMacrolet.swift
      1 //
      2 //  FMSMacrolet.swift
      3 //
      4 
      5 import SwiftSyntax
      6 
      7 /// Fused-multiply-subtract: `subtracting(_:multipliedBy:)` and t
        he mutating variant.
      8 struct FMSMacrolet: SIMDMatrixMacrolet {
      9   let descriptor: MatrixDescriptor
     … +43 lines (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/ScalarMultiplicationMacrole
       t.swift)
  ⎿  Wrote 41 lines to Sources/HDXLSIMDSupportMacroPlugin/Macrolets/ScalarM
     ultiplicationMacrolet.swift
      1 //
      2 //  ScalarMultiplicationMacrolet.swift
      3 //
      4 
      5 import SwiftSyntax
      6 
      7 /// `multiplied(by:)` / `formMultiplication(by:)` — scalar multip
        lication.
      8 struct ScalarMultiplicationMacrolet: SIMDMatrixMacrolet {
      9   let descriptor: MatrixDescriptor
     … +35 lines (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/ScalarDivisionMacrolet.swif
       t)
  ⎿  Wrote 44 lines to Sources/HDXLSIMDSupportMacroPlugin/Macrolets/ScalarD
     ivisionMacrolet.swift
       2 //  ScalarDivisionMacrolet.swift
       3 //
       4 
       6 import SwiftSyntax
       7 /// `divided(by:)` / `formDivision(by:)` — scalar division (each
          entry divided
         onformances:calar). Implementation matches the existing native c
       9 /// multiply by `1/scalar`, letting the floating-point arithmeti
         c handle the
      10 /// non-zero precondition.
     … +40 lines (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/VectorMultiplicationMacrole
       t.swift)
  ⎿  Wrote 51 lines to Sources/HDXLSIMDSupportMacroPlugin/Macrolets/VectorM
     ultiplicationMacrolet.swift
       2 //  VectorMultiplicationMacrolet.swift
       3 //
       4 
       5 import SwiftSyntax
       6 
       8 /// Matrix-vector multiplications:
       9 ///   - `multiplied(onLeftBy columnVector:) -> RowVector`  (≡ `c
         olumnVector * self`)
      10 ///   - `multiplied(onRightBy rowVector:) -> ColumnVector` (≡ `s
         elf * rowVector`)
     … +49 lines (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/LinearCombinationMacrolet.s
       wift)
  ⎿  Wrote 51 lines to Sources/HDXLSIMDSupportMacroPlugin/Macrolets/LinearC
     ombinationMacrolet.swift
      1 //
      2 //  LinearCombinationMacrolet.swift
      3 //
      4 
      5 import SwiftSyntax
      6 
      7 /// `linearCombination(of:weight:with:weight:)` — weighted linear
         combination.
      8 struct LinearCombinationMacrolet: SIMDMatrixMacrolet {
      9   let descriptor: MatrixDescriptor
     … +44 lines (ctrl+o to expand)

⏺ Let me check how half-precision handles linearCombination:

  Searched for 1 pattern (ctrl+o to expand)

⏺ Bash(sed -n '83,100p'
      /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDXLSIMDSu
      pport/Matrices/NativeConformances/Half/simd_half2x2+Matrix2x2Protocol…)
  ⎿    // MARK: Linear Combinations
       // -----------------------------------------------------------------
     ------- //
     … +15 lines (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/AlmostEqualElementsMacrolet
       .swift)
  ⎿  Wrote 59 lines to Sources/HDXLSIMDSupportMacroPlugin/Macrolets/AlmostE
     qualElementsMacrolet.swift
       2 //  AlmostEqualElementsMacrolet.swift
       3 //
       4 
       5 import SwiftSyntax
       6 
         tive-toleranceEqualElements(to:absoluteTolerance:)` and the rela
       8 /// variant. Native bodies use `simd_almost_equal_elements` and
       9 /// `simd_almost_equal_elements_relative`; storage/wrapper forwa
         rd.
      10 struct AlmostEqualElementsMacrolet: SIMDMatrixMacrolet {
     … +54 lines (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/ComponentwiseMagnitudeSquar
       edMacrolet.swift)
  ⎿  Wrote 39 lines to Sources/HDXLSIMDSupportMacroPlugin/Macrolets/Compone
     ntwiseMagnitudeSquaredMacrolet.swift
       2 //  ComponentwiseMagnitudeSquaredMacrolet.swift
       3 //
       4 
       6 import SwiftSyntax
       7 /// `componentwiseMagnitudeSquared` — sum of squares of all entr
         ies.
       9 /// At the native layer we emit `simd_length_squared(columns.c) 
         + ...` because
      10 /// that's what the simd toolkit gives us. At storage/wrapper la
         yers we forward.
     … +32 lines (ctrl+o to expand)
⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/HashableMacrolet.swift)
  ⎿  Wrote 44 lines to
     Sources/HDXLSIMDSupportMacroPlugin/Macrolets/HashableMacrolet.swift
       2 //  HashableMacrolet.swift
       3 //
       4 
       6 import SwiftSyntax
       7 /// `hash(into:)` — hashes one column-vector at a time (column-v
         ector SIMD types
         form to themselves Hashable). Native simd matrix types don't con
       9 /// Hashable, so this is only emitted at storage / wrapper layer
         s.
      10 ///
     … +39 lines (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/CodableMacrolet.swift)
  ⎿  Wrote 91 lines to
     Sources/HDXLSIMDSupportMacroPlugin/Macrolets/CodableMacrolet.swift
       2 //  CodableMacrolet.swift
       3 //
       4 
       5 import SwiftSyntax
       6 
         (`c0`, `c1`,` — encodes/decodes one column-vector per CodingKey 
       8 /// ...). Only emitted for storage / wrapper layers; native simd
          matrices are
       9 /// not Codable.
      10 ///
     … +89 lines (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/DescriptionMacrolet.swift)
  ⎿  Wrote 50 lines to
     Sources/HDXLSIMDSupportMacroPlugin/Macrolets/DescriptionMacrolet.swift
       2 //  DescriptionMacrolet.swift
       3 //
       4 
       5 import SwiftSyntax
       6 
         ve simd typesingConvertible + CustomDebugStringConvertible. Nati
       8 /// already have these, so we only emit them on storage / wrappe
         r.
       9 struct DescriptionMacrolet: SIMDMatrixMacrolet {
      10   let descriptor: MatrixDescriptor
     … +47 lines (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/NativeSIMDRepresentableMacr
       olet.swift)
  ⎿  Wrote 82 lines to Sources/HDXLSIMDSupportMacroPlugin/Macrolets/NativeS
     IMDRepresentableMacrolet.swift
       2 //  NativeSIMDRepresentableMacrolet.swift
       3 //
       4 
       5 import SwiftSyntax
       6 
          layer. TheSIMDRepresentable` conformance — only for the wrapper
       8 /// wrapper reaches through TWO levels (`storage.storage`) to ex
         pose the raw
       9 /// `simd_*` value.
      10 ///
     … +85 lines (ctrl+o to expand)

⏺ Now the square-matrix-specific macrolets:

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/TransposeMacrolet.swift)
  ⎿  Wrote 80 lines to
     Sources/HDXLSIMDSupportMacroPlugin/Macrolets/TransposeMacrolet.swift
       2 //  TransposeMacrolet.swift
       3 //
       4 
       5 import SwiftSyntax
       6 
       7 /// Transpose support.
       8 ///
       9 /// - Square: `transposed() -> Self` and `formTranspose()`. Impl
         ementation uses
      10 ///   the native simd `.transpose` property.
     … +77 lines (ctrl+o to expand)

  Searched for 1 pattern (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/DeterminantMacrolet.swift)
  ⎿  Wrote 28 lines to
     Sources/HDXLSIMDSupportMacroPlugin/Macrolets/DeterminantMacrolet.swift
      1 //
      2 //  DeterminantMacrolet.swift
      3 //
      4 
      5 import SwiftSyntax
      6 
      7 /// `determinant: Scalar` — only emitted for square matrices.
      8 struct DeterminantMacrolet: SIMDMatrixMacrolet {
      9   let descriptor: MatrixDescriptor
     … +19 lines (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/InversionMacrolet.swift)
  ⎿  Wrote 42 lines to
     Sources/HDXLSIMDSupportMacroPlugin/Macrolets/InversionMacrolet.swift
      1 //
      2 //  InversionMacrolet.swift
      3 //
      4 
      5 import SwiftSyntax
      6 
      7 /// `inverted() -> Self` / `formInverse()` — only for square matr
        ices.
      8 struct InversionMacrolet: SIMDMatrixMacrolet {
      9   let descriptor: MatrixDescriptor
     … +34 lines (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/SquareMultiplicationMacrole
       t.swift)
  ⎿  Wrote 67 lines to Sources/HDXLSIMDSupportMacroPlugin/Macrolets/SquareM
     ultiplicationMacrolet.swift
       2 //  SquareMultiplicationMacrolet.swift
       3 //
       4 
       6 import SwiftSyntax
       7 /// Square self-multiplication operations from `MatrixNxNProtoco
         l`:
       9 ///   - `multiplied(onRightBy rhs: Self) -> Self`  (≡ `self * rh
         s`)
      10 ///   - `multiplied(onLeftBy lhs: Self) -> Self`   (≡ `lhs * sel
         f`)
     … +65 lines (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/SquareDivisionMacrolet.swif
       t)
  ⎿  Wrote 70 lines to Sources/HDXLSIMDSupportMacroPlugin/Macrolets/SquareD
     ivisionMacrolet.swift
       2 //  SquareDivisionMacrolet.swift
       3 //
       4 
       5 import SwiftSyntax
       6 
       8 /// Square self-division operations from `MatrixNxNProtocol`:
       9 ///   - `divided(onRightBy rhs:) -> Self`  (≡ `self * rhs.invers
         e`)
      10 ///   - `divided(onLeftBy lhs:) -> Self`   (≡ `lhs.inverse * sel
         f`)
     … +63 lines (ctrl+o to expand)

  Read 1 file (ctrl+o to expand)

⏺ Now the cross-shape multiplication — the most intricate macrolet:

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/CrossShapeMultiplicationMac
       rolet.swift)
  ⎿  Wrote 231 lines to Sources/HDXLSIMDSupportMacroPlugin/Macrolets/CrossS
     hapeMultiplicationMacrolet.swift
       1 //
       2 //  CrossShapeMultiplicationMacrolet.swift
       3 //
       4 
       5 import SwiftSyntax
       6 
       7 /// Cross-shape (M × N) matrix multiplication.
       8 ///
       9 /// For a matrix of shape (M cols, N rows):
      10 ///
     … +254 lines (ctrl+o to expand)

⏺ Let me look at NumericAggregate and the VectorArithmetic conformance:

  Read 3 files (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/NumericAggregateMacrolet.sw
       ift)
  ⎿  Wrote 46 lines to Sources/HDXLSIMDSupportMacroPlugin/Macrolets/Numeric
     AggregateMacrolet.swift
       2 //  NumericAggregateMacrolet.swift
       3 //
       4 
       5 import SwiftSyntax
       6 
         fy(_:)` methodgregate` conformance — the `allNumericEntriesSatis
       8 /// is the single protocol requirement, and the typealias for
       9 /// `NumericEntryRepresentation` is already emitted by `Typealia
         sMacrolet`.
      10 ///
     … +41 lines (ctrl+o to expand)

⏺ Now let me look at the wrapper-only VectorArithmetic conformance (used by
  SwiftUI):

  Searched for 1 pattern (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/VectorArithmeticMacrolet.sw
       ift)
  ⎿  Wrote 40 lines to Sources/HDXLSIMDSupportMacroPlugin/Macrolets/VectorA
     rithmeticMacrolet.swift
       2 //  VectorArithmeticMacrolet.swift
       3 //
       4 
       5 import SwiftSyntax
       6 
       8 /// `VectorArithmetic` conformance — wrapper-only.
       9 /// SwiftUI's `VectorArithmetic` requires `static var zero`, `ma
         gnitudeSquared:
      10 /// Double`, and `mutating func scale(by: Double)`. `AdditiveAri
         thmetic`
     … +34 lines (ctrl+o to expand)

⏺ Now wire all macrolets into the composition function:

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macros/MatrixMacroletComposition.swif
       t)  ⎿  Added 57 lines, removed 7 lines
       4  
       5  import SwiftSyntax
       6  
       7 -/// Compose the list of macrolets to invoke for a given descrip
         -tor and layer.                                                 
       8 -/// The composition currently focuses on the proof-of-concept s
         -lice                                                           
       9 -/// (`ShapeConstantsMacrolet`) so we can verify the pipeline be
         -fore scaling up;                                               
      10 -/// additional macrolets are added here as the migration procee
         -ds.                                                            
       7 +/// Composes the ordered list of macrolets that contribute to a
         + matrix                                                        
       8 +/// conformance, given a descriptor and a layer. Each entry is 
         +a slice of the                                                 
       9 +/// API; together they fill out the entire `MatrixProtocol` (pl
         +us the                                                         
      10 +/// concrete-shape protocols, plus `Hashable`/`Codable`/`Descri
         +ption`/...).                                                   
      11 +///                                                            
      12 +/// The ordering here drives the emit order in the generated so
         +urce. We keep                                                  
      13 +/// related slices adjacent (typealiases first, then init suite
         +, then arith,                                                  
      14 +/// then square-matrix-specific bits) so the expanded source re
         +mains readable.                                                
      15  enum MatrixMacroletComposition {
      16  
      17    static func macrolets(
      18      for descriptor: MatrixDescriptor,
      19      layer: MatrixLayer
      20    ) -> [any SIMDMatrixMacrolet] {
      17 -    var result: [any SIMDMatrixMacrolet] = [                   
      18 -      ShapeConstantsMacrolet(descriptor: descriptor)           
      19 -    ]                                                          
      21 +    var result: [any SIMDMatrixMacrolet] = []                  
      22 +                                                               
      23 +    // 1) Structural: typealiases + storage backing + compat al
         +iases + shape.                                                 
      24 +    result.append(TypealiasMacrolet(descriptor: descriptor))   
      25 +    result.append(StorageBackingMacrolet(descriptor: descriptor
         +))                                                             
      26 +    result.append(NativeSIMDRepresentableMacrolet(descriptor: d
         +escriptor))                                                    
      27 +    result.append(CompatibleMatricesMacrolet(descriptor: descri
         +ptor))                                                         
      28 +    result.append(ShapeConstantsMacrolet(descriptor: descriptor
         +))                                                             
      29 +    result.append(PositionHelpersMacrolet(descriptor: descripto
         +r))                                                            
      30 +                                                               
      31 +    // 2) Initialization + subscripting + bulk properties.     
      32 +    result.append(InitializationMacrolet(descriptor: descriptor
         +))                                                             
      33 +    result.append(SubscriptingMacrolet(descriptor: descriptor))
      34 +    result.append(BulkPropertiesMacrolet(descriptor: descriptor
         +))                                                             
      35 +                                                               
      36 +    // 3) Componentwise arithmetic (all shapes).               
      37 +    result.append(NegationMacrolet(descriptor: descriptor))    
      38 +    result.append(MatrixAdditionMacrolet(descriptor: descriptor
         +))                                                             
      39 +    result.append(MatrixSubtractionMacrolet(descriptor: descrip
         +tor))                                                          
      40 +    result.append(ScalarAdditionMacrolet(descriptor: descriptor
         +))                                                             
      41 +    result.append(ScalarSubtractionMacrolet(descriptor: descrip
         +tor))                                                          
      42 +    result.append(FMAMacrolet(descriptor: descriptor))         
      43 +    result.append(FMSMacrolet(descriptor: descriptor))         
      44 +    result.append(ScalarMultiplicationMacrolet(descriptor: desc
         +riptor))                                                       
      45 +    result.append(ScalarDivisionMacrolet(descriptor: descriptor
         +))                                                             
      46 +    result.append(VectorMultiplicationMacrolet(descriptor: desc
         +riptor))                                                       
      47 +    result.append(LinearCombinationMacrolet(descriptor: descrip
         +tor))                                                          
      48 +                                                               
      49 +    // 4) Comparisons / norms.                                 
      50 +    result.append(AlmostEqualElementsMacrolet(descriptor: descr
         +iptor))                                                        
      51 +    result.append(ComponentwiseMagnitudeSquaredMacrolet(descrip
         +tor: descriptor))                                              
      52 +                                                               
      53 +    // 5) Square-matrix-specific (only emit if descriptor is sq
         +uare).                                                         
      54 +    result.append(TransposeMacrolet(descriptor: descriptor))   
      55 +    result.append(DeterminantMacrolet(descriptor: descriptor)) 
      56 +    result.append(InversionMacrolet(descriptor: descriptor))   
      57 +    result.append(SquareMultiplicationMacrolet(descriptor: desc
         +riptor))                                                       
      58 +    result.append(SquareDivisionMacrolet(descriptor: descriptor
         +))                                                             
      59 +                                                               
      60 +    // 6) Cross-shape multiplication.                          
      61 +    result.append(CrossShapeMultiplicationMacrolet(descriptor: 
         +descriptor))                                                   
      62 +                                                               
      63 +    // 7) Cross-cutting conformances.                          
      64 +    result.append(NumericAggregateMacrolet(descriptor: descript
         +or))                                                           
      65 +    result.append(HashableMacrolet(descriptor: descriptor))    
      66 +    result.append(CodableMacrolet(descriptor: descriptor))     
      67 +    result.append(DescriptionMacrolet(descriptor: descriptor)) 
      68 +    result.append(VectorArithmeticMacrolet(descriptor: descript
         +or))                                                           
      69 +                                                               
      70      _ = layer
      71      return result
      72    }

⏺ Let me delete the smoke test, then build to verify all the macrolet code
  compiles:

⏺ Bash(rm /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDXLSI
      MDSupport/Macros/_MacroSmokeTest.swift && swift build 2>&1 | tail -50)
  ⎿  [171/219] Compiling HDXLSIMDSupport simd_half4x4+Matrix4x4Protocol.swi
     ft
     [172/219] Compiling HDXLSIMDSupport Matrix2x2OperatorSupportProtocol.s
     … +45 lines (ctrl+o to expand)
  ⎿  (timeout 10m)

⏺ The macro plugin compiles. Now I'll do the real migration — start by swapping
  simd_float2x2+Matrix2x2Protocol.swift to use @AddNativeMatrixConformance, and
  iterate:

⏺ Write(Sources/HDXLSIMDSupport/Matrices/NativeConformances/Float/simd_float2x2+
       Matrix2x2Protocol.swift)
  ⎿  Added 2 lines, removed 560 lines
        5  import Foundation
        6  import simd
        7  
        8 -extension simd_float2x2 : MatrixDefaultSupportProtocol, Matrix
          -2x2Protocol {                                                 
        9 -                                                              
       10 -  // ---------------------------------------------------------
          ---------------- //                                            
       11 -  // MARK: Scalar                                             
       12 -  // ---------------------------------------------------------
          ---------------- //                                            
       13 -                                                              
       14 -  public typealias Scalar = Float                             
       15 -                                                              
       16 -  // ---------------------------------------------------------
          ---------------- //                                            
       17 -  // MARK: Vectors                                            
       18 -  // ---------------------------------------------------------
          ---------------- //                                            
       19 -                                                              
       20 -  public typealias ColumnVector = SIMD2<Scalar>               
       21 -  public typealias RowVector = SIMD2<Scalar>                  
       22 -  public typealias DiagonalVector = SIMD2<Scalar>             
       23 -                                                              
       24 -  // ---------------------------------------------------------
          ---------------- //                                            
       25 -  // MARK: Components                                         
       26 -  // ---------------------------------------------------------
          ---------------- //                                            
       27 -                                                              
       28 -  public typealias Columns = T2<ColumnVector>                 
       29 -  public typealias Rows = T2<RowVector>                       
       30 -                                                              
       31 -  // ---------------------------------------------------------
          ---------------- //                                            
       32 -  // MARK: Shape Parameters                                   
       33 -  // ---------------------------------------------------------
          ---------------- //                                            
       34 -                                                              
       35 -  // defaults should supply:                                  
       36 -  /*                                                          
       37 -   static var rowCount: Int { get }                           
       38 -   static var rowLength: Int { get }                          
       39 -   static var columnCount: Int { get }                        
       40 -   static var columnLength: Int { get }                       
       41 -   static var scalarCount: Int { get }                        
       42 -   */                                                         
       43 -                                                              
       44 -  // ---------------------------------------------------------
          ---------------- //                                            
       45 -  // MARK: Initialization                                     
       46 -  // ---------------------------------------------------------
          ---------------- //                                            
       47 -                                                              
       48 -  // should already exist:                                    
       49 -  // init()                                                   
       50 -                                                              
       51 -  // The bridged `simd_floatNxM.init(_ scalar:)` constructor i
          -s a *diagonal*                                                
       52 -  // initializer (scalar on the diagonal, zeros elsewhere), so
          - we cannot use it                                             
       53 -  // to satisfy the protocol's "all entries" contract for `ini
          -t(repeating:)`.                                               
       54 -  @inlinable                                                  
       55 -  public init(repeating scalar: Scalar) {                     
       56 -    let column = ColumnVector(repeating: scalar)              
       57 -    self.init(columns: (column, column))                      
       58 -  }                                                           
       59 -                                                              
       60 -  // should already exist:                                    
       61 -  // init(diagonal: DiagonalVector)                           
       62 -                                                              
       63 -  // should already exist:                                    
       64 -  // init(columns: Columns)                                   
       65 -                                                              
       66 -  // we supply:                                               
       67 -  @inlinable                                                  
       68 -  public init(columnVectors: [ColumnVector]) {                
       69 -    precondition(columnVectors.count == Self.columnCount)     
       70 -    self.init(columnVectors)                                  
       71 -  }                                                           
       72 -                                                              
       73 -                                                              
       74 -  // defaults should supply:                                  
       75 -  // init(rows: Rows)                                         
       76 -                                                              
       77 -  // we supply:                                               
       78 -  @inlinable                                                  
       79 -  public init(rowVectors: [RowVector]) {                      
       80 -    precondition(rowVectors.count == Self.rowCount)           
       81 -    self.init(rows: rowVectors)                               
       82 -  }                                                           
       83 -                                                              
       84 -  // we supply:                                               
       85 -  // - note: we *could* call through to the existing `init<S>`
          - on the type,                                                 
       86 -  // but I want to keep my semantics stable                   
       87 -  @inlinable                                                  
       88 -  public init(linearizedScalars: [Scalar]) {                  
       89 -    precondition(linearizedScalars.count == Self.scalarCount) 
       90 -    self.init(                                                
       91 -      columnVectors: simd_float2x2.columnVectors(             
       92 -        forLinearizedScalars: linearizedScalars               
       93 -      )                                                       
       94 -    )                                                         
       95 -  }                                                           
       96 -                                                              
       97 -  // ---------------------------------------------------------
          ---------------- //                                            
       98 -  // MARK: Linear Combinations                                
       99 -  // ---------------------------------------------------------
          ---------------- //                                            
      100 -                                                              
      101 -  @inlinable                                                  
      102 -  public static func linearCombination(                       
      103 -    of first: simd_float2x2,                                  
      104 -    weight firstWeight: Scalar,                               
      105 -    with other: simd_float2x2,                                
      106 -    weight otherWeight: Scalar                                
      107 -  ) -> simd_float2x2 {                                        
      108 -    return simd_linear_combination(                           
      109 -      firstWeight,                                            
      110 -      first,                                                  
      111 -      otherWeight,                                            
      112 -      other                                                   
      113 -    )                                                         
      114 -  }                                                           
      115 -                                                              
      116 -  // ---------------------------------------------------------
          ---------------- //                                            
      117 -  // MARK: Subscripting - Columns                             
      118 -  // ---------------------------------------------------------
          ---------------- //                                            
      119 -                                                              
      120 -  // defaults should supply:                                  
      121 -  // subscript(columnIndex columnIndex: Int) -> ColumnVector {
          - get set }                                                    
      122 -                                                              
      123 -  // ---------------------------------------------------------
          ---------------- //                                            
      124 -  // MARK: Subscripting - Rows                                
      125 -  // ---------------------------------------------------------
          ---------------- //                                            
      126 -                                                              
      127 -  // we supply:                                               
      128 -  @inlinable                                                  
      129 -  public subscript(rowIndex rowIndex: Int) -> RowVector {     
      130 -    get {                                                     
      131 -      precondition(simd_float2x2.rowIndexRange.contains(rowInd
          -ex))                                                          
      132 -      return RowVector(                                       
      133 -        columns.0[rowIndex],                                  
      134 -        columns.1[rowIndex]                                   
      135 -      )                                                       
      136 -    }                                                         
      137 -    set {                                                     
      138 -      precondition(simd_float2x2.rowIndexRange.contains(rowInd
          -ex))                                                          
      139 -      columns.0[rowIndex] = newValue[0]                       
      140 -      columns.1[rowIndex] = newValue[1]                       
      141 -    }                                                         
      142 -  }                                                           
      143 -                                                              
      144 -  // ---------------------------------------------------------
          ---------------- //                                            
      145 -  // MARK: Subscripting - Scalars                             
      146 -  // ---------------------------------------------------------
          ---------------- //                                            
      147 -                                                              
      148 -  // defaults should supply:                                  
      149 -  // subscript(linearizedScalarIndex linearizedScalarIndex: In
          -t) -> Scalar { get set }                                      
      150 -                                                              
      151 -  // defaults should supply:                                  
      152 -  //  subscript(                                              
      153 -  //    columnIndex columnIndex: Int,                         
      154 -  //    rowIndex rowIndex: Int) -> Scalar { get set }         
      155 -                                                              
      156 -  // defaults should supply:                                  
      157 -  // subscript(position position: MatrixPosition) -> Scalar { 
          -get set }                                                     
      158 -                                                              
      159 -  // ---------------------------------------------------------
          ---------------- //                                            
      160 -  // MARK: Position & Linearization                           
      161 -  // ---------------------------------------------------------
          ---------------- //                                            
      162 -                                                              
      163 -  // defaults should supply:                                  
      164 -  // static func linearizedScalarIndex(                       
      165 -  //  forColumnIndex columnIndex: Int,                        
      166 -  //  rowIndex: Int) -> Int                                   
      167 -                                                              
      168 -  // defaults should supply:                                  
      169 -  // static func columnRowIndex(forLinearizedScalarIndex linea
          -rizedScalarIndex: Int) -> (Int,Int)                           
      170 -                                                              
      171 -  // defaults should supply:                                  
      172 -  // static func linearizedScalarIndex(forMatrixPosition matri
          -xPosition: MatrixPosition) -> Int                             
      173 -                                                              
      174 -  // defaults should supply:                                  
      175 -  // static func matrixPosition(forLinearizedScalarIndex linea
          -rizedScalarIndex: Int) -> MatrixPosition                      
      176 -                                                              
      177 -  // we supply:                                               
      178 -  public static let matrixPositions: [MatrixPosition] = simd_f
          -loat2x2.prepareMatrixPositionList()                           
      179 -                                                              
      180 -  // ---------------------------------------------------------
          ---------------- //                                            
      181 -  // MARK: Bulk Properties                                    
      182 -  // ---------------------------------------------------------
          ---------------- //                                            
      183 -                                                              
      184 -  // should already exist:                                    
      185 -  // var columns: Columns { get set }                         
      186 -                                                              
      187 -  // we supply:                                               
      188 -  @inlinable                                                  
      189 -  public var rows: Rows {                                     
      190 -    get {                                                     
      191 -      return (                                                
      192 -        RowVector(                                            
      193 -          columns.0[0],                                       
      194 -          columns.1[0]                                        
      195 -        ),                                                    
      196 -        RowVector(                                            
      197 -          columns.0[1],                                       
      198 -          columns.1[1]                                        
      199 -        )                                                     
      200 -      )                                                       
      201 -    }                                                         
      202 -  }                                                           
      203 -                                                              
      204 -  // defaults should supply:                                  
      205 -  // var columnVectors: [ColumnVector]                        
      206 -                                                              
      207 -  // defaults should supply:                                  
      208 -  // var rowVectors: [RowVector] { get }                      
      209 -                                                              
      210 -  // defaults should supply:                                  
      211 -  // var linearizedScalars: [Scalar] { get }                  
      212 -                                                              
      213 -  // ---------------------------------------------------------
          ---------------- //                                            
      214 -  // MARK: Almost Equal Elements                              
      215 -  // ---------------------------------------------------------
          ---------------- //                                            
      216 -                                                              
      217 -  // we supply:                                               
      218 -  @inlinable                                                  
      219 -  public func hasAlmostEqualElements(                         
      220 -    to other: simd_float2x2,                                  
      221 -    absoluteTolerance tolerance: Scalar                       
      222 -  ) -> Bool {                                                 
      223 -    return simd_almost_equal_elements(                        
      224 -      self,                                                   
      225 -      other,                                                  
      226 -      tolerance                                               
      227 -    )                                                         
      228 -  }                                                           
      229 -                                                              
      230 -  // we supply:                                               
      231 -  @inlinable                                                  
      232 -  public func hasAlmostEqualElements(                         
      233 -    to other: simd_float2x2,                                  
      234 -    relativeTolerance tolerance: Scalar                       
      235 -  ) -> Bool {                                                 
      236 -    return simd_almost_equal_elements_relative(               
      237 -      self,                                                   
      238 -      other,                                                  
      239 -      tolerance                                               
      240 -    )                                                         
      241 -  }                                                           
      242 -                                                              
      243 -  // ---------------------------------------------------------
          ---------------- //                                            
      244 -  // MARK: Norms                                              
      245 -  // ---------------------------------------------------------
          ---------------- //                                            
      246 -                                                              
      247 -  @inlinable                                                  
      248 -  public var componentwiseMagnitudeSquared: Scalar {          
      249 -    get {                                                     
      250 -      return (                                                
      251 -        simd_length_squared(columns.0)                        
      252 -        +                                                     
      253 -        simd_length_squared(columns.1)                        
      254 -      )                                                       
      255 -    }                                                         
      256 -  }                                                           
      257 -                                                              
      258 -  // ---------------------------------------------------------
          ---------------- //                                            
      259 -  // MARK: Negation                                           
      260 -  // ---------------------------------------------------------
          ---------------- //                                            
      261 -                                                              
      262 -  // we supply:                                               
      263 -  @inlinable                                                  
      264 -  public func negated() -> simd_float2x2 {                    
      265 -    return -self                                              
      266 -  }                                                           
      267 -                                                              
      268 -  // we supply:                                               
      269 -  @inlinable                                                  
      270 -  public mutating func formNegation() {                       
      271 -    self = -self                                              
      272 -  }                                                           
      273 -                                                              
      274 -  // ---------------------------------------------------------
          ---------------- //                                            
      275 -  // MARK: Addition - Matrix                                  
      276 -  // ---------------------------------------------------------
          ---------------- //                                            
      277 -                                                              
      278 -  // we supply:                                               
      279 -  @inlinable                                                  
      280 -  public func adding(_ other: simd_float2x2) -> simd_float2x2 
          -{                                                             
      281 -    return self + other                                       
      282 -  }                                                           
      283 -                                                              
      284 -  // we supply:                                               
      285 -  @inlinable                                                  
      286 -  public mutating func formAddition(of other: simd_float2x2) {
      287 -    self += other                                             
      288 -  }                                                           
      289 -                                                              
      290 -  // ---------------------------------------------------------
          ---------------- //                                            
      291 -  // MARK: Addition - Scalar                                  
      292 -  // ---------------------------------------------------------
          ---------------- //                                            
      293 -                                                              
      294 -  // defaults should supply:                                  
      295 -  // func adding(scalar: Scalar) -> Self                      
      296 -                                                              
      297 -  // defaults should supply:                                  
      298 -  // mutating func formAddition(ofScalar scalar: Scalar)      
      299 -                                                              
      300 -  // ---------------------------------------------------------
          ---------------- //                                            
      301 -  // MARK: FMA                                                
      302 -  // ---------------------------------------------------------
          ---------------- //                                            
      303 -                                                              
      304 -  // we supply:                                               
      305 -  @inlinable                                                  
      306 -  public func adding(                                         
      307 -    _ other: simd_float2x2,                                   
      308 -    multipliedBy scalar: Scalar                               
      309 -  ) -> simd_float2x2 {                                        
      310 -    return self + (other * scalar)                            
      311 -  }                                                           
      312 -                                                              
      313 -  // we supply:                                               
      314 -  @inlinable                                                  
      315 -  public mutating func formAddition(                          
      316 -    of other: simd_float2x2,                                  
      317 -    multipliedBy scalar: Scalar                               
      318 -  ) {                                                         
      319 -    self += other * scalar                                    
      320 -  }                                                           
      321 -                                                              
      322 -  // ---------------------------------------------------------
          ---------------- //                                            
      323 -  // MARK: Subtraction - Matrix                               
      324 -  // ---------------------------------------------------------
          ---------------- //                                            
      325 -                                                              
      326 -  // we supply:                                               
      327 -  @inlinable                                                  
      328 -  public func subtracting(_ other: simd_float2x2) -> simd_floa
          -t2x2 {                                                        
      329 -    return self - other                                       
      330 -  }                                                           
      331 -                                                              
      332 -  // we supply:                                               
      333 -  @inlinable                                                  
      334 -  public mutating func formSubtraction(of other: simd_float2x2
          -) {                                                           
      335 -    self -= other                                             
      336 -  }                                                           
      337 -                                                              
      338 -  // ---------------------------------------------------------
          ---------------- //                                            
      339 -  // MARK: Subtraction - Scalar                               
      340 -  // ---------------------------------------------------------
          ---------------- //                                            
      341 -                                                              
      342 -  // defaults should supply:                                  
      343 -  // func subtracting(scalar: Scalar) -> Self                 
      344 -                                                              
      345 -  // defaults should supply:                                  
      346 -  // mutating func formSubtraction(ofScalar scalar: Scalar)   
      347 -                                                              
      348 -  // ---------------------------------------------------------
          ---------------- //                                            
      349 -  // MARK: FMS                                                
      350 -  // ---------------------------------------------------------
          ---------------- //                                            
      351 -                                                              
      352 -  // we supply:                                               
      353 -  @inlinable                                                  
      354 -  public func subtracting(                                    
      355 -    _ other: simd_float2x2,                                   
      356 -    multipliedBy scalar: Scalar                               
      357 -  ) -> simd_float2x2 {                                        
      358 -    return self - (other * scalar)                            
      359 -  }                                                           
      360 -                                                              
      361 -  @inlinable                                                  
      362 -  public mutating func formSubtraction(                       
      363 -    of other: simd_float2x2,                                  
      364 -    multipliedBy scalar: Scalar                               
      365 -  ) {                                                         
      366 -    self -= (other * scalar)                                  
      367 -  }                                                           
      368 -                                                              
      369 -  // ---------------------------------------------------------
          ---------------- //                                            
      370 -  // MARK: Scalar Multiplication                              
      371 -  // ---------------------------------------------------------
          ---------------- //                                            
      372 -                                                              
      373 -  // we supply:                                               
      374 -  @inlinable                                                  
      375 -  public func multiplied(by scalar: Scalar) -> simd_float2x2 {
      376 -    return self * scalar                                      
      377 -  }                                                           
      378 -                                                              
      379 -  // we supply:                                               
      380 -  @inlinable                                                  
      381 -  public mutating func formMultiplication(by scalar: Scalar) {
      382 -    self *= scalar                                            
      383 -  }                                                           
      384 -                                                              
      385 -  // ---------------------------------------------------------
          ---------------- //                                            
      386 -  // MARK: Scalar Division                                    
      387 -  // ---------------------------------------------------------
          ---------------- //                                            
      388 -                                                              
      389 -  // we supply:                                               
      390 -  @inlinable                                                  
      391 -  public func divided(by scalar: Scalar) -> simd_float2x2 {   
      392 -    // let built-in handle the != 0.0 precondition!           
      393 -    return self * (1.0/scalar)                                
      394 -  }                                                           
      395 -                                                              
      396 -  // we supply:                                               
      397 -  @inlinable                                                  
      398 -  public mutating func formDivision(by scalar: Scalar) {      
      399 -    // let built-in handle the != 0.0 precondition!           
      400 -    self *= (1.0/scalar)                                      
      401 -  }                                                           
      402 -                                                              
      403 -  // ---------------------------------------------------------
          ---------------- //                                            
      404 -  // MARK: Vector Multiplication                              
      405 -  // ---------------------------------------------------------
          ---------------- //                                            
      406 -                                                              
      407 -  // we supply:                                               
      408 -  @inlinable                                                  
      409 -  public func multiplied(onLeftBy columnVector: ColumnVector) 
          --> RowVector {                                                
      410 -    return columnVector * self                                
      411 -  }                                                           
      412 -                                                              
      413 -  // we supply:                                               
      414 -  @inlinable                                                  
      415 -  public func multiplied(onRightBy rowVector: RowVector) -> Co
          -lumnVector {                                                  
      416 -    return self * rowVector                                   
      417 -  }                                                           
      418 -                                                              
      419 -  // ---------------------------------------------------------
          ---------------- //                                            
      420 -  // MARK: Compatible Matrix Types                            
      421 -  // ---------------------------------------------------------
          ---------------- //                                            
      422 -                                                              
      423 -  public typealias CompatibleQuaternion = simd_quatd          
      424 -  public typealias CompatibleMatrix2x3 = simd_float2x3        
      425 -  public typealias CompatibleMatrix3x2 = simd_float3x2        
      426 -  public typealias CompatibleMatrix2x4 = simd_float2x4        
      427 -  public typealias CompatibleMatrix4x2 = simd_float4x2        
      428 -                                                              
      429 -  // ---------------------------------------------------------
          ---------------- //                                            
      430 -  // MARK: Initialization                                     
      431 -  // ---------------------------------------------------------
          ---------------- //                                            
      432 -                                                              
      433 -  // should already exist:                                    
      434 -  // init(                                                    
      435 -  // _ c0: ColumnVector,                                      
      436 -  // _ c1: ColumnVector,                                      
      437 -  // _ c2: ColumnVector,                                      
      438 -  // _ c3: ColumnVector)                                      
      439 -                                                              
      440 -  // ---------------------------------------------------------
          ---------------- //                                            
      441 -  // MARK: Square-Matrix Math - Determinants                  
      442 -  // ---------------------------------------------------------
          ---------------- //                                            
      443 -                                                              
      444 -  // should already exist                                     
      445 -  // var determinant: Scalar { get }                          
      446 -                                                              
      447 -  // ---------------------------------------------------------
          ---------------- //                                            
      448 -  // MARK: Square-Matrix Math - Inversion                     
      449 -  // ---------------------------------------------------------
          ---------------- //                                            
      450 -                                                              
      451 -  // we supply:                                               
      452 -  @inlinable                                                  
      453 -  public func inverted() -> simd_float2x2 {                   
      454 -    return self.inverse                                       
      455 -  }                                                           
      456 -                                                              
      457 -  // we supply:                                               
      458 -  @inlinable                                                  
      459 -  public mutating func formInverse() {                        
      460 -    self = self.inverse                                       
      461 -  }                                                           
      462 -                                                              
      463 -  // ---------------------------------------------------------
          ---------------- //                                            
      464 -  // MARK: Square-Matrix Math - Multiplication                
      465 -  // ---------------------------------------------------------
          ---------------- //                                            
      466 -                                                              
      467 -  // we supply:                                               
      468 -  @inlinable                                                  
      469 -  public func multiplied(onRightBy rhs: simd_float2x2) -> simd
          -_float2x2 {                                                   
      470 -    return self * rhs                                         
      471 -  }                                                           
      472 -                                                              
      473 -  // we supply:                                               
      474 -  @inlinable                                                  
      475 -  public func multiplied(onLeftBy lhs: simd_float2x2) -> simd_
          -float2x2 {                                                    
      476 -    return lhs * self                                         
      477 -  }                                                           
      478 -                                                              
      479 -  // we supply:                                               
      480 -  @inlinable                                                  
      481 -  public mutating func formMultiplication(onRightBy rhs: simd_
          -float2x2) {                                                   
      482 -    self = self * rhs                                         
      483 -  }                                                           
      484 -                                                              
      485 -  // we supply:                                               
      486 -  @inlinable                                                  
      487 -  public mutating func formMultiplication(onLeftBy lhs: simd_f
          -loat2x2) {                                                    
      488 -    self = lhs * self                                         
      489 -  }                                                           
      490 -                                                              
      491 -  // ---------------------------------------------------------
          ---------------- //                                            
      492 -  // MARK: Square-Matrix Math - Multiplication                
      493 -  // ---------------------------------------------------------
          ---------------- //                                            
      494 -                                                              
      495 -  // we supply:                                               
      496 -  @inlinable                                                  
      497 -  public func divided(onRightBy rhs: simd_float2x2) -> simd_fl
          -oat2x2 {                                                      
      498 -    return self * rhs.inverse                                 
      499 -  }                                                           
      500 -                                                              
      501 -  // we supply:                                               
      502 -  @inlinable                                                  
      503 -  public func divided(onLeftBy lhs: simd_float2x2) -> simd_flo
          -at2x2 {                                                       
      504 -    return lhs.inverse * self                                 
      505 -  }                                                           
      506 -                                                              
      507 -  // we supply:                                               
      508 -  @inlinable                                                  
      509 -  public mutating func formDivision(onRightBy rhs: simd_float2
          -x2) {                                                         
      510 -    self = self * rhs.inverse                                 
      511 -  }                                                           
      512 -                                                              
      513 -  // we supply:                                               
      514 -  @inlinable                                                  
      515 -  public mutating func formDivision(onLeftBy lhs: simd_float2x
          -2) {                                                          
      516 -    self = lhs.inverse * self                                 
      517 -  }                                                           
      518 -                                                              
      519 -  // ---------------------------------------------------------
          ---------------- //                                            
      520 -  // MARK: Transposition                                      
      521 -  // ---------------------------------------------------------
          ---------------- //                                            
      522 -                                                              
      523 -  // we supply:                                               
      524 -  @inlinable                                                  
      525 -  public func transposed() -> simd_float2x2 {                 
      526 -    return self.transpose                                     
      527 -  }                                                           
      528 -                                                              
      529 -  // we supply:                                               
      530 -  @inlinable                                                  
      531 -  public mutating func formTranspose() {                      
      532 -    self = self.transpose                                     
      533 -  }                                                           
      534 -                                                              
      535 -  // ---------------------------------------------------------
          ---------------- //                                            
      536 -  // MARK: Right Multiplication                               
      537 -  // ---------------------------------------------------------
          ---------------- //                                            
      538 -                                                              
      539 -  // we supply:                                               
      540 -  @inlinable                                                  
      541 -  public func multiplied(onRightBy rhs: CompatibleMatrix3x2) -
          -> CompatibleMatrix3x2 {                                       
      542 -    return self * rhs                                         
      543 -  }                                                           
      544 -                                                              
      545 -  // we supply:                                               
      546 -  @inlinable                                                  
      547 -  public func multiplied(onRightBy rhs: CompatibleMatrix4x2) -
          -> CompatibleMatrix4x2 {                                       
      548 -    return self * rhs                                         
      549 -  }                                                           
      550 -                                                              
      551 -  // ---------------------------------------------------------
          ---------------- //                                            
      552 -  // MARK: Left Multiplication                                
      553 -  // ---------------------------------------------------------
          ---------------- //                                            
      554 -                                                              
      555 -  // we supply:                                               
      556 -  @inlinable                                                  
      557 -  public func multiplied(onLeftBy lhs: CompatibleMatrix2x3) ->
          - CompatibleMatrix2x3 {                                        
      558 -    return lhs * self                                         
      559 -  }                                                           
      560 -                                                              
      561 -  // we supply:                                               
      562 -  @inlinable                                                  
      563 -  public func multiplied(onLeftBy lhs: CompatibleMatrix2x4) ->
          - CompatibleMatrix2x4 {                                        
      564 -    return lhs * self                                         
      565 -  }                                                           
      566 -                                                              
      567 -}                                                             
        8 +@AddNativeMatrixConformance(rowCount: 2, columnCount: 2, repre
          +sentation: .float)                                            
        9 +extension simd_float2x2: Matrix2x2Protocol { }                

⏺ Bash(swift build 2>&1 | tail -80)
  ⎿  /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDXLSI
     MDSupport/NumericAggregate/Conformances/Matrices/Double/simd_double3x4
     +NumericAggregate.swift
     … +166 lines (ctrl+o to expand)
  ⎿  (timeout 10m)

⏺ Swift compiler crashed during macro expansion. Let me get cleaner error
  output:

⏺ Bash(swift build 2>&1 | grep -E "error:|warning:" | head -30)
  ⎿  error: emit-module command failed with exit code 1 (use -v to see invo
     cation)
     error: compile command failed due to signal 11 (use -v to see invocati
     … +14 lines (ctrl+o to expand)
  ⎿  (timeout 10m)

⏺ Let me check MatrixPosition signature:

  Searched for 2 patterns (ctrl+o to expand)

⏺ Several issues to fix. Let me address them:

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/PositionHelpersMacrolet.sw
        ift)
  ⎿  Added 2 lines, removed 2 lines
      51        @inlinable
      52        public static func matrixPosition(forLinearizedScalarInde
          x linearizedScalarIndex: Int) -> MatrixPosition {
      53          let (column, row) = columnRowIndex(forLinearizedScalarI
          ndex: linearizedScalarIndex)
      54 -        return MatrixPosition(columnIndex: column, rowIndex: ro
         -w)                                                             
      54 +        return MatrixPosition(rowIndex: row, columnIndex: colum
         +n)                                                             
      55        }
      56        """,
      57        """
     ...
      60          result.reserveCapacity(\(raw: columnCount * rowCount))
      61          for columnIndex in 0..<\(raw: columnCount) {
      62            for rowIndex in 0..<\(raw: rowCount) {
      63 -            result.append(MatrixPosition(columnIndex: columnInd
         -ex, rowIndex: rowIndex))                                       
      63 +            result.append(MatrixPosition(rowIndex: rowIndex, co
         +lumnIndex: columnIndex))                                       
      64            }
      65          }
      66          return result

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/TypealiasMacrolet.swift)
  ⎿  Added 4 lines, removed 2 lines
      28      let rowVectorSize = descriptor.columnCount
      29      let diagonalSize = Swift.min(descriptor.rowCount, descripto
          r.columnCount)
      30  
      31 +    // Note: `NumericEntryRepresentation` is emitted by `Numeri
         +cAggregateMacrolet`,                                           
      32 +    // not here, so that the typealias and the conformance meth
         +od that requires                                               
      33 +    // it stay together.                                       
      34      return [
      35        "public typealias Scalar = \(raw: scalar)",
      36        "public typealias RowVector = SIMD\(raw: rowVectorSize)<\
          (raw: scalar)>",
      37        "public typealias ColumnVector = SIMD\(raw: columnVectorS
          ize)<\(raw: scalar)>",
      38        "public typealias DiagonalVector = SIMD\(raw: diagonalSiz
          e)<\(raw: scalar)>",
      39        "public typealias Rows = \(raw: rowTupleType)",
      37 -      "public typealias Columns = \(raw: columnsTupleType)",   
      38 -      "public typealias NumericEntryRepresentation = \(raw: sca
         -lar)"                                                          
      40 +      "public typealias Columns = \(raw: columnsTupleType)"    
      41      ]
      42    }
      43  

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/NumericAggregateMacrolet.s
        wift)
  ⎿  Added 3 lines
      15    let descriptor: MatrixDescriptor
      16  
      17    func implementationDeclarations(in context: MatrixLayerContex
          t) -> [DeclSyntax] {
      18 +    let typealiasDecl: DeclSyntax = "public typealias NumericEn
         +tryRepresentation = \(raw: context.scalarTypeName)"            
      19      switch context.layer {
      20      case .native:
      21        let checks = (0..<descriptor.columnCount)
      22          .map { "columns.\($0).allNumericEntriesSatisfy(predicat
          e)" }
      23          .joined(separator: " && ")
      24        return [
      25 +        typealiasDecl,                                         
      26          """
      27          @inlinable
      28          public func allNumericEntriesSatisfy(
     ...
      34        ]
      35      case .storage, .wrapper:
      36        return [
      37 +        typealiasDecl,                                         
      38          """
      39          @inlinable
      40          public func allNumericEntriesSatisfy(

⏺ Now delete the old simd_float2x2+NumericAggregate.swift (the macro now handles
   it) and add NumericAggregate to the migrated conformance:

⏺ Bash(rm /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDXLSI
      MDSupport/NumericAggregate/Conformances/Matrices/Float/simd_float2x2+Numer
      icAggregate.s…)
  ⎿  Done

⏺ Write(Sources/HDXLSIMDSupport/Matrices/NativeConformances/Float/simd_float2x2+
       Matrix2x2Protocol.swift)
  ⎿  Added 1 line, removed 1 line
      6  import simd
      7  
      8  @AddNativeMatrixConformance(rowCount: 2, columnCount: 2, represe
         ntation: .float)
      9 -extension simd_float2x2: Matrix2x2Protocol { }                  
      9 +extension simd_float2x2: Matrix2x2Protocol, NumericAggregate { }

⏺ Bash(swift build 2>&1 | grep -E "error:" | head -30)
  ⎿  (No output)
  ⎿  (timeout 10m)

⏺ Bash(swift build 2>&1 | tail -20)
  ⎿  Building for debugging...
     [0/2] Write swift-version--58304C5D6DBC2206.txt
     Build complete! (0.09s)

⏺ Bash(swift build 2>&1 | tail -30)
  ⎿  Building for debugging...
     [0/2] Write swift-version--58304C5D6DBC2206.txt
     Build complete! (0.09s)

⏺ Bash(touch /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDX
      LSIMDSupport/Matrices/NativeConformances/Float/simd_float2x2+Matrix2x2Prot
      ocol.swift &&…)
  ⎿  Building for debugging...
     [0/3] Write sources
     [1/3] Write swift-version--58304C5D6DBC2206.txt
     … +3 lines (ctrl+o to expand)
  ⎿  (timeout 10m)
⏺ Build is green. Let me run the tests to verify no regressions:

⏺ Bash(swift test 2>&1 | tail -30)
  ⎿  Test Case '-[HDXLSIMDSupportTests.MatrixShapeSanityTests testMatrix4x2
     Shape]' started.
     Test Case '-[HDXLSIMDSupportTests.MatrixShapeSanityTests testMatrix4x2
     … +33 lines (ctrl+o to expand)

⏺ Tests green. Now migrate FloatMatrix2x2Storage. The macros generate
  everything; the storage file becomes near-empty:

⏺ Write(Sources/HDXLSIMDSupport/Matrices/Storages/Float/FloatMatrix2x2Storage.sw
       ift)
  ⎿  Added 4 lines, removed 140 lines
        6  import simd
        7  
        8  @frozen
        9 -public struct FloatMatrix2x2Storage :                         
        9 +@AddStorageMatrixConformance(rowCount: 2, columnCount: 2, repr
          +esentation: .float)                                           
       10 +public struct FloatMatrix2x2Storage:                          
       11    Matrix2x2Protocol,
       12    MatrixOperatorSupportProtocol,
       13    Matrix2x2OperatorSupportProtocol,
       13 -  Passthrough,                                                
       14 +  NativeSIMDRepresentable,                                    
       15    NumericAggregate,
       16    Hashable,
       17    CustomStringConvertible,
       18    CustomDebugStringConvertible,
       19    Codable
       19 -{                                                             
       20 -                                                              
       21 -  public typealias CompatibleMatrix2x3 = FloatMatrix2x3Storage
       22 -  public typealias CompatibleMatrix3x2 = FloatMatrix3x2Storage
       23 -  public typealias CompatibleMatrix2x4 = FloatMatrix2x4Storage
       24 -  public typealias CompatibleMatrix4x2 = FloatMatrix4x2Storage
       25 -                                                              
       26 -  public typealias PassthroughValue = simd_float2x2           
       27 -  public typealias Scalar = PassthroughValue.Scalar           
       28 -  public typealias RowVector = PassthroughValue.RowVector     
       29 -  public typealias ColumnVector = PassthroughValue.ColumnVecto
          -r                                                             
       30 -  public typealias DiagonalVector = PassthroughValue.DiagonalV
          -ector                                                         
       31 -  public typealias Rows = PassthroughValue.Rows               
       32 -  public typealias Columns = PassthroughValue.Columns         
       33 -  public typealias NumericEntryRepresentation = PassthroughVal
          -ue.NumericEntryRepresentation                                 
       34 -                                                              
       35 -  // ---------------------------------------------------------
          ---------------- //                                            
       36 -  // MARK: Typename                                           
       37 -  // ---------------------------------------------------------
          ---------------- //                                            
       38 -                                                              
       39 -  @usableFromInline                                           
       40 -  internal static var typename: String {                      
       41 -    get {                                                     
       42 -      return "FloatMatrix2x2Storage"                          
       43 -    }                                                         
       44 -  }                                                           
       45 -                                                              
       46 -  // ---------------------------------------------------------
          ---------------- //                                            
       47 -  // MARK: Passthrough                                        
       48 -  // ---------------------------------------------------------
          ---------------- //                                            
       49 -                                                              
       50 -  public var passthroughValue: PassthroughValue               
       51 -                                                              
       52 -  @inlinable                                                  
       53 -  public init(passthroughValue: PassthroughValue) {           
       54 -    self.passthroughValue = passthroughValue                  
       55 -  }                                                           
       56 -                                                              
       57 -  // ---------------------------------------------------------
          ---------------- //                                            
       58 -  // MARK: Hashable                                           
       59 -  // ---------------------------------------------------------
          ---------------- //                                            
       60 -                                                              
       61 -  @inlinable                                                  
       62 -  public func hash(into hasher: inout Hasher) {               
       63 -    columns.0.hash(into: &hasher)                             
       64 -    columns.1.hash(into: &hasher)                             
       65 -  }                                                           
       66 -                                                              
       67 -  // ---------------------------------------------------------
          ---------------- //                                            
       68 -  // MARK: CustomStringConvertible                            
       69 -  // ---------------------------------------------------------
          ---------------- //                                            
       70 -                                                              
       71 -  @inlinable                                                  
       72 -  public var description: String {                            
       73 -    get {                                                     
       74 -      return "\(type(of: self).typename): \(String(describing:
          - passthroughValue))"                                          
       75 -    }                                                         
       76 -  }                                                           
       77 -                                                              
       78 -  // ---------------------------------------------------------
          ---------------- //                                            
       79 -  // MARK: CustomDebugStringConvertible                       
       80 -  // ---------------------------------------------------------
          ---------------- //                                            
       81 -                                                              
       82 -  @inlinable                                                  
       83 -  public var debugDescription: String {                       
       84 -    get {                                                     
       85 -      return "\(type(of: self).typename)(passthroughValue: \(S
          -tring(reflecting: passthroughValue)))"                        
       86 -    }                                                         
       87 -  }                                                           
       88 -                                                              
       89 -  // ---------------------------------------------------------
          ---------------- //                                            
       90 -  // MARK: Codable                                            
       91 -  // ---------------------------------------------------------
          ---------------- //                                            
       92 -                                                              
       93 -  public enum CodingKeys: String, CodingKey {                 
       94 -                                                              
       95 -    case c0 = "c0"                                            
       96 -    case c1 = "c1"                                            
       97 -                                                              
       98 -    @inlinable                                                
       99 -    public var intValue: Int? {                               
      100 -      get {                                                   
      101 -        switch self {                                         
      102 -        case .c0:                                             
      103 -          return 0                                            
      104 -        case .c1:                                             
      105 -          return 1                                            
      106 -        }                                                     
      107 -      }                                                       
      108 -    }                                                         
      109 -                                                              
      110 -    @inlinable                                                
      111 -    public init?(intValue: Int) {                             
      112 -      switch intValue {                                       
      113 -      case 0:                                                 
      114 -        self = .c0                                            
      115 -      case 1:                                                 
      116 -        self = .c1                                            
      117 -      default:                                                
      118 -        return nil                                            
      119 -      }                                                       
      120 -    }                                                         
      121 -                                                              
      122 -  }                                                           
      123 -                                                              
      124 -  @inlinable                                                  
      125 -  public func encode(to encoder: Encoder) throws {            
      126 -    var container = encoder.container(keyedBy: CodingKeys.self
          -)                                                             
      127 -    try container.encode(                                     
      128 -      columns.0,                                              
      129 -      forKey: .c0                                             
      130 -    )                                                         
      131 -    try container.encode(                                     
      132 -      columns.1,                                              
      133 -      forKey: .c1                                             
      134 -    )                                                         
      135 -  }                                                           
      136 -                                                              
      137 -  @inlinable                                                  
      138 -  public init(from decoder: Decoder) throws {                 
      139 -    let container = try decoder.container(keyedBy: CodingKeys.
          -self)                                                         
      140 -    let c0 = try container.decode(                            
      141 -      ColumnVector.self,                                      
      142 -      forKey: .c0                                             
      143 -    )                                                         
      144 -    let c1 = try container.decode(                            
      145 -      ColumnVector.self,                                      
      146 -      forKey: .c1                                             
      147 -    )                                                         
      148 -    self.init(                                                
      149 -      passthroughValue: PassthroughValue(                     
      150 -        c0,                                                   
      151 -        c1                                                    
      152 -      )                                                       
      153 -    )                                                         
      154 -  }                                                           
      155 -                                                              
      156 -}                                                             
       20 +{ }                                                           

⏺ Bash(swift build 2>&1 | grep -E "error:" | head -40)
  ⎿  error: emit-module command failed with exit code 1 (use -v to see invo
     cation)
     /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDXLSI
     … +76 lines (ctrl+o to expand)
  ⎿  (timeout 10m)

⏺ Let me revert the storage migration to get back to green, then take a
  different path — migrate wrappers first:

⏺ Bash(git checkout /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sour
      ces/HDXLSIMDSupport/Matrices/Storages/Float/FloatMatrix2x2Storage.swift)
  ⎿  Updated 1 path from the index

⏺ Bash(swift build 2>&1 | tail -10)
  ⎿  Building for debugging...
     [0/3] Write sources
     [1/3] Write swift-version--58304C5D6DBC2206.txt
     … +3 lines (ctrl+o to expand)
  ⎿  (timeout 10m)

⏺ Strategy adjustment: I'll keep the migrated types Passthrough-conformant
  during transition, switching the macros to emit passthroughValue (the existing
   Passthrough property name). This lets me migrate types one-at-a-time without
  breaking cross-references. After all types are migrated I'll do a final rename
   pass.

  Let me revise the macrolets:

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/StorageBackingMacrolet.swif
       t)
  ⎿  Added 14 lines, removed 13 lines
       4  
       5  import SwiftSyntax
       6  
       7 -/// Emits the stored property and initializer that ties a wrapp
         -ing layer                                                      
       8 -/// (storage or wrapper) to its underlying value.              
       7 +/// Emits the stored value + initializer that ties a wrapping l
         +ayer to its                                                    
       8 +/// underlying value. During the migration we keep the *name* `
         +passthroughValue`                                              
       9 +/// so the generated types continue to satisfy the existing `Pa
         +ssthrough`                                                     
      10 +/// protocol (and so they can interoperate with not-yet-migrate
         +d types via                                                    
      11 +/// existing `Passthrough` extensions). Once all types are migr
         +ated, this                                                     
      12 +/// macrolet will be flipped over to emit `storage`/`init(stora
         +ge:)` and                                                      
      13 +/// `Passthrough` will be demolished.                          
      14  ///
      10 -/// - Native layer: emits nothing (a `simd_float2x2` doesn't wr
         -ap anything).                                                  
      11 -/// - Storage layer: emits                                     
      12 -///       `@usableFromInline internal var storage: simd_float2x
         -2`                                                             
      13 -///       `@inlinable internal init(storage: simd_float2x2) { .
         -.. }`                                                          
      14 -/// - Wrapper layer: emits                                     
      15 -///       `@usableFromInline internal var storage: Scalar.Matri
         -xNxMStorage`                                                   
      16 -///       `@inlinable internal init(storage: Scalar.MatrixNxMSt
         -orage) { ... }`                                                
      15 +/// - Native layer: emits nothing (`simd_floatNxM` IS its own v
         +alue).                                                         
      16 +/// - Storage / Wrapper: emits `typealias PassthroughValue`, th
         +e stored                                                       
      17 +///   `passthroughValue` property, and `init(passthroughValue:)
         +`.                                                             
      18  struct StorageBackingMacrolet: SIMDMatrixMacrolet {
      19    let descriptor: MatrixDescriptor
      20  
      21    func implementationDeclarations(in context: MatrixLayerContex
          t) -> [DeclSyntax] {
      22      guard let wrappedTypeName = context.wrappedTypeName else { 
          return [] }
      23      return [
      24 +      "public typealias PassthroughValue = \(raw: wrappedTypeNa
         +me)",                                                          
      25        """
      24 -      @usableFromInline                                        
      25 -      internal var storage: \(raw: wrappedTypeName)            
      26 +      public var passthroughValue: PassthroughValue            
      27        """,
      28        """
      29        @inlinable
      29 -      internal init(storage: \(raw: wrappedTypeName)) {        
      30 -        self.storage = storage                                 
      30 +      public init(passthroughValue: PassthroughValue) {        
      31 +        self.passthroughValue = passthroughValue               
      32        }
      33        """
      34      ]

  Searched for 1 pattern (ctrl+o to expand)

⏺ Let me batch-update the macrolet files with careful sed replacements that
  preserve MatrixLayer.storage enum-case usages:

⏺ Bash(cd /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDXLSI
      MDSupportMacroPlugin/Macrolets/ && for f in
      AlmostEqualElementsMacrolet.swift BulkPrope…)
  ⎿  Done with batch-replace
     AlmostEqualElementsMacrolet.swift:3
     CompatibleMatricesMacrolet.swift:0
     … +3 lines (ctrl+o to expand)

⏺ The perl regex was over-aggressive — it broke case .storage: enum cases AND
  left rhs.storage-style member access unchanged. Let me fix both:

⏺ Bash(cd /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDXLSI
      MDSupportMacroPlugin/Macrolets/ && grep -l "case
      .passthroughValue\|passthroughValue, .…)
  ⎿  DescriptionMacrolet.swift
     NativeSIMDRepresentableMacrolet.swift

⏺ Bash(cd /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDXLSI
      MDSupportMacroPlugin/Macrolets/ && for f in DescriptionMacrolet.swift
      NativeSIMDReprese…)
  ⎿  done

⏺ Now fix the rhs.storage / other.storage / lhs.storage / first.storage
  references that the previous regex missed:

⏺ Bash(cd /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDXLSI
      MDSupportMacroPlugin/Macrolets/ && perl -i -pe '
        s/\b(rhs|lhs|other|first)\.storage\b…)
  ⎿  done

⏺ Bash(cd /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDXLSI
      MDSupportMacroPlugin/Macrolets/ && grep -n "\bstorage\b" *.swift | grep -v
       "passthrough…)
  ⎿  AlmostEqualElementsMacrolet.swift:36:    case .storage, .wrapper:
     CompatibleMatricesMacrolet.swift:33:    // mirror the matrix-storage p
     refixing scheme:
     … +24 lines (ctrl+o to expand)

  Read 1 file (ctrl+o to expand)

⏺ Let me fix NativeSIMDRepresentableMacrolet for the wrapper layer — during
  transition it needs to chain through Passthrough:
  Read 1 file (ctrl+o to expand)

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/NativeSIMDRepresentableMac
        rolet.swift)
  ⎿  Added 11 lines, removed 5 lines
      58          """
      59        ]
      60      case .wrapper:
      61 +      // During the migration, the underlying `Scalar.MatrixNxM
         +Storage` may or                                                
      62 +      // may not have a `NativeSIMDRepresentation` typealias ye
         +t — but it DOES                                                
      63 +      // have a `PassthroughValue` (the existing Passthrough co
         +nformance), and                                                
      64 +      // `PassthroughValue.PassthroughValue` is the native simd
         + type. We reach                                                
      65 +      // through the Passthrough chain so the wrapper works reg
         +ardless of                                                     
      66 +      // which underlying storages have already been migrated. 
      67        return [
      68          """
      63 -        public typealias NativeSIMDRepresentation = Scalar.Matr
         -ix\(raw: descriptor.shapeLabel)Storage.NativeSIMDRepresentation
      69 +        public typealias NativeSIMDRepresentation = Passthrough
         +Value.PassthroughValue                                         
      70          """,
      71          """
      72          @inlinable
      73          public var nativeSIMDRepresentation: NativeSIMDRepresen
          tation {
      68 -          get { passthroughValue.nativeSIMDRepresentation }    
      69 -          set { passthroughValue.nativeSIMDRepresentation = new
         -Value }                                                        
      70 -          _modify { yield &passthroughValue.nativeSIMDRepresent
         -ation }                                                        
      74 +          get { passthroughValue.passthroughValue }            
      75 +          set { passthroughValue.passthroughValue = newValue } 
      76 +          _modify { yield &passthroughValue.passthroughValue } 
      77          }
      78          """,
      79          """
      80          @inlinable
      81          public init(nativeSIMDRepresentation: NativeSIMDReprese
          ntation) {
      76 -          self.init(passthroughValue: Scalar.Matrix\(raw: descr
         -iptor.shapeLabel)Storage(nativeSIMDRepresentation: nativeSIMDRe
         -presentation))                                                 
      82 +          self.init(passthroughValue: PassthroughValue(passthro
         +ughValue: nativeSIMDRepresentation))                           
      83          }
      84          """
      85        ]

⏺ Now build and verify the plugin still compiles cleanly:

⏺ Bash(swift build 2>&1 | grep -E "error:" | head -30)
  ⎿  (No output)

⏺ Bash(swift build 2>&1 | tail -20)
  ⎿  Building for debugging...
     [0/2] Write swift-version--58304C5D6DBC2206.txt
     Build complete! (0.09s)

⏺ Bash(touch /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDX
      LSIMDSupport/Matrices/NativeConformances/Float/simd_float2x2+Matrix2x2Prot
      ocol.swift &&…)
  ⎿  (No output)
  ⎿  (timeout 10m)

⏺ Bash(touch /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDX
      LSIMDSupport/Matrices/NativeConformances/Float/simd_float2x2+Matrix2x2Prot
      ocol.swift &&…)
  ⎿  Building for debugging...
     [0/3] Write sources
     [1/3] Write swift-version--58304C5D6DBC2206.txt
     … +3 lines (ctrl+o to expand)
  ⎿  (timeout 10m)

⏺ Let me migrate Matrix2x2<Scalar> wrapper as the next test:

⏺ Write(Sources/HDXLSIMDSupport/Matrices/Matrices/Matrix2x2.swift)
  ⎿  Added 3 lines, removed 83 lines
       7  import SwiftUI
       8  
       9  @frozen
      10 -public struct Matrix2x2<Scalar:ExtendedSIMDScalar> :           
      10 +@AddWrapperMatrixConformance(rowCount: 2, columnCount: 2)      
      11 +public struct Matrix2x2<Scalar: ExtendedSIMDScalar>:           
      12    Matrix2x2Protocol,
      13    MatrixOperatorSupportProtocol,
      14    Matrix2x2OperatorSupportProtocol,
     ...
       20    CustomDebugStringConvertible,
       21    Codable,
       22    VectorArithmetic
       22 -{                                                             
       23 -                                                              
       24 -  public typealias CompatibleMatrix2x3 = Matrix2x3<Scalar>    
       25 -  public typealias CompatibleMatrix3x2 = Matrix3x2<Scalar>    
       26 -  public typealias CompatibleMatrix2x4 = Matrix2x4<Scalar>    
       27 -  public typealias CompatibleMatrix4x2 = Matrix4x2<Scalar>    
       28 -                                                              
       29 -  public typealias PassthroughValue = Scalar.Matrix2x2Storage 
       30 -  public typealias RowVector = PassthroughValue.RowVector     
       31 -  public typealias ColumnVector = PassthroughValue.ColumnVecto
          -r                                                             
       32 -  public typealias DiagonalVector = PassthroughValue.DiagonalV
          -ector                                                         
       33 -  public typealias Rows = PassthroughValue.Rows               
       34 -  public typealias Columns = PassthroughValue.Columns         
       35 -  public typealias NumericEntryRepresentation = PassthroughVal
          -ue.NumericEntryRepresentation                                 
       36 -                                                              
       37 -  public var passthroughValue: PassthroughValue               
       38 -                                                              
       39 -  @inlinable                                                  
       40 -  public init(passthroughValue: PassthroughValue) {           
       41 -    self.passthroughValue = passthroughValue                  
       42 -  }                                                           
       43 -                                                              
       44 -  public typealias NativeSIMDRepresentation = PassthroughValue
          -.PassthroughValue                                             
       45 -                                                              
       46 -  @inlinable                                                  
       47 -  public var nativeSIMDRepresentation: NativeSIMDRepresentatio
          -n {                                                           
       48 -    get {                                                     
       49 -      return passthroughValue.passthroughValue                
       50 -    }                                                         
       51 -    set {                                                     
       52 -      passthroughValue.passthroughValue = newValue            
       53 -    }                                                         
       54 -    _modify {                                                 
       55 -      yield &passthroughValue.passthroughValue                
       56 -    }                                                         
       57 -  }                                                           
       58 -                                                              
       59 -  @inlinable                                                  
       60 -  public init(nativeSIMDRepresentation: NativeSIMDRepresentati
          -on) {                                                         
       61 -    self.init(                                                
       62 -      passthroughValue: PassthroughValue(                     
       63 -        passthroughValue: nativeSIMDRepresentation            
       64 -      )                                                       
       65 -    )                                                         
       66 -  }                                                           
       67 -                                                              
       68 -  @inlinable                                                  
       69 -  public var description: String {                            
       70 -    get {                                                     
       71 -      return "Matrix2x2: \(String(describing: nativeSIMDRepres
          -entation))"                                                   
       72 -    }                                                         
       73 -  }                                                           
       74 -                                                              
       75 -  @inlinable                                                  
       76 -  public var debugDescription: String {                       
       77 -    get {                                                     
       78 -      return "Matrix2x2<\(String(reflecting: Scalar.self))>(na
          -tiveSIMDRepresentation: \(String(reflecting: nativeSIMDReprese
          -ntation)))"                                                   
       79 -    }                                                         
       80 -  }                                                           
       81 -                                                              
       82 -  @inlinable                                                  
       83 -  public static var zero: Matrix2x2<Scalar> {                 
       84 -    get {                                                     
       85 -      return Matrix2x2<Scalar>()                              
       86 -    }                                                         
       87 -  }                                                           
       88 -                                                              
       89 -  @inlinable                                                  
       90 -  public var magnitudeSquared: Double {                       
       91 -    get {                                                     
       92 -      return Double(componentwiseMagnitudeSquared)            
       93 -    }                                                         
       94 -  }                                                           
       95 -                                                              
       96 -  @inlinable                                                  
       97 -  public mutating func scale(by factor: Double) {             
       98 -    formMultiplication(                                       
       99 -      by: Scalar(factor)                                      
      100 -    )                                                         
      101 -  }                                                           
      102 -                                                              
      103 -}                                                             
       23 +{ }                                                           

⏺ Bash(swift build 2>&1 | grep -E "error:" | head -30)
  ⎿  error: emit-module command failed with exit code 1 (use -v to see invo
     cation)
     macro expansion @AddWrapperMatrixConformance:120:19: error: static sto
     … +7 lines (ctrl+o to expand)
  ⎿  (timeout 10m)

⏺ matrixPositions can't be static let in a generic type. Let me fix that:

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/PositionHelpersMacrolet.sw
        ift)
  ⎿  Added 6 lines, removed 2 lines
      54          return MatrixPosition(rowIndex: row, columnIndex: colum
          n)
      55        }
      56        """,
      57 +      // Computed (not stored) because static stored properties
         + aren't allowed                                                
      58 +      // in generic types (the wrapper `Matrix2x2<Scalar>` is g
         +eneric). The                                                   
      59 +      // array is small (≤16 entries) so the per-call cost is n
         +egligible.                                                     
      60        """
      58 -      public static let matrixPositions: [MatrixPosition] = {  
      61 +      @inlinable                                               
      62 +      public static var matrixPositions: [MatrixPosition] {    
      63          var result: [MatrixPosition] = []
      64          result.reserveCapacity(\(raw: columnCount * rowCount))
      65          for columnIndex in 0..<\(raw: columnCount) {
     ...
      68            }
      69          }
      70          return result
      67 -      }()                                                      
      71 +      }                                                        
      72        """,
      73        """
      74        @inlinable

⏺ Bash(swift build 2>&1 | grep -E "error:" | head -30)
  ⎿  (No output)
  ⎿  (timeout 10m)

⏺ Bash(touch /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDX
      LSIMDSupport/Matrices/Matrices/Matrix2x2.swift && swift build 2>&1 | grep
      -E "error:" |…)
  ⎿  (No output)
  ⎿  (timeout 10m)

⏺ Bash(swift build 2>&1 | tail -30)
  ⎿  Building for debugging...
     [0/2] Write swift-version--58304C5D6DBC2206.txt
     Build complete! (0.10s)

⏺ Bash(touch /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDX
      LSIMDSupport/Matrices/Matrices/Matrix2x2.swift && touch
      /Users/prb/conductor/workspaces…)
  ⎿  Building for debugging...
     [0/4] Write sources
     [2/4] Write swift-version--58304C5D6DBC2206.txt
     … +6 lines (ctrl+o to expand)
  ⎿  (timeout 10m)

⏺ Bash(swift test 2>&1 | tail -10)
  ⎿  Test Suite 'QuaternionMemoryLayoutTests' passed at 2026-05-14 21:13:21
     .538.
         Executed 3 tests, with 0 failures (0 unexpected) in 0.000 (0.000) sec
     … +12 lines (ctrl+o to expand)


⏺ Now migrate FloatMatrix2x2Storage:

⏺ Write(Sources/HDXLSIMDSupport/Matrices/Storages/Float/FloatMatrix2x2Storage.sw
       ift)
  ⎿  Added 4 lines, removed 139 lines
        6  import simd
        7  
        8  @frozen
        9 -public struct FloatMatrix2x2Storage :                         
        9 +@AddStorageMatrixConformance(rowCount: 2, columnCount: 2, repr
          +esentation: .float)                                           
       10 +public struct FloatMatrix2x2Storage:                          
       11    Matrix2x2Protocol,
       12    MatrixOperatorSupportProtocol,
       13    Matrix2x2OperatorSupportProtocol,
       14    Passthrough,
       15 +  NativeSIMDRepresentable,                                    
       16    NumericAggregate,
       17    Hashable,
       18    CustomStringConvertible,
       19    CustomDebugStringConvertible,
       20    Codable
       19 -{                                                             
       20 -                                                              
       21 -  public typealias CompatibleMatrix2x3 = FloatMatrix2x3Storage
       22 -  public typealias CompatibleMatrix3x2 = FloatMatrix3x2Storage
       23 -  public typealias CompatibleMatrix2x4 = FloatMatrix2x4Storage
       24 -  public typealias CompatibleMatrix4x2 = FloatMatrix4x2Storage
       25 -                                                              
       26 -  public typealias PassthroughValue = simd_float2x2           
       27 -  public typealias Scalar = PassthroughValue.Scalar           
       28 -  public typealias RowVector = PassthroughValue.RowVector     
       29 -  public typealias ColumnVector = PassthroughValue.ColumnVecto
          -r                                                             
       30 -  public typealias DiagonalVector = PassthroughValue.DiagonalV
          -ector                                                         
       31 -  public typealias Rows = PassthroughValue.Rows               
       32 -  public typealias Columns = PassthroughValue.Columns         
       33 -  public typealias NumericEntryRepresentation = PassthroughVal
          -ue.NumericEntryRepresentation                                 
       34 -                                                              
       35 -  // ---------------------------------------------------------
          ---------------- //                                            
       36 -  // MARK: Typename                                           
       37 -  // ---------------------------------------------------------
          ---------------- //                                            
       38 -                                                              
       39 -  @usableFromInline                                           
       40 -  internal static var typename: String {                      
       41 -    get {                                                     
       42 -      return "FloatMatrix2x2Storage"                          
       43 -    }                                                         
       44 -  }                                                           
       45 -                                                              
       46 -  // ---------------------------------------------------------
          ---------------- //                                            
       47 -  // MARK: Passthrough                                        
       48 -  // ---------------------------------------------------------
          ---------------- //                                            
       49 -                                                              
       50 -  public var passthroughValue: PassthroughValue               
       51 -                                                              
       52 -  @inlinable                                                  
       53 -  public init(passthroughValue: PassthroughValue) {           
       54 -    self.passthroughValue = passthroughValue                  
       55 -  }                                                           
       56 -                                                              
       57 -  // ---------------------------------------------------------
          ---------------- //                                            
       58 -  // MARK: Hashable                                           
       59 -  // ---------------------------------------------------------
          ---------------- //                                            
       60 -                                                              
       61 -  @inlinable                                                  
       62 -  public func hash(into hasher: inout Hasher) {               
       63 -    columns.0.hash(into: &hasher)                             
       64 -    columns.1.hash(into: &hasher)                             
       65 -  }                                                           
       66 -                                                              
       67 -  // ---------------------------------------------------------
          ---------------- //                                            
       68 -  // MARK: CustomStringConvertible                            
       69 -  // ---------------------------------------------------------
          ---------------- //                                            
       70 -                                                              
       71 -  @inlinable                                                  
       72 -  public var description: String {                            
       73 -    get {                                                     
       74 -      return "\(type(of: self).typename): \(String(describing:
          - passthroughValue))"                                          
       75 -    }                                                         
       76 -  }                                                           
       77 -                                                              
       78 -  // ---------------------------------------------------------
          ---------------- //                                            
       79 -  // MARK: CustomDebugStringConvertible                       
       80 -  // ---------------------------------------------------------
          ---------------- //                                            
       81 -                                                              
       82 -  @inlinable                                                  
       83 -  public var debugDescription: String {                       
       84 -    get {                                                     
       85 -      return "\(type(of: self).typename)(passthroughValue: \(S
          -tring(reflecting: passthroughValue)))"                        
       86 -    }                                                         
       87 -  }                                                           
       88 -                                                              
       89 -  // ---------------------------------------------------------
          ---------------- //                                            
       90 -  // MARK: Codable                                            
       91 -  // ---------------------------------------------------------
          ---------------- //                                            
       92 -                                                              
       93 -  public enum CodingKeys: String, CodingKey {                 
       94 -                                                              
       95 -    case c0 = "c0"                                            
       96 -    case c1 = "c1"                                            
       97 -                                                              
       98 -    @inlinable                                                
       99 -    public var intValue: Int? {                               
      100 -      get {                                                   
      101 -        switch self {                                         
      102 -        case .c0:                                             
      103 -          return 0                                            
      104 -        case .c1:                                             
      105 -          return 1                                            
      106 -        }                                                     
      107 -      }                                                       
      108 -    }                                                         
      109 -                                                              
      110 -    @inlinable                                                
      111 -    public init?(intValue: Int) {                             
      112 -      switch intValue {                                       
      113 -      case 0:                                                 
      114 -        self = .c0                                            
      115 -      case 1:                                                 
      116 -        self = .c1                                            
      117 -      default:                                                
      118 -        return nil                                            
      119 -      }                                                       
      120 -    }                                                         
      121 -                                                              
      122 -  }                                                           
      123 -                                                              
      124 -  @inlinable                                                  
      125 -  public func encode(to encoder: Encoder) throws {            
      126 -    var container = encoder.container(keyedBy: CodingKeys.self
          -)                                                             
      127 -    try container.encode(                                     
      128 -      columns.0,                                              
      129 -      forKey: .c0                                             
      130 -    )                                                         
      131 -    try container.encode(                                     
      132 -      columns.1,                                              
      133 -      forKey: .c1                                             
      134 -    )                                                         
      135 -  }                                                           
      136 -                                                              
      137 -  @inlinable                                                  
      138 -  public init(from decoder: Decoder) throws {                 
      139 -    let container = try decoder.container(keyedBy: CodingKeys.
          -self)                                                         
      140 -    let c0 = try container.decode(                            
      141 -      ColumnVector.self,                                      
      142 -      forKey: .c0                                             
      143 -    )                                                         
      144 -    let c1 = try container.decode(                            
      145 -      ColumnVector.self,                                      
      146 -      forKey: .c1                                             
      147 -    )                                                         
      148 -    self.init(                                                
      149 -      passthroughValue: PassthroughValue(                     
      150 -        c0,                                                   
      151 -        c1                                                    
      152 -      )                                                       
      153 -    )                                                         
      154 -  }                                                           
      155 -                                                              
      156 -}                                                             
       21 +{ }                                                           

⏺ Bash(swift build 2>&1 | grep -E "error:" | head -30)
  ⎿  (No output)
  ⎿  (timeout 10m)

⏺ Bash(swift build 2>&1 | tail -20)  ⎿  Building for debugging...
     [0/2] Write swift-version--58304C5D6DBC2206.txt
     Build complete! (0.09s)

⏺ Bash(touch /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDX
      LSIMDSupport/Matrices/Storages/Float/FloatMatrix2x2Storage.swift && swift
      build 2>&1 |…)
  ⎿  Building for debugging...
     [0/3] Write sources
     [1/3] Write swift-version--58304C5D6DBC2206.txt
     … +3 lines (ctrl+o to expand)
  ⎿  (timeout 10m)

⏺ Bash(swift test 2>&1 | tail -10)
  ⎿  Test Suite 'QuaternionMemoryLayoutTests' passed at 2026-05-14 21:14:17
     .365.
         Executed 3 tests, with 0 failures (0 unexpected) in 0.000 (0.000) sec
     … +12 lines (ctrl+o to expand)


⏺ Phase 2 is essentially done. Matrix2x2 over Float runs end-to-end through
  macros. Let me commit progress and expand to all shapes for Float.

⏺ Bash(git add -A && git status --short && echo "---" && git diff --cached
      --stat | tail -30)
  ⎿  M  Package.swift
     A  Sources/HDXLSIMDSupport/Macros/Macros.swift
     M  Sources/HDXLSIMDSupport/Matrices/Matrices/Matrix2x2.swift
     … +74 lines (ctrl+o to expand)

⏺ Let me batch-migrate the remaining 8 Float natives. I'll write them in
  parallel:

⏺ Write(Sources/HDXLSIMDSupport/Matrices/NativeConformances/Float/simd_float2x3+
       Matrix2x3Protocol.swift)
  ⎿  Error writing file

⏺ Bash(for f in /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/
      HDXLSIMDSupport/Matrices/NativeConformances/Float/*.swift; do echo "=== $f
       ==="; done)
  ⎿  === /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HD
     XLSIMDSupport/Matrices/NativeConformances/Float/simd_float2x2+Matrix2x
     2Protocol.swift ===
     … +18 lines (ctrl+o to expand)

⏺ Need to read each file before writing. Let me use a shell command to do this
  in bulk efficiently:

⏺ Bash(cd /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDXLSI
      MDSupport/Matrices/NativeConformances/Float/…)
  ⎿  Wrote simd_float2x3
     Wrote simd_float2x4
     Wrote simd_float3x2
     … +5 lines (ctrl+o to expand)

⏺ Bash(cd /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDXLSI
      MDSupport/Matrices/Storages/Float/…)
  ⎿  Wrote FloatMatrix2x3Storage
     Wrote FloatMatrix2x4Storage
     Wrote FloatMatrix3x2Storage
     … +5 lines (ctrl+o to expand)

⏺ Bash(cd /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDXLSI
      MDSupport/Matrices/Matrices/…)
  ⎿  Wrote Matrix2x3
     Wrote Matrix2x4
     Wrote Matrix3x2
     … +5 lines (ctrl+o to expand)

⏺ Now delete the corresponding +NumericAggregate.swift files for Float (the
  macro generates this now):

⏺ Bash(cd /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDXLSI
      MDSupport/NumericAggregate/Conformances/Matrices/Float/ && ls && rm -v
      simd_float*.swif…)
  ⎿  simd_float2x3+NumericAggregate.swift
     simd_float2x4+NumericAggregate.swift
     simd_float3x2+NumericAggregate.swift
     … +13 lines (ctrl+o to expand)

⏺ Now build to see what breaks:

⏺ Bash(swift build 2>&1 | grep -E "error:" | head -40)
  ⎿  /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDXLSI
     MDSupport/Matrices/NativeConformances/Float/simd_float3x3+Matrix3x3Pro
     tocol.swift:9:1: error: initializer 'init(_:)' has different argument
     … +121 lines (ctrl+o to expand)
  ⎿  (timeout 10m)

⏺ Matrix3x3Protocol and Matrix4x4Protocol need init(quaternion:). Let me check:

  Searched for 1 pattern (ctrl+o to expand)

⏺ I need a QuaternionConstructorMacrolet for 3x3 and 4x4:

  Searched for 1 pattern (ctrl+o to expand)
⏺ Bash(git show HEAD:Sources/HDXLSIMDSupport/Matrices/NativeConformances/Float/s
      imd_float3x3+Matrix3x3Protocol.swift 2>/dev/null | grep -A5
      "init(quaternion")
  ⎿    public init(quaternion: CompatibleQuaternion) {
         self.init(quaternion)
       }
     … +4 lines (ctrl+o to expand)

⏺ Bash(git show HEAD:Sources/HDXLSIMDSupport/Matrices/Storages/Float/FloatMatrix
      3x3Storage.swift 2>/dev/null | grep -B2 -A5 "init(quaternion")
  ⎿  No matches found

  Searched for 2 patterns (ctrl+o to expand)

⏺ Bash(sed -n '253,262p'
      /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDXLSIMDSu
      pport/Matrices/Passthrough/Passthrough+Matrix3x3Protocol.swift)
  ⎿    @inlinable
       init(quaternion: CompatibleQuaternion) {
         self.init(
     … +5 lines (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/QuaternionConstructorMacrol
       et.swift)
  ⎿  Wrote 42 lines to Sources/HDXLSIMDSupportMacroPlugin/Macrolets/Quatern
     ionConstructorMacrolet.swift
       2 //  QuaternionConstructorMacrolet.swift
       3 //
       4 
       5 import SwiftSyntax
       6 
       7 /// `init(quaternion: CompatibleQuaternion)` — only required by
       8 /// `Matrix3x3Protocol` and `Matrix4x4Protocol`.
       9 ///
      10 /// - Native: bridges via the simd overlay's `init(_ quaternion:
         )` (which is
     … +37 lines (ctrl+o to expand)

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Macros/MatrixMacroletComposition.swi
        ft)
  ⎿  Added 1 line
      54      result.append(TransposeMacrolet(descriptor: descriptor))
      55      result.append(DeterminantMacrolet(descriptor: descriptor))
      56      result.append(InversionMacrolet(descriptor: descriptor))
      57 +    result.append(QuaternionConstructorMacrolet(descriptor: des
         +criptor))                                                      
      58      result.append(SquareMultiplicationMacrolet(descriptor: desc
          riptor))
      59      result.append(SquareDivisionMacrolet(descriptor: descriptor
          ))
      60  

⏺ Bash(swift build 2>&1 | grep -E "error:" | head -30)
  ⎿  (No output)
  ⎿  (timeout 10m)

⏺ Bash(touch /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDX
      LSIMDSupport/Matrices/NativeConformances/Float/simd_float3x3+Matrix3x3Prot
      ocol.swift &&…)
  ⎿  (No output)
  ⎿  (timeout 10m)

⏺ Bash(touch /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDX
      LSIMDSupport/Matrices/NativeConformances/Float/simd_float3x3+Matrix3x3Prot
      ocol.swift &&…)
  ⎿  Building for debugging...
     [0/3] Write sources
     [1/3] Write swift-version--58304C5D6DBC2206.txt
     … +3 lines (ctrl+o to expand)
  ⎿  (timeout 10m)

⏺ Bash(swift test 2>&1 | tail -10)
  ⎿  Test Suite 'QuaternionMemoryLayoutTests' passed at 2026-05-14 21:17:49
     .151.
         Executed 3 tests, with 0 failures (0 unexpected) in 0.000 (0.000) sec
     … +12 lines (ctrl+o to expand)


⏺ Phase 3 (Float) complete — all 133 tests pass with macro-generated code. Let
  me proceed to Double + Half (Phase 4). First batch — Double, which should
  mirror Float:

⏺ Bash(cd /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDXLSI
      MDSupport/Matrices/NativeConformances/Double/…)
  ⎿  Done

⏺ Bash(swift build 2>&1 | grep -E "error:" | head -20)
  ⎿  (No output)
  ⎿  (timeout 10m)

⏺ Bash(touch /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDX
      LSIMDSupport/Matrices/Storages/Double/DoubleMatrix2x2Storage.swift &&
      swift build 2>&1…)
  ⎿  Building for debugging...
     [0/3] Write sources
     [1/3] Write swift-version--58304C5D6DBC2206.txt
     … +3 lines (ctrl+o to expand)
  ⎿  (timeout 10m)

⏺ Bash(swift test 2>&1 | tail -10)
  ⎿  Test Suite 'QuaternionMemoryLayoutTests' passed at 2026-05-14 21:18:49
     .225.
         Executed 3 tests, with 0 failures (0 unexpected) in 0.000 (0.000) sec
     … +12 lines (ctrl+o to expand)

  ⎿  (timeout 10m)

⏺ Now the trickier Half migration. Let me look at the existing overlay-bug
  workarounds:

  Read 1 file (ctrl+o to expand)

⏺ Let me check how SquareMultiplication handles half3x3:

  Searched for 4 patterns (ctrl+o to expand)
⏺ Let me add the half-3-row helper and update affected macrolets:

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/IR/MatrixDescriptor.swift)
  ⎿  Added 17 lines
      73      "SIMD\(Swift.min(rowCount, columnCount))<\(representation.s
          wiftScalarTypeName)>"
      74    }
      75  
      76 +  /// True iff a matrix-returning native simd operation on this
         + shape is                                                      
      77 +  /// miscomputed by the Swift simd overlay on macOS 26 (Float1
         +6 only).                                                       
      78 +  ///                                                          
      79 +  /// The bug is that any C-level `simd_*` routine that *produc
         +es* a                                                          
      80 +  /// `simd_halfNx3` shape returns wrong values. So for half-pr
         +ecision shapes                                                 
      81 +  /// with 3 rows, operations that yield "the same shape" (nega
         +tion, addition,                                                
      82 +  /// scalar multiplication, etc.) must be implemented in pure 
         +Swift by                                                       
      83 +  /// composing per-column operations.                         
      84 +  ///                                                          
      85 +  /// Operations that DON'T produce a half-3-row matrix (e.g. `
         +determinant`                                                   
      86 +  /// returning a scalar, or `transposed()` from a 3-row to a n
         +on-3-row shape)                                                
      87 +  /// continue to use the native simd routines because those re
         +turn values are                                                
      88 +  /// correct.                                                 
      89 +  var producesBuggyHalfThreeRow: Bool {                        
      90 +    representation == .half && rowCount == 3                   
      91 +  }                                                            
      92 +                                                               
      93    // MARK: Compatible matrices
      94  
      95    /// Compatible matrix shape `MxN` (in the same representation
          ) given an

⏺ Now update each affected macrolet. Let me start with NegationMacrolet:

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/NegationMacrolet.swift)
  ⎿  Added 22 lines, removed 2 lines
       6  
       7  /// Emits `negated() -> Self` and `formNegation()`.
       8  ///
       9 -/// - Native: implements `-self` directly.                     
      10 -/// - Storage/Wrapper: forwards to `passthroughValue.negated()`
         -.                                                              
       9 +/// - Native: implements `-self` directly, except for shapes wh
         +ose simd overlay                                               
      10 +///   matrix-level operations are buggy (`producesBuggyHalfThre
         +eRow`), where we                                               
      11 +///   fall back to a column-wise pure-Swift implementation.    
      12 +/// - Storage/Wrapper: forwards.                               
      13  struct NegationMacrolet: SIMDMatrixMacrolet {
      14    let descriptor: MatrixDescriptor
      15  
      16    func implementationDeclarations(in context: MatrixLayerContex
          t) -> [DeclSyntax] {
      17      switch context.layer {
      18      case .native:
      19 +      if descriptor.producesBuggyHalfThreeRow {                
      20 +        let columnsTuple = "(" + (0..<descriptor.columnCount).m
         +ap { "-columns.\($0)" }.joined(separator: ",") + ")"           
      21 +        let formStmts = (0..<descriptor.columnCount).map { "col
         +umns.\($0) = -columns.\($0)" }.joined(separator: "\n")         
      22 +        return [                                               
      23 +          """                                                  
      24 +          @inlinable                                           
      25 +          public func negated() -> Self {                      
      26 +            Self(columns: \(raw: columnsTuple))                
      27 +          }                                                    
      28 +          """,                                                 
      29 +          """                                                  
      30 +          @inlinable                                           
      31 +          public mutating func formNegation() {                
      32 +            \(raw: formStmts)                                  
      33 +          }                                                    
      34 +          """                                                  
      35 +        ]                                                      
      36 +      }                                                        
      37        return [
      38          """
      39          @inlinable

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/MatrixAdditionMacrolet.swif
       t)
  ⎿  Error writing file

  Read 1 file (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/MatrixAdditionMacrolet.swif
       t)
  ⎿  Added 26 lines
       5  import SwiftSyntax
       6  
       7  /// Componentwise matrix-matrix addition: `adding(_:)` and `for
          mAddition(of:)`.
       8 +///                                                            
       9 +/// Half-precision shapes that return half-3-row matrices fall 
         +back to                                                        
      10 +/// column-wise pure Swift, because the C-level `simd_*` overlo
         +ad is                                                          
      11 +/// miscomputed by the macOS 26 simd overlay.                  
      12  struct MatrixAdditionMacrolet: SIMDMatrixMacrolet {
      13    let descriptor: MatrixDescriptor
      14  
      15    func implementationDeclarations(in context: MatrixLayerContex
          t) -> [DeclSyntax] {
      16      switch context.layer {
      17      case .native:
      18 +      if descriptor.producesBuggyHalfThreeRow {                
      19 +        let columnsTuple = "(" +                               
      20 +          (0..<descriptor.columnCount).map { "columns.\($0) + o
         +ther.columns.\($0)" }.joined(separator: ",")                   
      21 +          + ")"                                                
      22 +        let formStmts = (0..<descriptor.columnCount)           
      23 +          .map { "columns.\($0) += other.columns.\($0)" }      
      24 +          .joined(separator: "\n")                             
      25 +        return [                                               
      26 +          """                                                  
      27 +          @inlinable                                           
      28 +          public func adding(_ other: Self) -> Self {          
      29 +            Self(columns: \(raw: columnsTuple))                
      30 +          }                                                    
      31 +          """,                                                 
      32 +          """                                                  
      33 +          @inlinable                                           
      34 +          public mutating func formAddition(of other: Self) {  
      35 +            \(raw: formStmts)                                  
      36 +          }                                                    
      37 +          """                                                  
      38 +        ]                                                      
      39 +      }                                                        
      40        return [
      41          """
      42          @inlinable

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/MatrixSubtractionMacrolet.s
       wift)
  ⎿  Error writing file

  Read 1 file (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/MatrixSubtractionMacrolet.s
       wift)
  ⎿  Added 25 lines, removed 1 line
       4  
       5  import SwiftSyntax
       6  
       7 -/// Componentwise matrix-matrix subtraction: `subtracting(_:)` 
         -and `formSubtraction(of:)`.                                    
       7 +/// Componentwise matrix-matrix subtraction.                   
       8 +///                                                            
       9 +/// Half-3-row results use column-wise pure-Swift fallback.    
      10  struct MatrixSubtractionMacrolet: SIMDMatrixMacrolet {
      11    let descriptor: MatrixDescriptor
      12  
      13    func implementationDeclarations(in context: MatrixLayerContex
          t) -> [DeclSyntax] {
      14      switch context.layer {
      15      case .native:
      16 +      if descriptor.producesBuggyHalfThreeRow {                
      17 +        let columnsTuple = "(" +                               
      18 +          (0..<descriptor.columnCount).map { "columns.\($0) - o
         +ther.columns.\($0)" }.joined(separator: ",")                   
      19 +          + ")"                                                
      20 +        let formStmts = (0..<descriptor.columnCount)           
      21 +          .map { "columns.\($0) -= other.columns.\($0)" }      
      22 +          .joined(separator: "\n")                             
      23 +        return [                                               
      24 +          """                                                  
      25 +          @inlinable                                           
      26 +          public func subtracting(_ other: Self) -> Self {     
      27 +            Self(columns: \(raw: columnsTuple))                
      28 +          }                                                    
      29 +          """,                                                 
      30 +          """                                                  
      31 +          @inlinable                                           
      32 +          public mutating func formSubtraction(of other: Self) 
         +{                                                              
      33 +            \(raw: formStmts)                                  
      34 +          }                                                    
      35 +          """                                                  
      36 +        ]                                                      
      37 +      }                                                        
      38        return [
      39          """
      40          @inlinable

  Read 1 file (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/FMAMacrolet.swift)
  ⎿  Added 25 lines
       5  import SwiftSyntax
       6  
       7  /// Fused-multiply-add: `adding(_:multipliedBy:)` and the mutat
          ing variant.
       8 +///                                                            
       9 +/// Half-3-row results use column-wise pure-Swift fallback.    
      10  struct FMAMacrolet: SIMDMatrixMacrolet {
      11    let descriptor: MatrixDescriptor
      12  
      13    func implementationDeclarations(in context: MatrixLayerContex
          t) -> [DeclSyntax] {
      14      switch context.layer {
      15      case .native:
      16 +      if descriptor.producesBuggyHalfThreeRow {                
      17 +        let columnsTuple = "(" +                               
      18 +          (0..<descriptor.columnCount).map { "columns.\($0) + o
         +ther.columns.\($0) * scalar" }                                 
      19 +            .joined(separator: ",")                            
      20 +          + ")"                                                
      21 +        let formStmts = (0..<descriptor.columnCount)           
      22 +          .map { "columns.\($0) += other.columns.\($0) * scalar
         +" }                                                            
      23 +          .joined(separator: "\n")                             
      24 +        return [                                               
      25 +          """                                                  
      26 +          @inlinable                                           
      27 +          public func adding(_ other: Self, multipliedBy scalar
         +: Scalar) -> Self {                                            
      28 +            Self(columns: \(raw: columnsTuple))                
      29 +          }                                                    
      30 +          """,                                                 
      31 +          """                                                  
      32 +          @inlinable                                           
      33 +          public mutating func formAddition(of other: Self, mul
         +tipliedBy scalar: Scalar) {                                    
      34 +            \(raw: formStmts)                                  
      35 +          }                                                    
      36 +          """                                                  
      37 +        ]                                                      
      38 +      }                                                        
      39        return [
      40          """
      41          @inlinable

  Read 1 file (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/FMSMacrolet.swift)
  ⎿  Added 25 lines
       5  import SwiftSyntax
       6  
       7  /// Fused-multiply-subtract: `subtracting(_:multipliedBy:)` and
           the mutating variant.
       8 +///                                                            
       9 +/// Half-3-row results use column-wise pure-Swift fallback.    
      10  struct FMSMacrolet: SIMDMatrixMacrolet {
      11    let descriptor: MatrixDescriptor
      12  
      13    func implementationDeclarations(in context: MatrixLayerContex
          t) -> [DeclSyntax] {
      14      switch context.layer {
      15      case .native:
      16 +      if descriptor.producesBuggyHalfThreeRow {                
      17 +        let columnsTuple = "(" +                               
      18 +          (0..<descriptor.columnCount).map { "columns.\($0) - o
         +ther.columns.\($0) * scalar" }                                 
      19 +            .joined(separator: ",")                            
      20 +          + ")"                                                
      21 +        let formStmts = (0..<descriptor.columnCount)           
      22 +          .map { "columns.\($0) -= other.columns.\($0) * scalar
         +" }                                                            
      23 +          .joined(separator: "\n")                             
      24 +        return [                                               
      25 +          """                                                  
      26 +          @inlinable                                           
      27 +          public func subtracting(_ other: Self, multipliedBy s
         +calar: Scalar) -> Self {                                       
      28 +            Self(columns: \(raw: columnsTuple))                
      29 +          }                                                    
      30 +          """,                                                 
      31 +          """                                                  
      32 +          @inlinable                                           
      33 +          public mutating func formSubtraction(of other: Self, 
         +multipliedBy scalar: Scalar) {                                 
      34 +            \(raw: formStmts)                                  
      35 +          }                                                    
      36 +          """                                                  
      37 +        ]                                                      
      38 +      }                                                        
      39        return [
      40          """
      41          @inlinable

  Read 1 file (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/ScalarMultiplicationMacrole
       t.swift)
  ⎿  Added 22 lines
       5  import SwiftSyntax
       6  
       7  /// `multiplied(by:)` / `formMultiplication(by:)` — scalar mult
          iplication.
       8 +/// Half-3-row results use column-wise pure-Swift fallback.    
       9  struct ScalarMultiplicationMacrolet: SIMDMatrixMacrolet {
      10    let descriptor: MatrixDescriptor
      11  
      12    func implementationDeclarations(in context: MatrixLayerContex
          t) -> [DeclSyntax] {
      13      switch context.layer {
      14      case .native:
      15 +      if descriptor.producesBuggyHalfThreeRow {                
      16 +        let columnsTuple = "(" +                               
      17 +          (0..<descriptor.columnCount).map { "columns.\($0) * s
         +calar" }.joined(separator: ",")                                
      18 +          + ")"                                                
      19 +        let formStmts = (0..<descriptor.columnCount)           
      20 +          .map { "columns.\($0) *= scalar" }.joined(separator: 
         +"\n")                                                          
      21 +        return [                                               
      22 +          """                                                  
      23 +          @inlinable                                           
      24 +          public func multiplied(by scalar: Scalar) -> Self {  
      25 +            Self(columns: \(raw: columnsTuple))                
      26 +          }                                                    
      27 +          """,                                                 
      28 +          """                                                  
      29 +          @inlinable                                           
      30 +          public mutating func formMultiplication(by scalar: Sc
         +alar) {                                                        
      31 +            \(raw: formStmts)                                  
      32 +          }                                                    
      33 +          """                                                  
      34 +        ]                                                      
      35 +      }                                                        
      36        return [
      37          """
      38          @inlinable

  Read 1 file (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/ScalarDivisionMacrolet.swif
       t)
  ⎿  Added 26 lines, removed 4 lines
       4  
       5  import SwiftSyntax
       6  
       7 -/// `divided(by:)` / `formDivision(by:)` — scalar division (eac
         -h entry divided                                                
       8 -/// by the scalar). Implementation matches the existing native 
         -conformances:                                                  
       9 -/// multiply by `1/scalar`, letting the floating-point arithmet
         -ic handle the                                                  
      10 -/// non-zero precondition.                                     
       7 +/// `divided(by:)` / `formDivision(by:)` — scalar division.    
       8 +///                                                            
       9 +/// Half-3-row results use column-wise pure-Swift fallback.    
      10  struct ScalarDivisionMacrolet: SIMDMatrixMacrolet {
      11    let descriptor: MatrixDescriptor
      12  
      13    func implementationDeclarations(in context: MatrixLayerContex
          t) -> [DeclSyntax] {
      14      switch context.layer {
      15      case .native:
      16 +      if descriptor.producesBuggyHalfThreeRow {                
      17 +        let columnsTuple = "(" +                               
      18 +          (0..<descriptor.columnCount).map { "columns.\($0) * i
         +nv" }.joined(separator: ",")                                   
      19 +          + ")"                                                
      20 +        let formStmts = (0..<descriptor.columnCount)           
      21 +          .map { "columns.\($0) *= inv" }.joined(separator: "\n
         +")                                                             
      22 +        return [                                               
      23 +          """                                                  
      24 +          @inlinable                                           
      25 +          public func divided(by scalar: Scalar) -> Self {     
      26 +            let inv = (1 as Scalar) / scalar                   
      27 +            return Self(columns: \(raw: columnsTuple))         
      28 +          }                                                    
      29 +          """,                                                 
      30 +          """                                                  
      31 +          @inlinable                                           
      32 +          public mutating func formDivision(by scalar: Scalar) 
         +{                                                              
      33 +            let inv = (1 as Scalar) / scalar                   
      34 +            \(raw: formStmts)                                  
      35 +          }                                                    
      36 +          """                                                  
      37 +        ]                                                      
      38 +      }                                                        
      39        return [
      40          """
      41          @inlinable

  Read 1 file (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/LinearCombinationMacrolet.s
       wift)
  ⎿  Added 22 lines, removed 1 line
       4  
       5  import SwiftSyntax
       6  
       7 -/// `linearCombination(of:weight:with:weight:)` — weighted line
         -ar combination.                                                
       7 +/// `linearCombination(of:weight:with:weight:)`. Half-3-row res
         +ults use a                                                     
       8 +/// pure-Swift column-wise fallback rather than `simd_linear_co
         +mbination`.                                                    
       9  struct LinearCombinationMacrolet: SIMDMatrixMacrolet {
      10    let descriptor: MatrixDescriptor
      11  
      12    func implementationDeclarations(in context: MatrixLayerContex
          t) -> [DeclSyntax] {
      13      switch context.layer {
      14      case .native:
      15 +      if descriptor.producesBuggyHalfThreeRow {                
      16 +        let columnsTuple = "(" +                               
      17 +          (0..<descriptor.columnCount)                         
      18 +            .map { "first.columns.\($0) * firstWeight + other.c
         +olumns.\($0) * otherWeight" }                                  
      19 +            .joined(separator: ",")                            
      20 +          + ")"                                                
      21 +        return [                                               
      22 +          """                                                  
      23 +          @inlinable                                           
      24 +          public static func linearCombination(                
      25 +            of first: Self,                                    
      26 +            weight firstWeight: Scalar,                        
      27 +            with other: Self,                                  
      28 +            weight otherWeight: Scalar                         
      29 +          ) -> Self {                                          
      30 +            Self(columns: \(raw: columnsTuple))                
      31 +          }                                                    
      32 +          """                                                  
      33 +        ]                                                      
      34 +      }                                                        
      35        return [
      36          """
      37          @inlinable

⏺ Now the SquareMultiplicationMacrolet (only matters for 3x3 half):

  Read 1 file (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/SquareMultiplicationMacrole
       t.swift)
  ⎿  Added 42 lines
      10  ///   - `multiplied(onLeftBy lhs: Self) -> Self`   (≡ `lhs * se
          lf`)
      11  ///   - `formMultiplication(onRightBy:)`           (≡ `self *= 
          rhs`)
      12  ///   - `formMultiplication(onLeftBy:)`            (≡ `self = l
          hs * self`)
      13 +///                                                            
      14 +/// Half-3-row (i.e. half-3x3) uses pure Swift column-wise mult
         +iplication.                                                    
      15  struct SquareMultiplicationMacrolet: SIMDMatrixMacrolet {
      16    let descriptor: MatrixDescriptor
      17  
     ...
      19      guard descriptor.isSquare else { return [] }
      20      switch context.layer {
      21      case .native:
      22 +      if descriptor.producesBuggyHalfThreeRow {                
      23 +        // Pure-Swift matmul: column k of (self * rhs) is `sum_
         +i self.columns[i] * rhs.columns[k][i]`.                        
      24 +        let dim = descriptor.columnCount  // == rowCount for sq
         +uare                                                           
      25 +        let buildColumnExpr: (String, String) -> String = { sel
         +fRef, rhsRef in                                                
      26 +          // For each output column k, sum self.columns[i] * rh
         +s.columns[k][i] for i in 0..<dim                               
      27 +          let cols = (0..<dim).map { k -> String in            
      28 +            let summands = (0..<dim).map { i in "\(selfRef).col
         +umns.\(i) * \(rhsRef).columns.\(k)[\(i)]" }                    
      29 +            return "(" + summands.joined(separator: " + ") + ")
         +"                                                              
      30 +          }                                                    
      31 +          return "(" + cols.joined(separator: ",") + ")"       
      32 +        }                                                      
      33 +        let rightMul = buildColumnExpr("self", "rhs")          
      34 +        let leftMul = buildColumnExpr("lhs", "self")           
      35 +        return [                                               
      36 +          """                                                  
      37 +          @inlinable                                           
      38 +          public func multiplied(onRightBy rhs: Self) -> Self {
      39 +            Self(columns: \(raw: rightMul))                    
      40 +          }                                                    
      41 +          """,                                                 
      42 +          """                                                  
      43 +          @inlinable                                           
      44 +          public func multiplied(onLeftBy lhs: Self) -> Self { 
      45 +            Self(columns: \(raw: leftMul))                     
      46 +          }                                                    
      47 +          """,                                                 
      48 +          """                                                  
      49 +          @inlinable                                           
      50 +          public mutating func formMultiplication(onRightBy rhs
         +: Self) {                                                      
      51 +            self = multiplied(onRightBy: rhs)                  
      52 +          }                                                    
      53 +          """,                                                 
      54 +          """                                                  
      55 +          @inlinable                                           
      56 +          public mutating func formMultiplication(onLeftBy lhs:
         + Self) {                                                       
      57 +            self = multiplied(onLeftBy: lhs)                   
      58 +          }                                                    
      59 +          """                                                  
      60 +        ]                                                      
      61 +      }                                                        
      62        return [
      63          """
      64          @inlinable
⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/QuaternionConstructorMacrol
       et.swift)
  ⎿  Added 22 lines, removed 3 lines
       7  /// `init(quaternion: CompatibleQuaternion)` — only required by
       8  /// `Matrix3x3Protocol` and `Matrix4x4Protocol`.
       9  ///
      10 -/// - Native: bridges via the simd overlay's `init(_ quaternion
         -:)` (which is                                                  
      11 -///   an unlabeled positional initializer on simd_floatNxN; we 
         -re-label it to                                                 
      12 -///   `quaternion:` to match the protocol requirement).        
      10 +/// - Native: bridges via the simd overlay's `init(_ quaternion
         +:)`. For                                                       
      11 +///   `simd_half3x3` specifically the overlay's `simd_matrix3x3
         +(quath)` is                                                    
      12 +///   miscomputed, so we route via `simd_matrix4x4(quaternion)`
         + and slice the                                                 
      13 +///   top-left 3x3 out by hand.                                
      14  /// - Storage/Wrapper: forwards through the Passthrough chain.
      15  struct QuaternionConstructorMacrolet: SIMDMatrixMacrolet {
      16    let descriptor: MatrixDescriptor
     ...
      21      }
      22      switch context.layer {
      23      case .native:
      24 +      if descriptor.producesBuggyHalfThreeRow {                
      25 +        // simd_half3x3 case — route through 4x4 and slice the 
         +top-left 3x3.                                                  
      26 +        return [                                               
      27 +          """                                                  
      28 +          @inlinable                                           
      29 +          public init(quaternion: CompatibleQuaternion) {      
      30 +            let m4 = simd_matrix4x4(quaternion)                
      31 +            self.init(                                         
      32 +              columns: (                                       
      33 +                SIMD3<Scalar>(m4.columns.0.x, m4.columns.0.y, m
         +4.columns.0.z),                                                
      34 +                SIMD3<Scalar>(m4.columns.1.x, m4.columns.1.y, m
         +4.columns.1.z),                                                
      35 +                SIMD3<Scalar>(m4.columns.2.x, m4.columns.2.y, m
         +4.columns.2.z)                                                 
      36 +              )                                                
      37 +            )                                                  
      38 +          }                                                    
      39 +          """                                                  
      40 +        ]                                                      
      41 +      }                                                        
      42        return [
      43          """
      44          @inlinable

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/TransposeMacrolet.swift)
  ⎿  Added 59 lines, removed 3 lines
       7  /// Transpose support.
       8  ///
       9  /// - Square: `transposed() -> Self` and `formTranspose()`. Imp
          lementation uses
      10 -///   the native simd `.transpose` property.                   
      10 +///   the native simd `.transpose` property (except for half-3x
         +3, which                                                       
      11 +///   returns a buggy half-3-row shape and so uses column-wise 
         +pure Swift).                                                   
      12  /// - Non-square: `transposed() -> CompatibleMatrixNxM` where t
          he shape swaps
      12 -///   (no `formTranspose()` because the type changes).         
      13 +///   (no `formTranspose()` because the type changes). For half
         +-precision                                                     
      14 +///   shapes whose transpose result is 3-row, uses pure-Swift f
         +allback.                                                       
      15  struct TransposeMacrolet: SIMDMatrixMacrolet {
      16    let descriptor: MatrixDescriptor
      17  
     ...
      23      }
      24    }
      25  
      26 +  /// True iff transpose produces a half-3-row result (i.e., th
         +e simd routine                                                 
      27 +  /// would be miscomputed).                                   
      28 +  private var transposeIsBuggy: Bool {                         
      29 +    descriptor.representation == .half && descriptor.columnCoun
         +t == 3                                                         
      30 +  }                                                            
      31 +                                                               
      32 +  /// Build the columns-tuple expression for a manual transpose
         +. The result                                                   
      33 +  /// has shape (columnCount=descriptor.rowCount, rowCount=desc
         +riptor.columnCount).                                           
      34 +  /// For result column j (j in 0..<descriptor.rowCount), the c
         +olumn is built                                                 
      35 +  /// from `self.columns.0[j], self.columns.1[j], ..., self.col
         +umns.M-1[j]`                                                   
      36 +  /// where M == descriptor.columnCount.                       
      37 +  private func manualTransposeColumnsTuple(of selfRef: String, 
         +resultColumnVectorType: String) -> String {                    
      38 +    let resultColumnCount = descriptor.rowCount                
      39 +    let M = descriptor.columnCount                             
      40 +    let cols = (0..<resultColumnCount).map { j -> String in    
      41 +      let entries = (0..<M).map { i in "\(selfRef).columns.\(i)
         +[\(j)]" }.joined(separator: ",")                               
      42 +      return "\(resultColumnVectorType)(\(entries))"           
      43 +    }                                                          
      44 +    return "(" + cols.joined(separator: ",") + ")"             
      45 +  }                                                            
      46 +                                                               
      47 +  private var transposeResultColumnVectorType: String {        
      48 +    // The result has columnVector length M (= descriptor.colum
         +nCount), scalar                                                
      49 +    // matches representation.                                 
      50 +    "SIMD\(descriptor.columnCount)<\(descriptor.representation.
         +swiftScalarTypeName)>"                                         
      51 +  }                                                            
      52 +                                                               
      53    private func squareTransposeDeclarations(in context: MatrixLa
          yerContext) -> [DeclSyntax] {
      54      switch context.layer {
      55      case .native:
      56 +      if transposeIsBuggy {                                    
      57 +        let tuple = manualTransposeColumnsTuple(of: "self", res
         +ultColumnVectorType: transposeResultColumnVectorType)          
      58 +        return [                                               
      59 +          """                                                  
      60 +          @inlinable                                           
      61 +          public func transposed() -> Self {                   
      62 +            Self(columns: \(raw: tuple))                       
      63 +          }                                                    
      64 +          """,                                                 
      65 +          """                                                  
      66 +          @inlinable                                           
      67 +          public mutating func formTranspose() {               
      68 +            self = transposed()                                
      69 +          }                                                    
      70 +          """                                                  
      71 +        ]                                                      
      72 +      }                                                        
      73        return [
      74          """
      75          @inlinable
     ...
       99    }
      100  
      101    private func nonSquareTransposeDeclarations(in context: Matr
           ixLayerContext) -> [DeclSyntax] {
       56 -    // Transpose of an MxN is an NxM (swap row and column coun
          -ts).                                                          
      102      let transposeShape = descriptor.transposed
      103      let transposeTypealias = "CompatibleMatrix\(transposeShape
           .columnCount)x\(transposeShape.rowCount)"
      104      switch context.layer {
      105      case .native:
      106 +      if transposeIsBuggy {                                   
      107 +        let tuple = manualTransposeColumnsTuple(of: "self", re
          +sultColumnVectorType: transposeResultColumnVectorType)        
      108 +        return [                                              
      109 +          """                                                 
      110 +          @inlinable                                          
      111 +          public func transposed() -> \(raw: transposeTypealia
          +s) {                                                          
      112 +            \(raw: transposeTypealias)(columns: \(raw: tuple))
      113 +          }                                                   
      114 +          """                                                 
      115 +        ]                                                     
      116 +      }                                                       
      117        return [
      118          """
      119          @inlinable

  Read 1 file (ctrl+o to expand)

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/CrossShapeMultiplicationMa
        crolet.swift)
  ⎿  Added 19 lines
      71    ) -> [DeclSyntax] {
      72      switch context.layer {
      73      case .native:
      74 +      // Result row count is N (= descriptor.rowCount). Buggy i
         +ff half-3-row.                                                 
      75 +      if descriptor.representation == .half && descriptor.rowCo
         +unt == 3 {                                                     
      76 +        // Right-mult pure-Swift: result.columns[k] = sum_{i=0.
         +.<M} self.columns[i] * rhs.columns[k][i]                       
      77 +        let M = descriptor.columnCount                         
      78 +        let resultColumnCount = extractColumnCount(fromTypeName
         +: rhsTypeName, fallback: 2)                                    
      79 +        let colExprs = (0..<resultColumnCount).map { k -> Strin
         +g in                                                           
      80 +          let summands = (0..<M).map { i in "self.columns.\(i) 
         +* rhs.columns.\(k)[\(i)]" }                                    
      81 +          return "(" + summands.joined(separator: " + ") + ")" 
      82 +        }                                                      
      83 +        let tuple = "(" + colExprs.joined(separator: ",") + ")"
      84 +        return [                                               
      85 +          """                                                  
      86 +          @inlinable                                           
      87 +          public func multiplied(onRightBy rhs: \(raw: rhsTypeN
         +ame)) -> \(raw: resultTypeName) {                              
      88 +            \(raw: resultTypeName)(columns: \(raw: tuple))     
      89 +          }                                                    
      90 +          """                                                  
      91 +        ]                                                      
      92 +      }                                                        
      93        return [
      94          """
      95          @inlinable

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/CrossShapeMultiplicationMac
       rolet.swift)
  ⎿  Added 66 lines, removed 16 lines
       9  /// For a matrix of shape (M cols, N rows):
      10  ///
      11  ///   - Right-mult: `self * rhs` where rhs is (X, M) → result (
          X, N).
      12 -///     X ∈ {2,3,4}. When X == M and the result type equals Sel
         -f (square or                                                   
      13 -///     not), we additionally emit `formMultiplication(onRightB
         -y:)`.                                                          
      12 +///     X ∈ {2,3,4}. When the result type equals Self we additi
         +onally emit                                                    
      13 +///     `formMultiplication(onRightBy:)`.                      
      14  ///   - Left-mult:  `lhs * self` where lhs is (N, X) → result (
          M, X).
      15 -///     Symmetric. When X == N (and the result equals Self), we
         - emit                                                          
      16 -///     `formMultiplication(onLeftBy:)`.                       
      15 +///     Symmetric.                                             
      16  ///
      17  /// Square-`Self`-multiplication is handled separately by
      19 -/// `SquareMultiplicationMacrolet`. This macrolet skips those i
         -dentities to                                                   
      20 -/// avoid duplicate declarations.                              
      18 +/// `SquareMultiplicationMacrolet`. This macrolet skips that ca
         +se.                                                            
      19 +///                                                            
      20 +/// For half-precision shapes whose multiplication-result has 3
         + rows the                                                      
      21 +/// simd routines miscompute, so we emit pure-Swift column-wise
         + fallbacks.                                                    
      22  struct CrossShapeMultiplicationMacrolet: SIMDMatrixMacrolet {
      23    let descriptor: MatrixDescriptor
      24  
     ...
      41        let rhsColumnCount = X
      42        let resultRowCount = N
      43        let resultColumnCount = X
      43 -      // Skip the Self*Self square case (handled by SquareMulti
         -plicationMacrolet).                                            
      44        if descriptor.isSquare && X == M { continue }
      45        let isSelfResult = (resultColumnCount == descriptor.colum
          nCount && resultRowCount == descriptor.rowCount)
      46 -      let rhsTypeName = compatibleTypeName(rowCount: rhsRowCoun
         -t, columnCount: rhsColumnCount, in: context)                   
      47 -      let resultTypeName = isSelfResult ? "Self" : compatibleTy
         -peName(rowCount: resultRowCount, columnCount: resultColumnCount
         -, in: context)                                                 
      46 +      let rhsTypeName = compatibleTypeName(rowCount: rhsRowCoun
         +t, columnCount: rhsColumnCount)                                
      47 +      let resultTypeName = isSelfResult ? "Self" : compatibleTy
         +peName(rowCount: resultRowCount, columnCount: resultColumnCount
         +)                                                              
      48 +      // Result is half-3-row iff representation == .half AND r
         +esultRowCount == 3.                                            
      49 +      let isBuggyHalf = (descriptor.representation == .half && 
         +resultRowCount == 3)                                           
      50  
      51        decls.append(contentsOf: rightMultiplicationDecl(
      52          rhsTypeName: rhsTypeName,
      53          resultTypeName: resultTypeName,
      54 +        resultColumnCount: resultColumnCount,                  
      55 +        isBuggyHalf: isBuggyHalf,                              
      56          isSelfResult: isSelfResult,
      57          in: context
      58        ))
     ...
      60        if isSelfResult {
      61          decls.append(contentsOf: formRightMultiplicationDecl(
      62            rhsTypeName: rhsTypeName,
      63 +          isBuggyHalf: isBuggyHalf,                            
      64            in: context
      65          ))
      66        }
     ...
      71    private func rightMultiplicationDecl(
      72      rhsTypeName: String,
      73      resultTypeName: String,
      74 +    resultColumnCount: Int,                                    
      75 +    isBuggyHalf: Bool,                                         
      76      isSelfResult: Bool,
      77      in context: MatrixLayerContext
      78    ) -> [DeclSyntax] {
      79      switch context.layer {
      80      case .native:
      74 -      // Result row count is N (= descriptor.rowCount). Buggy i
         -ff half-3-row.                                                 
      75 -      if descriptor.representation == .half && descriptor.rowCo
         -unt == 3 {                                                     
      76 -        // Right-mult pure-Swift: result.columns[k] = sum_{i=0.
         -.<M} self.columns[i] * rhs.columns[k][i]                       
      81 +      if isBuggyHalf {                                         
      82 +        // result.columns[k] = sum_{i=0..<M} self.columns[i] * 
         +rhs.columns[k][i]                                              
      83          let M = descriptor.columnCount
      78 -        let resultColumnCount = extractColumnCount(fromTypeName
         -: rhsTypeName, fallback: 2)                                    
      84          let colExprs = (0..<resultColumnCount).map { k -> Strin
          g in
      85            let summands = (0..<M).map { i in "self.columns.\(i) 
          * rhs.columns.\(k)[\(i)]" }
      86            return "(" + summands.joined(separator: " + ") + ")"
     ...
      123  
      124    private func formRightMultiplicationDecl(
      125      rhsTypeName: String,
      126 +    isBuggyHalf: Bool,                                        
      127      in context: MatrixLayerContext
      128    ) -> [DeclSyntax] {
      129      switch context.layer {
      130      case .native:
      131 +      if isBuggyHalf {                                        
      132 +        return [                                              
      133 +          """                                                 
      134 +          @inlinable                                          
      135 +          public mutating func formMultiplication(onRightBy rh
          +s: \(raw: rhsTypeName)) {                                     
      136 +            self = multiplied(onRightBy: rhs)                 
      137 +          }                                                   
      138 +          """                                                 
      139 +        ]                                                     
      140 +      }                                                       
      141        return [
      142          """
      143          @inlinable
     ...
      172        let resultColumnCount = M
      173        if descriptor.isSquare && X == N { continue }
      174        let isSelfResult = (resultColumnCount == descriptor.colu
           mnCount && resultRowCount == descriptor.rowCount)
      159 -      let lhsTypeName = compatibleTypeName(rowCount: lhsRowCou
          -nt, columnCount: lhsColumnCount, in: context)                 
      160 -      let resultTypeName = isSelfResult ? "Self" : compatibleT
          -ypeName(rowCount: resultRowCount, columnCount: resultColumnCou
          -nt, in: context)                                              
      175 +      let lhsTypeName = compatibleTypeName(rowCount: lhsRowCou
          +nt, columnCount: lhsColumnCount)                              
      176 +      let resultTypeName = isSelfResult ? "Self" : compatibleT
          +ypeName(rowCount: resultRowCount, columnCount: resultColumnCou
          +nt)                                                           
      177 +      let isBuggyHalf = (descriptor.representation == .half &&
          + resultRowCount == 3)                                         
      178  
      179        decls.append(contentsOf: leftMultiplicationDecl(
      180          lhsTypeName: lhsTypeName,
      181          resultTypeName: resultTypeName,
      182 +        resultColumnCount: resultColumnCount,                 
      183 +        isBuggyHalf: isBuggyHalf,                             
      184          isSelfResult: isSelfResult,
      185          in: context
      186        ))
     ...
      188        if isSelfResult {
      189          decls.append(contentsOf: formLeftMultiplicationDecl(
      190            lhsTypeName: lhsTypeName,
      191 +          isBuggyHalf: isBuggyHalf,                           
      192            in: context
      193          ))
      194        }
     ...
      199    private func leftMultiplicationDecl(
      200      lhsTypeName: String,
      201      resultTypeName: String,
      202 +    resultColumnCount: Int,                                   
      203 +    isBuggyHalf: Bool,                                        
      204      isSelfResult: Bool,
      205      in context: MatrixLayerContext
      206    ) -> [DeclSyntax] {
      207      switch context.layer {
      208      case .native:
      209 +      if isBuggyHalf {                                        
      210 +        // result.columns[k] = sum_{j=0..<N} lhs.columns[j] * 
          +self.columns[k][j]                                            
      211 +        let N = descriptor.rowCount                           
      212 +        let colExprs = (0..<resultColumnCount).map { k -> Stri
          +ng in                                                         
      213 +          let summands = (0..<N).map { j in "lhs.columns.\(j) 
          +* self.columns.\(k)[\(j)]" }                                  
      214 +          return "(" + summands.joined(separator: " + ") + ")"
      215 +        }                                                     
      216 +        let tuple = "(" + colExprs.joined(separator: ",") + ")
          +"                                                             
      217 +        return [                                              
      218 +          """                                                 
      219 +          @inlinable                                          
      220 +          public func multiplied(onLeftBy lhs: \(raw: lhsTypeN
          +ame)) -> \(raw: resultTypeName) {                             
      221 +            \(raw: resultTypeName)(columns: \(raw: tuple))    
      222 +          }                                                   
      223 +          """                                                 
      224 +        ]                                                     
      225 +      }                                                       
      226        return [
      227          """
      228          @inlinable
     ...
      251  
      252    private func formLeftMultiplicationDecl(
      253      lhsTypeName: String,
      254 +    isBuggyHalf: Bool,                                        
      255      in context: MatrixLayerContext
      256    ) -> [DeclSyntax] {
      257      switch context.layer {
      258      case .native:
      259 +      if isBuggyHalf {                                        
      260 +        return [                                              
      261 +          """                                                 
      262 +          @inlinable                                          
      263 +          public mutating func formMultiplication(onLeftBy lhs
          +: \(raw: lhsTypeName)) {                                      
      264 +            self = multiplied(onLeftBy: lhs)                  
      265 +          }                                                   
      266 +          """                                                 
      267 +        ]                                                     
      268 +      }                                                       
      269        return [
      270          """
      271          @inlinable
     ...
      291    /// Resolves the appropriate `CompatibleMatrixCxR` typealias
            name (or `Self`)
      292    /// for a matrix of shape (rowCount, columnCount). Note: the
            typealias name
      293    /// uses Apple's `CxR` form, so we feed (columnCount, rowCou
           nt) in.
      244 -  private func compatibleTypeName(rowCount: Int, columnCount: 
          -Int, in context: MatrixLayerContext) -> String {              
      294 +  private func compatibleTypeName(rowCount: Int, columnCount: 
          +Int) -> String {                                              
      295      if rowCount == descriptor.rowCount && columnCount == descr
           iptor.columnCount {
      296        return "Self"
      297      }

⏺ Let me build the plugin to verify no breakage, then do the Half migration:

⏺ Bash(swift build 2>&1 | tail -20)
  ⎿  [26/43] Compiling HDXLSIMDSupportMacroPlugin StorageBackingMacrolet.sw
     ift
     [27/43] Compiling HDXLSIMDSupportMacroPlugin VectorMultiplicationMacro
     … +18 lines (ctrl+o to expand)

⏺ Plugin compiles. Run tests:

⏺ Bash(swift test 2>&1 | tail -10)
  ⎿  Test Suite 'QuaternionMemoryLayoutTests' passed at 2026-05-14 21:27:23
     .901.
         Executed 3 tests, with 0 failures (0 unexpected) in 0.000 (0.000) sec
     … +12 lines (ctrl+o to expand)


⏺ Tests still pass. Now batch-migrate Half:

⏺ Bash(cd /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDXLSI
      MDSupport/Matrices/NativeConformances/Half/…)
  ⎿  Done

⏺ Bash(swift build 2>&1 | grep -E "error:" | head -30)
  ⎿  error: emit-module command failed with exit code 1 (use -v to see invo
     cation)
     /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDXLSI
     … +56 lines (ctrl+o to expand)
  ⎿  (timeout 10m)

⏺ Bash(git show HEAD:Sources/HDXLSIMDSupport/Matrices/NativeConformances/Half/si
      md_half2x2+Matrix2x2Protocol.swift 2>/dev/null | grep -B1 -A5 "func
      adding\|func subtra…)
  ⎿    @inlinable
       public func negated() -> simd_half2x2 {
         return simd_mul((-1) as Scalar, self)
     … +34 lines (ctrl+o to expand)

⏺ For half-precision the matrix-level Swift operators don't exist. Let me
  broaden the workaround to apply to ALL half shapes, not just 3-row:

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/IR/MatrixDescriptor.swift)
  ⎿  Added 17 lines
       90      representation == .half && rowCount == 3
       91    }
       92  
       93 +  /// True iff the descriptor's representation lacks the matri
          +x-level Swift                                                 
       94 +  /// operators (`+`, `-`, `*`, `*=`, ...) on the simd type.  
       95 +  ///                                                         
       96 +  /// Specifically: `simd_halfNxM` does not have the operator 
          +overloads that                                                
       97 +  /// `simd_floatNxM` and `simd_doubleNxM` have. So for the ha
          +lf representation                                             
       98 +  /// we have to use either the C-level `simd_add` / `simd_sub
          +` / `simd_mul`                                                
       99 +  /// routines (which still misbehave for half-3-row results) 
          +or pure-Swift                                                 
      100 +  /// column-wise composition.                                
      101 +  ///                                                         
      102 +  /// We pick column-wise pure Swift uniformly for the half re
          +presentation:                                                 
      103 +  /// it's correct in every case (including 3-row), it's the s
          +ame Swift                                                     
      104 +  /// vector operations the C routines lower to, and it keeps 
          +the generated                                                 
      105 +  /// source uniform.                                         
      106 +  var usesColumnWiseSwiftFallback: Bool {                     
      107 +    representation == .half                                   
      108 +  }                                                           
      109 +                                                              
      110    // MARK: Compatible matrices
      111  
      112    /// Compatible matrix shape `MxN` (in the same representatio
           n) given an

  Searched for 1 pattern (ctrl+o to expand)

⏺ Bash(git show HEAD:Sources/HDXLSIMDSupport/Matrices/NativeConformances/Half/si
      md_half2x3+Matrix2x3Protocol.swift 2>/dev/null | grep -A6 "func
      transposed" | head -20)
  ⎿    public func transposed() -> simd_half3x2 {
         return simd_transpose(self)
       }
     … +6 lines (ctrl+o to expand)

⏺ Bash(git show HEAD:Sources/HDXLSIMDSupport/Matrices/NativeConformances/Half/si
      md_half2x2+Matrix2x2Protocol.swift 2>/dev/null | grep -A6 "func
      transposed" | head -20)
  ⎿    public func transposed() -> simd_half2x2 {
         return simd_transpose(self)
       }
     … +4 lines (ctrl+o to expand)

⏺ Bash(git show HEAD:Sources/HDXLSIMDSupport/Matrices/NativeConformances/Half/si
      md_half2x2+Matrix2x2Protocol.swift 2>/dev/null | grep -A4
      "determinant\|inverted\|formI…)  ⎿    public var determinant: Scalar {
         get {
           return simd_determinant(self)
     … +34 lines (ctrl+o to expand)

⏺ Bash(git show HEAD:Sources/HDXLSIMDSupport/Matrices/NativeConformances/Half/si
      md_half3x3+Matrix3x3Protocol.swift 2>/dev/null | grep -B1 -A5 "func
      inverted\|func tran…)
  ⎿    // where `c0`/`c1`/`c2` are the columns of M. We can't use
       // `simd_inverse(simd_half3x3)` because the return crosses the broke
     n
     … +16 lines (ctrl+o to expand)

⏺ Bash(git show HEAD:Sources/HDXLSIMDSupport/Matrices/NativeConformances/Half/si
      md_half3x3+Matrix3x3Protocol.swift 2>/dev/null | sed -n '/func
      inverted/,/^  }$/p' | he…)
  ⎿    public func inverted() -> simd_half3x3 {
         let c0 = columns.0
         let c1 = columns.1
     … +14 lines (ctrl+o to expand)

⏺ Bash(git show HEAD:Sources/HDXLSIMDSupport/Matrices/NativeConformances/Half/si
      md_half4x4+Matrix4x4Protocol.swift 2>/dev/null | grep -B1 -A4 "func
      inverted" | head -1…)
  ⎿    @inlinable
       public func inverted() -> simd_half4x4 {
         return simd_inverse(self)
     … +3 lines (ctrl+o to expand)

⏺ Bash(git show HEAD:Sources/HDXLSIMDSupport/Matrices/NativeConformances/Half/si
      md_half2x2+Matrix2x2Protocol.swift 2>/dev/null | grep -B1 -A5
      "multiplied(onLeftBy colu…)
  ⎿    public func negated() -> simd_half2x2 {
         return simd_mul((-1) as Scalar, self)
       }
     … +31 lines (ctrl+o to expand)

⏺ Bash(git show HEAD:Sources/HDXLSIMDSupport/Matrices/NativeConformances/Half/si
      md_half2x2+Matrix2x2Protocol.swift 2>/dev/null | grep -B1 -A5
      "multiplied(onLeftBy colu…)
  ⎿    @inlinable
       public func multiplied(onLeftBy columnVector: ColumnVector) -> RowVe
     ctor {
     … +12 lines (ctrl+o to expand)

⏺ Let me update all macrolets to use the broader half check, then handle special
   cases:

⏺ Bash(cd /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDXLSI
      MDSupportMacroPlugin/Macrolets/ && perl -i -pe
      's/producesBuggyHalfThreeRow/usesColumnW…)
  ⎿  done

⏺ Now update CrossShapeMultiplicationMacrolet's check for all-half (not just
  3-row result):

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/CrossShapeMultiplicationMa
        crolet.swift)
  ⎿  Added 8 lines, removed 2 lines
      46        let rhsTypeName = compatibleTypeName(rowCount: rhsRowCoun
          t, columnCount: rhsColumnCount)
      47        let resultTypeName = isSelfResult ? "Self" : compatibleTy
          peName(rowCount: resultRowCount, columnCount: resultColumnCount
          )
      48        // Result is half-3-row iff representation == .half AND r
          esultRowCount == 3.
      49 -      let isBuggyHalf = (descriptor.representation == .half && 
         -resultRowCount == 3)                                           
      49 +      // For half, the matrix-level Swift operators don't exist
         + at all, so we                                                 
      50 +      // need a column-wise fallback regardless of the result's
         + row count.                                                    
      51 +      let isBuggyHalf = (descriptor.representation == .half)   
      52 +      _ = resultRowCount                                       
      53  
      54        decls.append(contentsOf: rightMultiplicationDecl(
      55          rhsTypeName: rhsTypeName,
     ...
      177        let isSelfResult = (resultColumnCount == descriptor.colu
           mnCount && resultRowCount == descriptor.rowCount)
      178        let lhsTypeName = compatibleTypeName(rowCount: lhsRowCou
           nt, columnCount: lhsColumnCount)
      179        let resultTypeName = isSelfResult ? "Self" : compatibleT
           ypeName(rowCount: resultRowCount, columnCount: resultColumnCou
           nt)
      177 -      let isBuggyHalf = (descriptor.representation == .half &&
          - resultRowCount == 3)                                         
      180 +      // For half, the matrix-level Swift operators don't exis
          +t at all, so we                                               
      181 +      // need a column-wise fallback regardless of the result'
          +s row count.                                                  
      182 +      let isBuggyHalf = (descriptor.representation == .half)  
      183 +      _ = resultRowCount                                      
      184  
      185        decls.append(contentsOf: leftMultiplicationDecl(
      186          lhsTypeName: lhsTypeName,

⏺ Now TransposeMacrolet:

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/TransposeMacrolet.swift)
  ⎿  Added 5 lines, removed 3 lines
      23      }
      24    }
      25  
      26 -  /// True iff transpose produces a half-3-row result (i.e., th
         -e simd routine                                                 
      27 -  /// would be miscomputed).                                   
      26 +  /// True iff transpose needs a column-wise pure-Swift fallbac
         +k. For half                                                    
      27 +  /// representation we always emit the fallback (the Swift sim
         +d overlay                                                      
      28 +  /// doesn't expose `.transpose` on `simd_halfNxM` at all, and
         + for half-3-row                                                
      29 +  /// results the simd_transpose C function is miscomputed).   
      30    private var transposeIsBuggy: Bool {
      29 -    descriptor.representation == .half && descriptor.columnCoun
         -t == 3                                                         
      31 +    descriptor.representation == .half                         
      32    }
      33  
      34    /// Build the columns-tuple expression for a manual transpose
          . The result

⏺ Now DeterminantMacrolet:

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/DeterminantMacrolet.swift)
  ⎿  Added 16 lines, removed 1 line
       5  import SwiftSyntax
       6  
       7  /// `determinant: Scalar` — only emitted for square matrices.
       8 +///                                                            
       9 +/// - Native: float/double simd matrices expose `self.determina
         +nt` via the                                                    
      10 +///   simd overlay. For half there's no overlay property, so we
         + call the                                                      
      11 +///   C-level `simd_determinant(self)` which is a scalar output
         + and                                                           
      12 +///   therefore unaffected by the half-3-row overlay bug.      
      13 +/// - Storage/Wrapper: forwards.                               
      14  struct DeterminantMacrolet: SIMDMatrixMacrolet {
      15    let descriptor: MatrixDescriptor
      16  
     ...
      18      guard descriptor.isSquare else { return [] }
      19      switch context.layer {
      20      case .native:
      15 -      // simd_floatNxM.determinant exists for square matrices. 
      21 +      if descriptor.representation == .half {                  
      22 +        return [                                               
      23 +          """                                                  
      24 +          @inlinable                                           
      25 +          public var determinant: Scalar {                     
      26 +            get { simd_determinant(self) }                     
      27 +          }                                                    
      28 +          """                                                  
      29 +        ]                                                      
      30 +      }                                                        
      31        return []
      32      case .storage, .wrapper:
      33        return [

⏺ Now InversionMacrolet with the half-3x3 adjugate special case:

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/InversionMacrolet.swift)
  ⎿  Added 49 lines
       5  import SwiftSyntax
       6  
       7  /// `inverted() -> Self` / `formInverse()` — only for square ma
          trices.
       8 +///                                                            
       9 +/// - Native float/double: `self.inverse` via the simd overlay.
      10 +/// - Native half-2x2 / half-4x4: `simd_inverse(self)` C functi
         +on.                                                            
      11 +/// - Native half-3x3: pure-Swift adjugate formula using `simd_
         +determinant` +                                                 
      12 +///   `simd_cross`. The C function `simd_inverse(simd_half3x3)`
         + is miscomputed                                                
      13 +///   because its result crosses the broken half-3-row overlay 
         +bridge.                                                        
      14 +/// - Storage / Wrapper: forwards.                             
      15  struct InversionMacrolet: SIMDMatrixMacrolet {
      16    let descriptor: MatrixDescriptor
      17  
     ...
      19      guard descriptor.isSquare else { return [] }
      20      switch context.layer {
      21      case .native:
      22 +      if descriptor.representation == .half && descriptor.rowCo
         +unt == 3 {                                                     
      23 +        // 3x3 inverse via cofactor / adjugate formula.        
      24 +        return [                                               
      25 +          """                                                  
      26 +          @inlinable                                           
      27 +          public func inverted() -> Self {                     
      28 +            let c0 = columns.0                                 
      29 +            let c1 = columns.1                                 
      30 +            let c2 = columns.2                                 
      31 +            let invDet = (1 as Scalar) / simd_determinant(self)
      32 +            let r0 = simd_cross(c1, c2)                        
      33 +            let r1 = simd_cross(c2, c0)                        
      34 +            let r2 = simd_cross(c0, c1)                        
      35 +            return Self(                                       
      36 +              columns: (                                       
      37 +                ColumnVector(r0[0], r1[0], r2[0]) * invDet,    
      38 +                ColumnVector(r0[1], r1[1], r2[1]) * invDet,    
      39 +                ColumnVector(r0[2], r1[2], r2[2]) * invDet     
      40 +              )                                                
      41 +            )                                                  
      42 +          }                                                    
      43 +          """,                                                 
      44 +          """                                                  
      45 +          @inlinable                                           
      46 +          public mutating func formInverse() {                 
      47 +            self = inverted()                                  
      48 +          }                                                    
      49 +          """                                                  
      50 +        ]                                                      
      51 +      }                                                        
      52 +      if descriptor.representation == .half {                  
      53 +        return [                                               
      54 +          """                                                  
      55 +          @inlinable                                           
      56 +          public func inverted() -> Self { simd_inverse(self) }
      57 +          """,                                                 
      58 +          """                                                  
      59 +          @inlinable                                           
      60 +          public mutating func formInverse() { self = simd_inve
         +rse(self) }                                                    
      61 +          """                                                  
      62 +        ]                                                      
      63 +      }                                                        
      64        return [
      65          """
      66          @inlinable

⏺ Now SquareDivisionMacrolet:

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/SquareDivisionMacrolet.swif
       t)
  ⎿  Error writing file

  Read 1 file (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/SquareDivisionMacrolet.swif
       t)
  ⎿  Added 33 lines, removed 4 lines
       4  
       5  import SwiftSyntax
       6  
       7 -/// Square self-division operations from `MatrixNxNProtocol`:  
       7 +/// Square self-division operations from `MatrixNxNProtocol`.  
       8  ///
       9 -///   - `divided(onRightBy rhs:) -> Self`  (≡ `self * rhs.inver
         -se`)                                                           
      10 -///   - `divided(onLeftBy lhs:) -> Self`   (≡ `lhs.inverse * se
         -lf`)                                                           
      11 -///   - `formDivision(onRightBy:)` / `formDivision(onLeftBy:)` 
       9 +/// For half representation we go through the protocol-level   
      10 +/// `multiplied(onRightBy:)` / `inverted()` helpers rather than
         + `*` and                                                       
      11 +/// `.inverse`, because (a) `*` doesn't exist on `simd_halfNxM`
         +, and                                                          
      12 +/// (b) `simd_inverse(simd_half3x3)` is miscomputed.           
      13  struct SquareDivisionMacrolet: SIMDMatrixMacrolet {
      14    let descriptor: MatrixDescriptor
      15  
     ...
      17      guard descriptor.isSquare else { return [] }
      18      switch context.layer {
      19      case .native:
      20 +      if descriptor.representation == .half {                  
      21 +        return [                                               
      22 +          """                                                  
      23 +          @inlinable                                           
      24 +          public func divided(onRightBy rhs: Self) -> Self {   
      25 +            multiplied(onRightBy: rhs.inverted())              
      26 +          }                                                    
      27 +          """,                                                 
      28 +          """                                                  
      29 +          @inlinable                                           
      30 +          public func divided(onLeftBy lhs: Self) -> Self {    
      31 +            multiplied(onLeftBy: lhs.inverted())               
      32 +          }                                                    
      33 +          """,                                                 
      34 +          """                                                  
      35 +          @inlinable                                           
      36 +          public mutating func formDivision(onRightBy rhs: Self
         +) {                                                            
      37 +            self = divided(onRightBy: rhs)                     
      38 +          }                                                    
      39 +          """,                                                 
      40 +          """                                                  
      41 +          @inlinable                                           
      42 +          public mutating func formDivision(onLeftBy lhs: Self)
         + {                                                             
      43 +            self = divided(onLeftBy: lhs)                      
      44 +          }                                                    
      45 +          """                                                  
      46 +        ]                                                      
      47 +      }                                                        
      48        return [
      49          """
      50          @inlinable

⏺ Now VectorMultiplicationMacrolet:

  Read 1 file (ctrl+o to expand)
⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/VectorMultiplicationMacrole
       t.swift)
  ⎿  Added 20 lines, removed 2 lines
       9  ///   - `multiplied(onLeftBy columnVector:) -> RowVector`  (≡ `
          columnVector * self`)
      10  ///   - `multiplied(onRightBy rowVector:) -> ColumnVector` (≡ `
          self * rowVector`)
      11  ///
      12 -/// At the native layer this dispatches to the simd `*` overloa
         -ds. At passthroughValue/                                       
      13 -/// wrapper layers it forwards.                                
      12 +/// Float/Double natives dispatch to the simd `*` overloads. Ha
         +lf natives have                                                
      13 +/// no operator overloads on `simd_halfNxM`, so they use the C-
         +level                                                          
      14 +/// `simd_mul(vec, mat)` / `simd_mul(mat, vec)` (vector-out, un
         +affected by                                                    
      15 +/// the half-3-row overlay bug). Storage/wrapper forwards.     
      16  struct VectorMultiplicationMacrolet: SIMDMatrixMacrolet {
      17    let descriptor: MatrixDescriptor
      18  
      19    func implementationDeclarations(in context: MatrixLayerContex
          t) -> [DeclSyntax] {
      20      switch context.layer {
      21      case .native:
      22 +      if descriptor.representation == .half {                  
      23 +        return [                                               
      24 +          """                                                  
      25 +          @inlinable                                           
      26 +          public func multiplied(onLeftBy columnVector: ColumnV
         +ector) -> RowVector {                                          
      27 +            simd_mul(columnVector, self)                       
      28 +          }                                                    
      29 +          """,                                                 
      30 +          """                                                  
      31 +          @inlinable                                           
      32 +          public func multiplied(onRightBy rowVector: RowVector
         +) -> ColumnVector {                                            
      33 +            simd_mul(self, rowVector)                          
      34 +          }                                                    
      35 +          """                                                  
      36 +        ]                                                      
      37 +      }                                                        
      38        return [
      39          """
      40          @inlinable

⏺ Now build and see what happens:

⏺ Bash(swift build 2>&1 | grep -E "error:" | head -30)
  ⎿  /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDXLSI
     MDSupport/Matrices/NativeConformances/Half/simd_half4x3+Matrix4x3Proto
     col.swift:9:1: error: type 'simd_half4x3' does not conform to protocol
     … +64 lines (ctrl+o to expand)
  ⎿  (timeout 10m)

⏺ Bash(swift build 2>&1 | grep -E "error:" | head -50 | tail -30)
  ⎿  macro expansion @AddStorageMatrixConformance:173:54: error: argument p
     assed to call that takes no arguments
        |    |                                                      `- erro
     … +64 lines (ctrl+o to expand)
  ⎿  (timeout 10m)

⏺ Bash(swift build 2>&1 | grep "error:" | grep -E "@Add(Native|Storage|Wrapper)"
       | head -20)
  ⎿  macro expansion @AddStorageMatrixConformance:173:54: error: argument p
     assed to call that takes no arguments
     macro expansion @AddStorageMatrixConformance:212:43: error: initialize
     … +53 lines (ctrl+o to expand)
  ⎿  (timeout 10m)

⏺ Let me check the CompatibleMatricesMacrolet case for the issue:

  Searched for 1 pattern (ctrl+o to expand)

⏺ Bash(git show HEAD:Sources/HDXLSIMDSupport/Matrices/NativeConformances/Half/si
      md_half3x4+Matrix3x4Protocol.swift 2>/dev/null | grep -B1 -A3
      "init(columns:" | head -2…)
  ⎿      let column = ColumnVector(repeating: scalar)
         self.init(columns: (column, column, column))
       }
     … +8 lines (ctrl+o to expand)

⏺ Found it — the half-3x3 special case in QuaternionConstructorMacrolet is
  firing for half-4x4 too. Let me fix:

  Read 1 file (ctrl+o to expand)

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/QuaternionConstructorMacro
        let.swift)
  ⎿  Added 15 lines, removed 2 lines
      21      }
      22      switch context.layer {
      23      case .native:
      24 -      if descriptor.usesColumnWiseSwiftFallback {              
      25 -        // simd_half3x3 case — route through 4x4 and slice the 
         -top-left 3x3.                                                  
      24 +      // ONLY simd_half3x3 needs the 4x4-and-slice workaround. 
         +simd_half4x4                                                   
      25 +      // is fine — `simd_matrix4x4(quaternion)` works and the 4
         +x4 result                                                      
      26 +      // doesn't cross the broken half-3-row bridge.           
      27 +      if descriptor.representation == .half && descriptor.rowCo
         +unt == 3 {                                                     
      28          return [
      29            """
      30            @inlinable
     ...
      41            """
      42          ]
      43        }
      44 +      if descriptor.representation == .half {                  
      45 +        // simd_half4x4: simd_matrix4x4 returns the right shape
         + directly.                                                     
      46 +        return [                                               
      47 +          """                                                  
      48 +          @inlinable                                           
      49 +          public init(quaternion: CompatibleQuaternion) {      
      50 +            self = simd_matrix4x4(quaternion)                  
      51 +          }                                                    
      52 +          """                                                  
      53 +        ]                                                      
      54 +      }                                                        
      55        return [
      56          """
      57          @inlinable

⏺ Bash(swift build 2>&1 | grep -E "error:" | head -20)
  ⎿  /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDXLSI
     MDSupport/Matrices/NativeConformances/Half/simd_half4x3+Matrix4x3Proto
     col.swift:9:1: error: type 'simd_half4x3' does not conform to protocol
     … +42 lines (ctrl+o to expand)
  ⎿  (timeout 10m)

⏺ Bash(swift build 2>&1 | grep -E "error:" | grep "macro expansion\|in
      reasonable time" | head -20)
  ⎿  macro expansion @AddStorageMatrixConformance:169:54: error: argument p
     assed to call that takes no arguments
     macro expansion @AddStorageMatrixConformance:208:8: error: failed to p
     … +45 lines (ctrl+o to expand)
  ⎿  (timeout 10m)

⏺ Let me isolate half2x2 errors:

⏺ Bash(swift build 2>&1 | grep -A1 "simd_half2x2+" | head -20)
  ⎿  /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDXLSI
     MDSupport/Matrices/NativeConformances/Half/simd_half2x2+Matrix2x2Proto
     col.swift:9:1: error: type 'simd_half2x2' does not conform to protocol
     … +22 lines (ctrl+o to expand)
  ⎿  (timeout 10m)

⏺ Bash(swift build 2>&1 | sed -n '/simd_half2x2.*does not
      conform/,/simd_half2x3/p' | head -100)
  ⎿  /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDXLSI
     MDSupport/Matrices/NativeConformances/Half/simd_half2x2+Matrix2x2Proto
     col.swift:9:1: error: type 'simd_half2x2' does not conform to protocol
     … +95 lines (ctrl+o to expand)
  ⎿  (timeout 10m)

⏺ Half needs explicit init(diagonal:) and init(_:_:) since the overlay doesn't
  expose them. Let me update InitializationMacrolet:

  Read 1 file (ctrl+o to expand)

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/InitializationMacrolet.swi
        ft)
  ⎿  Added 27 lines, removed 1 line
      102    private func diagonalInit(in context: MatrixLayerContext) ->
            [DeclSyntax] {
      103      switch context.layer {
      104      case .native:
      105 -      // simd_floatNxM already has init(diagonal:); don't rede
          -clare.                                                        
      105 +      if descriptor.representation == .half {                 
      106 +        // simd_halfNxM doesn't expose init(diagonal:) via the
          + overlay, so                                                  
      107 +        // we build it explicitly: zero columns with the appro
          +priate diagonal                                               
      108 +        // entry set on each.                                 
      109 +        let rowCount = descriptor.rowCount                    
      110 +        let columnCount = descriptor.columnCount              
      111 +        let diagonalLength = Swift.min(rowCount, columnCount) 
      112 +        let columns = (0..<columnCount).map { c -> String in  
      113 +          let entries = (0..<rowCount).map { r -> String in   
      114 +            if c == r && c < diagonalLength {                 
      115 +              return "diagonal[\(c)]"                         
      116 +            }                                                 
      117 +            return "0"                                        
      118 +          }                                                   
      119 +          return "ColumnVector(\(entries.joined(separator: ","
          +)))"                                                          
      120 +        }                                                     
      121 +        let tuple = "(" + columns.joined(separator: ",") + ")"
      122 +        return [                                              
      123 +          """                                                 
      124 +          @inlinable                                          
      125 +          public init(diagonal: DiagonalVector) {             
      126 +            self.init(columns: \(raw: tuple))                 
      127 +          }                                                   
      128 +          """                                                 
      129 +        ]                                                     
      130 +      }                                                       
      131 +      // simd_floatNxM / simd_doubleNxM already have init(diag
          +onal:).                                                       
      132        return []
      133      case .storage, .wrapper:
      134        guard let wrapped = context.wrappedTypeName else { retur
           n [] }

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/InitializationMacrolet.swi
        ft)
  ⎿  Added 17 lines, removed 1 line
      294    private func positionalColumnsInit(in context: MatrixLayerCo
           ntext) -> [DeclSyntax] {
      295      switch context.layer {
      296      case .native:
      297 -      // simd_floatNxM already has positional column initializ
          -ers via the overlay.                                          
      297 +      if descriptor.representation == .half {                 
      298 +        // simd_halfNxM doesn't expose the positional column-v
          +ector                                                         
      299 +        // initializer; emit our own that routes through init(
          +columns:).                                                    
      300 +        let params = (0..<descriptor.columnCount)             
      301 +          .map { "_ c\($0): ColumnVector" }                   
      302 +          .joined(separator: ", ")                            
      303 +        let tuple = "(" + (0..<descriptor.columnCount).map { "
          +c\($0)" }.joined(separator: ",") + ")"                        
      304 +        return [                                              
      305 +          """                                                 
      306 +          @inlinable                                          
      307 +          public init(\(raw: params)) {                       
      308 +            self.init(columns: \(raw: tuple))                 
      309 +          }                                                   
      310 +          """                                                 
      311 +        ]                                                     
      312 +      }                                                       
      313 +      // simd_floatNxM / simd_doubleNxM already have positiona
          +l column initializers.                                        
      314        return []
      315      case .storage, .wrapper:
      316        guard let wrapped = context.wrappedTypeName else { retur
           n [] }

⏺ Bash(swift build 2>&1 | grep -E "error:" | head -30)
  ⎿  error: emit-module command failed with exit code 1 (use -v to see invo
     cation)
     error: compile command failed due to signal 11 (use -v to see invocati
     … +69 lines (ctrl+o to expand)
  ⎿  (timeout 10m)
⏺ Bash(git show HEAD:Sources/HDXLSIMDSupport/Matrices/NativeConformances/Half/si
      md_half3x3+Matrix3x3Protocol.swift 2>/dev/null | sed -n
      '/multiplied(onRightBy rhs: sim…)
  ⎿    public func multiplied(onRightBy rhs: simd_half3x3) -> simd_half3x3
     {
         let s0 = columns.0
     … +13 lines (ctrl+o to expand)

⏺ Let me restructure the half mult code to hoist column refs into lets:

  Read 1 file (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/SquareMultiplicationMacrole
       t.swift)
  ⎿  Added 19 lines, removed 13 lines
      11  ///   - `formMultiplication(onRightBy:)`           (≡ `self *= 
          rhs`)
      12  ///   - `formMultiplication(onLeftBy:)`            (≡ `self = l
          hs * self`)
      13  ///
      14 -/// Half-3-row (i.e. half-3x3) uses pure Swift column-wise mult
         -iplication.                                                    
      14 +/// Half representation uses pure-Swift column-wise multiplicat
         +ion. Each                                                      
      15 +/// output column hoists the per-input-column references into l
         +ocal `let`s                                                    
      16 +/// before summing, otherwise the type-checker chokes on the la
         +rge nested                                                     
      17 +/// expression.                                                
      18  struct SquareMultiplicationMacrolet: SIMDMatrixMacrolet {
      19    let descriptor: MatrixDescriptor
      20  
     ...
      23      switch context.layer {
      24      case .native:
      25        if descriptor.usesColumnWiseSwiftFallback {
      23 -        // Pure-Swift matmul: column k of (self * rhs) is `sum_
         -i self.columns[i] * rhs.columns[k][i]`.                        
      26          let dim = descriptor.columnCount  // == rowCount for sq
          uare
      25 -        let buildColumnExpr: (String, String) -> String = { sel
         -fRef, rhsRef in                                                
      26 -          // For each output column k, sum self.columns[i] * rh
         -s.columns[k][i] for i in 0..<dim                               
      27 -          let cols = (0..<dim).map { k -> String in            
      28 -            let summands = (0..<dim).map { i in "\(selfRef).col
         -umns.\(i) * \(rhsRef).columns.\(k)[\(i)]" }                    
      29 -            return "(" + summands.joined(separator: " + ") + ")
         -"                                                              
      30 -          }                                                    
      31 -          return "(" + cols.joined(separator: ",") + ")"       
      27 +        let selfLets = (0..<dim).map { i in "let s\(i) = self.c
         +olumns.\(i)" }.joined(separator: "\n  ")                       
      28 +        let rightCols = (0..<dim).map { k -> String in         
      29 +          let summands = (0..<dim).map { i in "s\(i) * rhs.colu
         +mns.\(k)[\(i)]" }                                              
      30 +          return summands.joined(separator: " + ")             
      31          }
      33 -        let rightMul = buildColumnExpr("self", "rhs")          
      34 -        let leftMul = buildColumnExpr("lhs", "self")           
      32 +        let rightTuple = "(" + rightCols.joined(separator: ", "
         +) + ")"                                                        
      33 +        let lhsLets = (0..<dim).map { i in "let l\(i) = lhs.col
         +umns.\(i)" }.joined(separator: "\n  ")                         
      34 +        let leftCols = (0..<dim).map { k -> String in          
      35 +          let summands = (0..<dim).map { i in "l\(i) * self.col
         +umns.\(k)[\(i)]" }                                             
      36 +          return summands.joined(separator: " + ")             
      37 +        }                                                      
      38 +        let leftTuple = "(" + leftCols.joined(separator: ", ") 
         ++ ")"                                                          
      39          return [
      40            """
      41            @inlinable
      42            public func multiplied(onRightBy rhs: Self) -> Self {
      39 -            Self(columns: \(raw: rightMul))                    
      43 +            \(raw: selfLets)                                   
      44 +            return Self(columns: \(raw: rightTuple))           
      45            }
      46            """,
      47            """
      48            @inlinable
      49            public func multiplied(onLeftBy lhs: Self) -> Self {
      45 -            Self(columns: \(raw: leftMul))                     
      50 +            \(raw: lhsLets)                                    
      51 +            return Self(columns: \(raw: leftTuple))            
      52            }
      53            """,
      54            """

⏺ Similarly, restructure CrossShapeMultiplicationMacrolet:

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/CrossShapeMultiplicationMa
        crolet.swift)
  ⎿  Added 8 lines, removed 4 lines
       83      case .native:
       84        if isBuggyHalf {
       85          // result.columns[k] = sum_{i=0..<M} self.columns[i] *
            rhs.columns[k][i]
       86 +        // Hoist `let s_i = self.columns.i` first so the type 
          +checker can                                                   
       87 +        // resolve the sum without blowing up on large M.     
       88          let M = descriptor.columnCount
       89 +        let selfLets = (0..<M).map { i in "let s\(i) = self.co
          +lumns.\(i)" }.joined(separator: "\n  ")                       
       90          let colExprs = (0..<resultColumnCount).map { k -> Stri
           ng in
       88 -          let summands = (0..<M).map { i in "self.columns.\(i)
          - * rhs.columns.\(k)[\(i)]" }                                  
       89 -          return "(" + summands.joined(separator: " + ") + ")"
       91 +          let summands = (0..<M).map { i in "s\(i) * rhs.colum
          +ns.\(k)[\(i)]" }                                              
       92 +          return summands.joined(separator: " + ")            
       93          }
       91 -        let tuple = "(" + colExprs.joined(separator: ",") + ")
          -"                                                             
       94 +        let tuple = "(" + colExprs.joined(separator: ", ") + "
          +)"                                                            
       95          return [
       96            """
       97            @inlinable
       98            public func multiplied(onRightBy rhs: \(raw: rhsType
           Name)) -> \(raw: resultTypeName) {
       96 -            \(raw: resultTypeName)(columns: \(raw: tuple))    
       99 +            \(raw: selfLets)                                  
      100 +            return \(raw: resultTypeName)(columns: \(raw: tupl
          +e))                                                           
      101            }
      102            """
      103          ]

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/CrossShapeMultiplicationMa
        crolet.swift)
  ⎿  Added 6 lines, removed 4 lines
      219        if isBuggyHalf {
      220          // result.columns[k] = sum_{j=0..<N} lhs.columns[j] * 
           self.columns[k][j]
      221          let N = descriptor.rowCount
      222 +        let lhsLets = (0..<N).map { j in "let l\(j) = lhs.colu
          +mns.\(j)" }.joined(separator: "\n  ")                         
      223          let colExprs = (0..<resultColumnCount).map { k -> Stri
           ng in
      223 -          let summands = (0..<N).map { j in "lhs.columns.\(j) 
          -* self.columns.\(k)[\(j)]" }                                  
      224 -          return "(" + summands.joined(separator: " + ") + ")"
      224 +          let summands = (0..<N).map { j in "l\(j) * self.colu
          +mns.\(k)[\(j)]" }                                             
      225 +          return summands.joined(separator: " + ")            
      226          }
      226 -        let tuple = "(" + colExprs.joined(separator: ",") + ")
          -"                                                             
      227 +        let tuple = "(" + colExprs.joined(separator: ", ") + "
          +)"                                                            
      228          return [
      229            """
      230            @inlinable
      231            public func multiplied(onLeftBy lhs: \(raw: lhsTypeN
           ame)) -> \(raw: resultTypeName) {
      231 -            \(raw: resultTypeName)(columns: \(raw: tuple))    
      232 +            \(raw: lhsLets)                                   
      233 +            return \(raw: resultTypeName)(columns: \(raw: tupl
          +e))                                                           
      234            }
      235            """
      236          ]

⏺ Bash(swift build 2>&1 | grep -E "error:" | head -30)
  ⎿  error: compile command failed due to signal 11 (use -v to see invocati
     on)
  ⎿  (timeout 10m)

⏺ Bash(swift build 2>&1 | tail -30)
  ⎿  5. While silgen emitFunction SIL function "@$sSo12simd_half4x4a15HDXLSI
     MDSupportE10multiplied9onRightByA2B_tF".
      for 'multiplied(onRightBy:)' (at @__swiftmacro_15HDXLSIMDSupport1_26A
     … +61 lines (ctrl+o to expand)

  ⎿  (timeout 10m)

⏺ Bash(git show HEAD:Sources/HDXLSIMDSupport/Matrices/NativeConformances/Half/si
      md_half4x4+Matrix4x4Protocol.swift 2>/dev/null | grep -B1 -A12
      "multiplied(onRightBy rh…)
  ⎿    @inlinable
       public func multiplied(onRightBy rhs: simd_half4x4) -> simd_half4x4
     {
     … +13 lines (ctrl+o to expand)

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/SquareMultiplicationMacrol
        et.swift)
  ⎿  Added 25 lines, removed 1 line
      22      guard descriptor.isSquare else { return [] }
      23      switch context.layer {
      24      case .native:
      25 -      if descriptor.usesColumnWiseSwiftFallback {              
      25 +      // half-2x2 / half-4x4: use `simd_mul` (C-level, works fo
         +r non-3-row).                                                  
      26 +      // half-3x3: use pure-Swift column-wise (overlay's matrix
         +-level routines                                                
      27 +      // miscompute half-3-row results).                       
      28 +      // float / double: use `*` (operator overload from the ov
         +erlay).                                                        
      29 +      if descriptor.representation == .half && descriptor.rowCo
         +unt != 3 {                                                     
      30 +        return [                                               
      31 +          """                                                  
      32 +          @inlinable                                           
      33 +          public func multiplied(onRightBy rhs: Self) -> Self {
         + simd_mul(self, rhs) }                                         
      34 +          """,                                                 
      35 +          """                                                  
      36 +          @inlinable                                           
      37 +          public func multiplied(onLeftBy lhs: Self) -> Self { 
         +simd_mul(lhs, self) }                                          
      38 +          """,                                                 
      39 +          """                                                  
      40 +          @inlinable                                           
      41 +          public mutating func formMultiplication(onRightBy rhs
         +: Self) { self = simd_mul(self, rhs) }                         
      42 +          """,                                                 
      43 +          """                                                  
      44 +          @inlinable                                           
      45 +          public mutating func formMultiplication(onLeftBy lhs:
         + Self) { self = simd_mul(lhs, self) }                          
      46 +          """                                                  
      47 +        ]                                                      
      48 +      }                                                        
      49 +      if descriptor.producesBuggyHalfThreeRow {                
      50          let dim = descriptor.columnCount  // == rowCount for sq
          uare
      51          let selfLets = (0..<dim).map { i in "let s\(i) = self.c
          olumns.\(i)" }.joined(separator: "\n  ")
      52          let rightCols = (0..<dim).map { k -> String in

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/CrossShapeMultiplicationMa
        crolet.swift)
  ⎿  Error editing file

  Read 1 file (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/CrossShapeMultiplicationMac
       rolet.swift)
  ⎿  Added 112 lines, removed 59 lines
      17  /// Square-`Self`-multiplication is handled separately by
      18  /// `SquareMultiplicationMacrolet`. This macrolet skips that ca
          se.
      19  ///
      20 -/// For half-precision shapes whose multiplication-result has 3
         - rows the                                                      
      21 -/// simd routines miscompute, so we emit pure-Swift column-wise
         - fallbacks.                                                    
      20 +/// Native dispatch strategy:                                  
      21 +///   - float / double: use the `*` operator from the simd over
         +lay.                                                           
      22 +///   - half, result is NOT 3-row: `simd_mul(a, b)` C function.
      23 +///   - half, result IS 3-row: column-wise pure Swift (the C fu
         +nction                                                         
      24 +///     miscomputes half-3-row results).                       
      25  struct CrossShapeMultiplicationMacrolet: SIMDMatrixMacrolet {
      26    let descriptor: MatrixDescriptor
      27  
      28 +  enum NativeStrategy {                                        
      29 +    case swiftOperator                                         
      30 +    case simdMul                                               
      31 +    case columnWise                                            
      32 +  }                                                            
      33 +                                                               
      34    func implementationDeclarations(in context: MatrixLayerContex
          t) -> [DeclSyntax] {
      35      var result: [DeclSyntax] = []
      36      result.append(contentsOf: rightMultiplications(in: context)
          )
     ...
      38      return result
      39    }
      40  
      41 +  // MARK: - Strategy selection                                
      42 +                                                               
      43 +  private func strategy(forResultRowCount resultRowCount: Int) 
         +-> NativeStrategy {                                            
      44 +    switch descriptor.representation {                         
      45 +    case .float, .double:                                      
      46 +      return .swiftOperator                                    
      47 +    case .half:                                                
      48 +      return resultRowCount == 3 ? .columnWise : .simdMul      
      49 +    }                                                          
      50 +  }                                                            
      51 +                                                               
      52    // MARK: - Right multiplications
      53  
      54    /// `self * rhs` for each compatible rhs shape (X, M).
     ...
      65        let isSelfResult = (resultColumnCount == descriptor.colum
          nCount && resultRowCount == descriptor.rowCount)
      66        let rhsTypeName = compatibleTypeName(rowCount: rhsRowCoun
          t, columnCount: rhsColumnCount)
      67        let resultTypeName = isSelfResult ? "Self" : compatibleTy
          peName(rowCount: resultRowCount, columnCount: resultColumnCount
          )
      48 -      // Result is half-3-row iff representation == .half AND r
         -esultRowCount == 3.                                            
      49 -      // For half, the matrix-level Swift operators don't exist
         - at all, so we                                                 
      50 -      // need a column-wise fallback regardless of the result's
         - row count.                                                    
      51 -      let isBuggyHalf = (descriptor.representation == .half)   
      52 -      _ = resultRowCount                                       
      68 +      let nativeStrategy = strategy(forResultRowCount: resultRo
         +wCount)                                                        
      69  
      70        decls.append(contentsOf: rightMultiplicationDecl(
      71          rhsTypeName: rhsTypeName,
      72          resultTypeName: resultTypeName,
      73          resultColumnCount: resultColumnCount,
      58 -        isBuggyHalf: isBuggyHalf,                              
      74 +        nativeStrategy: nativeStrategy,                        
      75          isSelfResult: isSelfResult,
      76          in: context
      77        ))
     ...
      79        if isSelfResult {
      80          decls.append(contentsOf: formRightMultiplicationDecl(
      81            rhsTypeName: rhsTypeName,
      66 -          isBuggyHalf: isBuggyHalf,                            
      82 +          nativeStrategy: nativeStrategy,                      
      83            in: context
      84          ))
      85        }
     ...
       91      rhsTypeName: String,
       92      resultTypeName: String,
       93      resultColumnCount: Int,
       78 -    isBuggyHalf: Bool,                                        
       94 +    nativeStrategy: NativeStrategy,                           
       95      isSelfResult: Bool,
       96      in context: MatrixLayerContext
       97    ) -> [DeclSyntax] {
       98      switch context.layer {
       99      case .native:
       84 -      if isBuggyHalf {                                        
       85 -        // result.columns[k] = sum_{i=0..<M} self.columns[i] *
          - rhs.columns[k][i]                                            
       86 -        // Hoist `let s_i = self.columns.i` first so the type 
          -checker can                                                   
       87 -        // resolve the sum without blowing up on large M.     
      100 +      switch nativeStrategy {                                 
      101 +      case .swiftOperator:                                    
      102 +        return [                                              
      103 +          """                                                 
      104 +          @inlinable                                          
      105 +          public func multiplied(onRightBy rhs: \(raw: rhsType
          +Name)) -> \(raw: resultTypeName) {                            
      106 +            self * rhs                                        
      107 +          }                                                   
      108 +          """                                                 
      109 +        ]                                                     
      110 +      case .simdMul:                                          
      111 +        return [                                              
      112 +          """                                                 
      113 +          @inlinable                                          
      114 +          public func multiplied(onRightBy rhs: \(raw: rhsType
          +Name)) -> \(raw: resultTypeName) {                            
      115 +            simd_mul(self, rhs)                               
      116 +          }                                                   
      117 +          """                                                 
      118 +        ]                                                     
      119 +      case .columnWise:                                       
      120          let M = descriptor.columnCount
      121          let selfLets = (0..<M).map { i in "let s\(i) = self.co
           lumns.\(i)" }.joined(separator: "\n  ")
      122          let colExprs = (0..<resultColumnCount).map { k -> Stri
           ng in
     ...
      134            """
      135          ]
      136        }
      105 -      return [                                                
      106 -        """                                                   
      107 -        @inlinable                                            
      108 -        public func multiplied(onRightBy rhs: \(raw: rhsTypeNa
          -me)) -> \(raw: resultTypeName) {                              
      109 -          self * rhs                                          
      110 -        }                                                     
      111 -        """                                                   
      112 -      ]                                                       
      137      case .storage, .wrapper:
      138        let wrap: String
      139        if isSelfResult {
     ...
      154  
      155    private func formRightMultiplicationDecl(
      156      rhsTypeName: String,
      133 -    isBuggyHalf: Bool,                                        
      157 +    nativeStrategy: NativeStrategy,                           
      158      in context: MatrixLayerContext
      159    ) -> [DeclSyntax] {
      160      switch context.layer {
      161      case .native:
      138 -      if isBuggyHalf {                                        
      162 +      switch nativeStrategy {                                 
      163 +      case .swiftOperator:                                    
      164          return [
      165            """
      166            @inlinable
      167            public mutating func formMultiplication(onRightBy rh
           s: \(raw: rhsTypeName)) {
      168 +            self = self * rhs                                 
      169 +          }                                                   
      170 +          """                                                 
      171 +        ]                                                     
      172 +      case .simdMul:                                          
      173 +        return [                                              
      174 +          """                                                 
      175 +          @inlinable                                          
      176 +          public mutating func formMultiplication(onRightBy rh
          +s: \(raw: rhsTypeName)) {                                     
      177 +            self = simd_mul(self, rhs)                        
      178 +          }                                                   
      179 +          """                                                 
      180 +        ]                                                     
      181 +      case .columnWise:                                       
      182 +        return [                                              
      183 +          """                                                 
      184 +          @inlinable                                          
      185 +          public mutating func formMultiplication(onRightBy rh
          +s: \(raw: rhsTypeName)) {                                     
      186              self = multiplied(onRightBy: rhs)
      187            }
      188            """
      189          ]
      190        }
      148 -      return [                                                
      149 -        """                                                   
      150 -        @inlinable                                            
      151 -        public mutating func formMultiplication(onRightBy rhs:
          - \(raw: rhsTypeName)) {                                       
      152 -          self = self * rhs                                   
      153 -        }                                                     
      154 -        """                                                   
      155 -      ]                                                       
      191      case .storage, .wrapper:
      192        return [
      193          """
     ...
      216        let isSelfResult = (resultColumnCount == descriptor.colu
           mnCount && resultRowCount == descriptor.rowCount)
      217        let lhsTypeName = compatibleTypeName(rowCount: lhsRowCou
           nt, columnCount: lhsColumnCount)
      218        let resultTypeName = isSelfResult ? "Self" : compatibleT
           ypeName(rowCount: resultRowCount, columnCount: resultColumnCou
           nt)
      184 -      // For half, the matrix-level Swift operators don't exis
          -t at all, so we                                               
      185 -      // need a column-wise fallback regardless of the result'
          -s row count.                                                  
      186 -      let isBuggyHalf = (descriptor.representation == .half)  
      187 -      _ = resultRowCount                                      
      219 +      let nativeStrategy = strategy(forResultRowCount: resultR
          +owCount)                                                      
      220  
      221        decls.append(contentsOf: leftMultiplicationDecl(
      222          lhsTypeName: lhsTypeName,
      223          resultTypeName: resultTypeName,
      224          resultColumnCount: resultColumnCount,
      193 -        isBuggyHalf: isBuggyHalf,                             
      225 +        nativeStrategy: nativeStrategy,                       
      226          isSelfResult: isSelfResult,
      227          in: context
      228        ))
     ...
      230        if isSelfResult {
      231          decls.append(contentsOf: formLeftMultiplicationDecl(
      232            lhsTypeName: lhsTypeName,
      201 -          isBuggyHalf: isBuggyHalf,                           
      233 +          nativeStrategy: nativeStrategy,                     
      234            in: context
      235          ))
      236        }
     ...
      242      lhsTypeName: String,
      243      resultTypeName: String,
      244      resultColumnCount: Int,
      213 -    isBuggyHalf: Bool,                                        
      245 +    nativeStrategy: NativeStrategy,                           
      246      isSelfResult: Bool,
      247      in context: MatrixLayerContext
      248    ) -> [DeclSyntax] {
      249      switch context.layer {
      250      case .native:
      219 -      if isBuggyHalf {                                        
      220 -        // result.columns[k] = sum_{j=0..<N} lhs.columns[j] * 
          -self.columns[k][j]                                            
      251 +      switch nativeStrategy {                                 
      252 +      case .swiftOperator:                                    
      253 +        return [                                              
      254 +          """                                                 
      255 +          @inlinable                                          
      256 +          public func multiplied(onLeftBy lhs: \(raw: lhsTypeN
          +ame)) -> \(raw: resultTypeName) {                             
      257 +            lhs * self                                        
      258 +          }                                                   
      259 +          """                                                 
      260 +        ]                                                     
      261 +      case .simdMul:                                          
      262 +        return [                                              
      263 +          """                                                 
      264 +          @inlinable                                          
      265 +          public func multiplied(onLeftBy lhs: \(raw: lhsTypeN
          +ame)) -> \(raw: resultTypeName) {                             
      266 +            simd_mul(lhs, self)                               
      267 +          }                                                   
      268 +          """                                                 
      269 +        ]                                                     
      270 +      case .columnWise:                                       
      271          let N = descriptor.rowCount
      272          let lhsLets = (0..<N).map { j in "let l\(j) = lhs.colu
           mns.\(j)" }.joined(separator: "\n  ")
      273          let colExprs = (0..<resultColumnCount).map { k -> Stri
           ng in
     ...
      285            """
      286          ]
      287        }
      238 -      return [                                                
      239 -        """                                                   
      240 -        @inlinable                                            
      241 -        public func multiplied(onLeftBy lhs: \(raw: lhsTypeNam
          -e)) -> \(raw: resultTypeName) {                               
      242 -          lhs * self                                          
      243 -        }                                                     
      244 -        """                                                   
      245 -      ]                                                       
      288      case .storage, .wrapper:
      289        let wrap: String
      290        if isSelfResult {
     ...
      305  
      306    private func formLeftMultiplicationDecl(
      307      lhsTypeName: String,
      266 -    isBuggyHalf: Bool,                                        
      308 +    nativeStrategy: NativeStrategy,                           
      309      in context: MatrixLayerContext
      310    ) -> [DeclSyntax] {
      311      switch context.layer {
      312      case .native:
      271 -      if isBuggyHalf {                                        
      313 +      switch nativeStrategy {                                 
      314 +      case .swiftOperator:                                    
      315          return [
      316            """
      317            @inlinable
      318            public mutating func formMultiplication(onLeftBy lhs
           : \(raw: lhsTypeName)) {
      319 +            self = lhs * self                                 
      320 +          }                                                   
      321 +          """                                                 
      322 +        ]                                                     
      323 +      case .simdMul:                                          
      324 +        return [                                              
      325 +          """                                                 
      326 +          @inlinable                                          
      327 +          public mutating func formMultiplication(onLeftBy lhs
          +: \(raw: lhsTypeName)) {                                      
      328 +            self = simd_mul(lhs, self)                        
      329 +          }                                                   
      330 +          """                                                 
      331 +        ]                                                     
      332 +      case .columnWise:                                       
      333 +        return [                                              
      334 +          """                                                 
      335 +          @inlinable                                          
      336 +          public mutating func formMultiplication(onLeftBy lhs
          +: \(raw: lhsTypeName)) {                                      
      337              self = multiplied(onLeftBy: lhs)
      338            }
      339            """
      340          ]
      341        }
      281 -      return [                                                
      282 -        """                                                   
      283 -        @inlinable                                            
      284 -        public mutating func formMultiplication(onLeftBy lhs: 
          -\(raw: lhsTypeName)) {                                        
      285 -          self = lhs * self                                   
      286 -        }                                                     
      287 -        """                                                   
      288 -      ]                                                       
      342      case .storage, .wrapper:
      343        return [
      344          """

⏺ Bash(swift build 2>&1 | grep -E "error:" | head -30)
  ⎿  macro expansion @AddNativeMatrixConformance:496:10: error: the compile
     r is unable to type-check this expression in reasonable time; try brea
     king up the expression into distinct sub-expressions
     … +74 lines (ctrl+o to expand)
  ⎿  (timeout 10m)

⏺ Let me restructure to use explicit let col_k: ColumnVector annotations:

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/CrossShapeMultiplicationMa
        crolet.swift)
  ⎿  Added 16 lines, removed 4 lines
      118          ]
      119        case .columnWise:
      120          let M = descriptor.columnCount
      121 -        let selfLets = (0..<M).map { i in "let s\(i) = self.co
          -lumns.\(i)" }.joined(separator: "\n  ")                       
      122 -        let colExprs = (0..<resultColumnCount).map { k -> Stri
          -ng in                                                         
      121 +        // Hoist `self.columns.i` into typed locals, then buil
          +d each output                                                 
      122 +        // column as a separately-typed `let`. Two-stage hoist
          +ing prevents                                                  
      123 +        // the type checker from blowing up on long sums.     
      124 +        let selfLets = (0..<M).map { i in "let s\(i): ColumnVe
          +ctor = self.columns.\(i)" }.joined(separator: "\n  ")         
      125 +        let resultCT = resultColumnVectorType(forResultRowCoun
          +t: descriptor.rowCount)                                       
      126 +        let colDecls: [String] = (0..<resultColumnCount).map {
          + k in                                                         
      127            let summands = (0..<M).map { i in "s\(i) * rhs.colum
           ns.\(k)[\(i)]" }
      124 -          return summands.joined(separator: " + ")            
      128 +          return "let col\(k): \(resultCT) = \(summands.joined
          +(separator: " + "))"                                          
      129          }
      126 -        let tuple = "(" + colExprs.joined(separator: ", ") + "
          -)"                                                            
      130 +        let tuple = "(" + (0..<resultColumnCount).map { "col\(
          +$0)" }.joined(separator: ", ") + ")"                          
      131          return [
      132            """
      133            @inlinable
      134            public func multiplied(onRightBy rhs: \(raw: rhsType
           Name)) -> \(raw: resultTypeName) {
      135              \(raw: selfLets)
      136 +            \(raw: colDecls.joined(separator: "\n  "))        
      137              return \(raw: resultTypeName)(columns: \(raw: tupl
           e))
      138            }
      139            """
     ...
      157      }
      158    }
      159  
      160 +  /// Result column-vector spelled out as `SIMD<resultRowCount
          +><scalar>` —                                                  
      161 +  /// for half-3-row results this is `SIMD3<Float16>`; for oth
          +er half                                                       
      162 +  /// shapes the column-wise path isn't taken anyway.         
      163 +  private func resultColumnVectorType(forResultRowCount result
          +RowCount: Int) -> String {                                    
      164 +    "SIMD\(resultRowCount)<\(descriptor.representation.swiftSc
          +alarTypeName)>"                                               
      165 +  }                                                           
      166 +                                                              
      167    private func formRightMultiplicationDecl(
      168      rhsTypeName: String,
      169      nativeStrategy: NativeStrategy,

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/CrossShapeMultiplicationMa
        crolet.swift)
  ⎿  Added 13 lines, removed 3 lines
      280            """
      281          ]
      282        case .columnWise:
      283 +        // For left-mult `lhs * self`, lhs has shape (N, X) wi
          +th X = lhs.rowCount                                           
      284 +        // = resultRowCount. Each lhs column is SIMD<X>; resul
          +t columns are SIMD<X>.                                        
      285 +        // (resultRowCount is captured implicitly by the lhsCo
          +lumnVectorType.)                                              
      286          let N = descriptor.rowCount
      287 +        let lhsCT = lhsColumnVectorType(forResultRowCount: des
          +criptor.rowCount)                                             
      288 +        _ = lhsCT  // currently unused; kept for symmetry with
          + right-mult                                                   
      289          let lhsLets = (0..<N).map { j in "let l\(j) = lhs.colu
           mns.\(j)" }.joined(separator: "\n  ")
      285 -        let colExprs = (0..<resultColumnCount).map { k -> Stri
          -ng in                                                         
      290 +        let colDecls: [String] = (0..<resultColumnCount).map {
          + k in                                                         
      291            let summands = (0..<N).map { j in "l\(j) * self.colu
           mns.\(k)[\(j)]" }
      287 -          return summands.joined(separator: " + ")            
      292 +          return "let col\(k) = \(summands.joined(separator: "
          + + "))"                                                       
      293          }
      289 -        let tuple = "(" + colExprs.joined(separator: ", ") + "
          -)"                                                            
      294 +        let tuple = "(" + (0..<resultColumnCount).map { "col\(
          +$0)" }.joined(separator: ", ") + ")"                          
      295          return [
      296            """
      297            @inlinable
      298            public func multiplied(onLeftBy lhs: \(raw: lhsTypeN
           ame)) -> \(raw: resultTypeName) {
      299              \(raw: lhsLets)
      300 +            \(raw: colDecls.joined(separator: "\n  "))        
      301              return \(raw: resultTypeName)(columns: \(raw: tupl
           e))
      302            }
      303            """
     ...
      321      }
      322    }
      323  
      324 +  private func lhsColumnVectorType(forResultRowCount resultRow
          +Count: Int) -> String {                                       
      325 +    "SIMD\(resultRowCount)<\(descriptor.representation.swiftSc
          +alarTypeName)>"                                               
      326 +  }                                                           
      327 +                                                              
      328    private func formLeftMultiplicationDecl(
      329      lhsTypeName: String,
      330      nativeStrategy: NativeStrategy,

⏺ Same hoisting for SquareMultiplicationMacrolet's column-wise branch:

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/SquareMultiplicationMacrol
        et.swift)  ⎿  Added 14 lines, removed 9 lines
      47          ]
      48        }
      49        if descriptor.producesBuggyHalfThreeRow {
      50 -        let dim = descriptor.columnCount  // == rowCount for sq
         -uare                                                           
      51 -        let selfLets = (0..<dim).map { i in "let s\(i) = self.c
         -olumns.\(i)" }.joined(separator: "\n  ")                       
      52 -        let rightCols = (0..<dim).map { k -> String in         
      50 +        // Half-3x3 column-wise pure-Swift. Hoist column refs i
         +nto typed                                                      
      51 +        // locals plus emit each result column as its own `let`
         + to keep the                                                   
      52 +        // type checker happy on the long sum expressions.     
      53 +        let dim = descriptor.columnCount  // == rowCount for sq
         +uare (3)                                                       
      54 +        let selfLets = (0..<dim).map { i in "let s\(i): ColumnV
         +ector = self.columns.\(i)" }.joined(separator: "\n  ")         
      55 +        let rightColDecls = (0..<dim).map { k -> String in     
      56            let summands = (0..<dim).map { i in "s\(i) * rhs.colu
          mns.\(k)[\(i)]" }
      54 -          return summands.joined(separator: " + ")             
      57 +          return "let rc\(k): ColumnVector = \(summands.joined(
         +separator: " + "))"                                            
      58          }
      56 -        let rightTuple = "(" + rightCols.joined(separator: ", "
         -) + ")"                                                        
      57 -        let lhsLets = (0..<dim).map { i in "let l\(i) = lhs.col
         -umns.\(i)" }.joined(separator: "\n  ")                         
      58 -        let leftCols = (0..<dim).map { k -> String in          
      59 +        let rightTuple = "(" + (0..<dim).map { "rc\($0)" }.join
         +ed(separator: ", ") + ")"                                      
      60 +        let lhsLets = (0..<dim).map { i in "let l\(i): ColumnVe
         +ctor = lhs.columns.\(i)" }.joined(separator: "\n  ")           
      61 +        let leftColDecls = (0..<dim).map { k -> String in      
      62            let summands = (0..<dim).map { i in "l\(i) * self.col
          umns.\(k)[\(i)]" }
      60 -          return summands.joined(separator: " + ")             
      63 +          return "let lc\(k): ColumnVector = \(summands.joined(
         +separator: " + "))"                                            
      64          }
      62 -        let leftTuple = "(" + leftCols.joined(separator: ", ") 
         -+ ")"                                                          
      65 +        let leftTuple = "(" + (0..<dim).map { "lc\($0)" }.joine
         +d(separator: ", ") + ")"                                       
      66          return [
      67            """
      68            @inlinable
      69            public func multiplied(onRightBy rhs: Self) -> Self {
      70              \(raw: selfLets)
      71 +            \(raw: rightColDecls.joined(separator: "\n  "))    
      72              return Self(columns: \(raw: rightTuple))
      73            }
      74            """,
     ...
      76            @inlinable
      77            public func multiplied(onLeftBy lhs: Self) -> Self {
      78              \(raw: lhsLets)
      79 +            \(raw: leftColDecls.joined(separator: "\n  "))     
      80              return Self(columns: \(raw: leftTuple))
      81            }
      82            """,

⏺ Bash(swift build 2>&1 | grep -E "error:" | head -30)
  ⎿  error: emit-module command failed with exit code 1 (use -v to see invo
     cation)
     error: compile command failed due to signal 5 (use -v to see invocatio
     … +74 lines (ctrl+o to expand)
  ⎿  (timeout 10m)

⏺ Let me restructure to use imperative += so each expression type-checks
  independently:

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/CrossShapeMultiplicationMa
        crolet.swift)
  ⎿  Added 10 lines, removed 8 lines
      118          ]
      119        case .columnWise:
      120          let M = descriptor.columnCount
      121 -        // Hoist `self.columns.i` into typed locals, then buil
          -d each output                                                 
      122 -        // column as a separately-typed `let`. Two-stage hoist
          -ing prevents                                                  
      123 -        // the type checker from blowing up on long sums.     
      121 +        // Build each output column with imperative `+=` accum
          +ulation. Each                                                 
      122 +        // statement is a simple `SIMD<n> * Scalar` (or `+= SI
          +MD<n>`), which                                                
      123 +        // the type checker resolves in O(1).                 
      124          let selfLets = (0..<M).map { i in "let s\(i): ColumnVe
           ctor = self.columns.\(i)" }.joined(separator: "\n  ")
      125 -        let resultCT = resultColumnVectorType(forResultRowCoun
          -t: descriptor.rowCount)                                       
      126 -        let colDecls: [String] = (0..<resultColumnCount).map {
          - k in                                                         
      127 -          let summands = (0..<M).map { i in "s\(i) * rhs.colum
          -ns.\(k)[\(i)]" }                                              
      128 -          return "let col\(k): \(resultCT) = \(summands.joined
          -(separator: " + "))"                                          
      125 +        let colBuilders: [String] = (0..<resultColumnCount).fl
          +atMap { k -> [String] in                                      
      126 +          var lines: [String] = ["var col\(k): ColumnVector = 
          +s0 * rhs.columns.\(k)[0]"]                                    
      127 +          for i in 1..<M {                                    
      128 +            lines.append("col\(k) += s\(i) * rhs.columns.\(k)[
          +\(i)]")                                                       
      129 +          }                                                   
      130 +          return lines                                        
      131          }
      132          let tuple = "(" + (0..<resultColumnCount).map { "col\(
           $0)" }.joined(separator: ", ") + ")"
      133          return [
     ...
      135            @inlinable
      136            public func multiplied(onRightBy rhs: \(raw: rhsType
           Name)) -> \(raw: resultTypeName) {
      137              \(raw: selfLets)
      136 -            \(raw: colDecls.joined(separator: "\n  "))        
      138 +            \(raw: colBuilders.joined(separator: "\n  "))     
      139              return \(raw: resultTypeName)(columns: \(raw: tupl
           e))
      140            }
      141            """

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/CrossShapeMultiplicationMa
        crolet.swift)
  ⎿  Added 11 lines, removed 7 lines
      284        case .columnWise:
      285          // For left-mult `lhs * self`, lhs has shape (N, X) wi
           th X = lhs.rowCount
      286          // = resultRowCount. Each lhs column is SIMD<X>; resul
           t columns are SIMD<X>.
      287 -        // (resultRowCount is captured implicitly by the lhsCo
          -lumnVectorType.)                                              
      287          let N = descriptor.rowCount
      289 -        let lhsCT = lhsColumnVectorType(forResultRowCount: des
          -criptor.rowCount)                                             
      290 -        _ = lhsCT  // currently unused; kept for symmetry with
          - right-mult                                                   
      288 +        // For half-3-row result, the result-column vector typ
          +e is SIMD3<Float16>.                                          
      289 +        // We resolve via the result's row count (lhs.rowCount
          + which is the same).                                          
      290 +        // No explicit annotation is strictly required since l
          +hs.columns.\(j) is                                            
      291 +        // already typed; the imperative form makes type-check
          +ing cheap regardless.                                         
      292          let lhsLets = (0..<N).map { j in "let l\(j) = lhs.colu
           mns.\(j)" }.joined(separator: "\n  ")
      292 -        let colDecls: [String] = (0..<resultColumnCount).map {
          - k in                                                         
      293 -          let summands = (0..<N).map { j in "l\(j) * self.colu
          -mns.\(k)[\(j)]" }                                             
      294 -          return "let col\(k) = \(summands.joined(separator: "
          - + "))"                                                       
      293 +        let colBuilders: [String] = (0..<resultColumnCount).fl
          +atMap { k -> [String] in                                      
      294 +          var lines: [String] = ["var col\(k) = l0 * self.colu
          +mns.\(k)[0]"]                                                 
      295 +          for j in 1..<N {                                    
      296 +            lines.append("col\(k) += l\(j) * self.columns.\(k)
          +[\(j)]")                                                      
      297 +          }                                                   
      298 +          return lines                                        
      299          }
      300          let tuple = "(" + (0..<resultColumnCount).map { "col\(
           $0)" }.joined(separator: ", ") + ")"
      301          return [
     ...
      303            @inlinable
      304            public func multiplied(onLeftBy lhs: \(raw: lhsTypeN
           ame)) -> \(raw: resultTypeName) {
      305              \(raw: lhsLets)
      302 -            \(raw: colDecls.joined(separator: "\n  "))        
      306 +            \(raw: colBuilders.joined(separator: "\n  "))     
      307              return \(raw: resultTypeName)(columns: \(raw: tupl
           e))
      308            }
      309            """

⏺ Same imperative pattern for SquareMul:

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/SquareMultiplicationMacrol
        et.swift)
  ⎿  Added 17 lines, removed 11 lines
      47          ]
      48        }
      49        if descriptor.producesBuggyHalfThreeRow {
      50 -        // Half-3x3 column-wise pure-Swift. Hoist column refs i
         -nto typed                                                      
      51 -        // locals plus emit each result column as its own `let`
         - to keep the                                                   
      52 -        // type checker happy on the long sum expressions.     
      50 +        // Half-3x3 column-wise pure-Swift. Imperative accumula
         +tion keeps                                                     
      51 +        // type checking trivial.                              
      52          let dim = descriptor.columnCount  // == rowCount for sq
          uare (3)
      53          let selfLets = (0..<dim).map { i in "let s\(i): ColumnV
          ector = self.columns.\(i)" }.joined(separator: "\n  ")
      55 -        let rightColDecls = (0..<dim).map { k -> String in     
      56 -          let summands = (0..<dim).map { i in "s\(i) * rhs.colu
         -mns.\(k)[\(i)]" }                                              
      57 -          return "let rc\(k): ColumnVector = \(summands.joined(
         -separator: " + "))"                                            
      54 +        let rightBuilders: [String] = (0..<dim).flatMap { k -> 
         +[String] in                                                    
      55 +          var lines: [String] = ["var rc\(k): ColumnVector = s0
         + * rhs.columns.\(k)[0]"]                                       
      56 +          for i in 1..<dim {                                   
      57 +            lines.append("rc\(k) += s\(i) * rhs.columns.\(k)[\(
         +i)]")                                                          
      58 +          }                                                    
      59 +          return lines                                         
      60          }
      61          let rightTuple = "(" + (0..<dim).map { "rc\($0)" }.join
          ed(separator: ", ") + ")"
      62 +                                                               
      63          let lhsLets = (0..<dim).map { i in "let l\(i): ColumnVe
          ctor = lhs.columns.\(i)" }.joined(separator: "\n  ")
      61 -        let leftColDecls = (0..<dim).map { k -> String in      
      62 -          let summands = (0..<dim).map { i in "l\(i) * self.col
         -umns.\(k)[\(i)]" }                                             
      63 -          return "let lc\(k): ColumnVector = \(summands.joined(
         -separator: " + "))"                                            
      64 +        let leftBuilders: [String] = (0..<dim).flatMap { k -> [
         +String] in                                                     
      65 +          var lines: [String] = ["var lc\(k): ColumnVector = l0
         + * self.columns.\(k)[0]"]                                      
      66 +          for i in 1..<dim {                                   
      67 +            lines.append("lc\(k) += l\(i) * self.columns.\(k)[\
         +(i)]")                                                         
      68 +          }                                                    
      69 +          return lines                                         
      70          }
      71          let leftTuple = "(" + (0..<dim).map { "lc\($0)" }.joine
          d(separator: ", ") + ")"
      72          return [
     ...
      74            @inlinable
      75            public func multiplied(onRightBy rhs: Self) -> Self {
      76              \(raw: selfLets)
      71 -            \(raw: rightColDecls.joined(separator: "\n  "))    
      77 +            \(raw: rightBuilders.joined(separator: "\n  "))    
      78              return Self(columns: \(raw: rightTuple))
      79            }
      80            """,
     ...
      82            @inlinable
      83            public func multiplied(onLeftBy lhs: Self) -> Self {
      84              \(raw: lhsLets)
      79 -            \(raw: leftColDecls.joined(separator: "\n  "))     
      85 +            \(raw: leftBuilders.joined(separator: "\n  "))     
      86              return Self(columns: \(raw: leftTuple))
      87            }
      88            """,

⏺ Bash(swift build 2>&1 | grep -E "error:" | head -30)
  ⎿  (No output)
  ⎿  (timeout 10m)

⏺ Bash(swift build 2>&1 | tail -20)
  ⎿  Building for debugging...
     [0/2] Write swift-version--58304C5D6DBC2206.txt
     Build complete! (0.09s)

⏺ Bash(find /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDXL
      SIMDSupport/Matrices/NativeConformances/Half -name "*.swift" -newer
      /Users/prb/conducto…)
  ⎿  [4/12] Compiling HDXLSIMDSupport simd_half2x4+Matrix2x4Protocol.swift
     [5/12] Compiling HDXLSIMDSupport simd_half4x4+Matrix4x4Protocol.swift
     [6/12] Compiling HDXLSIMDSupport simd_half3x4+Matrix3x4Protocol.swift
     … +7 lines (ctrl+o to expand)
  ⎿  (timeout 10m)

⏺ Build succeeded. Run tests:

⏺ Bash(swift test 2>&1 | tail -10)
  ⎿  Test Suite 'QuaternionMemoryLayoutTests' passed at 2026-05-14 21:55:10
     .053.
         Executed 3 tests, with 0 failures (0 unexpected) in 0.000 (0.000) sec
     … +12 lines (ctrl+o to expand)


⏺ All representations migrated, 133/133 tests still green. Let me update tasks
  and move on to validation test generation.

⏺ Let me build the validation skeleton and an umbrella tests macro. Start with
  the skeleton:

  Read 2 files (ctrl+o to expand)

⏺ Let me create the validation helpers in the Tests target:

  Read 1 file (ctrl+o to expand)

⏺ Write(Tests/HDXLSIMDSupportTests/Support/MatrixValidationHelpers.swift)
  ⎿  Wrote 245 lines to
     Tests/HDXLSIMDSupportTests/Support/MatrixValidationHelpers.swift
      2 //  MatrixValidationHelpers.swift
      3 //
      4 //  Generic skeletons used by macro-generated validation tests. E
      5 //  per-macrolet test invokes one of these, passing the wrapped o
        peration
      6 //  closure and a "ground-truth" native-simd operation closure. T
      7 //  builds matching wrapped + native inputs from a probe descript
        or, applies
      8 //  both closures, and compares.
      9 //
     … +267 lines (ctrl+o to expand)

⏺ Let me first verify the validation helpers build, then write a sanity check
  test file:
⏺ Bash(swift build 2>&1 | tail -10)
  ⎿  [0/1] Planning build
     Building for debugging...
     [0/2] Write swift-version--58304C5D6DBC2206.txt
     Build complete! (0.68s)

⏺ Bash(swift test 2>&1 | tail -10)
  ⎿  Test Suite 'QuaternionMemoryLayoutTests' passed at 2026-05-14 21:58:20
     .351.
         Executed 3 tests, with 0 failures (0 unexpected) in 0.000 (0.000) sec
     … +12 lines (ctrl+o to expand)

  ⎿  (timeout 10m)

⏺ Now build the umbrella test macro. First add the declaration to public API:

⏺ Update(Sources/HDXLSIMDSupport/Macros/Macros.swift)
  ⎿  Added 23 lines
      70    module: "HDXLSIMDSupportMacroPlugin",
      71    type: "AddWrapperMatrixConformanceMacro"
      72  )
      73 +                                                               
      74 +/// Attached member macro that emits a `swift-testing` `@Test` 
         +suite of                                                       
      75 +/// validation cases for a particular (shape, representation) c
         +ombination.                                                    
      76 +///                                                            
      77 +/// Each test exercises the macro-generated wrapper (`Matrix2x2
         +<Float>`,                                                      
      78 +/// etc.) against the corresponding native simd matrix (`simd_f
         +loat2x2`,                                                      
      79 +/// etc.) on a deterministic sweep of inputs. A failure indicat
         +es the                                                         
      80 +/// generated forwarding doesn't agree with the simd routine.  
      81 +///                                                            
      82 +/// Apply to a `@Suite` struct in the test target:             
      83 +///                                                            
      84 +///     @Suite("Matrix2x2<Float> validation")                  
      85 +///     @AddMatrixConformanceTests(rowCount: 2, columnCount: 2,
         + representation: .float)                                       
      86 +///     struct Matrix2x2FloatValidationTests { }               
      87 +@attached(member, names: arbitrary)                            
      88 +public macro AddMatrixConformanceTests(                        
      89 +  rowCount: Int,                                               
      90 +  columnCount: Int,                                            
      91 +  representation: MatrixRepresentation                         
      92 +) = #externalMacro(                                            
      93 +  module: "HDXLSIMDSupportMacroPlugin",                        
      94 +  type: "AddMatrixConformanceTestsMacro"                       
      95 +)                                                              

⏺ Now the test macro implementation:

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macros/AddMatrixConformanceTestsMacro
       .swift)
  ⎿  Wrote 37 lines to Sources/HDXLSIMDSupportMacroPlugin/Macros/AddMatrixC
     onformanceTestsMacro.swift
       2 //  AddMatrixConformanceTestsMacro.swift
       3 //
       4 
       5 import SwiftSyntax
       6 import SwiftSyntaxMacros
       8 /// Attached member macro that expands into a `swift-testing` `@
         Test` suite
       9 /// for one specific (shape, representation) combination of macr
         o-generated
      10 /// matrix conformance.
     … +43 lines (ctrl+o to expand)

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Plugin.swift)
  ⎿  Added 2 lines, removed 1 line
      10    let providingMacros: [any Macro.Type] = [
      11      AddNativeMatrixConformanceMacro.self,
      12      AddStorageMatrixConformanceMacro.self,
      13 -    AddWrapperMatrixConformanceMacro.self                      
      13 +    AddWrapperMatrixConformanceMacro.self,                     
      14 +    AddMatrixConformanceTestsMacro.self                        
      15    ]
      16  }

  Searched for 6 patterns (ctrl+o to expand)

⏺ Let me update NegationMacrolet to emit a validation test as a proof of
  concept:

  Read 1 file (ctrl+o to expand)

⏺ Let me create a shared helper for emitting probe arrays + the
  native-vs-wrapper operation in test bodies:

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/ValidationTestSupport.swift
       )
  ⎿  Wrote 77 lines to Sources/HDXLSIMDSupportMacroPlugin/Macrolets/Validat
     ionTestSupport.swift
       2 //  ValidationTestSupport.swift
       3 //
       4 //  Helpers for `validationTestDeclarations` emissions. Centrali
       5 //  probe-input construction and the per-representation native-o
         peration
       6 //  formula choice, so individual macrolets stay focused on thei
       7 //  the API.
       8 //
       9 
      10 import SwiftSyntax
     … +87 lines (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/ValidationTestSupport.swift
       )
  ⎿  Added 30 lines, removed 21 lines
      20    /// `[[Scalar]]` value literals — small probe sweep used by e
          very test.
      21    /// Builds an array of `rowCount × columnCount` 2D-arrays, va
          rying the
      22    /// entries deterministically.
      23 -  var probeScalarsArrayExpression: String {                    
      24 -    let scalarType = representation.swiftScalarTypeName        
      25 -    // Deterministic small set of probes. The first few are    
      26 -    // zeros / identity / signed entries; remainder are derived
         - by indexing.                                                  
      23 +  var probeMatricesArrayExpression: String {                   
      24      let probesData: [[[Int]]] = [
      28 -      .zeroMatrix(rows: rowCount, columns: columnCount),       
      29 -      .identityMatrix(rows: rowCount, columns: columnCount),   
      30 -      .incrementingMatrix(rows: rowCount, columns: columnCount,
         - start: 1),                                                    
      31 -      .incrementingMatrix(rows: rowCount, columns: columnCount,
         - start: -3),                                                   
      32 -      .repeatingMatrix(rows: rowCount, columns: columnCount, va
         -lue: 2),                                                       
      33 -      .alternatingMatrix(rows: rowCount, columns: columnCount),
      34 -      .upperTriangularMatrix(rows: rowCount, columns: columnCou
         -nt)                                                            
      25 +      ProbeMatrixGenerator.zero(rows: rowCount, columns: column
         +Count),                                                        
      26 +      ProbeMatrixGenerator.identity(rows: rowCount, columns: co
         +lumnCount),                                                    
      27 +      ProbeMatrixGenerator.incrementing(rows: rowCount, columns
         +: columnCount, start: 1),                                      
      28 +      ProbeMatrixGenerator.incrementing(rows: rowCount, columns
         +: columnCount, start: -3),                                     
      29 +      ProbeMatrixGenerator.repeating(rows: rowCount, columns: c
         +olumnCount, value: 2),                                         
      30 +      ProbeMatrixGenerator.alternating(rows: rowCount, columns:
         + columnCount),                                                 
      31 +      ProbeMatrixGenerator.upperTriangular(rows: rowCount, colu
         +mns: columnCount)                                              
      32      ]
      33 +    let scalarType = representation.swiftScalarTypeName        
      34      let probeLiterals = probesData.map { matrix -> String in
      35        let rows = matrix.map { row -> String in
      36          "[" + row.map { "\(scalarType)(\($0))" }.joined(separat
          or: ", ") + "]"
      37        }
      38        return "[" + rows.joined(separator: ", ") + "]"
      39      }
      42 -    return "[" + probeLiterals.joined(separator: ",\n      ") +
         - "]"                                                           
      40 +    return "[\n      " + probeLiterals.joined(separator: ",\n  
         +    ") + "\n    ]"                                             
      41    }
      42 +                                                               
      43 +  /// Small probe scalar set used as scalar inputs to operation
         +s like                                                         
      44 +  /// `multiplied(by:)`. Concrete to the descriptor's represent
         +ation.                                                         
      45 +  var probeScalarsArrayExpression: String {                    
      46 +    let scalarType = representation.swiftScalarTypeName        
      47 +    let values = [-2, -1, 0, 1, 2]                             
      48 +    let elements = values.map { "\(scalarType)(\($0))" }.joined
         +(separator: ", ")                                              
      49 +    return "[" + elements + "]"                                
      50 +  }                                                            
      51  }
      52  
      46 -private extension Array where Element == [[Int]] {             
      53 +/// Probe matrix construction helpers (Swift values, used at ex
         +pansion-time                                                   
      54 +/// to lay out test inputs).                                   
      55 +enum ProbeMatrixGenerator {                                    
      56  
      48 -  static func zeroMatrix(rows: Int, columns: Int) -> [[Int]] { 
      49 -    Array<[Int]>(repeating: Array(repeating: 0, count: columns)
         -, count: rows)                                                 
      57 +  static func zero(rows: Int, columns: Int) -> [[Int]] {       
      58 +    Array(repeating: Array(repeating: 0, count: columns), count
         +: rows)                                                        
      59    }
      60  
      52 -  static func identityMatrix(rows: Int, columns: Int) -> [[Int]
         -] {                                                            
      61 +  static func identity(rows: Int, columns: Int) -> [[Int]] {   
      62      (0..<rows).map { r in (0..<columns).map { c in r == c ? 1 :
           0 } }
      63    }
      64  
      56 -  static func incrementingMatrix(rows: Int, columns: Int, start
         -: Int) -> [[Int]] {                                            
      65 +  static func incrementing(rows: Int, columns: Int, start: Int)
         + -> [[Int]] {                                                  
      66      var value = start
      67      return (0..<rows).map { _ in
      68        (0..<columns).map { _ -> Int in
     ...
      72      }
      73    }
      74  
      66 -  static func repeatingMatrix(rows: Int, columns: Int, value: I
         -nt) -> [[Int]] {                                               
      67 -    Array<[Int]>(repeating: Array(repeating: value, count: colu
         -mns), count: rows)                                             
      75 +  static func repeating(rows: Int, columns: Int, value: Int) ->
         + [[Int]] {                                                     
      76 +    Array(repeating: Array(repeating: value, count: columns), c
         +ount: rows)                                                    
      77    }
      78  
      70 -  static func alternatingMatrix(rows: Int, columns: Int) -> [[I
         -nt]] {                                                         
      79 +  static func alternating(rows: Int, columns: Int) -> [[Int]] {
      80      (0..<rows).map { r in (0..<columns).map { c in (r + c).isMu
          ltiple(of: 2) ? 1 : -1 } }
      81    }
      82  
      74 -  static func upperTriangularMatrix(rows: Int, columns: Int) ->
         - [[Int]] {                                                     
      83 +  static func upperTriangular(rows: Int, columns: Int) -> [[Int
         +]] {                                                           
      84      (0..<rows).map { r in (0..<columns).map { c in c >= r ? c -
           r + 1 : 0 } }
      85    }
      86  }

⏺ Let me simplify by replacing validation helpers with inline tests in the
  macrolet. First update the helpers file:

⏺ Write(Tests/HDXLSIMDSupportTests/Support/MatrixValidationHelpers.swift)
  ⎿  Added 89 lines, removed 171 lines
       1  //
       2  //  MatrixValidationHelpers.swift
       3  //
       4 -//  Generic skeletons used by macro-generated validation tests.
         - Each                                                          
       5 -//  per-macrolet test invokes one of these, passing the wrapped
         - operation                                                     
       6 -//  closure and a "ground-truth" native-simd operation closure.
         - The skeleton                                                  
       7 -//  builds matching wrapped + native inputs from a probe descri
         -ptor, applies                                                  
       8 -//  both closures, and compares.                               
       4 +//  Imported by macro-generated validation suites. Each generat
         +ed test                                                        
       5 +//  constructs probe matrices inline (as `[[Scalar]]` arrays), 
         +then invokes                                                   
       6 +//  one of these helpers, which compare the macro-generated wra
         +pper output                                                    
       7 +//  against a "ground truth" native-simd computation.          
       8  //
       9  
      10  import Foundation
     ...
      12  import simd
      13  @testable import HDXLSIMDSupport
      14  
      16 -// MARK: - Probe scalars                                       
      17 -                                                               
      18 -/// A small, fixed set of probe scalars covering positive, nega
         -tive, and zero.                                                
      19 -/// Used as multipliers / scalar inputs in generated tests. Kep
         -t short so the                                                 
      20 -/// test matrix doesn't explode.                               
      21 -enum MatrixValidationProbes {                                  
      22 -  static let floatScalars: [Float] = [-2.5, -1, 0, 1, 2.25, 3] 
      23 -  static let doubleScalars: [Double] = [-2.5, -1, 0, 1, 2.25, 3
         -]                                                              
      24 -  static let halfScalars: [Float16] = [-2.5, -1, 0, 1, 2.25, 3]
      25 -}                                                              
      26 -                                                               
      27 -// MARK: - Out-of-place unary                                  
      28 -                                                               
      29 -/// Validates that a wrapped unary operation matches a native-s
         -imd unary                                                      
      30 -/// operation on the same inputs.                              
      15 +/// Validates a wrapped unary operation against a native one ac
         +ross an array                                                  
      16 +/// of `[[Scalar]]` probe inputs.                              
      17  ///
      32 -/// - `name` is included in the failure message (the operation 
         -under test).                                                   
      33 -/// - `probes` is the input sweep — each tuple constructs both 
         -a wrapped value                                                
      34 -///   and a native value via `IntegerTupleConstructible`.      
      35 -/// - `epsilon` is the L∞ tolerance.                           
      36 -/// - `wrappedOperation` is the wrapped operation under test.  
      37 -/// - `nativeOperation` is the reference / ground-truth operati
         -on.                                                            
      38 -func validateOutOfPlaceUnary<Wrapped, Native, Result, NativeRes
         -ult, IntegerTuple>(                                            
      18 +/// `Wrapper` is the user-facing matrix wrapper (`Matrix2x2<Flo
         +at>`, etc.).                                                   
      19 +/// `Native` is the underlying simd matrix (`simd_float2x2`, et
         +c.).                                                           
      20 +func validateUnaryEquivalence<Wrapper, Native, Scalar>(        
      21    _ name: String,
      40 -  on probes: [IntegerTuple],                                   
      41 -  epsilon: Result.LInfinityDistance,                           
      42 -  wrappedOperation: (Wrapped) -> Result,                       
      43 -  nativeOperation: (Native) -> NativeResult,                   
      22 +  probes: [[[Scalar]]],                                        
      23 +  epsilon: Wrapper.LInfinityDistance,                          
      24 +  wrapped: (Wrapper) -> Wrapper,                               
      25 +  native: (Native) -> Native,                                  
      26    sourceLocation: SourceLocation = #_sourceLocation
      27  ) where
      46 -  Wrapped: IntegerTupleConstructible,                          
      47 -  Wrapped.IntegerTuple == IntegerTuple,                        
      48 -  Wrapped: NativeSIMDRepresentable,                            
      49 -  Wrapped.NativeSIMDRepresentation == Native,                  
      50 -  Native: IntegerTupleConstructible,                           
      51 -  Native.IntegerTuple == IntegerTuple,                         
      52 -  Result: NativeSIMDRepresentable,                             
      53 -  Result.NativeSIMDRepresentation == NativeResult,             
      54 -  Result: LInfinityDistanceMeasureable,                        
      55 -  Result.LInfinityDistance: BinaryFloatingPoint                
      28 +  Wrapper: NativeSIMDRepresentable,                            
      29 +  Wrapper.NativeSIMDRepresentation == Native,                  
      30 +  Wrapper: MatrixProtocol,                                     
      31 +  Wrapper.Scalar == Scalar,                                    
      32 +  Wrapper: LInfinityDistanceMeasureable,                       
      33 +  Wrapper.LInfinityDistance: BinaryFloatingPoint,              
      34 +  Scalar: SIMDScalar & BinaryFloatingPoint                     
      35  {
      36    for probe in probes {
      58 -    let wrappedInput = Wrapped(integerTuple: probe)            
      59 -    let nativeInput = Native(integerTuple: probe)              
      60 -    let wrappedResult = wrappedOperation(wrappedInput)         
      61 -    let nativeResult = nativeOperation(nativeInput)            
      62 -    let nativeAsWrapped = Result(nativeSIMDRepresentation: nati
         -veResult)                                                      
      37 +    let wrappedInput = Wrapper(scalars: probe)                 
      38 +    let nativeInput = wrappedInput.nativeSIMDRepresentation    
      39 +    let wrappedResult = wrapped(wrappedInput)                  
      40 +    let nativeResult = native(nativeInput)                     
      41 +    let nativeAsWrapped = Wrapper(nativeSIMDRepresentation: nat
         +iveResult)                                                     
      42      let distance = wrappedResult.lInfinityDistance(to: nativeAs
          Wrapped)
      43      #expect(
      44        distance < epsilon,
     ...
       48    }
       49  }
       50  
       72 -// MARK: - Out-of-place binary (matrix, matrix) -> matrix     
       73 -                                                              
       74 -/// Validates that a wrapped binary (same-shape inputs) operat
          -ion matches a                                                 
       75 -/// native-simd binary operation.                             
       76 -func validateOutOfPlaceBinary<Wrapped, Native, Result, NativeR
          -esult, IntegerTuple>(                                         
       51 +/// Validates a wrapped binary operation (same input shape, sa
          +me output shape)                                              
       52 +/// against a native one over the cartesian product of probe i
          +nputs.                                                        
       53 +func validateBinaryEquivalence<Wrapper, Native, Scalar>(      
       54    _ name: String,
       78 -  lhses: [IntegerTuple],                                      
       79 -  rhses: [IntegerTuple],                                      
       80 -  epsilon: Result.LInfinityDistance,                          
       81 -  wrappedOperation: (Wrapped, Wrapped) -> Result,             
       82 -  nativeOperation: (Native, Native) -> NativeResult,          
       55 +  lhses: [[[Scalar]]],                                        
       56 +  rhses: [[[Scalar]]],                                        
       57 +  epsilon: Wrapper.LInfinityDistance,                         
       58 +  wrapped: (Wrapper, Wrapper) -> Wrapper,                     
       59 +  native: (Native, Native) -> Native,                         
       60    sourceLocation: SourceLocation = #_sourceLocation
       61  ) where
       85 -  Wrapped: IntegerTupleConstructible,                         
       86 -  Wrapped.IntegerTuple == IntegerTuple,                       
       87 -  Wrapped: NativeSIMDRepresentable,                           
       88 -  Wrapped.NativeSIMDRepresentation == Native,                 
       89 -  Native: IntegerTupleConstructible,                          
       90 -  Native.IntegerTuple == IntegerTuple,                        
       91 -  Result: NativeSIMDRepresentable,                            
       92 -  Result.NativeSIMDRepresentation == NativeResult,            
       93 -  Result: LInfinityDistanceMeasureable,                       
       94 -  Result.LInfinityDistance: BinaryFloatingPoint               
       62 +  Wrapper: NativeSIMDRepresentable,                           
       63 +  Wrapper.NativeSIMDRepresentation == Native,                 
       64 +  Wrapper: MatrixProtocol,                                    
       65 +  Wrapper.Scalar == Scalar,                                   
       66 +  Wrapper: LInfinityDistanceMeasureable,                      
       67 +  Wrapper.LInfinityDistance: BinaryFloatingPoint,             
       68 +  Scalar: SIMDScalar & BinaryFloatingPoint                    
       69  {
       70    for lhs in lhses {
       71      for rhs in rhses {
       98 -      let wrappedLHS = Wrapped(integerTuple: lhs)             
       99 -      let wrappedRHS = Wrapped(integerTuple: rhs)             
      100 -      let nativeLHS = Native(integerTuple: lhs)               
      101 -      let nativeRHS = Native(integerTuple: rhs)               
      102 -      let wrappedResult = wrappedOperation(wrappedLHS, wrapped
          -RHS)                                                          
      103 -      let nativeResult = nativeOperation(nativeLHS, nativeRHS)
      104 -      let nativeAsWrapped = Result(nativeSIMDRepresentation: n
          -ativeResult)                                                  
       72 +      let wrappedLHS = Wrapper(scalars: lhs)                  
       73 +      let wrappedRHS = Wrapper(scalars: rhs)                  
       74 +      let nativeLHS = wrappedLHS.nativeSIMDRepresentation     
       75 +      let nativeRHS = wrappedRHS.nativeSIMDRepresentation     
       76 +      let wrappedResult = wrapped(wrappedLHS, wrappedRHS)     
       77 +      let nativeResult = native(nativeLHS, nativeRHS)         
       78 +      let nativeAsWrapped = Wrapper(nativeSIMDRepresentation: 
          +nativeResult)                                                 
       79        let distance = wrappedResult.lInfinityDistance(to: nativ
           eAsWrapped)
       80        #expect(
       81          distance < epsilon,
     ...
       86    }
       87  }
       88  
      115 -// MARK: - Out-of-place (matrix, scalar) -> matrix            
      116 -                                                              
      117 -func validateOutOfPlaceMatrixScalar<Wrapped, Native, Scalar, R
          -esult, NativeResult, IntegerTuple>(                           
       89 +/// Validates a wrapped `(matrix, scalar) -> matrix` operation
          + against a                                                    
       90 +/// native counterpart.                                       
       91 +func validateMatrixScalarEquivalence<Wrapper, Native, Scalar>(
       92    _ name: String,
      119 -  matrices: [IntegerTuple],                                   
       93 +  matrices: [[[Scalar]]],                                     
       94    scalars: [Scalar],
      121 -  epsilon: Result.LInfinityDistance,                          
      122 -  wrappedOperation: (Wrapped, Scalar) -> Result,              
      123 -  nativeOperation: (Native, Scalar) -> NativeResult,          
       95 +  epsilon: Wrapper.LInfinityDistance,                         
       96 +  wrapped: (Wrapper, Scalar) -> Wrapper,                      
       97 +  native: (Native, Scalar) -> Native,                         
       98    sourceLocation: SourceLocation = #_sourceLocation
       99  ) where
      126 -  Wrapped: IntegerTupleConstructible,                         
      127 -  Wrapped.IntegerTuple == IntegerTuple,                       
      128 -  Wrapped: NativeSIMDRepresentable,                           
      129 -  Wrapped.NativeSIMDRepresentation == Native,                 
      130 -  Native: IntegerTupleConstructible,                          
      131 -  Native.IntegerTuple == IntegerTuple,                        
      132 -  Result: NativeSIMDRepresentable,                            
      133 -  Result.NativeSIMDRepresentation == NativeResult,            
      134 -  Result: LInfinityDistanceMeasureable,                       
      135 -  Result.LInfinityDistance: BinaryFloatingPoint               
      100 +  Wrapper: NativeSIMDRepresentable,                           
      101 +  Wrapper.NativeSIMDRepresentation == Native,                 
      102 +  Wrapper: MatrixProtocol,                                    
      103 +  Wrapper.Scalar == Scalar,                                   
      104 +  Wrapper: LInfinityDistanceMeasureable,                      
      105 +  Wrapper.LInfinityDistance: BinaryFloatingPoint,             
      106 +  Scalar: SIMDScalar & BinaryFloatingPoint                    
      107  {
      137 -  for matrix in matrices {                                    
      108 +  for probe in matrices {                                     
      109      for scalar in scalars {
      139 -      let wrappedM = Wrapped(integerTuple: matrix)            
      140 -      let nativeM = Native(integerTuple: matrix)              
      141 -      let wrappedResult = wrappedOperation(wrappedM, scalar)  
      142 -      let nativeResult = nativeOperation(nativeM, scalar)     
      143 -      let nativeAsWrapped = Result(nativeSIMDRepresentation: n
          -ativeResult)                                                  
      110 +      let wrappedM = Wrapper(scalars: probe)                  
      111 +      let nativeM = wrappedM.nativeSIMDRepresentation         
      112 +      let wrappedResult = wrapped(wrappedM, scalar)           
      113 +      let nativeResult = native(nativeM, scalar)              
      114 +      let nativeAsWrapped = Wrapper(nativeSIMDRepresentation: 
          +nativeResult)                                                 
      115        let distance = wrappedResult.lInfinityDistance(to: nativ
           eAsWrapped)
      116        #expect(
      117          distance < epsilon,
      147 -        "[\(name)] L∞ distance \(distance) >= \(epsilon) for m
          -atrix=\(matrix), scalar=\(scalar)",                           
      118 +        "[\(name)] L∞ distance \(distance) >= \(epsilon) for m
          +atrix=\(probe), scalar=\(scalar)",                            
      119          sourceLocation: sourceLocation
      120        )
      121      }
      122    }
      123  }
      124  
      154 -// MARK: - Out-of-place (matrix, matrix, scalar) -> matrix  (F
          -MA / FMS)                                                     
      155 -                                                              
      156 -func validateOutOfPlaceMatrixMatrixScalar<Wrapped, Native, Sca
          -lar, IntegerTuple>(                                           
      125 +/// Validates an `(M, M, scalar) -> M` operation (FMA / FMS). 
      126 +func validateMatrixMatrixScalarEquivalence<Wrapper, Native, Sc
          +alar>(                                                        
      127    _ name: String,
      158 -  lhses: [IntegerTuple],                                      
      159 -  rhses: [IntegerTuple],                                      
      128 +  lhses: [[[Scalar]]],                                        
      129 +  rhses: [[[Scalar]]],                                        
      130    scalars: [Scalar],
      161 -  epsilon: Wrapped.LInfinityDistance,                         
      162 -  wrappedOperation: (Wrapped, Wrapped, Scalar) -> Wrapped,    
      163 -  nativeOperation: (Native, Native, Scalar) -> Native,        
      131 +  epsilon: Wrapper.LInfinityDistance,                         
      132 +  wrapped: (Wrapper, Wrapper, Scalar) -> Wrapper,             
      133 +  native: (Native, Native, Scalar) -> Native,                 
      134    sourceLocation: SourceLocation = #_sourceLocation
      135  ) where
      166 -  Wrapped: IntegerTupleConstructible,                         
      167 -  Wrapped.IntegerTuple == IntegerTuple,                       
      168 -  Wrapped: NativeSIMDRepresentable,                           
      169 -  Wrapped.NativeSIMDRepresentation == Native,                 
      170 -  Wrapped: LInfinityDistanceMeasureable,                      
      171 -  Wrapped.LInfinityDistance: BinaryFloatingPoint,             
      172 -  Native: IntegerTupleConstructible,                          
      173 -  Native.IntegerTuple == IntegerTuple                         
      136 +  Wrapper: NativeSIMDRepresentable,                           
      137 +  Wrapper.NativeSIMDRepresentation == Native,                 
      138 +  Wrapper: MatrixProtocol,                                    
      139 +  Wrapper.Scalar == Scalar,                                   
      140 +  Wrapper: LInfinityDistanceMeasureable,                      
      141 +  Wrapper.LInfinityDistance: BinaryFloatingPoint,             
      142 +  Scalar: SIMDScalar & BinaryFloatingPoint                    
      143  {
      144    for lhs in lhses {
      145      for rhs in rhses {
      146        for scalar in scalars {
      178 -        let wrappedLHS = Wrapped(integerTuple: lhs)           
      179 -        let wrappedRHS = Wrapped(integerTuple: rhs)           
      180 -        let nativeLHS = Native(integerTuple: lhs)             
      181 -        let nativeRHS = Native(integerTuple: rhs)             
      182 -        let wrappedResult = wrappedOperation(wrappedLHS, wrapp
          -edRHS, scalar)                                                
      183 -        let nativeResult = nativeOperation(nativeLHS, nativeRH
          -S, scalar)                                                    
      184 -        let nativeAsWrapped = Wrapped(nativeSIMDRepresentation
          -: nativeResult)                                               
      147 +        let wrappedL = Wrapper(scalars: lhs)                  
      148 +        let wrappedR = Wrapper(scalars: rhs)                  
      149 +        let nativeL = wrappedL.nativeSIMDRepresentation       
      150 +        let nativeR = wrappedR.nativeSIMDRepresentation       
      151 +        let wrappedResult = wrapped(wrappedL, wrappedR, scalar
          +)                                                             
      152 +        let nativeResult = native(nativeL, nativeR, scalar)   
      153 +        let nativeAsWrapped = Wrapper(nativeSIMDRepresentation
          +: nativeResult)                                               
      154          let distance = wrappedResult.lInfinityDistance(to: nat
           iveAsWrapped)
      155          #expect(
      156            distance < epsilon,
     ...
      161      }
      162    }
      163  }
      195 -                                                              
      196 -// MARK: - Out-of-place (matrix-A, matrix-B) -> matrix-C  (cro
          -ss-shape)                                                     
      197 -                                                              
      198 -func validateOutOfPlaceCross<                                 
      199 -  WrappedSelf, NativeSelf, IntegerTupleSelf,                  
      200 -  WrappedOther, NativeOther, IntegerTupleOther,               
      201 -  WrappedResult, NativeResult                                 
      202 ->(                                                            
      203 -  _ name: String,                                             
      204 -  selves: [IntegerTupleSelf],                                 
      205 -  others: [IntegerTupleOther],                                
      206 -  epsilon: WrappedResult.LInfinityDistance,                   
      207 -  wrappedOperation: (WrappedSelf, WrappedOther) -> WrappedResu
          -lt,                                                           
      208 -  nativeOperation: (NativeSelf, NativeOther) -> NativeResult, 
      209 -  sourceLocation: SourceLocation = #_sourceLocation           
      210 -) where                                                       
      211 -  WrappedSelf: IntegerTupleConstructible,                     
      212 -  WrappedSelf.IntegerTuple == IntegerTupleSelf,               
      213 -  WrappedSelf: NativeSIMDRepresentable,                       
      214 -  WrappedSelf.NativeSIMDRepresentation == NativeSelf,         
      215 -  NativeSelf: IntegerTupleConstructible,                      
      216 -  NativeSelf.IntegerTuple == IntegerTupleSelf,                
      217 -  WrappedOther: IntegerTupleConstructible,                    
      218 -  WrappedOther.IntegerTuple == IntegerTupleOther,             
      219 -  WrappedOther: NativeSIMDRepresentable,                      
      220 -  WrappedOther.NativeSIMDRepresentation == NativeOther,       
      221 -  NativeOther: IntegerTupleConstructible,                     
      222 -  NativeOther.IntegerTuple == IntegerTupleOther,              
      223 -  WrappedResult: NativeSIMDRepresentable,                     
      224 -  WrappedResult.NativeSIMDRepresentation == NativeResult,     
      225 -  WrappedResult: LInfinityDistanceMeasureable,                
      226 -  WrappedResult.LInfinityDistance: BinaryFloatingPoint        
      227 -{                                                             
      228 -  for s in selves {                                           
      229 -    for o in others {                                         
      230 -      let wrappedS = WrappedSelf(integerTuple: s)             
      231 -      let nativeS = NativeSelf(integerTuple: s)               
      232 -      let wrappedO = WrappedOther(integerTuple: o)            
      233 -      let nativeO = NativeOther(integerTuple: o)              
      234 -      let wrappedResult = wrappedOperation(wrappedS, wrappedO)
      235 -      let nativeResult = nativeOperation(nativeS, nativeO)    
      236 -      let nativeAsWrapped = WrappedResult(nativeSIMDRepresenta
          -tion: nativeResult)                                           
      237 -      let distance = wrappedResult.lInfinityDistance(to: nativ
          -eAsWrapped)                                                   
      238 -      #expect(                                                
      239 -        distance < epsilon,                                   
      240 -        "[\(name)] L∞ distance \(distance) >= \(epsilon) for s
          -elf=\(s), other=\(o)",                                        
      241 -        sourceLocation: sourceLocation                        
      242 -      )                                                       
      243 -    }                                                         
      244 -  }                                                           
      245 -}                                                             

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/NegationMacrolet.swift)
  ⎿  Added 32 lines, removed 6 lines
       4  
       5  import SwiftSyntax
       6  
       7 -/// Emits `negated() -> Self` and `formNegation()`.            
       8 -///                                                            
       9 -/// - Native: implements `-self` directly, except for shapes wh
         -ose simd overlay                                               
      10 -///   matrix-level operations are buggy (`usesColumnWiseSwiftFa
         -llback`), where we                                             
      11 -///   fall back to a column-wise pure-Swift implementation.    
      12 -/// - Storage/Wrapper: forwards.                               
       7 +/// Emits `negated() -> Self` and `formNegation()` plus the mat
         +ching                                                          
       8 +/// validation test.                                           
       9  struct NegationMacrolet: SIMDMatrixMacrolet {
      10    let descriptor: MatrixDescriptor
      11  
     ...
      57        ]
      58      }
      59    }
      60 +                                                               
      61 +  func validationTestDeclarations(in context: MatrixLayerContex
         +t) -> [DeclSyntax] {                                           
      62 +    // Skip half-3-row: we don't have an independent native gro
         +und-truth for                                                  
      63 +    // shapes the simd routines miscompute. (TODO: widen-to-flo
         +at                                                             
      64 +    // cross-validation.)                                      
      65 +    if descriptor.producesBuggyHalfThreeRow { return [] }      
      66 +    let wrapper = descriptor.wrapperTypeInstantiation          
      67 +    let native = descriptor.nativeTypeName                     
      68 +    let nativeNegation: String                                 
      69 +    switch descriptor.representation {                         
      70 +    case .half:                                                
      71 +      nativeNegation = "simd_mul((-1) as \(descriptor.represent
         +ation.swiftScalarTypeName), n)"                                
      72 +    case .float, .double:                                      
      73 +      nativeNegation = "-n"                                    
      74 +    }                                                          
      75 +    return [                                                   
      76 +      """                                                      
      77 +      @Test static func validateNegation() {                   
      78 +        let probes: [[[\(raw: descriptor.representation.swiftSc
         +alarTypeName)]]] = \(raw: descriptor.probeMatricesArrayExpressi
         +on)                                                            
      79 +        validateUnaryEquivalence(                              
      80 +          "negation",                                          
      81 +          probes: probes,                                      
      82 +          epsilon: 0.0001,                                     
      83 +          wrapped: { (m: \(raw: wrapper)) -> \(raw: wrapper) in
         + m.negated() },                                                
      84 +          native: { (n: \(raw: native)) -> \(raw: native) in \(
         +raw: nativeNegation) }                                         
      85 +        )                                                      
      86 +      }                                                        
      87 +      """                                                      
      88 +    ]                                                          
      89 +  }                                                            
      90  }

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/ValidationTestSupport.swif
        t)
  ⎿  Added 11 lines
      48      let elements = values.map { "\(scalarType)(\($0))" }.joined
          (separator: ", ")
      49      return "[" + elements + "]"
      50    }
      51 +                                                               
      52 +  /// Per-representation L∞-distance tolerance used in generate
         +d tests.                                                       
      53 +  /// Half-precision is much less precise than Float/Double; th
         +e looser                                                       
      54 +  /// tolerance accounts for rounding from `simd_mul((-1), x)` 
         +etc.                                                           
      55 +  var defaultEpsilonLiteral: String {                          
      56 +    switch representation {                                    
      57 +    case .half:   return "0.05"                                
      58 +    case .float:  return "0.0001"                              
      59 +    case .double: return "0.00000001"                          
      60 +    }                                                          
      61 +  }                                                            
      62  }
      63  
      64  /// Probe matrix construction helpers (Swift values, used at ex
          pansion-time

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/NegationMacrolet.swift)
  ⎿  Added 1 line, removed 1 line
      79          validateUnaryEquivalence(
      80            "negation",
      81            probes: probes,
      82 -          epsilon: 0.0001,                                     
      82 +          epsilon: \(raw: descriptor.defaultEpsilonLiteral),   
      83            wrapped: { (m: \(raw: wrapper)) -> \(raw: wrapper) in
           m.negated() },
      84            native: { (n: \(raw: native)) -> \(raw: native) in \(
          raw: nativeNegation) }
      85          )

⏺ Now create a test file in the Tests target that exercises the macro:
⏺ Write(Tests/HDXLSIMDSupportTests/Tests/Matrices/Validation/Matrix2x2FloatValid
       ationTests.swift)
  ⎿  Wrote 14 lines to Tests/HDXLSIMDSupportTests/Tests/Matrices/Validation
     /Matrix2x2FloatValidationTests.swift
       2 //  Matrix2x2FloatValidationTests.swift
       3 //
       4 //  Macro-driven validation suite for Matrix2x2<Float>. Every pe
         r-API
       5 //  macrolet that supports test emission contributes a `@Test` c
       6 //e here.
       7 
       8 import Testing
       9 import simd
      10 @testable import HDXLSIMDSupport
     … +7 lines (ctrl+o to expand)

⏺ Bash(swift test 2>&1 | tail -30)
  ⎿  [189/219] Compiling HDXLSIMDSupportTests ValidationTestCase.swift
     [190/219] Compiling HDXLSIMDSupportTests Products-2.swift
     [191/219] Compiling HDXLSIMDSupportTests Products-3.swift
     … +27 lines (ctrl+o to expand)
  ⎿  (timeout 10m)

⏺ Bash(swift test 2>&1 | grep -E "error:|fatalError|warning:" | head -30)
  ⎿  error: emit-module command failed with exit code 1 (use -v to see invo
     cation)
     macro expansion @Test:23:24: error: cannot use instance member '$s20HD
     … +43 lines (ctrl+o to expand)

⏺ @Test doesn't work on static methods. Remove static:

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/NegationMacrolet.swift)
  ⎿  Added 1 line, removed 1 line
      74      }
      75      return [
      76        """
      77 -      @Test static func validateNegation() {                   
      77 +      @Test func validateNegation() {                          
      78          let probes: [[[\(raw: descriptor.representation.swiftSc
          alarTypeName)]]] = \(raw: descriptor.probeMatricesArrayExpressi
          on)
      79          validateUnaryEquivalence(
      80            "negation",

⏺ Bash(swift test 2>&1 | grep -E "error:" | head -10)
  ⎿  error: emit-module command failed with exit code 1 (use -v to see invo
     cation)
     macro expansion @Test:23:24: error: cannot use instance member '$s20HD
     … +22 lines (ctrl+o to expand)

⏺ Let me check Swift Testing setup by writing a hand-coded test first:

⏺ Write(Tests/HDXLSIMDSupportTests/Tests/Matrices/Validation/Matrix2x2FloatValid
       ationTests.swift)
  ⎿  Added 17 lines, removed 2 lines
      10  @testable import HDXLSIMDSupport
      11  
      12  @Suite("Matrix2x2<Float> validation")
      13 -@AddMatrixConformanceTests(rowCount: 2, columnCount: 2, represe
         -ntation: .float)                                               
      14 -struct Matrix2x2FloatValidationTests { }                       
      13 +struct Matrix2x2FloatValidationTests {                         
      14 +                                                               
      15 +  @Test func handCodedNegation() {                             
      16 +    let probes: [[[Float]]] = [                                
      17 +      [[0, 0], [0, 0]],                                        
      18 +      [[1, 2], [3, 4]],                                        
      19 +      [[-1, 1], [2, -2]]                                       
      20 +    ]                                                          
      21 +    validateUnaryEquivalence(                                  
      22 +      "negation",                                              
      23 +      probes: probes,                                          
      24 +      epsilon: 0.0001,                                         
      25 +      wrapped: { (m: Matrix2x2<Float>) -> Matrix2x2<Float> in m
         +.negated() },                                                  
      26 +      native: { (n: simd_float2x2) -> simd_float2x2 in -n }    
      27 +    )                                                          
      28 +  }                                                            
      29 +}                                                              

⏺ Bash(swift test 2>&1 | grep -E "error:|handCodedNegation" | head -20)
  ⎿  􀟈  Test handCodedNegation() started.
     􁁛  Test handCodedNegation() passed after 0.001 seconds.

⏺ Let me try a peer macro approach — emit @Test functions as top-level peers
  rather than members:

⏺ Update(Sources/HDXLSIMDSupport/Macros/Macros.swift)
  ⎿  Added 5 lines, removed 5 lines
      71    type: "AddWrapperMatrixConformanceMacro"
      72  )
      73  
      74 -/// Attached member macro that emits a `swift-testing` `@Test` 
         -suite of                                                       
      74 +/// Attached peer macro that emits a `swift-testing` `@Test` su
         +ite of                                                         
      75  /// validation cases for a particular (shape, representation) c
          ombination.
      76  ///
      77  /// Each test exercises the macro-generated wrapper (`Matrix2x2
          <Float>`,
     ...
      79  /// etc.) on a deterministic sweep of inputs. A failure indicat
          es the
      80  /// generated forwarding doesn't agree with the simd routine.
      81  ///
      82 -/// Apply to a `@Suite` struct in the test target:             
      82 +/// Apply to a marker enum or struct in the test target — the m
         +acro generates                                                 
      83 +/// top-level `@Test` functions as peers of that declaration:  
      84  ///
      84 -///     @Suite("Matrix2x2<Float> validation")                  
      85  ///     @AddMatrixConformanceTests(rowCount: 2, columnCount: 2,
           representation: .float)
      86 -///     struct Matrix2x2FloatValidationTests { }               
      87 -@attached(member, names: arbitrary)                            
      86 +///     enum Matrix2x2FloatValidationTests { }                 
      87 +@attached(peer, names: arbitrary)                              
      88  public macro AddMatrixConformanceTests(
      89    rowCount: Int,
      90    columnCount: Int,

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macros/AddMatrixConformanceTestsMacro
       .swift)
  ⎿  Added 5 lines, removed 16 lines
       5  import SwiftSyntax
       6  import SwiftSyntaxMacros
       7  
       8 -/// Attached member macro that expands into a `swift-testing` `
         -@Test` suite                                                   
       8 +/// Peer macro that expands into top-level `swift-testing` `@Te
         +st` functions                                                  
       9  /// for one specific (shape, representation) combination of mac
          ro-generated
      10 -/// matrix conformance.                                        
      11 -///                                                            
      12 -/// Each per-API macrolet (Addition, Negation, ...) contributes
         - the test                                                      
      13 -/// declarations for its slice via `validationTestDeclarations(
         -in:)`. The                                                     
      14 -/// macro composes these in `MatrixMacroletComposition` orderin
         -g, the same                                                    
      15 -/// list that drives the implementation generation. That's the 
         -key                                                            
      16 -/// 1:1-coverage property: every macro-generated slice of behav
         -ior is paired                                                  
      17 -/// with a macro-generated test of that behavior.              
      18 -public struct AddMatrixConformanceTestsMacro: MemberMacro {    
      10 +/// matrix conformance. Each per-API macrolet contributes its s
         +lice's test                                                    
      11 +/// declarations.                                              
      12 +public struct AddMatrixConformanceTestsMacro: PeerMacro {      
      13    public static func expansion(
      14      of node: AttributeSyntax,
      21 -    providingMembersOf declaration: some DeclGroupSyntax,      
      22 -    conformingTo protocols: [TypeSyntax],                      
      15 +    providingPeersOf declaration: some DeclSyntaxProtocol,     
      16      in context: some MacroExpansionContext
      17    ) throws -> [DeclSyntax] {
      18      let rowCount = try MacroArgumentParser.intArgument(node, la
          bel: "rowCount", allowed: 2...4)
      19      let columnCount = try MacroArgumentParser.intArgument(node,
           label: "columnCount", allowed: 2...4)
      20      let representation = try MacroArgumentParser.representation
          Argument(node)
      21      let descriptor = MatrixDescriptor(rowCount: rowCount, colum
          nCount: columnCount, representation: representation)
      29 -    // For test generation we always use the `.wrapper` layer-c
         -ontext so that                                                 
      30 -    // the macrolets emit code referencing the user-facing wrap
         -per type                                                       
      31 -    // (`Matrix2x2<Float>`, etc.). The macrolets are aware of t
         -he concrete                                                    
      32 -    // representation via `descriptor.representation`.         
      22      let layerContext = MatrixLayerContext(layer: .wrapper, desc
          riptor: descriptor)
      23      let macrolets = MatrixMacroletComposition.macrolets(for: de
          scriptor, layer: .wrapper)
      24      return macrolets.flatMap { $0.validationTestDeclarations(in
          : layerContext) }

⏺ Write(Tests/HDXLSIMDSupportTests/Tests/Matrices/Validation/Matrix2x2FloatValid
       ationTests.swift)
  ⎿  Added 5 lines, removed 20 lines
       1  //
       2  //  Matrix2x2FloatValidationTests.swift
       3  //
       4 -//  Macro-driven validation suite for Matrix2x2<Float>. Every p
         -er-API                                                         
       5 -//  macrolet that supports test emission contributes a `@Test` 
         -case here.                                                     
       4 +//  Macro-driven validation suite for Matrix2x2<Float>. Each pe
         +r-API                                                          
       5 +//  macrolet that supports test emission contributes a `@Test` 
         +case here,                                                     
       6 +//  as top-level test functions emitted as peers of the marker 
         +enum.                                                          
       7  //
       8  
       9  import Testing
      10  import simd
      11  @testable import HDXLSIMDSupport
      12  
      12 -@Suite("Matrix2x2<Float> validation")                          
      13 -struct Matrix2x2FloatValidationTests {                         
      14 -                                                               
      15 -  @Test func handCodedNegation() {                             
      16 -    let probes: [[[Float]]] = [                                
      17 -      [[0, 0], [0, 0]],                                        
      18 -      [[1, 2], [3, 4]],                                        
      19 -      [[-1, 1], [2, -2]]                                       
      20 -    ]                                                          
      21 -    validateUnaryEquivalence(                                  
      22 -      "negation",                                              
      23 -      probes: probes,                                          
      24 -      epsilon: 0.0001,                                         
      25 -      wrapped: { (m: Matrix2x2<Float>) -> Matrix2x2<Float> in m
         -.negated() },                                                  
      26 -      native: { (n: simd_float2x2) -> simd_float2x2 in -n }    
      27 -    )                                                          
      28 -  }                                                            
      29 -}                                                              
      13 +@AddMatrixConformanceTests(rowCount: 2, columnCount: 2, represe
         +ntation: .float)                                               
      14 +enum Matrix2x2FloatValidationTests { }                         

⏺ Bash(swift test 2>&1 | grep -E "error:|validateNegation" | head -20)
  ⎿  /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Tests/HDXLSIMD
     SupportTests/Tests/Matrices/Validation/Matrix2x2FloatValidationTests.s
     wift:13:1: error: 'peer' macros are not allowed to introduce arbitrary
     … +44 lines (ctrl+o to expand)
  ⎿  (timeout 10m)

⏺ Let me switch to a freestanding declaration macro:

⏺ Update(Sources/HDXLSIMDSupport/Macros/Macros.swift)
  ⎿  Added 11 lines, removed 9 lines
      71    type: "AddWrapperMatrixConformanceMacro"
      72  )
      73  
      74 -/// Attached peer macro that emits a `swift-testing` `@Test` su
         -ite of                                                         
      75 -/// validation cases for a particular (shape, representation) c
         -ombination.                                                    
      74 +/// Freestanding declaration macro that emits a `swift-testing`
         + `@Test`                                                       
      75 +/// validation suite for a particular (shape, representation) c
         +ombination.                                                    
      76  ///
      77  /// Each test exercises the macro-generated wrapper (`Matrix2x2
          <Float>`,
      78  /// etc.) against the corresponding native simd matrix (`simd_f
          loat2x2`,
      79  /// etc.) on a deterministic sweep of inputs. A failure indicat
          es the
      80  /// generated forwarding doesn't agree with the simd routine.
      81  ///
      82 -/// Apply to a marker enum or struct in the test target — the m
         -acro generates                                                 
      83 -/// top-level `@Test` functions as peers of that declaration:  
      82 +/// Invoke at file scope inside a test source file:            
      83  ///
      85 -///     @AddMatrixConformanceTests(rowCount: 2, columnCount: 2,
         - representation: .float)                                       
      86 -///     enum Matrix2x2FloatValidationTests { }                 
      87 -@attached(peer, names: arbitrary)                              
      88 -public macro AddMatrixConformanceTests(                        
      84 +///     #generateMatrixConformanceTests(                       
      85 +///       rowCount: 2,                                         
      86 +///       columnCount: 2,                                      
      87 +///       representation: .float                               
      88 +///     )                                                      
      89 +@freestanding(declaration, names: arbitrary)                   
      90 +public macro generateMatrixConformanceTests(                   
      91    rowCount: Int,
      92    columnCount: Int,
      93    representation: MatrixRepresentation
      94  ) = #externalMacro(
      95    module: "HDXLSIMDSupportMacroPlugin",
      94 -  type: "AddMatrixConformanceTestsMacro"                       
      96 +  type: "GenerateMatrixConformanceTestsMacro"                  
      97  )

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macros/AddMatrixConformanceTestsMacro
       .swift)
  ⎿  Added 50 lines, removed 10 lines
       5  import SwiftSyntax
       6  import SwiftSyntaxMacros
       7  
       8 -/// Peer macro that expands into top-level `swift-testing` `@Te
         -st` functions                                                  
       9 -/// for one specific (shape, representation) combination of mac
         -ro-generated                                                   
      10 -/// matrix conformance. Each per-API macrolet contributes its s
         -lice's test                                                    
      11 -/// declarations.                                              
      12 -public struct AddMatrixConformanceTestsMacro: PeerMacro {      
       8 +/// Freestanding declaration macro that expands into top-level 
       9 +/// `swift-testing` `@Test` functions for one specific (shape, 
         +representation)                                                
      10 +/// combination of macro-generated matrix conformance. Each per
         +-API macrolet                                                  
      11 +/// contributes its slice's test declarations via              
      12 +/// `validationTestDeclarations(in:)`.                         
      13 +public struct GenerateMatrixConformanceTestsMacro: DeclarationM
         +acro {                                                         
      14    public static func expansion(
      14 -    of node: AttributeSyntax,                                  
      15 -    providingPeersOf declaration: some DeclSyntaxProtocol,     
      15 +    of node: some FreestandingMacroExpansionSyntax,            
      16      in context: some MacroExpansionContext
      17    ) throws -> [DeclSyntax] {
      18 -    let rowCount = try MacroArgumentParser.intArgument(node, la
         -bel: "rowCount", allowed: 2...4)                               
      19 -    let columnCount = try MacroArgumentParser.intArgument(node,
         - label: "columnCount", allowed: 2...4)                         
      20 -    let representation = try MacroArgumentParser.representation
         -Argument(node)                                                 
      18 +    let rowCount = try intArgument(of: node, label: "rowCount",
         + allowed: 2...4)                                               
      19 +    let columnCount = try intArgument(of: node, label: "columnC
         +ount", allowed: 2...4)                                         
      20 +    let representation = try representationArgument(of: node)  
      21      let descriptor = MatrixDescriptor(rowCount: rowCount, colum
          nCount: columnCount, representation: representation)
      22      let layerContext = MatrixLayerContext(layer: .wrapper, desc
          riptor: descriptor)
      23      let macrolets = MatrixMacroletComposition.macrolets(for: de
          scriptor, layer: .wrapper)
      24      return macrolets.flatMap { $0.validationTestDeclarations(in
          : layerContext) }
      25    }
      26  }
      27 +                                                               
      28 +// MARK: - Freestanding argument helpers                       
      29 +                                                               
      30 +private func intArgument(                                      
      31 +  of node: some FreestandingMacroExpansionSyntax,              
      32 +  label: String,                                               
      33 +  allowed: ClosedRange<Int>                                    
      34 +) throws -> Int {                                              
      35 +  guard let expression = expressionArgument(of: node, label: la
         +bel) else {                                                    
      36 +    throw MacroArgumentError.missingArgument(label: label)     
      37 +  }                                                            
      38 +  guard let intLit = expression.as(IntegerLiteralExprSyntax.sel
         +f),                                                            
      39 +        let value = Int(intLit.literal.text) else {            
      40 +    throw MacroArgumentError.invalidArgument(label: label, reas
         +on: "expected integer literal, got `\(expression)`")           
      41 +  }                                                            
      42 +  guard allowed.contains(value) else {                         
      43 +    throw MacroArgumentError.invalidArgument(label: label, reas
         +on: "value \(value) not in allowed range \(allowed)")          
      44 +  }                                                            
      45 +  return value                                                 
      46 +}                                                              
      47 +                                                               
      48 +private func representationArgument(of node: some FreestandingM
         +acroExpansionSyntax) throws -> MatrixRepresentation {          
      49 +  guard let expression = expressionArgument(of: node, label: "r
         +epresentation") else {                                         
      50 +    throw MacroArgumentError.missingArgument(label: "representa
         +tion")                                                         
      51 +  }                                                            
      52 +  guard let representation = MatrixRepresentation.parse(from: e
         +xpression) else {                                              
      53 +    throw MacroArgumentError.invalidArgument(                  
      54 +      label: "representation",                                 
      55 +      reason: "expected `.half | .float | .double`, got `\(expr
         +ession)`"                                                      
      56 +    )                                                          
      57 +  }                                                            
      58 +  return representation                                        
      59 +}                                                              
      60 +                                                               
      61 +private func expressionArgument(of node: some FreestandingMacro
         +ExpansionSyntax, label: String) -> ExprSyntax? {               
      62 +  for argument in node.arguments where argument.label?.text == 
         +label {                                                        
      63 +    return argument.expression                                 
      64 +  }                                                            
      65 +  return nil                                                   
      66 +}                                                              

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Plugin.swift)
  ⎿  Added 1 line, removed 1 line
      11      AddNativeMatrixConformanceMacro.self,
      12      AddStorageMatrixConformanceMacro.self,
      13      AddWrapperMatrixConformanceMacro.self,
      14 -    AddMatrixConformanceTestsMacro.self                        
      14 +    GenerateMatrixConformanceTestsMacro.self                   
      15    ]
      16  }

⏺ Write(Tests/HDXLSIMDSupportTests/Tests/Matrices/Validation/Matrix2x2FloatValid
       ationTests.swift)
  ⎿  Added 1 line, removed 6 lines
       1  //
       2  //  Matrix2x2FloatValidationTests.swift
       3  //
       4 -//  Macro-driven validation suite for Matrix2x2<Float>. Each pe
         -r-API                                                          
       5 -//  macrolet that supports test emission contributes a `@Test` 
         -case here,                                                     
       6 -//  as top-level test functions emitted as peers of the marker 
         -enum.                                                          
       7 -//                                                             
       4  
       5  import Testing
       6  import simd
       7  @testable import HDXLSIMDSupport
       8  
      13 -@AddMatrixConformanceTests(rowCount: 2, columnCount: 2, represe
         -ntation: .float)                                               
      14 -enum Matrix2x2FloatValidationTests { }                         
       9 +#generateMatrixConformanceTests(rowCount: 2, columnCount: 2, re
         +presentation: .float)                                          

⏺ Bash(swift test 2>&1 | grep -E "error:|validateNegation" | head -20)
  ⎿  /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Tests/HDXLSIMD
     SupportTests/Tests/Matrices/Validation/Matrix2x2FloatValidationTests.s
     wift:9:1: error: 'declaration' macros are not allowed to introduce arb
     … +45 lines (ctrl+o to expand)
  ⎿  (timeout 10m)
⏺ Write(Tests/HDXLSIMDSupportTests/Tests/Matrices/Validation/Matrix2x2FloatValid
       ationTests.swift)
  ⎿  Added 3 lines, removed 1 line
       6  import simd
       7  @testable import HDXLSIMDSupport
       8  
       9 -#generateMatrixConformanceTests(rowCount: 2, columnCount: 2, re
         -presentation: .float)                                          
       9 +enum Matrix2x2FloatValidationTests {                           
      10 +  #generateMatrixConformanceTests(rowCount: 2, columnCount: 2, 
         +representation: .float)                                        
      11 +}                                                              

⏺ Bash(swift test 2>&1 | grep -E "error:|validateNegation" | head -10)
  ⎿  error: emit-module command failed with exit code 1 (use -v to see invo
     cation)
     macro expansion @Test:22:26: error: enums must not contain stored prop
     … +14 lines (ctrl+o to expand)

⏺ Write(Tests/HDXLSIMDSupportTests/Tests/Matrices/Validation/Matrix2x2FloatValid
       ationTests.swift)
  ⎿  Added 2 lines, removed 1 line
       6  import simd
       7  @testable import HDXLSIMDSupport
       8  
       9 -enum Matrix2x2FloatValidationTests {                           
       9 +@Suite("Matrix2x2<Float> validation")                          
      10 +struct Matrix2x2FloatValidationTests {                         
      11    #generateMatrixConformanceTests(rowCount: 2, columnCount: 2, 
          representation: .float)
      12  }

⏺ Bash(swift test 2>&1 | grep -E "error:|validateNegation" | head -10)
  ⎿  error: emit-module command failed with exit code 1 (use -v to see invo
     cation)
     macro expansion @Test:23:24: error: cannot use instance member '$s20HD
     … +17 lines (ctrl+o to expand)

⏺ Let me dump the macro expansion to see what's being emitted:

⏺ Bash(swift build -Xswiftc -Xfrontend -Xswiftc -dump-macro-expansions 2>&1 |
      grep -A30 "Matrix2x2FloatValidationTests" | head -50)
  ⎿  (No output)
  ⎿  (timeout 10m)

⏺ Bash(swift build -Xswiftc -Xfrontend -Xswiftc -dump-macro-expansions 2>&1 |
      tail -200 | head -100)
  ⎿  Building for debugging...
     [0/2] Write swift-version--58304C5D6DBC2206.txt
     Build complete! (0.09s)

⏺ Bash(touch
      /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Tests/HDXLSIMDSupp
      ortTests/Tests/Matrices/Validation/Matrix2x2FloatValidationTests.swift &&
      swift…)
  ⎿  @__swiftmacro_20HDXLSIMDSupportTests024Matrix2x2FloatValidationB05Suit
     efMp_.swift
     ------------------------------
     … +91 lines (ctrl+o to expand)

⏺ The nested-macro issue with Swift Testing is intractable. Let me pivot to
  XCTest for generated tests:

⏺ Update(Sources/HDXLSIMDSupport/Macros/Macros.swift)
  ⎿  Added 18 lines, removed 12 lines
      71    type: "AddWrapperMatrixConformanceMacro"
      72  )
      73  
      74 -/// Freestanding declaration macro that emits a `swift-testing`
         - `@Test`                                                       
      75 -/// validation suite for a particular (shape, representation) c
         -ombination.                                                    
      74 +/// Freestanding declaration macro that emits an XCTest test-me
         +thod suite                                                     
      75 +/// validating a particular (shape, representation) combination
         + of the                                                        
      76 +/// macro-generated matrix conformance.                        
      77  ///
      77 -/// Each test exercises the macro-generated wrapper (`Matrix2x2
         -<Float>`,                                                      
      78 -/// etc.) against the corresponding native simd matrix (`simd_f
         -loat2x2`,                                                      
      79 -/// etc.) on a deterministic sweep of inputs. A failure indicat
         -es the                                                         
      80 -/// generated forwarding doesn't agree with the simd routine.  
      78 +/// Each emitted method compares the macro-generated wrapper   
      79 +/// (`Matrix2x2<Float>`, etc.) against the corresponding native
         + simd matrix                                                   
      80 +/// (`simd_float2x2`, etc.) on a deterministic sweep of inputs.
         + A failure                                                     
      81 +/// indicates the generated forwarding doesn't agree with the s
         +imd routine.                                                   
      82  ///
      82 -/// Invoke at file scope inside a test source file:            
      83 +/// We emit XCTest methods rather than `swift-testing` `@Test` 
         +methods                                                        
      84 +/// because the latter's macro expansion fights with nested mac
         +ro emission:                                                   
      85 +/// when `@Test` is applied to a method that was itself introdu
         +ced by an                                                      
      86 +/// outer macro, the testing library's auto-generated metadata 
         +properties                                                     
      87 +/// can't reference the test function. XCTest's runtime discove
         +ry                                                             
      88 +/// (test method names starting with `test`) sidesteps the conf
         +lict.                                                          
      89  ///
      84 -///     #generateMatrixConformanceTests(                       
      85 -///       rowCount: 2,                                         
      86 -///       columnCount: 2,                                      
      87 -///       representation: .float                               
      88 -///     )                                                      
      90 +/// Invoke at type scope inside an XCTestCase subclass:        
      91 +///                                                            
      92 +///     class Matrix2x2FloatValidationTests: XCTestCase {      
      93 +///       #generateMatrixConformanceTests(rowCount: 2, columnCo
         +unt: 2, representation: .float)                                
      94 +///     }                                                      
      95  @freestanding(declaration, names: arbitrary)
      96  public macro generateMatrixConformanceTests(
      97    rowCount: Int,

⏺ Write(Tests/HDXLSIMDSupportTests/Support/MatrixValidationHelpers.swift)
  ⎿  Added 36 lines, removed 28 lines
       1  //
       2  //  MatrixValidationHelpers.swift
       3  //
       4 -//  Imported by macro-generated validation suites. Each generat
         -ed test                                                        
       5 -//  constructs probe matrices inline (as `[[Scalar]]` arrays), 
         -then invokes                                                   
       6 -//  one of these helpers, which compare the macro-generated wra
         -pper output                                                    
       7 -//  against a "ground truth" native-simd computation.          
       4 +//  Imported by macro-generated validation suites (XCTest-based
         +). Each                                                        
       5 +//  generated method constructs probe matrices inline (as `[[Sc
         +alar]]`                                                        
       6 +//  arrays), then invokes one of these helpers which compares t
         +he                                                             
       7 +//  macro-generated wrapper output against a "ground truth" nat
         +ive-simd                                                       
       8 +//  computation.                                               
       9  //
      10  
      11  import Foundation
      11 -import Testing                                                 
      12 +import XCTest                                                  
      13  import simd
      14  @testable import HDXLSIMDSupport
      15  
      16  /// Validates a wrapped unary operation against a native one ac
          ross an array
      17  /// of `[[Scalar]]` probe inputs.
      17 -///                                                            
      18 -/// `Wrapper` is the user-facing matrix wrapper (`Matrix2x2<Flo
         -at>`, etc.).                                                   
      19 -/// `Native` is the underlying simd matrix (`simd_float2x2`, et
         -c.).                                                           
      18  func validateUnaryEquivalence<Wrapper, Native, Scalar>(
      19    _ name: String,
      20    probes: [[[Scalar]]],
      21    epsilon: Wrapper.LInfinityDistance,
      22    wrapped: (Wrapper) -> Wrapper,
      23    native: (Native) -> Native,
      26 -  sourceLocation: SourceLocation = #_sourceLocation            
      24 +  file: StaticString = #filePath,                              
      25 +  line: UInt = #line                                           
      26  ) where
      27    Wrapper: NativeSIMDRepresentable,
      28    Wrapper.NativeSIMDRepresentation == Native,
     ...
      39      let nativeResult = native(nativeInput)
      40      let nativeAsWrapped = Wrapper(nativeSIMDRepresentation: nat
          iveResult)
      41      let distance = wrappedResult.lInfinityDistance(to: nativeAs
          Wrapped)
      43 -    #expect(                                                   
      44 -      distance < epsilon,                                      
      42 +    XCTAssertLessThan(                                         
      43 +      distance,                                                
      44 +      epsilon,                                                 
      45        "[\(name)] L∞ distance \(distance) >= \(epsilon) for prob
          e \(probe). wrapped=\(wrappedResult), native=\(nativeResult)",
      46 -      sourceLocation: sourceLocation                           
      46 +      file: file,                                              
      47 +      line: line                                               
      48      )
      49    }
      50  }
      51  
      51 -/// Validates a wrapped binary operation (same input shape, sam
         -e output shape)                                                
      52 -/// against a native one over the cartesian product of probe in
         -puts.                                                          
      52 +/// Validates a wrapped binary operation (same input shape, sam
         +e output shape).                                               
      53  func validateBinaryEquivalence<Wrapper, Native, Scalar>(
      54    _ name: String,
      55    lhses: [[[Scalar]]],
     ...
      57    epsilon: Wrapper.LInfinityDistance,
      58    wrapped: (Wrapper, Wrapper) -> Wrapper,
      59    native: (Native, Native) -> Native,
      60 -  sourceLocation: SourceLocation = #_sourceLocation            
      60 +  file: StaticString = #filePath,                              
      61 +  line: UInt = #line                                           
      62  ) where
      63    Wrapper: NativeSIMDRepresentable,
      64    Wrapper.NativeSIMDRepresentation == Native,
     ...
      78        let nativeResult = native(nativeLHS, nativeRHS)
      79        let nativeAsWrapped = Wrapper(nativeSIMDRepresentation: n
          ativeResult)
      80        let distance = wrappedResult.lInfinityDistance(to: native
          AsWrapped)
      80 -      #expect(                                                 
      81 -        distance < epsilon,                                    
      81 +      XCTAssertLessThan(                                       
      82 +        distance,                                              
      83 +        epsilon,                                               
      84          "[\(name)] L∞ distance \(distance) >= \(epsilon) for lh
          s=\(lhs), rhs=\(rhs)",
      83 -        sourceLocation: sourceLocation                         
      85 +        file: file,                                            
      86 +        line: line                                             
      87        )
      88      }
      89    }
      90  }
      91  
      89 -/// Validates a wrapped `(matrix, scalar) -> matrix` operation 
         -against a                                                      
      90 -/// native counterpart.                                        
      92 +/// Validates a wrapped `(matrix, scalar) -> matrix` operation.
      93  func validateMatrixScalarEquivalence<Wrapper, Native, Scalar>(
      94    _ name: String,
      95    matrices: [[[Scalar]]],
     ...
       97    epsilon: Wrapper.LInfinityDistance,
       98    wrapped: (Wrapper, Scalar) -> Wrapper,
       99    native: (Native, Scalar) -> Native,
       98 -  sourceLocation: SourceLocation = #_sourceLocation           
      100 +  file: StaticString = #filePath,                             
      101 +  line: UInt = #line                                          
      102  ) where
      103    Wrapper: NativeSIMDRepresentable,
      104    Wrapper.NativeSIMDRepresentation == Native,
     ...
      116        let nativeResult = native(nativeM, scalar)
      117        let nativeAsWrapped = Wrapper(nativeSIMDRepresentation: 
           nativeResult)
      118        let distance = wrappedResult.lInfinityDistance(to: nativ
           eAsWrapped)
      116 -      #expect(                                                
      117 -        distance < epsilon,                                   
      119 +      XCTAssertLessThan(                                      
      120 +        distance,                                             
      121 +        epsilon,                                              
      122          "[\(name)] L∞ distance \(distance) >= \(epsilon) for m
           atrix=\(probe), scalar=\(scalar)",
      119 -        sourceLocation: sourceLocation                        
      123 +        file: file,                                           
      124 +        line: line                                            
      125        )
      126      }
      127    }
     ...
      136    epsilon: Wrapper.LInfinityDistance,
      137    wrapped: (Wrapper, Wrapper, Scalar) -> Wrapper,
      138    native: (Native, Native, Scalar) -> Native,
      134 -  sourceLocation: SourceLocation = #_sourceLocation           
      139 +  file: StaticString = #filePath,                             
      140 +  line: UInt = #line                                          
      141  ) where
      142    Wrapper: NativeSIMDRepresentable,
      143    Wrapper.NativeSIMDRepresentation == Native,
     ...
      158          let nativeResult = native(nativeL, nativeR, scalar)
      159          let nativeAsWrapped = Wrapper(nativeSIMDRepresentation
           : nativeResult)
      160          let distance = wrappedResult.lInfinityDistance(to: nat
           iveAsWrapped)
      155 -        #expect(                                              
      156 -          distance < epsilon,                                 
      161 +        XCTAssertLessThan(                                    
      162 +          distance,                                           
      163 +          epsilon,                                            
      164            "[\(name)] L∞ distance \(distance) >= \(epsilon) for
            lhs=\(lhs), rhs=\(rhs), scalar=\(scalar)",
      158 -          sourceLocation: sourceLocation                      
      165 +          file: file,                                         
      166 +          line: line                                          
      167          )
      168        }
      169      }

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/NegationMacrolet.swift)
  ⎿  Added 1 line, removed 1 line
      74      }
      75      return [
      76        """
      77 -      @Test func validateNegation() {                          
      77 +      func test_negation() {                                   
      78          let probes: [[[\(raw: descriptor.representation.swiftSc
          alarTypeName)]]] = \(raw: descriptor.probeMatricesArrayExpressi
          on)
      79          validateUnaryEquivalence(
      80            "negation",

⏺ Write(Tests/HDXLSIMDSupportTests/Tests/Matrices/Validation/Matrix2x2FloatValid
       ationTests.swift)
  ⎿  Added 2 lines, removed 3 lines
       2  //  Matrix2x2FloatValidationTests.swift
       3  //
       4  
       5 -import Testing                                                 
       5 +import XCTest                                                  
       6  import simd
       7  @testable import HDXLSIMDSupport
       8  
       9 -@Suite("Matrix2x2<Float> validation")                          
      10 -struct Matrix2x2FloatValidationTests {                         
       9 +class Matrix2x2FloatValidationTests: XCTestCase {              
      10    #generateMatrixConformanceTests(rowCount: 2, columnCount: 2, 
          representation: .float)
      11  }

⏺ Bash(swift test 2>&1 | grep -E "error:|test_negation|Negation" | head -20)
  ⎿  [25/52] Compiling HDXLSIMDSupportMacroPlugin NegationMacrolet.swift
     Test Case '-[HDXLSIMDSupportTests.FloatQuaternionValidationTests testO
     utOfPlaceQuaternionNegation]' started.
     … +10 lines (ctrl+o to expand)
  ⎿  (timeout 10m)

⏺ Test passing. Let me batch-add validation tests to the rest of the arithmetic
  macrolets:

  Read 1 file (ctrl+o to expand)

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/MatrixAdditionMacrolet.swi
        ft)
  ⎿  Added 26 lines
      64        ]
      65      }
      66    }
      67 +                                                               
      68 +  func validationTestDeclarations(in context: MatrixLayerContex
         +t) -> [DeclSyntax] {                                           
      69 +    if descriptor.producesBuggyHalfThreeRow { return [] }      
      70 +    let wrapper = descriptor.wrapperTypeInstantiation          
      71 +    let native = descriptor.nativeTypeName                     
      72 +    let nativeAddition: String                                 
      73 +    switch descriptor.representation {                         
      74 +    case .half:  nativeAddition = "simd_add(a, b)"             
      75 +    case .float, .double: nativeAddition = "a + b"             
      76 +    }                                                          
      77 +    return [                                                   
      78 +      """                                                      
      79 +      func test_matrixAddition() {                             
      80 +        let probes: [[[\(raw: descriptor.representation.swiftSc
         +alarTypeName)]]] = \(raw: descriptor.probeMatricesArrayExpressi
         +on)                                                            
      81 +        validateBinaryEquivalence(                             
      82 +          "addition",                                          
      83 +          lhses: probes,                                       
      84 +          rhses: probes,                                       
      85 +          epsilon: \(raw: descriptor.defaultEpsilonLiteral),   
      86 +          wrapped: { (lhs: \(raw: wrapper), rhs: \(raw: wrapper
         +)) -> \(raw: wrapper) in lhs.adding(rhs) },                    
      87 +          native: { (a: \(raw: native), b: \(raw: native)) -> \
         +(raw: native) in \(raw: nativeAddition) }                      
      88 +        )                                                      
      89 +      }                                                        
      90 +      """                                                      
      91 +    ]                                                          
      92 +  }                                                            
      93  }

  Read 1 file (ctrl+o to expand)

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/MatrixSubtractionMacrolet.
        swift)
  ⎿  Added 26 lines
      62        ]
      63      }
      64    }
      65 +                                                               
      66 +  func validationTestDeclarations(in context: MatrixLayerContex
         +t) -> [DeclSyntax] {                                           
      67 +    if descriptor.producesBuggyHalfThreeRow { return [] }      
      68 +    let wrapper = descriptor.wrapperTypeInstantiation          
      69 +    let native = descriptor.nativeTypeName                     
      70 +    let nativeSubtraction: String                              
      71 +    switch descriptor.representation {                         
      72 +    case .half:  nativeSubtraction = "simd_sub(a, b)"          
      73 +    case .float, .double: nativeSubtraction = "a - b"          
      74 +    }                                                          
      75 +    return [                                                   
      76 +      """                                                      
      77 +      func test_matrixSubtraction() {                          
      78 +        let probes: [[[\(raw: descriptor.representation.swiftSc
         +alarTypeName)]]] = \(raw: descriptor.probeMatricesArrayExpressi
         +on)                                                            
      79 +        validateBinaryEquivalence(                             
      80 +          "subtraction",                                       
      81 +          lhses: probes,                                       
      82 +          rhses: probes,                                       
      83 +          epsilon: \(raw: descriptor.defaultEpsilonLiteral),   
      84 +          wrapped: { (lhs: \(raw: wrapper), rhs: \(raw: wrapper
         +)) -> \(raw: wrapper) in lhs.subtracting(rhs) },               
      85 +          native: { (a: \(raw: native), b: \(raw: native)) -> \
         +(raw: native) in \(raw: nativeSubtraction) }                   
      86 +        )                                                      
      87 +      }                                                        
      88 +      """                                                      
      89 +    ]                                                          
      90 +  }                                                            
      91  }

  Read 1 file (ctrl+o to expand)

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/ScalarMultiplicationMacrol
        et.swift)  ⎿  Added 28 lines
      60        ]
      61      }
      62    }
      63 +                                                               
      64 +  func validationTestDeclarations(in context: MatrixLayerContex
         +t) -> [DeclSyntax] {                                           
      65 +    if descriptor.producesBuggyHalfThreeRow { return [] }      
      66 +    let wrapper = descriptor.wrapperTypeInstantiation          
      67 +    let native = descriptor.nativeTypeName                     
      68 +    let scalar = descriptor.representation.swiftScalarTypeName 
      69 +    let nativeMul: String                                      
      70 +    switch descriptor.representation {                         
      71 +    case .half:  nativeMul = "simd_mul(s, m)"                  
      72 +    case .float, .double: nativeMul = "m * s"                  
      73 +    }                                                          
      74 +    return [                                                   
      75 +      """                                                      
      76 +      func test_scalarMultiplication() {                       
      77 +        let probes: [[[\(raw: scalar)]]] = \(raw: descriptor.pr
         +obeMatricesArrayExpression)                                    
      78 +        let scalars: [\(raw: scalar)] = \(raw: descriptor.probe
         +ScalarsArrayExpression)                                        
      79 +        validateMatrixScalarEquivalence(                       
      80 +          "multiplied(by:)",                                   
      81 +          matrices: probes,                                    
      82 +          scalars: scalars,                                    
      83 +          epsilon: \(raw: descriptor.defaultEpsilonLiteral),   
      84 +          wrapped: { (m: \(raw: wrapper), s: \(raw: scalar)) ->
         + \(raw: wrapper) in m.multiplied(by: s) },                     
      85 +          native: { (m: \(raw: native), s: \(raw: scalar)) -> \
         +(raw: native) in \(raw: nativeMul) }                           
      86 +        )                                                      
      87 +      }                                                        
      88 +      """                                                      
      89 +    ]                                                          
      90 +  }                                                            
      91  }

⏺ Let me build and test progress so far:

⏺ Bash(swift test 2>&1 | grep -E "Test Case.*Matrix2x2FloatValidation|error:" |
      head -20)
  ⎿  Test Case '-[HDXLSIMDSupportTests.Matrix2x2FloatValidationTests test_n
     egation]' started.
     Test Case '-[HDXLSIMDSupportTests.Matrix2x2FloatValidationTests test_n
     egation]' passed (0.000 seconds).

⏺ Bash(touch
      /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Tests/HDXLSIMDSupp
      ortTests/Tests/Matrices/Validation/Matrix2x2FloatValidationTests.swift &&
      swift…)
  ⎿  Test Case '-[HDXLSIMDSupportTests.Matrix2x2FloatValidationTests test_m
     atrixAddition]' started.
     Test Case '-[HDXLSIMDSupportTests.Matrix2x2FloatValidationTests test_m
     … +13 lines (ctrl+o to expand)

  Read 1 file (ctrl+o to expand)

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/ScalarDivisionMacrolet.swi
        ft)
  ⎿  Added 29 lines
      63        ]
      64      }
      65    }
      66 +                                                               
      67 +  func validationTestDeclarations(in context: MatrixLayerContex
         +t) -> [DeclSyntax] {                                           
      68 +    if descriptor.producesBuggyHalfThreeRow { return [] }      
      69 +    let wrapper = descriptor.wrapperTypeInstantiation          
      70 +    let native = descriptor.nativeTypeName                     
      71 +    let scalar = descriptor.representation.swiftScalarTypeName 
      72 +    let nativeDiv: String                                      
      73 +    switch descriptor.representation {                         
      74 +    case .half:  nativeDiv = "simd_mul((1 as \(scalar)) / s, m)
         +"                                                              
      75 +    case .float, .double: nativeDiv = "m * ((1 as \(scalar)) / 
         +s)"                                                            
      76 +    }                                                          
      77 +    return [                                                   
      78 +      """                                                      
      79 +      func test_scalarDivision() {                             
      80 +        let probes: [[[\(raw: scalar)]]] = \(raw: descriptor.pr
         +obeMatricesArrayExpression)                                    
      81 +        // Filter zeros to avoid division-by-zero in the test. 
      82 +        let scalars: [\(raw: scalar)] = [\(raw: scalar)(-2), \(
         +raw: scalar)(-1), \(raw: scalar)(1), \(raw: scalar)(2)]        
      83 +        validateMatrixScalarEquivalence(                       
      84 +          "divided(by:)",                                      
      85 +          matrices: probes,                                    
      86 +          scalars: scalars,                                    
      87 +          epsilon: \(raw: descriptor.defaultEpsilonLiteral),   
      88 +          wrapped: { (m: \(raw: wrapper), s: \(raw: scalar)) ->
         + \(raw: wrapper) in m.divided(by: s) },                        
      89 +          native: { (m: \(raw: native), s: \(raw: scalar)) -> \
         +(raw: native) in \(raw: nativeDiv) }                           
      90 +        )                                                      
      91 +      }                                                        
      92 +      """                                                      
      93 +    ]                                                          
      94 +  }                                                            
      95  }

  Read 1 file (ctrl+o to expand)

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/FMAMacrolet.swift)
  ⎿  Added 29 lines
      67        ]
      68      }
      69    }
      70 +                                                               
      71 +  func validationTestDeclarations(in context: MatrixLayerContex
         +t) -> [DeclSyntax] {                                           
      72 +    if descriptor.producesBuggyHalfThreeRow { return [] }      
      73 +    let wrapper = descriptor.wrapperTypeInstantiation          
      74 +    let native = descriptor.nativeTypeName                     
      75 +    let scalar = descriptor.representation.swiftScalarTypeName 
      76 +    let nativeFMA: String                                      
      77 +    switch descriptor.representation {                         
      78 +    case .half:  nativeFMA = "simd_add(a, simd_mul(s, b))"     
      79 +    case .float, .double: nativeFMA = "a + (b * s)"            
      80 +    }                                                          
      81 +    return [                                                   
      82 +      """                                                      
      83 +      func test_fusedMultiplyAdd() {                           
      84 +        let probes: [[[\(raw: scalar)]]] = \(raw: descriptor.pr
         +obeMatricesArrayExpression)                                    
      85 +        let scalars: [\(raw: scalar)] = \(raw: descriptor.probe
         +ScalarsArrayExpression)                                        
      86 +        validateMatrixMatrixScalarEquivalence(                 
      87 +          "adding(_:multipliedBy:)",                           
      88 +          lhses: probes,                                       
      89 +          rhses: probes,                                       
      90 +          scalars: scalars,                                    
      91 +          epsilon: \(raw: descriptor.defaultEpsilonLiteral),   
      92 +          wrapped: { (a: \(raw: wrapper), b: \(raw: wrapper), s
         +: \(raw: scalar)) -> \(raw: wrapper) in a.adding(b, multipliedB
         +y: s) },                                                       
      93 +          native: { (a: \(raw: native), b: \(raw: native), s: \
         +(raw: scalar)) -> \(raw: native) in \(raw: nativeFMA) }        
      94 +        )                                                      
      95 +      }                                                        
      96 +      """                                                      
      97 +    ]                                                          
      98 +  }                                                            
      99  }

  Read 1 file (ctrl+o to expand)

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/FMSMacrolet.swift)
  ⎿  Added 29 lines
      67        ]
      68      }
      69    }
      70 +                                                               
      71 +  func validationTestDeclarations(in context: MatrixLayerContex
         +t) -> [DeclSyntax] {                                           
      72 +    if descriptor.producesBuggyHalfThreeRow { return [] }      
      73 +    let wrapper = descriptor.wrapperTypeInstantiation          
      74 +    let native = descriptor.nativeTypeName                     
      75 +    let scalar = descriptor.representation.swiftScalarTypeName 
      76 +    let nativeFMS: String                                      
      77 +    switch descriptor.representation {                         
      78 +    case .half:  nativeFMS = "simd_sub(a, simd_mul(s, b))"     
      79 +    case .float, .double: nativeFMS = "a - (b * s)"            
      80 +    }                                                          
      81 +    return [                                                   
      82 +      """                                                      
      83 +      func test_fusedMultiplySubtract() {                      
      84 +        let probes: [[[\(raw: scalar)]]] = \(raw: descriptor.pr
         +obeMatricesArrayExpression)                                    
      85 +        let scalars: [\(raw: scalar)] = \(raw: descriptor.probe
         +ScalarsArrayExpression)                                        
      86 +        validateMatrixMatrixScalarEquivalence(                 
      87 +          "subtracting(_:multipliedBy:)",                      
      88 +          lhses: probes,                                       
      89 +          rhses: probes,                                       
      90 +          scalars: scalars,                                    
      91 +          epsilon: \(raw: descriptor.defaultEpsilonLiteral),   
      92 +          wrapped: { (a: \(raw: wrapper), b: \(raw: wrapper), s
         +: \(raw: scalar)) -> \(raw: wrapper) in a.subtracting(b, multip
         +liedBy: s) },                                                  
      93 +          native: { (a: \(raw: native), b: \(raw: native), s: \
         +(raw: scalar)) -> \(raw: native) in \(raw: nativeFMS) }        
      94 +        )                                                      
      95 +      }                                                        
      96 +      """                                                      
      97 +    ]                                                          
      98 +  }                                                            
      99  }

⏺ Now SquareMultiplication (only square shapes) and Transpose:

  Read 1 file (ctrl+o to expand)

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/SquareMultiplicationMacrol
        et.swift)
  ⎿  Added 27 lines
      147        ]
      148      }
      149    }
      150 +                                                              
      151 +  func validationTestDeclarations(in context: MatrixLayerConte
          +xt) -> [DeclSyntax] {                                         
      152 +    guard descriptor.isSquare else { return [] }              
      153 +    if descriptor.producesBuggyHalfThreeRow { return [] }     
      154 +    let wrapper = descriptor.wrapperTypeInstantiation         
      155 +    let native = descriptor.nativeTypeName                    
      156 +    let nativeMul: String                                     
      157 +    switch descriptor.representation {                        
      158 +    case .half:  nativeMul = "simd_mul(a, b)"                 
      159 +    case .float, .double: nativeMul = "a * b"                 
      160 +    }                                                         
      161 +    return [                                                  
      162 +      """                                                     
      163 +      func test_squareMatrixMultiplication() {                
      164 +        let probes: [[[\(raw: descriptor.representation.swiftS
          +calarTypeName)]]] = \(raw: descriptor.probeMatricesArrayExpres
          +sion)                                                         
      165 +        validateBinaryEquivalence(                            
      166 +          "multiplied(onRightBy: Self)",                      
      167 +          lhses: probes,                                      
      168 +          rhses: probes,                                      
      169 +          epsilon: \(raw: descriptor.defaultEpsilonLiteral),  
      170 +          wrapped: { (a: \(raw: wrapper), b: \(raw: wrapper)) 
          +-> \(raw: wrapper) in a.multiplied(onRightBy: b) },           
      171 +          native: { (a: \(raw: native), b: \(raw: native)) -> 
          +\(raw: native) in \(raw: nativeMul) }                         
      172 +        )                                                     
      173 +      }                                                       
      174 +      """                                                     
      175 +    ]                                                         
      176 +  }                                                           
      177  }

  Read 1 file (ctrl+o to expand)

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/TransposeMacrolet.swift)
  ⎿  Added 29 lines
      135        ]
      136      }
      137    }
      138 +                                                              
      139 +  func validationTestDeclarations(in context: MatrixLayerConte
          +xt) -> [DeclSyntax] {                                         
      140 +    // Only validate square transpose for now (result == Self)
          +. Non-square                                                  
      141 +    // transpose returns a different shape; the helper would n
          +eed a separate                                                
      142 +    // signature.                                             
      143 +    guard descriptor.isSquare else { return [] }              
      144 +    if descriptor.producesBuggyHalfThreeRow { return [] }     
      145 +    let wrapper = descriptor.wrapperTypeInstantiation         
      146 +    let native = descriptor.nativeTypeName                    
      147 +    let nativeTranspose: String                               
      148 +    switch descriptor.representation {                        
      149 +    case .half:  nativeTranspose = "simd_transpose(m)"        
      150 +    case .float, .double: nativeTranspose = "m.transpose"     
      151 +    }                                                         
      152 +    return [                                                  
      153 +      """                                                     
      154 +      func test_transpose() {                                 
      155 +        let probes: [[[\(raw: descriptor.representation.swiftS
          +calarTypeName)]]] = \(raw: descriptor.probeMatricesArrayExpres
          +sion)                                                         
      156 +        validateUnaryEquivalence(                             
      157 +          "transposed",                                       
      158 +          probes: probes,                                     
      159 +          epsilon: \(raw: descriptor.defaultEpsilonLiteral),  
      160 +          wrapped: { (m: \(raw: wrapper)) -> \(raw: wrapper) i
          +n m.transposed() },                                           
      161 +          native: { (m: \(raw: native)) -> \(raw: native) in \
          +(raw: nativeTranspose) }                                      
      162 +        )                                                     
      163 +      }                                                       
      164 +      """                                                     
      165 +    ]                                                         
      166 +  }                                                           
      167  }

⏺ Now batch-generate test files for all 27 shape × representation combos:

⏺ Bash(cd /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Tests/HDXLSIMD
      SupportTests/Tests/Matrices/Validation/…)
  ⎿  27

⏺ Bash(swift test 2>&1 | grep -E "error:" | head -20)
  ⎿  (No output)
  ⎿  (timeout 10m)

⏺ Bash(swift test 2>&1 | grep -E "Test
      Suite.*Validation|test_negation|test_matrixAddition|test_matrixSubtraction
      |test_scalarMultiplication|test_scalarDivision|test_fu…)
  ⎿  210

⏺ Bash(swift test 2>&1 | grep "failed" | head -10)
  ⎿  (No output)

⏺ Bash(swift test 2>&1 | tail -15)
  ⎿  Test Case '-[HDXLSIMDSupportTests.QuaternionMemoryLayoutTests testDoub
     leQuaternionNoPaddingAdded]' passed (0.000 seconds).
     Test Case '-[HDXLSIMDSupportTests.QuaternionMemoryLayoutTests testFloa
     … +15 lines (ctrl+o to expand)

⏺ Excellent — 317 tests pass, 0 failures. Up from 133 baseline → 184 new
  macro-generated validation tests, all passing. Let me add a few more
  validations to round out coverage:

  Read 1 file (ctrl+o to expand)
⏺ Let me add Inversion validation (square shapes only, requires non-singular
  probes):

  Read 1 file (ctrl+o to expand)

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/InversionMacrolet.swift)
  ⎿  Added 55 lines
       88        ]
       89      }
       90    }
       91 +                                                              
       92 +  func validationTestDeclarations(in context: MatrixLayerConte
          +xt) -> [DeclSyntax] {                                         
       93 +    guard descriptor.isSquare else { return [] }              
       94 +    // Skip half-3x3: our pure-Swift adjugate formula IS the i
          +mplementation;                                                
       95 +    // there's no independent ground truth via simd_inverse to
          + compare against.                                             
       96 +    if descriptor.producesBuggyHalfThreeRow { return [] }     
       97 +    let wrapper = descriptor.wrapperTypeInstantiation         
       98 +    let native = descriptor.nativeTypeName                    
       99 +    let scalar = descriptor.representation.swiftScalarTypeName
      100 +    let nativeInverse: String                                 
      101 +    switch descriptor.representation {                        
      102 +    case .half:  nativeInverse = "simd_inverse(m)"            
      103 +    case .float, .double: nativeInverse = "m.inverse"         
      104 +    }                                                         
      105 +    // Only use non-singular probes — invertible matrices. We 
          +hardcode a few                                                
      106 +    // here rather than relying on the macrolet's broader prob
          +e sweep                                                       
      107 +    // (which includes the zero matrix).                      
      108 +    let identityRows = (0..<descriptor.rowCount).map { r -> St
          +ring in                                                       
      109 +      let cells = (0..<descriptor.columnCount).map { c in "\(s
          +calar)(\(r == c ? 1 : 0))" }                                  
      110 +      return "[" + cells.joined(separator: ", ") + "]"        
      111 +    }                                                         
      112 +    let identity = "[" + identityRows.joined(separator: ", ") 
          ++ "]"                                                         
      113 +    let upperRows = (0..<descriptor.rowCount).map { r -> Strin
          +g in                                                          
      114 +      let cells = (0..<descriptor.columnCount).map { c -> Stri
          +ng in                                                         
      115 +        if r == c { return "\(scalar)(2)" }                   
      116 +        if c > r { return "\(scalar)(1)" }                    
      117 +        return "\(scalar)(0)"                                 
      118 +      }                                                       
      119 +      return "[" + cells.joined(separator: ", ") + "]"        
      120 +    }                                                         
      121 +    let upper = "[" + upperRows.joined(separator: ", ") + "]" 
      122 +    let diagRows = (0..<descriptor.rowCount).map { r -> String
          + in                                                           
      123 +      let cells = (0..<descriptor.columnCount).map { c in "\(s
          +calar)(\(r == c ? r + 2 : 0))" }                              
      124 +      return "[" + cells.joined(separator: ", ") + "]"        
      125 +    }                                                         
      126 +    let diag = "[" + diagRows.joined(separator: ", ") + "]"   
      127 +    return [                                                  
      128 +      """                                                     
      129 +      func test_matrixInversion() {                           
      130 +        let probes: [[[\(raw: scalar)]]] = [                  
      131 +          \(raw: identity),                                   
      132 +          \(raw: upper),                                      
      133 +          \(raw: diag)                                        
      134 +        ]                                                     
      135 +        validateUnaryEquivalence(                             
      136 +          "inverted",                                         
      137 +          probes: probes,                                     
      138 +          epsilon: \(raw: descriptor.defaultEpsilonLiteral),  
      139 +          wrapped: { (m: \(raw: wrapper)) -> \(raw: wrapper) i
          +n m.inverted() },                                             
      140 +          native: { (m: \(raw: native)) -> \(raw: native) in \
          +(raw: nativeInverse) }                                        
      141 +        )                                                     
      142 +      }                                                       
      143 +      """                                                     
      144 +    ]                                                         
      145 +  }                                                           
      146  }

⏺ Bash(swift test 2>&1 | tail -10)
  ⎿  Test Suite 'QuaternionMemoryLayoutTests' passed at 2026-05-14 22:15:57
     .458.
         Executed 3 tests, with 0 failures (0 unexpected) in 0.000 (0.000) sec
     … +12 lines (ctrl+o to expand)


⏺ Bash(touch
      /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Tests/HDXLSIMDSupp
      ortTests/Tests/Matrices/Validation/Matrix2x2FloatValidationTests.swift &&
      swift…)
  ⎿  Test Suite 'QuaternionMemoryLayoutTests' passed at 2026-05-14 22:16:05
     .954.
         Executed 3 tests, with 0 failures (0 unexpected) in 0.000 (0.000) sec
     … +12 lines (ctrl+o to expand)


⏺ Bash(touch /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Tests/HDXLS
      IMDSupportTests/Tests/Matrices/Validation/*.swift && swift test 2>&1 |
      tail -5)
  ⎿      Executed 325 tests, with 0 failures (0 unexpected) in 0.922 (0.936)
     s
     econds
     􀟈  Test run started.
     … +3 lines (ctrl+o to expand)

⏺ Solid progress — 325 tests pass, 192 new validation tests. Let me also save
  memory notes about this big effort.

  Listed 1 directory (ctrl+o to expand)

⏺ Bash(mkdir -p
      /Users/prb/.claude/projects/-Users-prb-github-HDXLSIMDSupport/memory/ &&
      ls /Users/prb/.claude/projects/-Users-prb-github-HDXLSIMDSupport/memory/)
  ⎿  (No output)

  Wrote 3 memories (ctrl+o to expand)

⏺ Let me give a clear progress summary to the user:

  Major milestone reached:

  Implementation (Phases 1-4 complete):
  - Macro plugin (HDXLSIMDSupportMacroPlugin) with MatrixDescriptor IR,
  MatrixLayerContext, SIMDMatrixMacrolet protocol, and 30+ macrolets covering
  the entire MatrixProtocol API surface
  - 3 attached macros: @AddNativeMatrixConformance,
  @AddStorageMatrixConformance, @AddWrapperMatrixConformance
  - All 27 storage types + 27 native conformances + 9 wrapper types migrated to
  macro-driven generation
  - Half-precision overlay-bug workarounds (half-3-row column-wise pure-Swift,
  half-3x3 adjugate inversion, half-3x3 quaternion-via-4x4-slice) encoded into
  macrolets so the bugs the merged PR fixed by hand are now systematically
  prevented
  - Each macrolet handles all three layers (native/storage/wrapper) with
  per-representation dispatch (float/double Swift operators vs half simd_* C
  functions vs half-3-row column-wise)

  Validation tests (Phase 4.5 complete):
  - New freestanding #generateMatrixConformanceTests macro emits XCTest cases
  (chose XCTest over swift-testing because @Test doesn't tolerate being added to
   macro-introduced methods)
  - 8 macrolets emit validation tests: Negation, Matrix +/-, Scalar ×/÷, FMA,
  FMS, Square multiplication, Transpose, Inversion
  - 27 test files (9 shapes × 3 reps) instantiate the macro
  - 325 tests pass total (133 baseline + 192 new macro-generated validation 
  tests)
  - Half-3-row buggy shapes correctly skipped (no independent ground truth
  available)

  Still pending:
  - Phase 5: Quaternion migration (1 wrapper + 3 storages + 3 natives via new
  quaternion-specific macrolets)
  - Phase 6: Demolish Passthrough protocol, rename passthroughValue → storage,
  demote storage types to @usableFromInline internal
  - Optional expansions: Validation for cross-shape multiplication, vector
  multiplication, determinant, scalar add/sub, linear combination

  Given the size of the change so far, want me to:
  1. Continue with Phase 5 (quaternions)
  2. Continue with Phase 6 (Passthrough demolition)
  3. Add more macro-driven validation tests (cross-shape mult, etc.)
  4. Stop here and ask you to review/commit

  The build is green and there are no regressions; this is a safe stopping
  point.

✻ Cooked for 1h 24m 27s

❯ I've reviewed this work and so far it looks good to me. Please commit this    
  work, then I'll give the next instructions.                                   

⏺ Let me check the current state and prepare a commit:

⏺ Bash(git status)
  ⎿  On branch plx/raleigh
     Changes to be committed:
       (use "git restore --staged <file>..." to unstage)
     … +214 lines (ctrl+o to expand)

⏺ Bash(git diff --stat)
  ⎿   Sources/HDXLSIMDSupport/Macros/Macros.swift        |  31 ++
      .../Matrices/Matrices/Matrix2x3.swift              |  89 +---
      .../Matrices/Matrices/Matrix2x4.swift              |  89 +---
     … +98 lines (ctrl+o to expand)

⏺ Bash(git log --oneline -5)
  ⎿  c9d2020 Add Float16 support to ExtendedSIMDScalar (#5)
     9860129 Add _modify accessors to passthrough/wrapper computed properti
     es (#4)
     … +4 lines (ctrl+o to expand)

⏺ Let me look at unstaged untracked file paths to ensure no surprises:

⏺ Bash(git ls-files --others --exclude-standard | head -50)
  ⎿  Sources/HDXLSIMDSupportMacroPlugin/Macrolets/QuaternionConstructorMacr
     olet.swift
     Sources/HDXLSIMDSupportMacroPlugin/Macrolets/ValidationTestSupport.swi
     … +36 lines (ctrl+o to expand)

⏺ All clean — only refactor-related files. Let me stage and commit:

⏺ Bash(git add Sources/ Tests/ Package.swift && git status --short | head -30)
  ⎿  M  Package.swift
     A  Sources/HDXLSIMDSupport/Macros/Macros.swift
     M  Sources/HDXLSIMDSupport/Matrices/Matrices/Matrix2x2.swift
     … +33 lines (ctrl+o to expand)
⏺ Bash(git commit -m "$(cat <<'EOF'
      Migrate matrix conformances to macro-generated code; add macro-driven
      validation tests.…)
  ⎿  [plx/raleigh 24e0eed] Migrate matrix conformances to macro-generated c
     ode; add macro-driven validation tests.
      164 files changed, 4996 insertions(+), 18661 deletions(-)
     … +151 lines (ctrl+o to expand)

⏺ Bash(git log --oneline -3)
  ⎿  24e0eed Migrate matrix conformances to macro-generated code; add macro
     -driven validation tests.
     c9d2020 Add Float16 support to ExtendedSIMDScalar (#5)
     … +2 lines (ctrl+o to expand)

⏺ Committed as 24e0eed. 164 files changed: +4,996 lines / −18,661 lines (net
  −13,665 — the macro plugin replaces a lot of boilerplate). Ready for your next
   instructions.

✻ Churned for 1m 17s

❯ Ok, great. What I'd like you to do is proactively compact, and then resume    
  the original goal (e.g. resume work towards that goal, starting with phase    
  5). Is that something you can do on your own, or will I need to trigger the   
  compact/goal-resumption?                                                      

⏺ I don't have a tool to trigger /compact myself — that's a user-side slash
  command. But I'm well-prepared for the auto-compaction (memory files saved,
  task list current, work committed). I'll proceed with Phase 5 now; if context
  fills, auto-compaction will preserve everything and the memory + task pointers
   will let me resume cleanly.

⏺ Let me explore the Quaternion side to understand what needs migrating:

  Searched for 1 pattern, read 6 files (ctrl+o to expand)

⏺ I have enough context. Let me build the Quaternion macro infrastructure
  efficiently — IR, macrolet protocol, all macrolets, and three umbrella macros:

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/IR/QuaternionDescriptor.swift)
  ⎿  Wrote 41 lines to
     Sources/HDXLSIMDSupportMacroPlugin/IR/QuaternionDescriptor.swift
       2 //  QuaternionDescriptor.swift
       3 //
       4 
       5 import SwiftSyntax
       6 
         identified byaternion macro expansion. A quaternion is uniquely 
       8 /// its scalar `representation` (.half / .float / .double); shap
         e is fixed.
       9 struct QuaternionDescriptor: Equatable {
      10   let representation: MatrixRepresentation
     … +39 lines (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/IR/SIMDQuaternionMacrolet.swift)
  ⎿  Wrote 65 lines to
     Sources/HDXLSIMDSupportMacroPlugin/IR/SIMDQuaternionMacrolet.swift
       2 //  SIMDQuaternionMacrolet.swift
       3 //
       4 
       5 import SwiftSyntax
       6 
       7 /// Layer context for quaternion macrolets.
       8 struct QuaternionLayerContext {
       9   let layer: MatrixLayer  // re-uses .native / .storage / .wrapp
         er
      10   let descriptor: QuaternionDescriptor
     … +61 lines (ctrl+o to expand)

⏺ Now the macrolets — I'll bundle related slices into a single file for
  efficiency:

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/QuaternionMacrolets.swift)
  ⎿  Wrote 1104 lines to
     Sources/HDXLSIMDSupportMacroPlugin/Macrolets/QuaternionMacrolets.swift
       2 //  QuaternionMacrolets.swift
       3 //
       4 //  All quaternion-specific macrolets, bundled in one file for c
       5 //  Each struct implements a single slice of `QuaternionProtocol
         ` (or a
       6 //  cross-cutting conformance like Hashable/Codable) and emits t
       7 //  code for native / storage / wrapper layers.
       8 //
       9 
      10 import SwiftSyntax
     … +1262 lines (ctrl+o to expand)

⏺ Now the composition + macros:

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macros/QuaternionMacroletComposition.
       swift)
  ⎿  Wrote 29 lines to Sources/HDXLSIMDSupportMacroPlugin/Macros/Quaternion
     MacroletComposition.swift
       1 //
       2 //  QuaternionMacroletComposition.swift
       3 //
       4 
       5 import SwiftSyntax
       6 
       7 enum QuaternionMacroletComposition {
       8   static func macrolets(
       9     for descriptor: QuaternionDescriptor,
      10     layer: MatrixLayer
     … +31 lines (ctrl+o to expand)

⏺ Write(Sources/HDXLSIMDSupportMacroPlugin/Macros/AddQuaternionConformanceMacros
       .swift)
  ⎿  Wrote 54 lines to Sources/HDXLSIMDSupportMacroPlugin/Macros/AddQuatern
     ionConformanceMacros.swift
       2 //  AddQuaternionConformanceMacros.swift
       3 //
       4 
       5 import SwiftSyntax
       6 import SwiftSyntaxMacros
       7 
       8 /// Native quaternion conformance macro (applied to `extension s
         imd_quatf`,
       9 /// `extension simd_quatd`, `extension simd_quath`).
      10 public struct AddNativeQuaternionConformanceMacro: MemberMacro {
     … +55 lines (ctrl+o to expand)

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Plugin.swift)
  ⎿  Added 4 lines, removed 1 line
      11      AddNativeMatrixConformanceMacro.self,
      12      AddStorageMatrixConformanceMacro.self,
      13      AddWrapperMatrixConformanceMacro.self,
      14 -    GenerateMatrixConformanceTestsMacro.self                   
      14 +    GenerateMatrixConformanceTestsMacro.self,                  
      15 +    AddNativeQuaternionConformanceMacro.self,                  
      16 +    AddStorageQuaternionConformanceMacro.self,                 
      17 +    AddWrapperQuaternionConformanceMacro.self                  
      18    ]
      19  }

⏺ Update(Sources/HDXLSIMDSupport/Macros/Macros.swift)
  ⎿  Added 28 lines
       71    type: "AddWrapperMatrixConformanceMacro"
       72  )
       73  
       74 +/// Attached member macro emitting the QuaternionProtocol conf
          +ormance for a                                                 
       75 +/// native `simd_quat{f,d,h}` extension.                      
       76 +@attached(member, names: arbitrary)                           
       77 +public macro AddNativeQuaternionConformance(                  
       78 +  representation: MatrixRepresentation                        
       79 +) = #externalMacro(                                           
       80 +  module: "HDXLSIMDSupportMacroPlugin",                       
       81 +  type: "AddNativeQuaternionConformanceMacro"                 
       82 +)                                                             
       83 +                                                              
       84 +/// Attached member macro emitting the QuaternionProtocol conf
          +ormance for a                                                 
       85 +/// per-representation storage struct (`FloatQuaternionStorage
          +`, etc.).                                                     
       86 +@attached(member, names: arbitrary)                           
       87 +public macro AddStorageQuaternionConformance(                 
       88 +  representation: MatrixRepresentation                        
       89 +) = #externalMacro(                                           
       90 +  module: "HDXLSIMDSupportMacroPlugin",                       
       91 +  type: "AddStorageQuaternionConformanceMacro"                
       92 +)                                                             
       93 +                                                              
       94 +/// Attached member macro emitting the QuaternionProtocol conf
          +ormance for the                                               
       95 +/// generic `Quaternion<Scalar>` wrapper.                     
       96 +@attached(member, names: arbitrary)                           
       97 +public macro AddWrapperQuaternionConformance() = #externalMacr
          +o(                                                            
       98 +  module: "HDXLSIMDSupportMacroPlugin",                       
       99 +  type: "AddWrapperQuaternionConformanceMacro"                
      100 +)                                                             
      101 +                                                              
      102  /// Freestanding declaration macro that emits an XCTest test-m
           ethod suite
      103  /// validating a particular (shape, representation) combinatio
           n of the
      104  /// macro-generated matrix conformance.

⏺ Bash(swift build 2>&1 | grep -E "error:" | head -10)
  ⎿  (No output)
  ⎿  (timeout 10m)

⏺ Bash(swift build 2>&1 | tail -10)
  ⎿  Building for debugging...
     [0/2] Write swift-version--58304C5D6DBC2206.txt
     Build complete! (0.09s)
  Searched for 1 pattern, read 1 file (ctrl+o to expand)

⏺ Now let me delete that file and migrate the quaternion types:

⏺ Bash(rm /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDXLSI
      MDSupport/NumericAggregate/Conformances/Quaternion+NumericAggregate.swift
      && echo done)
  ⎿  done

⏺ Write(Sources/HDXLSIMDSupport/Quaternion/NativeConformances/simd_quatf+Quatern
       ionProtocol.swift)
  ⎿  Added 2 lines, removed 467 lines
        5  import Foundation
        6  import simd
        7  
        8 -extension simd_quatf : QuaternionProtocol {                   
        9 -                                                              
       10 -  // ---------------------------------------------------------
          ---------------- //                                            
       11 -  // MARK: Compatible Types                                   
       12 -  // ---------------------------------------------------------
          ---------------- //                                            
       13 -                                                              
       14 -  public typealias Scalar = Float                             
       15 -  public typealias CompatibleMatrix3x3 = simd_float3x3        
       16 -  public typealias CompatibleMatrix4x4 = simd_float4x4        
       17 -                                                              
       18 -  // ---------------------------------------------------------
          ---------------- //                                            
       19 -  // MARK: Initialization                                     
       20 -  // ---------------------------------------------------------
          ---------------- //                                            
       21 -                                                              
       22 -  // already exists:                                          
       23 -  // init()                                                   
       24 -                                                              
       25 -  // we supply:                                               
       26 -  @inlinable                                                  
       27 -  public init(i: Scalar, j: Scalar, k: Scalar, real: Scalar) {
       28 -    self.init(                                                
       29 -      ix: i,                                                  
       30 -      iy: j,                                                  
       31 -      iz: k,                                                  
       32 -      r: real                                                 
       33 -    )                                                         
       34 -  }                                                           
       35 -                                                              
       36 -  // we supply:                                               
       37 -  @inlinable                                                  
       38 -  public init(x: Scalar, y: Scalar, z: Scalar, real: Scalar) {
       39 -    self.init(                                                
       40 -      ix: x,                                                  
       41 -      iy: y,                                                  
       42 -      iz: z,                                                  
       43 -      r: real                                                 
       44 -    )                                                         
       45 -  }                                                           
       46 -                                                              
       47 -  // we supply (rename):                                      
       48 -  @inlinable                                                  
       49 -  public init(                                                
       50 -    realComponent: Scalar,                                    
       51 -    imaginaryComponent: Vector3                               
       52 -  ) {                                                         
       53 -    self.init(                                                
       54 -      real: realComponent,                                    
       55 -      imag: imaginaryComponent                                
       56 -    )                                                         
       57 -  }                                                           
       58 -                                                              
       59 -  // we supply (rename):                                      
       60 -  @inlinable                                                  
       61 -  public init(                                                
       62 -    angleInRadians angle: Scalar,                             
       63 -    rotationAxis axis: Vector3                                
       64 -  ) {                                                         
       65 -    self.init(                                                
       66 -      angle: angle,                                           
       67 -      axis: axis                                              
       68 -    )                                                         
       69 -  }                                                           
       70 -                                                              
       71 -  // we supply (rename):                                      
       72 -  @inlinable                                                  
       73 -  public init(                                                
       74 -    rotating origin: Vector3,                                 
       75 -    onto destination: Vector3                                 
       76 -  ) {                                                         
       77 -    self.init(                                                
       78 -      from: origin,                                           
       79 -      to: destination                                         
       80 -    )                                                         
       81 -  }                                                           
       82 -                                                              
       83 -  // we supply (rename):                                      
       84 -  @inlinable                                                  
       85 -  public init(rotationMatrix matrix: CompatibleMatrix3x3) {   
       86 -    self.init(matrix)                                         
       87 -  }                                                           
       88 -                                                              
       89 -  // we supply (rename):                                      
       90 -  @inlinable                                                  
       91 -  public init(rotationMatrix matrix: CompatibleMatrix4x4) {   
       92 -    self.init(matrix)                                         
       93 -  }                                                           
       94 -                                                              
       95 -  // ---------------------------------------------------------
          ---------------- //                                            
       96 -  // MARK: Other Constructors                                 
       97 -  // ---------------------------------------------------------
          ---------------- //                                            
       98 -                                                              
       99 -  // we supply:                                               
      100 -  @inlinable                                                  
      101 -  public static func slerp(                                   
      102 -    _ q0: simd_quatf,                                         
      103 -    _ q1: simd_quatf,                                         
      104 -    _ t: Scalar,                                              
      105 -    strategy: QuaternionSlerpStrategy                         
      106 -  ) -> simd_quatf {                                           
      107 -    switch strategy {                                         
      108 -    case .automatic:                                          
      109 -      return simd_quatf.slerpShortest(                        
      110 -        q0,                                                   
      111 -        q1,                                                   
      112 -        t                                                     
      113 -      )                                                       
      114 -    case .shortest:                                           
      115 -      return simd_quatf.slerpShortest(                        
      116 -        q0,                                                   
      117 -        q1,                                                   
      118 -        t                                                     
      119 -      )                                                       
      120 -    case .longest:                                            
      121 -      return simd_quatf.slerpLongest(                         
      122 -        q0,                                                   
      123 -        q1,                                                   
      124 -        t                                                     
      125 -      )                                                       
      126 -    }                                                         
      127 -  }                                                           
      128 -                                                              
      129 -  // we supply:                                               
      130 -  @inlinable                                                  
      131 -  public static func slerpShortest(                           
      132 -    _ q0: simd_quatf,                                         
      133 -    _ q1: simd_quatf,                                         
      134 -    _ t: Scalar                                               
      135 -  ) -> simd_quatf {                                           
      136 -    return simd_slerp(                                        
      137 -      q0,                                                     
      138 -      q1,                                                     
      139 -      t                                                       
      140 -    )                                                         
      141 -  }                                                           
      142 -                                                              
      143 -  // we supply:                                               
      144 -  @inlinable                                                  
      145 -  public static func slerpLongest(                            
      146 -    _ q0: simd_quatf,                                         
      147 -    _ q1: simd_quatf,                                         
      148 -    _ t: Scalar                                               
      149 -  ) -> simd_quatf {                                           
      150 -    return simd_slerp_longest(                                
      151 -      q0,                                                     
      152 -      q1,                                                     
      153 -      t                                                       
      154 -    )                                                         
      155 -  }                                                           
      156 -                                                              
      157 -  // we supply:                                               
      158 -  @inlinable                                                  
      159 -  public static func bezier(                                  
      160 -    q0: simd_quatf,                                           
      161 -    q1: simd_quatf,                                           
      162 -    q2: simd_quatf,                                           
      163 -    q3: simd_quatf,                                           
      164 -    t: Scalar                                                 
      165 -  ) -> simd_quatf {                                           
      166 -    return simd_bezier(                                       
      167 -      q0,                                                     
      168 -      q1,                                                     
      169 -      q2,                                                     
      170 -      q3,                                                     
      171 -      t                                                       
      172 -    )                                                         
      173 -  }                                                           
      174 -                                                              
      175 -  // we supply:                                               
      176 -  @inlinable                                                  
      177 -  public static func spline(                                  
      178 -    q0: simd_quatf,                                           
      179 -    q1: simd_quatf,                                           
      180 -    q2: simd_quatf,                                           
      181 -    q3: simd_quatf,                                           
      182 -    t: Scalar                                                 
      183 -  ) -> simd_quatf {                                           
      184 -    return simd_spline(                                       
      185 -      q0,                                                     
      186 -      q1,                                                     
      187 -      q2,                                                     
      188 -      q3,                                                     
      189 -      t                                                       
      190 -    )                                                         
      191 -  }                                                           
      192 -                                                              
      193 -  // ---------------------------------------------------------
          ---------------- //                                            
      194 -  // MARK: Basic Properties                                   
      195 -  // ---------------------------------------------------------
          ---------------- //                                            
      196 -                                                              
      197 -  // we supply (rename):                                      
      198 -  @inlinable                                                  
      199 -  public var realComponent: Scalar {                          
      200 -    get {                                                     
      201 -      return real                                             
      202 -    }                                                         
      203 -    set {                                                     
      204 -      real = newValue                                         
      205 -    }                                                         
      206 -    _modify {                                                 
      207 -      yield &real                                             
      208 -    }                                                         
      209 -  }                                                           
      210 -                                                              
      211 -  // we supply (rename):                                      
      212 -  @inlinable                                                  
      213 -  public var imaginaryComponent: Vector3 {                    
      214 -    get {                                                     
      215 -      return imag                                             
      216 -    }                                                         
      217 -    set {                                                     
      218 -      imag = newValue                                         
      219 -    }                                                         
      220 -    _modify {                                                 
      221 -      yield &imag                                             
      222 -    }                                                         
      223 -  }                                                           
      224 -                                                              
      225 -  // we supply (rename):                                      
      226 -  @inlinable                                                  
      227 -  public var angleInRadians: Scalar {                         
      228 -    get {                                                     
      229 -      return angle                                            
      230 -    }                                                         
      231 -  }                                                           
      232 -                                                              
      233 -  // we supply (rename):                                      
      234 -  @inlinable                                                  
      235 -  public var rotationAxis: Vector3 {                          
      236 -    get {                                                     
      237 -      return axis                                             
      238 -    }                                                         
      239 -  }                                                           
      240 -                                                              
      241 -  // already exists:                                          
      242 -  // var length: Scalar { get }                               
      243 -                                                              
      244 -  // ---------------------------------------------------------
          ---------------- //                                            
      245 -  // MARK: Applying to Vectors                                
      246 -  // ---------------------------------------------------------
          ---------------- //                                            
      247 -                                                              
      248 -  // we supply (rename):                                      
      249 -  @inlinable                                                  
      250 -  public func apply(to vector: Vector3) -> Vector3 {          
      251 -    return act(vector)                                        
      252 -  }                                                           
      253 -                                                              
      254 -  // ---------------------------------------------------------
          ---------------- //                                            
      255 -  // MARK: Normalization                                      
      256 -  // ---------------------------------------------------------
          ---------------- //                                            
      257 -                                                              
      258 -  @inlinable                                                  
      259 -  public func normalized() -> simd_quatf {                    
      260 -    return normalized                                         
      261 -  }                                                           
      262 -                                                              
      263 -  @inlinable                                                  
      264 -  public mutating func formNormalization() {                  
      265 -    self = normalized                                         
      266 -  }                                                           
      267 -                                                              
      268 -  // ---------------------------------------------------------
          ---------------- //                                            
      269 -  // MARK: Norms                                              
      270 -  // ---------------------------------------------------------
          ---------------- //                                            
      271 -                                                              
      272 -  @inlinable                                                  
      273 -  public var componentwiseMagnitudeSquared: Scalar {          
      274 -    get {                                                     
      275 -      return simd_length_squared(vector)                      
      276 -    }                                                         
      277 -  }                                                           
      278 -                                                              
      279 -  // ---------------------------------------------------------
          ---------------- //                                            
      280 -  // MARK: Inversion                                          
      281 -  // ---------------------------------------------------------
          ---------------- //                                            
      282 -                                                              
      283 -  @inlinable                                                  
      284 -  public func inverted() -> simd_quatf {                      
      285 -    return inverse                                            
      286 -  }                                                           
      287 -                                                              
      288 -  @inlinable                                                  
      289 -  public mutating func formInverse() {                        
      290 -    self = inverse                                            
      291 -  }                                                           
      292 -                                                              
      293 -  // ---------------------------------------------------------
          ---------------- //                                            
      294 -  // MARK: Conjugation                                        
      295 -  // ---------------------------------------------------------
          ---------------- //                                            
      296 -                                                              
      297 -  @inlinable                                                  
      298 -  public func conjugated() -> simd_quatf {                    
      299 -    return conjugate                                          
      300 -  }                                                           
      301 -                                                              
      302 -  @inlinable                                                  
      303 -  public mutating func formConjugate() {                      
      304 -    self = conjugate                                          
      305 -  }                                                           
      306 -                                                              
      307 -  // ---------------------------------------------------------
          ---------------- //                                            
      308 -  // MARK: Negation                                           
      309 -  // ---------------------------------------------------------
          ---------------- //                                            
      310 -                                                              
      311 -  @inlinable                                                  
      312 -  public func negated() -> simd_quatf {                       
      313 -    return -self                                              
      314 -  }                                                           
      315 -                                                              
      316 -  @inlinable                                                  
      317 -  public mutating func formNegation() {                       
      318 -    self = -self                                              
      319 -  }                                                           
      320 -                                                              
      321 -  // ---------------------------------------------------------
          ---------------- //                                            
      322 -  // MARK: Addition                                           
      323 -  // ---------------------------------------------------------
          ---------------- //                                            
      324 -                                                              
      325 -  @inlinable                                                  
      326 -  public func adding(_ other: simd_quatf) -> simd_quatf {     
      327 -    return self + other                                       
      328 -  }                                                           
      329 -                                                              
      330 -  @inlinable                                                  
      331 -  public mutating func formAddition(of other: simd_quatf) {   
      332 -    self += other                                             
      333 -  }                                                           
      334 -                                                              
      335 -  // ---------------------------------------------------------
          ---------------- //                                            
      336 -  // MARK: FMA                                                
      337 -  // ---------------------------------------------------------
          ---------------- //                                            
      338 -                                                              
      339 -  @inlinable                                                  
      340 -  public func adding(                                         
      341 -    _ other: simd_quatf,                                      
      342 -    multipliedBy factor: Scalar                               
      343 -  ) -> simd_quatf {                                           
      344 -    return self + (other * factor)                            
      345 -  }                                                           
      346 -                                                              
      347 -  @inlinable                                                  
      348 -  public mutating func formAddition(                          
      349 -    of other: simd_quatf,                                     
      350 -    multipliedBy factor: Scalar                               
      351 -  ) {                                                         
      352 -    self += (other * factor)                                  
      353 -  }                                                           
      354 -                                                              
      355 -  // ---------------------------------------------------------
          ---------------- //                                            
      356 -  // MARK: Subtraction                                        
      357 -  // ---------------------------------------------------------
          ---------------- //                                            
      358 -                                                              
      359 -  @inlinable                                                  
      360 -  public func subtracting(_ other: simd_quatf) -> simd_quatf {
      361 -    return self - other                                       
      362 -  }                                                           
      363 -                                                              
      364 -  @inlinable                                                  
      365 -  public mutating func formSubtraction(of other: simd_quatf) {
      366 -    self -= other                                             
      367 -  }                                                           
      368 -                                                              
      369 -  // ---------------------------------------------------------
          ---------------- //                                            
      370 -  // MARK: FMS                                                
      371 -  // ---------------------------------------------------------
          ---------------- //                                            
      372 -                                                              
      373 -  @inlinable                                                  
      374 -  public func subtracting(                                    
      375 -    _ other: simd_quatf,                                      
      376 -    multipliedBy factor: Scalar                               
      377 -  ) -> simd_quatf {                                           
      378 -    return self - (other * factor)                            
      379 -  }                                                           
      380 -                                                              
      381 -  @inlinable                                                  
      382 -  public mutating func formSubtraction(                       
      383 -    of other: simd_quatf,                                     
      384 -    multipliedBy factor: Scalar                               
      385 -  ) {                                                         
      386 -    self -= (other * factor)                                  
      387 -  }                                                           
      388 -                                                              
      389 -  // ---------------------------------------------------------
          ---------------- //                                            
      390 -  // MARK: Scalar Multiplication                              
      391 -  // ---------------------------------------------------------
          ---------------- //                                            
      392 -                                                              
      393 -  @inlinable                                                  
      394 -  public func multiplied(by factor: Scalar) -> simd_quatf {   
      395 -    return self * factor                                      
      396 -  }                                                           
      397 -                                                              
      398 -  @inlinable                                                  
      399 -  public mutating func formMultiplication(by factor: Scalar) {
      400 -    self *= factor                                            
      401 -  }                                                           
      402 -                                                              
      403 -  // ---------------------------------------------------------
          ---------------- //                                            
      404 -  // MARK: Scalar Division                                    
      405 -  // ---------------------------------------------------------
          ---------------- //                                            
      406 -                                                              
      407 -  @inlinable                                                  
      408 -  public func divided(by factor: Scalar) -> simd_quatf {      
      409 -    return self / factor                                      
      410 -  }                                                           
      411 -                                                              
      412 -  @inlinable                                                  
      413 -  public mutating func formDivision(by factor: Scalar) {      
      414 -    self /= factor                                            
      415 -  }                                                           
      416 -                                                              
      417 -  // ---------------------------------------------------------
          ---------------- //                                            
      418 -  // MARK: Quaternion Multiplication                          
      419 -  // ---------------------------------------------------------
          ---------------- //                                            
      420 -                                                              
      421 -  @inlinable                                                  
      422 -  public func multiplied(onRightBy other: simd_quatf) -> simd_
          -quatf {                                                       
      423 -    return self * other                                       
      424 -  }                                                           
      425 -                                                              
      426 -  @inlinable                                                  
      427 -  public func multiplied(onLeftBy other: simd_quatf) -> simd_q
          -uatf {                                                        
      428 -    return other * self                                       
      429 -  }                                                           
      430 -                                                              
      431 -  @inlinable                                                  
      432 -  public mutating func formMultiplication(onRightBy other: sim
          -d_quatf) {                                                    
      433 -    self = self * other                                       
      434 -  }                                                           
      435 -                                                              
      436 -  @inlinable                                                  
      437 -  public mutating func formMultiplication(onLeftBy other: simd
          -_quatf) {                                                     
      438 -    self = other * self                                       
      439 -  }                                                           
      440 -                                                              
      441 -  // ---------------------------------------------------------
          ---------------- //                                            
      442 -  // MARK: Quaternion Division                                
      443 -  // ---------------------------------------------------------
          ---------------- //                                            
      444 -                                                              
      445 -  @inlinable                                                  
      446 -  public func divided(onRightBy other: simd_quatf) -> simd_qua
          -tf {                                                          
      447 -    return self / other                                       
      448 -  }                                                           
      449 -                                                              
      450 -  @inlinable                                                  
      451 -  public func divided(onLeftBy other: simd_quatf) -> simd_quat
          -f {                                                           
      452 -    return other.inverse * self                               
      453 -  }                                                           
      454 -                                                              
      455 -  @inlinable                                                  
      456 -  public mutating func formDivision(onRightBy other: simd_quat
          -f) {                                                          
      457 -    self /= other                                             
      458 -  }                                                           
      459 -                                                              
      460 -  @inlinable                                                  
      461 -  public mutating func formDivision(onLeftBy other: simd_quatf
          -) {                                                           
      462 -    self = other.inverse * self                               
      463 -  }                                                           
      464 -                                                              
      465 -  // ---------------------------------------------------------
          ---------------- //                                            
      466 -  // MARK: Quaternion Dot Product                             
      467 -  // ---------------------------------------------------------
          ---------------- //                                            
      468 -                                                              
      469 -  @inlinable                                                  
      470 -  public func dotted(with other: simd_quatf) -> Scalar {      
      471 -    return simd_dot(self, other)                              
      472 -  }                                                           
      473 -                                                              
      474 -}                                                             
        8 +@AddNativeQuaternionConformance(representation: .float)       
        9 +extension simd_quatf: QuaternionProtocol, NumericAggregate { }

⏺ Bash(swift build 2>&1 | grep -E "error:" | head -30)
  ⎿  /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDXLSI
     MDSupport/Quaternion/Storages/DoubleQuaternionStorage.swift:25:66: err
     or: 'NumericEntryRepresentation' is not a member type of struct 'HDXLS
     … +88 lines (ctrl+o to expand)
  ⎿  (timeout 10m)

⏺ Write(Sources/HDXLSIMDSupport/Quaternion/NativeConformances/simd_quatd+Quatern
       ionProtocol.swift)
  ⎿  Error writing file

  Read 1 file (ctrl+o to expand)

⏺ Now migrate the quaternion storages and wrapper:

  Read 1 file (ctrl+o to expand)

⏺ Bash(swift build 2>&1 | grep -E "error:" | head -30)
  ⎿  (No output)
  ⎿  (timeout 10m)

⏺ Bash(swift build 2>&1 | tail -10)
  ⎿  Building for debugging...
     [0/2] Write swift-version--58304C5D6DBC2206.txt
     Build complete! (0.09s)

⏺ Bash(touch /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDX
      LSIMDSupport/Quaternion/Storages/FloatQuaternionStorage.swift && swift
      build 2>&1 | gre…)
  ⎿  (No output)
  ⎿  (timeout 10m)

⏺ Bash(touch /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDX
      LSIMDSupport/Quaternion/Storages/FloatQuaternionStorage.swift && swift
      build 2>&1 | tai…)
  ⎿  Building for debugging...
     [0/3] Write sources
     [1/3] Write swift-version--58304C5D6DBC2206.txt
     … +3 lines (ctrl+o to expand)
  ⎿  (timeout 10m)

⏺ Bash(swift test 2>&1 | tail -10)
  ⎿  Test Suite 'QuaternionMemoryLayoutTests' passed at 2026-05-15 21:11:31
     .868.
         Executed 3 tests, with 0 failures (0 unexpected) in 0.000 (0.000) sec
     … +12 lines (ctrl+o to expand)

  ⎿  (timeout 10m)

⏺ Phase 5 done — quaternion fully macro-driven, 325 tests pass. Let me check
  what's left in the quaternion directory and clean up, then continue to Phase
  6:

  Read 1 file (ctrl+o to expand)

⏺ Moving to Phase 6. Let me see what's referencing Passthrough and
  passthroughValue:

  Searched for 2 patterns, read 2 files (ctrl+o to expand)

⏺ Let me first batch-remove Passthrough, from all the migrated type
  declarations:

⏺ Bash(cd /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDXLSI
      MDSupport && perl -i -pe 's/^  Passthrough,\n//; s/  Passthrough,\n//' \
        Matrices/Mat…)
  ⎿  (actually using sed below)

⏺ Bash(cd /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDXLSI
      MDSupport && for f in Matrices/Matrices/*.swift
      Matrices/Storages/Float/*.swift Matrice…)
  ⎿  Matrices/Storages/Float/FloatMatrix2x2Storage.swift:0
     Matrices/Matrices/Matrix2x2.swift:0
     Quaternion/Storages/FloatQuaternionStorage.swift:0
     Quaternion/Quaternion/Quaternion.swift:0
⏺ Now delete the Passthrough infrastructure:

⏺ Bash(cd /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDXLSI
      MDSupport && rm -rf Passthrough/ Matrices/Passthrough/
      Quaternion/Passthrough/ && echo…)
  ⎿  Error: Exit code 1
     Deleted Passthrough infrastructure
     ls: Passthrough/: No such file or directory
     ls: Matrices/Passthrough/: No such file or directory
     ls: Quaternion/Passthrough/: No such file or directory

⏺ Now update ExtendedSIMDScalar to drop Passthrough requirements:

⏺ Write(Sources/HDXLSIMDSupport/ExtendedSIMDScalar/ExtendedSIMDScalar.swift)
  ⎿  Added 31 lines, removed 123 lines
       5  import Foundation
       6  import simd
       7  
       8 -/// `ExtendedSIMDScalar` extends `SIMDScalar` by adding *mutual
         -ly-compatible* storages for                                    
       9 -/// (a) a quaternion and also (b) all of the currently-availabl
         -e matrix types (2x2 ... 4x4). The key point here               
      10 -/// being that *mutually-compatible*: the 2x2 matrix storage's 
         -compatible 2x3 matrix must be the                              
      11 -/// 2x3 matrix, and so on down the line.                       
       8 +/// `ExtendedSIMDScalar` extends `SIMDScalar` with mutually-com
         +patible                                                        
       9 +/// storage types for a quaternion and the nine `MxN` matrix sh
         +apes. The                                                      
      10 +/// associated types pin down which concrete storage is used fo
         +r each                                                         
      11 +/// `Quaternion<Scalar>` / `MatrixNxM<Scalar>` wrapper, and the
         + `where`                                                       
      12 +/// clauses ensure the cross-shape "compatible matrix" hooks li
         +ne up.                                                         
      13  ///
      13 -/// Note that—for now—this is where those "compatible types" ge
         -t pinned-down with constraints like                            
      14 -/// `: Matrix4x4Protocol` and `: Scalar == ...`; in a perfect w
         -orld the compatible types would                                
      15 -/// already have such `where`-clauses attached at the point of 
         -definition...but we don't live in that perfect world           
      16 -/// (or even a neighborhood thereof). Including those constrain
         -ts within the individual `MatrixMxNProtocol`                   
      17 -/// types seems to pretty-reliably trigger superexponential blo
         -w-ups in our compile-times.                                    
      18 -///                                                            
      19 -/// That's not an exaggeration, either: right now the project t
         -akes a few minutes to compile, which is already                
      20 -/// quite long for this quantity of Swift code (as measured in 
         -lines/files). Adding more `where` clauses, etc.,               
      21 -/// pretty reliably got me into hours-or-days to compile the th
         -ing, blowing through all my 64gb of RAM, and                   
      22 -/// made everything hilariously-unusable.                      
      23 -///                                                            
      24 -/// I still intend to *experiment* with refining the declaratio
         -ns to more-perfectly match the intent, but the                 
      25 -/// state of the tools leaves me with low expectations for thos
         -e experiemnts.                                                 
      26 -///                                                            
      27 -/// Anyways, this protocol exists as the bound on `Scalar` for 
         -`Matrix4x4<Scalar>`, etc., with the                            
      28 -/// interlocking, mutually-compatible storages being basically 
         -a manual emulation of something that could be                  
      29 -/// done almost-trivially if Swift gained higher-kinded types. 
         -Oh well.                                                       
      30 -///                                                            
      14 +/// Each storage is required to be both `MatrixNxMProtocol` /  
      15 +/// `QuaternionProtocol` AND `NativeSIMDRepresentable`, the lat
         +ter so the                                                     
      16 +/// wrapper can reach through to the native simd value via     
      17 +/// `Storage.NativeSIMDRepresentation`.                        
      18  public protocol ExtendedSIMDScalar : SIMDScalar, BinaryFloating
          Point, Codable {
      32 -                                                               
      33 -  associatedtype QuaternionStorage: QuaternionProtocol, Passthr
         -ough, NumericAggregate, Hashable, Codable                      
      19 +                                                               
      20 +  associatedtype QuaternionStorage: QuaternionProtocol, NativeS
         +IMDRepresentable, NumericAggregate, Hashable, Codable          
      21      where
      22      QuaternionStorage.Scalar == Self,
      23      QuaternionStorage.NumericEntryRepresentation == Self,
      24      QuaternionStorage.CompatibleMatrix4x4 == Self.Matrix4x4Stor
          age,
      38 -    QuaternionStorage.CompatibleMatrix3x3 == Self.Matrix3x3Stor
         -age,                                                           
      39 -    QuaternionStorage.PassthroughValue: QuaternionProtocol,    
      40 -    QuaternionStorage.PassthroughValue.Scalar == Self,         
      41 -    QuaternionStorage.PassthroughValue.CompatibleMatrix4x4 == S
         -elf.Matrix4x4Storage.PassthroughValue,                         
      42 -    QuaternionStorage.PassthroughValue.CompatibleMatrix3x3 == S
         -elf.Matrix3x3Storage.PassthroughValue                          
      43 -                                                               
      44 -  associatedtype Matrix2x2Storage: Matrix2x2Protocol, Passthrou
         -gh, NumericAggregate, Hashable, Codable                        
      25 +    QuaternionStorage.CompatibleMatrix3x3 == Self.Matrix3x3Stor
         +age                                                            
      26 +                                                               
      27 +  associatedtype Matrix2x2Storage: Matrix2x2Protocol, NativeSIM
         +DRepresentable, NumericAggregate, Hashable, Codable            
      28      where
      29      Matrix2x2Storage.Scalar == Self,
      30      Matrix2x2Storage.NumericEntryRepresentation == Self,
      31      Matrix2x2Storage.CompatibleMatrix2x3 == Self.Matrix2x3Stora
          ge,
      32      Matrix2x2Storage.CompatibleMatrix3x2 == Self.Matrix3x2Stora
          ge,
      33      Matrix2x2Storage.CompatibleMatrix2x4 == Self.Matrix2x4Stora
          ge,
      51 -    Matrix2x2Storage.CompatibleMatrix4x2 == Self.Matrix4x2Stora
         -ge,                                                            
      52 -    Matrix2x2Storage.PassthroughValue:Matrix2x2Protocol,       
      53 -    Matrix2x2Storage.PassthroughValue.Scalar == Self,          
      54 -    Matrix2x2Storage.PassthroughValue.CompatibleMatrix2x3 == Se
         -lf.Matrix2x3Storage.PassthroughValue,                          
      55 -    Matrix2x2Storage.PassthroughValue.CompatibleMatrix3x2 == Se
         -lf.Matrix3x2Storage.PassthroughValue,                          
      56 -    Matrix2x2Storage.PassthroughValue.CompatibleMatrix2x4 == Se
         -lf.Matrix2x4Storage.PassthroughValue,                          
      57 -    Matrix2x2Storage.PassthroughValue.CompatibleMatrix4x2 == Se
         -lf.Matrix4x2Storage.PassthroughValue                           
      34 +    Matrix2x2Storage.CompatibleMatrix4x2 == Self.Matrix4x2Stora
         +ge                                                             
      35  
      59 -  associatedtype Matrix2x3Storage: Matrix2x3Protocol, Passthrou
         -gh, NumericAggregate, Hashable, Codable                        
      36 +  associatedtype Matrix2x3Storage: Matrix2x3Protocol, NativeSIM
         +DRepresentable, NumericAggregate, Hashable, Codable            
      37      where
      38      Matrix2x3Storage.Scalar == Self,
      39      Matrix2x3Storage.NumericEntryRepresentation == Self,
     ...
      43      Matrix2x3Storage.CompatibleMatrix2x4 == Self.Matrix2x4Stora
          ge,
      44      Matrix2x3Storage.CompatibleMatrix4x2 == Self.Matrix4x2Stora
          ge,
      45      Matrix2x3Storage.CompatibleMatrix3x4 == Self.Matrix3x4Stora
          ge,
      69 -    Matrix2x3Storage.CompatibleMatrix4x3 == Self.Matrix4x3Stora
         -ge,                                                            
      70 -    Matrix2x3Storage.PassthroughValue: Matrix2x3Protocol,      
      71 -    Matrix2x3Storage.PassthroughValue.Scalar == Self,          
      72 -    Matrix2x3Storage.PassthroughValue.CompatibleMatrix2x2 == Se
         -lf.Matrix2x2Storage.PassthroughValue,                          
      73 -    Matrix2x3Storage.PassthroughValue.CompatibleMatrix3x3 == Se
         -lf.Matrix3x3Storage.PassthroughValue,                          
      74 -    Matrix2x3Storage.PassthroughValue.CompatibleMatrix3x2 == Se
         -lf.Matrix3x2Storage.PassthroughValue,                          
      75 -    Matrix2x3Storage.PassthroughValue.CompatibleMatrix2x4 == Se
         -lf.Matrix2x4Storage.PassthroughValue,                          
      76 -    Matrix2x3Storage.PassthroughValue.CompatibleMatrix4x2 == Se
         -lf.Matrix4x2Storage.PassthroughValue,                          
      77 -    Matrix2x3Storage.PassthroughValue.CompatibleMatrix3x4 == Se
         -lf.Matrix3x4Storage.PassthroughValue,                          
      78 -    Matrix2x3Storage.PassthroughValue.CompatibleMatrix4x3 == Se
         -lf.Matrix4x3Storage.PassthroughValue                           
      46 +    Matrix2x3Storage.CompatibleMatrix4x3 == Self.Matrix4x3Stora
         +ge                                                             
      47  
      80 -                                                               
      81 -  associatedtype Matrix2x4Storage: Matrix2x4Protocol, Passthrou
         -gh, NumericAggregate, Hashable, Codable                        
      48 +  associatedtype Matrix2x4Storage: Matrix2x4Protocol, NativeSIM
         +DRepresentable, NumericAggregate, Hashable, Codable            
      49      where
      50      Matrix2x4Storage.Scalar == Self,
      51      Matrix2x4Storage.NumericEntryRepresentation == Self,
     ...
       55      Matrix2x4Storage.CompatibleMatrix4x2 == Self.Matrix4x2Stor
           age,
       56      Matrix2x4Storage.CompatibleMatrix3x2 == Self.Matrix3x2Stor
           age,
       57      Matrix2x4Storage.CompatibleMatrix3x4 == Self.Matrix3x4Stor
           age,
       91 -    Matrix2x4Storage.CompatibleMatrix4x3 == Self.Matrix4x3Stor
          -age,                                                          
       92 -    Matrix2x4Storage.PassthroughValue: Matrix2x4Protocol,     
       93 -    Matrix2x4Storage.PassthroughValue.Scalar == Self,         
       94 -    Matrix2x4Storage.PassthroughValue.CompatibleMatrix2x2 == S
          -elf.Matrix2x2Storage.PassthroughValue,                        
       95 -    Matrix2x4Storage.PassthroughValue.CompatibleMatrix4x4 == S
          -elf.Matrix4x4Storage.PassthroughValue,                        
       96 -    Matrix2x4Storage.PassthroughValue.CompatibleMatrix2x3 == S
          -elf.Matrix2x3Storage.PassthroughValue,                        
       97 -    Matrix2x4Storage.PassthroughValue.CompatibleMatrix4x2 == S
          -elf.Matrix4x2Storage.PassthroughValue,                        
       98 -    Matrix2x4Storage.PassthroughValue.CompatibleMatrix3x2 == S
          -elf.Matrix3x2Storage.PassthroughValue,                        
       99 -    Matrix2x4Storage.PassthroughValue.CompatibleMatrix3x4 == S
          -elf.Matrix3x4Storage.PassthroughValue,                        
      100 -    Matrix2x4Storage.PassthroughValue.CompatibleMatrix4x3 == S
          -elf.Matrix4x3Storage.PassthroughValue                         
       58 +    Matrix2x4Storage.CompatibleMatrix4x3 == Self.Matrix4x3Stor
          +age                                                           
       59  
      102 -  associatedtype Matrix3x2Storage: Matrix3x2Protocol, Passthro
          -ugh, NumericAggregate, Hashable, Codable                      
       60 +  associatedtype Matrix3x2Storage: Matrix3x2Protocol, NativeSI
          +MDRepresentable, NumericAggregate, Hashable, Codable          
       61      where
       62      Matrix3x2Storage.Scalar == Self,
       63      Matrix3x2Storage.NumericEntryRepresentation == Self,
     ...
       67      Matrix3x2Storage.CompatibleMatrix2x4 == Self.Matrix2x4Stor
           age,
       68      Matrix3x2Storage.CompatibleMatrix4x2 == Self.Matrix4x2Stor
           age,
       69      Matrix3x2Storage.CompatibleMatrix3x4 == Self.Matrix3x4Stor
           age,
      112 -    Matrix3x2Storage.CompatibleMatrix4x3 == Self.Matrix4x3Stor
          -age,                                                          
      113 -    Matrix3x2Storage.PassthroughValue: Matrix3x2Protocol,     
      114 -    Matrix3x2Storage.PassthroughValue.Scalar == Self,         
      115 -    Matrix3x2Storage.PassthroughValue.CompatibleMatrix2x2 == S
          -elf.Matrix2x2Storage.PassthroughValue,                        
      116 -    Matrix3x2Storage.PassthroughValue.CompatibleMatrix3x3 == S
          -elf.Matrix3x3Storage.PassthroughValue,                        
      117 -    Matrix3x2Storage.PassthroughValue.CompatibleMatrix2x3 == S
          -elf.Matrix2x3Storage.PassthroughValue,                        
      118 -    Matrix3x2Storage.PassthroughValue.CompatibleMatrix2x4 == S
          -elf.Matrix2x4Storage.PassthroughValue,                        
      119 -    Matrix3x2Storage.PassthroughValue.CompatibleMatrix4x2 == S
          -elf.Matrix4x2Storage.PassthroughValue,                        
      120 -    Matrix3x2Storage.PassthroughValue.CompatibleMatrix3x4 == S
          -elf.Matrix3x4Storage.PassthroughValue,                        
      121 -    Matrix3x2Storage.PassthroughValue.CompatibleMatrix4x3 == S
          -elf.Matrix4x3Storage.PassthroughValue                         
       70 +    Matrix3x2Storage.CompatibleMatrix4x3 == Self.Matrix4x3Stor
          +age                                                           
       71  
      123 -  associatedtype Matrix3x3Storage: Matrix3x3Protocol, Passthro
          -ugh, NumericAggregate, Hashable, Codable                      
       72 +  associatedtype Matrix3x3Storage: Matrix3x3Protocol, NativeSI
          +MDRepresentable, NumericAggregate, Hashable, Codable          
       73      where
       74      Matrix3x3Storage.Scalar == Self,
       75      Matrix3x3Storage.NumericEntryRepresentation == Self,
     ...
       77      Matrix3x3Storage.CompatibleMatrix2x3 == Self.Matrix2x3Stor
           age,
       78      Matrix3x3Storage.CompatibleMatrix3x2 == Self.Matrix3x2Stor
           age,
       79      Matrix3x3Storage.CompatibleMatrix3x4 == Self.Matrix3x4Stor
           age,
      131 -    Matrix3x3Storage.CompatibleMatrix4x3 == Self.Matrix4x3Stor
          -age,                                                          
      132 -    Matrix3x3Storage.PassthroughValue: Matrix3x3Protocol,     
      133 -    Matrix3x3Storage.PassthroughValue.Scalar == Self,         
      134 -    Matrix3x3Storage.PassthroughValue.CompatibleQuaternion == 
          -Self.QuaternionStorage.PassthroughValue,                      
      135 -    Matrix3x3Storage.PassthroughValue.CompatibleMatrix2x3 == S
          -elf.Matrix2x3Storage.PassthroughValue,                        
      136 -    Matrix3x3Storage.PassthroughValue.CompatibleMatrix3x2 == S
          -elf.Matrix3x2Storage.PassthroughValue,                        
      137 -    Matrix3x3Storage.PassthroughValue.CompatibleMatrix3x4 == S
          -elf.Matrix3x4Storage.PassthroughValue,                        
      138 -    Matrix3x3Storage.PassthroughValue.CompatibleMatrix4x3 == S
          -elf.Matrix4x3Storage.PassthroughValue                         
       80 +    Matrix3x3Storage.CompatibleMatrix4x3 == Self.Matrix4x3Stor
          +age                                                           
       81  
      140 -  associatedtype Matrix3x4Storage: Matrix3x4Protocol, Passthro
          -ugh, NumericAggregate, Hashable, Codable                      
       82 +  associatedtype Matrix3x4Storage: Matrix3x4Protocol, NativeSI
          +MDRepresentable, NumericAggregate, Hashable, Codable          
       83      where
       84      Matrix3x4Storage.Scalar == Self,
       85      Matrix3x4Storage.NumericEntryRepresentation == Self,
     ...
       89      Matrix3x4Storage.CompatibleMatrix3x2 == Self.Matrix3x2Stor
           age,
       90      Matrix3x4Storage.CompatibleMatrix2x4 == Self.Matrix2x4Stor
           age,
       91      Matrix3x4Storage.CompatibleMatrix4x2 == Self.Matrix4x2Stor
           age,
      150 -    Matrix3x4Storage.CompatibleMatrix4x3 == Self.Matrix4x3Stor
          -age,                                                          
      151 -    Matrix3x4Storage.PassthroughValue: Matrix3x4Protocol,     
      152 -    Matrix3x4Storage.PassthroughValue.Scalar == Self,         
      153 -    Matrix3x4Storage.PassthroughValue.CompatibleMatrix4x4 == S
          -elf.Matrix4x4Storage.PassthroughValue,                        
      154 -    Matrix3x4Storage.PassthroughValue.CompatibleMatrix3x3 == S
          -elf.Matrix3x3Storage.PassthroughValue,                        
      155 -    Matrix3x4Storage.PassthroughValue.CompatibleMatrix2x3 == S
          -elf.Matrix2x3Storage.PassthroughValue,                        
      156 -    Matrix3x4Storage.PassthroughValue.CompatibleMatrix3x2 == S
          -elf.Matrix3x2Storage.PassthroughValue,                        
      157 -    Matrix3x4Storage.PassthroughValue.CompatibleMatrix2x4 == S
          -elf.Matrix2x4Storage.PassthroughValue,                        
      158 -    Matrix3x4Storage.PassthroughValue.CompatibleMatrix4x2 == S
          -elf.Matrix4x2Storage.PassthroughValue,                        
      159 -    Matrix3x4Storage.PassthroughValue.CompatibleMatrix4x3 == S
          -elf.Matrix4x3Storage.PassthroughValue                         
       92 +    Matrix3x4Storage.CompatibleMatrix4x3 == Self.Matrix4x3Stor
          +age                                                           
       93  
      161 -  associatedtype Matrix4x2Storage: Matrix4x2Protocol, Passthro
          -ugh, NumericAggregate, Hashable, Codable                      
       94 +  associatedtype Matrix4x2Storage: Matrix4x2Protocol, NativeSI
          +MDRepresentable, NumericAggregate, Hashable, Codable          
       95      where
       96      Matrix4x2Storage.Scalar == Self,
       97      Matrix4x2Storage.NumericEntryRepresentation == Self,
     ...
      101      Matrix4x2Storage.CompatibleMatrix3x2 == Self.Matrix3x2Stor
           age,
      102      Matrix4x2Storage.CompatibleMatrix2x4 == Self.Matrix2x4Stor
           age,
      103      Matrix4x2Storage.CompatibleMatrix3x4 == Self.Matrix3x4Stor
           age,
      171 -    Matrix4x2Storage.CompatibleMatrix4x3 == Self.Matrix4x3Stor
          -age,                                                          
      172 -    Matrix4x2Storage.PassthroughValue: Matrix4x2Protocol,     
      173 -    Matrix4x2Storage.PassthroughValue.Scalar == Self,         
      174 -    Matrix4x2Storage.PassthroughValue.CompatibleMatrix4x4 == S
          -elf.Matrix4x4Storage.PassthroughValue,                        
      175 -    Matrix4x2Storage.PassthroughValue.CompatibleMatrix2x2 == S
          -elf.Matrix2x2Storage.PassthroughValue,                        
      176 -    Matrix4x2Storage.PassthroughValue.CompatibleMatrix2x3 == S
          -elf.Matrix2x3Storage.PassthroughValue,                        
      177 -    Matrix4x2Storage.PassthroughValue.CompatibleMatrix3x2 == S
          -elf.Matrix3x2Storage.PassthroughValue,                        
      178 -    Matrix4x2Storage.PassthroughValue.CompatibleMatrix2x4 == S
          -elf.Matrix2x4Storage.PassthroughValue,                        
      179 -    Matrix4x2Storage.PassthroughValue.CompatibleMatrix3x4 == S
          -elf.Matrix3x4Storage.PassthroughValue,                        
      180 -    Matrix4x2Storage.PassthroughValue.CompatibleMatrix4x3 == S
          -elf.Matrix4x3Storage.PassthroughValue                         
      104 +    Matrix4x2Storage.CompatibleMatrix4x3 == Self.Matrix4x3Stor
          +age                                                           
      105  
      182 -  associatedtype Matrix4x3Storage: Matrix4x3Protocol, Passthro
          -ugh, NumericAggregate, Hashable, Codable                      
      106 +  associatedtype Matrix4x3Storage: Matrix4x3Protocol, NativeSI
          +MDRepresentable, NumericAggregate, Hashable, Codable          
      107      where
      108      Matrix4x3Storage.Scalar == Self,
      109      Matrix4x3Storage.NumericEntryRepresentation == Self,
     ...
      113      Matrix4x3Storage.CompatibleMatrix3x2 == Self.Matrix3x2Stor
           age,
      114      Matrix4x3Storage.CompatibleMatrix2x4 == Self.Matrix2x4Stor
           age,
      115      Matrix4x3Storage.CompatibleMatrix4x2 == Self.Matrix4x2Stor
           age,
      192 -    Matrix4x3Storage.CompatibleMatrix3x4 == Self.Matrix3x4Stor
          -age,                                                          
      193 -    Matrix4x3Storage.PassthroughValue: Matrix4x3Protocol,     
      194 -    Matrix4x3Storage.PassthroughValue.Scalar == Self,         
      195 -    Matrix4x3Storage.PassthroughValue.CompatibleMatrix4x4 == S
          -elf.Matrix4x4Storage.PassthroughValue,                        
      196 -    Matrix4x3Storage.PassthroughValue.CompatibleMatrix3x3 == S
          -elf.Matrix3x3Storage.PassthroughValue,                        
      197 -    Matrix4x3Storage.PassthroughValue.CompatibleMatrix2x3 == S
          -elf.Matrix2x3Storage.PassthroughValue,                        
      198 -    Matrix4x3Storage.PassthroughValue.CompatibleMatrix3x2 == S
          -elf.Matrix3x2Storage.PassthroughValue,                        
      199 -    Matrix4x3Storage.PassthroughValue.CompatibleMatrix2x4 == S
          -elf.Matrix2x4Storage.PassthroughValue,                        
      200 -    Matrix4x3Storage.PassthroughValue.CompatibleMatrix4x2 == S
          -elf.Matrix4x2Storage.PassthroughValue,                        
      201 -    Matrix4x3Storage.PassthroughValue.CompatibleMatrix3x4 == S
          -elf.Matrix3x4Storage.PassthroughValue                         
      116 +    Matrix4x3Storage.CompatibleMatrix3x4 == Self.Matrix3x4Stor
          +age                                                           
      117  
      203 -  associatedtype Matrix4x4Storage: Matrix4x4Protocol, Passthro
          -ugh, NumericAggregate, Hashable, Codable                      
      118 +  associatedtype Matrix4x4Storage: Matrix4x4Protocol, NativeSI
          +MDRepresentable, NumericAggregate, Hashable, Codable          
      119      where
      120      Matrix4x4Storage.Scalar == Self,
      121      Matrix4x4Storage.NumericEntryRepresentation == Self,
     ...
      123      Matrix4x4Storage.CompatibleMatrix2x4 == Self.Matrix2x4Stor
           age,
      124      Matrix4x4Storage.CompatibleMatrix4x2 == Self.Matrix4x2Stor
           age,
      125      Matrix4x4Storage.CompatibleMatrix3x4 == Self.Matrix3x4Stor
           age,
      211 -    Matrix4x4Storage.CompatibleMatrix4x3 == Self.Matrix4x3Stor
          -age,                                                          
      212 -    Matrix4x4Storage.PassthroughValue: Matrix4x4Protocol,     
      213 -    Matrix4x4Storage.PassthroughValue.Scalar == Self,         
      214 -    Matrix4x4Storage.PassthroughValue.CompatibleQuaternion == 
          -Self.QuaternionStorage.PassthroughValue,                      
      215 -    Matrix4x4Storage.PassthroughValue.CompatibleMatrix2x4 == S
          -elf.Matrix2x4Storage.PassthroughValue,                        
      216 -    Matrix4x4Storage.PassthroughValue.CompatibleMatrix4x2 == S
          -elf.Matrix4x2Storage.PassthroughValue,                        
      217 -    Matrix4x4Storage.PassthroughValue.CompatibleMatrix3x4 == S
          -elf.Matrix3x4Storage.PassthroughValue,                        
      218 -    Matrix4x4Storage.PassthroughValue.CompatibleMatrix4x3 == S
          -elf.Matrix4x3Storage.PassthroughValue                         
      126 +    Matrix4x4Storage.CompatibleMatrix4x3 == Self.Matrix4x3Stor
          +age                                                           
      127  
      128  }

⏺ Now fix the wrapper macros to use NativeSIMDRepresentation directly instead of
   the PassthroughValue chain:

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/NativeSIMDRepresentableMac
        rolet.swift)
  ⎿  Added 9 lines, removed 11 lines
      58          """
      59        ]
      60      case .wrapper:
      61 -      // During the migration, the underlying `Scalar.MatrixNxM
         -Storage` may or                                                
      62 -      // may not have a `NativeSIMDRepresentation` typealias ye
         -t — but it DOES                                                
      63 -      // have a `PassthroughValue` (the existing Passthrough co
         -nformance), and                                                
      64 -      // `PassthroughValue.PassthroughValue` is the native simd
         - type. We reach                                                
      65 -      // through the Passthrough chain so the wrapper works reg
         -ardless of                                                     
      66 -      // which underlying storages have already been migrated. 
      61 +      // Storage types conform to NativeSIMDRepresentable (per 
         +the                                                            
      62 +      // ExtendedSIMDScalar protocol constraint), so we can ref
         +er to                                                          
      63 +      // `Scalar.MatrixNxMStorage.NativeSIMDRepresentation` dir
         +ectly.                                                         
      64 +      let storageTypeRef = "Scalar.Matrix\(descriptor.shapeLabe
         +l)Storage"                                                     
      65        return [
      66          """
      69 -        public typealias NativeSIMDRepresentation = Passthrough
         -Value.PassthroughValue                                         
      67 +        public typealias NativeSIMDRepresentation = \(raw: stor
         +ageTypeRef).NativeSIMDRepresentation                           
      68          """,
      69          """
      70          @inlinable
      71          public var nativeSIMDRepresentation: NativeSIMDRepresen
          tation {
      74 -          get { passthroughValue.passthroughValue }            
      75 -          set { passthroughValue.passthroughValue = newValue } 
      76 -          _modify { yield &passthroughValue.passthroughValue } 
      72 +          get { passthroughValue.nativeSIMDRepresentation }    
      73 +          set { passthroughValue.nativeSIMDRepresentation = new
         +Value }                                                        
      74 +          _modify { yield &passthroughValue.nativeSIMDRepresent
         +ation }                                                        
      75          }
      76          """,
      77          """
      78          @inlinable
      79          public init(nativeSIMDRepresentation: NativeSIMDReprese
          ntation) {
      82 -          self.init(passthroughValue: PassthroughValue(passthro
         -ughValue: nativeSIMDRepresentation))                           
      80 +          self.init(passthroughValue: \(raw: storageTypeRef)(na
         +tiveSIMDRepresentation: nativeSIMDRepresentation))             
      81          }
      82          """
      83        ]

⏺ Also Quaternion's wrapper layer for NativeSIMDRepresentable:

⏺ Update(Sources/HDXLSIMDSupportMacroPlugin/Macrolets/QuaternionMacrolets.swift)
  ⎿  Added 5 lines, removed 5 lines
      110        ]
      111      case .wrapper:
      112        return [
      113 -        "public typealias NativeSIMDRepresentation = Passthrou
          -ghValue.PassthroughValue",                                    
      113 +        "public typealias NativeSIMDRepresentation = Scalar.Qu
          +aternionStorage.NativeSIMDRepresentation",                    
      114          """
      115          @inlinable
      116          public var nativeSIMDRepresentation: NativeSIMDReprese
           ntation {
      117 -          get { passthroughValue.passthroughValue }           
      118 -          set { passthroughValue.passthroughValue = newValue }
      119 -          _modify { yield &passthroughValue.passthroughValue }
      117 +          get { passthroughValue.nativeSIMDRepresentation }   
      118 +          set { passthroughValue.nativeSIMDRepresentation = ne
          +wValue }                                                      
      119 +          _modify { yield &passthroughValue.nativeSIMDRepresen
          +tation }                                                      
      120          }
      121          """,
      122          """
      123          @inlinable
      124          public init(nativeSIMDRepresentation: NativeSIMDRepres
           entation) {
      125 -          self.init(passthroughValue: PassthroughValue(passthr
          -oughValue: nativeSIMDRepresentation))                         
      125 +          self.init(passthroughValue: Scalar.QuaternionStorage
          +(nativeSIMDRepresentation: nativeSIMDRepresentation))         
      126          }
      127          """
      128        ]

⏺ Now check the test integer-tuple file for Passthrough references and fix:

  Read 1 file (ctrl+o to expand)

⏺ Update(Tests/HDXLSIMDSupportTests/Support/IntegerTupleConstructible/Matrices+I
        ntegerTupleConstructible.swift)
  ⎿  21

⏺ Bash(touch /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDX
      LSIMDSupport/ExtendedSIMDScalar/ExtendedSIMDScalar.swift && swift build
      2>&1 | grep -E…)
  ⎿  (No output)
  ⎿  (timeout 10m)

⏺ Bash(swift build 2>&1 | tail -20)
  ⎿  Building for debugging...
     [0/2] Write swift-version--58304C5D6DBC2206.txt
     Build complete! (0.09s)

⏺ Bash(touch /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDX
      LSIMDSupport/ExtendedSIMDScalar/ExtendedSIMDScalar.swift && touch
      /Users/prb/conductor/…)
  ⎿  Building for debugging...
     [0/3] Write sources
     [1/3] Write swift-version--58304C5D6DBC2206.txt
     … +4 lines (ctrl+o to expand)
  ⎿  (timeout 10m)

⏺ Build green with Passthrough demolished. Run tests:

⏺ Bash(swift test 2>&1 | tail -10)
  ⎿  Test Suite 'QuaternionMemoryLayoutTests' passed at 2026-05-15 21:15:37
     .275.
         Executed 3 tests, with 0 failures (0 unexpected) in 0.000 (0.000) sec
     … +12 lines (ctrl+o to expand)

  ⎿  (timeout 10m)

  Searched for 3 patterns (ctrl+o to expand)

⏺ Now rename passthroughValue → storage and PassthroughValue → Storage in
  macrolets:

⏺ Bash(cd /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDXLSI
      MDSupportMacroPlugin && perl -i -pe '
        s/\bpassthroughValue\b/storage/g;…)
  ⎿  done

⏺ Now build and verify:

⏺ Bash(swift build 2>&1 | grep -E "error:" | head -20)
  ⎿  (No output)

⏺ Bash(touch /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDX
      LSIMDSupportMacroPlugin/Macrolets/StorageBackingMacrolet.swift && swift
      build 2>&1 | ta…)
  ⎿  Building for debugging...
     [0/3] Write sources
     [1/3] Write swift-version--58304C5D6DBC2206.txt
     … +4 lines (ctrl+o to expand)

⏺ Bash(touch /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HDX
      LSIMDSupport/Matrices/Storages/Float/FloatMatrix2x2Storage.swift && swift
      build 2>&1 |…)
  ⎿  [115/123] Compiling HDXLSIMDSupport HalfNativeMatrices+Equatable.swift
     [116/123] Compiling HDXLSIMDSupport simd_half2x2+Matrix2x2Protocol.swi
     ft
     … +14 lines (ctrl+o to expand)
  ⎿  (timeout 10m)
⏺ Bash(swift test 2>&1 | tail -10)
  ⎿  Test Suite 'QuaternionMemoryLayoutTests' passed at 2026-05-15 21:17:00
     .633.
         Executed 3 tests, with 0 failures (0 unexpected) in 0.000 (0.000) sec
     … +12 lines (ctrl+o to expand)

  ⎿  (timeout 10m)

  Searched for 3 patterns (ctrl+o to expand)

⏺ Bash(rm -rf /Users/prb/conductor/workspaces/HDXLSIMDSupport/raleigh/Sources/HD
      XLSIMDSupport/Matrices/Protocols/DefaultSupport/ && swift build 2>&1 |
      tail -5)
  ⎿  [124/127] Compiling HDXLSIMDSupport simd_half3x3+Matrix3x3Protocol.swi
     ft
     [125/127] Compiling HDXLSIMDSupport simd_half3x4+Matrix3x4Protocol.swi
     … +5 lines (ctrl+o to expand)
  ⎿  (timeout 10m)

⏺ Bash(swift test 2>&1 | tail -5)
  ⎿      Executed 325 tests, with 0 failures (0 unexpected) in 0.896 (0.910)
     s
     econds
     􀟈  Test run started.
     … +3 lines (ctrl+o to expand)
  ⎿  (timeout 10m)

⏺ Let me check final state and verify cleanliness:

⏺ Bash(git status --short 2>&1 | head -30 && echo "---" && git diff --stat |
      tail -5)
  ⎿   M Sources/HDXLSIMDSupport/ExtendedSIMDScalar/ExtendedSIMDScalar.swift
      M Sources/HDXLSIMDSupport/Macros/Macros.swift
      M Sources/HDXLSIMDSupport/Matrices/Matrices/Matrix2x2.swift
     … +35 lines (ctrl+o to expand)

⏺ Let me commit this Phase 5/6 milestone:

⏺ Bash(git add -A && git commit -m "$(cat <<'EOF'
      Migrate Quaternion to macros and demolish the Passthrough protocol.…)
  ⎿   create mode 100644 Sources/HDXLSIMDSupportMacroPlugin/IR/QuaternionDe
     scriptor.swift
      create mode 100644 Sources/HDXLSIMDSupportMacroPlugin/IR/SIMDQuaterni
     … +7 lines (ctrl+o to expand)

⏺ Bash(git log --oneline -3)
  ⎿  c54a394 Migrate Quaternion to macros and demolish the Passthrough prot
     ocol.
     24e0eed Migrate matrix conformances to macro-generated code; add macro
     … +2 lines (ctrl+o to expand)

⏺ All phases of the original goal are now complete and committed:

  c54a394 Phase 5 + Phase 6:
  - Quaternion fully macro-generated (3 native + 3 storage + 1 wrapper, 13
  quaternion macrolets covering the entire protocol surface)
  - Half-precision quaternion's missing-overlay quirks handled by routing
  through C-level simd_* calls
  - Passthrough protocol and all forwarding extensions deleted (30+ files, ~6000
   lines)
  - MatrixDefaultSupportProtocol defaults deleted (the macros now emit those
  explicitly)
  - ExtendedSIMDScalar cleaned up — Passthrough requirements dropped, replaced
  by NativeSIMDRepresentable; all .PassthroughValue chain constraints removed
  - passthroughValue → storage and PassthroughValue → Storage throughout the
  macro plugin and test bindings
  - 325 tests still passing, 0 failures

  Phase status:
  - ✅ Phase 0: Baseline
  - ✅ Phase 1: Macro plugin scaffold + IR + macrolet protocol
  - ✅ Phase 2: Matrix2x2 end-to-end
  - ✅ Phase 3: All matrix shapes (Float)
  - ✅ Phase 4: Double + Half representations
  - ✅ Phase 4.5: Validation test generation infrastructure (192 generated
  tests)
  - ✅ Phase 5: Quaternion + cross-cutting concerns
  - ✅ Phase 6: Passthrough demolition + cleanup

  Deferred (not strictly part of the original goal):
  - Demoting concrete storage types to @usableFromInline internal — left public
  for now since it'd be a breaking change for any downstream that names a
  concrete FloatMatrixNxMStorage.
  - Additional validation slice coverage (cross-shape mult, scalar add/sub,
  linear combination, determinant). Architecturally trivial to add; each is
  another macrolet adding validationTestDeclarations.

  The architecture you sketched is fully in place. Ready for next instructions.

✻ Brewed for 15m 38s

❯ Write out a markdown document like "RemainingMigrationWork.md" with enough    
  detail to fill in those deferred tasks in a future session (e.g. "cross-shape 
   mult, scalar add/sub, linear combination, determinant", the demotion to      
  internal and `@usableFromInline`), save it into the project root, and then    
  commit all this work.                                                         

⏺ Write(RemainingMigrationWork.md)
  ⎿  Wrote 322 lines to RemainingMigrationWork.md
      2 # Remaining Migration Work
        ionally complete — every matrix and quaternion conformance is mac
        sions are gone, and 325 tests pass. The items below are deferred 
        ut of the main migration. None of them are required for correctne
        ss; they tighten the API surface and broaden the validation safet
      4 y net.
      6 ---
        l` 1. Demote concrete storage types to `@usableFromInline interna
      9 **Goal.** Reduce the public API surface to just the generic wrapp
        ers (`Matrix2x2<Scalar>` through `Matrix4x4<Scalar>`, `Quate
     … +514 lines (ctrl+o to expand)

⏺ Bash(git status --short && echo "---" && git add RemainingMigrationWork.md &&
      git commit -m "$(cat <<'EOF'
      Document the remaining migration work.…)
  ⎿  ?? RemainingMigrationWork.md
     ---
     [plx/raleigh 81c86f3] Document the remaining migration work.
     … +2 lines (ctrl+o to expand)

⏺ Bash(git log --oneline -5)
  ⎿  81c86f3 Document the remaining migration work.
     c54a394 Migrate Quaternion to macros and demolish the Passthrough prot
     ocol.
     … +5 lines (ctrl+o to expand)

⏺ Committed as 81c86f3. The document (RemainingMigrationWork.md) covers six
  sections with file pointers and time estimates: storage privacy demotion, six
  categories of additional validation coverage (scalar add/sub, linear
  combination, vector mult, cross-shape mult, scalar-output / bool-output
  slices, structural slices), optional half-3-row float-widening
  cross-validation, quaternion validation tests, comment cleanup, and a few
  other small follow-ups, plus a recommended ordering for the next session.

✻ Cogitated for 2m 42s

❯ /export                                                                       
  ⎿  Conversation copied to clipboard

❯ /export                                                                       
  ⎿  Conversation copied to clipboard