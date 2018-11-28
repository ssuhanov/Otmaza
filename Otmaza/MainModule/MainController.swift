//
//  MainController.swift
//  Otmaza
//
//  Created by Serge Sukhanov on 11/28/18.
//  Copyright © 2018 Serge Sukhanov. All rights reserved.
//

import Foundation

class MainController {
    unowned var view: MainViewProtocol
    var currentOtmazaNumber: Int
    var currentImageNumber: Int
    var randomizerService: RandomizerService
    var otmazaService: GetOtmazaService
    
    init(view: MainViewProtocol,
         randomizerService: RandomizerService = RandomizerService(),
         otmazaService: GetOtmazaService = GetOtmazaService()) {
        self.view = view
        self.currentOtmazaNumber = -1
        self.currentImageNumber = -1
        self.randomizerService = randomizerService
        self.otmazaService = otmazaService
    }
    
    func getOtmaza() {
        self.view.startSpinner()
        self.view.disableButton()
        let otmazaNumber = self.randomizerService.getAnotherRandomNumber(currentNumber: self.currentOtmazaNumber, maxValue: ApplicationConstants.MaxOtmazaNumber)
        self.otmazaService.getOtmazaWith(number: otmazaNumber) { (otmazaString) in
            if let otmaza = otmazaString {
                self.currentOtmazaNumber = otmazaNumber
                self.updateWith(otmaza: otmaza)
            } else {
                self.getOtmaza()
            }
        }
    }
    
    private func updateWith(otmaza: String) {
        self.view.stopSpinner()
        self.view.updateLabel(text: otmaza)
        let imageNumber = self.randomizerService.getAnotherRandomNumber(currentNumber: self.currentImageNumber, maxValue: ApplicationConstants.MaxImageNumber)
        self.view.updateBackground(imageName: "\(imageNumber)")
        self.currentImageNumber = imageNumber
        self.view.enableButton()
    }
}
