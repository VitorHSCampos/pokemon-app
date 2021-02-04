//
//  User.swift
//  PokeApp
//
//  Created by Vitor Campos on 2/3/21.
//

import Foundation
import RealmSwift

@objcMembers class User: Object, Decodable {
    dynamic var id: Int = 0
    dynamic var name: String = ""
    dynamic var email: String = ""

    enum CodingKeys: String, CodingKey {
        case id, first_name, last_name, email
    }

    override class func primaryKey() -> String? {
        return "id"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)

        let firstName = try container.decode(String.self, forKey: .first_name)
        let lastName = try container.decode(String.self, forKey: .last_name)
        name = "\(firstName) \(lastName)"

        email = try container.decode(String.self, forKey: .email)

        super.init()
    }

    required override init() {
        super.init()
    }
    
    func saveUser() {
        let realm = try! Realm()
        try? realm.write {
            realm.add(self)
        }
    }
    
    static func checkUserExists(email: String) -> User? {
        let realm = try! Realm()
        return realm.objects(User.self).filter("email == %@", email).first
    }

}
