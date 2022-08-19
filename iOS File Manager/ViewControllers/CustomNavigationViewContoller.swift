//
//  CustomNavigationViewContoller.swift
//  iOS File Manager
//
//  Created by Егор Белоцкий on 18.07.22.
//

import UIKit

class CustomNavigationViewContoller: UINavigationController {
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.checkPassword()
        }
    }
    
    // MARK: - Key chain alerts
    
    func checkPassword() {
        if KeyChainService.shared.getPassword() == nil {
            showCreatePasswordAlert()
        }
        else {
            showEnterPasswordAlert()
        }
    }
    
    func showCreatePasswordAlert() {
        let alertController = UIAlertController(title: "Create password",
                                                message: nil,
                                                preferredStyle: .alert)
        
        alertController.addTextField()
        alertController.addTextField()
        
        alertController.textFields?.first?.isSecureTextEntry = true
        alertController.textFields?.last?.isSecureTextEntry = true
        alertController.textFields?.first?.placeholder = "New password"
        alertController.textFields?.last?.placeholder = "Confirm password"
        
        
        let acceptAction = UIAlertAction(title: "Ok", style: .default) { _ in
            guard let password = alertController.textFields?.first?.text else { return }
            guard let confirmedPassword = alertController.textFields?.last?.text else { return }
            
            if password != confirmedPassword || confirmedPassword.isEmpty {
                self.showCreatePasswordAlert()
            } else {
                self.createPassword(password: password)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { _ in
            exit(0)
        }
        
        alertController.addAction(acceptAction)
        alertController.addAction(cancelAction)
        
        viewControllers.first?.present(alertController, animated: true)
    }
    
    func createPassword(password: String) {
        KeyChainService.shared.setPassword(value: password)
    }

    func showEnterPasswordAlert() {
        let alertController = UIAlertController(title: "Access denied!",
                                                message: "Please, enter password",
                                                preferredStyle: .alert)
        
        alertController.addTextField()
        
        alertController.textFields?.first?.isSecureTextEntry = true
        alertController.textFields?.first?.placeholder = "Password"
        
        let acceptAction = UIAlertAction(title: "Ok", style: .default) { _ in
            guard let passwordText = alertController.textFields?.first?.text else { return }
            
            if passwordText != KeyChainService.shared.getPassword() {
                self.showEnterPasswordAlert()
            }
        }

        let cancelAction = UIAlertAction(title: "Quit ", style: .destructive) { _ in
            exit(0)
        }
        
        alertController.addAction(acceptAction)
        alertController.addAction(cancelAction)
        
        viewControllers.first?.present(alertController, animated: true)
    }
}
