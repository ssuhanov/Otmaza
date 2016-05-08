//
//  DataStore.swift
//  Otmaza
//
//  Created by Serge Sukhanov on 08.05.16.
//  Copyright © 2016 Serge Sukhanov. All rights reserved.
//

import Foundation

class DataStore {
    class var defaultLocalDB: CoreDataEngine {
        return CoreDataEngine.sharedInstance
    }
}