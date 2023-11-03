//
//  CurrentUserInfo.swift
//  FenceApp
//
//  Created by Woojun Lee on 11/1/23.
//

import Foundation

class CurrentUserInfo {
    
    static let shared = CurrentUserInfo()
    
    var currentUser: FBUser?
    
    private init() {}
}



//1.  앱껏다키면 사라짐 ㅇㅅㅇ;
//2.  키체인을 넣는건 아닌 것 같다
//3.  앱을 켜놓을 때 싱글톤에 넣어놓는 것은 괜찮다.

