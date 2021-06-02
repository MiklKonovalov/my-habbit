//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by Misha on 05.05.2021.
//  Copyright © 2021 Misha. All rights reserved.
//

import UIKit

class HabitsViewController: UIViewController {
    
    @IBAction func goToHabitViewController(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Создать", bundle: nil)
        let habitViewController = storyboard.instantiateViewController(identifier: "habitViewController") as! HabitViewController
        self.present(habitViewController, animated: true, completion: nil)
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
    
    //во viewDidAppear, потому что viewWillAppear срабатывает раньше, чем приходят данные. Поэтому они становятся видны в таблице только при следующем перезапуске.
    override func viewDidAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .init(red: 249/255, green: 249/255, blue: 249/255, alpha: 0.94)
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance

        self.view.addSubview(collectionView)
        //надо заскролить коллекцию!!!
        let constraints = [
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! HabitsCollectionViewCell
        
        if indexPath.section == 1 {
            let habit = HabitsStore.shared.habits[indexPath.item]
            cell.habit = habit
            return cell
        }
        
        let cellTwo = collectionView.dequeueReusableCell(withReuseIdentifier: progressId, for: indexPath) as! ProgressCollectionViewCell
        
        if indexPath.section == 0 {
            let progress = HabitsStore.shared.todayProgress
            cellTwo.progressIsLoad = progress
            return cellTwo
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let habitDetailsViewController = storyboard?.instantiateViewController(identifier: "habitDetailsViewController") as? HabitDetailsViewController
        
        let habit = HabitsStore.shared.habits[indexPath.item]
        habitDetailsViewController?.habit = habit
    
        navigationController?.pushViewController(habitDetailsViewController!, animated: true)
        print(type(of: self), #function)
    }
    
    //где надо написать, что если выбор первой секции, то не анимировать?
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return (indexPath.item == 0) ? true : false
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
        
        let width: CGFloat = collectionView.frame.width - 10 * 2
        var heigth: CGFloat = (collectionView.frame.height - 10 * 2) / 10
        
        switch indexPath.section {
        case 0:
            break
        case 1:
            heigth = (collectionView.frame.height - 10 * 2) / 6
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

