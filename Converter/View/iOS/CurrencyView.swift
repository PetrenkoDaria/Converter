//
//  CurrencyView.swift
//  Converter
//
//  Created by Дарья Петренко on 26.05.2023.
//

import SwiftUI

struct CurrencyView: View {
    
    @State var groupByCurrency: [String:[CurrencyConverter]] = [:]
    @State var factor = 1.0
    @State var factorString = "1"
    @State var showSheet = false
    
    @AppStorage("selectedCurrency", store: UserDefaults(suiteName: "group.com.sypivos.Converter"))
    var selectedCurrency: String = "EUR"
    
    @FetchRequest(sortDescriptors: [], animation: .default)
    var currencyConverteres: FetchedResults<CurrencyConverter>
    
    var body: some View {
       ScrollView {
            LazyVStack {
                HStack {
//                    Text("Currency")
//                        .foregroundColor(.white)
//                        .font(.title2)
//                        .fontWeight(.thin)
//                    Spacer()
                }.padding(.bottom, 30)
                
                HStack {
                    Text("Exchange Rates")
                        .foregroundColor(.white)
                        .font(.system(size: 60))
                        .fontWeight(.heavy)
                    Spacer()
                }
                .padding(.bottom)
                
                VStack(spacing: 5){
                    HStack(alignment: .bottom) {
                        Button("\(selectedCurrency)") {
                            showSheet = true
                        }.foregroundColor(.white)
                            .sheet(isPresented: $showSheet, onDismiss: { dataFilter() }) {
                                CurrencySelectionView()
                            }
                            
                        Spacer()
                        
                        TextField("", text: $factorString)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.plain)
                            .foregroundColor(.white)
                            .font(.system(size: 60, weight: .light))
                            .minimumScaleFactor(0.3)
                            .multilineTextAlignment(.trailing)
                            .onChange(of: factorString) { newValue in
                                factor = Double(factorString) ?? 1.0
                            }
                            .padding(.horizontal)
                    }
                    
                    Divider().background(.white)
                }
                HStack {
                    Button("MORE") {
                        showSheet = true
                    }.foregroundColor(.white)
                        .sheet(isPresented: $showSheet, onDismiss: { dataFilter() }) {
                            CurrencySelectionView()
                        }
                    
                    Spacer()
                    
                    Text("ENTER AMOUNT")
                        .foregroundColor(.white)
                }
                .padding(.bottom, 80)
                
                ForEach(groupByCurrency.keys.sorted(), id: \.self) { item in
                    CurrencyCellView(currencyConverter: groupByCurrency[item]?.first, factor: $factor)
                }
               Spacer()
            }.padding()
       }.scrollDismissesKeyboard(.immediately)
       .background {
           Image("4")
               .resizable()
               .ignoresSafeArea()
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

struct CurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyView()
    }
}
