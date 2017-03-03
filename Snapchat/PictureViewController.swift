//
//  PictureViewController.swift
//  Snapchat
//
//  Created by janusz jas on 02.03.2017.
//  Copyright © 2017 Janusz Pietkun. All rights reserved.
//

import UIKit
import Firebase

class PictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var DescriptionTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    var imagePicker = UIImagePickerController()
    var uuid = NSUUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nextButton.isEnabled = false
        imagePicker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        imageView.image = image
        
        imageView.backgroundColor = UIColor.clear
        
        nextButton.isEnabled = true
        imagePicker.dismiss(animated: true, completion: nil)
    }
  
    @IBAction func cameraTapped(_ sender: Any) {
        
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        
        nextButton.isEnabled = false
        
        //images - nazwa folderu w storage firebase
        let imagesFolder = FIRStorage.storage().reference().child("images")
        //0.1 to stopien kompresji bo normalnie jako png zdjecie miało nawet 10mb i sie wysylalo dlugo
        let imageData = UIImageJPEGRepresentation(imageView.image!, 0.1)!
        
        
        //NSUUUID doda unikalny identyfikator do zdjęcie, by sie nie nadpisywały
        imagesFolder.child("\(uuid).jpg").put(imageData, metadata: nil, completion: {(metadata, error) in
            print("we tried to upload")
            if error != nil {
                print("we had an error : \(error)")
            }else {
                print(metadata?.downloadURL()!)
                
                self.performSegue(withIdentifier: "selectUsersegue", sender: metadata?.downloadURL()!.absoluteString)
            }
        })
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       //przesyłamy do nastepnego widoku url obrazka i jego opis
        let nextVC = segue.destination as! SelectUserViewController
        nextVC.imageURL = sender as! String
        nextVC.descrip = DescriptionTextField.text!
        nextVC.uuid = uuid
        
        
        
    }
    
}
