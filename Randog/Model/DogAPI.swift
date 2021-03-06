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
    
    enum Endpoint {
        case randomImageFromAllDogsCollection
        case randomImageForBreed(String)
        case listAllBreeds
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
        
        var stringValue: String {
            switch self {
            case .randomImageFromAllDogsCollection:
                return "https://dog.ceo/api/breeds/image/random"
            case .randomImageForBreed(let breed):
                return "https://dog.ceo/api/breed/\(breed)/images/random"
            case .listAllBreeds:
                return "https://dog.ceo/api/breeds/list/all"
            default:
                return ""
            }
        }
    }
    
    class func requestBreedList(completionHandler: @escaping ([String], Error?) -> Void) {
        let endpoint = Endpoint.listAllBreeds.url
        let task = URLSession.shared.dataTask(with: endpoint, completionHandler: {
            (data, response, error) in
            guard let data = data else {
                completionHandler([], error)
                return
            }
            do {
                let breedDict = try DECODER.decode(BreedList.self, from: data)
                completionHandler(breedDict.message.keys.map({$0}), nil)
            } catch {
                completionHandler([], error)
            }
        })
        task.resume()
    }
    
    class func requestRandomImage(breed: String, completionHandler: @escaping (DogImage?, Error?) -> Void) {
        let endpoint = Endpoint.randomImageForBreed(breed).url
        let task = URLSession.shared.dataTask(with: endpoint, completionHandler: {(data, res, err) in
            guard let data = data else {
                completionHandler(nil, err)
                return
            }
            do {
                let imageData = try DECODER.decode(DogImage.self, from: data)
                guard let _: String = imageData.message else {
                    completionHandler(nil, err)
                    return
                }
                completionHandler(imageData, nil)
            } catch {
                completionHandler(nil, err)
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
