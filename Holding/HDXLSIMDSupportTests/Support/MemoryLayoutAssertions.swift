import Foundation
import Testing

fileprivate func physicalSize<T>(
  of type: T.Type
) -> Int {
  MemoryLayout<T>.size
}

fileprivate func stride<T>(
  of type: T.Type
) -> Int {
  MemoryLayout<T>.stride
}

func alignment<T>(
  of type: T.Type
) -> Int {
  MemoryLayout<T>.alignment
}
 
//func validateEquivalentMemoryLayouts<Reference, each Candidate>(
//  reference: Reference.Type,
//  candidates: (repeat (each Candidate).Type)
//) {
//  for candidate in repeat each candidates {
//    #expect(physicalSize(of: reference) == physicalSize(of: candidate))
////      """
////      Expected identical `.size`, but got `(\(physicalSize(of: reference)), \(physicalSize(of: candidate)))` for (\(String(reflecting: reference)) and \(String(reflecting: candidate))), respectively.
////      """
//    
//    #expect(alignment(of: reference) == alignment(of: candidate))
////      """
////      Expected identical `.alignment`, but got `(\(alignment(of: reference)), \(alignment(of: candidate)))` for (\(String(reflecting: reference)) and \(String(reflecting: candidate))), respectively.
////      """
//
//    #expect(stride(of: reference) == stride(of: candidate))
////      """
////      Expected identical `.stride`, but got `(\(stride(of: reference)), \(stride(of: candidate)))` for (\(String(reflecting: reference)) and \(String(reflecting: candidate))), respectively.
////      """
//  }
//}

func validateEquivalentMemoryLayouts<Reference, Candidate>(
  reference: Reference.Type,
  candidate: Candidate.Type
) {
  #expect(physicalSize(of: reference) == physicalSize(of: candidate))
  #expect(alignment(of: reference) == alignment(of: candidate))
  #expect(stride(of: reference) == stride(of: candidate))
}

func validateEquivalentMemoryLayouts<Reference, A, B>(
  reference: Reference.Type,
  candidates: (A.Type, B.Type)
) {
  validateEquivalentMemoryLayouts(
    reference: reference,
    candidate: candidates.0
  )
  validateEquivalentMemoryLayouts(
    reference: reference,
    candidate: candidates.1
  )
}

