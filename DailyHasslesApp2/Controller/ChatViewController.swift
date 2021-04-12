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
    var imageURLString = String()
    //Message構造体が入る配列を空にして宣言する
    var messages:[Message] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.delegate = self
        chatTableView.dataSource = self
        
        //アプリ内に画像URLが保存されている場合、変数に格納する
        if UserDefaults.standard.object(forKey: "userImage") != nil{
            imageURLString = UserDefaults.standard.object(forKey: "userImage") as! String
        }
        
        //全体チャットへ遷移する場合
        if roomName == "" {
            roomName = "All"
        }
        
        //ナビバーに表示するタイトルを指定する
        self.navigationItem.title = roomName
    }
    
    
    //部屋ごとに格納されているデータを全て取得する
    func loadMessages(roomName:String){
        db.collection(roomName).order(by: "date").addSnapshotListener { (snapShot, error) in
            //初期化
            self.messages = []
            //エラー判定
            if error != nil{
                print(error.debugDescription)
                return
            }

            //snapShotの空判定(部屋ごとの各データを取得できた場合)
            if let snapShotDoc = snapShot?.documents{
                for doc in snapShotDoc{
                    //docの数だけ繰り返してドキュメント内のデータを取得する
                    let data = doc.data()
                    
                    //データの空判定(ドキュメント内のデータが取得できた場合)
                    if let email = data["email"] as? String, let message = data["message"] as? String, let imageURLString = data["imageURLString"] as? String{
                        //
                        let newMessage = Message(email: email, message: message, imageURLString: imageURLString)
                        //
                        self.messages.append(newMessage)
                    }
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
    @IBAction func sendAction(_ sender: Any) {
        //文字入力がある＆ユーザー認証済みの場合
        if let message = messageTextField.text, let email = Auth.auth().currentUser?.email{
            //Firestoreのパスを作成し、取得した各値をDBに登録する
            //＊全体チャットの場合、roomName = "All"
            db.collection(roomName).addDocument(data: ["email":email,"message":message,"imageURLString":imageURLString,"date":Date().timeIntervalSince1970]) { (error) in
                //エラー判定
                if error != nil{
                    print(error.debugDescription)
                    return
                }
                
                //非同期処理
                //＊上記のDB登録通信が遅い場合には順番を問わず処理が実行される
                DispatchQueue.main.async {
                    //送信後はテキストを空にする＆閉じる
                    self.messageTextField.text = ""
                    self.messageTextField.resignFirstResponder()
                }
            }
        }
    }    
}
