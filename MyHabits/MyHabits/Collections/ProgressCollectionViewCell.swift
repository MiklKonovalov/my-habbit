//
//  ProgressCollectionViewCell.swift
//  MyHabits
//
//  Created by Misha on 14.05.2021.
//  Copyright © 2021 Misha. All rights reserved.
//

import UIKit

final class ProgressCollectionViewCell: UICollectionViewCell {
    
    //Надо передать в прогрессвью данные из свойства HabitsStore.shared.todayProgress.
    //В свойстве HabitsStore.shared.todayProgress
    //MARK:-Observer
    var progressIsLoad: Float? {
        didSet {
            let progressData = HabitsStore.shared.todayProgress
            progressView.progress = progressData
            percentLabel.text = "\(Int(progressData * 100))" + "%"
        }
    }
    
    //MARK:-Create subview's
    let titleLabel: UILabel = {
    let titleLabel = UILabel()
    titleLabel.font = UIFont(name: "SFProText-Semibold", size: 13)
        titleLabel.textColor = .systemGray2
    titleLabel.text = "Всё получится"
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    return titleLabel
    }()
    
    let percentLabel: UILabel = {
    let percentLabel = UILabel()
    percentLabel.font = UIFont(name: "SFProText-Semibold", size: 13)
        percentLabel.textColor = .systemGray
    percentLabel.translatesAutoresizingMaskIntoConstraints = false
    return percentLabel
    }()
    
    var progressView: UIProgressView = {
    let progressView = UIProgressView()
    progressView.progressViewStyle = .default
    progressView.progressTintColor = .init(red: 161/255, green: 22/255, blue: 204/255, alpha: 0.94)
    progressView.translatesAutoresizingMaskIntoConstraints = false
    return progressView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        contentView.backgroundColor = .white
        
        self.contentView.layer.cornerRadius = 10
       
        //MARK:-Add subview's
        contentView.addSubview(titleLabel)
        contentView.addSubview(percentLabel)
        contentView.addSubview(progressView)
        
        progressView.setProgress(0.5, animated: false)
        
        //MARK:-Create constraints
        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            progressView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 30),
            progressView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            progressView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -30),
            progressView.widthAnchor.constraint(equalToConstant: 100),
            progressView.heightAnchor.constraint(equalToConstant: 5),
            
            percentLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            percentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
        ]
        NSLayoutConstraint.activate(constraints)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
