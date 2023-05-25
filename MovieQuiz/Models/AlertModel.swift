//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Михаил Асаилов on 01.05.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)?
}
