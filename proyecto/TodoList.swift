//
//  TodoList.swift
//  proyecto
//
//  Created by Jesús García Valadez on 11/08/15.
//  Copyright © 2015 Jesús García Valadez. All rights reserved.
//

import UIKit

class TodoList: NSObject {
    var items: [ String ] = [ ]

    func addItem( item item: String ) {
        items.append( item )
    }
}

// Pragma Mark: - Métodos del TableViewDataSource
extension TodoList : UITableViewDataSource {
    // Tells the data source to return the number of rows in a given section of a table view.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    // Asks the data source for a cell to insert in a particular location of the table view.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier( "Cell", forIndexPath: indexPath )
        let item: String = items[ indexPath.row ]
        cell.textLabel!.text = item

        return cell
    }
}