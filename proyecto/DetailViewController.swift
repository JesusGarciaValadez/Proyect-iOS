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

    // Schedule a local notificacion with a given date
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

    //  Select a date from the UIDatePicker and set a label text with this selected date
    @IBAction func dateSelected(sender: UIDatePicker) {
        print( "Fecha seleccionada: \( sender.date )" )
        self.dateLabel.text = formatDate(date: sender.date )
        self.doneButton.enabled = true
        self.datePicker.hidden = true
    }

    @IBAction func addImage(sender: UIBarButtonItem) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController( imagePickerController, animated: true, completion: nil )
        imagePickerController.delegate = self
    }

    // Formatting a date passed as parameter with a given format
    func formatDate( date date: NSDate ) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = self.DATE_FORMAT
        return formatter.stringFromDate( date )
    }

    // Formatting a string passed as parameter with a given format
    func parseDate( string string: String ) -> NSDate? {
        let parser = NSDateFormatter()
        parser.dateFormat = self.DATE_FORMAT
        return parser.dateFromString( string )
    }

    // Configuration and schedule of UILocalNotification
    func scheduleNotificacion( message message: String, date: NSDate ) {
        let localNotificacion = UILocalNotification()
        localNotificacion.fireDate = date
        localNotificacion.timeZone = NSTimeZone.defaultTimeZone()
        localNotificacion.alertBody = message
        localNotificacion.alertTitle = "Recuerda esta tarea"
        localNotificacion.applicationIconBadgeNumber = 1;

        UIApplication.sharedApplication().scheduleLocalNotification( localNotificacion )
    }

    func addGestureRecognizerToImage() {
        let gr = UITapGestureRecognizer()
        gr.numberOfTapsRequired = 1
        gr.numberOfTouchesRequired = 1
        gr.addTarget( self, action: "rotate")
        self.imageView.userInteractionEnabled = true
        self.imageView.addGestureRecognizer( gr )
    }

    func rotate() {
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation"
        animation.toValue = M_PI * 2.0
        animation.duration = 1
        self.imageView.layer.addAnimation( animation, forKey: "rotateAnimation")
    }

    func toggleDatePicker() {
        if self.datePicker.hidden {
            fadeInDatePicker()
        } else {
            fadeOutDatePicker()
        }
    }

    func fadeInDatePicker() {
        self.datePicker.alpha = 0
        self.datePicker.hidden = false
        UIView.animateWithDuration( 1 ) { () -> Void in
            self.datePicker.alpha = 1
            self.imageView.alpha = 0
        }
    }

    func fadeOutDatePicker() {
        self.datePicker.alpha = 1
        self.datePicker.hidden = false
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

// MARK: - UIImagePickerControllerDelegate and UINavigatotControllerDelegate methods
extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[ UIImagePickerControllerOriginalImage ] as? UIImage {
            self.item?.image = image
            self.todoList?.saveItems()
            self.imageView.image = image
        }
        self.dismissViewControllerAnimated( true, completion: nil )
    }
}