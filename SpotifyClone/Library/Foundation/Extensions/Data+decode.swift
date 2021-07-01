import Foundation

extension Data {
    func decode<T>(_ type: T.Type) -> T? where T: Decodable {
        var decodedData: T?
        
        do {
            let jsonDecoder = JSONDecoder()

            decodedData = try jsonDecoder.decode(T.self, from: self)
        } catch let error {
            assertionFailure("Unable to decode data: \(error.localizedDescription)")
        }
        
        return decodedData
    }
}
