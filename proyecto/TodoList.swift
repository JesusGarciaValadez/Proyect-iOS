//
//  TodoList.swift
//  proyecto
//
//  Created by Jesús García Valadez on 11/08/15.
//  Copyright © 2015 Jesús García Valadez. All rights reserved.
//

import UIKit

class TodoList: NSObject {
    var items: [ String ] = []

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

        return documentDirectoryURL.URLByAppendingPathComponent( "todolist.items" )
    }()

    func addItem( item item: String ) {
        items.append( item )

        self.saveItems()
    }

    func saveItems() {
        let itemsArray = items as NSArray
        if itemsArray.writeToURL( self.fileURL, atomically: true ) {
            print( "Guardado" )
        } else {
            print( "No guardado" )
        }
    }

    func loadItems() {
        if let itemsArray = NSArray( contentsOfURL: self.fileURL ) as? [ String ] {
            self.items = itemsArray
        }
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
        let item: String = items[ indexPath.row ]
        cell.textLabel!.text = item

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