//
//  ApplicationConstants.swift
//  Otmaza
//
//  Created by Serge Sukhanov on 11/28/18.
//  Copyright © 2018 Serge Sukhanov. All rights reserved.
//

import Foundation

struct ApplicationConstants {
    static var Locale: Localization = .ru
    static let Blockquote = "blockquote"
    static var LocaleUrl: String {
        let baseUrl = "http://copout.me"
        switch Locale {
        case .ru:
            return baseUrl
        case .eng:
            return "\(baseUrl)/en"
        }
    }
    static let AdditionUrl = "/get-excuse/"
    
    static let MaxOtmazaNumber: UInt32 = 1000
    static let MaxImageNumber: UInt32 = 15
}

enum Localization {
    case ru
    case eng
}
