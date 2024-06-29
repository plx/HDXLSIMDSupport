import Foundation
import SwiftUI
import HDXLSIMDSupportProtocols

// MARK: SwiftUIVectorArithmetic

@attached(
  extension,
  conformances: VectorArithmetic,
  names: named(magnitudeSquared), named(scale(by:))
)
package macro SwiftUIVectorArithmetic() = #externalMacro(
  module: "HDXLSIMDSupportMacrosPlugin",
  type: "SwiftUIVectorArithmeticMacro"
)
