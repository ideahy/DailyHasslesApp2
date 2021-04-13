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
        <#code#>
    }
}
