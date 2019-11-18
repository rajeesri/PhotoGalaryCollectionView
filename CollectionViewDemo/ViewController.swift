//
//  ViewController.swift
//  CollectionViewDemo
//
//  Created by YaathmiAR on 1/23/18.
//  Copyright © 2018 YaathmiAR. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController,ImageTaskDownloadedDelegate{

    
    
    let urlBase = "https://picsum.photos/id/"
    var imageTasks : [Int: ImageFetcher] = [:]
    var totalImageCount = 10
    
    

    //  "https://picsum.photos/id/50/200/200"

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        
        let bgImage = UIImageView();
        bgImage.image = UIImage(named: "bgImg");
        bgImage.contentMode = .scaleToFill
        self.collectionView?.backgroundView = bgImage

        setupNavigationBar()
        
        
        guard let collectionView = collectionView , let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.minimumLineSpacing = 5
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        flowLayout.itemSize = CGSize(width: (collectionView.frame.size.width-15)/2, height: collectionView.frame.size.height/5) //cell size
        
        
        setupImageTasks (totalImages: totalImageCount)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    func setupNavigationBar(){
        
        let color =  UIColor(red: 51.0/2555.0, green: 153.0/255.0, blue: 235/255.0, alpha: 1.0)//135, 206, 235

        let textAttribute = [NSForegroundColorAttributeName: color , NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20)]
        
        navigationController?.navigationBar.titleTextAttributes = textAttribute
        navigationController?.navigationBar.barTintColor = color
        
        
        

    }
    private func setupImageTasks(totalImages: Int) {
        
        for i in 1...totalImages {
            addImage(id: i)
        }
        
        collectionView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   //MARK:imageDownloadedTaskDelegate
    
    func imageDownloaded(position: Int) {
        self.collectionView?.reloadItems(at: [IndexPath(row: position, section: 0)])
        
    }

    @IBAction func addPhoto(_ sender: Any) {
        
        
        totalImageCount += 1
        
        addImage(id: totalImageCount)
        
        //(collectionView?.insertItems(at: [IndexPath(row:(totalImageCount-1),section :0)])
        
        let newIndexPath = IndexPath(row: (totalImageCount-1), section: 0)

        collectionView?.performBatchUpdates({self.collectionView?.insertItems(at:[newIndexPath])}, completion: {finished in DispatchQueue.main.async {
            self.collectionView?.scrollToItem(at: newIndexPath, at: .centeredVertically, animated: true)
            }})
        
        
        
    }
    
    func addImage(id : Int){
        
        let session = URLSession(configuration: URLSessionConfiguration.default)


        let urlString = "\(urlBase)\(id+50)/200/200"
        
        let url = URL(string:urlString )
        let imageTask = ImageFetcher(position: id-1, url: url!, session: session, delegate: self,tagId:(id+50))
        imageTasks[id-1] = imageTask

    }

}
extension ViewController{
    
    //MARK:collectionViewDelegate
    
   override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageTasks.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! ImageCollectionViewCell
        
        let image = imageTasks[indexPath.row]?.image

        

        cell.cellImage.image = image
        cell.backgroundColor = UIColor(red:135.0/2555.0 , green: 206.0/255.0, blue: 235.0/255.0, alpha: 0.3)
        return cell
        
        
        
    }
     override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let imageCell = cell as! ImageCollectionViewCell
        imageCell.activityView.startAnimating()
        
        let imageTask = imageTasks[indexPath.row]
        imageTask?.resume()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let imageCell = cell as! ImageCollectionViewCell

        imageTasks[indexPath.row]?.pause()
        imageCell.activityView.stopAnimating()

    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        

        
        self.performSegue(withIdentifier: "photoDetails", sender: indexPath)

        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "photoDetails"{
            
        let row = (sender as! NSIndexPath).row; //we know that sender is an NSIndexPath here.

            let photoDetailsViewController = segue.destination as! PhotoDetailsViewController
            photoDetailsViewController.photoDetails = imageTasks[row]
            
            
    }
    
    }
}
