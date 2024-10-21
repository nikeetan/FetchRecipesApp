//
//  Untitled.swift
//  Fetch Recipes
//
//  Created by Niketan Doddamani on 10/15/24.
//

import UIKit

class ImageCache {
    static let shared = ImageCache()
    
    private let cache = NSCache<NSString, UIImage>()
    
    // Retrieve an image from the cache
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: NSString(string: key))
    }
    
    // Save an image to the cache
    func saveImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: NSString(string: key))
    }
}
