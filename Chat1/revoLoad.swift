//
//  revLoad.swift
//  Chat1
//
//  Display rules of game
//  and Countdown
//

import UIKit
import AVFoundation

class revoLoad: UIViewController {
    
    @IBOutlet weak var counter: UILabel!
    var count = 5
    var player: AVAudioPlayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playSound1()
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
            player?.stop()
            performSegue(withIdentifier: "revSeg", sender: count)
        }
    }
    
    // play gun sound
    func playSound1(){
        guard let sound = NSDataAsset(name: "load") else {
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
        // Dispose of any resources that can be recreated.
    }
    
}
