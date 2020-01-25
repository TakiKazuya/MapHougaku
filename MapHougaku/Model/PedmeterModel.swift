//
//  PedmeterModel.swift
//  MapHougaku
//
//  Created by 国分和弥 on 2020/01/25.
//  Copyright © 2020 Kazuya Kokubun. All rights reserved.
//

import Foundation
import  CoreMotion

class PedmeterModel{
    
    var pedometer = CMPedometer()
    
    var steps = Int()
    var directionNumber = Int()
    
    init(kyori:Int,hougaku:Int) {
        self.steps = kyori
        self.directionNumber = hougaku
        print("距離は\(steps)歩です")
        print("方角は\(directionNumber)番です")
    }
    
   
    
    
}
