//
//  OtmazaModel.swift
//  Otmaza
//
//  Created by Serge Sukhanov on 08.05.16.
//  Copyright © 2016 Serge Sukhanov. All rights reserved.
//

import Foundation

class OtmazaModel {
    
    var inputDictionary = Dictionary<String, AnyObject>()
    
    convenience init(inputDictionary: Dictionary<String, AnyObject>) {
        self.init()
        self.inputDictionary = inputDictionary
    }
    
    convenience init(otmaza: Otmaza) {
        self.init()
        self.id = otmaza.id!
        self.text = otmaza.text!
        self.local = otmaza.local!
    }
    
    var id: NSNumber {
        set(newId) {
            inputDictionary["id"] = newId
        }
        get {
            return (inputDictionary["id"] as? NSNumber)!
        }
    }
    
    var text: String {
        set(newText) {
            inputDictionary["text"] = newText
        }
        get {
            return (inputDictionary["text"] as? String)!
        }
    }
    
    var local: String {
        set(newLocal) {
            inputDictionary["local"] = newLocal
        }
        get {
            return (inputDictionary["local"] as? String)!
        }
    }
    
}
