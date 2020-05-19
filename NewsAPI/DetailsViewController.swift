//
//  DetailsViewController.swift
//  NewsAPI
//
//  Created by M'haimdat omar on 24-12-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var text: String = ""
    
    let textDescription: UITextView = {
        let textView = UITextView()
        textView.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."
        textView.translatesAutoresizingMaskIntoConstraints = false
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        let atributes = [NSAttributedString.Key.paragraphStyle: style ]
        textView.attributedText = NSAttributedString(string: textView.text, attributes: atributes)
        textView.textColor = UIColor.black
        textView.font = UIFont.boldSystemFont(ofSize: 15)
        textView.font = UIFont(name: "Avenir", size: 16)
        textView.textAlignment = NSTextAlignment.justified
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.sizeToFit()
        textView.backgroundColor = .clear
        textView.textContainer.lineBreakMode = .byCharWrapping
        
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        self.view.addSubview(textDescription)
        setupText()
        textDescription.text = text
    }
    
    func setupText() {
        textDescription.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 15).isActive = true
        textDescription.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        textDescription.widthAnchor.constraint(equalToConstant: self.view.frame.width - 64).isActive = true
        textDescription.heightAnchor.constraint(equalToConstant: 10000).isActive = true
        textDescription.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        textDescription.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
    }
}
