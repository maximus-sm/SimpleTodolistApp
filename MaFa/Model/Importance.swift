//
//  Importance.swift
//  MaFa
//
//  Created by Sundet Mukhtar on 20.07.2024.
//

import Foundation

enum Importance:Int {
    case critical = 0;
    case urgent   = 1;
    case regular  = 2;
    
}

extension Importance: CustomStringConvertible{
    
    public var description: String{
        switch self {
        case .critical:
            return "Critical"
            
        case .urgent:
            return "Urgent"
            
        case .regular:
            return "Regular"
            
        default:
            return "Unknown"
            
        }
        
    }
}
