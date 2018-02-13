//
//  Category.swift
//  Todoey
//
//  Created by Taiwo on 12/02/2018.
//  Copyright © 2018 Taiwo. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {

    @objc dynamic var name: String = ""
    let items = List<Item>()
}
