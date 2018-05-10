//
//  memeMaker2.swift
//  Shutter 3
//
//  Created by Mario Kardum on 09/05/2018.
//  Copyright © 2018 dumar022. All rights reserved.
//

import UIKit

class memeMaker2: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var topText = String()
    var bottomText = String()
    var theImage: UIImage?

    @IBOutlet weak var backbut5: UIButton!
    @IBOutlet weak var savebut2: UIButton!
    @IBOutlet weak var changeFontBut: UIButton!
    @IBOutlet weak var changeColorBut: UIButton!
    
    @IBOutlet weak var memeImage: UIImageView!
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    var labelFont: UIFont?
    var labelColor: UIColor?
    
    @IBOutlet weak var fontPicker: UIPickerView!
  
    
    let fontos = ["HoeflerText-Black", "Farah", "BradleyHandITCTT-Bold", "Noteworthy-Bold", "SnellRoundhand-Bold"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memeImage.image = theImage
        topLabel.text = topText
        topLabel.textColor = UIColor.white
        topLabel.sizeToFit()
        memeImage.addSubview(topLabel)
        bottomLabel.text = bottomText
        bottomLabel.textColor = UIColor.white
        bottomLabel.sizeToFit()
        memeImage.addSubview(bottomLabel)
        
        fonts()
        

    }
    
    func fonts() {
        let finalFont = labelFont?.fontName
        topLabel.font = UIFont(name: finalFont!, size: 23)
        bottomLabel.font = UIFont(name: finalFont!, size: 23)

    }
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fontos.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return fontos[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        labelFont = UIFont(name: fontos[row], size: 23)
        topLabel.font = labelFont
        bottomLabel.font = labelFont
        
    }
    
    
    @IBAction func back6(_ sender: Any) {
    }
    
    @IBAction func savact(_ sender: Any) {
    }
    
    @IBAction func chooseFont(_ sender: Any) {
    }
    
    @IBAction func chooseCol(_ sender: Any) {
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
