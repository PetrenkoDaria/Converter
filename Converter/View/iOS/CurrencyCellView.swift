//
//  CurrencyCellView.swift
//  Converter
//
//  Created by Дарья Петренко on 27.05.2023.
//

import SwiftUI

struct CurrencyCellView: View {
    
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
                
                Text(roundExchange == "0.00" ? "\(String(format:"%.06f", exchange))" : roundExchange)
                    .foregroundColor(.white)
                    .font(.system(size: 60))
                    .fontWeight(.light)
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)
                    .textSelection(.enabled)
            }
            
            Divider()
                .background(.white)
                .ignoresSafeArea()
        }
    }
}

struct CurrencyCellView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyCellView(currencyConverter: nil, factor: .constant(1.1))
    }
}
