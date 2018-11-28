//
//  MainView.swift
//  Otmaza
//
//  Created by Serge Sukhanov on 11/20/18.
//  Copyright © 2018 Serge Sukhanov. All rights reserved.
//

import UIKit

private let BlurTimer: TimeInterval = 2.0

protocol MainViewProtocol: class {
    func startSpinner()
    func stopSpinner()
    func hideLabel()
    func updateLabel(text: String)
    func updateBackground(imageName: String)
    func enableButton()
    func disableButton()
}

class MainView: UIViewController {
    var controller: MainController!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var blurEffectView: UIVisualEffectView!
    @IBOutlet weak var otmazaTextLabel: UILabel!
    @IBOutlet weak var oneMoreButton: UIButton!
    @IBOutlet weak var spinnerIndicatorView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        self.controller = MainController(view: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.controller.getOtmaza()
    }
    
    @IBAction func oneMoreButtonPressed(_ sender: UIButton) {
        self.controller.getOtmaza()
    }
}

// MARK: - MainViewProtocol
extension MainView: MainViewProtocol {
    func startSpinner() {
        DispatchQueue.main.async {
            self.spinnerIndicatorView.startAnimating()
        }
    }
    
    func stopSpinner() {
        DispatchQueue.main.async {
            self.spinnerIndicatorView.stopAnimating()
        }
    }
    
    func hideLabel() {
        DispatchQueue.main.async {
            self.otmazaTextLabel.alpha = 0.0
        }
    }
    
    func updateLabel(text: String) {
        DispatchQueue.main.async {
            self.otmazaTextLabel.text = text.uppercased()
            self.otmazaTextLabel.alpha = 1.0
        }
    }
    
    func updateBackground(imageName: String) {
        DispatchQueue.main.async {
            self.blurEffectView.alpha = 0.0
            self.backgroundImageView.image = UIImage(named: imageName)
            UIView.animate(withDuration: BlurTimer, animations: {
                self.blurEffectView.alpha = 1.0
            })
        }
    }
    
    func enableButton() {
        DispatchQueue.main.async {
            self.oneMoreButton.isEnabled = true
        }
    }
    
    func disableButton() {
        DispatchQueue.main.async {
            self.oneMoreButton.isEnabled = false
        }
    }
}
