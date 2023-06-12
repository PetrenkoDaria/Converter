//
//  CurrencyMacOSView.swift
//  Converter
//
//  Created by Дарья Петренко on 04.06.2023.
//

import SwiftUI

struct CurrencyMacOSView: View {
    
    @State var groupByCurrency: [String:[CurrencyConverter]] = [:]
    @State var factor = 1.0
    @State var factorString = "1"
    
    @AppStorage("selectedCurrency", store: UserDefaults(suiteName: "group.com.sypivos.Converter"))
    var selectedCurrency: String = "EUR"
    
    @FetchRequest(sortDescriptors: [], animation: .default)
    var currencyConverteres: FetchedResults<CurrencyConverter>
    
    var body: some View {
    ScrollView {
        LazyVStack {
            HStack {
                Text("Exchange Rates")
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .heavy))
               Spacer()
            }
            .padding(.top, 40)
            .padding(.bottom, 14)
            
            VStack(spacing: 5){
                HStack(alignment: .bottom) {
                    Text("\(selectedCurrency)")
                        .foregroundColor(.white)

                    Spacer()
                    
                    TextField("", text: $factorString)
                        .textFieldStyle(.plain)
                        .foregroundColor(.white)
                        .font(.system(size: 50, weight: .medium))
                        .minimumScaleFactor(0.3)
                        .multilineTextAlignment(.trailing)
                        .onChange(of: factorString) { newValue in
                            factor = Double(factorString) ?? 1.0
                        }.padding(.horizontal)
                }
                Divider().background(.white)
            }
            HStack {
                Text("CURRENCY").foregroundColor(.white)
                Spacer()
                Text("ENTER AMOUNT").foregroundColor(.primary).colorInvert()
            }.padding(.bottom, 80)
            
            ForEach(groupByCurrency.keys.sorted(), id: \.self) { item in
                    CurrencyCellMacOSView(currencyConverter: groupByCurrency[item]?.first, factor: $factor)
                }
           Spacer()
        }
        .padding()
    }
            .background {
                ZStack{
                    Image("4")
                        .resizable()
                        .ignoresSafeArea()
                    
                    Rectangle()
                        .ignoresSafeArea()
                        .foregroundStyle(.thinMaterial)
                        .opacity(0.2)
                }
            }
        .onAppear{ dataFilter() }
        .onChange(of: selectedCurrency) { _ in
            dataFilter()
        }
    }
    
    func dataFilter() {
        currencyConverteres.nsPredicate = NSCompoundPredicate(type: .or, subpredicates: [
            NSPredicate(format: "currencyPair BEGINSWITH %@", selectedCurrency),
            NSPredicate(format: "currencyPair ENDSWITH %@", selectedCurrency)
        ])
        groupByCurrency = Dictionary(grouping: currencyConverteres, by: { item in
            item.currencyPair ?? ""
        })
    }
}

struct CurrencyMacOSView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyMacOSView()
    }
}







