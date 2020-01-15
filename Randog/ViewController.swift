//
//  ViewController.swift
//  Randog
//
//  Created by Cristhian Jesus Recalde Franco on 1/15/20.
//  Copyright © 2020 Cristhian Jesus Recalde Franco. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let endpoint = DogAPI.Endpoint.randomImageFromAllDogsCollection.url
        
        let task = URLSession.shared.dataTask(with: endpoint) {
            (data, res, err) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            let imageData = try! decoder.decode(DogImage.self, from: data)
            guard let imageUrl = URL(string: imageData.message) else {
                print("no image")
                return
            }
            self.loadImage(url: imageUrl)
        }
        task.resume()
    }
    
    private func loadImage(url: URL) {
        let downloadTask = URLSession.shared.dataTask(with: url) {
            (data,response,error) in
            guard let data = data else {
                print("Unable to download data")
                return
            }
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data)
            }
        }
        downloadTask.resume()
    }
}

