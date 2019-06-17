//
//  QuaternionCapableProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

public protocol QuaternionCapableProtocol {
  
  associatedtype QuaternionStorage: QuaternionStorageProtocol
    where QuaternionStorage.Scalar == Self
  
}
