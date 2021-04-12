//
//  CheckPermission.swift
//  DailyHasslesApp2
//
//  Created by 山本英明 on 2021/04/12.
//


//
//許可画面を表示するためのModel
//


import Foundation
import Photos

class CheckPermission {
    
    func showCheckPermission(){
        PHPhotoLibrary.requestAuthorization { (status) in
            
            switch(status){
            
            case .authorized:
                print("許可されてますよ")
                
            case .denied:
                print("拒否")
                
            case .notDetermined:
                print("notDetermined")
                
            case .restricted:
                print("restricted")
                
            case .limited:
                print("limited")
            @unknown default: break
                
            }
            
        }
    }
    
}
