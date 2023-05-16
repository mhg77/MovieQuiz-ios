//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Михаил Асаилов on 16.05.2023.
//

import Foundation

protocol StatisticService{
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
}

final class StatisticServiceImplementation: StatisticService {
    
}
