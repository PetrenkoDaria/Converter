//
//  ContentView.swift
//  Converter
//
//  Created by Дарья Петренко on 23.05.2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @StateObject var currencyObject = CurrencyViewModel()
    
    @AppStorage("selectedCurrency", store: UserDefaults(suiteName: "group.com.sypivos.Converter"))
    var selectedCurrency: String = "EUR"
   
    var body: some View {
        ZStack{
            if currencyObject.isLoading {
                ProgressView()
            } else{
                if UIDevice.current.userInterfaceIdiom == .phone {
                    ZStack {
                        CurrencyView()
                            .onOpenURL { url in
                                print("🚀 Launched from widget ", url)
                                let selected = url.absoluteString.components(separatedBy: "//").last
                                selectedCurrency = selected ?? "EUR"
                                currencyObject.saveCurrencyData()       
                        }
                        
                        if currencyObject.isError {
                            Rectangle()
                                .ignoresSafeArea()
                                .foregroundStyle(.ultraThinMaterial)
                            
                            Text("Error")
                                .font(.system(size: 60))
                                .fontWeight(.heavy)
                        }
                    }
                } else {
                    NavigationSplitView {
                        VStack {
                            CurrencySelectionMacOSView()
                        }
                    } detail: {
                        CurrencyMacOSView()
                            .navigationTitle("")
                    }
                }
            }
        }
        .onAppear() {
                currencyObject.saveCurrencyData()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

