//
//  MovieQuizPresenterTests.swift
//  MovieQuizTests
//
//  Created by Михаил Асаилов on 23.05.2023.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func enableUserInteraction() {}
    func disableUserInteraction() {}
    func show(quiz step: MovieQuiz.QuizStepViewModel) {}
    func showLoadingIndicator() {}
    func hideLoadingIndicator() {}
    func highlightImageBorder(isCorrect: Bool) {}
    func clearImageBorder() {}
}

final class MovieQuizPresenterTests: XCTestCase {
    
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Test", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.imageData)
        XCTAssertEqual(viewModel.question, "Test")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
