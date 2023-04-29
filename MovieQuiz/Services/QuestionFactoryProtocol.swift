//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Михаил Асаилов on 29.04.2023.
//

import Foundation

protocol QuestionFactoryProtocol {
    func requestNextQuestion() -> QuizQuestion?
}
