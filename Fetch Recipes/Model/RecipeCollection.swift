//
//  RecipieCollection.swift
//  Fetch Recipes
//
//  Created by Niketan Doddamani on 10/13/24.
//

struct RecipeCollection : Codable
{
    let recipes: [Recipe]
    
    struct Recipe: Codable
    {
        let cuisine : String
        let name : String
        let photoUrlLarge : String
        let photoUrlSmall : String
        let sourceUrl : String?
        let uuid : String
        let youtubeUrl : String?
        
        enum CodingKeys: String, CodingKey {
            case cuisine
            case name
            case photoUrlLarge = "photo_url_large"
            case photoUrlSmall = "photo_url_small"
            case sourceUrl = "source_url"
            case uuid
            case youtubeUrl = "youtube_url"
        }
    }
}

