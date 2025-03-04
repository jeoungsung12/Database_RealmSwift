//
//  MainViewController.swift
//  SeSAC6Database
//
//  Created by Jack on 3/4/25.
//

import UIKit
import SnapKit
import SwiftUI
import RealmSwift
/*
 뷰 갱신
 데이터 수정
 */
final class MainViewController: UIViewController {
    private let tableView = UITableView()
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
        print(repository.getFileURL())
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
    }
    
    private func configureView() {
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
         
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
     
    @objc func rightBarButtonItemClicked() {
        let vc = AddViewController()
        navigationController?.pushViewController(vc, animated: true)
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
