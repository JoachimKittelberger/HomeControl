//
//  ShutterList.swift
//  HomeControl
//
//  Created by Joachim Kittelberger on 07.06.17.
//  Copyright © 2017 Joachim Kittelberger. All rights reserved.
//

import Foundation

class ShutterList {
    
    private var items = [ShutterItem]()
    
    init() {
        items.append(ShutterItem(name: "Rolladen Wohnzimmer links", isEnabled: true, outputUp: 100000215, outputDown: 100000216))
        items.append(ShutterItem(name: "Rolladen Terrasse rechts", isEnabled: true, outputUp: 100000209, outputDown: 100000210))
        items.append(ShutterItem(name: "Rolladen Terrasse links", isEnabled: true, outputUp: 100000211, outputDown: 100000212))
        items.append(ShutterItem(name: "Rolladen Wohnzimmer rechts", isEnabled: true, outputUp: 100000213, outputDown: 100000214))
        items.append(ShutterItem(name: "Rolladen Küche", isEnabled: true, outputUp: 100000301, outputDown: 100000302))
        items.append(ShutterItem(name: "Rolladen Büro Andrea", isEnabled: true, outputUp: 100000303, outputDown: 100000304))
        items.append(ShutterItem(name: "Rolladen WC", isEnabled: true, outputUp: 100000305, outputDown: 100000306))
        items.append(ShutterItem(name: "Rolladen Schlafzimmer", isEnabled: true, outputUp: 100000313, outputDown: 100000314))
        items.append(ShutterItem(name: "Rolladen Büro Joachim", isEnabled: true, outputUp: 100000311, outputDown: 100000312))
        items.append(ShutterItem(name: "Rolladen Gästezimmer", isEnabled: true, outputUp: 100000309, outputDown: 100000310))
        items.append(ShutterItem(name: "Rolladen Bad", isEnabled: true, outputUp: 100000307, outputDown: 100000308))
        items.append(ShutterItem(name: "Rolladen Hobbyraum links", isEnabled: true, outputUp: 100000411, outputDown: 100000412))
        items.append(ShutterItem(name: "Rolladen Hobbyraum rechts", isEnabled: true, outputUp: 100000413, outputDown: 100000414))
        items.append(ShutterItem(name: "Rolladen Dachfenster Treppenhaus", isEnabled: true, outputUp: 100000407, outputDown: 100000408))
        items.append(ShutterItem(name: "Rolladen Dachfenster Galerie", isEnabled: true, outputUp: 100000405, outputDown: 100000406))
        items.append(ShutterItem(name: "Jalousie links", isEnabled: true, outputUp: 100000203, outputDown: 100000204))
        items.append(ShutterItem(name: "Jalousie mitte", isEnabled: true, outputUp: 100000205, outputDown: 100000206))
        items.append(ShutterItem(name: "Jalousie rechts", isEnabled: true, outputUp: 100000207, outputDown: 100000208))
        items.append(ShutterItem(name: "Dachfenster Treppenhaus", isEnabled: true, outputUp: 100000403, outputDown: 100000404))
        items.append(ShutterItem(name: "Dachfenster Galerie", isEnabled: true, outputUp: 100000401, outputDown: 100000402))
    }

    func getShutterItems() -> [ShutterItem] {
        return items
    }
    
    func getShutter(forIndex index: Int) -> ShutterItem {
        return items[index]
    }
    
}
