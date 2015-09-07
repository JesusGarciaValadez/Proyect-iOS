//
//  TodoList.swift
//  proyecto
//
//  Created by Jesús García Valadez on 11/08/15.
//  Copyright © 2015 Jesús García Valadez. All rights reserved.
//

import UIKit

class TodoList: NSObject {
    var items: [ TodoItem ] = []

    // MARK: Inicialization of instance loading items from a plist file
    override init() {
        super.init()

        loadItems()
    }

    // MARK: Set a path and filename for a plist file for save tasks
    private let fileURL: NSURL = {
        let fileManager = NSFileManager.defaultManager()
        let documentDirectoryURLs = fileManager.URLsForDirectory( .DocumentDirectory,
            inDomains: .UserDomainMask ) as [ NSURL ]
        let documentDirectoryURL = documentDirectoryURLs.first!
        print( "Path a documents \(documentDirectoryURL)" )

        return documentDirectoryURL.URLByAppendingPathComponent( "todolist.plist" )
    }()

    // MARK: Add an item into the array of tasks and save into a plist file
    func addItem( item item: TodoItem ) {
        items.append( item )

        self.saveItems()
    }

    // MARK: Save all the taks into the plist file
    func saveItems() {
        let itemsArray = items as NSArray

        if NSKeyedArchiver.archiveRootObject( itemsArray, toFile: self.fileURL.path! ) {
            print( "Guardado" )
        } else {
            print( "No Guardado" )
        }
    }

    // MARK: Loading all items from the plist file in the disk
    func loadItems() {
        if let itemsArray = NSKeyedUnarchiver.unarchiveObjectWithFile( self.fileURL.path! ) {
            self.items = itemsArray as! [ TodoItem ]
        }
    }

    // Get an item specified
    func getItem( index index: Int ) -> TodoItem {
        return self.items[ index ]
    }
}

// PRAGMA MARK: - Methods of the UITableViewDataSource
extension TodoList : UITableViewDataSource {

    // MARK: - Tells the data source to return the number of rows in a given section of a table view.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    // MARK: - Asks the data source for a cell to insert in a particular location of the table view.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier( "Cell", forIndexPath: indexPath )
        let item = items[ indexPath.row ]

        cell.textLabel!.text = item.todo
        return cell
    }

    // MARK: - Make the cells deletable
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    // MARK: - Remove an item from the array of tasks, save all the taks remaining into the plist file and set an animation for delete a row in the UITableView
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        items.removeAtIndex( indexPath.row )
        saveItems()
        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths( [ indexPath ], withRowAnimation: UITableViewRowAnimation.Middle )
        tableView.endUpdates()
    }
}