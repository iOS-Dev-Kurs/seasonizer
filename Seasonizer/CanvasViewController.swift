//
//  CanvasViewController.swift
//  Seasonizer
//
//  Created by Nils Fischer on 19.06.15.
//  Copyright (c) 2015 Nils Fischer. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    
    // MARK: Model
    
    var allAccessories: [Accessory]!

    
    // MARK: Interface Elements
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var accessoryOverlayView: UIView!
    
    
    // MARK: Accessory Handling
    
    /// Displays the accessory view on the canvas and enables user interaction with it.
    fileprivate func addAccessoryView(_ accessoryView: AccessoryView) {
        self.accessoryOverlayView.addSubview(accessoryView)
        
        // recognize gestures on accessory view:
        accessoryView.isUserInteractionEnabled = true
        // move
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        panGR.delegate = self
        accessoryView.addGestureRecognizer(panGR)
        // pinch
        let pinchGR = UIPinchGestureRecognizer(target: self, action: #selector(pinch(_:)))
        pinchGR.delegate = self
        accessoryView.addGestureRecognizer(pinchGR)
        // rotate
        let rotateGR = UIRotationGestureRecognizer(target: self, action: #selector(rotate(_:)))
        rotateGR.delegate = self
        accessoryView.addGestureRecognizer(rotateGR)
        // long press
        let tapGR = UILongPressGestureRecognizer(target: self, action: #selector(tap(_:)))
        tapGR.delegate = self
        accessoryView.addGestureRecognizer(tapGR)
    }

    
    /// The accessory views currently visible on the canvas.
    fileprivate var accessoryViews: [AccessoryView] {
        return accessoryOverlayView.subviews.flatMap({ $0 as? AccessoryView })
    }

    /// The temporary selected accessory view, e.g. from a long press gesture
    fileprivate var selectedAccessoryView: UIView?

    
    // MARK: Rendered Picture
    
    fileprivate var renderedPicture: UIImage {
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, true, 0)
        self.view.drawHierarchy(in: self.view.bounds, afterScreenUpdates: true)
        let renderedPicture = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return renderedPicture!
    }

    
    // MARK: User Interaction
    
    @IBAction func cameraButtonPressed(_ sender: AnyObject) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(UIAlertAction(title: "Kamera", style: .default, handler: { action in
                self.presentImagePickerWithSourceType(.camera)
            }))
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alertController.addAction(UIAlertAction(title: "Foto auswählen", style: .default, handler: { action in
                self.presentImagePickerWithSourceType(.photoLibrary)
            }))
        }
        alertController.addAction(UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func presentImagePickerWithSourceType(_ sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func trashButtonPressed(_ sender: AnyObject) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Bild zurücksetzen", style: .destructive, handler: { action in
            self.photoImageView.image = nil
            for accessoryView in self.accessoryViews {
                accessoryView.removeFromSuperview()
            }
        }))
        alertController.addAction(UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func actionButtonPressed(_ sender: AnyObject) {
        // obtain rendered picture
        let renderedPicture = self.renderedPicture
        // present share sheet
        let activityViewController = UIActivityViewController(activityItems: [ renderedPicture ], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "showAccessories":
            guard let accessoryListViewController = (segue.destination as? UINavigationController)?.topViewController as? AccessoryListViewController else {
                break
            }
            accessoryListViewController.accessories = allAccessories
        default:
            break
        }
    }
    
    @IBAction func unwindToCanvas(_ segue: UIStoryboardSegue) {
        switch segue.identifier! {
        case "selectedAccessory":
            guard let accessoryListViewController = segue.source as? AccessoryListViewController,
                let selectedAccessory = accessoryListViewController.selectedAccessory else {
                break
            }
            let accessoryView = AccessoryView(accessory: selectedAccessory)
            accessoryView.center = accessoryOverlayView.convert(accessoryOverlayView.center, from: accessoryOverlayView.superview)
            self.addAccessoryView(accessoryView)
        default:
            break
        }
    }

}


// MARK: State Preservation

extension CanvasViewController {
    
    override func encodeRestorableState(with coder: NSCoder) {
        if let photo = photoImageView.image {
            let imageData = UIImageJPEGRepresentation(photo, 1)
            coder.encode(imageData, forKey: "photo")
        }
        coder.encode(NSKeyedArchiver.archivedData(withRootObject: accessoryViews), forKey: "accessoryViews")
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        if let photoData = coder.decodeObject(forKey: "photo") as? Data {
            photoImageView.image = UIImage(data: photoData)
        }
        if let accessoryViewsData = coder.decodeObject(forKey: "accessoryViews") as? Data {
            let accessoryViews = NSKeyedUnarchiver.unarchiveObject(with: accessoryViewsData) as! [AccessoryView]
            accessoryViews.forEach(addAccessoryView)
        }
        super.decodeRestorableState(with: coder)
    }
    
}


// MARK: Image Picker Controller Delegate

extension CanvasViewController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.photoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}


// MARK: Gesture Interaction

extension CanvasViewController {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func pan(_ sender: UIPanGestureRecognizer) {
        if let accessoryView = sender.view {
            accessoryView.superview?.bringSubview(toFront: accessoryView)
            let translation = sender.translation(in: accessoryView.superview!)
            accessoryView.center = CGPoint(x: accessoryView.center.x + translation.x, y: accessoryView.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: accessoryView.superview!)
        }
    }

    func pinch(_ sender: UIPinchGestureRecognizer) {
        if let accessoryView = sender.view {
            accessoryView.superview?.bringSubview(toFront: accessoryView)
            accessoryView.transform = accessoryView.transform.scaledBy(x: sender.scale, y: sender.scale);
            sender.scale = 1
        }
    }

    func rotate(_ sender: UIRotationGestureRecognizer) {
        if let accessoryView = sender.view {
            accessoryView.superview?.bringSubview(toFront: accessoryView)
            accessoryView.transform = accessoryView.transform.rotated(by: sender.rotation);
            sender.rotation = 0
        }
    }

    func tap(_ sender: UILongPressGestureRecognizer) {
        if sender.state != .began {
            return
        }
        if let accessoryView = sender.view {
            self.becomeFirstResponder()
            let menuController = UIMenuController.shared
            menuController.menuItems = [ UIMenuItem(title: "Entfernen", action: #selector(removeAccessoryButtonPressed(_:))) ]
            menuController.setTargetRect(accessoryView.frame, in: accessoryView.superview!)
            menuController.setMenuVisible(true, animated: true)
            self.selectedAccessoryView = accessoryView
        }
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    func removeAccessoryButtonPressed(_ sender: AnyObject) {
        if let accessoryView = self.selectedAccessoryView {
            accessoryView.removeFromSuperview()
        }
    }
    
}

