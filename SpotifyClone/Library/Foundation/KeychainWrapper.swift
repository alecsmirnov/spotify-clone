import Foundation

enum KeychainWrapper {
    private static var defaultService: String {
        return Bundle.main.bundleIdentifier ?? String(describing: Self.self)
    }
}

// MARK: - Public Methods

extension KeychainWrapper {
    static func setValue<T: Codable>(_ value: T, forKey key: String) {
        guard let valueData = encodeValue(value) else { return }
        
        if hasValue(forKey: key) {
            updateValue(valueData, forKey: key)
        } else {
            createValue(valueData, forKey: key)
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
            assertionFailure("Unable to get object")
            return nil
        }
        
        return decodeData(data)
    }
    
    static func removeObject(forKey key: String) {
        let keychainDictionary = createKeychainDictionary(forKey: key)
        
        let removeStatus = SecItemDelete(keychainDictionary)
        
        guard removeStatus == errSecSuccess else {
            assertionFailure("Unable to remove object")
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
            assertionFailure("Unable to get object")
            isExist = false
        }
        
        return isExist
    }
}

// MARK: - Private Methods

private extension KeychainWrapper {
    static func createValue(_ value: Data, forKey key: String) {
        let keychainDictionary = createKeychainDictionary(forKey: key, value: value)
        
        let addStatus = SecItemAdd(keychainDictionary, nil)
        
        guard addStatus == errSecSuccess else {
            assertionFailure("Unable to store value")
            return
        }
    }
    
    static func updateValue(_ value: Data, forKey key: String) {
        let keychainDictionary = createKeychainDictionary(forKey: key)
        let keychainValueDictionary = createKeychainValueDictionary(value)
        
        let updateStatus = SecItemUpdate(keychainDictionary, keychainValueDictionary)
        
        guard updateStatus == errSecSuccess else {
            assertionFailure("Unable to update value")
            return
        }
    }
}

// MARK: - Keychain Dictionary Helpers

private extension KeychainWrapper {
    static func createKeychainDictionary(
        forKey key: String,
        value: Data? = nil,
        shouldReturn: Bool? = nil
    ) -> CFDictionary {
        var keychainDictionary: [CFString: Any] = [
            kSecAttrAccount: key,
            kSecAttrService: defaultService,
            kSecClass: kSecClassGenericPassword
        ]
        
        if let value = value {
            keychainDictionary[kSecValueData] = value
        }
        
        if let shouldReturn = shouldReturn {
            keychainDictionary[kSecReturnData] = shouldReturn
        }
        
        return keychainDictionary as CFDictionary
    }
    
    static func createKeychainValueDictionary(_ value: Data) -> CFDictionary {
        return [kSecValueData: value] as CFDictionary
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
