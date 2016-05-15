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
    
    // TODO: Setup user interface in storyboard.
    
    /// Eine `UIImageView`, die das Foto anzeigt.
    @IBOutlet weak var photoImageView: UIImageView!
    /// Eine View, die _über_ der `photoImageView` positioniert ist und die Accessories anzeigt.
    @IBOutlet weak var accessoryOverlayView: UIView!
    
    // MARK: Accessory Handling
    
    /// Displays the accessory view on the canvas and enables user interaction with it.
    private func addAccessoryView(accessoryView: AccessoryView) {
        self.accessoryOverlayView.addSubview(accessoryView)
        
        // recognize gestures on accessory view:
        accessoryView.userInteractionEnabled = true
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
    private var accessoryViews: [AccessoryView] {
        return accessoryOverlayView.subviews.flatMap({ $0 as? AccessoryView })
    }

    /// The temporary selected accessory view, e.g. from a long press gesture
    private var selectedAccessoryView: UIView?

    
    // MARK: Rendered Picture
    
    private var renderedPicture: UIImage {
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, true, 0)
        self.view.drawViewHierarchyInRect(self.view.bounds, afterScreenUpdates: true)
        let renderedPicture = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return renderedPicture
    }

    var selectedAccessory : Accessory?
    
    // MARK: User Interaction
    
    @IBAction func cameraButtonPressed(sender: AnyObject) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            alertController.addAction(UIAlertAction(title: "Kamera", style: .Default, handler: { action in
                self.presentImagePickerWithSourceType(.Camera)
            }))
        }
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            alertController.addAction(UIAlertAction(title: "Foto auswählen", style: .Default, handler: { action in
                self.presentImagePickerWithSourceType(.PhotoLibrary)
            }))
        }
        alertController.addAction(UIAlertAction(title: "Abbrechen", style: .Cancel, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func presentImagePickerWithSourceType(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func trashButtonPressed(sender: AnyObject) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        alertController.addAction(UIAlertAction(title: "Bild zurücksetzen", style: .Destructive, handler: { action in
            self.photoImageView.image = nil
            for accessoryView in self.accessoryViews {
                accessoryView.removeFromSuperview()
            }
        }))
        alertController.addAction(UIAlertAction(title: "Abbrechen", style: .Cancel, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func actionButtonPressed(sender: AnyObject) {
        // obtain rendered picture
        let renderedPicture = self.renderedPicture
        // present share sheet
        let activityViewController = UIActivityViewController(activityItems: [ renderedPicture ], applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "AccessoryView":
            guard let accessoryListViewController = (segue.destinationViewController as? UINavigationController)?.topViewController as? AccessoryListViewController else {break}
            accessoryListViewController.accessories = allAccessories
        default:
            break
        }
    }
    
    // TODO: Implement `prepareForSegue(_:sender:)` to pass `allAccessories` on to `AccessoryListViewController`.
    /*
     HINT: The `AccessoryListViewController` should be embedded in a `UINavigationController`:
     
         guard let accessoryListViewController = (segue.destinationViewController as? UINavigationController)?.topViewController as? AccessoryListViewController else {
            return
         }
    */
    
    // TODO: Implement an `@IBAction func unwindToCanvas(segue: UIStoryboardSegue)` Unwing Segue that the `AccessoryListViewController` can exit to.
    
    // TODO: For the "selectedAccessory" segue, obtain the selected accessory and add it to the canvas.
    /*
     HINTS:
     
     - The `AccessoryListViewController` is the segue's `sourceViewController`:
     
         guard let accessoryListViewController = segue.sourceViewController as? AccessoryListViewController,
                selectedAccessory = accessoryListViewController.selectedAccessory else {
            return
         }
     
     - Create an `AccessoryView` from the `selectedAccessory` and set its initial position:
     
        let accessoryView = AccessoryView(accessory: selectedAccessory)
        accessoryView.center = accessoryOverlayView.convertPoint(accessoryOverlayView.center, fromView: accessoryOverlayView.superview)

     - Finally, call the `addAccessoryView(_:)` Method implemented above:
     
        self.addAccessoryView(accessoryView)
    */
    
    @IBAction func unwindToCanvas (segue: UIStoryboardSegue) {
        switch segue.identifier! {
        case "selectedAccessory":
            guard let accessoryListViewController = segue.sourceViewController as? AccessoryListViewController,
                selectedAccessory = accessoryListViewController.selectedAccessory else {
                    break
            }
            let accessoryView = AccessoryView(accessory: selectedAccessory)
            accessoryView.center = accessoryOverlayView.convertPoint(accessoryOverlayView.center, fromView: accessoryOverlayView.superview)
            addAccessoryView(accessoryView)
        case "ExitFromButton":
            break
        default:
            break
        }
    }

}


// MARK: State Preservation

extension CanvasViewController {
    
    override func encodeRestorableStateWithCoder(coder: NSCoder) {
        if let photo = photoImageView.image {
            let imageData = UIImageJPEGRepresentation(photo, 1)
            coder.encodeObject(imageData, forKey: "photo")
        }
        coder.encodeObject(NSKeyedArchiver.archivedDataWithRootObject(accessoryViews), forKey: "accessoryViews")
        super.encodeRestorableStateWithCoder(coder)
    }
    
    override func decodeRestorableStateWithCoder(coder: NSCoder) {
        if let photoData = coder.decodeObjectForKey("photo") as? NSData {
            photoImageView.image = UIImage(data: photoData)
        }
        if let accessoryViewsData = coder.decodeObjectForKey("accessoryViews") as? NSData {
            let accessoryViews = NSKeyedUnarchiver.unarchiveObjectWithData(accessoryViewsData) as! [AccessoryView]
            accessoryViews.forEach(addAccessoryView)
        }
        super.decodeRestorableStateWithCoder(coder)
    }
    
}


// MARK: Image Picker Controller Delegate

extension CanvasViewController: UIImagePickerControllerDelegate {

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.photoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
}


// MARK: Gesture Interaction

extension CanvasViewController {
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func pan(sender: UIPanGestureRecognizer) {
        if let accessoryView = sender.view {
            accessoryView.superview?.bringSubviewToFront(accessoryView)
            let translation = sender.translationInView(accessoryView.superview!)
            accessoryView.center = CGPoint(x: accessoryView.center.x + translation.x, y: accessoryView.center.y + translation.y)
            sender.setTranslation(CGPointZero, inView: accessoryView.superview!)
        }
    }

    func pinch(sender: UIPinchGestureRecognizer) {
        if let accessoryView = sender.view {
            accessoryView.superview?.bringSubviewToFront(accessoryView)
            accessoryView.transform = CGAffineTransformScale(accessoryView.transform, sender.scale, sender.scale);
            sender.scale = 1
        }
    }

    func rotate(sender: UIRotationGestureRecognizer) {
        if let accessoryView = sender.view {
            accessoryView.superview?.bringSubviewToFront(accessoryView)
            accessoryView.transform = CGAffineTransformRotate(accessoryView.transform, sender.rotation);
            sender.rotation = 0
        }
    }

    func tap(sender: UILongPressGestureRecognizer) {
        if sender.state != .Began {
            return
        }
        if let accessoryView = sender.view {
            self.becomeFirstResponder()
            let menuController = UIMenuController.sharedMenuController()
            menuController.menuItems = [ UIMenuItem(title: "Entfernen", action: #selector(removeAccessoryButtonPressed(_:))) ]
            menuController.setTargetRect(accessoryView.frame, inView: accessoryView.superview!)
            menuController.setMenuVisible(true, animated: true)
            self.selectedAccessoryView = accessoryView
        }
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    func removeAccessoryButtonPressed(sender: AnyObject) {
        if let accessoryView = self.selectedAccessoryView {
            accessoryView.removeFromSuperview()
        }
    }
    
}

