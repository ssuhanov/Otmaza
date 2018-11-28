//
//  ExtractOtmazaService.swift
//  Otmaza
//
//  Created by Serge Sukhanov on 11/28/18.
//  Copyright © 2018 Serge Sukhanov. All rights reserved.
//

import Foundation

class ExtractOtmazaService {
    func extractOtmaza(body: String?) -> String? {
        let blockqoute = ApplicationConstants.Blockquote
        guard let body = body,
            let resultStart = body.lowercased().range(of: "<\(blockqoute)>"),
            let resultFinish = body.lowercased().range(of: "</\(blockqoute)>") else {
                return nil
        }
        
        let resultSubstring = body[resultStart.upperBound..<resultFinish.lowerBound]
        let resultString = String(resultSubstring)
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "&quot", with: "\"")
            .replacingOccurrences(of: "<br>", with: "\n")
        
        return resultString.isEmpty ? nil : resultString
    }
}
