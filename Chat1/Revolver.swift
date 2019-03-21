//
//  Revolver.swift
//  Chat1
//
//  Shake phone to draw
//  Tap quickly until all shots are gone
//  User is timed. The winner is the user who completes the task quicker
//

import UIKit
import MultipeerConnectivity
import AVFoundation

class Revolver: UIViewController {
    var chatService: ChatService?
    var damage = 0
    var bullets = 7
    var mTime = Double()
    var draw = 0
    
    var startTime: TimeInterval = 0
    var endTime: TimeInterval = 0
    
    var count = 5
    var player: AVAudioPlayer?
    
    @IBOutlet weak var damageTaken: UILabel!
    @IBOutlet weak var shotsFired: UILabel!
    
    // invoke chat service
    override func viewDidAppear(_ animated: Bool) {
        chatService = ChatService()
        if let chatService = chatService {
            chatService.delegate = self
        }
    }
    
    // start timer on load
    override func viewDidLoad() {
        super.viewDidLoad()
        startTime = NSDate().timeIntervalSinceReferenceDate
        var _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // shake to draw
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?){
        if event?.subtype == UIEventSubtype.motionShake {
            draw = 1
        }
    }
    
    // Shoot on tap
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        //send(message: "BANG")
        shoot()
    }

    // segue to calculate screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "calculateSeg" {
            if let destination = segue.destination as? calculate {
                destination.mTime = mTime
            }
        }
    }
    
    //
    func update() {
        if count > 0 {
            count -= 1
        }
        
        if count == 0 {
            performSegue(withIdentifier: "calculateSeg", sender: count)
        }
    }
    
    // keep track of damage taken
    // disabled: to much latency between devices
    func damageTrack() {
        damage += 1
        damageTaken.text = String(damage)
        if damage == 6 {
            stopTime()
            mTime = endTime - startTime
        }
    }
    
    // Keep track of bullets
    // end timer when all bullets are gone
    func shoot() {
        if bullets > 0 {
            playSound1()
            if draw == 1 {
                bullets -= 1
                shotsFired.text = String(bullets)
                if bullets == 0 {
                    stopTime()
                    mTime = endTime - startTime
                }
            }
        }
        draw = 1
    }
    
    func stopTime() {
        endTime = NSDate().timeIntervalSinceReferenceDate
    }
    
    func send(message: String) {
        shoot()
        if let chatService = chatService {
            chatService.sendMessage(message)
        }
    }
    
    func playSound1(){
        guard let sound = NSDataAsset(name: "gun") else {
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
extension Revolver : ChatServiceDelegate {
    
    func connectedDevicesChanged(_ manager: ChatService, connectedDevices: [String]) {
        OperationQueue.main.addOperation { () -> Void in
            ///xxx
        }
    }
    
    func messageReceived(_ manager: ChatService, message: String) {
        //damageTrack()
        OperationQueue.main.addOperation { () -> Void in
            //xxxx
        }
        
    }
    
    
    
}
