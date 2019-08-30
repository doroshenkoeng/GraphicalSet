//
//  AboutTheAuthorViewController.swift
//  GraphicalSet
//
//  Created by Сергей Дорошенко on 30/08/2019.
//  Copyright © 2019 Сергей Дорошенко. All rights reserved.
//

import UIKit

/// This class designed to show some information about the author of the game.
class AboutTheAuthorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    /// This method closes AboutTheAuthorViewController's screen.
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }
}
