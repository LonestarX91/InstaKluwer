//
//  Utils.swift
//  InstaKluwer
//
//  Created by Daniel on 08.11.2022.
//

import UIKit

class Utils: NSObject {

    func formattedDate(from str: String) -> String? {
        guard let date = ISO8601DateFormatter().date(from: str) else { return nil }
        let toFormatter = DateFormatter()
        toFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        return toFormatter.string(from: date)
    }
}

extension UIView {
    func snapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}

