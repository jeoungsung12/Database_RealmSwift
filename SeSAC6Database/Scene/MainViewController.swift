//
//  MainViewController.swift
//  SeSAC6Database
//
//  Created by Jack on 3/4/25.
//

import UIKit
import FSCalendar
import SnapKit
import SwiftUI
import RealmSwift
/*
 뷰 갱신
 데이터 수정
 */
final class MainViewController: UIViewController {
    private let tableView = UITableView()
    private let calendar = FSCalendar()
    
    private var list: [JackTable] = []
    //램에 들어있는 list넣어주고 -> 뷰에 보여준다. results 타입이기 때문에 상황에 따라서 잘 나오지 않을때도 있다. 셀 재사용 문제로 볼수 있다.
//    private let realm = try! Realm() //default.realm
     
    private let repository: JackTableRepositoryType = JackTableRepository()
    private let folderRepository: FolderRepositoryType = FolderRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        folderRepository.createItem(name: "개인")
        folderRepository.createItem(name: "계모임")
        folderRepository.createItem(name: "회사")
        folderRepository.createItem(name: "멘토")
        
        print(#function)
//        print(repository.getFileURL())
//        let data = realm.objects(JackTable.self)
//            .where { $0.name.contains("sesac", options: .caseInsensitive) }
//            .sorted(byKeyPath: "money", ascending: false)
//        dump(list)
        
        list = Array(repository.fetchAll())
        
        configureHierarchy()
        configureView()
        configureConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
//        list = Array(realm.objects(JackTable.self))
        tableView.reloadData()
    }
    
    private func configureHierarchy() {
        view.addSubview(tableView)
        view.addSubview(calendar)
    }
    
    private func configureView() {
        calendar.backgroundColor = .green
        calendar.dataSource = self
        calendar.delegate = self
        
        view.backgroundColor = .white
        tableView.rowHeight = 130
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.id)
          
        let image = UIImage(systemName: "plus")
        let item = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(rightBarButtonItemClicked))
        navigationItem.rightBarButtonItem = item
    }
    
    private func configureConstraints() {
        calendar.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(250)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
     
    @objc func rightBarButtonItemClicked() {
        let vc = AddViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension MainViewController: FSCalendarDelegate, FSCalendarDataSource {
//    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//        //이벤트 점을 찍을수 있는 닷!
//        print(#function, date)
//        return 2
//    }
//    
//    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
//        return UIImage(systemName: "star")
//    }
//    
//    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
//        return "subTitle"
//    }
//    
//    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
//        return "title"
//    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(#function, date)
        //선택한 날짜
        let start = Calendar.current.startOfDay(for: date) //시작날짜
        //선택한 날짜의 다음날 날짜
        let end: Date = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? Date() //그 다음날의 시작점!
        //Realm where filter, iOS NSPredicate
        let predicate = NSPredicate(format: "regdate >= %@ && regdate < %@", start as NSDate, end as NSDate)
        
        let realm = try! Realm()
        let result = realm.objects(JackTable.self).filter(predicate)
        dump(result)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.id) as! ListTableViewCell
        
        let data = list[indexPath.row]
        
        cell.titleLabel.text = "\(data.name), \(data.category)"
        cell.subTitleLabel.text = data.folder.first?.name
        cell.overviewLabel.text = data.money.formatted()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = list[indexPath.row]
        repository.deleteItem(data: data)
        tableView.reloadData()
    }
      
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerRepresentable<MainViewController>()
    }
}
