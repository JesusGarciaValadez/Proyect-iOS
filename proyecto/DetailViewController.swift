//
//  DetailViewController.swift
//  proyecto
//
//  Created by Jesús García Valadez on 22/08/15.
//  Copyright © 2015 Jesús García Valadez. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var item: TodoItem?,
    todoList: TodoList?
    
    private let DATE_FORMAT = "dd/MM/yyyy HH:mm"

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var imageView: UIImageView!

    // MARK: Show all the items and give format to the labels. Add a gesture recognizer to the UILabel for trigger toggleDatePicker
    override func viewDidLoad() {
        super.viewDidLoad()

        print( "Item: \(self.item)" )
        self.showItem()

        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.numberOfTouchesRequired = 1
        tapGestureRecognizer.addTarget( self, action: "toggleDatePicker" )
        self.dateLabel.addGestureRecognizer( tapGestureRecognizer )
        self.dateLabel.userInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Show all the items and give format to the labels.
    func showItem() {
        self.descriptionLabel.text = item?.todo
        if let date = item?.dueDate {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "dd/MM/yyyy HH:mm"
            self.dateLabel.text = formatter.stringFromDate( date )
        }
        if let img = item?.image {
            self.imageView.image = img
        }
    }

    // MARK: Schedule a local notificacion with a given date
    @IBAction func addNotification(sender: UIBarButtonItem) {
        // Obtain the date from the dateLabel as a string
        if let dateString = self.dateLabel.text {
            // Obtain a date from a string
            if let date = parseDate( string: dateString ) {
                // Schedule a local notification from the date
                self.item?.dueDate = date
                self.todoList?.saveItems()

                scheduleNotificacion( message: self.item!.todo!, date: date )
                self.doneButton.enabled = false

                self.navigationController?.popViewControllerAnimated( true )
            }
        }
    }

    //  MARK: Select a date from the UIDatePicker and set a label text with this selected date
    @IBAction func dateSelected(sender: UIDatePicker) {
        print( "Fecha seleccionada: \( sender.date )" )
        self.dateLabel.text = formatDate(date: sender.date )
        self.doneButton.enabled = true
        self.datePicker.hidden = true
    }

    // MARK: Add the image obtained from the image picker and show it in the UIImage
    @IBAction func addImage(sender: UIBarButtonItem) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController( imagePickerController, animated: true, completion: nil )
        imagePickerController.delegate = self
    }

    // MARK: Formatting a date passed as parameter with a given format
    func formatDate( date date: NSDate ) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = self.DATE_FORMAT
        return formatter.stringFromDate( date )
    }

    // MARK: Formatting a string passed as parameter with a given format
    func parseDate( string string: String ) -> NSDate? {
        let parser = NSDateFormatter()
        parser.dateFormat = self.DATE_FORMAT
        return parser.dateFromString( string )
    }

    // MARK: Configuration and schedule of UILocalNotification
    func scheduleNotificacion( message message: String, date: NSDate ) {
        let localNotificacion = UILocalNotification()
        localNotificacion.fireDate = date
        localNotificacion.timeZone = NSTimeZone.defaultTimeZone()
        localNotificacion.alertBody = message
        localNotificacion.alertTitle = "Recuerda esta tarea"
        localNotificacion.applicationIconBadgeNumber = 1;

        UIApplication.sharedApplication().scheduleLocalNotification( localNotificacion )
    }

    // MARK: Add a gesture recognizer to the image for trigger rotate in the image
    func addGestureRecognizerToImage() {
        let gr = UITapGestureRecognizer()
        // Set the gesture recognizer for one tap
        gr.numberOfTapsRequired = 1
        // Set the touches to one finger
        gr.numberOfTouchesRequired = 1
        // Execute the function rotate when the gesture is triggered
        gr.addTarget( self, action: "rotate" )
        // Enabling the image for receive a touch event and adding the gesture recognizer to the image
        self.imageView.userInteractionEnabled = true
        self.imageView.addGestureRecognizer( gr )
    }

    // MARK: Rotate the image of the task
    func rotate() {
        let animation = CABasicAnimation()
        // Set a transformation as rotation
        animation.keyPath = "transform.rotation"
        // Set the rotation in 360 degrees
        animation.toValue = M_PI * 2.0
        // Set the duration of the rotation in 1 second
        animation.duration = 1
        // Adding the rotation to the image in this view
        self.imageView.layer.addAnimation( animation, forKey: "rotateAnimation")
    }

    // MARK: Toggle the UIDatePicker with a fade animation
    func toggleDatePicker() {
        if self.datePicker.hidden {
            fadeInDatePicker()
        } else {
            fadeOutDatePicker()
        }
    }

    // MARK: Doing a fade in to the UIDatePicker
    func fadeInDatePicker() {
        // Set the UIDatePicker opacity to 0 (transparent)
        self.datePicker.alpha = 0
        // Hide the UIDatePicker
        self.datePicker.hidden = false
        // Do the interpolation of the follow properties of the IBOutlet below listed in a second
        UIView.animateWithDuration( 1 ) { () -> Void in
            self.datePicker.alpha = 1
            self.imageView.alpha = 0
        }
    }

        // MARK: Doing a fade out to the UIDatePicker
    func fadeOutDatePicker() {
        // Set the UIDatePicker opacity to 1 (opaque)
        self.datePicker.alpha = 1
        // Show the UIDatePicker
        self.datePicker.hidden = false
        // Do the interpolation of the follow properties of the IBOutlet below listed in a second
        UIView.animateWithDuration( 1, animations: { () -> Void in
            self.datePicker.alpha = 0
            self.imageView.alpha = 1
            } ) { (completed ) -> Void in
                if completed {
                    self.datePicker.hidden = true
                }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// PRAGMA MARK: - UIImagePickerControllerDelegate and UINavigatotControllerDelegate methods
extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: Show a picking photo view and obtain the image path
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[ UIImagePickerControllerOriginalImage ] as? UIImage {
            self.item?.image = image
            self.todoList?.saveItems()
            self.imageView.image = image
        }
        self.dismissViewControllerAnimated( true, completion: nil )
    }
}