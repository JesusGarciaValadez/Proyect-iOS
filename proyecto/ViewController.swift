//
//  ViewController.swift
//  proyecto
//
//  Created by Jesús García Valadez on 06/08/15.
//  Copyright © 2015 Jesús García Valadez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    let todoList: TodoList = TodoList()
    private static let MAX_TEXT_SIZE = 50
    var selectedItem: TodoItem?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Adds a cell to the TableView and naming it "Cell"
        self.tableView.registerClass( UITableViewCell.self,
            forCellReuseIdentifier: "Cell" )

        // Setting a DataSource for the UITableView
        self.tableView.dataSource = self.todoList
        //self.tableView.delegate = self
        //self.itemTextField.delegate = self
    }

    // Create a new Item and add it to the list. Reload the tableView, reset the itemTextField and hide the keyboard
    @IBAction func addButtonPressed( sender: UIButton ) {
        print( "Agregando un elemento a la lista \(self.itemTextField.text!)" )
        let todoItem = TodoItem()
        todoItem.todo = itemTextField.text
        todoList.addItem( item: todoItem )

        self.tableView.reloadData()

        self.itemTextField.text = nil
        self.textFieldResignFirstResponder()
    }

    // MARK: - Blur from the TextField and resign first responder
    func textFieldResignFirstResponder() {
        self.itemTextField?.resignFirstResponder()
    }

    // Prepare for passing objects to the DetailViewController in the segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detailViewController = segue.destinationViewController as? DetailViewController {
            detailViewController.item = self.selectedItem
            detailViewController.todoList = self.todoList
        }
    }

    // MARK: - Blur from the TextField and resign first responder
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.textFieldResignFirstResponder()
    }
}

// PRAGMA MARK: - Methods of the UITableViewDelegate
extension ViewController: UITableViewDelegate {
    // MARK: Do the segue and pass it to the ViewController
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedItem = self.todoList.getItem(index: indexPath.row)
        self.performSegueWithIdentifier( "showItem", sender: self)

        // Performing segue via code
        /*
        let detailVC = DetailViewController()
        self.navigationController?.pushViewController( detailVC, animated: true)
        */
    }
}

// PRAGMA MARK: - Methods of the UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    // MARK: - Tells the TextField if user writes a lot and denies if there's more than MAX_TEXT_SIZE characters
    func textField(textField: UITextField,
        shouldChangeCharactersInRange range: NSRange,
        replacementString string: String) -> Bool {
        if let taskString = textField.text as? NSString {
            let updatedTaskString = taskString.stringByReplacingCharactersInRange( range,
                withString: string )
            return updatedTaskString.characters.count <= ViewController.MAX_TEXT_SIZE
        } else {
            return true
        }
    }
}
