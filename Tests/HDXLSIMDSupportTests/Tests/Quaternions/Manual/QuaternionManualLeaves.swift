//
//  QuaternionManualLeaves.swift
//
//  Concrete, XCTest-discoverable leaves for the quaternion manual suite. Each
//  picks a geometric tolerance suited to its representation's trig precision.
//

import XCTest
@testable import HDXLSIMDSupport

final class Quaternion_Float_Manual: QuaternionManualValidation<Float> {
  override var geometricTolerance: Float { 1e-3 }
}

final class Quaternion_Double_Manual: QuaternionManualValidation<Double> {
  override var geometricTolerance: Double { 1e-6 }
}

final class Quaternion_Half_Manual: QuaternionManualValidation<Float16> {
  override var geometricTolerance: Float16 { 0.2 }
}
