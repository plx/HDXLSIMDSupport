import Foundation
import XCTest
import HDXLSIMDSupport

extension BinaryFloatingPoint {
  static var validationTestTolerance: Self { 0.000001 }
}

// -------------------------------------------------------------------------- //
// MARK: (Aggregate, Native) within-epsilison
// -------------------------------------------------------------------------- //

func HDXLAssertNativeAndAggregateWithinEpsilon<Distance, Aggregate, Native>(
  _ epsilon: Distance = .validationTestTolerance,
  aggregate: Aggregate,
  native: Native,
  function: StaticString = #function,
  file: StaticString = #filePath,
  line: UInt = #line,
  column: UInt = #column
) where
  Aggregate: NativeSIMDRepresentable,
  Native == Aggregate.NativeSIMDRepresentation,
  Aggregate: L1DistanceMeasureable,
  Native: L1DistanceMeasureable,
  Distance == Aggregate.L1Distance,
  Distance == Native.L1Distance
{
  let distanceAsAggregates = aggregate.l1Distance(to: Aggregate(nativeSIMDRepresentation: native))
  let distanceAsNatives = native.l1Distance(to: aggregate.nativeSIMDRepresentation)
  let distanceOfDistances = abs(distanceAsAggregates - distanceAsAggregates)
  let maximumDistance = max(distanceAsAggregates, distanceAsNatives, distanceOfDistances)
  if maximumDistance >= epsilon {
    XCTFail(
      """
      Found unexpectedly-distant (Aggregate, Native) pair:
      
      - `Distance`: \(String(reflecting: Distance.self))
      - `Aggregate`: \(String(reflecting: Aggregate.self))
      - `Native`: \(String(reflecting: Native.self))
      - `aggregate`: \(String(reflecting: aggregate))
      - `native`: \(String(reflecting: native))
      - `distanceAsAggregates`: \(distanceAsAggregates)
      - `distanceAsNatives`: \(distanceAsNatives)
      - `distanceOfDistances`: \(distanceOfDistances)
      - `maximumDistance`: \(maximumDistance)
      - `epsilon`: \(epsilon)
      - `function`: \(function)
      - `file`: \(file)
      - `line`: \(line)
      - `column`: \(column)
      """,
      file: file,
      line: line
    )
  }
}

// -------------------------------------------------------------------------- //
// MARK: (Scalar, Aggregate) -> Scalar
// -------------------------------------------------------------------------- //

func HDXLValidateOutOfPlaceScalarAggregateToScalarOperation<Scalar, Aggregate, Native, IntegerTuple>(
  _ operationName: @autoclosure () -> String,
  on inputs: (Aggregate.Type, Scalar.Type),
  tolerance: Scalar = .validationTestTolerance,
  lhses: some Sequence<Scalar>,
  rhses: AsyncStream<IntegerTuple>,
  operations aggregateOperation: (Scalar, Aggregate) -> Scalar,
  _ nativeOperation: (Scalar, Native) -> Scalar,
  function: StaticString = #function,
  file: StaticString = #filePath,
  line: UInt = #line,
  column: UInt = #column
) async throws where
  Aggregate: NativeSIMDRepresentable,
  Native == Aggregate.NativeSIMDRepresentation,
  Aggregate: IntegerTupleConstructible,
  Native: IntegerTupleConstructible,
  Aggregate.IntegerTuple == IntegerTuple,
  Native.IntegerTuple == IntegerTuple,
  Aggregate: L1DistanceMeasureable,
  Native: L1DistanceMeasureable,
  Scalar == Aggregate.L1Distance,
  Scalar == Native.L1Distance
{
  for lhs in lhses {
    for try await rhs in rhses {
      _HDXLValidateOutOfPlaceScalarAggregateToScalarOperation(
        operationName(),
        tolerance: tolerance,
        lhs: lhs,
        rhses: Aggregate(integerTuple: rhs), Native(integerTuple: rhs),
        operations: aggregateOperation, nativeOperation,
        function: function,
        file: file,
        line: line,
        column: column
      )
    }
  }
}

func _HDXLValidateOutOfPlaceScalarAggregateToScalarOperation<Scalar, Aggregate, Native>(
  _ operationName: @autoclosure () -> String,
  tolerance: Scalar = .validationTestTolerance,
  lhs: Scalar,
  rhses aggregateRHS: Aggregate,
  _ nativeRHS: Native,
  operations aggregateOperation: (Scalar, Aggregate) -> Scalar,
  _ nativeOperation: (Scalar, Native) -> Scalar,
  function: StaticString = #function,
  file: StaticString = #filePath,
  line: UInt = #line,
  column: UInt = #column
) where
  Aggregate: NativeSIMDRepresentable,
  Native == Aggregate.NativeSIMDRepresentation,
  Aggregate: L1DistanceMeasureable,
  Native: L1DistanceMeasureable,
  Scalar == Aggregate.L1Distance,
  Scalar == Native.L1Distance
{
  // ///////////////////////////////////////////////////////////////////////////
  HDXLAssertNativeAndAggregateWithinEpsilon(
    tolerance,
    aggregate: aggregateRHS,
    native: nativeRHS,
    function: function,
    file: file,
    line: line,
    column: column
  )
  // ///////////////////////////////////////////////////////////////////////////
  let nativeResult = nativeOperation(lhs, nativeRHS)
  let aggregateResult = aggregateOperation(lhs, aggregateRHS)
  if abs(nativeResult - aggregateResult) >= tolerance {
    let name = operationName()
    XCTFail(
      """
      Validation failure for out-of-place `(Scalar, Aggregate) -> Scalar` operation \(name)
      
      - Summary:
        - `nativeResult`: \(nativeResult)
        - `aggregateResult`: \(aggregateResult)
        - `abs(nativeResult - aggregateResult)` -> \(abs(nativeResult - aggregateResult)) >= \(tolerance)
      - Details:
        - `Scalar`: \(String(reflecting: Scalar.self))
        - `Aggregate`: \(String(reflecting: Aggregate.self))
        - `Native`: \(String(reflecting: Native.self))
        - `operationName`: \(name)
        - `tolerance`: \(tolerance)
        - `lhs`: \(lhs)
        - `aggregateRHS`: \(String(reflecting: aggregateRHS))
        - `nativeRHS`: \(String(reflecting: nativeRHS))
        - `nativeResult`: \(nativeResult)
        - `aggregateResult`: \(aggregateResult)
        - `abs(nativeResult - aggregateResult)`: \(abs(nativeResult - aggregateResult))
        - `function`: \(function)
        - `file`: \(file)
        - `line`: \(line)
        - `column`: \(column)
      """,
      file: file,
      line: line
    )
  }
}
 
// -------------------------------------------------------------------------- //
// MARK: (Aggregate, Scalar) -> Scalar
// -------------------------------------------------------------------------- //

func HDXLValidateOutOfPlaceAggregateScalarToScalarOperation<Scalar, Aggregate, Native, IntegerTuple>(
  _ operationName: @autoclosure () -> String,
  on inputs: (Aggregate.Type, Scalar.Type),
  tolerance: Scalar = .validationTestTolerance,
  lhses: AsyncStream<IntegerTuple>,
  rhses: some Sequence<Scalar>,
  operations aggregateOperation: (Aggregate, Scalar) -> Scalar,
  _ nativeOperation: (Native, Scalar) -> Scalar,
  function: StaticString = #function,
  file: StaticString = #filePath,
  line: UInt = #line,
  column: UInt = #column
) async throws where
  Aggregate: NativeSIMDRepresentable,
  Native == Aggregate.NativeSIMDRepresentation,
  Aggregate: IntegerTupleConstructible,
  Native: IntegerTupleConstructible,
  Aggregate.IntegerTuple == IntegerTuple,
  Native.IntegerTuple == IntegerTuple,
  Aggregate: L1DistanceMeasureable,
  Native: L1DistanceMeasureable,
  Scalar == Aggregate.L1Distance,
  Scalar == Native.L1Distance
{
  for try await lhs in lhses {
    for rhs in rhses {
      _HDXLValidateOutOfPlaceAggregateScalarToScalarOperation(
        operationName(),
        tolerance: tolerance,
        lhses: Aggregate(integerTuple: lhs), Native(integerTuple: lhs),
        rhs: rhs,
        operations: aggregateOperation, nativeOperation,
        function: function,
        file: file,
        line: line,
        column: column
      )
    }
  }
}

func _HDXLValidateOutOfPlaceAggregateScalarToScalarOperation<Scalar, Aggregate, Native>(
  _ operationName: @autoclosure () -> String,
  tolerance: Scalar = .validationTestTolerance,
  lhses aggregateLHS: Aggregate,
  _ nativeLHS: Native,
  rhs: Scalar,
  operations aggregateOperation: (Aggregate, Scalar) -> Scalar,
  _ nativeOperation: (Native, Scalar) -> Scalar,
  function: StaticString = #function,
  file: StaticString = #filePath,
  line: UInt = #line,
  column: UInt = #column
) where
  Aggregate: NativeSIMDRepresentable,
  Native == Aggregate.NativeSIMDRepresentation,
  Aggregate: L1DistanceMeasureable,
  Native: L1DistanceMeasureable,
  Scalar == Aggregate.L1Distance,
  Scalar == Native.L1Distance
{
  // ///////////////////////////////////////////////////////////////////////////
  HDXLAssertNativeAndAggregateWithinEpsilon(
    tolerance,
    aggregate: aggregateLHS,
    native: nativeLHS,
    function: function,
    file: file,
    line: line,
    column: column
  )
  // ///////////////////////////////////////////////////////////////////////////
  let nativeResult = nativeOperation(nativeLHS, rhs)
  let aggregateResult = aggregateOperation(aggregateLHS, rhs)
  if abs(nativeResult - aggregateResult) >= tolerance {
    let name = operationName()
    XCTFail(
      """
      Validation failure for out-of-place `(Aggregate, Scalar) -> Scalar` operation \(name)
      
      - Summary:
        - `nativeResult`: \(nativeResult)
        - `aggregateResult`: \(aggregateResult)
        - `abs(nativeResult - aggregateResult)` -> \(abs(nativeResult - aggregateResult)) >= \(tolerance)
      - Details:
        - `Scalar`: \(String(reflecting: Scalar.self))
        - `Aggregate`: \(String(reflecting: Aggregate.self))
        - `Native`: \(String(reflecting: Native.self))
        - `operationName`: \(name)
        - `tolerance`: \(tolerance)
        - `aggregateLHS`: \(String(reflecting: aggregateLHS))
        - `nativeLHS`: \(String(reflecting: nativeLHS))
        - `rhs`: \(rhs)
        - `nativeResult`: \(nativeResult)
        - `aggregateResult`: \(aggregateResult)
        - `abs(nativeResult - aggregateResult)`: \(abs(nativeResult - aggregateResult))
        - `function`: \(function)
        - `file`: \(file)
        - `line`: \(line)
        - `column`: \(column)
      """,
      file: file,
      line: line
    )
  }
}

// -------------------------------------------------------------------------- //
// MARK: (Aggregate, Aggregate) -> Scalar
// -------------------------------------------------------------------------- //

func HDXLValidateOutOfPlaceAggregateAggregateToScalarOperation<Scalar, Aggregate, Native, IntegerTuple>(
  _ operationName: @autoclosure () -> String,
  on inputs: (Aggregate.Type, Aggregate.Type),
  tolerance: Scalar = .validationTestTolerance,
  lhses: AsyncStream<IntegerTuple>,
  rhses: AsyncStream<IntegerTuple>,
  operations aggregateOperation: (Aggregate, Aggregate) -> Scalar,
  _ nativeOperation: (Native, Native) -> Scalar,
  function: StaticString = #function,
  file: StaticString = #filePath,
  line: UInt = #line,
  column: UInt = #column
) async throws where
  Aggregate: NativeSIMDRepresentable,
  Native == Aggregate.NativeSIMDRepresentation,
  Aggregate: IntegerTupleConstructible,
  Native: IntegerTupleConstructible,
  Aggregate.IntegerTuple == IntegerTuple,
  Native.IntegerTuple == IntegerTuple,
  Aggregate: L1DistanceMeasureable,
  Native: L1DistanceMeasureable,
  Scalar == Aggregate.L1Distance,
  Scalar == Native.L1Distance
{
  for try await lhs in lhses {
    for try await rhs in rhses {
      _HDXLValidateOutOfPlaceAggregateAggregateToScalarOperation(
        operationName(),
        tolerance: tolerance,
        lhses: Aggregate(integerTuple: lhs), Native(integerTuple: lhs),
        rhses: Aggregate(integerTuple: rhs), Native(integerTuple: rhs),
        operations: aggregateOperation, nativeOperation,
        function: function,
        file: file,
        line: line,
        column: column
      )
    }
  }
}


func _HDXLValidateOutOfPlaceAggregateAggregateToScalarOperation<Scalar, Aggregate, Native>(
  _ operationName: @autoclosure () -> String,
  tolerance: Scalar = .validationTestTolerance,
  lhses aggregateLHS: Aggregate,
  _ nativeLHS: Native,
  rhses aggregateRHS: Aggregate,
  _ nativeRHS: Native,
  operations aggregateOperation: (Aggregate, Aggregate) -> Scalar,
  _ nativeOperation: (Native, Native) -> Scalar,
  function: StaticString = #function,
  file: StaticString = #filePath,
  line: UInt = #line,
  column: UInt = #column
) where
  Aggregate: NativeSIMDRepresentable,
  Native == Aggregate.NativeSIMDRepresentation,
  Aggregate: L1DistanceMeasureable,
  Native: L1DistanceMeasureable,
  Scalar == Aggregate.L1Distance,
  Scalar == Native.L1Distance
{
  // ///////////////////////////////////////////////////////////////////////////
  HDXLAssertNativeAndAggregateWithinEpsilon(
    tolerance,
    aggregate: aggregateLHS,
    native: nativeLHS,
    function: function,
    file: file,
    line: line,
    column: column
  )
  HDXLAssertNativeAndAggregateWithinEpsilon(
    tolerance,
    aggregate: aggregateRHS,
    native: nativeRHS,
    function: function,
    file: file,
    line: line,
    column: column
  )
  // ///////////////////////////////////////////////////////////////////////////
  let nativeResult = nativeOperation(nativeLHS, nativeRHS)
  let aggregateResult = aggregateOperation(aggregateLHS, aggregateRHS)
  if abs(nativeResult - aggregateResult) >= tolerance {
    let name = operationName()
    XCTFail(
      """
      Validation failure for out-of-place `(Aggregate, Aggregate) -> Scalar` operation \(name)
      
      - Summary:
        - `nativeResult`: \(nativeResult)
        - `aggregateResult`: \(aggregateResult)
        - `abs(nativeResult - aggregateResult)` -> \(abs(nativeResult - aggregateResult)) >= \(tolerance)
      - Details:
        - `Scalar`: \(String(reflecting: Scalar.self))
        - `Aggregate`: \(String(reflecting: Aggregate.self))
        - `Native`: \(String(reflecting: Native.self))
        - `operationName`: \(name)
        - `tolerance`: \(tolerance)
        - `aggregateLHS`: \(String(reflecting: aggregateLHS))
        - `nativeLHS`: \(String(reflecting: nativeLHS))
        - `aggregateRHS`: \(String(reflecting: aggregateRHS))
        - `nativeRHS`: \(String(reflecting: nativeRHS))
        - `nativeResult`: \(nativeResult)
        - `aggregateResult`: \(aggregateResult)
        - `abs(nativeResult - aggregateResult)`: \(abs(nativeResult - aggregateResult))
        - `function`: \(function)
        - `file`: \(file)
        - `line`: \(line)
        - `column`: \(column)
      """,
      file: file,
      line: line
    )
  }
}

// -------------------------------------------------------------------------- //
// MARK: (Scalar, Aggregate) -> Aggregate
// -------------------------------------------------------------------------- //

func HDXLValidateOutOfPlaceScalarAggregateToAggregateOperation<Scalar, Aggregate, Native, IntegerTuple>(
  _ operationName: @autoclosure () -> String,
  on inputs: (Scalar.Type, Aggregate.Type),
  tolerance: Scalar = .validationTestTolerance,
  lhses: some Sequence<Scalar>,
  rhses: AsyncStream<IntegerTuple>,
  operations aggregateOperation: (Scalar, Aggregate) -> Aggregate,
  _ nativeOperation: (Scalar, Native) -> Native,
  function: StaticString = #function,
  file: StaticString = #filePath,
  line: UInt = #line,
  column: UInt = #column
) async throws where
  Aggregate: NativeSIMDRepresentable,
  Native == Aggregate.NativeSIMDRepresentation,
  Aggregate: IntegerTupleConstructible,
  Native: IntegerTupleConstructible,
  Aggregate.IntegerTuple == IntegerTuple,
  Native.IntegerTuple == IntegerTuple,
  Aggregate: L1DistanceMeasureable,
  Native: L1DistanceMeasureable,
  Scalar == Aggregate.L1Distance,
  Scalar == Native.L1Distance
{
  for lhs in lhses {
    for try await rhs in rhses {
      _HDXLValidateOutOfPlaceScalarAggregateToAggregateOperation(
        operationName(),
        tolerance: tolerance,
        lhs: lhs,
        rhses: Aggregate(integerTuple: rhs), Native(integerTuple: rhs),
        operations: aggregateOperation, nativeOperation,
        function: function,
        file: file,
        line: line,
        column: column
      )
    }
  }
}


func _HDXLValidateOutOfPlaceScalarAggregateToAggregateOperation<Scalar, Aggregate, Native>(
  _ operationName: @autoclosure () -> String,
  tolerance: Scalar = .validationTestTolerance,
  lhs: Scalar,
  rhses aggregateRHS: Aggregate,
  _ nativeRHS: Native,
  operations aggregateOperation: (Scalar, Aggregate) -> Aggregate,
  _ nativeOperation: (Scalar, Native) -> Native,
  function: StaticString = #function,
  file: StaticString = #filePath,
  line: UInt = #line,
  column: UInt = #column
) where
  Aggregate: NativeSIMDRepresentable,
  Native == Aggregate.NativeSIMDRepresentation,
  Aggregate: L1DistanceMeasureable,
  Native: L1DistanceMeasureable,
  Scalar == Aggregate.L1Distance,
  Scalar == Native.L1Distance
{
  // ///////////////////////////////////////////////////////////////////////////
  HDXLAssertNativeAndAggregateWithinEpsilon(
    tolerance,
    aggregate: aggregateRHS,
    native: nativeRHS,
    function: function,
    file: file,
    line: line,
    column: column
  )
  // ///////////////////////////////////////////////////////////////////////////
  let nativeResult = nativeOperation(lhs, nativeRHS)
  let aggregateResult = aggregateOperation(lhs, aggregateRHS)
  let distanceAsAggregates = aggregateResult.l1Distance(to: Aggregate(nativeSIMDRepresentation: nativeResult))
  let distanceAsNatives = nativeResult.l1Distance(to: aggregateResult.nativeSIMDRepresentation)
  let distanceOfDistances = abs(distanceAsAggregates - distanceAsAggregates)
  let maximumDistance = max(distanceAsAggregates, distanceAsNatives, distanceOfDistances)
  if maximumDistance >= tolerance {
    let name = operationName()
    XCTFail(
      """
      Validation failure for out-of-place `(Scalar, Aggregate) -> Aggregate` operation \(name)
      
      - Summary:
        - `nativeResult`: \(nativeResult)
        - `aggregateResult`: \(aggregateResult)
        - `maximumDistance` -> \(maximumDistance) >= \(tolerance)
      - Details:
        - `Scalar`: \(String(reflecting: Scalar.self))
        - `Aggregate`: \(String(reflecting: Aggregate.self))
        - `Native`: \(String(reflecting: Native.self))
        - `operationName`: \(name)
        - `tolerance`: \(tolerance)
        - `lhs`: \(lhs)
        - `aggregateRHS`: \(String(reflecting: aggregateRHS))
        - `nativeRHS`: \(String(reflecting: nativeRHS))
        - `aggregateResult`: \(String(reflecting: aggregateResult))
        - `nativeResult`: \(String(reflecting: nativeResult))
        - `distanceAsAggregates`: \(distanceAsAggregates)
        - `distanceAsNatives`: \(distanceAsNatives)
        - `distanceOfDistances`: \(distanceOfDistances)
        - `maximumDistance`: \(maximumDistance)
        - `function`: \(function)
        - `file`: \(file)
        - `line`: \(line)
        - `column`: \(column)
      """,
      file: file,
      line: line
    )
  }
}

// -------------------------------------------------------------------------- //
// MARK: (Aggregate, Scalar) -> Aggregate
// -------------------------------------------------------------------------- //

func HDXLValidateOutOfPlaceAggregateScalarToAggregateOperation<Scalar, Aggregate, Native, IntegerTuple>(
  _ operationName: @autoclosure () -> String,
  on inputs: (Aggregate.Type, Scalar.Type),
  tolerance: Scalar = .validationTestTolerance,
  lhses: AsyncStream<IntegerTuple>,
  rhses: some Sequence<Scalar>,
  operations aggregateOperation: (Aggregate, Scalar) -> Aggregate,
  _ nativeOperation: (Native, Scalar) -> Native,
  function: StaticString = #function,
  file: StaticString = #filePath,
  line: UInt = #line,
  column: UInt = #column
) async throws where
  Aggregate: NativeSIMDRepresentable,
  Native == Aggregate.NativeSIMDRepresentation,
  Aggregate: IntegerTupleConstructible,
  Native: IntegerTupleConstructible,
  Aggregate.IntegerTuple == IntegerTuple,
  Native.IntegerTuple == IntegerTuple,
  Aggregate: L1DistanceMeasureable,
  Native: L1DistanceMeasureable,
  Scalar == Aggregate.L1Distance,
  Scalar == Native.L1Distance
{
  for try await lhs in lhses {
    for rhs in rhses {
      _HDXLValidateOutOfPlaceAggregateScalarToAggregateOperation(
        operationName(),
        tolerance: tolerance,
        lhses: Aggregate(integerTuple: lhs), Native(integerTuple: lhs),
        rhs: rhs,
        operations: aggregateOperation, nativeOperation,
        function: function,
        file: file,
        line: line,
        column: column
      )
    }
  }
}


func _HDXLValidateOutOfPlaceAggregateScalarToAggregateOperation<Scalar, Aggregate, Native>(
  _ operationName: @autoclosure () -> String,
  tolerance: Scalar = .validationTestTolerance,
  lhses aggregateLHS: Aggregate,
  _ nativeLHS: Native,
  rhs: Scalar,
  operations aggregateOperation: (Aggregate, Scalar) -> Aggregate,
  _ nativeOperation: (Native, Scalar) -> Native,
  function: StaticString = #function,
  file: StaticString = #filePath,
  line: UInt = #line,
  column: UInt = #column
) where
  Aggregate: NativeSIMDRepresentable,
  Native == Aggregate.NativeSIMDRepresentation,
  Aggregate: L1DistanceMeasureable,
  Native: L1DistanceMeasureable,
  Scalar == Aggregate.L1Distance,
  Scalar == Native.L1Distance
{
  // ///////////////////////////////////////////////////////////////////////////
  HDXLAssertNativeAndAggregateWithinEpsilon(
    tolerance,
    aggregate: aggregateLHS,
    native: nativeLHS,
    function: function,
    file: file,
    line: line,
    column: column
  )
  // ///////////////////////////////////////////////////////////////////////////
  let nativeResult = nativeOperation(nativeLHS, rhs)
  let aggregateResult = aggregateOperation(aggregateLHS, rhs)
  let distanceAsAggregates = aggregateResult.l1Distance(to: Aggregate(nativeSIMDRepresentation: nativeResult))
  let distanceAsNatives = nativeResult.l1Distance(to: aggregateResult.nativeSIMDRepresentation)
  let distanceOfDistances = abs(distanceAsAggregates - distanceAsAggregates)
  let maximumDistance = max(distanceAsAggregates, distanceAsNatives, distanceOfDistances)
  if maximumDistance >= tolerance {
    let name = operationName()
    XCTFail(
      """
      Validation failure for out-of-place `(Aggregate, Scalar) -> Aggregate` operation \(name)
      
      - Summary:
        - `nativeResult`: \(nativeResult)
        - `aggregateResult`: \(aggregateResult)
        - `maximumDistance` -> \(maximumDistance) >= \(tolerance)
      - Details:
        - `Scalar`: \(String(reflecting: Scalar.self))
        - `Aggregate`: \(String(reflecting: Aggregate.self))
        - `Native`: \(String(reflecting: Native.self))
        - `operationName`: \(name)
        - `tolerance`: \(tolerance)
        - `aggregateLHS`: \(String(reflecting: aggregateLHS))
        - `nativeLHS`: \(String(reflecting: nativeLHS))
        - `rhs`: \(rhs)
        - `aggregateResult`: \(String(reflecting: aggregateResult))
        - `nativeResult`: \(String(reflecting: nativeResult))
        - `distanceAsAggregates`: \(distanceAsAggregates)
        - `distanceAsNatives`: \(distanceAsNatives)
        - `distanceOfDistances`: \(distanceOfDistances)
        - `maximumDistance`: \(maximumDistance)
        - `function`: \(function)
        - `file`: \(file)
        - `line`: \(line)
        - `column`: \(column)
      """,
      file: file,
      line: line
    )
  }
}

// -------------------------------------------------------------------------- //
// MARK: (Aggregate, Aggregate) -> Aggregate
// -------------------------------------------------------------------------- //

func HDXLValidateOutOfPlaceAggregateAggregateToAggregateOperation<Distance, Aggregate, Native, IntegerTuple>(
  _ operationName: @autoclosure () -> String,
  on inputs: (Aggregate.Type, Aggregate.Type),
  tolerance: Distance = .validationTestTolerance,
  lhses: AsyncStream<IntegerTuple>,
  rhses: AsyncStream<IntegerTuple>,
  operations aggregateOperation: (Aggregate, Aggregate) -> Aggregate,
  _ nativeOperation: (Native, Native) -> Native,
  function: StaticString = #function,
  file: StaticString = #filePath,
  line: UInt = #line,
  column: UInt = #column
) async throws where
  Aggregate: NativeSIMDRepresentable,
  Native == Aggregate.NativeSIMDRepresentation,
  Aggregate: IntegerTupleConstructible,
  Native: IntegerTupleConstructible,
  Aggregate.IntegerTuple == IntegerTuple,
  Native.IntegerTuple == IntegerTuple,
  Aggregate: L1DistanceMeasureable,
  Native: L1DistanceMeasureable,
  Distance == Aggregate.L1Distance,
  Distance == Native.L1Distance
{
  for try await lhs in lhses {
    for try await rhs in rhses {
      _HDXLValidateOutOfPlaceAggregateAggregateToAggregateOperation(
        operationName(),
        tolerance: tolerance,
        lhses: Aggregate(integerTuple: lhs), Native(integerTuple: lhs),
        rhses: Aggregate(integerTuple: rhs), Native(integerTuple: rhs),
        operations: aggregateOperation, nativeOperation,
        function: function,
        file: file,
        line: line,
        column: column
      )
    }
  }
}


func _HDXLValidateOutOfPlaceAggregateAggregateToAggregateOperation<Distance, Aggregate, Native>(
  _ operationName: @autoclosure () -> String,
  tolerance: Distance = .validationTestTolerance,
  lhses aggregateLHS: Aggregate,
  _ nativeLHS: Native,
  rhses aggregateRHS: Aggregate,
  _ nativeRHS: Native,
  operations aggregateOperation: (Aggregate, Aggregate) -> Aggregate,
  _ nativeOperation: (Native, Native) -> Native,
  function: StaticString = #function,
  file: StaticString = #filePath,
  line: UInt = #line,
  column: UInt = #column
) where
  Aggregate: NativeSIMDRepresentable,
  Native == Aggregate.NativeSIMDRepresentation,
  Aggregate: L1DistanceMeasureable,
  Native: L1DistanceMeasureable,
  Distance == Aggregate.L1Distance,
  Distance == Native.L1Distance
{
  // ///////////////////////////////////////////////////////////////////////////
  HDXLAssertNativeAndAggregateWithinEpsilon(
    tolerance,
    aggregate: aggregateLHS,
    native: nativeLHS,
    function: function,
    file: file,
    line: line,
    column: column
  )
  HDXLAssertNativeAndAggregateWithinEpsilon(
    tolerance,
    aggregate: aggregateRHS,
    native: nativeRHS,
    function: function,
    file: file,
    line: line,
    column: column
  )
  // ///////////////////////////////////////////////////////////////////////////
  let nativeResult = nativeOperation(nativeLHS, nativeRHS)
  let aggregateResult = aggregateOperation(aggregateLHS, aggregateRHS)
  let promotedNativeResult = Aggregate(nativeSIMDRepresentation: nativeResult)
  let demotedAggregateResult = aggregateResult.nativeSIMDRepresentation
  let nativeDistance = nativeResult.l1Distance(to: demotedAggregateResult)
  let aggregateDistance = aggregateResult.l1Distance(to: promotedNativeResult)
  let distance = max(nativeDistance, aggregateDistance)
  if distance >= tolerance {
    let name = operationName()
    XCTFail(
      """
      Validation failure for out-of-place `(Aggregate, Aggregate) -> Aggregate` operation \(name)
      
      - Summary:
        - `nativeResult`: \(nativeResult)
        - `aggregateResult`: \(aggregateResult)
        - `promotedNativeResult`: \(promotedNativeResult)
        - `demotedAggregateResult`: \(demotedAggregateResult)
        - `nativeDistance`: \(nativeDistance)
        - `aggregateDistance`: \(aggregateDistance)
        - `distance` -> \(distance) >= \(tolerance)
      - Details:
        - `Distance`: \(String(reflecting: Distance.self))
        - `Aggregate`: \(String(reflecting: Aggregate.self))
        - `Native`: \(String(reflecting: Native.self))
        - `operationName`: \(name)
        - `tolerance`: \(tolerance)
        - `aggregateLHS`: \(String(reflecting: aggregateLHS))
        - `nativeLHS`: \(String(reflecting: nativeLHS))
        - `aggregateRHS`: \(String(reflecting: aggregateRHS))
        - `nativeRHS`: \(String(reflecting: nativeRHS))
        - `nativeResult`: \(String(reflecting: nativeResult))
        - `aggregateResult`: \(String(reflecting: aggregateResult))
        - `promotedNativeResult`: \(promotedNativeResult)
        - `demotedAggregateResult`: \(demotedAggregateResult)
        - `nativeDistance`: \(nativeDistance)
        - `aggregateDistance`: \(aggregateDistance)
        - `distance`: \(distance)
        - `function`: \(function)
        - `file`: \(file)
        - `line`: \(line)
        - `column`: \(column)
      """,
      file: file,
      line: line
    )
  }
}

// -------------------------------------------------------------------------- //
// MARK: (Aggregate) -> Aggregate
// -------------------------------------------------------------------------- //

func HDXLValidateOutOfPlaceAggregateToAggregateOperation<Distance, Aggregate, Native, IntegerTuple>(
  _ operationName: @autoclosure () -> String,
  on inputs: (Aggregate.Type),
  tolerance: Distance = .validationTestTolerance,
  probes: AsyncStream<IntegerTuple>,
  operations aggregateOperation: (Aggregate) -> Aggregate,
  _ nativeOperation: (Native) -> Native,
  function: StaticString = #function,
  file: StaticString = #filePath,
  line: UInt = #line,
  column: UInt = #column
) async throws where
  Aggregate: NativeSIMDRepresentable,
  Native == Aggregate.NativeSIMDRepresentation,
  Aggregate: IntegerTupleConstructible,
  Native: IntegerTupleConstructible,
  Aggregate.IntegerTuple == IntegerTuple,
  Native.IntegerTuple == IntegerTuple,
  Aggregate: L1DistanceMeasureable,
  Native: L1DistanceMeasureable,
  Distance == Aggregate.L1Distance,
  Distance == Native.L1Distance
{
  for try await probe in probes {
    _HDXLValidateOutOfPlaceAggregateToAggregateOperation(
      operationName(),
      tolerance: tolerance,
      probes: Aggregate(integerTuple: probe), Native(integerTuple: probe),
      operations: aggregateOperation, nativeOperation,
      function: function,
      file: file,
      line: line,
      column: column
    )
  }
}


func _HDXLValidateOutOfPlaceAggregateToAggregateOperation<Distance, Aggregate, Native>(
  _ operationName: @autoclosure () -> String,
  tolerance: Distance = .validationTestTolerance,
  probes aggregateProbe: Aggregate,
  _ nativeProbe: Native,
  operations aggregateOperation: (Aggregate) -> Aggregate,
  _ nativeOperation: (Native) -> Native,
  function: StaticString = #function,
  file: StaticString = #filePath,
  line: UInt = #line,
  column: UInt = #column
) where
  Aggregate: NativeSIMDRepresentable,
  Native == Aggregate.NativeSIMDRepresentation,
  Aggregate: L1DistanceMeasureable,
  Native: L1DistanceMeasureable,
  Distance == Aggregate.L1Distance,
  Distance == Native.L1Distance
{
  // ///////////////////////////////////////////////////////////////////////////
  HDXLAssertNativeAndAggregateWithinEpsilon(
    tolerance,
    aggregate: aggregateProbe,
    native: nativeProbe,
    function: function,
    file: file,
    line: line,
    column: column
  )
  // ///////////////////////////////////////////////////////////////////////////
  let nativeResult = nativeOperation(nativeProbe)
  let aggregateResult = aggregateOperation(aggregateProbe)
  let promotedNativeResult = Aggregate(nativeSIMDRepresentation: nativeResult)
  let demotedAggregateResult = aggregateResult.nativeSIMDRepresentation
  let nativeDistance = nativeResult.l1Distance(to: demotedAggregateResult)
  let aggregateDistance = aggregateResult.l1Distance(to: promotedNativeResult)
  let distance = max(nativeDistance, aggregateDistance)
  if distance >= tolerance {
    let name = operationName()
    XCTFail(
      """
      Validation failure for out-of-place `(Aggregate) -> Aggregate` operation \(name)
      
      - Summary:
        - `nativeResult`: \(nativeResult)
        - `aggregateResult`: \(aggregateResult)
        - `promotedNativeResult`: \(promotedNativeResult)
        - `demotedAggregateResult`: \(demotedAggregateResult)
        - `nativeDistance`: \(nativeDistance)
        - `aggregateDistance`: \(aggregateDistance)
        - `distance` -> \(distance) >= \(tolerance)
      - Details:
        - `Distance`: \(String(reflecting: Distance.self))
        - `Aggregate`: \(String(reflecting: Aggregate.self))
        - `Native`: \(String(reflecting: Native.self))
        - `operationName`: \(name)
        - `tolerance`: \(tolerance)
        - `aggregateProbe`: \(String(reflecting: aggregateProbe))
        - `nativeProbe`: \(String(reflecting: nativeProbe))
        - `nativeResult`: \(String(reflecting: nativeResult))
        - `aggregateResult`: \(String(reflecting: aggregateResult))
        - `promotedNativeResult`: \(promotedNativeResult)
        - `demotedAggregateResult`: \(demotedAggregateResult)
        - `nativeDistance`: \(nativeDistance)
        - `aggregateDistance`: \(aggregateDistance)
        - `distance`: \(distance)
        - `function`: \(function)
        - `file`: \(file)
        - `line`: \(line)
        - `column`: \(column)
      """,
      file: file,
      line: line
    )
  }
}

// -------------------------------------------------------------------------- //
// MARK: (X, Y) -> Z (Common)
// -------------------------------------------------------------------------- //

func HDXLValidateOutOfPlaceHeterogeneousAggregateAggregateToCommonOutputOperation<
  Distance,
  AggregateLHS,
  NativeLHS,
  AggregateRHS,
  NativeRHS,
  CommonOutput,
  IntegerTupleLHS,
  IntegerTupleRHS
>(
  _ operationName: @autoclosure () -> String,
  on inputs: (AggregateLHS.Type, AggregateRHS.Type),
  tolerance: Distance = .validationTestTolerance,
  lhses: AsyncStream<IntegerTupleLHS>,
  rhses: AsyncStream<IntegerTupleRHS>,
  operations aggregateOperation: (AggregateLHS, AggregateRHS) -> CommonOutput,
  _ nativeOperation: (NativeLHS, NativeRHS) -> CommonOutput,
  function: StaticString = #function,
  file: StaticString = #filePath,
  line: UInt = #line,
  column: UInt = #column
) async throws where
  AggregateLHS: NativeSIMDRepresentable,
  AggregateLHS.NativeSIMDRepresentation == NativeLHS,
  AggregateLHS: IntegerTupleConstructible,
  AggregateLHS.IntegerTuple == IntegerTupleLHS,
  AggregateLHS: L1DistanceMeasureable,
  AggregateLHS.L1Distance == Distance,
  NativeLHS: IntegerTupleConstructible,
  NativeLHS.IntegerTuple == IntegerTupleLHS,
  NativeLHS: L1DistanceMeasureable,
  NativeLHS.L1Distance == Distance,
  AggregateRHS: NativeSIMDRepresentable,
  AggregateRHS.NativeSIMDRepresentation == NativeRHS,
  AggregateRHS: IntegerTupleConstructible,
  AggregateRHS.IntegerTuple == IntegerTupleRHS,
  AggregateRHS: L1DistanceMeasureable,
  AggregateRHS.L1Distance == Distance,
  NativeRHS: IntegerTupleConstructible,
  NativeRHS.IntegerTuple == IntegerTupleRHS,
  NativeRHS: L1DistanceMeasureable,
  NativeRHS.L1Distance == Distance,
  CommonOutput: L1DistanceMeasureable,
  CommonOutput.L1Distance == Distance
{
  for try await lhs in lhses {
    for try await rhs in rhses {
      _HDXLValidateOutOfPlaceHeterogeneousAggregateAggregateToCommonOutputOperation(
        operationName(),
        tolerance: tolerance,
        lhses: AggregateLHS(integerTuple: lhs), NativeLHS(integerTuple: lhs),
        rhses: AggregateRHS(integerTuple: rhs), NativeRHS(integerTuple: rhs),
        operations: aggregateOperation, nativeOperation,
        function: function,
        file: file,
        line: line,
        column: column
      )
    }
  }
}


func _HDXLValidateOutOfPlaceHeterogeneousAggregateAggregateToCommonOutputOperation<
  Distance,
  AggregateLHS,
  NativeLHS,
  AggregateRHS,
  NativeRHS,
  CommonOutput
>(
  _ operationName: @autoclosure () -> String,
  tolerance: Distance = .validationTestTolerance,
  lhses aggregateLHS: AggregateLHS,
  _ nativeLHS: NativeLHS,
  rhses aggregateRHS: AggregateRHS,
  _ nativeRHS: NativeRHS,
  operations aggregateOperation: (AggregateLHS, AggregateRHS) -> CommonOutput,
  _ nativeOperation: (NativeLHS, NativeRHS) -> CommonOutput,
  function: StaticString = #function,
  file: StaticString = #filePath,
  line: UInt = #line,
  column: UInt = #column
) where
  AggregateLHS: NativeSIMDRepresentable,
  NativeLHS == AggregateLHS.NativeSIMDRepresentation,
  AggregateRHS: NativeSIMDRepresentable,
  NativeRHS == AggregateRHS.NativeSIMDRepresentation,
  AggregateLHS: L1DistanceMeasureable,
  NativeLHS: L1DistanceMeasureable,
  AggregateRHS: L1DistanceMeasureable,
  NativeRHS: L1DistanceMeasureable,
  CommonOutput: L1DistanceMeasureable,
  Distance == AggregateLHS.L1Distance,
  Distance == NativeLHS.L1Distance,
  Distance == AggregateRHS.L1Distance,
  Distance == NativeRHS.L1Distance,
  Distance == CommonOutput.L1Distance
{
  // ///////////////////////////////////////////////////////////////////////////
  HDXLAssertNativeAndAggregateWithinEpsilon(
    tolerance,
    aggregate: aggregateLHS,
    native: nativeLHS,
    function: function,
    file: file,
    line: line,
    column: column
  )
  HDXLAssertNativeAndAggregateWithinEpsilon(
    tolerance,
    aggregate: aggregateRHS,
    native: nativeRHS,
    function: function,
    file: file,
    line: line,
    column: column
  )
  // ///////////////////////////////////////////////////////////////////////////
  let nativeResult = nativeOperation(nativeLHS, nativeRHS)
  let aggregateResult = aggregateOperation(aggregateLHS, aggregateRHS)
  let distance = nativeResult.l1Distance(to: aggregateResult)
  if distance >= tolerance {
    let name = operationName()
    XCTFail(
      """
      Validation failure for out-of-place `(X, Y) -> Z (Common)` operation \(name)
      
      - Summary:
        - `nativeResult`: \(nativeResult)
        - `aggregateResult`: \(aggregateResult)
        - `distance`: \(distance) >= \(tolerance)
      - Details:
        - `Distance`: \(String(reflecting: Distance.self))
        - `AggregateLHS`: \(String(reflecting: AggregateLHS.self))
        - `AggregateRHS`: \(String(reflecting: AggregateRHS.self))
        - `NativeLHS`: \(String(reflecting: NativeLHS.self))
        - `NativeRHS`: \(String(reflecting: NativeRHS.self))
        - `operationName`: \(name)
        - `tolerance`: \(tolerance)
        - `nativeLHS`: \(String(reflecting: nativeLHS))
        - `aggregateLHS`: \(String(reflecting: aggregateLHS))
        - `nativeRHS`: \(String(reflecting: nativeRHS))
        - `aggregateRHS`: \(String(reflecting: aggregateRHS))
        - `nativeResult`: \(String(reflecting: nativeResult))
        - `aggregateResult`: \(String(reflecting: aggregateResult))
        - `distance`: \(distance)
        - `function`: \(function)
        - `file`: \(file)
        - `line`: \(line)
        - `column`: \(column)
      """,
      file: file,
      line: line
    )
  }
}

// -------------------------------------------------------------------------- //
// MARK: (X, Y) -> Z (Aggregate)
// -------------------------------------------------------------------------- //

func HDXLValidateOutOfPlaceHeterogeneousAggregateAggregateToAggregateOperation<
  Distance,
  AggregateLHS,
  NativeLHS,
  AggregateRHS,
  NativeRHS,
  AggregateOutput,
  NativeOutput,
  IntegerTupleLHS,
  IntegerTupleRHS
>(
  _ operationName: @autoclosure () -> String,
  on inputs: (AggregateLHS.Type, AggregateRHS.Type),
  tolerance: Distance = .validationTestTolerance,
  lhses: AsyncStream<IntegerTupleLHS>,
  rhses: AsyncStream<IntegerTupleRHS>,
  operations aggregateOperation: (AggregateLHS, AggregateRHS) -> AggregateOutput,
  _ nativeOperation: (NativeLHS, NativeRHS) -> NativeOutput,
  function: StaticString = #function,
  file: StaticString = #filePath,
  line: UInt = #line,
  column: UInt = #column
) async throws where
  AggregateLHS: NativeSIMDRepresentable,
  AggregateLHS.NativeSIMDRepresentation == NativeLHS,
  AggregateLHS: IntegerTupleConstructible,
  AggregateLHS.IntegerTuple == IntegerTupleLHS,
  AggregateLHS: L1DistanceMeasureable,
  AggregateLHS.L1Distance == Distance,
  NativeLHS: IntegerTupleConstructible,
  NativeLHS.IntegerTuple == IntegerTupleLHS,
  NativeLHS: L1DistanceMeasureable,
  NativeLHS.L1Distance == Distance,
  AggregateRHS: NativeSIMDRepresentable,
  AggregateRHS.NativeSIMDRepresentation == NativeRHS,
  AggregateRHS: IntegerTupleConstructible,
  AggregateRHS.IntegerTuple == IntegerTupleRHS,
  AggregateRHS: L1DistanceMeasureable,
  AggregateRHS.L1Distance == Distance,
  NativeRHS: IntegerTupleConstructible,
  NativeRHS.IntegerTuple == IntegerTupleRHS,
  NativeRHS: L1DistanceMeasureable,
  NativeRHS.L1Distance == Distance,
  AggregateOutput: L1DistanceMeasureable,
  AggregateOutput.L1Distance == Distance,
  AggregateOutput: NativeSIMDRepresentable,
  AggregateOutput.NativeSIMDRepresentation == NativeOutput,
  NativeOutput: L1DistanceMeasureable,
  NativeOutput.L1Distance == Distance
{
  for try await lhs in lhses {
    for try await rhs in rhses {
      _HDXLValidateOutOfPlaceHeterogeneousAggregateAggregateToAggregateOperation(
        operationName(),
        tolerance: tolerance,
        lhses: AggregateLHS(integerTuple: lhs), NativeLHS(integerTuple: lhs),
        rhses: AggregateRHS(integerTuple: rhs), NativeRHS(integerTuple: rhs),
        operations: aggregateOperation, nativeOperation,
        function: function,
        file: file,
        line: line,
        column: column
      )
    }
  }
}


func _HDXLValidateOutOfPlaceHeterogeneousAggregateAggregateToAggregateOperation<
  Distance,
  AggregateLHS,
  NativeLHS,
  AggregateRHS,
  NativeRHS,
  AggregateOutput,
  NativeOutput
>(
  _ operationName: @autoclosure () -> String,
  tolerance: Distance = .validationTestTolerance,
  lhses aggregateLHS: AggregateLHS,
  _ nativeLHS: NativeLHS,
  rhses aggregateRHS: AggregateRHS,
  _ nativeRHS: NativeRHS,
  operations aggregateOperation: (AggregateLHS, AggregateRHS) -> AggregateOutput,
  _ nativeOperation: (NativeLHS, NativeRHS) -> NativeOutput,
  function: StaticString = #function,
  file: StaticString = #filePath,
  line: UInt = #line,
  column: UInt = #column
) where
  AggregateLHS: NativeSIMDRepresentable,
  NativeLHS == AggregateLHS.NativeSIMDRepresentation,
  AggregateRHS: NativeSIMDRepresentable,
  NativeRHS == AggregateRHS.NativeSIMDRepresentation,
  AggregateLHS: L1DistanceMeasureable,
  NativeLHS: L1DistanceMeasureable,
  AggregateRHS: L1DistanceMeasureable,
  NativeRHS: L1DistanceMeasureable,
  AggregateOutput: L1DistanceMeasureable,
  AggregateOutput: NativeSIMDRepresentable,
  AggregateOutput.NativeSIMDRepresentation == NativeOutput,
  NativeOutput: L1DistanceMeasureable,
  Distance == AggregateLHS.L1Distance,
  Distance == NativeLHS.L1Distance,
  Distance == AggregateRHS.L1Distance,
  Distance == NativeRHS.L1Distance,
  Distance == AggregateOutput.L1Distance,
  Distance == NativeOutput.L1Distance
{
  // ///////////////////////////////////////////////////////////////////////////
  HDXLAssertNativeAndAggregateWithinEpsilon(
    tolerance,
    aggregate: aggregateLHS,
    native: nativeLHS,
    function: function,
    file: file,
    line: line,
    column: column
  )
  HDXLAssertNativeAndAggregateWithinEpsilon(
    tolerance,
    aggregate: aggregateRHS,
    native: nativeRHS,
    function: function,
    file: file,
    line: line,
    column: column
  )
  // ///////////////////////////////////////////////////////////////////////////
  let nativeResult = nativeOperation(nativeLHS, nativeRHS)
  let aggregateResult = aggregateOperation(aggregateLHS, aggregateRHS)
  let distanceAsAggregates = aggregateResult.l1Distance(to: AggregateOutput(nativeSIMDRepresentation: nativeResult))
  let distanceAsNatives = nativeResult.l1Distance(to: aggregateResult.nativeSIMDRepresentation)
  let distanceOfDistances = abs(distanceAsAggregates - distanceAsAggregates)
  let maximumDistance = max(distanceAsAggregates, distanceAsNatives, distanceOfDistances)
  if maximumDistance >= tolerance {
    let name = operationName()
    XCTFail(
      """
      Validation failure for out-of-place `(X, Y) -> Z (Aggregate)` operation \(name)
      
      - Summary:
        - `nativeResult`: \(nativeResult)
        - `aggregateResult`: \(aggregateResult)
        - `distance`: \(maximumDistance) >= \(tolerance)
      - Details:
        - `Distance`: \(String(reflecting: Distance.self))
        - `AggregateLHS`: \(String(reflecting: AggregateLHS.self))
        - `AggregateRHS`: \(String(reflecting: AggregateRHS.self))
        - `AggregateOutput`: \(String(reflecting: AggregateOutput.self))
        - `NativeLHS`: \(String(reflecting: NativeLHS.self))
        - `NativeRHS`: \(String(reflecting: NativeRHS.self))
        - `NativeOutput`: \(String(reflecting: NativeRHS.self))
        - `operationName`: \(name)
        - `tolerance`: \(tolerance)
        - `nativeLHS`: \(String(reflecting: nativeLHS))
        - `aggregateLHS`: \(String(reflecting: aggregateLHS))
        - `nativeRHS`: \(String(reflecting: nativeRHS))
        - `aggregateRHS`: \(String(reflecting: aggregateRHS))
        - `nativeResult`: \(String(reflecting: nativeResult))
        - `aggregateResult`: \(String(reflecting: aggregateResult))
        - `distanceAsAggregates`: \(distanceAsAggregates)
        - `distanceAsNatives`: \(distanceAsNatives)
        - `distanceOfDistances`: \(distanceOfDistances)
        - `maximumDistance`: \(maximumDistance)
        - `function`: \(function)
        - `file`: \(file)
        - `line`: \(line)
        - `column`: \(column)
      """,
      file: file,
      line: line
    )
  }
}
