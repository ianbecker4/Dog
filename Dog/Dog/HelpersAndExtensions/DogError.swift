//
//  DogError.swift
//  Dog
//
//  Created by Ian Becker on 8/5/20.
//  Copyright © 2020 Ian Becker. All rights reserved.
//

import Foundation

enum DogError: LocalizedError {
    case invalidURL
    case thrownError(Error)
    case noData
    case unableToDecode
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The server failed to reach the URL."
        case .thrownError(let error):
            return "There was an error: \(error.localizedDescription)"
        case .noData:
            return "Data failed to load."
        case .unableToDecode:
            return "There was an error when loading the data."
        }
    }
}// End of enum
