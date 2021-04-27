//
//  OrderVM.swift
//  CafeManager-COBSCCOMP192P-011-Pasan_Edirisooriya
//
//  Created by Pasan Induwara Edirisooriya on 4/27/21.
//

import Foundation

struct SectionedOrders {
    var sectionName: String?
    var orders: [OrderModal]
    
    init(sectionName: String?, orders: [OrderModal]) {
        self.sectionName = sectionName
        self.orders = orders
    }
}

class OrderVM : BaseVM{
    
}
