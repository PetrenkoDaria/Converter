//
//  CurrencySelectionMacOSView.swift
//  Converter
//
//  Created by Артем Дорожкин on 04.06.2023.
//

import SwiftUI

struct CurrencySelectionMacOSView: View {
    
    @AppStorage("selectedCurrency", store: UserDefaults(suiteName: "group.com.sypivos.Converter"))
    var selectedCurrency: String = "EUR"
    
    var body: some View {
        ScrollView {
            VStack{
                HStack{
                    Text("Select a currency")
                        .foregroundColor(.primary)
                        .font(.system(size: 20, weight: .heavy))
                     
                   Spacer()
                }
                .padding(.top, 40)
                .padding(.bottom, 60)
            
            ForEach(CurrencyDecoding().currencies.keys.sorted(), id: \.self) { item in
                Button {
                    selectedCurrency = item
                } label: {
                    VStack(spacing: 5){
                        HStack(alignment: .bottom) {
                            Text(item)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            Spacer()
                            Text("(\(CurrencyDecoding().currencies[item] ?? ""))".uppercased())
                                .foregroundColor(.secondary)
                                .font(.system(size: 9, weight: .light))
                            Spacer()
                            Image(systemName: selectedCurrency == item ? "circle.inset.filled" : "circle")
                                .foregroundColor(.primary)
                            
                        }.padding(.bottom, 10)
                        Divider()
                            .background(.primary)
                            .padding(.bottom, 10)
                            .opacity(0.1)
                    }
                }.buttonStyle(.plain)
            }
            Spacer()
        }.padding()
    }
            .background{
                ZStack{
                    Image("4")
                        .resizable()
                    Rectangle()
                        .foregroundStyle(.regularMaterial)
                }
            }
    }
}

struct CurrencySelectionMacOSView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencySelectionMacOSView()
    }
}
