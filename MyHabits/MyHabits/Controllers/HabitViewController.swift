//
//  HabitViewController.swift
//  MyHabits
//
//  Created by Misha on 08.05.2021.
//  Copyright © 2021 Misha. All rights reserved.
//

import UIKit

protocol HabitViewControllerDelegate {
    func reloadDataForAddingHabit()
}

protocol HabitViewControllerDeleteHabitDelegate {
    func reloadDataForDeleteHabit()
}

class HabitViewController: UIViewController, UIColorPickerViewControllerDelegate, UITextFieldDelegate {
           
           let datePicker = UIDatePicker()
    
           var delegateForAddingHabbit: HabitViewControllerDelegate?
    
           var delegateForDeleteHabbit: HabitViewControllerDeleteHabitDelegate?
    
           var habit: Habit?
        
           var habitID: Int?
    
           struct Action {
               var name: String
               var action: () -> Void
           }
    
    init(habit: Habit? = nil, habitID: Int? = nil, action: Action? = nil) {
               self.habit = habit
               self.habitID = habitID
               super.init(nibName: nil, bundle: nil)
            
            if habit != nil {
            habitTextField.text = habit?.name
            
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm a"
            let myDate = formatter.string(from: habit!.date)
            timeTextLabel.text = myDate
            
            colorButton.backgroundColor = habit?.color
             
            deleteButton.setTitle(action?.name, for: .normal)
            deleteButton.isHidden = false
                
            } else {
                deleteButton.isHidden = true
            }
            deleteButton.addTarget(self, action: #selector(deleteHabit), for: .touchUpInside)
            }
    
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
    }
    
    //MARK: -ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
       
        self.view.addSubview(titleLable)
        self.view.addSubview(habitTextField)
        self.view.addSubview(colorLable)
        self.view.addSubview(colorButton)
        self.view.addSubview(timeLable)
        self.view.addSubview(everyDayLabel)
        self.view.addSubview(timeTextLabel)
        self.view.addSubview(datePicker)
        self.view.addSubview(deleteButton)
        
        habitTextField.delegate = self
        
        //MARK: - Create Buttons on navbar
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        let cancelButton = UIBarButtonItem(title: "Отмена", style: .done, target: self, action: #selector(cancelTap))
        self.navigationItem.leftBarButtonItem = cancelButton
        cancelButton.tintColor = .init(red: 161/255, green: 22/255, blue: 204/255, alpha: 1.0)
        
        let createButton = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(createDataButton))
        createButton.tintColor = .init(red: 161/255, green: 22/255, blue: 204/255, alpha: 1.0)
        self.navigationItem.rightBarButtonItem = createButton
        
        //MARK: - Create DatePicker
        
        datePicker.becomeFirstResponder()
        datePicker.datePickerMode = .time
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.backgroundColor = .white
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.date = habit?.date ?? Date() //dateOnDatePicker ?? Date()
        
        //MARK: - Create constraints
        
        let constraints = [
        
           titleLable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
           titleLable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
           habitTextField.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 20),
           habitTextField.leadingAnchor.constraint(equalTo: titleLable.leadingAnchor),
           habitTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
           
           colorLable.topAnchor.constraint(equalTo: habitTextField.bottomAnchor, constant: 20),
           colorLable.leadingAnchor.constraint(equalTo: titleLable.leadingAnchor),
           
           colorButton.topAnchor.constraint(equalTo: colorLable.bottomAnchor, constant: 20),
           colorButton.leadingAnchor.constraint(equalTo: titleLable.leadingAnchor),
           colorButton.widthAnchor.constraint(equalToConstant: 40),
           colorButton.heightAnchor.constraint(equalToConstant: 40),
           
           timeLable.topAnchor.constraint(equalTo: colorButton.bottomAnchor, constant: 20),
           timeLable.leadingAnchor.constraint(equalTo: titleLable.leadingAnchor),
           
           everyDayLabel.topAnchor.constraint(equalTo: timeLable.bottomAnchor, constant: 20),
           everyDayLabel.leadingAnchor.constraint(equalTo: titleLable.leadingAnchor),
           
           timeTextLabel.topAnchor.constraint(equalTo: everyDayLabel.topAnchor),
           timeTextLabel.leadingAnchor.constraint(equalTo: everyDayLabel.trailingAnchor, constant: 5),
           
           deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
           deleteButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
           datePicker.widthAnchor.constraint(equalTo: view.widthAnchor),
            datePicker.topAnchor.constraint(equalTo: timeTextLabel.bottomAnchor, constant: 20),
           
        ]
        NSLayoutConstraint.activate(constraints)
        
    }
    
    //MARK: - Create Selectors
    
    @objc func doneAction() {
        view.endEditing(true)
    }
    
    @objc func dateChanged() {
        getDateFromPicker()
    }
    
    @objc func tapGestureDone() {
        view.endEditing(true)
        print(type(of: self), #function)
    }
    
    @objc func cancelTap() {
        navigationController?.dismiss(animated: true, completion: nil)
        navigationController?.popToRootViewController(animated: true)
        print(type(of: self), #function)
    }
    
    @objc func createDataButton() {
        //создание новой привычки при нажатии на кнопку “Сохранить“. При этом я проверяю, чтобы новая привычка создавалась, если в контроллер до этого не передавалась привычка
        let habitsViewController = HabitsViewController()
    
        if let habit = habit {
            //редактируем уже старую привычку
            habit.name = habitTextField.text ?? "no data"

            habit.date = datePicker.date
            habit.color = colorButton.backgroundColor!
            HabitsStore.shared.save()
            reloadDataForAddingHabit()
            navigationController?.dismiss(animated: true, completion: nil)
            navigationController?.popViewController(animated: true)
            
        } else {
            //создаём новую привычку
            let newHabit = Habit(name: habitTextField.text ?? "No date",
                                 date: Date(),
                                 color: colorButton.backgroundColor!
                                )
            let store = HabitsStore.shared
            store.habits.append(newHabit)
            HabitsStore.shared.save()
            reloadDataForAddingHabit()
            navigationController?.dismiss(animated: true, completion: nil)
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @objc func cancelTapOnChangeModel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func createDataButtonOnChangeModel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func deleteHabit() {
        print("@objc func deleteHabit")
        //При нажатии на кнопку нужно показать UIAlertController со следующими параметрами:
        //Заголовок "Удалить привычку";
        //Сообщение "Вы хотите удалить привычку "название выбранной привычки"?";
        let alertController = UIAlertController(title: "Удалить привычку", message: "Вы хотите удалить привычку \(String(describing: self.habit?.name ?? " "))", preferredStyle: .alert)
        //Два Alert Actions:
        //"Отмена", который закрывает UIAlertController;
        let cancelButton = UIAlertAction(title: "Отмена", style: .default, handler: {
            (alertController: UIAlertAction) -> Void in
            self.dismiss(animated: true, completion: nil)
        })
        //"Удалить", при нажатии на который привычка удаляется из HabitsStore, экраны HabitViewController и HabitDetailsViewController закрываются и привычка пропадает из списка на экране MyHabitsViewController.
        let deleteHabitButton = UIAlertAction(title: "Удалить", style: .destructive, handler: {
            (alertController: UIAlertAction) -> Void in
            //Возвращаемся на HabitsViewController?
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.popToRootViewController(animated: true)
            
            //Я уже нахожусь в конкретной привычке.
            if let idx = HabitsStore.shared.habits.firstIndex(where: { $0 === self.habit }) {
                HabitsStore.shared.habits.remove(at: idx)
                self.reloadDataForDeleteHabit()
            }
            
            HabitsStore.shared.save()
            
        }
        )
        alertController.addAction(cancelButton)
        alertController.addAction(deleteHabitButton)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @objc func didTapSelectColor() {
        let colorPickerVC = UIColorPickerViewController()
        colorPickerVC.selectedColor = self.colorButton.backgroundColor!
        colorPickerVC.delegate = self
        present(colorPickerVC, animated: true)
        
    }

    //MARK: - Create func
    
    func reloadDataForDeleteHabit() {
        delegateForDeleteHabbit?.reloadDataForDeleteHabit()
    }
    
    func reloadDataForAddingHabit() {
        delegateForAddingHabbit?.reloadDataForAddingHabit()
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        colorButton.backgroundColor = color
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        colorButton.backgroundColor = color
    }
    
    func getDateFromPicker() {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        timeTextLabel.text = formatter.string(from: datePicker.date)
    }
    
    //MARK: - Create Subviews
    let titleLable: UILabel = {
        let titleLable = UILabel()
        titleLable.font = UIFont(name: "SFProText-Semibold", size: 13)
        titleLable.text = "Название"
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        return titleLable
    }()
    
    let habitTextField: UITextField = {
        let habitTextField = UITextField()
        habitTextField.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        habitTextField.translatesAutoresizingMaskIntoConstraints = false
        habitTextField.resignFirstResponder()
        return habitTextField
    }()
    
    let colorLable: UILabel = {
        let titleLable = UILabel()
        titleLable.font = UIFont(name: "SFProText-Semibold", size: 13)
        titleLable.text = "Цвет"
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        return titleLable
    }()
    
    let colorButton: UIButton = {
        let colorButton = UIButton()
        colorButton.backgroundColor = .orange
        colorButton.layer.cornerRadius = 40 / 2
        colorButton.clipsToBounds = true
        colorButton.addTarget(self, action: #selector(didTapSelectColor), for: .touchUpInside)
        colorButton.translatesAutoresizingMaskIntoConstraints = false
        return colorButton
    }()
    
    let timeLable: UILabel = {
        let timeLable = UILabel()
        timeLable.font = UIFont(name: "SFProText-Semibold", size: 13)
        timeLable.text = "Время"
        timeLable.translatesAutoresizingMaskIntoConstraints = false
        return timeLable
    }()
    
    let everyDayLabel: UILabel = {
        let everyDayLabel = UILabel()
        everyDayLabel.font = UIFont(name: "SFProText-Regular", size: 17)
        everyDayLabel.text = "Каждый день в"
        everyDayLabel.translatesAutoresizingMaskIntoConstraints = false
        return everyDayLabel
    }()
    
    let timeTextLabel: UILabel = {
        let timeTextLabel = UILabel()
        timeTextLabel.font = UIFont(name: "SFProText-Regular", size: 17)
        timeTextLabel.text = "11:00"
        timeTextLabel.becomeFirstResponder()
        timeTextLabel.textColor = .init(red: 161/255, green: 22/255, blue: 204/255, alpha: 1.0)
        timeTextLabel.translatesAutoresizingMaskIntoConstraints = false
        return timeTextLabel
    }()
    
    let deleteButton: UIButton = {
        let deleteButton = UIButton(type: .system)
        deleteButton.tintColor = .red
        deleteButton.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 17)
        deleteButton.isHidden = true
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        return deleteButton
    }()
    
}



