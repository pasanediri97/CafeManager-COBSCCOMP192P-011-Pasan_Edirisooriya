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

struct Category {
    var id:String
    var name:String?
    
    init(snapshot: QueryDocumentSnapshot) {
        id = snapshot.documentID
        let snapshotValue = snapshot.data()
        name = snapshotValue["name"] as? String
    }
    
}

class StoreVM:BaseVM{
    
}
