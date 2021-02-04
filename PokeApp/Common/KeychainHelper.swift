//
//  KeychainHelper.swift
//  PokeApp
//
//  Created by Vitor Campos on 2/4/21.
//

import Foundation
import KeychainAccess

class KeychainHelper {
    
    static func getRealmEncryptionKey() -> Data {
        let keychain = Keychain(service: "com.vitor.pokeapp")
        let key = keychain[data: "realm_key"]
        
        if key == nil {
            var data = Data(count: 64)
            data.withUnsafeMutableBytes {
                _ = SecRandomCopyBytes(kSecRandomDefault, 64, $0.baseAddress!)
            }
                        
            keychain[data: "realm_key"] = data
                        
            return data
        }
        
        return key!
    }
    
    static func saveUserPassword(email: String, password: String) {
        let keychain = Keychain(service: "com.vitor.pokeapp")
        keychain[email] = password
    }
    
    static func retrieveUserPassword(email: String) -> String? {
        let keychain = Keychain(service: "com.vitor.pokeapp")
        return keychain[email]
    }
}
