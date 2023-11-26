//
//  QuestionSwiftModel.swift
//  QuizApp
//
//  Created by Atakan Başaran on 10.11.2023.
//

import Foundation

//The data is shown in view by mapping the model
struct QuestionViewModelItem {
        
    var category: String
    let difficulty: String
    let question: String
    let correctAnswer: String
}


struct QuestionViewModel {
    
    var quiz: [[String]] = [[]]
    var difficultyNew = ""
    var categoryNew = ""
    var numberQuestion = 0
    var newSentence = ""
    var score = 0
    
    mutating func getQuizList(quizList: [QuestionViewModelItem]) {
        
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
        print("Number of quiz items: \(quiz.count)")

        
        let difficulty = Set(quizList.map {$0.difficulty}) //Mapping to get difficulty level from whole data
        difficultyNew = difficulty.first ?? "" //removing [] and ""
        
        let category = Set(quizList.map {$0.category})  //Mapping to get catefgory from whole data
        categoryNew = category.first ?? ""
        
        //Fixing api data
        let sentence = quiz[numberQuestion][0].replacingOccurrences(of: "&quot;", with: "\"")
        newSentence = sentence.replacingOccurrences(of: "&#039;", with: "'")

 
    }
    
    func getDifficulty() -> String {
        return difficultyNew.capitalized(with: Locale.current)
    }
    
    //Some category names are Entertainment: Film etc. The "Entertainment:" is removed
    func getCategory() -> String {
        let components = categoryNew.components(separatedBy: ":")
        if components.count >= 2 {
            let newCategory = components[1...].joined(separator: ":").trimmingCharacters(in: .whitespaces)
            return newCategory
            
        } else {
            return categoryNew
        }
    }
    
    func getQuestion() -> String {
        return newSentence
    }
    
    mutating func checkAnswer(playerAnswer: String) -> Bool {
        
        let rightAnswer = quiz[numberQuestion][1]
        
        if playerAnswer == rightAnswer {
            score += 1
            return true
            
        } else {
            return false
        }
     
    }
    
    func getScore() -> Int {
        return score
    }
    
    func getProgress() -> Float {
        return Float(numberQuestion) / Float(quiz.count)
    }
    
    mutating func nextQuestion() -> Bool {
       
       if numberQuestion + 1 < quiz.count {
           numberQuestion += 1
           return true
       } else {
           numberQuestion = 0
           return false
       }
   }
    
    func getQuestionNo() -> Int {
        return numberQuestion
    }
    
    mutating func playAgain() {
        numberQuestion = 0
        score = 0
    }
    
    
    
    
    
    
    
}
