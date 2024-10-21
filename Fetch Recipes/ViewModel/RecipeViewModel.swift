//
//  Untitled.swift
//  Fetch Recipes
//
//  Created by Niketan Doddamani on 10/13/24.
//
import Foundation
import SwiftUI

class RecipeViewModel: ObservableObject {
    
    @Published var recipes: [RecipeCollection.Recipe] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    // This creates the flexibility to invoke the recipeservice e
    private var recipeService: RecipeService
        
        init(recipeService: RecipeService = RecipeService()) {
            self.recipeService = recipeService
        }
        
    //private var recipeService = RecipeService()
    
    // Fetch recipes from a URL
    func fetchRecipes(from url: String) {
        isLoading = true
        errorMessage = nil
        
        recipeService.fetchRecipes(from: url) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let recipeCollection):
                    //print("Success:",url)
                    if recipeCollection.recipes.isEmpty {
                        self?.errorMessage = "No recipes available at the moment. Please try again later."
                        self?.recipes = []
                    }
                    else
                    {
                        let validRecipes = recipeCollection.recipes.filter { recipe in
                            return !recipe.cuisine.isEmpty &&
                            !recipe.name.isEmpty &&
                            !recipe.uuid.isEmpty &&
                            !recipe.photoUrlLarge.isEmpty &&
                            !recipe.photoUrlSmall.isEmpty
                        }
                        if validRecipes.count != recipeCollection.recipes.count
                        {
                            self?.errorMessage = "Some recipes are missing information. Please try again later."
                            self?.recipes = []
                        }
                        else
                        {
                            self?.recipes = validRecipes
                        }
                    }
                case .failure(let error):
                    //print("Fail:",url)
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func loadImage(for recipe: RecipeCollection.Recipe) {
        recipeService.fetchImages(from: recipe.photoUrlLarge) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    ImageCache.shared.saveImage(image, forKey: recipe.photoUrlLarge)
                    self?.objectWillChange.send() // Notify the view of changes
                case .failure(let error):
                    self?.errorMessage = "Failed to load image"
                }
            }
        }
    }
}
        
        
  
