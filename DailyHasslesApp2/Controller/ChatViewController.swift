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
    //MessageModel構造体が入る配列を空にして宣言する
    var messages:[MessageModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.delegate = self
        chatTableView.dataSource = self
        //カスタムセルを登録する
        chatTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
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
        //部屋内のメッセージをロードする
        loadMessages(roomName: roomName)
    }
    
    
    //部屋ごとに格納されているデータを全て取得する
    //＊ロード用のメソッドであり、送信用ではない
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
                        //DBに格納されている値を変数に格納する
                        let newMessage = MessageModel(email: email, message: message, imageURLString: imageURLString)
                        //MessageModel構造体が入る配列にロードした値を格納(クラス内で宣言済)
                        self.messages.append(newMessage)
                        //非同期処理
                        DispatchQueue.main.async {
                            //TableViewをリロードしてメッセージを表示
                            self.chatTableView.reloadData()
                            //indexPathを配列の個数-1にする
                            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                            //メッセージの一番下の行に来るようにスクロール
                            self.chatTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    //TableView画面に表示する内容を設定する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //MessageCellのプロパティにアクセス可能
        //
        //＊エラー判断ポイント
        //tableView(引数) or chatTableView(変数)
        //
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MessageCell
        //ロードしたメッセージ内容をcellのラベルに反映する
        let contents = messages[indexPath.row]
        cell.messageLabel.text = contents.message
        
        //自分の送信したメッセージの場合
        if contents.email == Auth.auth().currentUser?.email {
            //他人画像を隠す＆自分画像を表示する
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.rightImageView.sd_setImage(with: URL(string: imageURLString), completed: nil)
            //背景色＆文字色
            cell.backView.backgroundColor = .systemTeal
            cell.textLabel?.textColor = .white
            //他人画像は表示されない
            cell.leftImageView.sd_setImage(with: URL(string: messages[indexPath.row].imageURLString), completed: nil)
            
            //自分以外のユーザーのメッセージの場合
        }else{
            //他人画像を表示する＆自分画像を隠す
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.leftImageView.sd_setImage(with: URL(string: messages[indexPath.row].imageURLString), completed: nil)
            //背景色＆文字色
            cell.backView.backgroundColor = .orange
            cell.textLabel?.textColor = .white
            //自分画像は表示されない
            cell.rightImageView.sd_setImage(with: URL(string: imageURLString), completed: nil)
        }
        return cell
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
