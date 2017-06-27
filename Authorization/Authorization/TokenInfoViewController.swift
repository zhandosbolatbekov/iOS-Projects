//
//  TokenInfoViewController.swift
//  Authorization
//
//  Created by Нурлан on 21.06.17.
//  Copyright © 2017 Codebusters. All rights reserved.
//

import UIKit

class TokenInfoViewController: UIViewController {

    // MARK: - переменные
    var user: User! {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - outlet'ы
    @IBOutlet weak var tokenLabel: UILabel!
    
    // MARK: - внутренние функции
    private func updateUI() {
        tokenLabel?.text = user.token
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
}
