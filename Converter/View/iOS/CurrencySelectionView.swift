//
//  CurrencySelectionView.swift
//  Converter
//
//  Created by Дарья Петренко on 27.05.2023.
//

import SwiftUI

struct CurrencySelectionView: View {
    
    @AppStorage("selectedCurrency", store: UserDefaults(suiteName: "group.com.sypivos.Converter"))
    var selectedCurrency: String = "EUR"
    
    var body: some View {
        ScrollView {
            VStack{
                HStack{
                    Text("Select a currency")
                        .foregroundColor(.black)
                        .font(.system(size: 50, weight: .heavy))
                   Spacer()
                }
                .padding(.top, 40)
                .padding(.bottom, 80)
                
                ForEach(CurrencyDecoding().currencies.keys.sorted(), id: \.self) { item in
                    Button {
                        selectedCurrency = item
                    } label: {
                        VStack(spacing: 5){
                            HStack(alignment: .bottom) {
                                Text(item).foregroundColor(.white)
                                
                                Spacer()
                                
                                Text("(\(CurrencyDecoding().currencies[item] ?? ""))".uppercased())
                                    .foregroundColor(.white)
                                    .font(.system(size: 12))
                                
                                Spacer()
                                
                                Image(systemName: selectedCurrency == item ? "circle.inset.filled" : "circle")
                                    .foregroundColor(.white)
                                
                            }.padding(.bottom, 40)
                            
                            Divider()
                                .background(.white)
                                .padding(.bottom, 40)
                        }
                    }.buttonStyle(.plain)
                }
                Spacer()
            }.padding()
        }.background {
            Image("3")
                .resizable()
                .ignoresSafeArea()
        }
    }
}

struct CurrencySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencySelectionView()
    }
}
