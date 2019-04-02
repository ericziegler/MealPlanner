//
//  MealPlannerUI.swift
//  MealPlanner
//
//  Created by Eric Ziegler on 3/17/19.
//  Copyright © 2019 zigabytes. All rights reserved.
//

import UIKit

// MARK: Global Properties

func applyApplicationAppearanceProperties() {
    UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : UIFont.applicationFontOfSize(17)], for: .normal)
    UINavigationBar.appearance().tintColor = UIColor.white
    UINavigationBar.appearance().barTintColor = UIColor.main
}

func navTitleTextAttributes() -> [NSAttributedString.Key : Any] {
    return [NSAttributedString.Key.font : UIFont.applicationBoldFontOfSize(21.0), .foregroundColor : UIColor.navAccent]
}

// MARK: - UIImage

extension UIImage {
    
    func maskedImageWithColor(_ color: UIColor) -> UIImage? {
        var result: UIImage?
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        if let context: CGContext = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage {
            let rect: CGRect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
            
            // flip coordinate system or else CGContextClipToMask will appear upside down
            context.translateBy(x: 0, y: rect.size.height);
            context.scaleBy(x: 1.0, y: -1.0);
            
            // mask and fill
            context.setFillColor(color.cgColor)
            context.clip(to: rect, mask: cgImage);
            context.fill(rect)
            
        }
        
        result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
}

// MARK: - UILabel

class ApplicationStyleLabel : UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.preInit();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.preInit()
    }
    
    func preInit() {
        if let text = self.text, text.hasPrefix("^") {
            self.text = nil
        }
        self.commonInit()
    }
    
    func commonInit() {
        if type(of: self) === ApplicationStyleLabel.self {
            fatalError("ApplicationStyleLabel not meant to be used directly. Use its subclasses.")
        }
    }
}

class RegularLabel: ApplicationStyleLabel {
    override func commonInit() {
        self.font = UIFont.applicationFontOfSize(self.font.pointSize)
    }
}

class BoldLabel: ApplicationStyleLabel {
    override func commonInit() {
        self.font = UIFont.applicationBoldFontOfSize(self.font.pointSize)
    }
}

class LightLabel: ApplicationStyleLabel {
    override func commonInit() {
        self.font = UIFont.applicationLightFontOfSize(self.font.pointSize)
    }
}

// MARK: - UIButton

class ApplicationStyleButton : UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit() {
        if type(of: self) === ApplicationStyleButton.self {
            fatalError("ApplicationStyleButton not meant to be used directly. Use its subclasses.")
        }
    }
}

class RegularButton: ApplicationStyleButton {
    override func commonInit() {
        if let font = self.titleLabel?.font {
            self.titleLabel?.font = UIFont.applicationFontOfSize(font.pointSize)
        }
    }
}

class BoldButton: ApplicationStyleButton {
    override func commonInit() {
        if let font = self.titleLabel?.font {
            self.titleLabel?.font = UIFont.applicationBoldFontOfSize(font.pointSize)
        }
    }
}

class LightButton: ApplicationStyleButton {
    override func commonInit() {
        if let font = self.titleLabel?.font {
            self.titleLabel?.font = UIFont.applicationLightFontOfSize(font.pointSize)
        }
    }
}

extension UIFont {
    
    class func applicationFontOfSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue", size: size)!
    }
    
    class func applicationBoldFontOfSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Bold", size: size)!
    }
    
    class func applicationLightFontOfSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Light", size: size)!
    }
    
    class func debugListFonts() {
        UIFont.familyNames.forEach({ familyName in
            let fontNames = UIFont.fontNames(forFamilyName: familyName)
            print(familyName, fontNames)
        })
    }
    
}

// MARK: - UIColor

extension UIColor {

    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hex & 0x00FF00) >> 08) / 255.0
        let b = CGFloat((hex & 0x0000FF) >> 00) / 255.0
        self.init(red:r, green:g, blue:b, alpha:alpha)
    }
    
    convenience init(integerRed red: Int, green: Int, blue: Int, alpha: Int = 255) {
        let r = CGFloat(red) / 255.0
        let g = CGFloat(green) / 255.0
        let b = CGFloat(blue) / 255.0
        let a = CGFloat(alpha) / 255.0
        self.init(red:r, green:g, blue:b, alpha:a)
    }
    
    class var main: UIColor {
        return UIColor(hex: 0x6eaf7e)
    }
    
    class var navAccent: UIColor {
        return UIColor.white
    }
    
}
