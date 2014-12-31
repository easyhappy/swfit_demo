//
//  ActionRequestHandler.swift
//  NoteAppExtension
//
//  Created by andyhu on 14/12/30.
//  Copyright (c) 2014年 andyhu. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionRequestHandler: NSObject, NSExtensionRequestHandling {

    var extensionContext: NSExtensionContext?
    
    func beginRequestWithExtensionContext(context: NSExtensionContext!) {
        self.extensionContext = context
        let identifierType = NSString(format: kUTTypePropertyList, NSUTF8StringEncoding)
        for (item: NSExtensionItem) in context.inputItems as [NSExtensionItem] {
            for (itemProvider: NSItemProvider) in item.attachments as [NSItemProvider] {
                if itemProvider.hasItemConformingToTypeIdentifier(identifierType) {
                    itemProvider.loadItemForTypeIdentifier(identifierType, options: nil, completionHandler: {(item, error) in
                        let dictionary = item as NSDictionary
                        dispatch_async(dispatch_get_main_queue(), {
                            self.itemLoadCompletedWithPreprocessingResults(dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as NSDictionary)
                        })
                    })
                }
            }
        }
    }
    
    func itemLoadCompletedWithPreprocessingResults(javaScriptPreprocessingResults: NSDictionary) {
        if let text = javaScriptPreprocessingResults["args"] as? String {
            let userDefaults = NSUserDefaults(suiteName: "group.name")
            userDefaults?.setValue(text, forKey: "note")
            userDefaults?.synchronize()
            self.doneWithResults(["message": "Successfully added to the note app"])
        }
    }
    
    func doneWithResults(resultsForJavaScriptFinalizeArg: NSDictionary?) {
        if let resultsForJavaScriptFinalize = resultsForJavaScriptFinalizeArg {
            let identifierType = NSString(format: kUTTypePropertyList, NSUTF8StringEncoding)
            // 创建合适返回类型的标示符。
            
            // 这里创建的resultsItem将作为Action.js文件中finalize方法的参数。
            var resultsDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: resultsForJavaScriptFinalize]
            
            var resultsProvider = NSItemProvider(item: resultsDictionary, typeIdentifier: identifierType)
            
            var resultsItem = NSExtensionItem()
            resultsItem.attachments = [resultsProvider]
            
            // 这段代码意味着Action扩展已经处理完了逻辑，现在将信息返回给Action.js文件。
            self.extensionContext!.completeRequestReturningItems([resultsItem], completionHandler: nil)
        } else {
            // 就算我们没有任何要返回的信息，也要执行这段代码，用于告知我们的Action扩展已经完成了逻辑处理。
            self.extensionContext!.completeRequestReturningItems(nil, completionHandler: nil)
        }
        
        self.extensionContext = nil
    }
}
