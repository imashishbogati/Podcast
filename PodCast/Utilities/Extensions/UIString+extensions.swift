//
//  UIString+extensions.swift
//  PodCast
//
//  Created by Ashish Bogati on 15/12/2022.
//

import Foundation

extension String {
    func toSecureHTTPS() -> String {
        return self.contains("https") ? self : self.replacingOccurrences(of: "http", with: "https")
    }
    
    func toPlainText() -> String {
        do {
            let attributedString = try NSAttributedString(data: self.data(using: .utf8)!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            return attributedString.string
        } catch let error {
            debugPrint(error)
        }
        
        return ""
    }
    
}
