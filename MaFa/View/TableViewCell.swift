//
//  TableViewCell.swift
//  MaFa
//
//  Created by Sundet Mukhtar on 21.05.2024.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet var topViewHeightConstriant: NSLayoutConstraint!
    @IBOutlet var parentViewMinHeight: NSLayoutConstraint!
    
    let doneImage = UIImage(systemName: "checkmark.circle");
    let notDoneImage = UIImage(systemName: "circle");
    
    
    override func awakeFromNib() {
        //layoutSubviews()
        super.awakeFromNib()
//        titleLabel.text = "Home";
//        descriptionLabel.text = "Clean the roomjhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh";
//        timeLabel.text = "14:44";
        
        doneButton.setImage(notDoneImage, for: .normal);
        doneButton.setImage(doneImage, for: .selected);
        
        parentView.layer.cornerRadius = 20;
        parentView.layer.borderWidth = 2;
        parentView.layer.borderColor = UIColor.systemYellow.cgColor;
        
        // Initialization code
    }

    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected;
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
//    }
    
}


//extension TableViewCell {
//    open override func layoutSubviews() {
//        super.layoutSubviews()
//        //contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
//        print("from viewcell \(contentView.frame.height)");
//    }
//
//}
