//
//  VersionsViewController.swift
//  PublitIO Test
//
//  Created by gwl on 10/09/19.
//  Copyright © 2019 gwl. All rights reserved.
//

import UIKit
import Publitio

class VersionsViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!

    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorView.stopAnimating()
    }
    
    @IBAction func create(_ sender: Any) {

        let alertController = UIAlertController(title: "Create version", message: "", preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter file id"
        }
        
        let saveAction = UIAlertAction(title: "Create", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            
            if let textOne = firstTextField.text?.replacingOccurrences(of: " ", with: "") ,!textOne.isEmpty {
                self.indicatorView.startAnimating()
                Publitio.shared.versionCreate(fileId: textOne, extensions: .mp3, transformOption: .audioWaveform(frontColorHexCode: "7CC112")) { (success, result) in
                    DispatchQueue.main.async {
                        self.indicatorView.stopAnimating()
                        self.textView.text = result!.debugDescription
                        print(success, result)
                    }
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
        
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func list(_ sender: Any) {
        self.indicatorView.startAnimating()
        Publitio.shared.versionList(fileId: "H9t6AmLl") {  (success, result) in
            DispatchQueue.main.async {
                self.indicatorView.stopAnimating()
                self.textView.text = result!.debugDescription
                print(success, result)
            }
        }
    }
    
    @IBAction func show(_ sender: Any) {
    }
    
    @IBAction func update(_ sender: Any) {
    }
    
    @IBAction func reconvert(_ sender: Any) {
        self.indicatorView.startAnimating()
        Publitio.shared.versionReconvert(versionId: "W83fmzHB") { (success, result) in
            DispatchQueue.main.async {
                self.indicatorView.stopAnimating()
                self.textView.text = result!.debugDescription
                print(success, result)
            }
        }
    }
    
    @IBAction func actionDelete(_ sender: Any) {
    }
    
}
