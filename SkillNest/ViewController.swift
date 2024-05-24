//
//  ViewController.swift
//  SkillNest
//
//  Created by Davis Zarins on 23/05/2024.
//

import UIKit
import Toast

class ViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    @IBAction func registerBtnTapped(_ sender: Any) {
        if nameTextField.text!.isEmpty {
            self.view.makeToast("Lūdzu ievadiet vārdu")
        } else if emailTextField.text!.isEmpty || !isValidEmail(emailTextField.text!) {
            self.view.makeToast("Lūdzu ievadiet derīgu epastu")
        } else {
            let userType: UserType = segmentedControl.selectedSegmentIndex == 0 ? .client : .professional
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let listVC = storyboard.instantiateViewController(withIdentifier: "SkillListViewController") as! SkillListViewController
            listVC.setup(userType: userType, name: nameTextField.text!, email: emailTextField.text!)
            listVC.modalPresentationStyle = .fullScreen
            present(listVC, animated: true, completion: nil)
        }
    }
}

