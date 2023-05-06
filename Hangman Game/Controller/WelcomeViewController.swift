//
//  WelcomeViewController.swift
//  Hangman Game
//
//  Created by Lilian MAGALHAES on 2023-04-06.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var moviesModeBtn: UIButton!
    @IBOutlet weak var dictionaryModeBtn: UIButton!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var playerNameInput: UITextField!
    @IBOutlet weak var playerEmailInput: UITextField!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var UserDataStackView: UIStackView!
    @IBOutlet weak var changeUserBtn: UIButton!
    @IBOutlet weak var OkWelcomeBtn: UIButton!
    
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        playerNameInput.resignFirstResponder ()
        playerEmailInput.resignFirstResponder ()
    }

    @IBAction func okBtnTapped(_ sender: UIButton) {
        OkWelcomeBtn.isHidden = true
        UserDataStackView.isHidden = true
        changeUserBtn.isHidden = false
        themeLabel.isHidden = false
        moviesModeBtn.isEnabled = true
        dictionaryModeBtn.isEnabled = true
        let playerName = playerNameInput.text ?? "New Player"
        let name = playerName.isEmpty ? "New Player" : playerName
        welcomeLabel.text = "Welcome \(name)!"
        let playerEmail = playerEmailInput.text ?? "newPlayer@newPlayer.com"
        let email = playerEmail.isEmpty ? "newPlayer@newPlayer.com" : playerEmail
        createPlayer(name, _email: email)
    }
    
    
    @IBAction func changeUserBtnIsTapped(_ sender: UIButton) {
        changeUserBtn.isHidden = true
        welcomeLabel.text = ""
        OkWelcomeBtn.isHidden = false
        UserDataStackView.isHidden = false
        moviesModeBtn.isEnabled = false
        dictionaryModeBtn.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeLabel.text = ""
        changeUserBtn.isHidden = true
        themeLabel.isHidden = true
        OkWelcomeBtn.isHidden = false
        UserDataStackView.isHidden = false
        moviesModeBtn.isEnabled = false
        dictionaryModeBtn.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    func createPlayer(_ name: String, _email: String) {
        let player = Player(playerName: name, playerEmail: _email)
        GameStats.shared.save(player: player)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "goToMainTabBar"), object: nil, userInfo: ["name": name])
    }
    

}
