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
  var advancedHandler = AdvancedOverlayHandler()
  let idsToRemove: [Int]

  func makeUIView(context: Context) -> DataCaptureView {
    let view = UIView(frame: .zero)
    let captureView = DataCaptureView(context: dataCaptureContext, frame: view.bounds)
    
    view.addSubview(captureView)
    
    let overlay = BarcodeTrackingBasicOverlay(barcodeTracking: barcodeTracking, view: captureView, style: .frame)
    overlay.delegate = handler
    
    let advancedOverlay = BarcodeTrackingAdvancedOverlay(barcodeTracking: barcodeTracking, view: captureView)
    advancedOverlay.delegate = advancedHandler
    
    return captureView
  }
  
  func updateUIView(_ uiView: DataCaptureView, context: Context) {
    uiView.context = dataCaptureContext
    
    let overlay = BarcodeTrackingBasicOverlay(barcodeTracking: barcodeTracking, view: uiView)
    overlay.delegate = handler
    
    let advancedOverlay = BarcodeTrackingAdvancedOverlay(barcodeTracking: barcodeTracking, view: uiView)
    advancedOverlay.delegate = advancedHandler
    
    advancedHandler.remove(ids: idsToRemove)
  }
}

extension BarcodeCamera {
  class BasicOverlayHandler: NSObject, BarcodeTrackingBasicOverlayDelegate {
    func barcodeTrackingBasicOverlay(_ overlay: BarcodeTrackingBasicOverlay, brushFor trackedBarcode: TrackedBarcode) -> Brush? {
      return Brush(fill: .clear, stroke: .purple, strokeWidth: 2)
    }
    
    func barcodeTrackingBasicOverlay(_ overlay: BarcodeTrackingBasicOverlay, didTap trackedBarcode: TrackedBarcode) {}
  }

  class AdvancedOverlayHandler: NSObject, BarcodeTrackingAdvancedOverlayDelegate {
    var overlays: [Int: OverlayView] = [:]
    
    func remove(ids: [Int]) {
      ids.forEach {
        overlays.removeValue(forKey: $0)
      }
    }
    
    func barcodeTrackingAdvancedOverlay(_ overlay: BarcodeTrackingAdvancedOverlay, viewFor trackedBarcode: TrackedBarcode) -> UIView? {
      guard let overlay = overlays[trackedBarcode.identifier] else {
        let overlay = OverlayView()
        
        NSLayoutConstraint.activate([
          overlay.widthAnchor.constraint(equalToConstant: 200)
        ])

        overlays[trackedBarcode.identifier] = overlay
        
        return overlay
      }
      
      return overlay
    }
    
    func barcodeTrackingAdvancedOverlay(_ overlay: BarcodeTrackingAdvancedOverlay, anchorFor trackedBarcode: TrackedBarcode) -> ScanditBarcodeCapture.Anchor {
      .topCenter
    }
    
    func barcodeTrackingAdvancedOverlay(_ overlay: BarcodeTrackingAdvancedOverlay, offsetFor trackedBarcode: TrackedBarcode) -> PointWithUnit {
      .init(
        x: FloatWithUnit(value: 0, unit: .fraction),
        y: FloatWithUnit(value: -1, unit: .fraction)
      )
    }
  }
}

extension UIView {
    class func fromNib(named: String? = nil) -> Self {
        let name = named ?? "\(Self.self)"
        guard
            let nib = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
            else { fatalError("missing expected nib named: \(name)") }
        guard
            /// we're using `first` here because compact map chokes compiler on
            /// optimized release, so you can't use two views in one nib if you wanted to
            /// and are now looking at this
            let view = nib.first as? Self
            else { fatalError("view of type \(Self.self) not found in \(nib)") }
        return view
    }
}
