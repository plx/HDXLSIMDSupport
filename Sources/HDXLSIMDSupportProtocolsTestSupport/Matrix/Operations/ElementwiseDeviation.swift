import Testing

fileprivate func inject<each T>(
  labeledFields: (repeat (String, each T))
) -> String {
  var result: String = ""
  for labeledField in repeat each labeledFields {
    result.append(
      """
      - `\(labeledField.0)`: \(String(describing: labeledField.1))
      """
    )
  }
  
  return result
}

@usableFromInline
package func verifyScalarExpectation<Scalar, each T>(
  observation: Scalar,
  expectation: Scalar,
  tolerance: Scalar,
  fields labeledFields: @autoclosure () -> (repeat (String, each T)),
  explanation: @autoclosure () -> String,
  function: StaticString = #function,
  sourceLocation: SourceLocation = SourceLocation()
) where Scalar: BinaryFloatingPoint {
  let deviationFromExpectation = abs(observation - expectation)
  #expect(
    deviationFromExpectation < tolerance,
      """
      Unexpectedly found excessive deviation for componentwise matrix operation \(explanation()):

      \(inject(labeledFields: labeledFields()))
      - `observation`: \(observation)
      - `expectation`: \(expectation)
      - `deviationFromExpectation`: \(deviationFromExpectation)
      - `function`: \(function)
      - `fileID`: \(sourceLocation.fileID)
      - `line`: \(sourceLocation.line)
      - `column`: \(sourceLocation.column)
      """,
    sourceLocation: sourceLocation
  )

}

@usableFromInline
package func verifyScalarProperty<Scalar, each T>(
  value: Scalar,
  fields labeledFields: @autoclosure () -> (repeat (String, each T)),
  explanation: @autoclosure () -> String,
  function: StaticString = #function,
  sourceLocation: SourceLocation = SourceLocation(),
  _ property: (Scalar) throws -> Bool
) rethrows where Scalar: BinaryFloatingPoint {
  #expect(
  try property(value),
    """
    Property `\(explanation())` not satisfied for \(value):
    
    \(inject(labeledFields: labeledFields()))
    - `value`: \(value)
    - `function`: \(function)
    - `fileID`: \(sourceLocation.fileID)
    - `line`: \(sourceLocation.line)
    - `column`: \(sourceLocation.column)
    """,
    sourceLocation: sourceLocation
  )
  
}
