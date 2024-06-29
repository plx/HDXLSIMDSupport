import Testing


@usableFromInline
package struct ContextualizedValidationExample<Example> {
  
  @usableFromInline
  package let example: Example

  @usableFromInline
  package var function: StaticString
  
  @usableFromInline
  package let sourceLocation: SourceLocation

  @inlinable
  package init(
    example: Example,
    function: StaticString,
    sourceLocation: SourceLocation
  ) {
    self.example = example
    self.function = function
    self.sourceLocation = sourceLocation
  }
  
}
