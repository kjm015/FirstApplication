//
//  Downloader.swift
//  Mr Robot
//
//  Created by Kurt McMahon on 8/31/18.
//  Copyright © 2018 Northern Illinois University. All rights reserved.
//

import Foundation
import UIKit

class Downloader {
    
    //let imageCache = NSCache<AnyObject, AnyObject>()
    let imageCache = NSCache<NSString, UIImage>()
    
    // Gets an image. Arguments are the image URL as a string, and
    // a closure to execute if the image is successfully obtained.
    func downloadImage(urlString: String, completion: @escaping (_ image: UIImage?) -> Void) {
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            completion(cachedImage)
        } else {
            guard let url = URL(string: urlString) else {
                // Perform some error handling
                print("Invalid URL string")
                completion(UIImage(named: "default.png"))
                return
            }
            
            // Otherwise, try to download the image from the provided URL
            weak var weakSelf = self
            
            let task = URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                
                let httpResponse = response as? HTTPURLResponse
                
                if httpResponse!.statusCode != 200 {
                    // Perform some error handling
                    DispatchQueue.main.async {
                        print("HTTP Error: status code \(httpResponse!.statusCode).")
                        completion(UIImage(named: "default.png"))
                    }
                } else if (data == nil && error != nil) {
                    // Perform some error handling
                    DispatchQueue.main.async {
                        print("No image data downloaded for \(urlString).")
                        completion(UIImage(named: "default.png"))
                    }
                } else {
                    // Download succeeded, attempt to decode image
                    if let image = UIImage(data: data!) {
                        DispatchQueue.main.async {
                            print("Success")
                            weakSelf!.imageCache.setObject(image, forKey: urlString as NSString)
                            completion(image)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func downloadData(urlString: String, completion: @escaping (_ data: Data?) -> Void) {
        
        guard let url = URL(string: urlString) else {
            // Perform some error handling
            print("Invalid URL string")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            let httpResponse = response as? HTTPURLResponse
            
            if httpResponse!.statusCode != 200 {
                // Perform some error handling
                DispatchQueue.main.async {
                    print("HTTP Error: status code \(httpResponse!.statusCode).")
                    completion(nil)
                }
            } else if (data == nil && error != nil) {
                // Perform some error handling
                DispatchQueue.main.async {
                    print("No data downloaded for \(urlString).")
                    completion(nil)
                }
            } else {
                // Download succeeded, attempt to decode JSON
                DispatchQueue.main.async {
                    print("Success")
                    completion(data)
                }
            }
        }
        task.resume()
    }
}
