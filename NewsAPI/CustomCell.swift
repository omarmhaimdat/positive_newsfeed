//
//  CustomCell.swift
//  NewsAPI
//
//  Created by M'haimdat omar on 24-12-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit
//import Cards

class CustomCell: UICollectionViewCell, CardDelegate {
    
    var card: CardArticle!
    var article: Article!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.card = setupCardTest() as? CardArticle
        self.card.delegate = self
        self.article = Article(author: "", title: "", description: "", url: "", publishedAt: "", urlToImage: "", content: "")
    }
    
    func setupCardTest() -> Card {
        
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        let card = CardArticle(frame: CGRect(x: 30, y: 140, width: self.frame.width - 32 , height: self.frame.height/3))
        
        self.addSubview(card)
        
        card.translatesAutoresizingMaskIntoConstraints = false
        
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            //iPhones_5_5s_5c_SE
            card.heightAnchor.constraint(equalToConstant: screenHeight/2.5).isActive = true
            card.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
            card.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        case 1334:
            //iPhones_6_6s_7_8
            card.heightAnchor.constraint(equalToConstant: screenHeight/2.5).isActive = true
            card.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
            card.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        case 1792:
            //iPhone_XR
            card.heightAnchor.constraint(equalToConstant: screenHeight/3).isActive = true
            card.topAnchor.constraint(equalTo: self.topAnchor, constant: self.frame.height/5 - 30).isActive = true
        case 1920, 2208:
            //iPhones_6Plus_6sPlus_7Plus_8Plus
            card.heightAnchor.constraint(equalToConstant: screenHeight/2.5).isActive = true
        case 2436:
            //iPhones_X_XS
            card.heightAnchor.constraint(equalToConstant: screenHeight/3).isActive = true
            card.topAnchor.constraint(equalTo: self.topAnchor, constant: self.frame.height/5 - 30).isActive = true
        case 2688:
            //iPhone_XSMax
            card.heightAnchor.constraint(equalToConstant: screenHeight/2.5).isActive = true
        default:
            card.heightAnchor.constraint(equalToConstant: screenHeight/3).isActive = true
            card.topAnchor.constraint(equalTo: self.topAnchor, constant: self.frame.height/5 - 30).isActive = true
        }
        
        
        card.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        card.widthAnchor.constraint(equalToConstant: self.frame.width - 32).isActive = true
        
        
        card.backgroundColor = .systemBackground
        card.subtitle = "subtitle"
        card.title = "titre"
        card.category = "author"
        card.textColor = UIColor.white
        card.hasParallax = false
        
        return card
    }
    
    override func prepareForReuse() {
        self.card.title = "titre"
        self.card.subtitle = "subtitle"
        self.card.category = "author"
        self.card.textColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
