//
//  AppExtensions.swift
//  AshaSharm-ToDoApp
//
//  Created by Asha on 24/09/22.
//

import Foundation
import UIKit

extension UITableView {
    func setNoDataPlaceholder(_ message: String) {
        let label = UILabel(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        label.text = message
        label.sizeToFit()
        self.isScrollEnabled = false
        self.backgroundView = label
        self.separatorStyle = .none
    }
}
