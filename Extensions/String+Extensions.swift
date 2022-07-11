//
//  String+Extensions.swift
//  scandit poc
//
//  Created by Ben Fowler on 11/7/2022.
//

import Foundation

extension String {
  static var random: String {
    (1...10).map { _ in Random.word }.joined(separator: " ")
  }
}
