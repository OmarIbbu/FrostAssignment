//
//  CreateNotesViewController.swift
//  FrostAssignment
//
//  Created by Marmeto Developer  on 04/02/20.
//  Copyright © 2020 Marmeto Developer . All rights reserved.

import UIKit

class CreateNotesViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    let model = SingletonManager.model


    @IBOutlet weak var notes: UITextView!
    @IBOutlet weak var tags: UITextField!
    @IBOutlet weak var notesTitle: UITextField!
    @IBOutlet weak var attachMediaBtn: UIButton!
    
    var imageStr : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notes.layer.applySketchShadow()
        tags.layer.applySketchShadow()
        notesTitle.layer.applySketchShadow()
        attachMediaBtn.layer.applySketchShadow()
        
        tags.delegate = self
        notesTitle.delegate = self
        notes.delegate = self
    
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
       
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    @IBAction func createNotesBtnTapped(_ sender: UIButton) {
        
        
        let currentDateTime = Date()
                     
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                     
        let time =   formatter.string(from: currentDateTime)
        
        if notesTitle.text!.isEmpty {
            self.showAlertMsg("oops", message: "Plese enter title!", time: 1)
        }else if notes.text.isEmpty {
            self.showAlertMsg("oops", message: "Plese enter notes!", time: 1)

        }else {
        
            model.createNote(descrtiption: notes.text, tags: tags.text ?? "Nil", thumbnail: imageStr ?? "Nil", time: time, title: notesTitle.text ?? "Nil") { (Success) in
                if Success == true {
                    self.showAlertMsg("Success", message: "Notes have been saved successfully", time: 1)
                    self.notesTitle.text = ""
                    self.notes.text = ""
                    self.tags.text = ""
                    self.imageStr = ""
                    attachMediaBtn.setTitle("  Attach Media", for: .normal)


                }else{
                    self.showAlertMsg("Failure", message: "Notes have not been saved", time: 1)

                }
            }
        }

        
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func captureImageBtnTapped(_ sender: UIButton) {
             
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType =  UIImagePickerController.SourceType.photoLibrary
            attachMediaBtn.setTitle("  File Attached", for: .normal)

            self.present(myPickerController, animated: true, completion: nil)
    }
    
    
   
    
  
    var alertController: UIAlertController?
    var alertTimer: Timer?
    var remainingTime = 0.0
    var baseMessage: String?
    
    func showAlertMsg(_ title: String, message: String, time: Double) {
        
        guard (self.alertController == nil) else {
            return
        }
        
        self.baseMessage = message
        self.remainingTime = time
        
        self.alertController = UIAlertController(title: title, message: self.baseMessage, preferredStyle: .alert)
        
        self.alertTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
        
        if let presentedVC = presentedViewController {
            presentedVC.present(self.alertController!, animated: true, completion: nil)
        } else {
            present(self.alertController!, animated: true, completion: nil)
        }
        
    }
    
    @objc func countDown() {
        
        self.remainingTime -= 1
        if (self.remainingTime < 0) {
            self.alertTimer?.invalidate()
            self.alertTimer = nil
            self.alertController!.dismiss(animated: true, completion: {
                self.alertController = nil
            })
        } else {
            self.alertController!.message = self.alertMessage()
        }
        
    }
    
    func alertMessage() -> String {
        var message=""
        if let baseMessage=self.baseMessage {
            message=baseMessage+" "
        }
        return(message)
    }
    
    
}

extension CreateNotesViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
   
    guard let image = info[UIImagePickerController.InfoKey.originalImage]  as? UIImage else {
        return
    }
        let imageData:Data = image.jpegData(compressionQuality: 0.2)!
        self.imageStr = imageData.base64EncodedString()
        self.dismiss(animated: true, completion: nil)
    }
}
