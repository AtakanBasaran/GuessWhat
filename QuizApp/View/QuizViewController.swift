//
//  ViewController.swift
//  QuizApp
//
//  Created by Atakan Başaran on 10.11.2023.
//

import UIKit

class QuizViewController: UIViewController {
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var questionText: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var buttonTrue: UIButton!
    @IBOutlet weak var buttonFalse: UIButton!
    @IBOutlet weak var rePlay: UIButton!
    @IBOutlet weak var questionNumber: UILabel!
    

    var questionViewModel = QuestionViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rePlay.isHidden = true
   
        
        let categoryLabel = UILabel()
        categoryLabel.text = questionViewModel.getCategory()
        categoryLabel.textColor = .white
        categoryLabel.font = .boldSystemFont(ofSize: 20)
        categoryLabel.sizeToFit()
        self.navigationItem.titleView = categoryLabel
        
        let difficultyLabel = UILabel()
        difficultyLabel.text = questionViewModel.getDifficulty()
        difficultyLabel.textColor = .white
        difficultyLabel.font = .boldSystemFont(ofSize: 20)
        
        let barButonLabel = UIBarButtonItem(customView: difficultyLabel)
        self.navigationItem.rightBarButtonItem = barButonLabel
        
        questionViewModel.updateSentence()
        uptadeUI()
        questionText.textAlignment = .left
        

    }
    
    
    @IBAction func answerButton(_ sender: UIButton) {
        
        // Answering correct or false
        if let playerAnswer = sender.currentTitle {
            let boolAnswer = questionViewModel.checkAnswer(playerAnswer: playerAnswer)
            if boolAnswer == true {
                sender.setTitleColor(.green, for: .normal)
                showResultLabel(isCorrect: true)
                scoreLabel.text = "Score: \(questionViewModel.getScore())"
            } else {
                showResultLabel(isCorrect: false)
                sender.setTitleColor(.red, for: .normal)
            }
        }
        
        //Next Question
        let boolQuestion = questionViewModel.nextQuestion()
        
        if boolQuestion == true {
            questionText.text = questionViewModel.getQuestion()
            questionText.textAlignment = .left
            progressBar.progress = questionViewModel.getProgress()
            questionNumber.text = "Q: \(questionViewModel.getQuestionNo() + 1)"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { //clear the title color for the next question
                sender.setTitleColor(.white, for: .normal)
            }
        } else { //After last question
            questionNumber.text = "Q: \(questionViewModel.getQuestionNo())"
            questionText.textAlignment = .center
            questionText.text = "Game Over"
            scoreLabel.text = "Score: \(questionViewModel.getScore())"
            buttonTrue.isHidden = true
            buttonFalse.isHidden = true
            rePlay.isHidden = false
            progressBar.progress = 0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { //clear the title color for the next question
                sender.setTitleColor(.white, for: .normal)
            }
        }
    }
    
    func uptadeUI() {
        progressBar.progress = questionViewModel.getProgress()
        questionNumber.text = "Q: \(questionViewModel.getQuestionNo() + 1)"
        questionText.text = questionViewModel.getQuestion()
        scoreLabel.text = "Score: \(questionViewModel.getScore())"
 
    }
    
    //Reset the game
    @IBAction func playAgain(_ sender: Any) {
        
        questionViewModel.playAgain()
        
        buttonTrue.isHidden = false
        buttonFalse.isHidden = false
        rePlay.isHidden = true
        uptadeUI()
        questionText.textAlignment = .left
        
        
    }
    
    func showResultLabel(isCorrect: Bool) {
        
        let resultLabel = UILabel()
        resultLabel.font = .boldSystemFont(ofSize: 22)
        resultLabel.textAlignment = .center
        resultLabel.textColor = isCorrect ? .green : .red
        resultLabel.text = isCorrect ? "Correct!" : "Wrong!"
        
        view.addSubview(resultLabel)
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let yOffset: CGFloat = 28.0 //50 pixels below the center
        NSLayoutConstraint.activate([
            resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yOffset)
        ])
        
        //Duration of the animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            UIView.animate(withDuration: 0.40, animations: {
                resultLabel.alpha = 0
            }, completion: { _ in
                resultLabel.removeFromSuperview()
            })
        }
        
    }
    
    
}

