//
//  CurrencyCellMacOSView.swift
//  Converter
//
//  Created by Артем Дорожкин on 05.06.2023.
//

import SwiftUI

struct CurrencyCellMacOSView: View {
    
    let currencyConverter: CurrencyConverter?
    @Binding var factor: Double
    
    @AppStorage("selectedCurrency", store: UserDefaults(suiteName: "group.com.sypivos.Converter"))
    var selectedCurrency: String = "EUR"
    
    var body: some View {
        
        let conditionExchange = currencyConverter?.currencyPair?.dropLast(3) ?? "EUR" == selectedCurrency
        let exchangeFirst = (Double(currencyConverter?.exchange ?? "0") ?? 0.0)
        let exchange = conditionExchange ? exchangeFirst : 1/exchangeFirst
        let roundExchange = String(format:"%.02f", exchange * factor)
        
        VStack{
            HStack {
                if currencyConverter?.currencyPair?.dropLast(3) ?? "EUR" == selectedCurrency{
                    Text(currencyConverter?.currencyPair?.dropFirst(3) ?? "EUR")
                           .foregroundColor(.white)
                } else {
                 Text(currencyConverter?.currencyPair?.dropLast(3) ?? "EUR")
                        .foregroundColor(.white)
                }
                Spacer()
                let exchangeValues = roundExchange == "0.00" ? "\(String(format:"%.06f", exchange))" : roundExchange
                
                Text(exchangeValues)
                    .foregroundColor(.white)
                    .font(.system(size: 50, weight: .medium))
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)
                    .textSelection(.enabled)
                    .contextMenu {
                        Button(action: {
                            UIPasteboard.general.string = exchangeValues
                        }) {
                            Text("Copy")
                        }
                    }
            }
            Divider()
                .background(.white)
                .ignoresSafeArea()
        }
    }
}

struct CurrencyCellMacOSView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyCellMacOSView(currencyConverter: nil, factor: .constant(1.1))
    }
}

