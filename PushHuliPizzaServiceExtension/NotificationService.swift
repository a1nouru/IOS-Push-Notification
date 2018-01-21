//
//  NotificationService.swift
//  PushHuliPizzaServiceExtension
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    func changePizzaNotificationContent(content oldContent:UNNotificationContent)-> UNMutableNotificationContent{
        let content = oldContent.mutableCopy() as! UNMutableNotificationContent
        let userInfo = content.userInfo as! [String:Any]
        //add the subtitle
        if let subtitle = userInfo["subtitle"] {
            content.subtitle = subtitle as! String
        }
        
        if let orderEntry = userInfo["order"]{
            let orders = orderEntry as! [String]
            var body = ""
            for item in orders{
                body += item + ", "
            }
            content.body = body
        }
        return content
    }
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        if bestAttemptContent?.categoryIdentifier == "pizza.category"{
            bestAttemptContent = changePizzaNotificationContent(content: request.content)
        }
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title) - push Pizza"
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            let userInfo = bestAttemptContent.userInfo as![String:Any]
            if let subtitle = userInfo["subtitle"] {
                bestAttemptContent.subtitle = subtitle as! String
            }
            
            if let orderEntry = userInfo["order"]{
                let orders = orderEntry as! [String]
                var body = ""
                for item in orders{
                    body += item + ", "
                }
                bestAttemptContent.body = body
            }
            contentHandler(bestAttemptContent)
        }
    }

}










