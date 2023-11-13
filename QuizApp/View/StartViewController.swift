//
//  StartViewController.swift
//  QuizApp
//
//  Created by Atakan Başaran on 10.11.2023.
//

import UIKit

class StartViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var buttonCategory: UIButton!
    @IBOutlet weak var buttonDifficulty: UIButton!
    @IBOutlet weak var buttonStart: UIButton!
    
    
    var categoryNumber = ""
    var difficulty = ""
    var questionList =  [QuestionViewModelItem]()
    
    var categories = [
        ["General Knowledge", "9"],
        ["Film",  "11"],
        ["Music", "12"],
        ["Television", "14"],
        ["Video Games", "15"],
        ["Science & Nature", "17"],
        ["Sports", "21"],
        ["Geography", "22"],
        ["History", "23"],
        ["Mythology", "20"],
        ["Animals", "27"]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        buttonStart.isEnabled = true


    }
    
    override func viewWillAppear(_ animated: Bool) {
        buttonStart.isEnabled = true

    }
    
    //Categories are shown with UIPicker
    @IBAction func categoryButton(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: alertController.view.bounds.width - 16, height: 200))
        pickerView.delegate = self
        pickerView.dataSource = self
        alertController.view.addSubview(pickerView)
        
        let doneAction = UIAlertAction(title: "Select", style: .default) { _ in
            let rowSelected = pickerView.selectedRow(inComponent: 0)
            self.categoryNumber = self.categories[rowSelected][1]
            self.buttonCategory.setTitle("Category: \(self.categories[rowSelected][0])", for: .normal)
        }
        alertController.addAction(doneAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    //Since some of the difficulty levels do not exist in the api, some of difficulties is written same and some is written ""
    @IBAction func difficultyButton(_ sender: Any) {
        
        switch categoryNumber {
            
        case "9":
            chooseDifficulty(easy: "easy", medium: "medium", hard: "medium")
            
        case "11":
            chooseDifficulty(easy: "easy", medium: "easy", hard: "easy")
            
        case "12":
            chooseDifficulty(easy: "easy", medium: "medium", hard: "medium")
            
        case "14":
            chooseDifficulty(easy: "medium", medium: "medium", hard: "medium")
            
        case "15":
            chooseDifficulty(easy: "easy", medium: "medium", hard: "hard")
            
        case "17":
            chooseDifficulty(easy: "easy", medium: "medium", hard: "medium")
            
        case "21":
            chooseDifficulty(easy: "", medium: "", hard: "")
            
        case "22":
            chooseDifficulty(easy: "easy", medium: "medium", hard: "medium")
            
        case "23":
            chooseDifficulty(easy: "easy", medium: "medium", hard: "medium")
            
        case "20":
            chooseDifficulty(easy: "", medium: "", hard: "")
            
        case "27":
            chooseDifficulty(easy: "easy", medium: "easy", hard: "easy")
            
        default:
            self.alertMessage(title: "Error!", message: "Please select category first!")
        }
    
    }
    
    
    //pop-up menu for the difficulty selection
    func chooseDifficulty(easy: String, medium: String, hard: String) {

        let easy = UIAction(title: "Easy") { _ in
            self.difficulty = easy
            self.buttonDifficulty.setTitle("Difficulty: Easy", for: .normal)
        }

        let medium = UIAction(title: "Medium") { _ in
            self.difficulty = medium
            self.buttonDifficulty.setTitle("Difficulty: Medium", for: .normal)
        }

        let hard = UIAction(title: "Hard") { _ in
            self.difficulty = hard
            self.buttonDifficulty.setTitle("Difficulty: Hard", for: .normal)
        }

        let menu = UIMenu(title: "Difficulty", options: .displayInline, children: [hard, medium, easy])
        
        buttonDifficulty.menu = menu
        buttonDifficulty.showsMenuAsPrimaryAction = true
        
        
    }



    //Start the game
    @IBAction func startButton(_ sender: Any) {
        
        buttonStart.isEnabled = false //Cannot be tapped twice
        
        if categoryNumber == "" {
            alertMessage(title: "Error!", message: "Please select category and difficulty!")
            
        } else {
            let url = URL(string: "https://opentdb.com/api.php?amount=10&category=\(self.categoryNumber)&difficulty=\(self.difficulty)&type=boolean")!
            
            WebService().downloadQuestion(url: url) { result in
                
                switch result {
                    
                case .failure(let error):
                    switch error {
                    case .ParseError:
                        print("Parse Error")
                    case .ServerError:
                        print("Server Error")
                    }
                case .success(let listQuestion):
                    self.questionList = listQuestion.results.map { data in
                        return QuestionViewModelItem(
                            category: data.category,
                            difficulty: data.difficulty.rawValue,
                            question: data.question,
                            correctAnswer: data.correctAnswer.rawValue
                        )
                    }
                    if self.questionList.count > 0 {
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "toQuizVC", sender: nil)
                        }
                    } else {
                        print("error")
                        
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toQuizVC" {
            let destinationVC = segue.destination as! QuizViewController
            destinationVC.quizList = self.questionList
        }
        
    }
    
    
    func alertMessage(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okButton)
        present(alertController, animated: true, completion: nil)
    }
    
    //PickerView attributes
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row][0]
    }

}
