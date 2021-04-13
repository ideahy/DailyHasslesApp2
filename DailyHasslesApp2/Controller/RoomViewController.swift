//
//  RoomViewController.swift
//  DailyHasslesApp2
//
//  Created by 山本英明 on 2021/04/13.
//

import UIKit
//セル表示のアニメーション
import ViewAnimator

class RoomViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    var roomNameArray = ["誰でも話そうよ！","20代たまり場！","1人ぼっち集合","地球住み集合！！","好きなYoutuberを語ろう","大学生集合！！","高校生集合！！","中学生集合！！","暇なひと集合！","A型の人！！"]
    var roomImageStringArray = ["0","1","2","3","4","5","6","7","8","9"]
    
    @IBOutlet weak var roomTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roomTableView.delegate = self
        roomTableView.dataSource = self
        //アニメーション後に表示したいので隠しておく
        roomTableView.isHidden = true
    }
    
    
    //アニメーションを表示するメソッド
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //隠していたroomTableViewを表示し直す
        roomTableView.isHidden = false
        let animation = [AnimationType.vector(CGVector(dx: 0, dy: 30))]
        UIView.animate(views: roomTableView.visibleCells, animations: animation, completion:nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomNameArray.count
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //
        //＊エラー判断ポイント
        //tableView(引数) or roomTableView(変数)
        //
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath)
        //表示ルーム画像
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        imageView.image = UIImage(named: roomImageStringArray[indexPath.row])
        //表示ルーム名
        let label = cell.contentView.viewWithTag(2) as! UILabel
        label.text = roomNameArray[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    //セルが選択された時に呼び出し
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //画面遷移(sender(番号) -> prepare)
        performSegue(withIdentifier: "roomChat", sender: indexPath.row)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //使い回し(クラスを参照している)
        let roomChatVC = segue.destination as! ChatViewController
        //roomNameArrayの（sender）番目をroomChatVCのルームネームにする
        roomChatVC.roomName = roomNameArray[sender as! Int]
    }
}
