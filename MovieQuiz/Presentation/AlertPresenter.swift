//
//  Alertpresenter.swift
//  MovieQuiz
//
//  Created by Михаил Асаилов on 01.05.2023.
//

import UIKit

class AlertPresenter {
    private weak var delegate: MovieQuizViewControllerProtocol?
    
    init(delegate: MovieQuizViewControllerProtocol) {
        self.delegate = delegate
    }
    
    func show(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        
        alert.view.accessibilityIdentifier = "Game results"
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            alertModel.completion?()
        }
        alert.addAction(action)
        if let vc = delegate as? UIViewController {
            vc.present(alert, animated: true, completion: nil)
        }
    }
}
