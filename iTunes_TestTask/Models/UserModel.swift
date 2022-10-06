//
//  UserModel.swift
//  iTunes_TestTask
//
//  Created by Roman Apanasevich on 06.10.2022.
//

import Foundation

struct User: Codable {
    
    let firstName: String
    let secondName: String
    let phone: String
    let email: String
    let password: String
    let age: Date
}

