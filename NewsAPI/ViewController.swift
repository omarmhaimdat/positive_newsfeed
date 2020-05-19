//
//  ViewController.swift
//  NewsAPI
//
//  Created by M'haimdat omar on 23-12-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit
import NaturalLanguage

struct Article: Decodable {
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let publishedAt: String?
    let urlToImage: String?
    let content: String?
}

struct Articles: Decodable {
    var status: String?
    var totalResults: Int?
    var articles: [Article]
}

class ViewController: UIViewController {
    
    let serverAddress = "https://newsapi.org/v2/top-headlines?country=us&apiKey=485c58875fdc4cec9588a09c76634c87"
    
    var articles: Articles?
    var positiveArticles: Articles?
    
    let cellId = "cellId"
    let newCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        collection.backgroundColor = UIColor.clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isScrollEnabled = true
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabItem()
        getNews()
        self.setupCollection()
        self.setupCollectionView()
    }
    
    func setupTabItem() {
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.barTintColor = .darkGray
        view.backgroundColor = .systemBackground
        self.navigationItem.title = "News"
        self.setNeedsStatusBarAppearanceUpdate()
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.backgroundColor = .systemFill
            self.navigationController?.navigationBar.standardAppearance = navBarAppearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
    }
    
    
    
    fileprivate func setupCollection() {
            
        self.view.addSubview(newCollection)
        
        if #available(iOS 13.0, *) {
            newCollection.backgroundColor = .systemBackground
        } else {
            newCollection.backgroundColor = UIColor.white
        }
            
        newCollection.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        newCollection.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        newCollection.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        newCollection.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        newCollection.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            
    }
    
    fileprivate func setupCollectionView() {
        newCollection.register(CustomCell.self, forCellWithReuseIdentifier: cellId)
        newCollection.alwaysBounceVertical = true
        newCollection.delegate = self
        newCollection.dataSource = self
    }
    
    
    func getNews() {
        
        var request = URLRequest(url: URL(string: self.serverAddress)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                
                guard let data = data else {return}
                let article = try JSONDecoder().decode(Articles.self, from: data)
                DispatchQueue.main.async(execute: {
                    self.articles = article
                    self.positiveArticles = article
                    self.positiveArticles?.articles.removeAll()
                    if let articles = self.articles?.articles {
                        for ar in articles {
                            if ar.content != nil {
                                if self.getSentimentFromBuildInAPI(text: ar.content!) == 1 {
                                    self.positiveArticles?.articles.append(ar)
                                }
                            }
                        }
                    }
                    self.newCollection.reloadData()
                })
                
            } catch {
                print(error)
            }
        })
        
        task.resume()
    }
    
    func getSentimentFromBuildInAPI(text: String) -> Int {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = text
        let (sentiment, _) = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore)
        
        let sentimentScore = sentiment?.rawValue.toDouble()
        
        var finalScore = 0
        
        if let score = sentimentScore {
            if score < 0 {
                finalScore = 0 // Negative
            } else if score > 0 {
                finalScore = 1 // Positive
            } else {
                finalScore = -1 // Neutral
            }
        }
        
        return finalScore
    }


}

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}

