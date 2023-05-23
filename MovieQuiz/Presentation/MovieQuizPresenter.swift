//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Михаил Асаилов on 22.05.2023.
//

import UIKit

final class MovieQuizPresenter {
    
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?
    private weak var viewController: MovieQuizViewControllerProtocol?
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex: Int = 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticServiceImplementation()
        viewController.showLoadingIndicator()
        questionFactory?.loadData()
        alertPresenter = AlertPresenter(delegate: viewController)
    }
    
    private var isLastQuestions: Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    private func proceedWithAnswer(isCorrect: Bool) {
        viewController?.disableUserInteraction()
        viewController?.highlightImageBorder(isCorrect: isCorrect)
        
        if isCorrect {
            correctAnswers += 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            
            self.showNextQuestionOrResults()
            self.viewController?.enableUserInteraction()
        }
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = isYes
        
        proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.viewController?.show(quiz: viewModel)
            self.viewController?.clearImageBorder()
        }
    }
    
    private func getResultMessage() -> String {
        guard let statisticService = statisticService else { return "" }
        
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        
        let text = """
                   Ваш результат: \(correctAnswers)/\(questionsAmount)
                   Количество сыгранных квизов: \(statisticService.gamesCount)
                   Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
                   Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
                   """
        return text
    }
    
    private func showResult() {
        
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: getResultMessage(),
            buttonText: "Сыграть еще раз") { [weak self] _ in
                guard let self = self else { return }
                
                self.resetQuestionIndex()
                self.correctAnswers = 0
                
                questionFactory?.requestNextQuestion()
            }
        alertPresenter?.show(alertModel: alertModel)
    }
    
    private func showNextQuestionOrResults() {
        
        if isLastQuestions {
            showResult()
        } else {
            switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func showNetworkError(message: String) {
        viewController?.hideLoadingIndicator()
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать ещё раз") { [weak self] _ in
            guard let self = self else { return }
            
            self.resetQuestionIndex()
            self.correctAnswers = 0
            
            self.questionFactory?.loadData()
        }
        alertPresenter?.show(alertModel: model)
    }
}

extension MovieQuizPresenter: QuestionFactoryDelegate {
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
}
