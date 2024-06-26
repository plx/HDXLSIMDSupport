import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

@main
struct HDXLSIMDSupportMacrosPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    ExtendedSIMDScalarMacro.self,
    
    AddMatrixStorageMacro.self,
    AddCompatibleMatrixDeclarationsMacro.self,
    AddNativeSIMDBackingMacro.self,
    AddInferredScalarMacro.self,
    AddMatrixRowsAndColumnsMacro.self,
    AddCompatibleQuaternionDeclarationsMacro.self,
    
    DescriptionFromStorageMacro.self,
    DebugDescriptionFromNativeSIMDRepresentationMacro.self,
    
    SwiftUIVectorArithmeticMacro.self,
    StorageNativeSIMDRepresentableMacro.self,
    
    StorageNumericAggregateMacro.self,
    TwoColumnNumericAggregateMacro.self,
    ThreeColumnNumericAggregateMacro.self,
    FourColumnNumericAggregateMacro.self,
    
    TwoColumnNativeSIMDHashableMacro.self,
    ThreeColumnNativeSIMDHashableMacro.self,
    FourColumnNativeSIMDHashableMacro.self,
    
    TwoColumnNativeSIMDCodableMacro.self,
    ThreeColumnNativeSIMDCodableMacro.self,
    FourColumnNativeSIMDCodableMacro.self
  ]
}

