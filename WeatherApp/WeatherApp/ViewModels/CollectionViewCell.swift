//
//  CollectionViewCell.swift
//  WeatherApp
//
//  Created by Matthew Morris on 9/14/22.
//

import Foundation
import UIKit

class CollectionViewCell: UICollectionViewCell {
    
//    let view: UIView = {
//        let view = UIView()
//
//        return view
//    }()
    
    let title: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Hello"
        
        return title
    }()
    
    let body: UILabel = {
       let body = UILabel()
        body.translatesAutoresizingMaskIntoConstraints = false
        body.text = "Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye Goodbye"
        
        body.numberOfLines = 0
        return body
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(title)
        contentView.addSubview(body)
        
        title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        
        body.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
        body.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        body.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        body.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) was not implemented correctly")
    }
}
