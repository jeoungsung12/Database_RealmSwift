//
//  BackupViewController.swift
//  SeSAC6Database
//
//  Created by 정성윤 on 3/10/25.
//

import UIKit
import SnapKit
import Zip

final class BackupViewController: UIViewController {
    let backupButton = {
        let view = UIButton()
        view.backgroundColor = .systemOrange
        return view
    }()
    
    let restoreButton = {
        let view = UIButton()
        view.backgroundColor = .systemGreen
        return view
    }()
    
    let backupTableView = {
        let view = UITableView()
        view.rowHeight = 50
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
    }
    
    func configure() {
        view.addSubview(backupTableView)
        view.addSubview(backupButton)
        view.addSubview(restoreButton)
        backupButton.addTarget(self, action: #selector(backupButtonTapped), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(restoreButtonTapped), for: .touchUpInside)
        backupTableView.delegate = self
        backupTableView.dataSource = self
    }
    
    func setConstraints() {
        backupTableView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
        }
        
        backupButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.top.leading.equalTo(view.safeAreaLayoutGuide)
        }
        
        restoreButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func documentDirectoryPath() -> URL? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documentDirectory
    }
    
    @objc
    private func backupButtonTapped() {
        print(#function)
        //Document File > Zip
        //도큐먼트 위치 조회
        guard let path = documentDirectoryPath() else {
            print("도큐먼트 위치에 오류가 있습니다")
            return }
        //백업할 파일을 조회
        let realmFile = path.appendingPathComponent("default.realm")
        
        //백업할 파일을 압축 파일로 묶는 작업
        guard FileManager.default.fileExists(atPath: realmFile.path()) else {
            print("백업할 파일이 없습니다") //앱 다운 후 바로 백업 버튼 누르면?
            return
        }
        
        //압축하고자 하는 파일을 urlPath에 추가
        var urlPaths = [URL]()
        urlPaths.append(realmFile)
        
        //백업할 파일을 압축 파일로 묶는 작업
        do {
           let filePath = try Zip.quickZipFiles(urlPaths, fileName: "JackArchive") { progress in
                print(progress)
            }
            print("Zip location", filePath)
        } catch {
            print("압축을 실패했어요")
            // 기기 용량 부족, 화면 dismiss, 다른 탭 전환, 백그라운드
        }
    }
    
    @objc
    private func restoreButtonTapped() {
        print(#function)
        let document = UIDocumentPickerViewController(forOpeningContentTypes: [.archive], asCopy: true)
        //zip 선택 -> 도큐먼트 저장 -> 압축 해제
        document.delegate = self
        document.allowsMultipleSelection = false //여러개는 선택하지 못하게!
        present(document, animated: true)
    }
}

/*
 Todo
 - 사진 데이터가 백업이 되고 있지 않은 상태
 - 백업 압축 파일에 default.realm 만 있는 상황
 - 폴더 기반으로 이미지 저장!
 
 - 백업 파일명
 - JAckArchive.zip
 - Jack_날짜_초단위.zip
 
 - 백업본 A. 근데 까먹고 새로 설치한 앱에 데이터를 많이 쌓아두었다..
 - 그리고 나중에 알게됩니다 -> 덮어 씌어집니다
 - default.realm -> 앱을 처음 실행해야만 동작.
 -> json 으로 백업/복구
 
 - info.plist에서! 잘 설정해라
 */

extension BackupViewController: UIDocumentPickerDelegate {
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else {
            print("선택한 파일에 오류가 있습니다")
            return
        }
        
        guard let path = documentDirectoryPath() else {
            print("도큐먼트 위치에 오류가 있습니다")
            return
        }
        //도큐먼트 폴더 내에 저장할 경로 설정
        let sandboxFileURL = path.appendingPathComponent(selectedFileURL.lastPathComponent)
        //압축 파일을 저장하고 풀면 돼요
        //이미 경로에 파일이 존재하는 지 확인 -> 압축을 바로 해제
        //경로에 파일이 존재하지 않는다면 -> 파일 앱의 압축 파일 -> 도큐먼트 경로로 복사 -> 도큐먼트에 저장 -> 저장된 압축 파일을 해제
        if FileManager.default.fileExists(atPath: sandboxFileURL.path()) {
            let fileURL = path.appendingPathComponent("JackArchive.zip")
            
            do {
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil) { progress in
                    print("progress", progress)
                } fileOutputHandler: { unzippedFile in
                    print("압축해제 완료")
                }
            } catch {
                print("압축 해제 실패")
            }
        } else {
            //압축 파일이 존재하지 않을때!
            do {
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                
            } catch {
                print("파일 copy 실패, 압축 해제 실패")
            }
        }
    }
}

extension BackupViewController: UITableViewDelegate, UITableViewDataSource {
    
    //Document 폴더에서 zip 확장자를 갖고 있는 파일만 조회!
    func fetchZipList() -> [String] {
        //도큐먼트 위치 조회
        guard let path = documentDirectoryPath() else {
            print("도큐먼트 위치에 오류가 있습니다")
            return []
        }
        
        var list: [String] = []
        //도큐먼트 폴더 내에 컨텐츠들 조회 zip filter
        do {
            let docs = try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
            let zip = docs.filter { $0.pathExtension == "zip" }
            
            list = zip.map { $0.lastPathComponent }
            
        } catch {
            print("목록 조회 실패")
        }
        
        return ["테스트1", "테스트2"]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchZipList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = fetchZipList()[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let path = documentDirectoryPath() else {
            print("도큐먼트 위치에 오류가 있습니다")
            return
        }
        
        let backupFileURL = path.appendingPathComponent(fetchZipList()[indexPath.row])
        let vc = UIActivityViewController(activityItems: [backupFileURL], applicationActivities: nil)
        
        present(vc, animated: true)
    }
    
}
