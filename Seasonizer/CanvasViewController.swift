//
//  CanvasViewController.swift
//  Seasonizer
//
//  Created by Nils Fischer on 19.06.15.
//  Copyright (c) 2015 Nils Fischer. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AccessoryListViewControllerDelegate, UIGestureRecognizerDelegate {
    
    var allAccessories: [Accessory]!

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var accessoryOverlayView: UIView!
    
    var accessoryViews: [AccessoryView] {
        var accessoryViews = [AccessoryView]()
        for view in accessoryOverlayView.subviews {
            if let accessoryView = view as? AccessoryView {
                accessoryViews.append(accessoryView)
            }
        }
        return accessoryViews
    }
    
    var renderedPicture: UIImage {
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, true, 0)
        self.view.drawViewHierarchyInRect(self.view.bounds, afterScreenUpdates: true)
        let renderedPicture = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return renderedPicture
    }

    override func encodeRestorableStateWithCoder(coder: NSCoder) {
        if let photo = photoImageView.image {
            let imageData = UIImagePNGRepresentation(photo)
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
            for accessoryView in accessoryViews {
                self.addAccessoryView(accessoryView)
            }
        }
        super.decodeRestorableStateWithCoder(coder)
    }
    
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
    
    func presentImagePickerWithSourceType(sourceType: UIImagePickerControllerSourceType) {
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
        let activityViewController = UIActivityViewController(activityItems: [ self.renderedPicture ], applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "showAccessories":
                if let accessoryListViewController = (segue.destinationViewController as? UINavigationController)?.topViewController as? AccessoryListViewController {
                    accessoryListViewController.delegate = self
                }
            default:
                break
            }
        }
    }
    
    // MARK: Accessories
    func addAccessoryView(accessoryView: AccessoryView) {
        self.accessoryOverlayView.addSubview(accessoryView)
        
        accessoryView.userInteractionEnabled = true
        
        // Bewegen
        let panGR = UIPanGestureRecognizer(target:self, action:"pan:")
        panGR.delegate = self
        accessoryView.addGestureRecognizer(panGR)
        
        // Skalieren
        let pinchGR = UIPinchGestureRecognizer(target:self, action:"pinch:")
        pinchGR.delegate = self
        accessoryView.addGestureRecognizer(pinchGR)
        
        // Drehen
        let rotateGR = UIRotationGestureRecognizer(target:self, action:"rotate:")
        rotateGR.delegate = self
        accessoryView.addGestureRecognizer(rotateGR)
        
        // Löschen
        let tapGR = UILongPressGestureRecognizer(target:self, action:"tap:")
        tapGR.delegate = self
        accessoryView.addGestureRecognizer(tapGR)
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.photoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: AccessoryListViewControllerDelegate
    func accessoriesForAccessoryListViewController(accessoryListViewController: AccessoryListViewController) -> [Accessory] {
        return self.allAccessories
    }
    func accessoryListViewController(accessoryListViewController: AccessoryListViewController, didSelectAccessory accessory: Accessory) {
        let accessoryView = AccessoryView(accessory: accessory)
        accessoryView.center = accessoryOverlayView.convertPoint(accessoryOverlayView.center, fromView: accessoryOverlayView.superview)
        self.addAccessoryView(accessoryView)
        accessoryListViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    func accessoryListViewControllerDidCancel(accessoryListViewController: AccessoryListViewController) {
        accessoryListViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Gesture Recognizers
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // Gesture Recognizer unterbrechen die Erkennung einer Geste bei der Erkennung einer anderen, wenn hier NO zurückgegeben wird.
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

    private var selectedAccessoryView: UIView?
    func tap(sender: UILongPressGestureRecognizer) {
        if sender.state != .Began {
            return
        }
        if let accessoryView = sender.view {
            self.becomeFirstResponder()
            let menuController = UIMenuController.sharedMenuController()
            menuController.menuItems = [ UIMenuItem(title: "Entfernen", action:"removeAccessoryButtonPressed:") ]
            menuController.setTargetRect(CGRect(x: accessoryView.center.x, y: accessoryView.center.y, width: 0, height: 0), inView: accessoryView.superview!)
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

