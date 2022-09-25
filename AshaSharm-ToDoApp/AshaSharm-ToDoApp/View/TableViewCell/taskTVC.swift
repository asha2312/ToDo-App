//
//  taskTVC.swift
//  AshaSharm-ToDoApp
//
//  Created by Asha on 24/09/22.
//

import UIKit

class taskTVC: UITableViewCell {

    @IBOutlet weak var lblTodoName: UILabel!
    @IBOutlet weak var imgRightArrow: UIImageView!
    @IBOutlet weak var lblTodoDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        roundImage(img: imgRightArrow)
        imgRightArrow.layer.borderColor = UIColor.brown.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
