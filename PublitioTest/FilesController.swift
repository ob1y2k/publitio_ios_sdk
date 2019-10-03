//
//  ViewController.swift
//  PublitIO Test
//
//  Created by gwl on 10/09/19.
//  Copyright © 2019 gwl. All rights reserved.
//

import UIKit
import Publitio
import AVKit
class FilesController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    var selectedButton: SelectedButton = .none
    let imagePicker = UIImagePickerController()
    
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorView.stopAnimating()
    }
    
    
    
    //MARK:- Action for showing list of all files
    @IBAction func actionList(_ sender: Any) {
        indicatorView.startAnimating()
        Publitio.shared.filesFetchList(limit: nil, offset: nil, order: nil, filterPrivacy: nil, filterExtensions: .mp3, filterType: .audio, filterAd: nil, tag: nil) { (success, result) in
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
        
        let audio = UIAlertAction(title: "Audio", style: .default) { _ in
            self.uploadAudio()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive) { _ in
            
        }
        
        alert.addAction(camera)
        alert.addAction(gallary)
        alert.addAction(audio)
        alert.addAction(cancel)
        
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = viewRect;
            presenter.sourceRect = viewRect.bounds;
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func compresssAction(_ sender: Any) {
        if let button = sender as? UIButton, let selecedBtn = SelectedButton(rawValue: button.tag) {
            selectedButton = selecedBtn
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
    }
    
    func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("This device doesn't have a camera.")
            return
        }
        
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = .rear
        imagePicker.delegate = self
        //imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        imagePicker.mediaTypes = ["public.image", "public.movie"]
        imagePicker.videoQuality = .typeIFrame1280x720
        present(imagePicker, animated: true)
    }
    
    
    func openPhotoLibrary() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("can't open photo library")
            return
        }
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.mediaTypes = ["public.image", "public.movie"]
        present(imagePicker, animated: true)
    }
    
    
    func uploadAudio() {
        guard let path = Bundle.main.path(forResource: "song", ofType: "mp3") else {
            assertionFailure("No audio found with this name")
            return
        }
        self.indicatorView.startAnimating()
        Publitio.shared.filesCreate(localMediaPath: path, mimeType: .mp3, fileUrl: nil, publicId: nil, title: "testAudio", description: "This is for test purpose only", tags: nil, privacy: nil, optionDownload: nil, optionTransform: false, optionAd: .enabled) { (success, result) in
            DispatchQueue.main.async {
                print(success,result)
                self.textView.text = result!.debugDescription
                self.indicatorView.stopAnimating()
            }
        }
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
    
   /* func compressVideo(videoUrl: URL)  {
        self.indicatorView.startAnimating()
        Publitio.shared.compressVideo(videoLocation: videoUrl, videoQuality: .qualitylow) { (isSuccess, compressedObj, errorString ) in
            DispatchQueue.main.async {
                if isSuccess, let compressedObject = compressedObj {
                    print(compressedObj?.compressedVideoLoaction)
                    // self.textView.text = compressedObject.compressedVideoLoaction
                    self.indicatorView.stopAnimating()
                    self.playCompressedVideo(compressedObj: compressedObject)
                } else {
                    self.indicatorView.stopAnimating()
                    print(errorString)
                }
                
            }
        }
    }*/
    
    func playCompressedVideo(compressedObj: CompressedModel) {
        let alert = UIAlertController.init(title: "Message", message: "Do you want to play compressed Video?", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "Ok", style: .default) { (action) in
            if let locationStr = compressedObj.compressedVideoLoaction {
                let videoUrl = URL(fileURLWithPath: locationStr)
                let player = AVPlayer(url: videoUrl)
                let vc = AVPlayerViewController()
                vc.player = player
                self.present(vc, animated: true) {
                    vc.player?.play()
                }
            }
        }
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}


extension FilesController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        defer {
            picker.dismiss(animated: true)
        }
        if let mediaType = info[.mediaType] as? String,  self.selectedButton == .compress {
            //  if mediaType == "public.movie" {
            self.indicatorView.startAnimating()
            if let url = info[.mediaURL] as? URL {
                print(url)
                //self.compressVideo(videoUrl: url)
                Publitio.shared.filesCreateWithCompression(localMediaPath: url, videoQuality: .quality960x540, mimeType: .mov, fileUrl: nil, publicId: nil, title: nil, description: nil, tags: nil, privacy: nil, optionDownload: nil, optionTransform: nil, optionAd: nil, completion: { (success, result) in
                    DispatchQueue.main.async {
                        print(success,result)
                        self.textView.text = result!.debugDescription
                        self.indicatorView.stopAnimating()
                       // playCompressedVideo(compressedObj: res)
                    }
                })
            }
            //            }
        } else {
            if let mediaType = info[.mediaType] as? String {
                if mediaType  == "public.image" {
                    if let image = info[.originalImage] as? UIImage {
                        
                        guard let data = image.jpegData(compressionQuality:0.3) else {
                            return
                        }
                        self.indicatorView.startAnimating()
                        self.saveImageFile(name: "image.jpg", data: data) { (error, url) in
                            if let url = url {
                             
                                Publitio.shared.filesCreate(localMediaPath: url.path, mimeType: .png, fileUrl: nil, publicId: nil, title: nil, description: nil, tags: nil, privacy: nil, optionDownload: nil, optionTransform: nil, optionAd: nil, completion: { (success, result) in
                                    DispatchQueue.main.async {
                                        print(success,result)
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
                } else if mediaType == "public.movie" {
                    if let url = info[.mediaURL] as? URL {
                           print(url)
                        self.indicatorView.startAnimating()
                        Publitio.shared.filesCreate(localMediaPath: url.path, mimeType: .mov, fileUrl: nil, publicId: nil, title: nil, description: nil, tags: nil, privacy: nil, optionDownload: nil, optionTransform: nil, optionAd: nil, completion: { (success, result) in
                            DispatchQueue.main.async {
                                print(success,result)
                                self.textView.text = result!.debugDescription
                                self.indicatorView.stopAnimating()
                            }
                        })
                    }
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



enum SelectedButton:Int {
    case none = 0
    case create
    case list
    case show
    case update
    case delete
    case compress
}
