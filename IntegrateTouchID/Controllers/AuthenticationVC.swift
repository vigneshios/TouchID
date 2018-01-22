//
//  ViewController.swift
//  IntegrateTouchID
//
//  Created by Apple on 22/01/18.
//  Copyright © 2018 WowDreamApps. All rights reserved.
//

import UIKit
import LocalAuthentication


class AuthenticationVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      
    }

    @IBAction func authenticateViaTouch(_ sender: Any) {
          print("Integrate touch ID Here")
        let authenticationContext = LAContext()
        var error: NSError?
        
        if authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // Touch ID, navigating to success VC, handling error
            authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Not sure, if it's human..", reply: { (success, error) in
                if success {
                    // Navigate to successVC
                    self.navigateToAuthenticatedVC()
                    
                }else {
                    if let error = error as NSError?{
                        //Display different errors , that can possibly go wrong here.
                        let message = self.errorMessageForLAErrorCode(errorCode: error.code)
                        self.showAlertForEvaluatingpolicywithMessage(message: message)
                    }
                }
            })
        }else {
            //No biometrics
            showAlertForNoBioMetrics()
            return
        }
    }
    
    func navigateToAuthenticatedVC() {
        
        if let loggedInVC = storyboard?.instantiateViewController(withIdentifier: "isLoggedInVC") {
            DispatchQueue.main.async {
                 self.navigationController?.pushViewController(loggedInVC, animated: true)
            }
           
        }
    }
    
    func showAlertForEvaluatingpolicywithMessage(message: String) {
        showAlert(title: "Error", message: message)
    }
    
    func errorMessageForLAErrorCode(errorCode: Int) -> String {
        var message = ""
        switch errorCode {
        case LAError.appCancel.rawValue:
            message = "Authentication cancelled by the application"
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not seton the device"
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
        default:
            message = "Did not find error code on LAError object"
        }
        return message
    }
    
    func showAlertForNoBioMetrics() {
        showAlert(title: "Failed", message: "Sorry,The device has no Touch ID sensor")
    }
    
    
    func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(okAction)
        DispatchQueue.main.async {
             self.present(alertVC, animated: true, completion: nil)
        }
       
    }
    
    
    
}

