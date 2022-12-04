//
//  TableViewCell.swift
//  WeatherApp
//
//  Created by Matthew Morris on 11/14/22.
//

import UIKit

class TableViewCell: UITableViewCell {
    var title: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = .white
        
        addSubview(title)
        
        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: centerYAnchor),
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
