//
//  ShareableImage.swift
//  HappyBirthdayApp
//
//  Created by Yehonatan Yehudai on 22/05/2024.
//

import UIKit
import LinkPresentation

final class ShareableImage: NSObject, UIActivityItemSource {
    private let image: UIImage
    private let title: String

    init(image: UIImage, title: String) {
        self.image = image
        self.title = title
        super.init()
    }

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return image
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return image
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.iconProvider = NSItemProvider(object: image)

        metadata.title = title
        let size = image.fileSize()
        let type = image.fileType()
        let subtitleString = "\(type.uppercased()) File · \(size)"
        metadata.originalURL = URL(fileURLWithPath: subtitleString)

        return metadata
    }

}
