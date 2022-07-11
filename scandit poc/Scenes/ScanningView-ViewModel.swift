//
//  ScanningView-ViewModel.swift
//  scandit poc
//
//  Created by Ben Fowler on 8/7/2022.
//

import Foundation
import Combine
import ScanditCaptureCore
import ScanditBarcodeCapture

extension ScaningView {
  @MainActor class ViewModel: ObservableObject {
    
    private var captureView: DataCaptureView!
    private var overlay: BarcodeCaptureOverlay!
    var trackingDelegate: BarCodeTrackingDelegate?
    
    @Published var context: DataCaptureContext!
    @Published var settings = BarcodeTrackingSettings()
    @Published var symbologySelectionList: [Symbology: Bool] = [:]
    @Published var barcodeTracking: BarcodeTracking?
    @Published var removedBarcodes: [Int]?
    
    private var cancellables: [AnyCancellable] = []
    
    lazy var camera: Camera? = {
      let cameraSettings = BarcodeTracking.recommendedCameraSettings
      cameraSettings.preferredResolution = .uhd4k
      $0?.apply(cameraSettings)
      return $0
    }(Camera.default)
    
    init() {
      trackingDelegate?.$frameData.compactMap {$0}.sink {
        print($0.jsonString)
      }.store(in: &cancellables)
      
      $symbologySelectionList.sink {
        $0.forEach { [unowned self] k,v in
          self.settings.set(symbology: k, enabled: v)
        }

        self.setupBarCode()
      }.store(in: &cancellables)
      
      trackingDelegate?.$removedTracedBarcodes.removeDuplicates().sink {
        self.removedBarcodes = $0
      }.store(in: &cancellables)
      
    }
    
    func setupBarCode() {
      // Create data capture context using your license key.
      if context != nil {
        context.dispose()
      }
      context = DataCaptureContext.licensed

      camera = Camera.default
      context.setFrameSource(camera, completionHandler: nil)

      let recommendedCameraSettings = BarcodeCapture.recommendedCameraSettings
      camera?.apply(recommendedCameraSettings)

      let symbologySettings = settings.settings(for: .code39)
      symbologySettings.activeSymbolCounts = Set(7...20) as Set<NSNumber>

      barcodeTracking = BarcodeTracking(context: context, settings: settings)
      trackingDelegate = BarCodeTrackingDelegate(barcodeCapture: barcodeTracking!)

      barcodeTracking!.isEnabled = true
      camera?.switch(toDesiredState: .on)
    }
    
    func selected() -> [Symbology] {
      symbologySelectionList.reduce([Symbology](), { acc, val in
        if val.value {
          return acc + [val.key]
        }
        return acc
      })
    }
  }
}

extension ScaningView.ViewModel {
  
  class BarCodeTrackingDelegate: NSObject {
    @Published var frameData: FrameData?
    @Published var removedTracedBarcodes: [Int]?
    
    init(barcodeCapture: BarcodeTracking) {
      super.init()
      barcodeCapture.addListener(self)
    }
  }
}

extension ScaningView.ViewModel.BarCodeTrackingDelegate: BarcodeTrackingListener {
  func barcodeTracking(
    _ barcodeTracking: BarcodeTracking,
    didUpdate session: BarcodeTrackingSession,
    frameData: FrameData
  ) {
    let removedTrackedBarcodes = session.removedTrackedBarcodes
//    let trackedBarcodes = session.trackedBarcodes.values
    DispatchQueue.main.async {
        if !barcodeTracking.isEnabled {
            return
        }
      self.removedTracedBarcodes = removedTrackedBarcodes.map { $0.intValue }
//        for trackedCode in trackedBarcodes {
//            guard let code = trackedCode.barcode.data, !code.isEmpty else {
//                return
//            }
//
//            self.overlays[trackedCode.identifier]?.isHidden = !self.canShowOverlay(of: trackedCode)
//        }
    }
  }
}
