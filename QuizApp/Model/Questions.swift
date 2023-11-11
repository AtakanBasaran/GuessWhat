//
//  Questions.swift
//  QuizApp
//
//  Created by Atakan Başaran on 10.11.2023.
//

import Foundation

// MARK: - Questions
struct Questions: Codable {
    let responseCode: Int
    let results: [Result]

    enum CodingKeys: String, CodingKey {
        case responseCode = "response_code"
        case results
    }
}

// MARK: - Result
struct Result: Codable {
    let category: String  
    let type: TypeEnum
    let difficulty: Difficulty
    let question: String
    let correctAnswer: CorrectAnswer
    let incorrectAnswers: [CorrectAnswer]

    enum CodingKeys: String, CodingKey {
        case category, type, difficulty, question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
}

enum CorrectAnswer: String, Codable {
    case correctAnswerFalse = "False"
    case correctAnswerTrue = "True"
}

enum Difficulty: String, Codable {
    case easy
    case medium
    case hard
}

enum TypeEnum: String, Codable {
    case boolean = "boolean"
}
