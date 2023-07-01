//
//  EncodeDecodeUtil.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 01/07/23.
//

import Foundation

private let jsonEncoder = JSONEncoder()
private let jsonDecoder = JSONDecoder()

class CodableUtil {
    func encode<T>(data: T) -> String? where T: Codable {
        do {
            let jsonData = try jsonEncoder.encode(data)
            let json = String(data: jsonData, encoding: String.Encoding.utf8)
            return json
        } catch {
            print(">> Failed encode")
        }
        return nil
    }
    
    func decode<T>(_: T, from json: String) -> T? where T: Codable {
        do {
            guard let jsonData = json.data(using: String.Encoding.utf8) else {
                return nil
            }
            let data = try jsonDecoder.decode(T.self, from: jsonData)
            return data
        } catch {
            print(">> Failed to decode")
        }
        return nil
    }
}
