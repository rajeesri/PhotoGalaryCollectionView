//
//  PhotoDetailsViewController.swift
//  CollectionViewDemo
//
//  Created by YaathmiAR on 11/16/19.
//  Copyright © 2019 YaathmiAR. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {

    @IBOutlet weak var selectedImage: UIImageView!
    
    
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var authorName: UILabel!
    
    @IBOutlet weak var downloadURL: UILabel!
    
    
    
    var photoDetails : ImageFetcher?
    let baseUrl : String = "https://picsum.photos/id/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        guard let id = photoDetails?.tagId else {
            print("could not find url")
            return
        }
        let infoUrlStr = baseUrl + "\(id)/info"
        
        selectedImage.image = photoDetails?.image
        
        
        let infoUrl = URL(string: infoUrlStr)
        
        //        let task = URLSession.shared.dataTask(with: url!)  { (responseData, responseurl, error) -> Void in


        
        getDetailsFromUrl (url : infoUrl)

        

        // Do any additional setup after loading the view.
    }
    
    
    func getDetailsFromUrl(url infoUrl : URL?){
        
        
        
        
        let task = URLSession.shared.dataTask(with: infoUrl!){ (responseData, response, error) in
            
            if error != nil {
                return
            }
            
            if let data = responseData{
                
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                    
                    let name = json?["author"] as! String
                    let downloadUrl = json?["download_url"] as! String


                    
                    DispatchQueue.main.async {
                        
                        
                       self.authorName.text = name
                        self.downloadURL.text =  downloadUrl

                        
                    }


            }
                catch{
                    
                }

            
            
            }
        }
        
        task.resume()
        
        
        // let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSArray

    }
    
    
    
                

        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
