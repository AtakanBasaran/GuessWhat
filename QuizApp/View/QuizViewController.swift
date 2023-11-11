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
    
    var quizList =  [QuestionViewModelItem]()
    var numberQuestion = 0
    var quiz: [[String]] = [[]]
    var score = 0
    var progressNumber = 0.0 //For progressBar


    override func viewDidLoad() {
        super.viewDidLoad()
        
        rePlay.isHidden = true
        
        let questionArray = quizList.map {$0.question} //mapping to only get questions from whole data
        let answerArray = quizList.map {$0.correctAnswer} //mapping to only get answers from whole data
        //creating 2D array to paire questions and its answers
        quiz = [
            [questionArray[0], answerArray[0]],
            [questionArray[1], answerArray[1]],
            [questionArray[2], answerArray[2]],
            [questionArray[3], answerArray[3]],
            [questionArray[4], answerArray[4]],
            [questionArray[5], answerArray[5]],
            [questionArray[6], answerArray[6]],
            [questionArray[7], answerArray[7]],
            [questionArray[8], answerArray[8]],
            [questionArray[9], answerArray[9]]
            ]
        
        
        let difficulty = Set(quizList.map {$0.difficulty}) //Mapping to get difficulty level from whole data
        let category = Set(quizList.map {$0.category})  //Mapping to get catefgory from whole data
        
        let difficultyNew = difficulty.first ?? "" //removing [] and ""
        let categoryNew = category.first ?? ""
        
        let categoryLabel = UILabel()
        categoryLabel.text = "\(categoryNew)"
        categoryLabel.textColor = .white
        categoryLabel.font = .boldSystemFont(ofSize: 18)
        categoryLabel.sizeToFit()
        self.navigationItem.titleView = categoryLabel
        
        let difficultyLabel = UILabel()
        difficultyLabel.text = "\(difficultyNew.capitalized(with: Locale.current))"
        difficultyLabel.textColor = .white
        difficultyLabel.font = .boldSystemFont(ofSize: 18)
        
        let barButonLabel = UIBarButtonItem(customView: difficultyLabel)
        self.navigationItem.rightBarButtonItem = barButonLabel
        
        //Fixing api data
        let sentence = quiz[numberQuestion][0].replacingOccurrences(of: "&quot;", with: "\"")
        let newSentence = sentence.replacingOccurrences(of: "&#039;", with: "'")
        questionText.text = newSentence
        questionText.textAlignment = .left
        progressBar.progress = Float(progressNumber)
        questionNumber.text = "Q: \(numberQuestion + 1)"
        
        scoreLabel.text = "Score: \(score)"
        
    }
    

    @IBAction func answerButton(_ sender: UIButton) {
        numberQuestion += 1
        progressNumber += 0.1

        if numberQuestion == 10 {
            questionNumber.text = "Q: \(numberQuestion)"
            questionText.textAlignment = .center
            questionText.text = "Game Over"
            scoreLabel.text = "Score: \(score)"
            buttonTrue.isHidden = true
            buttonFalse.isHidden = true
            rePlay.isHidden = false
            progressBar.progress = Float(progressNumber)

        } else {
            let sentence = quiz[numberQuestion][0].replacingOccurrences(of: "&quot;", with: "\"")
            let newSentence = sentence.replacingOccurrences(of: "&#039;", with: "'")
            questionText.text = newSentence
            questionText.textAlignment = .left
            progressBar.progress = Float(progressNumber)
            questionNumber.text = "Q: \(numberQuestion + 1)"


            //Answering correct or false
            if sender.currentTitle == quiz[numberQuestion][1] {
                score += 1
                scoreLabel.text = "Score: \(score)"
                showResultLabel(isCorrect: true)
                
            } else {
                showResultLabel(isCorrect: false)
            }
        }
    }
    
    //Resetting the game
    @IBAction func playAgain(_ sender: Any) {
        
        buttonTrue.isHidden = false
        buttonFalse.isHidden = false
        rePlay.isHidden = true
        numberQuestion = 0
        score = 0
        progressNumber = 0.0
        progressBar.progress = Float(progressNumber)
        questionNumber.text = "Q: \(numberQuestion + 1)"

        let sentence = quiz[numberQuestion][0].replacingOccurrences(of: "&quot;", with: "\"")
        let newSentence = sentence.replacingOccurrences(of: "&#039;", with: "'")
        questionText.text = newSentence
        questionText.textAlignment = .left
        
        scoreLabel.text = "Score: \(score)"
        
    }
    
    func showResultLabel(isCorrect: Bool) {
        
        let resultLabel = UILabel()
        resultLabel.font = .boldSystemFont(ofSize: 21)
        resultLabel.textAlignment = .center
        resultLabel.textColor = isCorrect ? .green : .red
        resultLabel.text = isCorrect ? "Correct!" : "Wrong!"
        
        view.addSubview(resultLabel)
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let yOffset: CGFloat = 50.0 //50 pixels below the center
        NSLayoutConstraint.activate([
            resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yOffset)
        ])
        
        //Duration of the animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.animate(withDuration: 0.30, animations: {
                resultLabel.alpha = 0
            }, completion: { _ in
                resultLabel.removeFromSuperview()
            })
        }
        
    }
    
    
}

