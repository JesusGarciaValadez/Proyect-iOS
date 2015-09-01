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

    override init() {
        super.init()
    }

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

extension TodoItem: NSCoding {
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