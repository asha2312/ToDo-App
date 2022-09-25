//
//  AppFunctions.swift
//  AshaSharm-ToDoApp
//
//  Created by Asha on 24/09/22.
//

import Foundation
import UIKit
import AVFoundation

func checkTextValue(_ txtField : UITextField) -> Bool {
    return txtField.text?.replacingOccurrences(of: " ", with: "") == ""
}
func showAlert(withTitle title: String, message: String, viewcontroller : UIViewController) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    viewcontroller.present(alert, animated: true)
}
func compareDate(_ firstDate: Date, _ secondDate: Date, event : String) -> Bool {
   let formatter = DateFormatter()
   formatter.dateStyle = .full
   formatter.timeStyle = .none
   formatter.timeZone = .none
    if event == "Upcoming"{
        return firstDate < secondDate
    }else {
        return formatter.string(from: firstDate)
            == formatter.string(from: secondDate)
    }
}
func ButtonUI(button: UIButton)
{
    button.layer.cornerRadius = 20
}
func roundButton(button : UIButton)
{
    button.layer.cornerRadius = button.frame.size.height/2
    button.layer.borderWidth = 1.0
    button.layer.borderColor = UIColor.white.cgColor
    button.setTitleColor(.white, for: .normal)
}
func roundImage(img : UIImageView)
{
    img.layer.cornerRadius = img.frame.size.height/2
    img.layer.borderWidth = 1.0
    img.layer.borderColor = UIColor.white.cgColor
}
func getDate()->(today : Date,tomorrow : Date,upComing : Date)
{
    var calendar = Calendar.current
    //calendar.timeZone = TimeZone(abbreviation: "UTC")!
    let today = Date()
    let midnight = calendar.startOfDay(for: today)
    let tomorrow = calendar.date(byAdding: .day, value: 1, to: midnight)!
    let upcoming = calendar.date(byAdding: .day, value: 2, to: midnight)!
    return (today,tomorrow,upcoming)
}
