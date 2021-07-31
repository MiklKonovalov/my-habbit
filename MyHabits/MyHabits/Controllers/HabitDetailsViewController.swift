//
//  HabitDetailsViewController.swift
//  MyHabits
//
//  Created by Misha on 18.05.2021.
//  Copyright © 2021 Misha. All rights reserved.
//

import UIKit

class HabitDetailsViewController: UIViewController {
    
    var habit: Habit?
    
    //Устанавливаем навбар
    
    let navBarAppearance = UINavigationBarAppearance()
    
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Править", style: .plain, target: self, action: #selector(tap))
    }
    
    @objc func tap() {
        //Инициализируем HabitViewController
        
        let editHabitController = HabitViewController(habit: habit, action: HabitViewController.Action(name: "Удалить привычку", action: {
            
            print("123")

            })
        )
        
        editHabitController.modalPresentationStyle = .fullScreen
        editHabitController.title = "Править"
        //показываем контроллер через пуш
        navigationController?.pushViewController(editHabitController, animated: true)
        
    }
    
    @objc func cancelTap() {
        dismiss(animated: true, completion: nil)
    }
    
    //1. Инициализируем таблицу
    private let tableView = UITableView(frame: .zero, style: .grouped)
    //2. Инициализируем ячейку
    private let cellOne = "cellOne"
    
    //Чтобы largeTitleDisplayMode скрылся до открытия контроллера, помещаем его во viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
            navigationItem.largeTitleDisplayMode = .never
            title = habit?.name
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //устанавливаем фон ячейки
        self.view.backgroundColor = UIColor.white
        
        setupNavigationBar()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension HabitDetailsViewController: UITableViewDataSource {
    //2.1. Задаём количество ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HabitsStore.shared.dates.count
    }
    //2.2. Верстаем ячейку
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //2.2.1.Создаём ячейку
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellOne)
        
        //2.2.2.Задаём для свойства путь к определённой дате(даём понять таблице, где находится конкретная ячейка)
        //->передаём Date
        let date = HabitsStore.shared.dates[indexPath.item]
        
        //2.2.3.Передаём данные в ячейку
        //->передаём String
        cell.textLabel?.text = HabitsStore.shared.trackDateString(forIndex: indexPath.row)
        
        //2.2.5.Проверяем затрекана ли привычка в конкретную дату
        if !HabitsStore.shared.habit(habit!, isTrackedIn: date) {
            cell.accessoryType = .none
        } else {
            cell.accessoryType = .checkmark
        }
        //-убираем выделение у ячейки
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 70))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 20, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = "АКТИВНОСТЬ"
        label.textColor = .systemGray2
        label.font = UIFont(name: "SFProText-Regular", size: 17)
        
        headerView.addSubview(label)
        return headerView
    }
    
}

extension HabitDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

