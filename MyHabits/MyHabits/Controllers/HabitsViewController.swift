//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by Misha on 05.05.2021.
//  Copyright © 2021 Misha. All rights reserved.
//

import UIKit

class HabitsViewController: UIViewController, HabitsCollectionViewCellDelegate, HabitViewControllerDelegate, HabitViewControllerDeleteHabitDelegate {
    
    func reloadDataForDeleteHabit() {
        //реализация делегируемой логики
        self.collectionView.reloadData()
    }
    
    func reloadDataForAddingHabit() {
        //реализация делегируемой логики
        self.collectionView.reloadData()
    }
    
    func reloadData() {
        //реализация делегируемой логики
        self.collectionView.reloadData()
    }
     
    var habit: Habit?
    
    func captureModified(habit: Habit?) {
         self.habit = habit
    }
    
    let reuseId = "cellId"
    let progressId = "progressId"
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HabitsCollectionViewCell.self, forCellWithReuseIdentifier: reuseId)
        collectionView.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: progressId)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .init(red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        let habitViewController = HabitViewController()
        habitViewController.delegateForDeleteHabbit = self
        habitViewController.reloadDataForDeleteHabit()
    }
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
    //MARK: - Navbar settings
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .init(red: 249/255, green: 249/255, blue: 249/255, alpha: 0.94)
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        //Добавляем кнопку добавления привычки
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addHabit))
        navigationItem.rightBarButtonItem = addButton
        
        self.view.addSubview(collectionView)
        
        let constraints = [
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        
    }
    
    //MARK:-Selectors
    @objc func addHabit() {
        let habitViewController = HabitViewController()
        let navigationController = UINavigationController(rootViewController: habitViewController)
        habitViewController.delegateForAddingHabbit = self
        habitViewController.modalPresentationStyle = .fullScreen
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true) {
            habitViewController.title = "Создать"
        }
        
    }
    
}

extension HabitsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return HabitsStore.shared.habits.count
        default:
            return 0
        }
    }
    
    //cellForItemAt отвечает за вид ячейки
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! HabitsCollectionViewCell
        
        if indexPath.section == 1 {
            let habit = HabitsStore.shared.habits[indexPath.item]
            cell.habit = habit
            //Кладём контроллер, который поддерживает протокол делегата
            cell.delegateForReload = self
            
            return cell
        }
        
        let cellTwo = collectionView.dequeueReusableCell(withReuseIdentifier: progressId, for: indexPath) as! ProgressCollectionViewCell
        
        if indexPath.section == 0 {
            let progress = HabitsStore.shared.todayProgress
            cellTwo.progressIsLoad = progress
            
            //Отключаем выбор ячеек в конкретной секции
            cellTwo.isUserInteractionEnabled = false
            
            return cellTwo
        }
        return cell
    }
    
    //Задаём поведение ячейке при тапе (переход на HabitDetailsViewController)
    //Выполним перезагрузку ячейки в методе didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let habitDetailsViewController = HabitDetailsViewController()
        
        //Получаем выбранный объект Habit из источника данных по indexPath.item
        let habit = HabitsStore.shared.habits[indexPath.item]
        //Получаем доступ к конкретной ячейке
        habitDetailsViewController.habit = habit
        
        habitDetailsViewController.modalPresentationStyle = .fullScreen
        
        //let habitNavigationController = UINavigationController(rootViewController: habitDetailsViewController)
        
        navigationController?.pushViewController(habitDetailsViewController, animated: true)
    
    }
    
    //Если выбор первой секции, то не анимируем
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return (indexPath.section == 0) ? true : false
    }
        
}

extension UICollectionView {
    func deselectAllItem(animated: Bool) {
        guard let selectedItems = indexPathsForSelectedItems else { return }
        for indexPath in selectedItems {deselectItem(at: indexPath, animated: true)}
    }
}

extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Задаём размеры ячеек
        let width: CGFloat = collectionView.frame.width - 10 * 2
        var heigth: CGFloat = (collectionView.frame.height - 10 * 2) / 10
        
        switch indexPath.section {
        case 0:
            break
        case 1:
            heigth = (collectionView.frame.height - 10 * 2) / 4
        default:
            break
        }
        
        return CGSize(width: width, height: heigth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
    }
}


