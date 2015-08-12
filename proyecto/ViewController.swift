//
//  ViewController.swift
//  proyecto
//
//  Created by Jesús García Valadez on 06/08/15.
//  Copyright © 2015 Jesús García Valadez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    let todoList: TodoList = TodoList()
    private static let MAX_TEXT_SIZE = 50

    @IBAction func addButtonPressed( sender: UIButton ) {
        print( "Agregando un elemento a la lista \(itemTextField.text)" )
        self.todoList.addItem(item: itemTextField.text! )

        tableView.reloadData()
        self.itemTextField.text = nil
        self.itemTextField?.resignFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        tableView.registerClass( UITableViewCell.self, forCellReuseIdentifier: "Cell" )
        tableView.dataSource = todoList
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Métodos del table view delegate
    func scrollViewDisScroll( scrollView: UIScrollView ) {
        self.itemTextField?.resignFirstResponder()
    }

    //MARK: Métodos del text field delegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var currentLength = 0
        if let currentText = itemTextField.text {
            let updatedString = (currentText as NSString).stringByReplacingCharactersInRange(range, withString: string)
            currentLength = updatedString.characters.count
        } else {
            currentLength = string.characters.count
        }
        return currentLength <= ViewController.MAX_TEXT_SIZE
    }
}

