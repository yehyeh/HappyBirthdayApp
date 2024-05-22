//
//  UIImage_Ex.swift
//  HappyBirthdayApp
//
//  Created by Yehonatan Yehudai on 22/05/2024.
//

import UIKit

extension UIImage {
    func toData() -> Data? {
        pngData() ?? jpegData(compressionQuality: 1.0)
    }
    
    func fileSize() -> String {
        guard let imageData = self.toData() else { return "Unknown" }
        let size = Double(imageData.count) // in bytes
        if size < 1024 {
            return String(format: "%.2f bytes", size)
        } else if size < 1024 * 1024 {
            return String(format: "%.2f KB", size/1024.0)
        } else {
            return String(format: "%.2f MB", size/(1024.0*1024.0))
        }
    }

    func fileType() -> String {
        guard let data = self.toData(), data.count > 8 else { return "Unknown" }

        var header = [UInt8](repeating: 0, count: 8)
        data.copyBytes(to: &header, count: 8)

        switch header {
            case [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]: // PNG: 89 50 4E 47 0D 0A 1A 0A
                return "png"
            case [0xFF, 0xD8, 0xFF]: // JPEG: FF D8 FF
                return "jpg"
            default:
                return "unknown"
        }
    }
}
