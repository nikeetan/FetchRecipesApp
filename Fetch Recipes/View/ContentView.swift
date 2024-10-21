//
//  ContentView.swift
//  Fetch Recipes
//
//  Created by Niketan Doddamani on 10/8/24.
//



import SwiftUI

struct ContentView: View {
    
    // Storing the url inside a variable inorder to make the request
    private let url : String = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    // Adaptive, here we will divide the column by size 170
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 170))
    ]
    
    @StateObject private var viewModel = RecipeViewModel()
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Image("images")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height:80)
                    Text(" Favorite Recipes!")
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 16)
                
                if viewModel.isLoading{
                    ProgressView("Loading....")
                }
                else if let errorMessage = viewModel.errorMessage
                {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                }
                
                else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                            ForEach(viewModel.recipes, id: \.uuid) { recipe in
                                VStack {
                                    if let cachedImage = ImageCache.shared.getImage(forKey: recipe.photoUrlLarge)
                                    {
                                        Image(uiImage: cachedImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 150, height: 150)
                                            .cornerRadius(10)
                                                                  
                                    }
                                    else
                                    {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 150, height: 150)
                                            .cornerRadius(10)
                                            .overlay {
                                                ProgressView()
                                                    .onAppear {
                                                        viewModel.loadImage(for: recipe) // Call the function from the ViewModel
                                                    }
                                            }
                                    }
                                    Text(recipe.name)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.center)
                                    
                                    Text(recipe.cuisine)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                }
                            }
                        }
                    }

                    }
                }
            }
            .padding()
           .onAppear {
               // Here i am ensuring the recipes are displayed at the first launch and unintentional repeatedly calling the API is avoided
                if viewModel.recipes.isEmpty {
                       viewModel.fetchRecipes(from: url)
                   }
            }
            .refreshable {
                viewModel.fetchRecipes(from: url)
                    
                }
        }
   }
#Preview {
    ContentView()
}

