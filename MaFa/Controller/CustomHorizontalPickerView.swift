//
//  CustomHorizontalPickerView.swift
//  MaFa
//
//  Created by Sundet Mukhtar on 03.06.2024.
//

import UIKit

class CustomHorizontalPickerView{

    static func getPickerView(_ pickerView :UIPickerView) -> UIPickerView {
        let rotationAngle: CGFloat! = -90  * (.pi/180)
        
        
        pickerView.transform = CGAffineTransform(rotationAngle: rotationAngle)
        //        print(timePicker.superview!.frame.width/2)
        pickerView.frame = CGRect(x: 0, y: 0, width: pickerView.superview!.bounds.width , height: pickerView.superview!.frame.height)
        return pickerView;
    }
    
}
