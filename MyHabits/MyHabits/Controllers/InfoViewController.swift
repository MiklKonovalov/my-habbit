//
//  InfoViewController.swift
//  MyHabits
//
//  Created by Misha on 05.05.2021.
//  Copyright © 2021 Misha. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //Устанавливаем название навбара
        self.title = "Информация"
        
        self.view.addSubview(scrollView)
        
        scrollView.addSubview(myView)
        
        myView.addSubview(informationLabel)
        myView.addSubview(titleLabel)
        
        //MARK: - Create Constraints
        let constraints = [
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        scrollView.topAnchor.constraint(equalTo: view.topAnchor),
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
       
        myView.topAnchor.constraint(equalTo: scrollView.topAnchor),
        myView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        myView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
        myView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
        myView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        
        titleLabel.topAnchor.constraint(equalTo: myView.topAnchor, constant: 10),
        titleLabel.leadingAnchor.constraint(equalTo: myView.leadingAnchor, constant: 15),
        titleLabel.heightAnchor.constraint(equalToConstant: 30),

            
        informationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
        informationLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
        informationLabel.bottomAnchor.constraint(equalTo: myView.bottomAnchor),
        informationLabel.trailingAnchor.constraint(equalTo: myView.trailingAnchor, constant: -10),
        ]
        NSLayoutConstraint.activate(constraints)
        
    }
    //MARK: - Create View's
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let myView: UIView = {
        let myView = UIView()
        myView.translatesAutoresizingMaskIntoConstraints = false
        return myView
    }()
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "SFProDisplay-Semibold", size: 20)
        titleLabel.text = "Привычка за 21 день"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()

    
    let informationLabel: UILabel = {
        let informationLabel = UILabel()
        informationLabel.font = UIFont(name: "SFProText-Regular", size: 17)
        informationLabel.text = "Прохождение этапов, за которые за 21 день вырабатывается привычка, подчиняется следующему алгоритму: \n\n1. Провести 1 день без обращения к старым привычкам, стараться вести себя так, как будто цель, загаданная в перспективу, находится на расстоянии шага. \n\n2. Выдержать 2 дня в прежнем состоянии самоконтроля. \n\n3. Отметить в дневнике первую неделю изменений и подвести первые итоги – что оказалось тяжело, что – легче, с чем еще предстоит серьезно бороться. \n\n4. Поздравить себя с прохождением первого серьезного порога в 21 день. За это время отказ от дурных наклонностей уже примет форму осознанного преодоления и человек сможет больше работать в сторону принятия положительных качеств. \n\n5. Держать планку 40 дней. Практикующий методику уже чувствует себя освободившимся от прошлого негатива и двигается в нужном направлении с хорошей динамикой. \n\n6. На 90-й день соблюдения техники все лишнее из «прошлой жизни» перестает напоминать о себе, и человек, оглянувшись назад, осознает себя полностью обновившимся. \n\nИсточник: psychbook.ru"
        //Установил значение numberOfLines на 0, чтобы удалить предели и показывать столько строк, сколько нужно
        informationLabel.numberOfLines = 0
        informationLabel.translatesAutoresizingMaskIntoConstraints = false
        return informationLabel
    }()
    
}
