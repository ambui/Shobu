//
//  ketto.swift
//  Chat1
//
// Swiping Game
// Swipe the random pattern
// First to finish is the winner
//

import UIKit
import AVFoundation

class ketto: UIViewController {
    var sArray = [Int]()
    var uArray = [Int]()

    var x1 = Int()
    var x2 = Int()
    var x3 = Int()
    
    var count = 8
    var startTime: TimeInterval = 0
    var endTime: TimeInterval = 0
    var mTime = Double()
    
    var player: AVAudioPlayer?
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var s1: UILabel!
    @IBOutlet weak var s2: UILabel!
    @IBOutlet weak var s3: UILabel!
    
    func sets1() {
        x1 = sArray[0]
        if x1 == 0 {
            s1.text = "up"
        }
        if x1 == 1 {
            s1.text = "down"
        }
        if x1 == 2 {
            s1.text = "left"
        }
        if x1 == 3 {
            s1.text = "right"
        }
    }
    func sets2() {
        x2 = sArray[1]
        if x2 == 0 {
            s2.text = "up"
        }
        if x2 == 1 {
            s2.text = "down"
        }
        if x2 == 2 {
            s2.text = "left"
        }
        if x2 == 3 {
            s2.text = "right"
        }
    }
    func sets3() {
        x3 = sArray[2]
        if x3 == 0 {
            s3.text = "up"
        }
        if x3 == 1 {
            s3.text = "down"
        }
        if x3 == 2 {
            s3.text = "left"
        }
        if x3 == 3 {
            s3.text = "right"
        }
    }
    
    func appendU(n: Int) {
        playSound1()
        uArray.append(n)
        if uArray.count == 3 {
            endTime = NSDate().timeIntervalSinceReferenceDate
            mTime = endTime - startTime
        }
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
                switch swipeGesture.direction {
                case UISwipeGestureRecognizerDirection.right:
                    appendU(n: 3)
                    label.text = "right"
                    
                case UISwipeGestureRecognizerDirection.down:
                    appendU(n: 1)
                    label.text = "down"

                    
                case UISwipeGestureRecognizerDirection.left:
                    appendU(n: 2)
                    label.text = "left"

                    
                case UISwipeGestureRecognizerDirection.up:
                    appendU(n: 0)
                    label.text = "up"

                    
                default:
                    break
                }
                print("sadf")
        }
    }
    
    func update() {
        if count > 0 {
            count -= 1
        }
        
        if count == 0 {
            performSegue(withIdentifier: "calculateSam", sender: count)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "calculateSam" {
            if let destination = segue.destination as? calculate {
                destination.mTime = mTime
            }
        }
    }
    func playSound1(){
        guard let sound = NSDataAsset(name: "knife") else {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTime = NSDate().timeIntervalSinceReferenceDate
        var _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        sets1()
        sets2()
        sets3()
        label.text = String("______")
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeUp)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
