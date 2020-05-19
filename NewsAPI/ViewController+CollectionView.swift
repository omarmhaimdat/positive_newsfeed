//
//  ViewController+CollectionView.swift
//  NewsAPI
//
//  Created by M'haimdat omar on 24-12-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit
import CoreImage

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.positiveArticles?.articles.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width - 40, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = newCollection.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        let card = cell as! CustomCell
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        cell.backgroundColor = .systemBackground
        let article = positiveArticles?.articles[indexPath.item]
        card.article = article
        card.card.delegate = self
        
        card.card.title = positiveArticles?.articles[indexPath.item].title ?? "Title"
        card.card.category = positiveArticles?.articles[indexPath.item].author ?? "Author"
        card.card.subtitle = positiveArticles?.articles[indexPath.item].publishedAt ?? "Date"
        card.card.backgroundColor = .black
        card.card.textColor = .white
       
        
        let queue = DispatchQueue.global(qos: .background)
        queue.async() { () -> Void in
            let data = NSData(contentsOf: NSURL(string: self.positiveArticles?.articles[indexPath.item].urlToImage ?? "https://www.setra.com/hubfs/Sajni/crc_error.jpg")! as URL)
            let img = UIImage(data: data! as Data)!
            DispatchQueue.main.async {
                let image = img.addFilter(filter: .Instant)
                card.card.backgroundImage = self.blurImage(image: image)
                
            }
        }
        
        let details = DetailsViewController()
        details.text = self.positiveArticles?.articles[indexPath.item].content ?? ""
        card.card.shouldPresent(details, from: self , fullscreen: false)
        card.card.reloadInputViews()
        
        return cell
    }
}

extension ViewController: CardDelegate {
    
    private func cardPostDidTapButton(card: CardArticle, button: UIButton) {
        print("Hello card")
    }
    
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

enum FilterType : String {
    case Chrome = "CIPhotoEffectChrome"
    case Fade = "CIPhotoEffectFade"
    case Instant = "CIPhotoEffectInstant"
    case Mono = "CIPhotoEffectMono"
    case Noir = "CIPhotoEffectNoir"
    case Process = "CIPhotoEffectProcess"
    case Tonal = "CIPhotoEffectTonal"
    case Transfer =  "CIPhotoEffectTransfer"
}

extension UIImage {
    func addFilter(filter : FilterType) -> UIImage {
        let filter = CIFilter(name: filter.rawValue)
        // convert UIImage to CIImage and set as input
        let ciInput = CIImage(image: self)
        filter?.setValue(ciInput, forKey: "inputImage")
        // get output CIImage, render as CGImage first to retain proper UIImage scale
        let ciOutput = filter?.outputImage
        let ciContext = CIContext()
        let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!)
        //Return the image
        return UIImage(cgImage: cgImage!)
    }
}

extension ViewController {
    func blurImage(image:UIImage) -> UIImage? {
        let context = CIContext(options: nil)
        let inputImage = CIImage(image: image)
        let originalOrientation = image.imageOrientation
        let originalScale = image.scale

        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(5.0, forKey: kCIInputRadiusKey)
        let outputImage = filter?.outputImage

        var cgImage:CGImage?

        if let asd = outputImage
        {
            cgImage = context.createCGImage(asd, from: (inputImage?.extent)!)
        }

        if let cgImageA = cgImage
        {
            return UIImage(cgImage: cgImageA, scale: originalScale, orientation: originalOrientation)
        }

        return nil
    }
}
