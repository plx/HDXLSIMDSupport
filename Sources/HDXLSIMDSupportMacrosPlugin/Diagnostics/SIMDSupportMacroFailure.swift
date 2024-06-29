import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics

extension String {
  
  static let diagnosticDomainID: String = "hdxlsimdsupportmacros"
  static let standardMessageID: String = "diagnostic"
}

public protocol SIMDSupportMacro {
  
  static var diagnosticDomain: String { get }

}

extension SIMDSupportMacro {
  public static var diagnosticDomain: String { String(reflecting: self) }

  static func diagnostic(
    for node: some SyntaxProtocol,
    at position: AbsolutePosition? = nil,
    explanation: String,
    severity: DiagnosticSeverity,
    messageID: String = .standardMessageID,
    highlights: [Syntax]? = nil,
    notes: [Note] = [],
    fixIts: [FixIt] = []
  ) -> Diagnostic {
    Diagnostic(
      node: node,
      message: SIMDSupportMacroDiagnostic(
        message: explanation,
        severity: severity,
        diagnosticID: MessageID(
          domain: diagnosticDomain,
          id: messageID
        )
      ), 
      highlights: highlights,
      notes: notes,
      fixIts: fixIts
    )
  }

  static func _diagnosticError(
    for node: some SyntaxProtocol,
    at position: AbsolutePosition? = nil,
    explanation: String,
    messageID: String = .standardMessageID,
    highlights: [Syntax]? = nil,
    notes: [Note] = [],
    fixIts: [FixIt] = []
  ) -> Diagnostic {
    diagnostic(
      for: node,
      at: position,
      explanation: explanation,
      severity: .error,
      messageID: messageID,
      highlights: highlights,
      notes: notes,
      fixIts: fixIts
    )
  }

  static func _diagnosticWarning(
    for node: some SyntaxProtocol,
    at position: AbsolutePosition? = nil,
    explanation: String,
    messageID: String = .standardMessageID,
    highlights: [Syntax]? = nil,
    notes: [Note] = [],
    fixIts: [FixIt] = []
  ) -> Diagnostic {
    diagnostic(
      for: node,
      at: position,
      explanation: explanation,
      severity: .warning,
      messageID: messageID,
      highlights: highlights,
      notes: notes,
      fixIts: fixIts
    )
  }

  static func _diagnosticNote(
    for node: some SyntaxProtocol,
    at position: AbsolutePosition? = nil,
    explanation: String,
    messageID: String = .standardMessageID,
    highlights: [Syntax]? = nil,
    notes: [Note] = [],
    fixIts: [FixIt] = []
  ) -> Diagnostic {
    diagnostic(
      for: node,
      at: position,
      explanation: explanation,
      severity: .note,
      messageID: messageID,
      highlights: highlights,
      notes: notes,
      fixIts: fixIts
    )
  }

  static func _diagnosticRemark(
    for node: some SyntaxProtocol,
    at position: AbsolutePosition? = nil,
    explanation: String,
    messageID: String = .standardMessageID,
    highlights: [Syntax]? = nil,
    notes: [Note] = [],
    fixIts: [FixIt] = []
  ) -> Diagnostic {
    diagnostic(
      for: node,
      at: position,
      explanation: explanation,
      severity: .remark,
      messageID: messageID,
      highlights: highlights,
      notes: notes,
      fixIts: fixIts
    )
  }

  static func diagnosticError(
    for node: some SyntaxProtocol,
    at position: AbsolutePosition? = nil,
    explanation: String,
    messageID: String = .standardMessageID,
    highlights: [Syntax]? = nil,
    notes: [Note] = [],
    fixIts: [FixIt] = []
  ) -> DiagnosticsError {
    DiagnosticsError(
      diagnostics: [
        _diagnosticError(
          for: node,
          at: position,
          explanation: explanation,
          messageID: messageID,
          highlights: highlights,
          notes: notes,
          fixIts: fixIts
        )
      ]
    )
  }
  
  static func diagnosticWarning(
    for node: some SyntaxProtocol,
    at position: AbsolutePosition? = nil,
    explanation: String,
    messageID: String = .standardMessageID,
    highlights: [Syntax]? = nil,
    notes: [Note] = [],
    fixIts: [FixIt] = []
  ) -> DiagnosticsError {
    DiagnosticsError(
      diagnostics: [
        _diagnosticWarning(
          for: node,
          at: position,
          explanation: explanation,
          messageID: messageID,
          highlights: highlights,
          notes: notes,
          fixIts: fixIts
        )
      ]
    )
  }
  
  static func diagnosticNote(
    for node: some SyntaxProtocol,
    at position: AbsolutePosition? = nil,
    explanation: String,
    messageID: String = .standardMessageID,
    highlights: [Syntax]? = nil,
    notes: [Note] = [],
    fixIts: [FixIt] = []
  ) -> DiagnosticsError {
    DiagnosticsError(
      diagnostics: [
        _diagnosticNote(
          for: node,
          at: position,
          explanation: explanation,
          messageID: messageID,
          highlights: highlights,
          notes: notes,
          fixIts: fixIts
        )
      ]
    )
  }
  
  static func diagnosticRemark(
    for node: some SyntaxProtocol,
    at position: AbsolutePosition? = nil,
    explanation: String,
    messageID: String = .standardMessageID,
    highlights: [Syntax]? = nil,
    notes: [Note] = [],
    fixIts: [FixIt] = []
  ) -> DiagnosticsError {
    DiagnosticsError(
      diagnostics: [
        _diagnosticRemark(
          for: node,
          at: position,
          explanation: explanation,
          messageID: messageID,
          highlights: highlights,
          notes: notes,
          fixIts: fixIts
        )
      ]
    )
  }

}


struct SIMDSupportMacroDiagnostic : DiagnosticMessage {
  
  let message: String
  let severity: DiagnosticSeverity
  let diagnosticID: MessageID
  
  init(
    message: String,
    severity: DiagnosticSeverity,
    diagnosticID: MessageID
  ) {
    self.message = message
    self.severity = severity
    self.diagnosticID = diagnosticID
  }
  
  static func error(
    _ message: String,
    diagnosticID: MessageID
  ) -> SIMDSupportMacroDiagnostic {
    return Self(
      message: message,
      severity: .error,
      diagnosticID: diagnosticID
    )
  }
  
  static func warning(
    _ message: String,
    diagnosticID: MessageID
  ) -> SIMDSupportMacroDiagnostic {
    return Self(
      message: message,
      severity: .warning,
      diagnosticID: diagnosticID
    )
  }
  
  static func note(
    _ message: String,
    diagnosticID: MessageID
  ) -> SIMDSupportMacroDiagnostic {
    return Self(
      message: message,
      severity: .note,
      diagnosticID: diagnosticID
    )
  }
  
  static func remark(
    _ message: String,
    diagnosticID: MessageID
  ) -> SIMDSupportMacroDiagnostic {
    return Self(
      message: message,
      severity: .remark,
      diagnosticID: diagnosticID
    )
  }
  
  
}
