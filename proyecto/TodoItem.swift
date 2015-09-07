//
//  TodoItem.swift
//  proyecto
//
//  Created by Jesús García Valadez on 01/09/15.
//  Copyright © 2015 Jesús García Valadez. All rights reserved.
//

import UIKit

class TodoItem: NSObject {
    var todo: String?,
    dueDate: NSDate?,
    image: UIImage?

    // MARK: Class inicialization without parameters
    override init() {
        super.init()
    }

    // MARK: Class inicialization with parameters for decode information and self provide with this info
    required init( coder aDecoder: NSCoder ) {
        super.init()

        if let message = aDecoder.decodeObjectForKey( "todo" ) as? String {
            self.todo = message
        }

        if let date = aDecoder.decodeObjectForKey( "date" ) as? NSDate {
            self.dueDate = date
        }

        if let img = aDecoder.decodeObjectForKey( "image" ) as? UIImage {
            self.image = img
        }
    }
}

// PRAGMA MARK: - NSCoding Protocol Methods
extension TodoItem: NSCoding {

    // MARK: Encode all the parameters with NSCoder coder for self serialization
    func encodeWithCoder( aCoder: NSCoder ) {
        if let message = self.todo {
            aCoder.encodeObject( message, forKey: "todo" )
        }
        if let date = self.dueDate {
            aCoder.encodeObject( date, forKey: "dueDage" )
        }
        if let image = self.image {
            aCoder.encodeObject( image, forKey: "image" )
        }
    }
}