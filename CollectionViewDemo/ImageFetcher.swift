//
//  ImageFetcher.swift
//  CollectionViewDemo
//
//  Created by YaathmiAR on 11/11/19.
//  Copyright © 2019 YaathmiAR. All rights reserved.
//

import Foundation
import UIKit

protocol ImageTaskDownloadedDelegate {
    func imageDownloaded(position: Int)
}

class ImageFetcher{
    
    
    let position : Int
    let url : URL
    let session : URLSession
    var image : UIImage?
    let tagId : Int
    
    
    
    
    var imageTaskDownloadedDelegate : ImageTaskDownloadedDelegate
    private var task: URLSessionDownloadTask?
    private var resumeData: Data?
    
    private var isDownloading = false
    private var isFinishedDownloading = false

    
    init(position : Int , url : URL , session : URLSession ,delegate : ImageTaskDownloadedDelegate , tagId: Int ) {
        
        self.url = url
        self.position = position
        self.session = session
        self.imageTaskDownloadedDelegate = delegate
        self.tagId = tagId
    }

    
    
    
    func loadImage(url : URL) {
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url)
            
            if let data = data, let image = UIImage(data: data) {
                self.image = image
            }
        }
    }
    

    
    func resume() {
        

        if !isDownloading && !isFinishedDownloading {
            isDownloading = true
            
            if let resumeData = resumeData {
                task = session.downloadTask(withResumeData: resumeData, completionHandler: downloadTaskCompletionHandler)
            } else {
                task = session.downloadTask(with: url, completionHandler: downloadTaskCompletionHandler)
            }
            
            task?.resume()
        }
    }
    func pause() {
        if isDownloading && !isFinishedDownloading {
            task?.cancel(byProducingResumeData: { (data) in
                self.resumeData = data
            })
            
            self.isDownloading = false
        }
    }
    
    
    private func downloadTaskCompletionHandler(url: URL?, response: URLResponse?, error: Error?) {
        

        if let error = error {
            print("Error downloading: ", error)
            return
        }
        
        guard let url = url else { return }
        guard let data = FileManager.default.contents(atPath: url.path) else { return }
        guard let image = UIImage(data: data) else {
            print("could not convert data into image: ", url)

            return
        }
        
        DispatchQueue.main.async {
            self.image = image
            self.imageTaskDownloadedDelegate.imageDownloaded(position: self.position)
        }
        
        self.isFinishedDownloading = true
    }
    
    
    
}
