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
        let status = SecItemCopyMatching(keychainDictionary, &returnObjectReference)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            assertionFailure(OSStatusToError(status).localizedDescription)
            return nil
        }
        
        var value: T?

        if let data = returnObjectReference as? Data {
            value = decodeData(data)
        }
        
        return value
    }
    
    static func removeObject(forKey key: String) {
        let keychainDictionary = createKeychainDictionary(forKey: key)
        
        let status = SecItemDelete(keychainDictionary)
        
        guard status == errSecSuccess else {
            assertionFailure(OSStatusToError(status).localizedDescription)
            return
        }
    }
    
    static func hasValue(forKey key: String) -> Bool {
        let keychainDictionary = createKeychainDictionary(forKey: key, shouldReturn: false)
        
        let status = SecItemCopyMatching(keychainDictionary, nil)
        var isExist: Bool
        
        switch status {
        case errSecSuccess:
            isExist = true
        case errSecItemNotFound:
            isExist = false
        default:
            assertionFailure(OSStatusToError(status).localizedDescription)
            isExist = false
        }
        
        return isExist
    }
}

// MARK: - Private Methods

private extension KeychainWrapper {
    static func createValue(_ value: Data, forKey key: String) {
        let keychainDictionary = createKeychainDictionary(forKey: key, value: value)
        
        let status = SecItemAdd(keychainDictionary, nil)
        
        guard status == errSecSuccess else {
            assertionFailure(OSStatusToError(status).localizedDescription)
            return
        }
    }
    
    static func updateValue(_ value: Data, forKey key: String) {
        let keychainDictionary = createKeychainDictionary(forKey: key)
        let keychainValueDictionary = createKeychainValueDictionary(value)
        
        let status = SecItemUpdate(keychainDictionary, keychainValueDictionary)
        
        guard status == errSecSuccess else {
            assertionFailure(OSStatusToError(status).localizedDescription)
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

// MARK: - Helper Methods

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
    
    static func OSStatusToError(_ status: OSStatus) -> Error {
        let message = SecCopyErrorMessageString(status, nil) as String? ?? "Unknown error"
        let userInfo = [NSLocalizedDescriptionKey: message]
        let error = NSError(domain: NSOSStatusErrorDomain, code: Int(status), userInfo: userInfo)

        return error
    }
}
