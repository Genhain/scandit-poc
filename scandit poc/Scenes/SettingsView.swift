//
//  SettingsView.swift
//  scandit poc
//
//  Created by Ben Fowler on 8/7/2022.
//

import SwiftUI
import ScanditBarcodeCapture

struct SettingsView: View {
  
  @Binding var symbologySelectionList: [Symbology: Bool]
  
  var body: some View {
    VStack {
      Text("Select Code type to scan")
      List {
        ForEach(Symbology.allCases, id: \.description) { item in
          Toggle(item.description, isOn: bindingForSymbology(for: item))
        }
      }
    }
  }
  
  private func bindingForSymbology(for key:Symbology) -> Binding<Bool> {
    Binding(
      get: { symbologySelectionList[key] ?? false },
      set: { symbologySelectionList[key] = $0 }
    )
  }
}


struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView(symbologySelectionList: Binding(get: { [:] }, set: { _ in }))
  }
}
