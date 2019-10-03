//
//  FolderViewController.swift
//  PublitIO Test
//
//  Created by gwl on 10/09/19.
//  Copyright © 2019 gwl. All rights reserved.
//

import UIKit
import Publitio

class FolderViewController: UIViewController {
   
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorView.stopAnimating()
    }
    
    @IBAction func create(_ sender: Any) {
        
        
        let alertController = UIAlertController(title: "Create folder", message: "", preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter folder name"
        }
        
        let saveAction = UIAlertAction(title: "Create", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            
            if let textOne = firstTextField.text?.replacingOccurrences(of: " ", with: "") ,!textOne.isEmpty {
                self.indicatorView.startAnimating()

                let folder = Folder(name: textOne, parentId: nil)
                
                Publitio.shared.createFolder(folder: folder) { (success, result) in
                    print(success, result)
                    DispatchQueue.main.async {
                        self.indicatorView.stopAnimating()
                        self.textView.text = result!.debugDescription
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
        let param = FolderList(parentId: nil, sortOrder: [.date:.asc], tags: .all)
        Publitio.shared.listFolder(param: param) { (success, result) in
            print(success, result)
            DispatchQueue.main.async {
                self.indicatorView.stopAnimating()
                self.textView.text = result!.debugDescription
            }
        }
        
    }
    
    @IBAction func show(_ sender: Any) {
        let alertController = UIAlertController(title: "Show Folder", message: "", preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter folder id"
        }
        
        let saveAction = UIAlertAction(title: "Create", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            
            if let textOne = firstTextField.text?.replacingOccurrences(of: " ", with: "") ,!textOne.isEmpty {
                self.indicatorView.startAnimating()
                Publitio.shared.showFolder(folderId: textOne, completion: { (success, result) in
                    print(success, result)
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
    
    
    @IBAction func update(_ sender: Any) {
        let alertController = UIAlertController(title: "Update Folder", message: "", preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter folder id"
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter folder's new name"
        }
        
        let saveAction = UIAlertAction(title: "Update", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            let secondTextField = alertController.textFields![1] as UITextField
            
            if let textOne = firstTextField.text?.replacingOccurrences(of: " ", with: "") ,!textOne.isEmpty , let textTwo = secondTextField.text ,!textTwo.isEmpty{
                self.indicatorView.startAnimating()
                
                Publitio.shared.updateFolder(folderId: textOne, name: textTwo, completion: { (success, result) in
                    print(success, result)
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
    
    
    @IBAction func deleteFolder(_ sender: Any) {
        let alertController = UIAlertController(title: "Delete Folder", message: "", preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter folder id"
        }
        
        let saveAction = UIAlertAction(title: "Delete", style: .destructive, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            
            if let textOne = firstTextField.text?.replacingOccurrences(of: " ", with: "") ,!textOne.isEmpty {
                self.indicatorView.startAnimating()

                Publitio.shared.deleteFolder(folderId: textOne, completion: { (success, result) in
                    print(success, result)
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
    
    @IBAction func tree(_ sender: Any) {
        self.indicatorView.startAnimating()

        Publitio.shared.treeFolder(completion: { (success, result) in
            print(success, result)
            DispatchQueue.main.async {
                self.indicatorView.stopAnimating()
                self.textView.text = result!.debugDescription
            }
        })
    }
    
}
