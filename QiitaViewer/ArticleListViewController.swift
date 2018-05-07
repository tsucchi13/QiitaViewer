//
//  ArticleListViewController.swift
//  QiitaViewer
//
//  Created by Tsubasa Tsuchiya on 2018/05/07.
//  Copyright © 2018年 Tsubasa Tsuchiya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ArticleListViewController: UIViewController, UITableViewDataSource{

    let table = UITableView() // プロパティにtableを追加
    
    var articles: [[String: String?]] = [] // 記事を入れるプロパティを定義
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "新着記事" // Navigation Barのタイトルを設定
        table.frame = view.frame // tableの大きさをviewの大きさに合わせる
        view.addSubview(table) // viewにtableを乗せる
        
        table.dataSource = self // dataSouceプロパティに自身を代入
        
        getArticles()
        
    }
    
    func getArticles() {
        Alamofire.request("https://qiita.com/api/v2/items" , method: .get)
            .responseJSON { response in
                //print(response.result.value) // responseのresultプロパティのvalueプロパティをコンソールに出力
                
                guard let object = response.result.value else {
                    return
                }
                
                let json = JSON(object)
                json.forEach { (_, json) in
                    let article: [String:String?] = [
                        "title":json["title"].string,
                        "userId":json["user"]["id"].string
                    ]
                    self.articles.append(article)
//                    print(json["title"].string) // jsonから"title"がキーのものを取得、記事タイトルを表示
//                    print(json["user"]["id"].string) // 投稿者のユーザーIDを表示
                }
                self.table.reloadData() // TableViewを更新
        }
        
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let article = articles[indexPath.row] // 行数番目の記事を取得
        cell.textLabel?.text = article["title"]! // 記事のタイトルをtextLabelにセット
        cell.detailTextLabel?.text = article["userId"]! // 投稿者のユーザーIDをdetailTextLabelにセット
        return cell
    }
    

}
