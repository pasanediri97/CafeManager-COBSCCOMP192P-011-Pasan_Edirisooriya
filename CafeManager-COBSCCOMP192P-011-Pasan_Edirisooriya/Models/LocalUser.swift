//
//  LocalUser.swift
//  CafeManager-COBSCCOMP192P-011-Pasan_Edirisooriya
//
//  Created by Pasan Induwara Edirisooriya on 4/11/21.
//

import Foundation
import RealmSwift

class LocalUser: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var avatarUrl: String = ""
    @objc dynamic var phoneNo: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    // Get the first object of User Model
    class func current() -> LocalUser? {
        let users = try! Realm().objects(LocalUser.self)
        return users.first
    }
    
    class func saveLoginData(user: UserModal) {
        guard (LocalUser.current() == nil) else {
            RealmService.shared.remove(objectsOfInstanceType: LocalUser.self) // Remove if exists
            self.createLocalUser(user: user) // Write user then
            return
        }
        
        self.createLocalUser(user: user) // Write user
    }
    
    class func createLocalUser(user: UserModal) {
        let newUser = LocalUser()
        newUser.id = user.id
        newUser.phoneNo = user.phoneNo ?? ""
        newUser.email = user.email
        newUser.avatarUrl = user.avatarUrl
        RealmService.shared.create(object: newUser)
    }
    
    class func UpdateProfileData(type: ProfileUpdateType, user: UserModal?, avatar: String?) {
        if let currentUser = LocalUser.current() {
            switch type {
            case .Avatar:
                let dict: [String: Any?] = ["avatarUrl": avatar ?? ""]
                RealmService.shared.update(object: currentUser, with: dict)
            default:
                break
            }
        }
    }
}

enum ProfileUpdateType {
    case Info, Avatar, Unknown
}
