//
//  RegisterViewController.swift
//  DailyHasslesApp2
//
//  Created by 山本英明 on 2021/04/12.
//

import UIKit
import Firebase
import FirebaseAuth


//＊カメラやアルバム立ち上げの際にはImagePickerやNavigationが必要
class RegisterViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SendProfileOKDelegate,UITextFieldDelegate {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    
    //SendToDBModelクラスをインスタンス化
    var sendToDBModel = SendToDBModel()
    var urlString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //許可画面を表示するためのModelからメソッドを呼び出す
        let checkModel = CheckPermission()
        checkModel.showCheckPermission()
        //SendProfileOKDelegateメソッドをこのクラスで使う
        //SendToDBModelクラス内の変数や関数を参照可能
        //-> 変数を使用可能
        sendToDBModel.sendProfileOK = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //ナビゲーションバーは必要ないので隠しておく
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    //キーボード外がタッチされた場合は閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    
    @IBAction func registerAction(_ sender: Any) {
        //textFieldの空判定
        if emailTextField.text?.isEmpty != true && passwordTextField.text?.isEmpty != true, let image = profileImageView.image{
            //認証用ユーザー情報をFirebaseに登録
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
                if error != nil{
                    print(error.debugDescription)
                    return
                }
                //UIImage型からData型に変換する(ついでに圧縮)
                let data = image.jpegData(compressionQuality: 0.1)
                //選択した画像データ(Data型)をストレージに保存するためにモデルを呼び出す
                self.sendToDBModel.sendProfileImageData(data: data!)
                //
                //＊ここで画面遷移するとストレージやアプリ内保存が確認できないので、
                //SendToDBModelにprotocolを作成してそれを回避する
                //
            }
        }
        //FirebaseAuthへの認証
        
        //入力値を登録
    }
    
    
    //画像がタップされたら呼び出される
    @IBAction func tapImageAction(_ sender: Any) {
        //カメラorアルバム選択アラートの表示
        showAlert()
    }
    
    
    func sendProfileOKDelegate(url: String) {
        //SendToDBModelにて格納した引数を受け取る
        urlString = url
        if urlString.isEmpty != true {
            //
            //＊状況に合わせて変更する
            //self.performSegue(withIdentifier: "tabBC", sender: nil)
            //
            let tabBC = self.storyboard?.instantiateViewController(identifier: "tabBC") as! TabBarController
            self.navigationController?.pushViewController(tabBC, animated: true)
        }
    }
    
    
    //カメラ立ち上げメソッド
    func doCamera(){
        //カメラを指定
        let sourceType:UIImagePickerController.SourceType = .camera
        
        //カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            //表示の設定
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    
    
    //アルバム立ち上げメソッド
    func doAlbum(){
        
        let sourceType:UIImagePickerController.SourceType = .photoLibrary
        
        //アルバムが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            //表示の設定
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    
    
    //画像が選択された後に呼び出されるメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //画像が選択された場合
        if info[.originalImage] as? UIImage != nil{
            //選択画像を変数に格納
            let selectedImage = info[.originalImage] as! UIImage
            //画面上に選択画像を表示
            profileImageView.image = selectedImage
            //picker画面を閉じる
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    
    //キャンセルメソッド
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //picker画面を閉じる
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    //アラート
    func showAlert(){

        //アラートの設定
        let alertController = UIAlertController(title: "選択", message: "どちらを使用しますか?", preferredStyle: .actionSheet)

        let action1 = UIAlertAction(title: "カメラ", style: .default) { (alert) in
            self.doCamera()
        }

        let action2 = UIAlertAction(title: "アルバム", style: .default) { (alert) in
            self.doAlbum()
        }
        
        let action3 = UIAlertAction(title: "キャンセル", style: .cancel)
        
        //アラート画面に選択肢を追加
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        self.present(alertController, animated: true, completion: nil)
    }
}
