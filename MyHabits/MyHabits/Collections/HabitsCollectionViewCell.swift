//
//  HabitsCollectionViewCell.swift
//  MyHabits
//
//  Created by Misha on 12.05.2021.
//  Copyright © 2021 Misha. All rights reserved.
//

import UIKit

//Протокол для делегтрования нажатия на кружок
protocol HabitsCollectionViewCellDelegate {
    func reloadData()
}

final class HabitsCollectionViewCell: UICollectionViewCell {
    
    //Объявляем делегат для использования:
    var delegateForReload: HabitsCollectionViewCellDelegate?
    
    func reloadData() {
        //вызываем делегат в тот момент, когда нажата кнопка
        delegateForReload?.reloadData()
    }
    
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
            //Если привычка затрекана
            if habit?.isAlreadyTakenToday == true {
                //устанавливаем цвет круга = цвету привычки
                fillColorView.backgroundColor = habit?.color
            } else {
                //в другом случае делаем заливку равной белому кругу
                fillColorView.backgroundColor = .white
            }
        
            }
    }
    
    let nameOfHabitLabel: UITextView = {
        let nameOfHabitLabel = UITextView()
        nameOfHabitLabel.font = UIFont(name: "SFProText-Semibold", size: 17)
        nameOfHabitLabel.translatesAutoresizingMaskIntoConstraints = false
        nameOfHabitLabel.isUserInteractionEnabled = false
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
        let fillTopAnchor = fillColorView.centerYAnchor.constraint(equalTo: colorView.centerYAnchor)
        
        let fillCenterXAnchor = fillColorView.centerXAnchor.constraint(equalTo: colorView.centerXAnchor)
        let fillCenterYAnchor = fillColorView.widthAnchor.constraint(equalToConstant: 30)
        
        let fillHeightAnchor = fillColorView.heightAnchor.constraint(equalToConstant: 30)
        
        createColorStatusConstraint.append(fillTopAnchor)
        createColorStatusConstraint.append(fillCenterXAnchor)
        createColorStatusConstraint.append(fillCenterYAnchor)
        createColorStatusConstraint.append(fillHeightAnchor)
        
        NSLayoutConstraint.activate(createColorStatusConstraint)
        
        let tapOnColorRange = UITapGestureRecognizer(target: self, action: #selector(tap))
        fillColorView.addGestureRecognizer(tapOnColorRange)
        
        let constraints = [
            nameOfHabitLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameOfHabitLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameOfHabitLabel.trailingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: -10),
            //nameOfHabitLabel.heightAnchor.constraint(equalToConstant: 60),
            
            timeOfHabitLabel.topAnchor.constraint(equalTo: nameOfHabitLabel.bottomAnchor, constant: 20),
            timeOfHabitLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.heightAnchor.constraint(equalToConstant: 40),
            
            countLabel.topAnchor.constraint(equalTo: timeOfHabitLabel.bottomAnchor, constant: 20),
            countLabel.leadingAnchor.constraint(equalTo: timeOfHabitLabel.leadingAnchor),
            countLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
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
        let animator = UIViewPropertyAnimator(duration: 0.0, curve: .linear) {
            
        self.checkMark.isHidden = true
            
        self.contentView.layoutIfNeeded()
                
        }
        animator.startAnimation()
    
        print(type(of: self), #function)
    }
    
    //MARK: - Selectors
    @objc func tap() {
        //Нужно сохранить время привычки с помощью функции HabitsStore.shared.track(). Каждый день можно добавить только одно время для одной привычки. Проверить это условие можно с помощью свойства isAlreadyTakenToday.
        
        //Проверяем, что привычка не была затрекана
        if let habit = habit {
            //Если привычка не затрекана
            if habit.isAlreadyTakenToday == false {
                //трекаем привычку
                HabitsStore.shared.track(habit)
                
                reloadData()
                
                //увеличиваем счётчик
                self.count += 1
                //вызываем анимацию
                startAnimation()
                print("Привычка затрекана")
            //если привычка затрекана, то ничего не происходит
            }
            //else {
        //создаём аниматор
        //noAnimation()
        //    }
        }
    print(type(of: self), #function)
    }
    
}
