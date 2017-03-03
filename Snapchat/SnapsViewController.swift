//
//  SnapsViewController.swift
//  Snapchat
//
//  Created by janusz jas on 02.03.2017.
//  Copyright © 2017 Janusz Pietkun. All rights reserved.
//

import UIKit
import Firebase

class SnapsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var snaps : [Snap] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //to sie wykona gdy child added- dodany snap nowy do listy
        FIRDatabase.database().reference().child("users").child((FIRAuth.auth()!.currentUser?.uid)!).child("snaps").observe(FIRDataEventType.childAdded, with: {(snapshot) in
            print(snapshot)
            
            //wyswietlanie dostępnych użytkownikow po email do wysłania snapa
            
            let snap = Snap()
            
            snap.imageURL = snapshot.childSnapshot(forPath: "imageURL").value! as! String
            snap.from = snapshot.childSnapshot(forPath: "from").value! as! String
            snap.descrip = snapshot.childSnapshot(forPath: "descritpion").value! as! String
            snap.key = snapshot.key
            snap.uuid = snapshot.childSnapshot(forPath: "uuid").value! as! String
            self.snaps.append(snap)
            self.tableView.reloadData()
           
            
        })
        // to sie wykona gdy child zostanie removed - aby juz obejzany snap sie nie pokazywal
        FIRDatabase.database().reference().child("users").child((FIRAuth.auth()!.currentUser?.uid)!).child("snaps").observe(FIRDataEventType.childRemoved, with: {(snapshot) in
            print(snapshot)
            var index = 0
            
            for snap in self.snaps {
                if snap.key == snapshot.key {
                    self.snaps.remove(at: index)
                }
                index += 1
                
            }
            self.tableView.reloadData()

            
            
        })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //w przypadku gdy nie ma snapow wyswietlimy 1 komorke z napisem ze lipa
        if snaps.count == 0 {
            return 1
            
        }else {
        
        return snaps.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if snaps.count == 0 {
            cell.textLabel?.text = "ni ma snapów 🙃"
        }else {
        
        let snap = snaps[indexPath.row]
        cell.textLabel?.text = snap.from
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snap = snaps[indexPath.row]
        
        performSegue(withIdentifier: "viewsnapsegue", sender: snap)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "viewsnapsegue" {
        let nextVC = segue.destination as! ViewSnapViewController
        
        nextVC.snap = sender as! Snap
        }
    }

    @IBAction func logoutTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
  

}
