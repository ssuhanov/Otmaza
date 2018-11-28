//
//  MainView.swift
//  Otmaza
//
//  Created by Serge Sukhanov on 11/20/18.
//  Copyright © 2018 Serge Sukhanov. All rights reserved.
//

import UIKit

protocol MainViewProtocol: class {
    func startSpinner()
    func stopSpinner()
    func updateLabel(text: String)
    func updateBackground(imageName: String)
    func enableButton()
    func disableButton()
}

class MainView: UIViewController {
    var controller: MainController!
    
    override func awakeFromNib() {
        self.controller = MainController(view: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.controller.getOtmaza()
    }
}

// MARK: - MainViewProtocol
extension MainView: MainViewProtocol {
    func startSpinner() {
        
    }
    
    func stopSpinner() {
        
    }
    
    func updateLabel(text: String) {
        
    }
    
    func updateBackground(imageName: String) {
        
    }
    
    func enableButton() {
        
    }
    
    func disableButton() {
        
    }
}
