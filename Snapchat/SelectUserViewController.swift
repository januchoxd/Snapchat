//
//  SelectUserViewController.swift
//  Snapchat
//
//  Created by janusz jas on 02.03.2017.
//  Copyright © 2017 Janusz Pietkun. All rights reserved.
//

import UIKit
import Firebase

class SelectUserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var users : [User] = []
    
    var imageURL = ""
    var descrip = ""
    var uuid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        FIRDatabase.database().reference().child("users").observe(FIRDataEventType.childAdded, with: {(snapshot) in
        print(snapshot)
        
        //wyswietlanie dostępnych użytkownikow po email do wysłania snapa
            
        let user = User()
            
        user.email = snapshot.childSnapshot(forPath: "email").value as! String
        user.uid = snapshot.key
        
        self.users.append(user)
        self.tableView.reloadData()
        
    })
    
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.email
        
        return cell
    }

    //wybieramy któremu użytkownikowi wysłać i wysyłamy
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = users[indexPath.row]
        //
        let snap = ["from": FIRAuth.auth()?.currentUser?.email!, "descritpion": descrip, "imageURL":imageURL, "uuid":uuid]
        FIRDatabase.database().reference().child("users").child(user.uid).child("snaps").childByAutoId().setValue(snap)
        //aby po wysłaniu snapa wrocic do glownego menu
        navigationController!.popToRootViewController(animated: true)
    }
}
