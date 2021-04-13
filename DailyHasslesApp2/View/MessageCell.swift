//
//  MessageCell.swift
//  DailyHasslesApp2
//
//  Created by 山本英明 on 2021/04/13.
//

import UIKit

class MessageCell: UITableViewCell {

    
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //角を丸にする
        rightImageView.layer.cornerRadius = 25
        leftImageView.layer.cornerRadius = 25
        backView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
