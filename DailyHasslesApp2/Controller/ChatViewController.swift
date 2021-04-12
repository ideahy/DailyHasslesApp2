//
//  ChatViewController.swift
//  DailyHasslesApp2
//
//  Created by 山本英明 on 2021/04/12.
//

import UIKit
import Firebase
import SDWebImage

class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    let db = Firestore.firestore()
    var roomName = String()
    //SendToDBModelにてアプリ内に保存した画像URLを格納する変数
    var imageString = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.delegate = self
        chatTableView.dataSource = self
        
        //アプリ内に画像URLが保存されている場合、変数に格納する
        if UserDefaults.standard.object(forKey: "userImage") != nil{
            imageString = UserDefaults.standard.object(forKey: "userImage") as! String
        }
        
        //全体チャットへ遷移する場合
        if roomName == "" {
            roomName = "All"
        }
        
        //ナビバーに表示するタイトルを指定する
        self.navigationItem.title = roomName
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
    @IBAction func sendAction(_ sender: Any) {
    }    
}
