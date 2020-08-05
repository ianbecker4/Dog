//
//  DogViewController.swift
//  Dog
//
//  Created by Ian Becker on 8/5/20.
//  Copyright © 2020 Ian Becker. All rights reserved.
//

import UIKit

class DogViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var dogSearchBar: UISearchBar!
    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var dogLabel: UILabel!
    
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dogSearchBar.delegate = self
    }
    
    // MARK: - Private Methods
    private func fetchImageAndUpdateViews(for dog: Dog) {
        
        DogController.fetchImage(for: dog) { [weak self] (result) in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self?.dogImageView.image = image
                    self?.dogLabel.text = "\(self?.dogSearchBar.text ?? "")"
                case .failure(let error):
                    self?.presentErrorToUser(localizedError: error)
                }
            }
        }
    }
}

// MARK: - UISearchBarDelegate
extension DogViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else {return}
        
        DogController.fetchDog(searchTerm: searchTerm) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let dog):
                    self?.fetchImageAndUpdateViews(for: dog)
                case .failure(let error):
                    self?.presentErrorToUser(localizedError: error)
                }
            }
        }
    }
}
