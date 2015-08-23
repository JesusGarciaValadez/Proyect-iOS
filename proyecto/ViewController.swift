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
    var selectedItem: String?

    @IBAction func addButtonPressed( sender: UIButton ) {
        print( "Agregando un elemento a la lista \(self.itemTextField.text!)" )
        self.todoList.addItem( item: self.itemTextField.text! )
        self.tableView.reloadData()

        self.itemTextField.text = nil
        self.textFieldResignFirstResponder()
    }

    // MARK: - Blur from the TextField and resign first responder
    func textFieldResignFirstResponder() {
        self.itemTextField?.resignFirstResponder()
    }

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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detailViewController = segue.destinationViewController as? DetailViewController {
            detailViewController.item = self.selectedItem
        }
    }

}

// PRAGMA MARK: - Métodos del UITableViewDelegate
extension ViewController: UITableViewDelegate {
    // MARK: - Blur from the TextField and resign first responder
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.textFieldResignFirstResponder()
    }

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

// PRAGMA MARK: - Métodos del UITextFieldDelegate
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
