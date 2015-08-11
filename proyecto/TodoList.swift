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

    //Solicitamos el path de la carpeta Documents para guardar ahí los items
    //Al le agregamos el nombre del archivo: todolist.items
    private let fileURL: NSURL = {
        let fileManager = NSFileManager.defaultManager()
        let documentDirectoryURLs = fileManager.URLsForDirectory( .DocumentDirectory, inDomains: .UserDomainMask ) as [ NSURL ]
        let documentDirectoryURL = documentDirectoryURLs.first!
        print( "Path de documents \(documentDirectoryURL)")
        return documentDirectoryURL.URLByAppendingPathComponent( "todoList.items" )
    }()

    func addItem( item item: String ) {
        items.append( item )
    }

    //Los NSArrays saben serializarse: transformarse en bytes.
    //WriteURL además los guarda en la url que le indiquemos
    func saveItems() {
        let itemsArray = items as NSArray
        if itemsArray.writeToURL( self.fileURL, atomically: true ) {
            print( "Guardado" )
        } else {
            print( "No guardado" )
        }
    }

    // cargamos el archivo y si existe lo guardamos en items
    func loadItems() {
        if let itemsArray = NSArray ( contentsOfURL: self.fileURL ) as? [ String ] {
            self.items = itemsArray
        }
    }

    //Sobreescribimos el init para cargar el archivo cada que se cree el objeto
    override init() {
        super.init()
        loadItems()
    }
}

extension TodoList: UITableViewDataSource {
    func tableView( tableView: UITableView, numberOfRowsInSection section: Int ) -> Int {
        return items.count
    }

    func tableView( tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier( "Cell", forIndexPath: indexPath )
        let item = self.items[ indexPath.row ]

        cell.textLabel!.text = item
        return cell
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        self.items.removeAtIndex( indexPath.row )
        saveItems()
        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths( [ indexPath ], withRowAnimation: UITableViewRowAnimation.Middle )
        tableView.endUpdates()
    }
}