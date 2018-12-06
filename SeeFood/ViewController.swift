//
//  ViewController.swift
//  SeeFood
//
//  Created by Avilash on 04/12/18.
//  Copyright © 2018 Avilash. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType  = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imageView.image = userPickedImage
            
            guard let ciImage = CIImage(image: userPickedImage) else {
                fatalError("could not convert UIImage into CIImage.")
            }
            
            detect(image: ciImage)
            
        }
      
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func detect (image: CIImage){
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML Model Failed")
        }
        
        let request = VNCoreMLRequest(model: model, completionHandler: { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("MOdel Failed to process image Request")
            }
            if let firstResult = results.first {
                if firstResult.identifier.contains("hotdog") {
                    
                    self.navigationItem.title = "Hotdog!"
                    self.navigationController?.navigationBar.barTintColor = UIColor.green
                }
                else {
                    self.navigationItem.title = "Not Hotdog!"
                    self.navigationController?.navigationBar.barTintColor = UIColor.red
                }
            }
        })
        let handler = VNImageRequestHandler(ciImage: image)
        do{
        try handler.perform([request])
        } catch {
            print("Error in Handling Image \(error)")
        }
    }
    

    @IBAction func cameraTapped(_ sender: Any) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    


}

