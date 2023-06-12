//
//  AppDelegate.swift
//  CurrencyStatusBar
//
//  Created by Артем Дорожкин on 04.06.2023.
///

import AppKit
import SwiftUI

//class AppDelegate: NSObject, NSApplicationDelegate {
//
//    // Нам нужно объявить здесь NSStatusItem, иначе он будет уничтожен после
//        // вызывается applicationDidFinishLaunching
//    var statusBarItem : NSStatusItem!
//    var statusBarMenu : NSMenu!
//
//    func applicationDidFinishLaunching(_ notification: Notification) {
//
//        // Возвращает общесистемную строку состояния, расположенную в строке меню.
//        let statusBar = NSStatusBar.system
//
//        // Возвращает вновь созданный элемент состояния, которому отведено указанное место в строке состояния.
//        self.statusBarItem = statusBar.statusItem(withLength: NSStatusItem.squareLength)
//        self.statusBarItem.button?.image = NSImage(systemSymbolName: "star.fill", accessibilityDescription: "Status bar icon")
//
//        // Объект, который управляет меню приложения.
//        self.statusBarMenu = NSMenu()
//        self.statusBarMenu.addItem(withTitle: "Hello", action: nil, keyEquivalent: "")
//
//        // Добавляем меню в строку состояния
//        self.statusBarItem.menu = self.statusBarMenu
//    }
//}

class AppDelegate: NSObject, NSApplicationDelegate {
    
    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
    @State var factor = 1.0
    let persistenceController = PersistenceController.shared
    
    @MainActor func applicationDidFinishLaunching(_ notification: Notification) {
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let statusButton = statusItem.button {
            
            let imageName: String
            
            imageName = "logo"
            
//            if NSApplication.shared.effectiveAppearance.bestMatch(from: [.darkAqua]) == .darkAqua {
//                              imageName = "logo"
//                          } else {
//                              imageName = "logo"
//                          }

                          let image = NSImage(named: NSImage.Name(imageName))
                          statusButton.image = image
                          statusButton.action = #selector(togglePopover)
        }
        
        self.popover = NSPopover()
        setupPopover()
    }
    @objc func setupPopover(){
        
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: StatusBarView() .environment(\.managedObjectContext, persistenceController.container.viewContext))
        
    }
    @objc func togglePopover() {
            
            
            if let button = statusItem.button {
                if popover.isShown {
                    self.popover.performClose(nil)
                } else {
                    popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
                }
            }
            
    }
    
    
}
