//
//  ViewController.swift
//  proyecto
//
//  Created by Jesús García Valadez on 06/08/15.
//  Copyright © 2015 Jesús García Valadez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    let todoList: TodoList = TodoList()
    private static let MAX_TEXT_SIZE = 50

    @IBAction func addButtonPressed( sender: UIButton ) {
        print( "Agregando un elemento a la lista \(self.itemTextField.text!)" )
        self.todoList.addItem( item: self.itemTextField.text! )
        tableView.reloadData()

        self.textFieldResignFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // Adds a cell to the TableView and naming it "Cell"
        tableView.registerClass( UITableViewCell.self, forCellReuseIdentifier: "Cell" )
        tableView.dataSource = self.todoList
    }

    // MARK: - Blur from the TextField and resign first responder
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.textFieldResignFirstResponder()
    }

    func textFieldResignFirstResponder() {
        self.itemTextField?.resignFirstResponder()
    }
}

// PRAGMA MARK: - Métodos del TextFieldDelegate
extension ViewController: UITextFieldDelegate {

}