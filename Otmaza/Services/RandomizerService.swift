//
//  RandomizerService.swift
//  Otmaza
//
//  Created by Serge Sukhanov on 11/28/18.
//  Copyright © 2018 Serge Sukhanov. All rights reserved.
//

import Foundation

class RandomizerService {
    func getAnotherRandomNumber(currentNumber: Int, maxValue: UInt32) -> Int {
        var result = self.getRandomNumber(maxValue: maxValue)
        if currentNumber != -1 {
            while result == currentNumber {
                result = self.getRandomNumber(maxValue: maxValue)
            }
        }
        return result
    }
    
    private func getRandomNumber(maxValue: UInt32) -> Int {
        var result = Int(arc4random_uniform(maxValue))
        if result >= maxValue {
            result = Int(maxValue)
        }
        
        return result
    }
}
