//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Михаил Асаилов on 23.05.2023.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func highlightImageBorder(isCorrect: Bool)
    func clearImageBorder()
    func enableUserInteraction()
    func disableUserInteraction()
}
