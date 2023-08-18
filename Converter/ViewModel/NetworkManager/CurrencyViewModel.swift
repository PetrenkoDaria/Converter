//
//  ConverterModel.swift
//  Converter
//
//  Created by Дарья Петренко on 23.05.2023.
//

import Foundation

class CurrencyViewModel : ObservableObject{
    
    @Published var isLoading = false
    @Published var isError = false
    
    let parser = Parser()
    let viewContext = PersistenceController.shared.container.viewContext
    
    let currency = ["USDRUB","EURRUB","EURUSD","EURGBP","EURJPY","EURKZT","EURAED","EURBYN","USDGBP","USDJPY","USDKZT","USDKGS","USDAED","USDUAH","USDTHB","USDBYN","GBPRUB","GBPJPY","GBPAUD","JPYRUB","RUBKZT","RUBAED","BYNRUB","CNYRUB","CNYUSD","CNYEUR","BTCRUB","BTCUSD","BTCEUR","BTCGBP","BTCJPY","BTCBCH","BTCXRP","BCHUSD","BCHRUB","BCHGBP","BCHEUR","BCHJPY","BCHXRP","XRPUSD","XRPRUB","XRPGBP","XRPEUR","XRPJPY","GELUSD","GELRUB","THBEUR","THBRUB","BTGUSD","ETHUSD","ZECUSD","USDVND","USDMYR","RUBAUD","THBCNY","JPYAMD","JPYAZN","IDRUSD","EURTRY","USDAMD","USDILS","RUBNZD","RUBTRY","RUBSGD","CADRUB","CHFRUB","USDAUD","USDCAD","EURAMD","EURBGN","GBPBYN","RUBAMD","RUBBGN","RUBMYR","MDLEUR","MDLRUB","ETHRUB","ETHEUR","ETHGBP","ETHJPY","RSDRUB","RSDEUR","RSDUSD","LKRRUB","LKRUSD","LKREUR","MMKRUB","MMKUSD","MMKEUR"]
    let mainPath = "https://currate.ru/api/"
    let key = GitIgnore().key
    
    private func loadData() async -> Dictionary<String, AnyObject>? {
        let allCurrency = currency.reduce("", { $0 == "" ? $1 : $0 + "," + $1 })
        let urlString = mainPath + "?get=rates&pairs=" + allCurrency + "&key=" + key
        let url = URL(string: urlString)
        
        return await withCheckedContinuation { continuation in
            URLSession.shared.dataTask(with: url!) { data, response, error in
                do {
                    if error == nil {
                        let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? Dictionary<String, AnyObject>
                        if json?["status"] as! Int == 200 {
                           continuation.resume(returning: json)
                            Task {
                                self.isError = false
                            }
                          
                        } else {
                            continuation.resume(returning: nil)
                            self.isError = true
                        }
                    } else {
                        print(error!.localizedDescription)
                        self.isError = true
                    }
                }
            }.resume()
        }
    }
    
    func saveCurrencyData() {
        Task{
            await MainActor.run(body: {
                isLoading = true
            })
            
            let request = CurrencyConverter.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \CurrencyConverter.date, ascending: false)]
            let result = try viewContext.fetch(request)
            if !Calendar.current.isDateInToday(result.first?.date ?? Date(timeIntervalSince1970: 1653736124)) || result.isEmpty {
                if let currencies = await self.loadData() {
                    let dictData: Dictionary<String, String> = currencies["data"] as? Dictionary<String, String> ?? [:]
                    for item in currency {
                        let newCurrency = CurrencyConverter(context: viewContext)
                        newCurrency.currencyPair = item
                        newCurrency.exchange = dictData[item]
                        newCurrency.date = Date()
                    }
                    do {
                        if isError == false{
                            try viewContext.save()
                            print("✅Successfully added to CoreData", currency.count, "items")
                            await MainActor.run(body: {
                                isLoading = false
                            })
                        }
                    } catch {
                        print(error)
                    }
                } else {
                    print("🍺 Error load data")
                    await MainActor.run(body: {
                        isLoading = false
                    })
                }
            }else{
                print("🍺 CoreData isn't empty")
                await MainActor.run(body: {
                    isLoading = false
                })
            }
        }
    }
}
