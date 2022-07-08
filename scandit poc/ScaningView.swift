//
//  ContentView.swift
//  scandit poc
//
//  Created by Ben Fowler on 5/7/2022.
//

import SwiftUI
import CoreData
import ScanditCaptureCore
import ScanditBarcodeCapture

struct ScaningView: View {
  @Environment(\.managedObjectContext) private var viewContext
  
  @StateObject var vm = ViewModel()

  var body: some View {
    NavigationView {
      VStack {
        BarcodeCamera(dataCaptureContext: vm.context, barcodeCapture: vm.barcodeCapture!)
        HStack {
          ForEach(vm.selected(), id: \.description) { item in
            Text(item.description)
          }
        }
      }
      .toolbar {
          ToolbarItem {
            NavigationLink {
              SettingsView(symbologySelectionList: $vm.symbologySelectionList)

            } label: {
              Text("Settings")
            }
          }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ScaningView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
  }
}

