
//
//  User.swift
//  POC
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation
import RealmSwift

struct User {
    let id: String
    let name: String

    func asDatabaseObject() -> UserObject {
        let o = UserObject()
        o.id = id
        o.name = name
        return o
    }
}

final class UserObject: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""

    override public class func primaryKey() -> String? {
        return #keyPath(id)
    }

    func asModel() -> User {
        return User(id: id, name: name)
    }
}