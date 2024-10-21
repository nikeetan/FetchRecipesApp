//
//  RecipeService.swift
//  Fetch Recipes
//
//  Created by Niketan Doddamani on 10/13/24.
//

import Foundation
import SwiftUI

class RecipeService : ObservableObject {
    func fetchRecipes(from url: String,completion: @escaping (Result<RecipeCollection, Error>) -> Void)
    {
        
        // Lets Ensure the Url i have passed as a parameter can be converted into valid URL if yes then we will move to further steps else throw the error saying invalid URL
        
        guard let url = URL(string: url) else {
            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data , urlResponse , error  in
            if let error = error
            {
                
                completion(.failure(error))
                return
            }
            // Ensuring the data exists and is valid
            guard let data else {
                
                let error = NSError(domain: "No Data", code: 0, userInfo: nil)
                completion(.failure(error))
                return
            }
            do
            {
                let jsonDecoder = JSONDecoder()
                let decodedRecipes = try jsonDecoder.decode(RecipeCollection.self, from: data)
                completion(.success(decodedRecipes))
            }catch {
                let customError = NSError(domain: "Decoding Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to load recipes due to malformed data."])
                completion(.failure(customError))
                
            }
            
        }
        task.resume() // Here we are ensuring the network task to get started
    }
    
    func fetchImages(from url: String, completion: @escaping (Result<UIImage, Error>)->Void)
    {
        guard let url = URL(string: url) else {
            let error = NSError(domain: "Invalid Image URL", code: 0, userInfo: nil)
            completion(.failure(error))
            return
        }
        
        // Start the network task
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Ensure valid data is received
            guard let data = data, let image = UIImage(data: data) else {
                let error = NSError(domain: "No Image Data", code: 0, userInfo: nil)
                completion(.failure(error))
                return
            }
            
            // Success: return the downloaded image
            completion(.success(image))
        }
        task.resume()
    }
}
        


        

