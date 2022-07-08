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
  let barcodeTracking: BarcodeTracking
  var handler = BasicOverlayHandler()

  func makeUIView(context: Context) -> DataCaptureView {
    let view = UIView(frame: .zero)
    let captureView = DataCaptureView(context: dataCaptureContext, frame: view.bounds)
    
    view.addSubview(captureView)
    
    let overlay = BarcodeTrackingBasicOverlay(barcodeTracking: barcodeTracking, view: captureView, style: .frame)
    overlay.delegate = handler
    
    return captureView
  }
  
  func updateUIView(_ uiView: DataCaptureView, context: Context) {
    uiView.context = dataCaptureContext
    let overlay = BarcodeTrackingBasicOverlay(barcodeTracking: barcodeTracking, view: uiView)
    overlay.delegate = handler
  }
}

class BasicOverlayHandler: NSObject, BarcodeTrackingBasicOverlayDelegate {
  func barcodeTrackingBasicOverlay(_ overlay: BarcodeTrackingBasicOverlay, brushFor trackedBarcode: TrackedBarcode) -> Brush? {
    return Brush(fill: .clear, stroke: .purple, strokeWidth: 2)
  }
  
  func barcodeTrackingBasicOverlay(_ overlay: BarcodeTrackingBasicOverlay, didTap trackedBarcode: TrackedBarcode) {}
}
