//
//  Plugin.swift
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct HDXLSIMDSupportMacroPlugin: CompilerPlugin {
  let providingMacros: [any Macro.Type] = [
    AddNativeMatrixConformanceMacro.self,
    AddStorageMatrixConformanceMacro.self,
    AddWrapperMatrixConformanceMacro.self,
    GenerateMatrixConformanceTestsMacro.self
  ]
}
