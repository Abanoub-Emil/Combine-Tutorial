//
//  ViewController.swift
//  Combine Tutorial
//
//  Created by Abanoub Emil on 24/02/2022.
//

import UIKit
import Combine

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = Just("Anuj Rai")
            .map { (value) -> String in
                return value.uppercased()
            }
            .sink { (receivedValue) in
                print(receivedValue)
                
            }
    }


}

