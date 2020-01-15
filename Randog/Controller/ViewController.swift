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
    }
    
    @IBAction func getImage() {
        DogAPI.requestRandomImage(completionHandler: self.handleRandomImageResponse(dogImage:error:))
    }
    
    func handleRandomImageResponse(dogImage: DogImage?, error: Error?) {
        guard let imageUrl = URL(string: dogImage?.message ?? "") else {
            print("no image")
            return
        }
        
        DogAPI.requestImageFile(
            url: imageUrl,
            completionHandler: self.handleImageFileResponse(image:error:)
        )
    }
    
    func handleImageFileResponse(image: UIImage?, error: Error?) {
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }
}

