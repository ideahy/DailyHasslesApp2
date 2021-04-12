//
//  SendToDBModel.swift
//  DailyHasslesApp2
//
//  Created by 山本英明 on 2021/04/12.
//


//
//選択した画像データをストレージサーバに登録する
//RegisterVCで利用する
//


import Foundation
import FirebaseStorage

class SendToDBModel {
    
    
    init(){
    }
    
    
    //resisterVCにて新規登録ボタンを押下すると呼び出される(ついでに圧縮済み)
    func sendProfileImageData(data:Data){
        //引数をそのまま定数に格納(->結果的にputDataにて"!"が不必要になった)
        let profileImegeData = data
        
        //格納先を作成(.child("フォルダ名").child("画像名"))
        let imageRef = Storage.storage().reference().child("profileImege").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpg")
        //再度Data型にしたデータを指定したストレージに格納する
        imageRef.putData(profileImegeData, metadata: nil) { (result, error) in
            if error != nil{
                print(error.debugDescription)
                return
            }
            //格納先のURLを取得する
            imageRef.downloadURL { (url, error) in
                if error != nil{
                    print(error.debugDescription)
                    return
                }
                //選択した画像をアプリ内に保存する
                UserDefaults.standard.setValue(url?.absoluteString, forKey: "userImage")
            }
            //何も返ってこない②
            
        }
        //何も返ってこない①
        
    }
}
