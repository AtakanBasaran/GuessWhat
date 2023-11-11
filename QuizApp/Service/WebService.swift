//
//  WebService.swift
//  QuizApp
//
//  Created by Atakan Başaran on 10.11.2023.
//

import Foundation

enum questionError: Error {
    case ParseError
    case ServerError
}


class WebService {
    
    func downloadQuestion(url: URL, completion: @escaping(Swift.Result <Questions, questionError>) -> () ) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(questionError.ServerError))
                print(error.localizedDescription)
            } else if let data = data {
                if let questionList = try? JSONDecoder().decode(Questions.self, from: data) {
                    completion(.success(questionList))
                } else {
                    completion(.failure(questionError.ParseError))
                }
                    
            }
        }.resume()
        
        
    }
    
    
    
    
}
