//
//  User.swift
//  Authorization
//
//  Created by Нурлан on 21.06.17.
//  Copyright © 2017 Codebusters. All rights reserved.
//

import Foundation
import Alamofire

struct User {
    
    var token = ""
    var id = 0
    var email = ""
    
    init(from json: [String: Any]) {
        token = json["token"] as! String
        
        let user = json["user"] as! [String: Any]
        id = user["id"] as! Int
        email = user["username"] as! String
    }
    
    static func authorize(email: String,
                          password: String,
                          completion: @escaping (User?, String?) -> Void) {
        let parameters = [
            "username": email,
            "password": password
        ]
        let url = "https://apivotem.solf.io/api/authe/login/"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = value as! [String: Any]
                
                let code = json["code"] as! Int
                switch code {
                case 0:
                    completion(User(from: json), nil)
                case 6:
                    completion(nil, "email not found in server")
                default:
                    print("Пришел код ошибки, который мы не обрабатываем")
                    completion(nil, "unknown error")
                }
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
}
