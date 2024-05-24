//
//  SkillListViewController.swift
//  SkillNest
//
//  Created by Davis Zarins on 23/05/2024.
//

import UIKit
import RealmSwift
import Toast
import MessageUI

class SkillListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var text1: UILabel!
    @IBOutlet weak var text2: UILabel!
    @IBOutlet weak var formView: UIView!
    
    @IBOutlet weak var type: UITextField!
    @IBOutlet weak var desc: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var location: UITextField!
    
    var name: String!
    var email: String!
    
    var userType: UserType = .unknown
    
    var tableData: [TableRow] = []
    
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        formView.isHidden = true

        let nib = UINib(nibName: "SkillListTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "skillCell")

        self.text1.text = "Sveiki, " + name + "!"
        self.text2.text = userType == .client ? "Apskatiet profesionāļu piedāvājumus!" : "Apskatiet klientu pieprasījumus!"
        
        tableView.reloadData()
    }
    
    func setup(userType: UserType, name: String, email: String) {
        self.userType = userType
        self.name = name
        self.email = email
        
        if userType == .client {
            
            let profServices = realm.objects(ProfService.self)
            profServices.forEach { serv in
                tableData.append(TableRow(type: serv.type, desc: serv.desc, price: serv.price, location: serv.location, name: serv.name, email: serv.email))
            }
            
        } else if userType == .professional {
            
            let clientRequests = realm.objects(ClientRequest.self)
            clientRequests.forEach { req in
                tableData.append(TableRow(type: req.type, desc: req.desc, price: req.price, location: req.location, name: req.name, email: req.email))
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "skillCell", for: indexPath) as! SkillListTableViewCell
        let data = tableData[indexPath.row]
        cell.setup(type: data.type, desc: data.desc, price: data.price, location: data.location, name: data.name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = tableData[indexPath.row]

        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            mailComposeVC.setToRecipients([data.email])
            mailComposeVC.setSubject("SkillNest - \(data.type)")
            mailComposeVC.setMessageBody("Sveiki, \(data.name).", isHTML: false)
            
            present(mailComposeVC, animated: true, completion: nil)
        }
        
        print(data.email)
        print("SkillNest - \(data.type)")
        print("Sveiki, \(data.name).")
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: true, completion: nil)
    }
    
    @IBAction func showFormBtnTapped(_ sender: Any) {
        formView.isHidden = false
    }
    
    @IBAction func xBtnTapped(_ sender: Any) {
        formView.isHidden = true
    }
    
    @IBAction func addBtnTapped(_ sender: Any) {
        let type = type.text!
        let desc = desc.text!
        let price = price.text!
        let location = location.text!
        
        if type.isEmpty || desc.isEmpty || price.isEmpty || location.isEmpty {
            self.view.makeToast("Aizpildiet visus laukus!")
            return
        }
        
        if userType == .client {
            let clientReq = ClientRequest()
            clientReq.type = type
            clientReq.desc = desc
            clientReq.price = price
            clientReq.location = location
            clientReq.name = name
            clientReq.email = email
            
            try! realm.write {
                realm.add(clientReq)
            }
        } else if userType == .professional {
            let profServ = ProfService()
            profServ.type = type
            profServ.desc = desc
            profServ.price = price
            profServ.location = location
            profServ.name = name
            profServ.email = email
            
            try! realm.write {
                realm.add(profServ)
            }
        }
        
        self.view.makeToast("Ieraksts pievienots")
        
        formView.isHidden = true
    }

}
    
struct TableRow {
    var type: String
    var desc: String
    var price: String
    var location: String
    var name: String
    var email: String
}

class ClientRequest: Object {
    @Persisted var type: String
    @Persisted var desc: String
    @Persisted var price: String
    @Persisted var location: String
    @Persisted var name: String
    @Persisted var email: String
}

class ProfService: Object {
    @Persisted var type: String
    @Persisted var desc: String
    @Persisted var price: String
    @Persisted var location: String
    @Persisted var name: String
    @Persisted var email: String
}

enum UserType {
    case client
    case professional
    case unknown
}
