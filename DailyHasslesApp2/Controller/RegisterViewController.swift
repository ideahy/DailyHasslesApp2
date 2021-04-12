//
//  RegisterViewController.swift
//  DailyHasslesApp2
//
//  Created by 山本英明 on 2021/04/12.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //許可画面を表示するためのModelからメソッドを呼び出す
        let checkModel = CheckPermission()
        checkModel.showCheckPermission()
    }
    
    
    
    @IBAction func registerAction(_ sender: Any) {
        //textFieldの空判定
        
        //FirebaseAuthへの認証
        
        //入力値を登録
    }
    
    
    @IBAction func tapImageAction(_ sender: Any) {
        //カメラorアルバム選択肢の表示
        
        //アクションシートを表示
    }
    
}
