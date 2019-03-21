//
//  revLoad.swift
//  Chat1
//
//  Created by Andrew Bui on 5/4/17.
//  Copyright © 2017 ASU. All rights reserved.
//

import UIKit

class revLoad: UIViewController {

    @IBOutlet weak var counter: UILabel!
    var count = 15
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        counter.text = String(count)
        var _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }

    func update() {
        if count > 0 {
            counter.text = String(count)
            count -= 1
        }

        if count == 0 {
            performSegue(withIdentifier: "revSeg", sender: count)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
