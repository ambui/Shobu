//
//  loss.swift
//  Chat1
//
//  Created by Andrew Bui on 5/5/17.
//  Copyright © 2017 ASU. All rights reserved.
//

import UIKit
import AVFoundation

class loss: UIViewController {
    let defaults = UserDefaults.standard
    var loss = Int()
    var player:AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playSound1()
        if defaults.object(forKey: "loss") == nil {
            loss = 0
        }
        else {
            loss = defaults.object(forKey: "loss") as! Int
        }
        loss += 1
        
        UserDefaults.standard.set(loss, forKey: "loss")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playSound1(){
        guard let sound = NSDataAsset(name: "death") else {
            print("not found")
            return
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(data:sound.data, fileTypeHint: AVFileTypeMPEGLayer3)
            player!.play()
        } catch _ as NSError {
            print("x!!error!!x")
        }
    }


}
