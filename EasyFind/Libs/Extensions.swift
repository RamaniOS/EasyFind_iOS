//
//  Extensions.swift
//  C0761706_MidTerm_MAD3115F2019
//
//  Created by Ramanpreet Singh on 2019-10-31.
//  Copyright © 2019 Ramanpreet Singh. All rights reserved.
//

import UIKit

extension UITextField {
    
    var hasText: Bool {
        return text!.trimmingCharacters(in: .whitespacesAndNewlines).count > 0
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: text)
    }
    
    func setLeftPading(_ size: CGFloat) {
        leftViewMode = .always
        let leftPadView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: bounds.size.height))
        leftPadView.backgroundColor = .clear
        leftView = leftPadView
    }
    
    func setBottomLine() {
        borderStyle = .none
        layer.backgroundColor = UIColor.white.cgColor
        layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 0.0
    }
}

extension UIAlertController {
    
    // Shows alert view with completion block
    class func alert(_ title: String, message: String, buttons: [String], completion: ((_ : UIAlertController, _ : Int) -> Void)?) -> UIAlertController {
        let alertView: UIAlertController? = self.init(title: title, message: message, preferredStyle: .alert)
        for i in 0..<buttons.count {
            alertView?.addAction(UIAlertAction(title: buttons[i], style: .default, handler: {(_ action: UIAlertAction) -> Void in
                if completion != nil {
                    completion!(alertView!, i)
                }
            }))
        }
        // Add all other buttons
        return alertView!
    }
}

extension UIStoryboard {

    class var main: UIStoryboard {
        let storyboardName: String = (Bundle.main.object(forInfoDictionaryKey: "UIMainStoryboardFile") as? String)!
        return UIStoryboard(name: storyboardName, bundle: nil)
    }
}

/*
 Extension for Int
*/
extension Int {
    
    var billWithGB: String {
        return "\(self) GB"
    }
    
    var billWithMinutes: String {
        return "\(self) Minutes"
    }
    
    var billWithUnits: String {
        return "\(self) Units"
    }
}

/*
 Extension for String
 */
extension String {
    
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    var isValidNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == count && count == 10
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    func toDate(withFormat format: String = "yyyy-MM-dd") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: self) else {
            preconditionFailure("Take a look to your format")
        }
        return date
    }
}

/*
 Extension for Float
 */
extension Float {
    
    var billWithDollar: String {
        return String(format: "$%.2f", self)
    }
    
    private static var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        return numberFormatter
    }()
    
    var delimiter: String {
        return Float.numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}

/*
 Extension for Date
 */
extension Date {
    
    func toString(withFormat format: String = "EEEE, dd MMMM, YYYY") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    static func dateDifference(startDate: String, endDate: String) -> String {
        let start = startDate.toDate()
        let end = endDate.toDate()
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.month]
        formatter.unitsStyle = .full
        if let differenceString = formatter.string(from: start, to: end) {
            return differenceString
        }
        return "No Date Found"
    }
}

extension UIView {
    /** Loads instance from nib with the same name. */
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func actionBlock(_ closure: @escaping() -> ()) {
        let sleeve = ClosureSleeve(closure)
        let recognizer = UITapGestureRecognizer(target: sleeve, action: #selector(ClosureSleeve.invoke))
        addGestureRecognizer(recognizer)
        isUserInteractionEnabled = true
        
        objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}

extension UIScreen {
    
    class var mainBounds: CGRect {
        return main.bounds
    }
    
    class var mainSize: CGSize {
        return mainBounds.size
    }
}

class ClosureSleeve {
    let closure: ()->()
    
    init (_ closure: @escaping ()->()) {
        self.closure = closure
    }
    
    @objc func invoke () {
        closure()
    }
}
