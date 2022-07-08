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
    var captureDelegate: BarCodeCaptureDelegate?
    
    @Published var context: DataCaptureContext!
    @Published var settings = BarcodeCaptureSettings()
    @Published var symbologySelectionList: [Symbology: Bool] = [:]
    @Published var barcodeCapture: BarcodeCapture?
    
    private var cancellables: [AnyCancellable] = []
    
    let cameraSettings = BarcodeCapture.recommendedCameraSettings
    lazy var camera: Camera? = {
      $0?.apply(cameraSettings)
      return $0
    }(Camera.default)
    
    init() {
      captureDelegate?.$frameData.compactMap {$0}.sink {
        print($0.jsonString)
      }.store(in: &cancellables)
      
      $symbologySelectionList.sink {
        $0.forEach { [unowned self] k,v in
          self.settings.set(symbology: k, enabled: v)
        }

        self.setupBarCode()
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

      barcodeCapture = BarcodeCapture(context: context, settings: settings)
      captureDelegate = BarCodeCaptureDelegate(barcodeCapture: barcodeCapture!)

      barcodeCapture!.isEnabled = true
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
  
  class BarCodeCaptureDelegate: NSObject {
    @Published var frameData: FrameData?
    
    init(barcodeCapture: BarcodeCapture) {
      super.init()
      barcodeCapture.addListener(self)
    }
  }
}

extension ScaningView.ViewModel.BarCodeCaptureDelegate: BarcodeCaptureListener {
  func barcodeCapture(
    _ barcodeCapture: BarcodeCapture,
    didScanIn session: BarcodeCaptureSession,
    frameData: FrameData
  ) {
    self.frameData = frameData
  }
}
