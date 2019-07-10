//
//  UIImagePicker.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 7/10/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit

public protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?)
}

open class ImagePicker: NSObject {
    
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    
    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        super.init()
        
        self.delegate = delegate
        self.presentationController = presentationController
        
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default, handler: { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        })
    }
    
    public func present() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let action = self.action(for: .camera, title: "Tomar una foto"){
            alertController.addAction(action)
        }
        if let action = self.action(for: .savedPhotosAlbum, title: "Rollo fotografico") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Librería de Fotografías") {
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        self.presentationController?.present(alertController, animated: true)
        
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        
        self.delegate?.didSelect(image: image)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: image)
    }
    
}

extension ImagePicker: UINavigationControllerDelegate {
    
}
