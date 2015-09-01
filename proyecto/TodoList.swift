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

    override init() {
        super.init()

        loadItems()
    }

    private let fileURL: NSURL = {
        let fileManager = NSFileManager.defaultManager()
        let documentDirectoryURLs = fileManager.URLsForDirectory( .DocumentDirectory,
            inDomains: .UserDomainMask ) as [ NSURL ]
        let documentDirectoryURL = documentDirectoryURLs.first!
        print( "Path a documents \(documentDirectoryURL)" )

        return documentDirectoryURL.URLByAppendingPathComponent( "todolist.plist" )
    }()

    func addItem( item item: TodoItem ) {
        items.append( item )

        self.saveItems()
    }

    func saveItems() {
        let itemsArray = items as NSArray

        if NSKeyedArchiver.archiveRootObject( itemsArray, toFile: self.fileURL.path! ) {
            print( "Guardado" )
        } else {
            print( "No Guardado" )
        }
    }

    func loadItems() {
        if let itemsArray = NSKeyedUnarchiver.unarchiveObjectWithFile( self.fileURL.path! ) {
            self.items = itemsArray as! [ TodoItem ]
        }
    }

    func getItem( index index: Int ) -> TodoItem {
        return self.items[ index ]
    }
}

// PRAGMA MARK: - Métodos del UITableViewDataSource
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

    // MARK: -
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        items.removeAtIndex( indexPath.row )
        saveItems()
        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths( [ indexPath ], withRowAnimation: UITableViewRowAnimation.Middle )
        tableView.endUpdates()
    }
}