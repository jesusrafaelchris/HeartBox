//
//  Extensions.swift
//  BoxSwift
//
//  Created by Christian Grinling on 19/01/2022.
//

import Foundation
import UIKit
import AVFoundation

extension UIView {
    
    func pinEdgesToSuperView() {
        guard let superView = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        leftAnchor.constraint(equalTo: superView.leftAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        rightAnchor.constraint(equalTo: superView.rightAnchor).isActive = true
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, paddingTop: CGFloat, bottom: NSLayoutYAxisAnchor?, paddingBottom: CGFloat, left: NSLayoutXAxisAnchor?, paddingLeft: CGFloat, right: NSLayoutXAxisAnchor?, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
    translatesAutoresizingMaskIntoConstraints = false
        
    if let top = top {
    topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
    if let bottom = bottom {
    bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
    if let right = right {
    rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
    if let left = left {
    leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
    if width != 0 {
    widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
    if height != 0 {
    heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func SFSymbolFont(button: UIButton, symbol: String, size: CGFloat, colour: UIColor) {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: size, weight: .bold, scale: .large)
        let largeBoldDoc = UIImage(systemName: symbol, withConfiguration: largeConfig)?.withTintColor(colour).withRenderingMode(.alwaysOriginal)
        button.setImage(largeBoldDoc, for: .normal)
    }
}

extension UILabel {
    func layout(colour:UIColor, size: CGFloat, text: String, bold: Bool) {
        self.text = text
        self.textColor = colour
        if bold == true {
            self.font = UIFont.boldSystemFont(ofSize: size)
        }
        
        else {
            self.font = UIFont.systemFont(ofSize: size)
        }
        
    }
}


extension UIStackView {
    
    func layout(axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution, alignment: UIStackView.Alignment, spacing: Int){
        self.axis = axis
        self.distribution = distribution
        self.alignment = alignment
        self.spacing = 10
    }

}

extension UIImageView {
    func setsizedImage(symbol: String, size: CGFloat, colour: UIColor, weight: UIImage.SymbolWeight,scale: UIImage.SymbolScale) {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: size, weight: weight, scale: scale)
        let largeBoldDoc = UIImage(systemName: symbol, withConfiguration: largeConfig)?.withTintColor(colour).withRenderingMode(.alwaysOriginal)
        self.image = largeBoldDoc
    }
    
}

extension UIButton {
    
    func centerTextAndImage(spacing: CGFloat) {
        let insetAmount = spacing / 2
        let isRTL = UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .rightToLeft
        if isRTL {
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
            self.contentEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: -insetAmount)
        } else {
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
            self.contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
        }
    }
    
    
    func setsizedImage(symbol: String, size: CGFloat, colour: UIColor) {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: size, weight: .bold, scale: .large)
        let largeBoldDoc = UIImage(systemName: symbol, withConfiguration: largeConfig)?.withTintColor(colour).withRenderingMode(.alwaysOriginal)
        self.setImage(largeBoldDoc, for: .normal)
    }
    
    
    func layout(textcolour:UIColor?, backgroundColour:UIColor?, size: CGFloat?, text: String?, image: UIImage?, cornerRadius: CGFloat?) {
        setTitle(text, for: .normal)
        setTitleColor(textcolour, for: .normal)
        if let Size = size {
            titleLabel?.font = UIFont.boldSystemFont(ofSize: Size)
        }

        setImage(image, for: .normal)
        if let radius = cornerRadius {
        layer.cornerRadius = radius
        }
        layer.masksToBounds = true
        backgroundColor = backgroundColour
    
    }
    
    func setHighlighted() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        backgroundColor = .white
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 0.38, green: 0.11, blue: 0.81, alpha: 1.00).cgColor
        setTitleColor(.black, for: .normal)
    }
    
    func setNormal() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        backgroundColor = UIColor(red: 0.38, green: 0.11, blue: 0.81, alpha: 1.00)
        layer.borderWidth = 0
        layer.borderColor = nil
        setTitleColor(.white, for: .normal)
    }
}

extension UIViewController {
    
    func AlertofError(_ error:String, _ Message:String){
        let alertController = UIAlertController(title: "\(error)", message: "\(Message)", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func Alert(_ field:String){
       let alertController = UIAlertController(title: "\(field) Needed", message: "Please type in \(field)", preferredStyle: .alert)
       let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
       alertController.addAction(defaultAction)
       self.present(alertController, animated: true, completion: nil)
    }
}

extension UILabel {
  func setTextSpacingBy(value: Double) {
    if let textString = self.text {
      let attributedString = NSMutableAttributedString(string: textString)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: value, range: NSRange(location: 0, length: attributedString.length - 1))
      attributedText = attributedString
    }
  }
}

extension String {

    public func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect,
                                        options: .usesLineFragmentOrigin,
                                        attributes: [.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}

extension UITextView {
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
    
//    func centerHorizontally() {
//        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
//        let size = sizeThatFits(fittingSize)
//        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
//        let positiveTopOffset = max(1, topOffset)
//        contentOffset.y = -positiveTopOffset
//    }
}



extension UITextField {
    
    func addImage(image:String,size: CGFloat,colour: UIColor,weight: UIImage.SymbolWeight,scale: UIImage.SymbolScale, padding: Int) {
        let imageView = UIImageView(frame: CGRect(x: 8.0, y: 8.0, width: 24.0, height: 24.0))
        imageView.setsizedImage(symbol: image, size: size, colour: colour, weight: weight, scale: scale)
        imageView.contentMode = .scaleAspectFit

        let view = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: 40))
        view.addSubview(imageView)
        self.leftViewMode = UITextField.ViewMode.always
        self.leftView = view
    }
    
    func addBottomBorder(colour: CGColor){
         let bottomLine = CALayer()
         bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
         bottomLine.backgroundColor = colour
         borderStyle = .none
         layer.addSublayer(bottomLine)
     }

    func addPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = UITextField.ViewMode.always
    }
    
    func layout(placeholder: String, backgroundcolour: UIColor, bordercolour: UIColor,borderWidth: CGFloat, cornerRadius: CGFloat) {
        self.placeholder = placeholder
        self.backgroundColor = backgroundcolour
        layer.borderColor = bordercolour.cgColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }
}

var vSpinner : UIView?
extension UIViewController {
    
    
    func getTodaysDate() -> String {
        let date = Date()
        let dateFormatter  = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        return dateFormatter.string(from: date)
    }
    
    func getTodaysDateforbooking() -> String {
        let date = Date()
        let dateFormatter  = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    func getDayName() -> String {
            let df  = DateFormatter()
            df.dateFormat = "YYYY-MM-dd"
            let date = df.date(from: getTodaysDate())!
            df.dateFormat = "EEE"
            return df.string(from: date)
        }
    
    func getDate() -> String{
        let formatter : DateFormatter = DateFormatter()
         formatter.dateFormat = "d/M/yy"
         let myStr : String = formatter.string(from:   NSDate.init(timeIntervalSinceNow: 0) as Date)
        return myStr
    }
    
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }

}


extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}


class darkblackbutton: UIButton {

        static func textstring(text: String) -> darkblackbutton {
            let button = darkblackbutton()
            button.layout(textcolour: .white, backgroundColour: UIColor(hexString: "222222"), size: 16, text: text, image: nil, cornerRadius: 15)
            return button
        }
}

class SelfSizedCollectionView: UICollectionView {
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }

    override var intrinsicContentSize: CGSize {
        let s = self.collectionViewLayout.collectionViewContentSize
        return CGSize(width: max(s.width, 1), height: max(s.height,1))
    }

}

extension String {
    func widthWithConstrainedHeight(_ height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)

        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return boundingBox.width
    }
}

extension Sequence {
    func groupSort(ascending: Bool = true, byDate dateKey: (Iterator.Element) -> Date) -> [[Iterator.Element]] {
        var categories: [[Iterator.Element]] = []
        for element in self {
            let key = dateKey(element)
            guard let dayIndex = categories.firstIndex(where: { $0.contains(where: { Calendar.current.isDate(dateKey($0), inSameDayAs: key) }) }) else {
                guard let nextIndex = categories.firstIndex(where: { $0.contains(where: { dateKey($0).compare(key) == (ascending ? .orderedDescending : .orderedAscending) }) }) else {
                    categories.append([element])
                    continue
                }
                categories.insert([element], at: nextIndex)
                continue
            }

            guard let nextIndex = categories[dayIndex].firstIndex(where: { dateKey($0).compare(key) == (ascending ? .orderedDescending : .orderedAscending) }) else {
                categories[dayIndex].append(element)
                continue
            }
            categories[dayIndex].insert(element, at: nextIndex)
        }
        return categories
    }
}
