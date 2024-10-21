//
//  MockRecipeService.swift
//  Fetch Recipes
//
//  Created by Niketan Doddamani on 10/17/24.
//

import Foundation
import UIKit
@testable import Fetch_Recipes

class MockRecipeService: RecipeService {

    
    var result: Result<RecipeCollection, Error>?
    var imageResult: Result<UIImage, Error>?

    
    override func fetchRecipes(from url: String, completion: @escaping (Result<RecipeCollection, Error>) -> Void) {
        print("Mock service: Fetching recipes...")
        if let result = result {
            completion(result)
        }
    }

   
    override func fetchImages(from url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        if let imageResult = imageResult {
            completion(imageResult)
        }
    }
}
