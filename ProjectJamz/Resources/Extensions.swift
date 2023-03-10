//
//  Extensions.swift
//  JamzApp
//
//  Created by Adrianna Parlato on 2/13/23.
//


import Foundation
import UIKit



//The first extension is for the UIView class. It adds several computed properties to retrieve the dimensions and coordinates of the view's frame. Specifically, it adds width, height, left, right, top, and bottom properties, each of which returns a CGFloat value.
extension UIView {
    var width: CGFloat {
        return frame.size.width
    }
    var height: CGFloat {
        return frame.size.height
    }
    var left: CGFloat {
        return frame.origin.x
    }
    var right: CGFloat {
        return left + width
    }
    var top: CGFloat {
        return frame.origin.y
    }
    var bottom: CGFloat {
        return top + height
    }
    
}

//The second extension is for the DateFormatter class. It defines two static properties, dateFormatter and displayDateFormatter. These properties return DateFormatter objects that are configured to format dates in specific ways. dateFormatter is configured to format dates as "yyyy-mm-dd", while displayDateFormatter is configured to use the medium date style
extension DateFormatter {
    static let dateFormatter: DateFormatter = {
        let dateFomatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        return dateFormatter
    }()

    static let displayDateFormatter: DateFormatter = {
        let dateFomatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
}


//The third extension is for the String class. It defines a static method called formattedDate(string:), which takes a string argument and attempts to convert it to a date using the dateFormatter property from the DateFormatter extension. If the string cannot be converted to a date, the original string is returned. Otherwise, the displayDateFormatter property is used to format the date as a string, which is returned.
extension String {
    static func formattedDate(string: String) -> String {
        guard let date = DateFormatter.dateFormatter.date(from: string) else {
            return string
        }
        return DateFormatter.displayDateFormatter.string(from: date)
    }
}



//when user adds/saved album to library it will automatically update the saved album so the user wotn haveto  reload the  app in order to see it
//The fourth extension is for the Notification.Name class. It defines a static property called albumSavedNotificaion, which returns a Notification.Name object with the name "albumSavedNotificaion". This is used to create a unique identifier for a notification that is sent when a user saves an album to their library. This allows other parts of the app to listen for this notification and update their content accordingly.
extension Notification.Name {
    static let albumSavedNotificaion = Notification.Name("albumSavedNotificaion")
}



