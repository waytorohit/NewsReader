//
//  ViewController.swift
//  NewsReader
//
//  Created by Rohit on 10/27/17.
//  Copyright © 2017 Rohit. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!

    //var newsArray = [String:AnyObject]()
    
    var articles: [Article]? = []
    
    // https://newsapi.org/v1/articles?source=techcrunch&apiKey=833c7383bb7c4060afa57dfd6e0c92ca
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    fetchArticles()
    
        
    }
    
    func fetchArticles() {
        
let url = URL(string: "https://newsapi.org/v1/articles?source=techcrunch&apiKey=833c7383bb7c4060afa57dfd6e0c92ca")
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }
            else{
                  self.articles = [Article]()
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    print(json)
                    
                    if let jsonData = json["articles"] as? [[String:AnyObject]] {
                        for jsondata in jsonData{
                            let article = Article()
                             if let title = jsondata["title"] as? String,
                                let author = jsondata["author"] as? String,
                                let url = jsondata["url"] as? String,
                                let imageUrl = jsondata["urlToImage"] as? String,
                                let desc = jsondata["description"] as? String {
                                article.title = title
                                article.author = author
                                article.desc = desc
                                article.url = url
                                article.imageUrl = imageUrl
                                
                            }
                                self.articles?.append(article)
                        }
                    }
                    
                    
                    
                              OperationQueue.main.addOperation({
                              self.tableView.reloadData()
                               })
                    
                }             catch let error as NSError{
                             print(error)
                }
            }
        })
            .resume()
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return articles?.count ?? 0
        
    }
    
   	func	tableView(_	tableView:	UITableView,	cellForRowAt	indexPath:
        IndexPath)	->	UITableViewCell	{
        
        let	cell	=	tableView.dequeueReusableCell(withIdentifier: "NewsCell",for:	indexPath) as! NewsCell
        cell.first_Lbl.text = self.articles?[indexPath.item].title
        cell.Second_Lbl.text = self.articles?[indexPath.item].desc
        cell.Third_Lbl.text = self.articles?[indexPath.item].author
        //cell.Img_View.downloadedFrom(from: (self.articles?[indexPath.item].imageUrl!)!)
        return	cell
    }

   
}



class NewsCell: UITableViewCell {
    
    
    @IBOutlet weak var first_Lbl: UILabel!
    
    
    @IBOutlet weak var Second_Lbl: UILabel!
    
    
    @IBOutlet weak var Third_Lbl: UILabel!
    
    
    @IBOutlet weak var Img_View: UIImageView!
    
    
}


//extension UIImageView {
//    func downloadImage(from url: String) {
//        let urlRequest = URLRequest(url: URL(string: url)!)
//        let task = URLSession.shared.dataTask(with: urlRequest)   { (data, response, error) in
//           guard
//            let data = data, error == nil,
//            let image = UIImage(data: data)
//            //print(image)
//            
//            else
//           {  return
//            }
//            
//        }
//        DispatchQueue.main.async {
//            self.image = self.image
//        }
//        task.resume()
//    }
//}


extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}




