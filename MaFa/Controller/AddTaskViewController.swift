//
//  AddTaskViewController.swift
//  MaFa
//
//  Created by Sundet Mukhtar on 29.05.2024.
//

import UIKit

class AddTaskViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var descritionTextView: UITextView!
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var timePicker: UIPickerView!
    @IBOutlet weak var importancePicker: UIPickerView!
    @IBOutlet weak var importanceView: UIView!
    
    var rotationAngle: CGFloat! = -90  * (.pi/180)
    
    var timeData = ["12","24","48"];
    let categoryData = ["Job","Home","Gym"];
    let importanceData = ["Critical","Urgent","Regular"];
    let importanceBorderColor = ["#A0153E","#FFBF00","#EEEEEE"];
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fashionViews();
        timePicker.delegate = self;
        timePicker.dataSource = self;
        importancePicker.delegate = self;
        importancePicker.dataSource = self;
        categoryPicker.delegate = self;
        importancePicker.dataSource = self;
    

//        timePicker.transform = CGAffineTransform(rotationAngle: rotationAngle)
//        print(timePicker.superview!.frame.width/2)
//        timePicker.frame = CGRect(x: timePicker.superview!.frame.width/2.0 * (-1), y: 0, width: timePicker.superview!.bounds.width * 2, height: timePicker.superview!.frame.height)
    
        timePicker = rotatePickerView(timePicker);
        timePicker.selectRow(1, inComponent: 0, animated: false)

        importancePicker = rotatePickerView(importancePicker);
        importancePicker.selectRow(1, inComponent: 0, animated: false);
        pickerView(importancePicker, didSelectRow: 1, inComponent: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func fashionViews(){
        
        for view in stackView.subviews{
            view.layer.borderWidth = 2;
            view.layer.cornerRadius = 20;
            view.layer.borderColor = UIColor.lightGray.cgColor;
        }
        bottomView.layer.borderWidth = 2;
        bottomView.layer.cornerRadius = 20;
        bottomView.layer.borderColor = UIColor.lightGray.cgColor;
        
        descritionTextView.layer.cornerRadius = 20;
    }
    
    
    func rotatePickerView(_ pickerView :UIPickerView) -> UIPickerView {
        
        pickerView.transform = CGAffineTransform(rotationAngle: rotationAngle)
        //        print(timePicker.superview!.frame.width/2)
        pickerView.frame = CGRect(x: 0, y: 0, width: pickerView.superview!.bounds.width , height: pickerView.superview!.frame.height)
        return pickerView;
    }
}


extension AddTaskViewController:UIPickerViewDataSource, UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
            case importancePicker:
                return importanceData.count
            case timePicker:
                return timeData.count;
            case categoryPicker:
                return categoryData.count;
            default:
                return 1;
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case importancePicker:
            print("Helo")
            importanceView.layer.borderColor = UIColor.init(hexString: importanceBorderColor[row])?.cgColor;
        case timePicker:
            print("timePicker selected");
        default:
            print("asdf")
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard pickerView == categoryPicker else { return nil }
        return categoryData[row];
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let view = UIView()
        let height = pickerView.frame.height;
        let width = pickerView.frame.width;
        
        if(pickerView == categoryPicker) {
            view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        }else{
            view.frame = CGRect(x: 0, y: 0, width: height, height:width);
            view.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))
        }
        
        let label = UILabel(frame: view.frame);
        label.textColor = .black
        label.textAlignment = .center
        view.addSubview(label)
        
        switch pickerView {
            case importancePicker:
                label.text = importanceData[row]
            case timePicker:
                label.text = timeData[row]
            case categoryPicker:
                label.text = categoryData[row]
            default:
                label.text = "No data"
        }

        return view

    }
    
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        if(pickerView == categoryPicker){
            return pickerView.superview!.frame.height * 0.6
        }
        return pickerView.superview!.frame.width * 0.3
    }
    
}


extension UIColor {
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat

        if hexString.hasPrefix("#") {
            
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString[start...])
            var hexNumber: UInt64 = 0
            guard Scanner(string: hexColor).scanHexInt64(&hexNumber) else { return nil; }
            
            if hexColor.count == 8 {
                
                r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                a = CGFloat(hexNumber & 0x000000ff) / 255
                self.init(red: r, green: g, blue: b, alpha: a)
                return
                
            } else if hexColor.count == 6 {
                
                r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                b = CGFloat(hexNumber & 0x0000ff) / 255
                self.init(red: r, green: g, blue: b,alpha: 1.0);
                return
                
            }
        }

        return nil
    }
}
