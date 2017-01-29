//
//  LoginFormVC.swift
//  DUber
//
//  Created by Mazen on 28/01/2017.
//  Copyright © 2017 Mazen. All rights reserved.
//

import Foundation
import UIKit
import JDStatusBarNotification
import RxSwift

enum LoginMode {
    case student
    case staff
}

class LoginFormVC: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    var loginMode: LoginMode = .student
    
    @IBAction func didSwipe(_ sender: UISwipeGestureRecognizer) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onSignUpTap(_ sender: UIButton) {
        if canSignUp() {
            switch loginMode {
            case .student:
                handleUserLogin()
            case .staff:
                handleStaffLogin()
            }
        } else {
            JDStatusBarNotification.show(withStatus: "Make sure you did fill all the fields!", styleName: "Error")
            JDStatusBarNotification.dismiss(after: 5)
        }
    }
    
    func handleUserLogin() {
        self.passwordField.endEditing(true)
        self.phoneField.endEditing(true)
        self.usernameField.endEditing(true)
        _ = ApiClient.loginStudent(login: usernameField.text!, password: passwordField.text!)
            .flatMap({ (student) -> Observable<Student?> in
                if let fetchedStudent = student {
                    return ApiClient.sendUserPhoneAndPushToke(userID: fetchedStudent.id, phone: self.phoneField.text!, push: Student.pushToken)
                } else {
                    return Observable.just(nil)
                }
            })
            .do(onNext: { (student) in
            if let loggedInUser = student {
                Student.sharedCurrentStudentInstance = loggedInUser
                self.transferToStudentLocationPicker(student: loggedInUser)
            } else {
                JDStatusBarNotification.show(withStatus: "Error signing student in", styleName: "Error")
                JDStatusBarNotification.dismiss(after: 5)
            }
        }, onError: { (err) in
            JDStatusBarNotification.show(withStatus: err.localizedDescription, styleName: "Error")
        }, onCompleted: nil, onSubscribe: nil, onDispose: nil)
            .subscribe { _ in }
    }
    
    func handleStaffLogin() {
        self.passwordField.endEditing(true)
        self.phoneField.endEditing(true)
        self.usernameField.endEditing(true)
        let driver = Driver(id: 1, name: "Rob", surname: "Johnson", phone: "123456")
        transferToStaffView(driver: driver)
    }
    
    func transferToStudentLocationPicker(student: Student) {
        Student.sharedCurrentStudentInstance = student
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "studentPickup") as! StudentPickupVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func transferToStaffView(driver: Driver) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "driverVC") as! DriverVC
        Driver.currentDriverSharderInstance = driver
        vc.driver = driver
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        JDStatusBarNotification.addStyleNamed("Error", prepare: { (style) -> JDStatusBarStyle? in
            style?.barColor = UIColor.red
            style?.textColor = UIColor.white
            return style
        })
        
        usernameField.delegate = self
        phoneField.delegate = self
        passwordField.delegate = self
        
        signUpButton.layer.borderWidth = 2
        signUpButton.layer.borderColor = UIColor.white.cgColor
        signUpButton.layer.cornerRadius = 5
    }
    
    func canSignUp() -> Bool {
        guard let a = phoneField.text?.characters.count,
            let b = usernameField.text?.characters.count,
            let c = passwordField.text?.characters.count else {
                return false
        }
        if a > 0 && b > 0 && c > 0 {
            return true
        } else {
            return false
        }
    }
}

extension LoginFormVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}
