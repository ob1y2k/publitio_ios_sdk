//
//  ViewController.swift
//  Demo
//
//  Created by GWL on 04/09/18.
//  Copyright © 2018 GWL. All rights reserved.
//

import UIKit
import MobileCoreServices
import Publitio

class ViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    let imagePicker = UIImagePickerController()
    
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorView.stopAnimating()
    }
    
    
    
    //MARK:- Action for showing list of all files
    @IBAction func actionList(_ sender: Any) {
        indicatorView.startAnimating()
        Publitio.shared.filesFetchList(limit: nil, offset: nil, order: nil, filterPrivacy: nil, filterExtensions: nil, filterType: nil, filterAd: nil, tag: nil) { (success, result) in
            if success {
                DispatchQueue.main.async {
                    self.indicatorView.stopAnimating()
                    self.textView.text = result!.debugDescription
                }
            }
        }
        
    }
    
    
    //MARK:- Action for showing a file.
    @IBAction func actionShow(_ sender: Any) {
        let alertController = UIAlertController(title: "Show File", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter File Id"
        }
        
        let showAction = UIAlertAction(title: "Show", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            
            if let text = firstTextField.text?.replacingOccurrences(of: " ", with: "") ,!text.isEmpty{
                self.indicatorView.startAnimating()
                Publitio.shared.filesShow(fileID: text, completion: { (success, result) in
                    DispatchQueue.main.async {
                        self.indicatorView.stopAnimating()
                        self.textView.text = result!.debugDescription
                    }
                })
            }else{
                self.textView.text = "enter valid file id"
            }
            
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
        
        
        alertController.addAction(cancelAction)
        alertController.addAction(showAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    //MARK:- Action for delete a file
    @IBAction func actionDelete(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Delete File", message: "", preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter File Id"
        }
        
        let showAction = UIAlertAction(title: "Delete", style: .destructive, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            
            if let text = firstTextField.text?.replacingOccurrences(of: " ", with: "") ,!text.isEmpty{
                
                self.indicatorView.startAnimating()
                Publitio.shared.filesDelete(fileID: text, completion: { (success, result) in
                    DispatchQueue.main.async {
                        self.indicatorView.stopAnimating()
                        self.textView.text = result!.debugDescription
                    }
                })
                
            }else{
                self.textView.text = "enter valid file id"
            }
            
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(cancelAction)
        alertController.addAction(showAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    //MARK:- Action for updating file
    @IBAction func actionUpdate(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Update File", message: "", preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter file id"
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter file's new name"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            let secondTextField = alertController.textFields![1] as UITextField
            
            if let textOne = firstTextField.text?.replacingOccurrences(of: " ", with: "") ,!textOne.isEmpty , let textTwo = secondTextField.text ,!textTwo.isEmpty{
                
                self.indicatorView.startAnimating()
                Publitio.shared.filesUpdate(fileID: textOne, publicId: nil, title: textTwo, description: nil, tags: nil, privacy: nil, optionDownload: nil, optionTransform: nil, optionAd: nil, completion: { (success, result) in
                    DispatchQueue.main.async {
                        self.indicatorView.stopAnimating()
                        self.textView.text = result!.debugDescription
                    }
                })
                
            }
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
        
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    //MARK:-  Action for creating a file
    @IBAction func createFile(_ sender: Any) {
        
        guard let viewRect = sender as? UIView else {
            return
        }
        
        
        let alert = UIAlertController(title: "Select Source", message: "", preferredStyle: .actionSheet)
        
        
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            self.openCamera()
        }
        
        let gallary = UIAlertAction(title: "Photos", style: .default) { _ in
            self.openPhotoLibrary()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive) { _ in
            
        }
        
        alert.addAction(camera)
        alert.addAction(gallary)
        alert.addAction(cancel)
        
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = viewRect;
            presenter.sourceRect = viewRect.bounds;
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("This device doesn't have a camera.")
            return
        }
        
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = .rear
        imagePicker.delegate = self
        imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        present(imagePicker, animated: true)
    }
    
    
    func openPhotoLibrary() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("can't open photo library")
            return
        }
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        present(imagePicker, animated: true)
    }
    
    
    func saveImageFile(name:String,data:Data,completion:(_ error:Error?,_ path:URL?)->()){
        // get the documents directory url
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // choose a name for your image
        let fileName = name
        // create the destination file url to save your image
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        print(fileURL)
        if FileManager().fileExists(atPath: fileURL.path) {
            
            do {
                try FileManager().removeItem(at: fileURL)
            }catch{
                print(error.localizedDescription)
            }
        }
        
        
        do {
            try data.write(to: fileURL, options: .atomic)
            completion(nil,fileURL)
        }
        catch{
            print(error.localizedDescription)
            completion(error,nil)
        }
        
    }
}




extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        defer {
            picker.dismiss(animated: true)
        }
        
        if let mediaType = info[UIImagePickerControllerMediaType] as? String {
            
            if mediaType  == "public.image" {
                
                //                if let url = info[UIImagePickerControllerReferenceURL] as? URL {
                //                    self.indicatorView.startAnimating()
                //                    Publitio.shared.filesCreate(localMediaPath: url.path, mimeType: .png) { (success, result) in
                //                        DispatchQueue.main.async {
                //                            self.textView.text = result!.debugDescription
                //                            self.indicatorView.stopAnimating()
                //                        }
                //                    }
                //                }else
                
                if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                    
                    let data = UIImageJPEGRepresentation(image, 0.3)!
                    self.indicatorView.startAnimating()
                    self.saveImageFile(name: "image.jpg", data: data) { (error, url) in
                        
                        if let url = url {
                            
                            Publitio.shared.filesCreate(localMediaPath: url.path, mimeType: .png, fileUrl: nil, publicId: nil, title: nil, description: nil, tags: nil, privacy: nil, optionDownload: nil, optionTransform: nil, optionAd: nil, completion: { (success, result) in
                                DispatchQueue.main.async {
                                    self.textView.text = result!.debugDescription
                                    self.indicatorView.stopAnimating()
                                }
                            })
                        }
                        else{
                            self.indicatorView.stopAnimating()
                        }
                        
                    }
                }
            }
            if mediaType == "public.movie" {
                
                if let url = info[UIImagePickerControllerMediaURL] as? URL {
                    self.indicatorView.startAnimating()
                    
                    Publitio.shared.filesCreate(localMediaPath: url.path, mimeType: .mov, fileUrl: nil, publicId: nil, title: nil, description: nil, tags: nil, privacy: nil, optionDownload: nil, optionTransform: nil, optionAd: nil, completion: { (success, result) in
                        DispatchQueue.main.async {
                            self.textView.text = result!.debugDescription
                            self.indicatorView.stopAnimating()
                        }
                    })
                }
            }
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        defer {
            picker.dismiss(animated: true)
        }
        
        print("did cancel")
    }
}


