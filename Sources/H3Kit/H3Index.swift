//
//  H3Index.swift
//  
//
//  Created by Asiel Cabrera Gonzalez on 2/8/21.
//

import Ch3

public struct H3Index {
    
    private static let invalidIndex = 0
    
    private var value: UInt64
    
    public var isValid: Bool { h3IsValid(value) == 1 }
    
    public var resolution: Int { Int(h3GetResolution(value)) }
    
    public var coordinate: IndexCordinate {
        
        var coord = GeoCoord()
        h3ToGeo(value, &coord)
        
        let latRad = degsToRads(coord.lat)
        let longRad = degsToRads(coord.lon)
        
        return IndexCordinate(latitude: latRad, longitude: longRad)
    }
    
    public var directParent: H3Index? { parent(at: resolution - 1) }
    
    public var directCenterChild: H3Index? { centerChild(at: resolution + 1) }
    
    public init(_ value: UInt64) { self.value = value }
    
    public init(coordinate: IndexCordinate, resolution: Int32) {
        
        let latRad = degsToRads(coordinate.latitude)
        let longRad = degsToRads(coordinate.longitude)
        
        var coord = GeoCoord(lat: latRad, lon: longRad)
        
        self.value = geoToH3(&coord, Int32(resolution))
    }
    
    public init(string: String) {
        
        var value: UInt64 = 0
        
        string.withCString { value = stringToH3($0) }
        
        self.value = value
    }
    
    public func kRingIndices(ringK: Int32) -> [H3Index] {
        
        var indices = [UInt64](repeating: 0, count: Int(maxKringSize(ringK)))
        
        indices.withUnsafeMutableBufferPointer { ptr in
            kRing(value, ringK, ptr.baseAddress)
        }
        
        return indices.map { H3Index($0) }
    }
    
    public func parent(at resolution: Int) -> H3Index? {
        
        let val = h3ToParent(value, Int32(resolution))
        
        return val == H3Index.invalidIndex ? nil : H3Index(val)
    }
    
    public func children(at resolution: Int) -> [H3Index] {
        
        var children = [UInt64](
            repeating: 0,
            count: Int(maxH3ToChildrenSize(value, Int32(resolution)))
        )
        
        children.withUnsafeMutableBufferPointer { ptr in
            h3ToChildren(value, Int32(resolution), ptr.baseAddress)
        }
        
        return children
            .filter { $0 != 0 }
            .map { H3Index($0) }
    }
    
    public func centerChild(at resolution: Int) -> H3Index? {
        
        let index = h3ToCenterChild(value, Int32(resolution))
        
        return index == H3Index.invalidIndex ? nil : H3Index(index)
    }
}

extension H3Index: CustomStringConvertible {

    public var description: String {
        let cString = strdup("")
        h3ToString(value, cString, 17)
        return String(cString: cString!)
    }

}

extension H3Index: Equatable, Hashable {}
