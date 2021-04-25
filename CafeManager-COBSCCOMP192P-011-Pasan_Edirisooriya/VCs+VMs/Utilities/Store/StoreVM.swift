//
//  StoreVM.swift
//  CafeManager-COBSCCOMP192P-011-Pasan_Edirisooriya
//
//  Created by Pasan Induwara Edirisooriya on 4/15/21.
//

import Foundation
import Firebase

enum SelectedSegment:Int{
    case Preview = 0
    case Category = 1
    case Menu = 2
}

struct Category:Encodable {
    var id:String
    var name:String?
    
    init(snapshot: QueryDocumentSnapshot) {
        id = snapshot.documentID
        let snapshotValue = snapshot.data()
        name = snapshotValue["name"] as? String
    }
    
}

struct Food:Encodable {
    var id:String?
    var name:String?
    var imageUrl:String?
    var description:String?
    var price:String?
    var discount:String?
    var categoryId: String?
    var categoryName: String?
    var isSell:Bool?
    
    init(snapshot: QueryDocumentSnapshot,category:NSDictionary) {
        id = snapshot.documentID
        let snapshotValue = snapshot.data()
        name = snapshotValue["name"] as? String
        imageUrl = snapshotValue["imageUrl"] as? String
        description = snapshotValue["description"] as? String
        price = snapshotValue["price"] as? String
        discount = snapshotValue["discount"] as? String
        categoryId = category.value(forKey:"id") as? String
        categoryName = category.value(forKey:"name") as? String
        isSell = snapshotValue["isSell"] as? Bool
    }
    
}

struct SectionTable {
    var sectionName: String?
    var foods: [Food]
    
    init(sectionName: String?, foods: [Food]) {
        self.sectionName = sectionName
        self.foods = foods
    }
}


class StoreVM:BaseVM{
    
}
