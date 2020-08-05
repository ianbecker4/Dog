//
//  DogController.swift
//  Dog
//
//  Created by Ian Becker on 8/5/20.
//  Copyright © 2020 Ian Becker. All rights reserved.
//

import Foundation
import UIKit

class DogController {
    
    static func fetchDog(searchTerm: String, completion: @escaping (Result<Dog, DogError>) -> Void) {
        
        let breed = searchTerm.lowercased()
        
        guard let url = URL(string: "https://dog.ceo/api/breed/\(breed)/images/random") else {return completion(.failure(.invalidURL))}
        print(url)
        
        URLSession.shared.dataTask(with: url) {data, _, error in
            
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else {return completion(.failure(.noData))}
            
            do {
                let dog = try JSONDecoder().decode(Dog.self, from: data)
                return completion(.success(dog))
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    static func fetchImage(for dog: Dog, completion: @escaping (Result<UIImage, DogError>) -> Void) {
        
        guard let imageURL = URL(string: dog.message) else {return completion(.failure(.invalidURL))}
        
        URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
            
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else {return completion(.failure(.noData))}
            
            guard let breedImage = UIImage(data: data) else {return completion(.failure(.unableToDecode))}
            
            completion(.success(breedImage))
            
        }.resume()
    }
}// End of class
