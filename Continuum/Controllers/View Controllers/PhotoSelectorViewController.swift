//
//  PhotoSelectorViewController.swift
//  Continuum
//
//  Created by XMS_JZhan on 2/27/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class PhotoSelectorViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var selectImageButton: UIButton!
    
    // MARK: - Properties
    weak var delegate: PhotoSelectorViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - IBAction
    @IBAction func selectImageButtonTapped(_ sender: UIButton) {
        selectImageButton.titleLabel?.text = ""
        
        let alert = UIAlertController(title: "Add Image", message: "Please select image source", preferredStyle: .actionSheet)
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let controller = UIImagePickerController()
                controller.delegate = self
                controller.mediaTypes = (UIImagePickerController.availableMediaTypes(for: .photoLibrary) ?? nil) ?? []
                self.present(controller, animated: true, completion: {
                    
                })
            }
        }
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let controller = UIImagePickerController()
                controller.delegate = self
                let images = (UIImagePickerController.availableMediaTypes(for: .camera) ?? nil) ?? []
                controller.mediaTypes = [images.first] as! [String]
                controller.sourceType = UIImagePickerController.SourceType.camera
                controller.takePicture()
                self.present(controller, animated: true, completion: {
                    
                })
            }
        }
        alert.addAction(photoLibraryAction)
        alert.addAction(cameraAction)
        present(alert, animated: true, completion: nil)
    }

}

// MARK: - Extension to conform to UIImagePickerControllerDelegate
extension PhotoSelectorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        DispatchQueue.main.async {
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            
            self.photoImageView.image = image
            self.delegate?.photoSelectorViewControllerSelected(image: image)
        }
        dismiss(animated: true, completion: nil)
    }
}

protocol PhotoSelectorViewControllerDelegate: class {
    func photoSelectorViewControllerSelected(image: UIImage)
}
