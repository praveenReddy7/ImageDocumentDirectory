//
//  ViewController.swift
//  DocumentDirectory
//
//  Created by praveen reddy on 8/14/20.
//  Copyright © 2020 praveen reddy. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    var imagePicker = UIImagePickerController()
    var imagePicked: UIImage?
    var imageView: UIImageView!
    var imageName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imageView = UIImageView()
        imageView.frame = CGRect(x: 10, y: 40, width: 200, height: 200)
        view.addSubview(imageView)
        
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("pick image", for: .normal)
        btn.backgroundColor = .gray
        btn.addTarget(self, action: #selector(btnClicked(_:)), for: .touchUpInside)
        view.addSubview(btn)
        
        btn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        btn.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        createDirectory()
    }
    
    @objc func btnClicked(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage, let name = info[.imageURL] as? URL {
            self.imagePicked = image
            self.imageName = name.lastPathComponent
            print(name.lastPathComponent)
            saveImageToDocumentDirectory(imageName: name.lastPathComponent, image: image)
        }
        /* picking image from directory to check if it is saved or not.*/
        let dbImg = getImageFromDocumentDirectory(imageName: self.imageName ?? "")
        self.imageView.image = dbImg
        
        self.dismiss(animated: true, completion: nil)
    }

   
    
    func createDirectory() {
        let fileManager = FileManager.default
        let paths = ViewController.getImagesDirectoryPath()
        
        if !fileManager.fileExists(atPath: paths) {
            try! fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
        } else {
            print("Already dictionary created.")
        }
    }
    
    func saveImageToDocumentDirectory(imageName: String, image: UIImage) {
        let fileManager = FileManager.default
        let paths = (ViewController.getImagesDirectoryPath() as NSString).appendingPathComponent(imageName)
        
        let imageData = image.jpegData(compressionQuality: 0.5)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
    }
    
    func getImageFromDocumentDirectory(imageName: String) -> UIImage? {
        let fileManager = FileManager.default
        let imagePath = (ViewController.getImagesDirectoryPath() as NSString).appendingPathComponent(imageName)
        
        if fileManager.fileExists(atPath: imagePath){
            return UIImage(contentsOfFile: imagePath)
        } else {
            print("No Image.")
            return nil
        }
    }
    
    static func getImagesDirectoryPath() -> String {
        return (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("CapturedImages")
    }


    func deleteDirectory() {
        let fileManager = FileManager.default
        let paths = ViewController.getImagesDirectoryPath()
        
        if fileManager.fileExists(atPath: paths) {
            try! fileManager.removeItem(atPath: paths)
        } else {
            print("Something wronge.")
        }
    }
}

