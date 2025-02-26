//
//  ViewController.swift
//  newsApp
//
//  Created by Burak Aydın on 9.09.2023.
//

import UIKit


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {


    @IBOutlet weak var tableView: UITableView!
    
    private var newsTableViewModel : NewsTableViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        getData()

    }
    
    func getData () {
        
        let urlString = "https://raw.githubusercontent.com/atilsamancioglu/BTK-iOSDataSet/master/dataset.json"
        let url = URL(string : urlString)
        
        WebService().downloadNews(url: url!) { news in
            if let news = news {
                self.newsTableViewModel = NewsTableViewModel (newsList: news)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()

                }
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsTableViewModel == nil ? 0 : self.newsTableViewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsCell
        let newsViewModel = self.newsTableViewModel.newsAtIndexPath(indexPath.row)
        cell.titleLabel.text = newsViewModel.title
        cell.storyLabel.text = newsViewModel.story
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    


}

