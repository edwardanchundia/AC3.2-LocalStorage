//
//  Protocol.swift
//  AC3.2-LocalStorage
//
//  Created by Edward Anchundia on 1/20/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation

protocol BlockGroundAPIDelegate {
    func didDownload(_ task: URLSessionDownloadTask, to url: URL)
    func downloadProgress(_ task: URLSessionDownloadTask, progress: Double)
}
