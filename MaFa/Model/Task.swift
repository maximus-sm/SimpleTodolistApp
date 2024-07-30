//
//  Task.swift
//  MaFa
//
//  Created by Sundet Mukhtar on 26.08.2024.
//

import Foundation
import RealmSwift

class Task:Object{
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title:String;
    @Persisted var descrip:String;
    @Persisted var importance:Int;
    @Persisted var time:Int;
    @Persisted var endTime:Double;
    @Persisted var isDone:Bool = false;
    @Persisted var doneTime = 0.0;
    @Persisted var repetitve = 0;
}
