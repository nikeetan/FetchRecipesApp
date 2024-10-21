//
//  Fetch_RecipesTests.swift
//  Fetch RecipesTests
//
//  Created by Niketan Doddamani on 10/8/24.
//

import XCTest
@testable import Fetch_Recipes


final class Fetch_RecipesTestsTests : XCTestCase{
    
    func testFetchRecipesSucess() {
        
        
        // So here we are checking the execution of the function without making the necessary network call and we check when the case is succeds the functions records the necessary information or not

        // Arrange: Use a few representative recipes
        let mockRecipes = RecipeCollection(recipes: [
            RecipeCollection.Recipe(
                
                cuisine: "Malaysian",
                name: "Apam Balik",
                photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                sourceUrl: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                youtubeUrl: "https://www.youtube.com/watch?v=6R8ffRRJcrg"
                
            )
        ])
        
        let mockService = MockRecipeService()
        mockService.result = .success(mockRecipes)
        
        // Act: Fetch recipes
        mockService.fetchRecipes(from: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json") { result in
            // Assert: Validate success result
            switch result {
            case .success(let recipeCollection):
                XCTAssertEqual(recipeCollection.recipes.first?.name, "Apam Balik")
            case .failure:
                XCTFail("Expected success, but got failure")
            }
        }
    }
    func testFetchRecipesFailure()
    {
        
        // for checking of the invalid URL
        
        // Arrange
        let recipeService = RecipeService()
        let url = "http//examplecom"
        
        // Act
        recipeService.fetchRecipes(from: url)
        { result in
        
            // Assert
            
            switch result {
            case .failure(let error):
                XCTAssertEqual((error as NSError).domain, "Invalid URL")
            case .success:
                XCTFail("Should not have succeeded")    }
        }
        
    }
    func testFetchRecipesNodata()
    {
        // for No data From the end point
        
        //Arrange
        let mockService = MockRecipeService()
        let error = NSError(domain: "No Data", code: 0, userInfo: nil)
        let url = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
        mockService.result = .failure(error)
        //Act
        mockService.fetchRecipes(from: url)
        { result in
            
            
            switch result {
            case .failure(let error):
                XCTAssertEqual((error as NSError).domain, "No Data")
            case .success:
                XCTFail("Should not have succeeded")
            }
        }
    }
    func testFetchRecipesDecodingError()
    {
        // Arrange: Create the mock service and simulate decoding error
            let mockService = MockRecipeService()
            let error = NSError(domain: "Decoding Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to load recipes due to malformed data."])
            mockService.result = .failure(error)
            
            // Act: Fetch recipes
            mockService.fetchRecipes(from: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json") { result in
                // Assert: Validate failure result
                switch result {
                case .success:
                    XCTFail("Expected failure, but got success")
                case .failure(let error):
                    XCTAssertEqual((error as NSError).domain, "Decoding Error")
                    XCTAssertEqual((error as NSError).localizedDescription, "Failed to load recipes due to malformed data.")
                }
            }
    }

    func testFetchImagesInvalidURL() {
        // Arrange: Create the mock service
        let mockService = MockRecipeService()
        
        // Act: Fetch image with an invalid URL
        mockService.fetchImages(from: "http//examplecom") { result in
            // Assert: Validate failure result
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual((error as NSError).domain, "Invalid Image URL")
            }
        }
    }
    
    func testFetchImageSuccess() {
            // Arrange: Create a mock image
        
        // Creating the system generated image and passing that as a argument inorder to evaluate the test case
        let size = CGSize(width: 1, height: 1)
           UIGraphicsBeginImageContext(size)
           let mockImage = UIGraphicsGetImageFromCurrentImageContext()!
           UIGraphicsEndImageContext()
        
        let mockService = MockRecipeService()
        mockService.imageResult = .success(mockImage)
        
        // Act: Fetch image
        mockService.fetchImages(from: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg") { result in
            // Assert: Validate success result
            switch result {
            case .success(let image):
                XCTAssertEqual(image, mockImage)
            case .failure:
                XCTFail("Expected success, but got failure")
            }
        }
    }
    
    func testFetchImageNodata()
    {
        // for No data From the end point
        
        //Arrange
        let mockService = MockRecipeService()
        let error = NSError(domain: "No Image Data", code: 0, userInfo: nil)
        let url = "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg"
        mockService.result = .failure(error)
        //Act
        mockService.fetchImages(from: url)
        { result in
            
            
            switch result {
            case .failure(let error):
                XCTAssertEqual((error as NSError).domain, "No Image Data")
            case .success:
                XCTFail("Should not have succeeded")
            }
        }
    }

    // Till here I have completed the testing of the RecipeService now proceeding with the further testing of RecipeViewModel
    
    func testViewModelFetchRecipesSuccess() {
        // Arrange
        let mockRecipes = RecipeCollection(recipes: [
            RecipeCollection.Recipe(
                cuisine: "Malaysian",
                name: "Apam Balik",
                photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                sourceUrl: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                youtubeUrl: "https://www.youtube.com/watch?v=6R8ffRRJcrg"
            )
        ])
        
        let mockService = MockRecipeService()
        mockService.result = .success(mockRecipes)
        
        let viewModel = RecipeViewModel(recipeService: mockService)
        
        // Create an expectation to wait for async updates
        let expectation = self.expectation(description: "Recipes are fetched and updated in the ViewModel")
        
        // Act: Fetch recipes
        viewModel.fetchRecipes(from: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")
        
        
        // Add a delay to let the async update occur
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Assert: Check the ViewModel's state
            XCTAssertFalse(viewModel.isLoading, "ViewModel should have finished loading")
            XCTAssertEqual(viewModel.recipes.count, 1, "There should be 1 recipe")
            XCTAssertEqual(viewModel.recipes.first?.name, "Apam Balik", "The first recipe's name should be 'Apam Balik'")
            expectation.fulfill()  // Mark the expectation as fulfilled
        }
        
        // Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("Expectation failed: \(error)")
            }
        }
    }
    

    
    func testViewModelFetchRecipesFailure() {
        // Arrange
        let mockService = MockRecipeService()
        // Set the mock service to return a failure result
        let error = NSError(domain: "TestError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch recipes"])
        mockService.result = .failure(error)
        
        let viewModel = RecipeViewModel(recipeService: mockService)
        
        // Create an expectation to wait for async updates
        let expectation = self.expectation(description: "Fetching recipes fails and updates ViewModel with an error")
        
        // Act: Fetch recipes
        viewModel.fetchRecipes(from: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")
        
        // Add a delay to let the async update occur
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Assert: Check the ViewModel's state after failure
            XCTAssertFalse(viewModel.isLoading, "ViewModel should have finished loading")
            XCTAssertEqual(viewModel.recipes.count, 0, "There should be 0 recipes")
            XCTAssertEqual(viewModel.errorMessage, "Failed to fetch recipes", "Error message should match the mock error")
            expectation.fulfill()  // Mark the expectation as fulfilled
        }
        
        // Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("Expectation failed: \(error)")
            }
        }
    }

    
    
    func testViewModelLoadImageSuccess() {
        // Arrange
        let mockService = MockRecipeService()
        
        // Set the mock service to return a success result with a mock image
        let size = CGSize(width: 1, height: 1)
           UIGraphicsBeginImageContext(size)
           let mockImage = UIGraphicsGetImageFromCurrentImageContext()!
           UIGraphicsEndImageContext()
        mockService.imageResult = .success(mockImage)
        
        let viewModel = RecipeViewModel(recipeService: mockService)
        
        // Create a sample recipe to load the image for
        let recipe = RecipeCollection.Recipe(
            cuisine: "Malaysian",
            name: "Apam Balik",
            photoUrlLarge: "https://mock-url.com/photo-large.jpg",
            photoUrlSmall: "https://mock-url.com/photo-small.jpg",
            sourceUrl: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
            uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
            youtubeUrl: "https://www.youtube.com/watch?v=6R8ffRRJcrg"
        )
        
        // Create an expectation to wait for async updates
        let expectation = self.expectation(description: "Image is fetched and cached")
        
        // Act: Load the image
        viewModel.loadImage(for: recipe)
        
        // Add a delay to let the async update occur
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Assert: Check if the image was saved in the cache
            let cachedImage = ImageCache.shared.getImage(forKey: recipe.photoUrlLarge)
            XCTAssertNotNil(cachedImage, "Image should be cached")
            XCTAssertEqual(cachedImage, mockImage, "The cached image should be the mock image")
            XCTAssertNil(viewModel.errorMessage, "There should be no error message")
            expectation.fulfill()  // Mark the expectation as fulfilled
        }
        
        // Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("Expectation failed: \(error)")
            }
        }
    }
    
    
    func testViewModelLoadImageFailure() {
        // Arrange
        let mockService = MockRecipeService()
        
        // Set the mock service to return a failure result with an error
        let error = NSError(domain: "TestError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to load image"])
        mockService.imageResult = .failure(error)
        
        let viewModel = RecipeViewModel(recipeService: mockService)
        
        // Create a sample recipe to attempt to load the image for
        let recipe = RecipeCollection.Recipe(
            cuisine: "Malaysian",
            name: "Apam Balik",
            photoUrlLarge: "https://mock-url.com/photo-large.jpg",
            photoUrlSmall: "https://mock-url.com/photo-small.jpg",
            sourceUrl: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
            uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
            youtubeUrl: "https://www.youtube.com/watch?v=6R8ffRRJcrg"
        )
        
        // Create an expectation to wait for async updates
        let expectation = self.expectation(description: "Image fetching fails and ViewModel is updated with an error")
        
        // Act: Try to load the image
        viewModel.loadImage(for: recipe)
        
        // Add a delay to let the async update occur
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Assert: Check that no image is cached and an error message is set
            let cachedImage = ImageCache.shared.getImage(forKey: recipe.photoUrlLarge)
            XCTAssertNil(cachedImage, "Image should not be cached on failure")
            XCTAssertEqual(viewModel.errorMessage, "Failed to load image", "Error message should match the mock error")
            expectation.fulfill()  // Mark the expectation as fulfilled
        }
        
        // Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("Expectation failed: \(error)")
            }
        }
    }



    
}
