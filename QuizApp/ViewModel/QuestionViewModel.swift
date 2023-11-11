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
