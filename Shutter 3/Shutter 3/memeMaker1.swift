//
//  memeMaker1.swift
//  Shutter 3
//
//  Created by Mario Kardum on 09/05/2018.
//  Copyright © 2018 dumar022. All rights reserved.
//

import UIKit

class memeMaker1: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var backBtn3: UIButton!
    @IBOutlet weak var chooseTheImage: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var pickedImage: UIImageView!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self

    }
    
    // Picker
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info [UIImagePickerControllerOriginalImage] as! UIImage
        pickedImage.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    // Texts
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        topTextField.resignFirstResponder()
        bottomTextField.resignFirstResponder()
        return true
    }
    
    
    
    // Buttons
    
    @IBAction func back3Act(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func chooseImageAction(_ sender: Any) {
        
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        
        present(controller, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var passby = segue.destination as! memeMaker2
        passby.topText = topTextField.text!
        passby.bottomText = bottomTextField.text!
        passby.theImage = pickedImage.image
    }
    
    
    
    @IBAction func nextButton(_ sender: Any) {
        performSegue(withIdentifier: "meme2meme", sender: nil)
        
        
    }
    

  

}
