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
    func getOtmazaWith(number: Int, completion: OtmazaCompletion?) {
        let urlString = "\(ApplicationConstants.BaseUrl)\(ApplicationConstants.AdditionUrl)\(number)"
        guard let url = URL(string: urlString) else {
            completion?(nil)
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let resultString: String?
            guard let data = data else {
                resultString = nil
                return
            }
            
            resultString = ExtractOtmazaService().extractOtmaza(body: String(data: data, encoding: .utf8))
            completion?(resultString)
        }
        dataTask.resume()
    }
}
