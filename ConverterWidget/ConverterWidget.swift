//
//  ConverterWidget.swift
//  ConverterWidget
//
//  Created by Дарья Петренко on 29.05.2023.
// //

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    
    let currencyObject = CurrencyViewModel()
    @AppStorage("selectedCurrency") var selectedCurrency: String = "EUR"
    
    func placeholder(in context: Context) -> SimpleEntry {
        do{
            let currency = try getCurrencyData()
            return SimpleEntry(date: Date(), configuration: ConfigurationIntent(), converter: currency, selectedCurrency: "EUR")
        } catch{
            print(error)
            return SimpleEntry(date: Date(), configuration: ConfigurationIntent(), converter: [:], selectedCurrency: "EUR")
        }
    }

   func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
       let configurationCurrency = configuration.currency
       selectedCurrency = converToString(items: configurationCurrency)
       let currency = try? getCurrencyData()
       let entry = SimpleEntry(date: Date(), configuration: configuration, converter: currency ?? [:], selectedCurrency: selectedCurrency)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            do {
                let configurationCurrency = configuration.currency
                selectedCurrency = converToString(items: configurationCurrency)
                let currency = try getCurrencyData()
                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                let entry = SimpleEntry(date: entryDate, configuration: configuration, converter: currency, selectedCurrency: selectedCurrency)
                entries.append(entry)
            } catch {
                print(error.localizedDescription)
            }
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    func getCurrencyData() throws -> [String : [CurrencyConverter]] {
        currencyObject.saveCurrencyData()
        let context = PersistenceController.shared.container.viewContext
        let request = CurrencyConverter.fetchRequest()
        
        request.predicate = NSCompoundPredicate(type: .or, subpredicates: [
            NSPredicate(format: "currencyPair BEGINSWITH %@", selectedCurrency),
            NSPredicate(format: "currencyPair ENDSWITH %@", selectedCurrency)
        ])
        
        let result = try context.fetch(request)
        let groupByCurrency = Dictionary(grouping: result, by: { item in
            item.currencyPair ?? ""
        })
        return groupByCurrency
    }
    
    func converToString(items: Currencies) -> String{
        switch items {
        case .eUR:
            return "EUR"
        case .rUB:
            return "RUB"
        case .uSD:
            return "USD"
        case .aED:
            return "AED"
        case .aMD:
            return "AMD"
        case .aUD:
            return "AUD"
        case .aZN:
            return "AZN"
        case .bCH:
            return "BCH"
        case .bGN:
            return "BGN"
        case .bTC:
            return "BTC"
        case .bTG:
            return "BTG"
        case .bYN:
            return "BYN"
        case .cAD:
            return "CAD"
        case .cHF:
            return "CHF"
        case .cNY:
            return "CNY"
        case .eTH:
            return "ETH"
        case .gBP:
            return "GBP"
        case .gEL:
            return "GEL"
        case .iDR:
            return "IDR"
        case .iLS:
            return "ILS"
        case .jPY:
            return "JPY"
        case .kGS:
            return "KGS"
        case .kZT:
            return "KZT"
        case .lKR:
            return "LKR"
        case .mDL:
            return "MDL"
        case .mMK:
            return "MMK"
        case .mYR:
            return "MYR"
        case .nZD:
            return "NZD"
        case .rSD:
            return "RSD"
        case .sGD:
            return "SGD"
        case .tHB:
            return "THB"
        case .tRY:
            return "TRY"
        case .uAH:
            return "UAH"
        case .vND:
            return "VND"
        case .xRP:
            return "XRP"
        case .zEC:
            return "ZEC"
        default:
            return "EUR"
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let converter: [String : [CurrencyConverter]]
    let selectedCurrency: String
}

struct ConverterWidgetEntryView : View {
    
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            systemSmallView
        case .systemMedium:
            systemMediumView
        case .systemLarge:
            systemLargeView
        default:
            systemSmallView
        }
    }
        
    //MARK: Small widget
    private var systemSmallView: some View {
        
        ZStack{
            Image("41")
                .resizable()

            Rectangle()
                .foregroundColor(.black)
                .opacity(0.2)

            VStack(alignment: .leading) {
                HStack {
                    Text("\(entry.selectedCurrency)")
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(CurrencyDecoding().currencies[entry.selectedCurrency] ?? "")
                            .font(.system(size: 7))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                           
                        Text("Updated:")
                            .font(.system(size: 7))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                        Text("\(entry.date, style: .date)")
                            .font(.system(size: 7))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                }
                Divider().background(.white)
                   
            ForEach(entry.converter.keys.sorted().prefix(5), id: \.self) { item in
                HStack {
                    let currencyConverter = entry.converter[item]?.first
                    let conditionExchange = currencyConverter?.currencyPair?.dropLast(3) ?? "EUR" == entry.selectedCurrency
                    let exchangeFirst = (Double(currencyConverter?.exchange ?? "0") ?? 0.0)
                    let exchange = conditionExchange ? exchangeFirst : 1/exchangeFirst
                    let roundExchange = String(format:"%.02f", exchange)
                    
                    HStack {
                        if currencyConverter?.currencyPair?.dropLast(3) ?? "EUR" == entry.selectedCurrency{
                            Text(currencyConverter?.currencyPair?.dropFirst(3) ?? "EUR")
                                .foregroundColor(.white)
                                .font(.system(size: 10))
                        } else {
                            Text(currencyConverter?.currencyPair?.dropLast(3) ?? "EUR")
                                .foregroundColor(.white)
                                .font(.system(size: 10))
                        }
                        Spacer()
                        Text(roundExchange == "0.00" ? "\(String(format:"%.06f", exchange))" : roundExchange)
                            .foregroundColor(.white)
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                }
                .minimumScaleFactor(0.5)
            }
        }
            .padding()
            .widgetURL(URL(string: "widget-deeplink://\(entry.selectedCurrency)")!)
    }
}
    
    
    //MARK: Medium widget
    let columnsM = [GridItem(), GridItem(), GridItem()]
    private var systemMediumView: some View {
       ZStack{
            Image("41")
                .resizable()
            Rectangle()
                .foregroundColor(.black)
                .opacity(0.2)

            VStack(alignment: .leading) {
                HStack {
                    Text("\(entry.selectedCurrency)")
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(CurrencyDecoding().currencies[entry.selectedCurrency] ?? "")
                            .font(.system(size: 7))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                        Text("Updated:")
                            .font(.system(size: 8))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                        Text("\(entry.date, style: .date)")
                            .font(.system(size: 8))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                }
                
                Divider().background(.white)
                   
                LazyVGrid(columns: columnsM) {
                    ForEach(entry.converter.keys.sorted().prefix(15), id: \.self) { item in
                        HStack {
                            let currencyConverter = entry.converter[item]?.first
                            let conditionExchange = currencyConverter?.currencyPair?.dropLast(3) ?? "EUR" == entry.selectedCurrency
                            let exchangeFirst = (Double(currencyConverter?.exchange ?? "0") ?? 0.0)
                            let exchange = conditionExchange ? exchangeFirst : 1/exchangeFirst
                            let roundExchange = String(format:"%.02f", exchange)
                            
                            HStack {
                                if currencyConverter?.currencyPair?.dropLast(3) ?? "EUR" == entry.selectedCurrency{
                                    Text(currencyConverter?.currencyPair?.dropFirst(3) ?? "EUR")
                                        .foregroundColor(.white)
                                        .font(.system(size: 10))
                                } else {
                                    Text(currencyConverter?.currencyPair?.dropLast(3) ?? "EUR")
                                        .foregroundColor(.white)
                                        .font(.system(size: 10))
                                }
                                
                                Spacer()
                                
                                Text(roundExchange == "0.00" ? "\(String(format:"%.06f", exchange))" : roundExchange)
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                                    .font(.system(size: 15))
                            }
                        }.minimumScaleFactor(0.5)
                    }
                }
        }.padding()
    }.widgetURL(URL(string: "widget-deeplink://\(entry.selectedCurrency)")!)
}
    
    //MARK: Large widget
    let columnsL = [GridItem(), GridItem()]
    private var systemLargeView: some View {
        ZStack{
            Image("41")
                .resizable()

            Rectangle()
                .foregroundColor(.black)
                .opacity(0.15)
           
            VStack(alignment: .leading) {
                HStack {
                    Text("\(entry.selectedCurrency)")
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text(CurrencyDecoding().currencies[entry.selectedCurrency] ?? "")
                            .font(.system(size: 10))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                        
                        Text("Updated:")
                            .font(.system(size: 10))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                        Text("\(entry.date, style: .date)")
                            .font(.system(size: 10))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                }
                
                Divider()
                    .background(.white)
                
                LazyVGrid(columns: columnsL) {
                    ForEach(entry.converter.keys.sorted().prefix(24), id: \.self) { item in
                        HStack {
                            let currencyConverter = entry.converter[item]?.first
                            let conditionExchange = currencyConverter?.currencyPair?.dropLast(3) ?? "EUR" == entry.selectedCurrency
                            let exchangeFirst = (Double(currencyConverter?.exchange ?? "0") ?? 0.0)
                            let exchange = conditionExchange ? exchangeFirst : 1/exchangeFirst
                            let roundExchange = String(format:"%.02f", exchange)
                            
                            HStack {
                                if currencyConverter?.currencyPair?.dropLast(3) ?? "EUR" == entry.selectedCurrency{
                                    Text(currencyConverter?.currencyPair?.dropFirst(3) ?? "EUR")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14))
                                    
                                } else {
                                    Text(currencyConverter?.currencyPair?.dropLast(3) ?? "EUR")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14))
                                }
                                Spacer()
                                Text(roundExchange == "0.00" ? "\(String(format:"%.06f", exchange))" : roundExchange)
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                                    .font(.system(size: 20))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                            }.padding(.horizontal)
                        }.minimumScaleFactor(0.5)
                    }
                }
                Spacer()
            }.widgetURL(URL(string: "widget-deeplink://\(entry.selectedCurrency)")!)
        .padding()
        }
    }
}

struct ConverterWidget: Widget {
    let kind: String = "ConverterWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            ConverterWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct ConverterWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ConverterWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), converter: [:], selectedCurrency: "EUR"))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
            
            ConverterWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), converter: [:], selectedCurrency: "EUR"))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            ConverterWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), converter: [:], selectedCurrency: "EUR"))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            }
     }
}
