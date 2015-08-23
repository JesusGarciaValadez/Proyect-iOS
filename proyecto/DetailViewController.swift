//
//  DetailViewController.swift
//  proyecto
//
//  Created by Jesús García Valadez on 22/08/15.
//  Copyright © 2015 Jesús García Valadez. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var item: String?

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        print( "Item: \(self.item)" )
        self.descriptionLabel.text = self.item
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
