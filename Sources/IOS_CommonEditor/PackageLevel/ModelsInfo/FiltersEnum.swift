//
//  FiltersEnum.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 04/01/25.
//


public enum FiltersEnum : Int{
    case none = 0
    case blackNWhite = 1
    case sepia = 2
    case falseColor = 3
    case monoChrome = 4
    case sketch = 5
    case softElegance = 6
    case massEtikate = 7
    case poolkadot = 8
}

public enum AdjustmentsEnum{
    case brightness
    case contrast
    case highlight
    case shadows
    case saturation
    case vibrance
    case sharpness
    case warmth
    case tint
}

func getFilter(filterNumber : Int) -> FiltersEnum{
    if filterNumber == 0 {
        return .none
    }
    
    else if filterNumber == 1{
        return .blackNWhite
    }
    
    else if filterNumber == 2{
        return .sepia
    }
    
    else if filterNumber == 3{
        return .falseColor
    }
    
    else if filterNumber == 4{
        return .monoChrome
    }
    
    else if filterNumber == 5{
        return .sketch
    }
    
    else if filterNumber == 6{
        return .softElegance
    }
    
    else if filterNumber == 7{
        return .massEtikate
    }
    
    else if filterNumber == 8{
        return .poolkadot
    }
    
    return .none
}
