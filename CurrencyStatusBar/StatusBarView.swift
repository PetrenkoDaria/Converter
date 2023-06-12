//
//  StatusBarView.swift
//  CurrencyStatusBar
//
//  Created by Артем Дорожкин on 05.06.2023.
//

import SwiftUI

struct StatusBarView: View {

    @AppStorage("selectedCurrency") var selectedCurrency: String = "EUR"
    
    @FetchRequest(sortDescriptors: [], animation: .default)
    var currencyConverteres: FetchedResults<CurrencyConverter>
    
    @StateObject var currencyObject = CurrencyViewModel()
    @State var groupByCurrency: [String:[CurrencyConverter]] = [:]
    @State var factor = 1.0
    @State var factorString = "1"
    @State var showSheet = false
    
    var body: some View {
        let columns = [GridItem(), GridItem()]
        ScrollView{
            VStack {
                HStack {
                    TextField("", text: $factorString)
                        .foregroundColor(.primary)
                        .textFieldStyle(.roundedBorder)
                        .font(.system(size: 20, weight: .medium))
                        .minimumScaleFactor(0.3)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 230)
                        .onChange(of: factorString) { newValue in
                            factor = Double(factorString) ?? 1.0
                        }
                    
                    Picker(selection: $selectedCurrency, label: Text("")) {
                        ForEach(CurrencyDecoding().currencies.keys.sorted(), id: \.self) { item in
                            Text(item)
                        }
                    }.frame(width: 100)
                    Spacer()
                }.padding(.bottom)
                
                LazyVGrid(columns: columns) {
                    ForEach(groupByCurrency.keys.sorted(), id: \.self) { item in
                        StatusBarCellView(currencyConverter: groupByCurrency[item]?.first, factor: $factor)
                    }
                }
                Spacer()
            }.padding()
        }
        .frame(width: 500, height: 300)
        .onAppear{
                currencyObject.saveCurrencyData()
                dataFilter()
        }
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

struct StatusBarView_Previews: PreviewProvider {
    static var previews: some View {
        StatusBarView()
    }
}
