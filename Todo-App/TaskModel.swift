//
//  TaskModel.swift
//  Todo-App
//
//  Created by Admin on 2/22/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import RealmSwift


class TaskModel : Object{
    dynamic var toDo = ""
    dynamic var priority = -1
    dynamic var date = 0.0
}
