//
//  SendToDBModel.swift
//  DailyHasslesApp2
//
//  Created by 山本英明 on 2021/04/12.
//


//
//画像データをストレージサーバに飛ばす
//RegisterVCで利用する
//


import Foundation
import FirebaseStorage

class SendToDBModel {
    
    
    init(){
    }
    
    
    //data引数(Data型)を受け取って定数(UIIMage型)に格納
    func sendProfileImageData(data:Data){
        let image = UIImage(data: data)
        let profileImege = image?.jpegData(compressionQuality: 0.1)
        //参照元を指定(child("フォルダ名"))
        let imageRef = Storage.storage().reference().child("profileImege")
    }
}
