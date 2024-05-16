//
//  Extensions.swift
//  KinopoiskListApp
//
//  Created by Флоранс on 20.03.2024.
//
import UIKit

extension Date {
    /// Getting Current Year
    func formatString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        return formatter.string(from: self)
    }
}

extension UITableView {
    ///Adjust Height of Table HeaderView
    func updateHeaderViewHeight() {
        if let header = self.tableHeaderView {
            let newSize = header.systemLayoutSizeFitting(CGSize(width: self.bounds.width, height: 0))
            header.frame.size.height = newSize.height + 3
        }
    }
}

extension UILabel {
    var maxNumberOfLines: Int {
        let lineHeight = font.lineHeight
        return Int(ceil(self.textHeight / lineHeight))
    }
    
    var textHeight: CGFloat {
        let maxSize = CGSize(
            width: (superview?.bounds.width ?? UIScreen.main.bounds.width) - 20,
            height: CGFloat(MAXFLOAT)
        )
        let text = (self.text ?? "") as NSString
        let textHeight = text.boundingRect(
            with: maxSize,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        ).height
        return textHeight
    }
}

extension Int {
     func years() -> String {
         var dayString: String!
         if "1".contains("\(self % 10)")      {dayString = "лет"}
         if "234".contains("\(self % 10)")    {dayString = "года" }
         if "567890".contains("\(self % 10)") {dayString = "лет"}
         if 11...14 ~= self % 100                   {dayString = "лет"}
         return "\(self) " + dayString
    }
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String { html2AttributedString?.string ?? "" }
}

extension StringProtocol {
    var html2AttributedString: NSAttributedString? {
        Data(utf8).html2AttributedString
    }
    var html2String: String {
        html2AttributedString?.string ?? ""
    }
}
