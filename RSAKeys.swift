//
//  RSAKeys.swift
//  RSAKeys
//
//  Created by Krish Kharbanda on 4/19/22.
//

import Foundation
import UIKit

struct RSAKeys {

    enum KeyType {
        case publicKey
        case privateKey
    }
    
    let algorithm: SecKeyAlgorithm = .rsaEncryptionOAEPSHA256
    
    private var publicKey: SecKey?
    private var privateKey: SecKey?
    
    init() {
        let (privateKey, publicKey) = createKey(from: UIDevice.current.identifierForVendor!.uuidString)
        guard let privateKey = privateKey, let publicKey = publicKey else { return }
        
        self.privateKey = privateKey
        self.publicKey = publicKey
        
        let addQuery: [String: Any] = [kSecClass as String: kSecClassKey, kSecAttrApplicationTag as String: "\(Bundle.main.bundleIdentifier!).\(UIDevice.current.identifierForVendor!.uuidString)", kSecValueRef as String: privateKey]
        let status = SecItemAdd(addQuery as CFDictionary, nil)
        guard status == errSecSuccess else { return }
    }
    init(publicKey: SecKey, privateKey: SecKey) {
        self.publicKey = publicKey
        self.privateKey = privateKey
    }
    
    private func createKey(from uuid: String) -> (SecKey?, SecKey?) {
        var error: Unmanaged<CFError>?
        
        let keyAttributes: [String: Any] = [kSecAttrType as String: kSecAttrKeyTypeRSA, kSecAttrKeySizeInBits as String: 2048, kSecPrivateKeyAttrs as String: [kSecAttrIsPermanent as String: true, kSecAttrApplicationTag as String: ("\(Bundle.main.bundleIdentifier!).\(uuid)").data(using: .utf8)!]]
        
        do {
            guard let privateKey = SecKeyCreateRandomKey(keyAttributes as CFDictionary, &error) else {
                throw error!.takeRetainedValue() as Error
            }
            guard let publicKey = SecKeyCopyPublicKey(privateKey) else {
                throw error!.takeRetainedValue() as Error
            }
            return (privateKey, publicKey)
        } catch {
            print(error.localizedDescription)
            return (nil, nil)
        }
    }
    private func recreateKey(from publicKeyString: String) -> SecKey? {
        let data = Data(base64Encoded: publicKeyString)!
        let options: [String: Any] = [kSecAttrKeyType as String: kSecAttrKeyTypeRSA, kSecAttrKeyClass as String: kSecAttrKeyClassPublic]
        var error: Unmanaged<CFError>?
        do {
            guard let key = SecKeyCreateWithData(data as CFData, options as CFDictionary, &error) else {
                throw error!.takeRetainedValue() as Error
            }
            return key
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    public func getKey(of type: KeyType) -> SecKey? {
        switch type {
        case .publicKey:
            guard let publicKey = self.publicKey else { return nil }
            return publicKey
        case .privateKey:
            guard let privateKey = self.privateKey else { return nil }
            return privateKey
        }
    }
    public func getPublicKeyAsString() -> String? {
        var error: Unmanaged<CFError>?
        guard let key = getKey(of: .publicKey) else { return nil }
        guard let cfData = SecKeyCopyExternalRepresentation(key, &error) else {
            print((error!.takeRetainedValue() as Error).localizedDescription)
            return nil
        }
        return (cfData as Data).base64EncodedString()
    }
    
    public func encrypt(_ message: String) -> String? {
        var error: Unmanaged<CFError>?
        
        guard let key = getKey(of: .publicKey) else { return nil }
        let messageEncrypted = message.data(using: .utf8)!
        
        do {
            guard let cfData = SecKeyCreateEncryptedData(key, algorithm, messageEncrypted as CFData, &error) else {
                throw error!.takeRetainedValue() as Error
            }
            return (cfData as Data).base64EncodedString()
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    public func encrypt(_ message: String, using publicKeyString: String) -> String? {
        guard let key = recreateKey(from: publicKeyString) else { return nil }
        
        var error: Unmanaged<CFError>?
        let messageEncrypted = message.data(using: .utf8)!
        
        do {
            guard let cfData = SecKeyCreateEncryptedData(key, algorithm, messageEncrypted as CFData, &error) else {
                throw error!.takeRetainedValue() as Error
            }
            return (cfData as Data).base64EncodedString()
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    public func decrypt(_ message: String) -> String? {
        var error: Unmanaged<CFError>?
        guard let messageData = Data(base64Encoded: message) else { return nil }
        guard let key = getKey(of: .privateKey) else { return nil }
        
        do {
            guard let cfData = SecKeyCreateDecryptedData(key, algorithm, messageData as CFData, &error) else {
                throw error!.takeRetainedValue() as Error
            }
            return String(data: (cfData as Data), encoding: .utf8)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
