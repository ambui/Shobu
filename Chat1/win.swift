//
//  win.swift
//  Chat1
//
//  Created by Andrew Bui on 5/5/17.
//  Copyright © 2017 ASU. All rights reserved.
//

import UIKit
import AVFoundation

class win: UIViewController {
    let defaults = UserDefaults.standard
    var win = Int()
    
    var player: AVAudioPlayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playSound1()
        
        if defaults.object(forKey: "win") == nil {
            win = 0
        }
        else {
            win = defaults.object(forKey: "win") as! Int
        }
        win += 1
        UserDefaults.standard.set(win, forKey: "win")
    }

    func playSound1(){
        guard let sound = NSDataAsset(name: "win") else {
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
