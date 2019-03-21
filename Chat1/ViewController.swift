//
//  ViewController.swift
//  Chat1
//  "Chatroom" of the map. Users can issue and accept challenges in this screen
//  The first responsder and issuer will then be segued into a game screen
//

import UIKit
import MultipeerConnectivity
import AVFoundation

class ViewController: UIViewController {
    let defaults = UserDefaults.standard
    var searchMessage = String()
    var messageLog: String = ""
    var sendReq = 0
    var recReq = 0
    var player: AVAudioPlayer?
    
    @IBOutlet weak var connectionsLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    var chatService: ChatService?
    
    // Load challenge message
    override func viewDidLoad() {
        super.viewDidLoad()
        connectionsLabel.isHidden = true
        if defaults.object(forKey: "name") != nil {
            searchMessage = (defaults.object(forKey: "name") as? String)!
        }
        else {
            searchMessage = "Looking for Worthy Opponent"
        }
    }
    

    // invoke chatservice
    override func viewDidAppear(_ animated: Bool) {
        if (chatService == nil) {
            chatService = ChatService()
            if let chatService = chatService {
                chatService.delegate = self
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // disconnect from chatroom
    @IBAction func Disconnect(_ sender: Any) {
        if let chatService = chatService {
            chatService.disconnect()
            print("disconnect!!")
        }
    }

    // accept duel - quickdraw
    @IBAction func s2(_ sender: Any) {
        playSound1()
        send(message: searchMessage)
        sendReq = 1
        acceptDuel()
        print("\(sendReq) \(recReq)")
    }
    // accept duel - swipe
    @IBAction func sam(_ sender: Any) {
        playSound1()
        send(message: searchMessage)
        sendReq = 2
        acceptDuel()
    }
    
    // send message to chatlog
    func send(message: String) {
        messageLog += "[me] " + message + "\n"
        textView.text = messageLog
        textView.setNeedsLayout()
        if let chatService = chatService {
            chatService.sendMessage(message)
        }
    }
    
    // challenge has been accepted -> segue
    func acceptDuel() {
        if (recReq == 1 && sendReq == 1 ){
            performSegue(withIdentifier: "revLoadSeg", sender: Any?.self)
        }
        if (recReq == 1 && sendReq == 2) {
            performSegue(withIdentifier: "samLoadSeg", sender: Any?.self)
        }
    }
}


// Chat Service
extension ViewController : ChatServiceDelegate {
    
    func connectedDevicesChanged(_ manager: ChatService, connectedDevices: [String]) {
        print("connectedDevicesChanged \(connectedDevices)")
        let list = connectedDevices.joined(separator: ", ")
        OperationQueue.main.addOperation { () -> Void in
            self.connectionsLabel.text = list
            self.connectionsLabel.setNeedsDisplay()
        }
    }
    
    func messageReceived(_ manager: ChatService, message: String) {
        messageLog += message
        messageLog += "\n"
        //print(messageLog)
        OperationQueue.main.addOperation { () -> Void in
            self.recReq = 1
            self.acceptDuel()
            self.textView.text = self.messageLog
            self.textView.setNeedsDisplay()
        }
        
    }
    
    func playSound1(){
        guard let sound = NSDataAsset(name: "Track02") else {
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
