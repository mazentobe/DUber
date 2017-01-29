//
//  LoginVC.swift
//  DUber
//
//  Created by Mazen on 28/01/2017.
//  Copyright © 2017 Mazen. All rights reserved.
//

import Foundation
import UIKit

class LoginVC: UIViewController {
    @IBOutlet weak var studentButton: UIButton!
    @IBOutlet weak var staffButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonDesign(studentButton)
        buttonDesign(staffButton)
    }
    
    func buttonDesign(_ button: UIButton) {
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 6
        button.layer.borderColor = UIColor.white.cgColor
    }
    
    @IBAction func onStaffTap(_ sender: UIButton) {
        instantiateFormLogin(type: .staff)
    }
    @IBAction func onStudenTap(_ sender: UIButton) {
        instantiateFormLogin(type: .student)
    }
    
    func instantiateFormLogin(type: LoginMode) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginForm") as! LoginFormVC
        vc.loginMode = type
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
