import Foundation

enum KeychainWrapper {
    private static var defaultService: String {
        return Bundle.main.bundleIdentifier ?? String(describing: Self.self)
    }
}

// MARK: - Public Methods

extension KeychainWrapper {
    static func setValue<T: Codable>(_ value: T, forKey key: String) {
        if hasValue(forKey: key) {
            update(value, forKey: key)
        } else {
            create(value, forKey: key)
        }
    }
    
    static func object<T: Codable>(forKey key: String) -> T? {
        let keychainDictionary = createKeychainDictionary(forKey: key, shouldReturn: true)
        
        var returnObjectReference: AnyObject?
        let returnStatus = SecItemCopyMatching(keychainDictionary, &returnObjectReference)
        
        guard
            returnStatus == errSecSuccess,
            let data = returnObjectReference as? Data
        else {
            assertionFailure("Unable to get keychain item")
            return nil
        }
        
        return decodeData(data)
    }
    
    static func removeObject(forKey key: String) {
        let keychainDictionary = createKeychainDictionary(forKey: key)
        
        let removeStatus = SecItemDelete(keychainDictionary)
        
        guard removeStatus == errSecSuccess else {
            assertionFailure("Unable to remove item")
            return
        }
    }
    
    static func hasValue(forKey key: String) -> Bool {
        let keychainDictionary = createKeychainDictionary(forKey: key, shouldReturn: false)
        
        let returnStatus = SecItemCopyMatching(keychainDictionary, nil)
        var isExist: Bool
        
        switch returnStatus {
        case errSecSuccess:
            isExist = true
        case errSecItemNotFound:
            isExist = false
        default:
            assertionFailure("Unable to get keychain item")
            isExist = false
        }
        
        return isExist
    }
}

// MARK: - Private Methods

private extension KeychainWrapper {
    static func create<T: Codable>(_ value: T, forKey key: String) {
        let keychainDictionary = createKeychainDictionary(forKey: key, value: value)
        
        let addStatus = SecItemAdd(keychainDictionary, nil)
        
        guard addStatus == errSecSuccess else {
            assertionFailure("Unable to store keychain item")
            return
        }
    }
    
    static func update<T: Codable>(_ value: T, forKey key: String) {
        let keychainDictionary = createKeychainDictionary(forKey: key)
        let keychainValueDictionary = createKeychainValueDictionary(value)
        
        let updateStatus = SecItemUpdate(keychainDictionary, keychainValueDictionary)
        
        guard updateStatus == errSecSuccess else {
            assertionFailure("Unable to update keychain item")
            return
        }
    }
}

// MARK: - Keychain Dictionary Helpers

private extension KeychainWrapper {
    static func createKeychainDictionary<T: Codable>(
        forKey key: String,
        value: T
    ) -> CFDictionary {
        var keychainDictionary = createKeychainKeyDictionary(key)
        keychainDictionary[kSecValueData] = encodeValue(value)
        
        return keychainDictionary as CFDictionary
    }
    
    static func createKeychainDictionary(
        forKey key: String,
        shouldReturn: Bool? = nil
    ) -> CFDictionary {
        var keychainDictionary = createKeychainKeyDictionary(key)
        
        if let shouldReturn = shouldReturn {
            keychainDictionary[kSecReturnData] = shouldReturn
        }
        
        return keychainDictionary as CFDictionary
    }
    
    static func createKeychainKeyDictionary(_ key: String) -> [CFString: Any] {
        let keychainDictionary: [CFString: Any] = [
            kSecAttrAccount: key,
            kSecAttrService: defaultService,
            kSecClass: kSecClassGenericPassword
        ]
        
        return keychainDictionary
    }
    
    static func createKeychainValueDictionary<T: Codable>(_ value: T) -> CFDictionary {
        return [kSecValueData: encodeValue(value)] as CFDictionary
    }
}

// MARK: - Codable

private extension KeychainWrapper {
    static func encodeValue<T: Encodable>(_ value: T) -> Data? {
        var data: Data?
        
        do {
            let encoder = JSONEncoder()
        
            data = try encoder.encode(value)
        } catch let error {
            assertionFailure("Encoding error: \(error.localizedDescription)")
        }
        
        return data
    }
    
    static func decodeData<T: Decodable>(_ data: Data) -> T? {
        var value: T?
        
        do {
            let jsonDecoder = JSONDecoder()

            value = try jsonDecoder.decode(T.self, from: data)
        } catch let error {
            assertionFailure("Decoding error: \(error.localizedDescription)")
        }
        
        return value
    }
}
