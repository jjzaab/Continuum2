//
//  AddPostTableViewController.swift
//  Continuum
//
//  Created by XMS_JZhan on 2/26/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class AddPostTableViewController: UITableViewController {
    
    // MARK: - IBOutlets
    //@IBOutlet weak var selectImageButton: UIButton!
    //@IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    
    // MARK: - Landing pad
    var post: Post?
    var selectedImage: UIImage?
    let controller = UIImagePickerController()
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //selectImageButton.titleLabel?.text = "Select Image"
        //photoImageView.image = nil
        //commentTextField.text = ""
    }
    
    // MARK: - IBActions
    @IBAction func selectImageButtonTapped(_ sender: UIButton) {
        //        selectImageButton.titleLabel?.text = ""
        //
        //        let alert = UIAlertController(title: "Add Image", message: "Please select image source", preferredStyle: .actionSheet)
        //        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
        //            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
        //                let controller = UIImagePickerController()
        //                controller.delegate = self
        //                controller.mediaTypes = (UIImagePickerController.availableMediaTypes(for: .photoLibrary) ?? nil) ?? []
        //                self.present(controller, animated: true, completion: {
        //
        //                })
        //            }
        //        }
        //        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
        //            if UIImagePickerController.isSourceTypeAvailable(.camera) {
        //                let controller = UIImagePickerController()
        //                controller.delegate = self
        //                let images = (UIImagePickerController.availableMediaTypes(for: .camera) ?? nil) ?? []
        //                controller.mediaTypes = [images.first] as! [String]
        //                controller.sourceType = UIImagePickerController.SourceType.camera
        //                controller.takePicture()
        //                self.present(controller, animated: true, completion: {
        //
        //                })
        //            }
        //        }
        //        alert.addAction(photoLibraryAction)
        //        alert.addAction(cameraAction)
        //        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addPostButtonTapped(_ sender: UIButton) {
        guard let image =  selectedImage, let caption = commentTextField.text, caption != "" else { return }
        PostController.shared.createPostWith(image: image, caption: caption) { (post) in

        }
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        self.tabBarController?.selectedIndex = 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoSelectorSegue" {
            if let destinationVC = segue.destination as? PhotoSelectorViewController {
                destinationVC.delegate = self as? PhotoSelectorViewControllerDelegate
            }
        }
        
    }
}

// MARK: - Extension to conform to UIImagePickerControllerDelegate
//extension AddPostTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        DispatchQueue.main.async {
//            self.photoImageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
//        }
//        dismiss(animated: true, completion: nil)
//    }
//}

extension AddPostTableViewController: PhotoSelectorViewControllerDelegate {
    func photoSelectorViewControllerSelected(image: UIImage) {
        self.selectedImage = image
//        guard let caption = commentTextField.text, caption != "" else { return }
//
//        PostController.shared.createPostWith(image: image, caption: caption) { (post) in
//
//        }
    }
    
    
}
