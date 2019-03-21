//
//  profile.swift
//  Chat1
//
// Show Win/Loss record
// Customize Name and taunt
//

import UIKit

class profile: UIViewController, UITextFieldDelegate {
    let defaults = UserDefaults.standard
    var win = 0
    var loss = 0

    @IBOutlet weak var winLoss: UILabel!
    @IBAction func nameField(_ sender: Any) {
    }
    @IBAction func playerTaunt(_ sender: Any) {
    }
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var playerTaunt: UITextField!
    @IBAction func saveButton(_ sender: UIButton) {
        let saveName = nameField.text
        let saveTaunt = playerTaunt.text
        UserDefaults.standard.set(saveName, forKey: "name")
        UserDefaults.standard.set(saveTaunt, forKey: "taunt")
    }
    
    func textFieldShouldReturn(_ nameField: UITextField) -> Bool {  //closes keyboard when return is pressed
        self.view.endEditing(true)
        return false
    }
    
    func dismissKeyboard() {  //close keyboard when screen is tapped
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //close keyboard functions on return and tap on screen
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)) //tap off screen
        view.addGestureRecognizer(tap)
        self.nameField.delegate = self     //close on return press
        
        //load default name/ taunt if nothing is input.
        if defaults.object(forKey: "name") == nil {
            nameField.text = "Nameless"
            nameField.textColor = UIColor.gray
        }
        else {
            nameField.text = defaults.object(forKey: "name") as? String
            nameField.textColor = UIColor.black
        }
        if defaults.object(forKey: "taunt") == nil {
            playerTaunt.text = "..."
            playerTaunt.textColor = UIColor.gray
        }
        else {
            playerTaunt.text = defaults.object(forKey: "taunt") as? String
            playerTaunt.textColor = UIColor.black
        }
        
        //load w/l ratio
        if defaults.object(forKey: "win") == nil {
            win = 0
        }
        else {
            win = defaults.object(forKey: "win") as! Int
        }
        
        if defaults.object(forKey: "loss") == nil {
            loss = 0
        }
        else {
            loss = defaults.object(forKey: "loss") as! Int
        }
        UserDefaults.standard.set(win, forKey: "win")
        UserDefaults.standard.set(loss, forKey: "loss")
        
        //display w/l
        winLoss.text = "\(win) - \(loss)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
