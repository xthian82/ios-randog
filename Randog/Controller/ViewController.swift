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
    @IBOutlet weak var pickerView: UIPickerView!
    var breeds: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        DogAPI.requestBreedList(completionHandler: self.handleBreedList(list:error:))
    }
    
    func handleBreedList(list: [String], error: Error?) {
        self.breeds = list
        
        DispatchQueue.main.async {
            self.pickerView.reloadAllComponents()
        }
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

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breeds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return breeds[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        DogAPI.requestRandomImage(breed: breeds[row], completionHandler: self.handleRandomImageResponse(dogImage:error:))
        
    }
}
