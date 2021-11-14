//
//  UIImage+Extension.swift
//  Studian
//
//  Created by 이한규 on 2021/11/02.
//

import UIKit
//사진등록시 90도 회전되는 사항 방지.
extension UIImage {
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImage.Orientation.up {
    return self
    }
    UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x:0, y:0, width:self.size.width, height:self.size.height))
        let normalizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return normalizedImage;
    }
}
extension UIImage {
       // image with rounded corners
       public func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
           let maxRadius = min(size.width, size.height) / 2
           let cornerRadius: CGFloat
           if let radius = radius, radius > 0 && radius <= maxRadius {
               cornerRadius = radius
           } else {
               cornerRadius = maxRadius
           }
           UIGraphicsBeginImageContextWithOptions(size, false, scale)
           let rect = CGRect(origin: .zero, size: size)
           UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
           draw(in: rect)
           let image = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()
           return image
       }
   }
