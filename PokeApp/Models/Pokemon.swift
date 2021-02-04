//
//  Pokemon.swift
//  PokeApp
//
//  Created by Vitor Campos on 2/4/21.
//

import Foundation
import RealmSwift

struct PokemonIndex: Decodable {
    let name: String
}

@objcMembers class Pokemon: Object, Decodable {
    dynamic var id = 0
    dynamic var name = ""
    dynamic var image = ""
    dynamic var hp = 0
    dynamic var attack = 0
    dynamic var defense = 0
    dynamic var speed = 0

    enum CodingKeys: String, CodingKey {
        case id, name, image, hp, attack, defense, speed
    }

    override class func primaryKey() -> String? {
        return "id"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        image = try container.decode(String.self, forKey: .image)
        hp = try container.decode(Int.self, forKey: .hp)
        attack = try container.decode(Int.self, forKey: .attack)
        defense = try container.decode(Int.self, forKey: .defense)
        speed = try container.decode(Int.self, forKey: .speed)

        super.init()
    }

    required override init() {
        super.init()
    }
    
    func detachedCopy() -> Pokemon {
        let detached = type(of: self).init()
        for property in objectSchema.properties {
            guard let value = value(forKey: property.name) else { continue }
            detached.setValue(value, forKey: property.name)
        }
        
        return detached
    }
    
    func isFavorite() -> Bool {
        let realm = try! Realm()
        return realm.objects(Pokemon.self).filter("id == %d", self.id).first != nil
    }
    
    func favorite() {
        let realm = try! Realm()
        try! realm.write {
            realm.add(self.detachedCopy())
        }
    }
    
    func removeFavorite() {
        let realm = try! Realm()
        try! realm.write {
            if let pokemon = realm.objects(Pokemon.self).filter("id == %d", self.id).first {
                realm.delete(pokemon)
            }
        }
    }
    
    static func listAllFavorites() -> Results<Pokemon> {
        let realm = try! Realm()
        return realm.objects(Pokemon.self)
    }
}
