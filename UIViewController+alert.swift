//
//  UIViewController+alert.swift
//
//  Created by Reza Emdad on 3/20/18.
//  Copyright © 2018 Objexo LLC. All rights reserved.
//
//

import Foundation
import UIKit


extension UIViewController {
    
    func showAlert(withTitle title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertOnSelf(withTitle title: String?, message: String?) {
        if self.navigationController?.visibleViewController == self {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
}
