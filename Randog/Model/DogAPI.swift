//
//  DogAPI.swift
//  Randog
//
//  Created by Cristhian Jesus Recalde Franco on 1/15/20.
//  Copyright © 2020 Cristhian Jesus Recalde Franco. All rights reserved.
//

import Foundation
import UIKit

class DogAPI {

    static let DECODER = JSONDecoder()
    
    enum Endpoint: String {
        case randomImageFromAllDogsCollection = "https://dog.ceo/api/breeds/image/random"
        
        var url: URL {
            return URL(string: self.rawValue)!
        }
    }
    
    class func requestRandomImage(completionHandler: @escaping (DogImage?, Error?) -> Void) {
        let endpoint = Endpoint.randomImageFromAllDogsCollection.url
        let task = URLSession.shared.dataTask(with: endpoint, completionHandler: {(data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            do {
                let imageData = try DECODER.decode(DogImage.self, from: data)
                guard let _: String = imageData.message else {
                    completionHandler(nil, error)
                    return
                }
                completionHandler(imageData, nil)
            } catch {
                completionHandler(nil, error)
            }
        })
        task.resume()
    }
    
    class func requestImageFile(url: URL, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            let downloadedImage = UIImage(data: data)
            completionHandler(downloadedImage, nil)
        })
        task.resume()
    }
}
