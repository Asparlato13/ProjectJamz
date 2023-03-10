//
//  SettingsModels.swift
//  JamzApp
//
//  Created by Adrianna Parlato on 2/13/23.
//

import Foundation

//The Section struct has two properties: title, which is a string representing the section's title, and options, which is an array of Option structs.
struct Section {
    let title: String
    let options: [Option]
    
}


//The Option struct has two properties: title, which is a string representing the option's title, and handler, which is a closure that takes no arguments and returns no value (i.e. () -> Void). The handler closure is used to perform some action when the user selects this option.
struct Option {
    let title: String
    let handler: () -> Void
    
}
