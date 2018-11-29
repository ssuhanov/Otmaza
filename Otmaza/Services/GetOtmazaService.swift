//
//  GetOtmazaService.swift
//  Otmaza
//
//  Created by Serge Sukhanov on 11/28/18.
//  Copyright © 2018 Serge Sukhanov. All rights reserved.
//

import Foundation

typealias OtmazaCompletion = (String?) -> Void

class GetOtmazaService {
    var extractOtmazaService: ExtractOtmazaService
    
    init(extractOtmazaService: ExtractOtmazaService = ExtractOtmazaService()) {
        self.extractOtmazaService = extractOtmazaService
    }
    
    func getOtmazaWith(number: Int, completion: OtmazaCompletion?) {
        let urlString = "\(ApplicationConstants.LocaleUrl)\(ApplicationConstants.AdditionUrl)\(number)"
        guard let url = URL(string: urlString) else {
            completion?(nil)
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, _) in
            let resultString: String?
            guard let data = data else {
                resultString = nil
                return
            }
            
            resultString = self.extractOtmazaService.extractOtmaza(body: String(data: data, encoding: .utf8))
            completion?(resultString)
        }
        dataTask.resume()
    }
}
