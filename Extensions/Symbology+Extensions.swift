//
//  Symbology+Extensions.swift
//  scandit poc
//
//  Created by Ben Fowler on 8/7/2022.
//

import Foundation
import ScanditCaptureCore
import ScanditBarcodeCapture

extension Symbology: CaseIterable {
  public static var allCases: [Symbology] = [
    .aztec,
    .codabar,
    .code11,
    .code128,
    .code25,
    .code32,
    .code39,
    .code93,
    .dataMatrix,
    .dotCode,
    .ean13UPCA,
    .ean8,
    .gs1Databar,
    .gs1DatabarExpanded,
    .gs1DatabarLimited,
    .iataTwoOfFive,
    .interleavedTwoOfFive,
    .kix,
    .lapa4SC,
    .matrixTwoOfFive,
    .maxiCode,
    .microPDF417,
    .microQR,
    .msiPlessey,
    .pdf417,
    .qr,
    .rm4scc,
    .upce,
    .uspsIntelligentMail
  ]
}

extension Symbology: CustomStringConvertible {
  public var description: String {
    var result = ""
    switch self {
    case .ean13UPCA:
      result = "EAN-13 UPC-A"
    case .upce:
      result = "UPCE"
    case .ean8:
      result = "EAN-8"
    case .code39:
      result = "Code-39"
    case .code93:
      result = "Code 93"
    case .code128:
      result = "Code 128"
    case .code11:
      result = "Code 11"
    case .code25:
      result = "Code 25"
    case .codabar:
      result = "Codabar"
    case .interleavedTwoOfFive:
      result = "Interleaved Two Of Five"
    case .msiPlessey:
      result = "MSI Plessey"
    case .qr:
      result = "QR"
    case .dataMatrix:
      result = "Data Matrix"
    case .aztec:
      result = "Aztec"
    case .maxiCode:
      result = "Maxi Code"
    case .dotCode:
      result = "Dot Code"
    case .kix:
      result = "Kix"
    case .rm4scc:
      result = "RM4SCC"
    case .gs1Databar:
      result = "GS1 Databar"
    case .gs1DatabarExpanded:
      result = "GS1 Databar Expanded"
    case .gs1DatabarLimited:
      result = "GS1 Databar Limited"
    case .pdf417:
      result = "PDF 417"
    case .microPDF417:
      result = "Micro PDF 417"
    case .microQR:
      result = "Micro QR"
    case .code32:
      result = "Code 32"
    case .lapa4SC:
      result = "Lapa 4SC"
    case .iataTwoOfFive:
      result = "Iata Two Of Five"
    case .matrixTwoOfFive:
      result = "Matrix Two Of Five"
    case .uspsIntelligentMail:
      result = "USPS Intelligent Mail"
    }
    
    return result
  }
}
