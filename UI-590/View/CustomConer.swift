//
//  CustomConer.swift
//  UI-590
//
//  Created by nyannyan0328 on 2022/06/17.
//

import SwiftUI

struct CustomConer: Shape {
    var radi : CGFloat
    var corner : UIRectCorner
  
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corner, cornerRadii: CGSize(width: radi, height: radi))
        
        return .init(path.cgPath)
    }
}
