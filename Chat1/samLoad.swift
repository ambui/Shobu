//
//  samLoad.swift
//  Chat1
//
//  Display rules of game
//  and Countdown
//

import UIKit
import AVFoundation

class samLoad: UIViewController {

    var count = 5
    let s1 = Int(arc4random_uniform(3))
    let s2 = Int(arc4random_uniform(3))
    let s3 = Int(arc4random_uniform(3))
    var player: AVAudioPlayer?

    var sArray = [Int]()
    
    @IBOutlet weak var counter2: UILabel!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "samSeg" {
            if let destination = segue.destination as? ketto {
                destination.sArray = (sender as? [Int])!
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playSound1()
        sArray = [s1,s2,s3]
        
        counter2.text = String(count)
        var _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)

    }
    
    func update() {
        if count > 0 {
            counter2.text = String(count)
            count -= 1
        }
        
        if count == 0 {
            player?.stop()
            performSegue(withIdentifier: "samSeg", sender: sArray)
        }
    }
    
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
    }
    

}
