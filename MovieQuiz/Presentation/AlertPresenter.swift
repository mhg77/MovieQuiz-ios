//
//  Alertpresenter.swift
//  MovieQuiz
//
//  Created by Михаил Асаилов on 01.05.2023.
//

import UIKit

class AlertPresenter {
    private weak var delegate: UIViewController?
    init(delegate: UIViewController) {
        self.delegate = delegate
    }
    
    func show(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default, handler: alertModel.completion)
        alert.addAction(action)
        delegate?.present(alert, animated: true, completion: nil)
    }
}
