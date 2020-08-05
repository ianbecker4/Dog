import UIKit
import Foundation


// MARK: - Model
struct Dog: Decodable {
    
    let message: String
    
}

// MARK: - Model Controller
class DogController {
    
    static func fetchImage(searchTerm: String, completion: @escaping (Result<Dog, DogError>)-> Void) {
        
        let breed = searchTerm.lowercased()
        
        guard let baseURL = URL(string: "https://dog.ceo/api/breed/\(breed)/images/random") else {return completion(.failure(.invalidURL))}
        print(baseURL)
        
        URLSession.shared.dataTask(with: baseURL) {data, _, error in
            
            if let error = error {
                print(error, error.localizedDescription)
                return completion(.failure(.thrownError(error)))
                
                guard let data = data else {return completion(.failure(.noData))}
                
                do {
                    let breedImage = try JSONDecoder().decode(Dog.self, from: data)
                    return completion(.success(breedImage))
                } catch {
                    print(error, error.localizedDescription)
                    return completion(.failure(.thrownError(error)))
                }
            }
        }.resume()
    }
}

// MARK: - HelpersAndExtensions
enum DogError: LocalizedError {
    case invalidURL
    case thrownError(Error)
    case noData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The server failed to reach the URL."
        case .thrownError(let error):
            return "There was an error: \(error.localizedDescription)"
        case .noData:
            return "Data failed to load."
        }
    }
}


// MARK: - "View Controller"

DogController.fetchImage(searchTerm: "boxer") { (image) in
    print(image)
}
