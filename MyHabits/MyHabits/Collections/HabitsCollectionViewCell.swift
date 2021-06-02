//
//  HabitsCollectionViewCell.swift
//  MyHabits
//
//  Created by Misha on 12.05.2021.
//  Copyright © 2021 Misha. All rights reserved.
//

import UIKit

final class HabitsCollectionViewCell: UICollectionViewCell {
    
    var createColorStatusConstraint = [NSLayoutConstraint]()
    
    var count: Int = 0 {
        didSet {
            countLabel.text = String(count)
        }
    }
    
    var habit: Habit? {
        didSet {
            nameOfHabitLabel.text = habit?.name
            timeOfHabitLabel.text = habit?.dateString
            colorView.backgroundColor = habit?.color
            nameOfHabitLabel.textColor = habit?.color
            }
        }
    
    let nameOfHabitLabel: UILabel = {
        let nameOfHabitLabel = UILabel()
        nameOfHabitLabel.font = UIFont(name: "SFProText-Semibold", size: 17)
        nameOfHabitLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameOfHabitLabel
        }()
    
    let timeOfHabitLabel: UILabel = {
        let timeOfHabitLabel = UILabel()
        timeOfHabitLabel.font = UIFont(name: "SFProText-Regular", size: 12)
        timeOfHabitLabel.textColor = .systemGray2
        timeOfHabitLabel.translatesAutoresizingMaskIntoConstraints = false
        return timeOfHabitLabel
        }()
    
    let colorView: UIView = {
        let colorView = UIView()
        colorView.layer.cornerRadius = 40 / 2
        colorView.clipsToBounds = true
        colorView.translatesAutoresizingMaskIntoConstraints = false
        return colorView
    }()
    
    let fillColorView: UIView = {
        let fillColorView = UIView()
        fillColorView.layer.backgroundColor = UIColor.white.cgColor
        fillColorView.layer.cornerRadius = 30 / 2
        fillColorView.clipsToBounds = true
        fillColorView.translatesAutoresizingMaskIntoConstraints = false
        return fillColorView
    }()
    
    let checkMark: UIImageView = {
        let checkMark = UIImageView()
        checkMark.image = UIImage(named: "checkmark")
        checkMark.isHidden = true
        checkMark.translatesAutoresizingMaskIntoConstraints = false
        return checkMark
    }()
    
    let countLabel: UILabel = {
        let countLabel = UILabel()
        countLabel.font = UIFont(name: "SFProText-Regular", size: 13)
        countLabel.text = "Счётчик: 0"
        countLabel.textColor = .systemGray2
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        return countLabel
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(nameOfHabitLabel)
        contentView.addSubview(timeOfHabitLabel)
        contentView.addSubview(colorView)
        contentView.addSubview(countLabel)
        contentView.addSubview(fillColorView)
        contentView.addSubview(checkMark)
        
        self.contentView.layer.cornerRadius = 10
        
        //MARK: - Constraints
        var fillTopAnchor = fillColorView.centerYAnchor.constraint(equalTo: colorView.centerYAnchor)
        
        var fillCenterXAnchor = fillColorView.centerXAnchor.constraint(equalTo: colorView.centerXAnchor)
        var fillCenterYAnchor = fillColorView.widthAnchor.constraint(equalToConstant: 30)
        
        var fillHeightAnchor = fillColorView.heightAnchor.constraint(equalToConstant: 30)
        
        createColorStatusConstraint.append(fillTopAnchor)
        createColorStatusConstraint.append(fillCenterXAnchor)
        createColorStatusConstraint.append(fillCenterYAnchor)
        createColorStatusConstraint.append(fillHeightAnchor)
        
        NSLayoutConstraint.activate(createColorStatusConstraint)
        
        let tapOnColorRange = UITapGestureRecognizer(target: self, action: #selector(tap))
        fillColorView.addGestureRecognizer(tapOnColorRange)
        
        let constraints = [
            nameOfHabitLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            nameOfHabitLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            timeOfHabitLabel.topAnchor.constraint(equalTo: nameOfHabitLabel.topAnchor, constant: 20),
            timeOfHabitLabel.leadingAnchor.constraint(equalTo: nameOfHabitLabel.leadingAnchor),
            
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.heightAnchor.constraint(equalToConstant: 40),
            
            countLabel.topAnchor.constraint(equalTo: timeOfHabitLabel.topAnchor, constant: 40),
            countLabel.leadingAnchor.constraint(equalTo: nameOfHabitLabel.leadingAnchor),
            
            checkMark.centerYAnchor.constraint(equalTo: fillColorView.centerYAnchor),
            checkMark.centerXAnchor.constraint(equalTo: fillColorView.centerXAnchor),
            checkMark.widthAnchor.constraint(equalToConstant: 20),
            checkMark.heightAnchor.constraint(equalToConstant: 20),
            
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?( coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimation() {
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear) {
            
        self.fillColorView.backgroundColor = self.habit?.color
            
        self.checkMark.isHidden = false
            
        self.countLabel.text = "Cчётчик:" + " " + String(self.count)
            
        self.contentView.layoutIfNeeded()
                
        }
        animator.startAnimation()
    
        print(type(of: self), #function)
    }
    
    func noAnimation() {
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear) {
            
        //self.fillColorView.backgroundColor = self.habit?.color
            
        self.checkMark.isHidden = true
            
        //self.countLabel.text = "Cчётчик:" + " " + "1"
            
        self.contentView.layoutIfNeeded()
                
        }
        animator.startAnimation()
    
        print(type(of: self), #function)
    }
    
    //MARK: - Selectors
    @objc func tap() {
        //Также нужно сохранить время привычки с помощью функции HabitsStore.shared.track(). Каждый день можно добавить только одно время для одной привычки. Проверить это условие можно с помощью свойства isAlreadyTakenToday.
        
        //if let habit = habit {
        //Проверяем, что привычка не была затрекана
        //guard habit.isAlreadyTakenToday else { return }
        if let habit = habit {
            if habit.isAlreadyTakenToday == false {
                //трекаем привычку
                HabitsStore.shared.track(habit)
                //увеличиваем счётчик
                self.count += 1
                startAnimation()
                
                print("Привычка затрекана")
            } else {
        //создаём аниматор
        noAnimation()
            }
        }
    print(type(of: self), #function)
    }
}
