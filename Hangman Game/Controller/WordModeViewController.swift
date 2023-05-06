//
//  WordModeViewController.swift
//  Hangman Game
//
//  Created by Lilian MAGALHAES on 2023-04-18.
//

import UIKit

class WordModeViewController: UIViewController {
    
    @IBOutlet var KeyboardButtons: [UIButton]!
    ///label tag components:
    @IBOutlet weak var wordLabelContainer: UIStackView!
    @IBOutlet weak var correctTriesLabel: UILabel!
    @IBOutlet weak var missedTriesLabel: UILabel!
    
    @IBOutlet var hangmanImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var wordLabelTest: UILabel!  //TODO: Label to test if we got the film title, delete after finished testing the game.
    @IBOutlet weak var newWordGameButton: UIButton!
    
    let message: String = ""
    var currentGameMissedTries: Int = 0
    var currentGameTries = 0
    var correctLettersGuessed = 0
    
    let data: Data = Data()
    var validString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordLabelTest.textColor = UIColor.clear
        ///target and action for each keyboard button
        KeyboardButtons.forEach { button in
            button.addTarget(self, action: #selector(keyboardButtonTapped(_:)), for: .touchUpInside)
        }
        startApp()
    }
    
    private func startApp () {
        self.toggleActivityIndicator(shown: true)
        getNewWord()
    }
    
    private func resetScores() {
        currentGameMissedTries  = 0
        currentGameTries = 0
        correctLettersGuessed = 0
        updateMissedLabel(missedTries: currentGameMissedTries)
        updateCorrectLabel(correctTries: correctLettersGuessed)
        wordLabelContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    @IBAction func PlayNewWordGame(_ sender: Any) {
        getNewWord()
        KeyboardButtons.forEach { button in
            button.backgroundColor = UIColor(red: 230/256, green: 231/256, blue: 180/256, alpha: 1)
            button.isEnabled = true
        }
    }
    
    
   
    func getNewWord() {
        validString = ""
        let imageName = "Hang00"
        let image = UIImage(named: imageName)
        hangmanImage.image = image
        
        self.toggleActivityIndicator(shown: true)
        WordManager.shared.getWord() { (success, data) in
            self.toggleActivityIndicator(shown: false)
            guard let data = data, success == true else {
                self.presentAlert()
                return
            }
            if let stringData = String(data: data, encoding: .utf8) {
                let word = stringData
                self.validString = self.getValidWordString(word: word)
                if self.validString.count > 16 {
                    self.startApp()
                }
                else {
                    DispatchQueue.main.async {
                        self.wordLabelTest.text = self.validString.uppercased()
                        self.resetScores()
                        self.createWordLabel(word: self.validString.uppercased())
                    }
                }
            }
        }
    }
          
    
    private func getValidWordString(word: String) -> String {
            let originalString = word
            validString = originalString.replacingOccurrences(of: "[", with: "")
                                                       .replacingOccurrences(of: "]", with: "")
                                                       .replacingOccurrences(of: "\"", with: "")
        return validString
        }
    
        private func toggleActivityIndicator(shown: Bool) {
            newWordGameButton.isHidden = shown
            activityIndicator.isHidden = !shown
        }
        
        private func updateGameMissedTries() {
            if currentGameMissedTries < 6 {
                currentGameMissedTries += 1
                print(currentGameMissedTries)
                updateGame(missedTries: currentGameMissedTries)
                updateMissedLabel(missedTries: currentGameMissedTries)
            }
            updateGame(missedTries: currentGameMissedTries)
        }
        
        func updateMissedLabel(missedTries: Int){
            missedTriesLabel.text = "\(missedTries)/6"
        }
        
        private func updateScore() {}
        
        private func updateGame(missedTries: Int) {
            var imageName: String = ""
            print("missed Letters: \(missedTries)")
            switch missedTries {
            case 1:
                imageName = "Hang01.png"
            case 2:
                imageName = "Hang02.png"
            case 3:
                imageName =  "Hang03.png"
            case 4:
                imageName =  "Hang04.png"
            case 5:
                imageName = "Hang05.png"
            case 6:
                imageName =  "Hang06.png"
                presentAlertGameStatus(message: "Game is Over")
                finishGame()
            default:
                print ("error reading missed tries")
            }
            let image = UIImage(named: imageName)
            hangmanImage.image = image
        }
        
        private func finishGame() {
            KeyboardButtons.forEach { button in
                button.isEnabled = false
            }
        }
        
        @IBAction func keyboardButtonTapped(_ sender: UIButton) {
            currentGameTries += 1
            print("Total of Tries: \(currentGameTries)")
            var tappedLetter: String
            if let buttonText = sender.titleLabel?.text?.uppercased() {
                sender.backgroundColor = UIColor.clear
                sender.isEnabled = false
                tappedLetter = buttonText.uppercased()
                let doesLetterExists = containsLetter(letter: tappedLetter)
                if doesLetterExists == true {
                    let  numberCorrectLettters = countCorrectLetters(letter: tappedLetter)
                    showLetters(letter: tappedLetter)
                    correctLettersGuessed += numberCorrectLettters
                    print("correct Letters: \(correctLettersGuessed)")
                    updateCorrectLabel(correctTries: correctLettersGuessed)
                }
                else {
                    updateGameMissedTries()
                }
            }
        }
        
        func containsLetter(letter: String) -> Bool {
            let currentWord = validString.uppercased()
            return currentWord.contains(letter)
        }
        
        var numberOfLetters: Int!
        private func countCorrectLetters(letter: String) -> Int {
            validString = validString.uppercased()
            if let firstCharacter = letter.first {
                let selectedLetter = firstCharacter
                numberOfLetters = validString.filter { $0 == selectedLetter }.count
            }
            print("number of letters: \(String(describing: numberOfLetters))")
            return numberOfLetters
        }
        
        private func showLetters(letter: String){
            if let wordLabelContainer = wordLabelContainer {
                for i in 0..<wordLabelContainer.arrangedSubviews.count {
                    let stackCharContainer = wordLabelContainer.arrangedSubviews[i]
                    if let charLabel = stackCharContainer.subviews.first as? UILabel, charLabel.text?.uppercased() == letter {
                        charLabel.textColor = UIColor.white //(red: 200/256, green: 111/256, blue: 180/256, alpha: 1)
                    }
                    print("charLabelText: \(String(describing: (stackCharContainer.subviews.first as? UILabel)?.text))")
                    print("letter: \(letter)")
                }
            }
        }
        
        private func updateCorrectLabel(correctTries: Int) {
            let numberValidCharacters = validString .count
            correctTriesLabel.text = "\(correctTries)/\(numberValidCharacters)"
            if correctTries == numberValidCharacters {
                presentAlertGameStatus(message: "Congratulations!")
                finishGame()
            }
        }
    
        
        private func presentAlert() {
            let alertVC = UIAlertController(title: "Error", message: "Could not find data.", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alertVC, animated: true, completion: nil)
        }
        
        func presentAlertGameStatus(message: String) {
            let alertVC = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alertVC, animated: true, completion: nil)
        }
        
        private func createWordLabel(word: String) {
            wordLabelContainer.axis = .horizontal // Set the axis to horizontal for a horizontal stack view
            wordLabelContainer.alignment = .center // Set the alignment to center for the stack view
            wordLabelContainer.spacing = 10 // Set the spacing between labels
            let wordString = word
            wordString.forEach { char in
                let stackCharContainer = UIStackView()
                stackCharContainer.axis = .vertical
                stackCharContainer.alignment = .center // Set the alignment to center for the stack view
                stackCharContainer.spacing = -12
                let guideLabel = UILabel()
                let charLabel = UILabel()
                if char == " " {
                    guideLabel.text = "" // Display empty string for empty spaces
                    charLabel.text = ""
                } else {
                    guideLabel.text = "_" // Display "_" for other characters
                    charLabel.text = String(char.uppercased()) // Convert character to string and set as text
                }
                guideLabel.font = UIFont(name: "Chalkduster", size: 20)
                charLabel.font = UIFont(name: "Chalkduster", size: 20)
                guideLabel.textAlignment = .center // Center align the guide label's text
                charLabel.textAlignment = .center // Center align the character label's text
                guideLabel.textColor = UIColor(red: 230/256, green: 231/256, blue: 180/256, alpha: 1)
                charLabel.textColor = UIColor.clear
                stackCharContainer.addArrangedSubview(charLabel)
                stackCharContainer.addArrangedSubview(guideLabel)
                
                wordLabelContainer.addArrangedSubview(stackCharContainer) // Add stackCharContainer to the titleLabelContainer
            }
        }
    }

