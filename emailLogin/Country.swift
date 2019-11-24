//
//  Country.swift
//  emailLogin
//
//  Created by ismael alali on 16.11.19.
//  Copyright © 2019 user158383. All rights reserved.
//

import Foundation

struct Country: Decodable {
    var ID: String = ""
    var name: String = ""
    var currency: String = ""
    var capital: String = ""
    var native: String = ""
    var continent: String = ""
    var phone: String = ""
    var createTime: Date
    var updateTime: Date
    var languages: [String]
    
    private enum RootCodingKeys: String, CodingKey {
        case ID = "name"
        case createTime
        case updateTime
        case fields
    }
    
    private enum NestedCodingKeys: String, CodingKey {
        case name
        case currency
        case capital
        case native
        case continent
        case phone
        case languages
    }
    
    private enum StringValueCodingKeys: String, CodingKey {
        case stringValue
    }
    
    private enum ArrayValueCodingKeys: String, CodingKey {
        case arrayValue
    }
    
    private enum ArrayValueNestedCodingKeys: String, CodingKey {
        case values
    }
    
    init(from decoder: Decoder) throws {
        
        
        let rootContainer = try decoder.container(keyedBy: RootCodingKeys.self)
        
        let fields = try rootContainer.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .fields)
        let nameNested = try fields.nestedContainer(keyedBy: StringValueCodingKeys.self.self, forKey: .name)
        
        let currencyNested = try fields.nestedContainer(keyedBy: StringValueCodingKeys.self.self, forKey: .currency)
        
        let nativeNested = try fields.nestedContainer(keyedBy: StringValueCodingKeys.self.self, forKey: .native)
        
        let capitalNested = try fields.nestedContainer(keyedBy: StringValueCodingKeys.self.self, forKey: .capital)
        
        let continentNested = try fields.nestedContainer(keyedBy: StringValueCodingKeys.self.self, forKey: .continent)
        
        let phoneNested = try fields.nestedContainer(keyedBy: StringValueCodingKeys.self.self, forKey: .phone)
        
        let languageNested = try fields.nestedContainer(keyedBy: ArrayValueCodingKeys.self, forKey:  .languages)
        
        let arrayValueNested = try languageNested.nestedContainer(keyedBy: ArrayValueNestedCodingKeys.self, forKey: .arrayValue)
        
        ID = (try rootContainer.decode(String.self, forKey: .ID) as NSString).lastPathComponent
        createTime = try rootContainer.decode(Date.self, forKey: .createTime)
        updateTime = try rootContainer.decode(Date.self, forKey: .updateTime)
        
        self.name = try nameNested.decode(String.self, forKey: .stringValue)
        self.capital = try capitalNested.decode(String.self, forKey: .stringValue)
        self.currency = try currencyNested.decode(String.self, forKey: .stringValue)
        self.native = try nativeNested.decode(String.self, forKey: .stringValue)
        self.phone = try phoneNested.decode(String.self, forKey: .stringValue)
        self.continent = try continentNested.decode(String.self, forKey: .stringValue)
        
        // decode other properties...
        
        var valuesNested = try arrayValueNested.nestedUnkeyedContainer(forKey: .values)
        
        var languagesArray = [String]()
        
        while !valuesNested.isAtEnd{
            
            let stringContainer = try valuesNested.nestedContainer(keyedBy: StringValueCodingKeys.self)
            
            languagesArray.append(try stringContainer.decode(String.self, forKey: .stringValue))
            //print(languagesArray)
        }
        
        guard languagesArray.first != nil else {
            
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: rootContainer.codingPath + [RootCodingKeys.fields], debugDescription: "Languages cannot be empty"))
        }
        
        self.languages = languagesArray
    }
    
}


struct DocumentsContainer: Decodable {
    var documents: [Country]
}

// Date JSON parsing
extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

