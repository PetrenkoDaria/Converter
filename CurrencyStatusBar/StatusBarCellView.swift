//
//  StatusBarCellView.swift
//  CurrencyStatusBar
//
//  Created by Артем Дорожкин on 06.06.2023.
//

import SwiftUI

struct StatusBarCellView: View {
    
    let currencyConverter: CurrencyConverter?
    @Binding var factor: Double
    @AppStorage("selectedCurrency") var selectedCurrency: String = "EUR"
    
    var body: some View {
        
        let conditionExchange = currencyConverter?.currencyPair?.dropLast(3) ?? "EUR" == selectedCurrency
        let exchangeFirst = (Double(currencyConverter?.exchange ?? "0") ?? 0.0)
        let exchange = conditionExchange ? exchangeFirst : 1/exchangeFirst
        let roundExchange = String(format:"%.02f", exchange * factor)
        let exchangeValues = roundExchange == "0.00" ? "\(String(format:"%.06f", exchange))" : roundExchange
        
        VStack{
            HStack {
                if currencyConverter?.currencyPair?.dropLast(3) ?? "EUR" == selectedCurrency{
                    Text(currencyConverter?.currencyPair?.dropFirst(3) ?? "EUR")
                           .foregroundColor(.primary)
                           .font(.system(size: 12))
                } else {
                 Text(currencyConverter?.currencyPair?.dropLast(3) ?? "EUR")
                        .foregroundColor(.primary)
                        .font(.system(size: 12))
                }
                
                Spacer()
                
                Text(exchangeValues)
                    .foregroundColor(.primary)
                    .font(.system(size: 15))
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)
                    .textSelection(.enabled)
            }
            
            Divider()
                .background(.primary)
                .ignoresSafeArea()
                .opacity(0.1)
        }
    }
}

struct StatusBarCellView_Previews: PreviewProvider {
    static var previews: some View {
        StatusBarCellView(currencyConverter: nil, factor: .constant(1.1))
    }
}
