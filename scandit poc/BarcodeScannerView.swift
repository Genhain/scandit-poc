//
//  BarcodeScannerView.swift
//  scandit poc
//
//  Created by Ben Fowler on 8/7/2022.
//

import SwiftUI
import ScanditBarcodeCapture

struct BarcodeCamera: UIViewRepresentable {

  let dataCaptureContext: DataCaptureContext
  let barcodeCapture: BarcodeCapture

  func makeUIView(context: Context) -> DataCaptureView {
    let view = UIView(frame: .zero)
    let captureView = DataCaptureView(context: dataCaptureContext, frame: view.bounds)
    
    view.addSubview(captureView)
    
    let overlay = BarcodeCaptureOverlay(barcodeCapture: barcodeCapture, view: captureView)
    overlay.viewfinder = RectangularViewfinder(style: .square, lineStyle: .light)
    return captureView
  }
  
  func updateUIView(_ uiView: DataCaptureView, context: Context) {
    uiView.context = dataCaptureContext
    let overlay = BarcodeCaptureOverlay(barcodeCapture: barcodeCapture, view: uiView)
    overlay.viewfinder = RectangularViewfinder(style: .square, lineStyle: .light)
  }
}
