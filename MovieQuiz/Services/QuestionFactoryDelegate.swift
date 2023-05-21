//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Михаил Асаилов on 01.05.2023.
//

import Foundation


protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
