//
//  AddTaskViewController.swift
//  MaFa
//
//  Created by Sundet Mukhtar on 29.05.2024.
//

import UIKit
import RealmSwift

class AddTaskViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var timePicker: UIPickerView!
    @IBOutlet weak var importancePicker: UIPickerView!
    @IBOutlet var categoryLabel: UITextField!
    
    @IBOutlet var descriptionTextView: UITextView! {
        didSet{
            descriptionTextView.text = K.Task.descriptionPlaceholderText;
            descriptionTextView.textColor = UIColor.lightGray
        }
    }
    @IBOutlet weak var importanceView: UIView!
    
    var rotationAngle: CGFloat! = -90  * (.pi/180)
    
    var timeData = K.Task.times;
    let categoryData = K.Task.basicCategories;
    let importanceData = K.Task.importance;
    let importanceBorderColor = K.Task.importanceBorderColor;
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fashionViews();
        timePicker.delegate = self;
        timePicker.dataSource = self;
        importancePicker.delegate = self;
        importancePicker.dataSource = self;
        categoryPicker.delegate = self;
        importancePicker.dataSource = self;
        descriptionTextView.delegate = self;
        categoryLabel.delegate = self
    

//        timePicker.transform = CGAffineTransform(rotationAngle: rotationAngle)
//        print(timePicker.superview!.frame.width/2)
//        timePicker.frame = CGRect(x: timePicker.superview!.frame.width/2.0 * (-1), y: 0, width: timePicker.superview!.bounds.width * 2, height: timePicker.superview!.frame.height)
    
        timePicker = rotatePickerView(timePicker);
        timePicker.selectRow(1, inComponent: 0, animated: false)

        importancePicker = rotatePickerView(importancePicker);
        importancePicker.selectRow(1, inComponent: 0, animated: false);
        pickerView(importancePicker, didSelectRow: 1, inComponent: 0)
    }
    
    
    @IBAction func saveTaskPressed(_ sender: Any) {
        var task = Task.init();
        
        let selectedCategory = categoryData[categoryPicker.selectedRow(inComponent: 0)];
        let selectedTime = timeData[timePicker.selectedRow(inComponent: 0)];
        //revise. Unnessecerily complex logic?
        let selectedImportance = Importance(rawValue: importancePicker.selectedRow(inComponent: 0))?.rawValue ?? 1;
        let title = (categoryLabel.text == nil || categoryLabel.text!.count <= 0)  ? selectedCategory : categoryLabel.text;
        let descriptionText = descriptionTextView.text == K.Task.descriptionPlaceholderText ? "" : descriptionTextView.text!;
        
        task.title = title!;
        task.time = selectedTime
        task.importance = selectedImportance
        task.descrip = descriptionText;
        let t = Date().timeIntervalSince1970
        task.startTime = t;
        task.endTime = t + Double(selectedTime * 60 * 60);
        //print(task.startTime)
        //print(task.endTime)
        
        do{
            let realm = try Realm()
            try realm.write {
                realm.add(task)
            }
            navigationController?.popViewController(animated: true);
        }catch{
            print("saving problem: \(error.localizedDescription)")
        }
        
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
        
        descriptionTextView.layer.cornerRadius = 20;
    }
    
    
    func rotatePickerView(_ pickerView :UIPickerView) -> UIPickerView {
        
        pickerView.transform = CGAffineTransform(rotationAngle: rotationAngle)
        pickerView.frame = CGRect(x: 0, y: 0, width: pickerView.superview!.bounds.width , height: pickerView.superview!.frame.height)
        return pickerView;
    }
    
    
}


// MARK: - Picker Views' data source and delegete.
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
            //label.text = importanceData[row]
            label.text = Importance(rawValue: row)?.description ?? "";
        case timePicker:
            label.text = String(timeData[row])
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


// MARK: - Text delegates to limite the lenght of the input
extension AddTaskViewController:UITextViewDelegate,UITextFieldDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil;
            textView.textColor = .black;
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty{
            textView.text = "Describe what should be done with 255 symbols"
            textView.textColor = .lightGray;
        }
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        return updatedText.count <= 255
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? "";
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count < 16;
    }
    
    
    
}


// MARK: - UIColor convenience init(hexString: String)
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
