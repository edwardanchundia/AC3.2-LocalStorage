//
//  LocalFilesViewController.swift
//  AC3.2-LocalStorage
//
//  Created by Louis Tur on 1/16/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import SnapKit

class LocalFilesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, BlockGroundAPIDelegate {
  private let cellIdentifier: String = "LocalFileCellIdentifier"
  private var directoryItems: [URL]? 
  
  // MARK: - View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViewHierarchy()
    configureConstraints()
    
    // load directory items
    self.directoryItems = BlockGroundFileManager.shared.listContentsOfBlockgroundsDir()
    BlockGroundAPIManager.shared.downloadDelegate = self
    // configure api manager
    
    // download blockground images
    BlockGroundAPIManager.shared.configure(bookId: "587d55d093e81a0400aef3b2")
    
    // request blockgrounds
    BlockGroundAPIManager.shared.requestAllBlockGrounds { (blockground: [BlockGround]?, error: Error?) in
      // check for BlockGrounds!
      guard blockground != nil else {
        return
      }

      // download blockground images
      guard let lastBlock = blockground?.last else { return }
      BlockGroundAPIManager.shared.downloadBlockGround(lastBlock, completion: { (image: UIImage?) in
        guard let validImage = image else { return }
        // do something with image?
        dump(validImage)
      })
    }
  }
  
  
  // MARK: - BlockGroundAPI Delegate 
  func didDownload(_ task: URLSessionDownloadTask, to url: URL) {
    
    print(task.description)
    print(url)
  }
  
  // we need to update this to something different
  func downloadProgress(_ task: URLSessionDownloadTask) -> Double {
    return 0.0
  }
  
  // MARK: - Setup
  private func configureConstraints() {
    self.edgesForExtendedLayout = []
    
    // lay out views
    previewView.snp.makeConstraints { (view) in
      view.height.equalToSuperview().multipliedBy(0.25)
      view.top.leading.trailing.equalToSuperview()
    }
    
    localFilesTable.snp.makeConstraints { (view) in
      view.top.equalTo(previewView.snp.bottom)
      view.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  private func setupViewHierarchy() {
    // add views
    self.view.addSubview(previewView)
    self.view.addSubview(localFilesTable)

    // set delegate/datasource
    self.localFilesTable.delegate = self
    self.localFilesTable.dataSource = self
    
    // register tableview
    self.localFilesTable.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
  }
  
  
  // MARK: - TableView Delegates
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.directoryItems?.count ?? 0
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
    
    cell.textLabel?.text = self.directoryItems?[indexPath.row].absoluteURL.lastPathComponent
    print("cell.textLabel.text = \(cell.textLabel?.text)")
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  }
  
  // MARK: - Lazy Inits
  internal lazy var previewView: UIView = {
    let view: UIView = UIView()
    view.backgroundColor = .gray
    return view
  }()
  
  internal lazy var localFilesTable: UITableView = {
    let tableView: UITableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
    return tableView
  }()
}
