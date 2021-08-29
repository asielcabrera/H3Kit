//
//  H3Kit.swift
//
//
//  Created by Asiel Cabrera Gonzalez on 2/8/21.
//

open class H3 {
    
    static var resolution: Int32 = 10
    static var coordinates: IndexCordinate = IndexCordinate(latitude: 0.0, longitude: 0.0)
    static var indexH3: H3Index = H3Index(coordinate: H3.coordinates, resolution: H3.resolution)
    
    static func cordToIndex(cord: IndexCordinate, res: Int32) -> H3Index {
        
        H3.coordinates = cord
        H3.resolution = res
        
        return H3Index(coordinate: H3.coordinates, resolution: 10)
    }
    
    static func indexToCord(index: H3Index) -> IndexCordinate {
        return indexH3.coordinate
    }
    
}
