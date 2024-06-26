import Foundation
import simd

/// Reversed `*=`: `foo *= bar` should be equivalent to `bar = foo * bar` (for non-commutative types).
infix operator =* : AssignmentPrecedence

/// Reversed `/=`: `foo /= bar` should be equivalent to `bar = (1/foo) * bar` (for non-commutative types).
infix operator =/ : AssignmentPrecedence

/// "Dot-product" operator for quaternions.
infix operator • : MultiplicationPrecedence
