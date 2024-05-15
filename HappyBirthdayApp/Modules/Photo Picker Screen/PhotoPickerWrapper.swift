//
//  PhotoPickerWrapper.swift
//  HappyBirthdayApp
//
//  Created by Yehonatan Yehudai on 15/05/2024.
//

import Foundation
import PhotosUI


class AvatarImagePicker: NSObject {
    weak var navigationDelegate: UINavigationControllerDelegate? = nil
    private weak var imagePickerDelegate: UIImagePickerControllerDelegate? = nil

    func makeUIViewController(sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {

        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self

        return imagePicker
    }
}
extension AvatarImagePicker: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
}
