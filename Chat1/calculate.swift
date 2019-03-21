//
//  calculate.swift
//  Chat1
//
// Receives time from other device and calculate winner
//

import UIKit
import MultipeerConnectivity
import AVFoundation



class calculate: UIViewController {
    let defaults = UserDefaults.standard
    var chatService: ChatService?
    var mTime = Double()
    var oTime = Double()
    var dMessage = Double()
    @IBOutlet weak var myTime: UILabel!
    @IBOutlet weak var oppTime: UILabel!
    @IBOutlet weak var taunt: UILabel!
    var sendTaunt = String()
    var count = 5
    
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playSound1()
        myTime.text = String(Double(round(1000*mTime)/1000))
        send(message: "\(mTime)")
        if defaults.object(forKey: "taunt") != nil {
            sendTaunt = (defaults.object(forKey: "taunt") as? String)!
            taunt.text = sendTaunt
        }
        else {
            taunt.text = "..."
        }
        var _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)

    }

    override func viewDidAppear(_ animated: Bool) {
        chatService = ChatService()
        if let chatService = chatService {
            chatService.delegate = self
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    func update() {
        if count > 0 {
            count -= 1
            send(message: "\(mTime)")

        }
        
        if count == 0 {
            if (mTime >= oTime || mTime == 0.0) {
                performSegue(withIdentifier: "loseSeg", sender: Any?.self)
            }
            if (mTime < oTime) {
                performSegue(withIdentifier: "winSeg", sender: Any?.self)
            }
        }
    }

    func send(message: String) {
        if let chatService = chatService {
            chatService.sendMessage(message)
        }
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
}



extension calculate : ChatServiceDelegate {
    
    func connectedDevicesChanged(_ manager: ChatService, connectedDevices: [String]) {
        print("connectedDevicesChanged \(connectedDevices)")
        _ = connectedDevices.joined(separator: ", ")
        OperationQueue.main.addOperation { () -> Void in
            //xxxx
        }
    }
    
    func messageReceived(_ manager: ChatService, message: String) {
        oTime = Double(message)!
        OperationQueue.main.addOperation { () -> Void in
            self.oTime = Double(message)!

        }
        
    }
    
    
    
}
