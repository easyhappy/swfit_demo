//
//  Action.js
//  NoteAppExtension
//
//  Created by andyhu on 14/12/30.
//  Copyright (c) 2014年 andyhu. All rights reserved.
//

var Action = function() {};

Action.prototype = {
    
    run: function(arguments) {
        // 在这个方法里，你可以通过document操作HTML中的元素，或者可以将HTML中的内容传给ActionRequestHandler文件的代码。
        
        // 在本文的例子中，我们不做任何更新，只是将HTML中选中的内容穿给ActionRequestHandler文件的代码。
        var selected = "No Text Selected";
        if (window.getSelection) {
            selected = window.getSelection().getRangeAt(0).toString();
        } else {
            selected = document.getSelection().getRangeAt(0).toString();
        }
        arguments.completionFunction({"args" : selected});
    },
    
    finalize: function(arguments) {
        // 当ActionRequestHandler文件中的itemLoadCompletedWithPreprocessingResults方法执行完之后会调用该方法。
        
        // 如果ActionRequestHandler文件向HTML返回了信息，我们可以通过arguments["message"]来查看，并且可以根据该信息操作HTML中的元素。
        alert(arguments["message"])
    }
    
};
    
var ExtensionPreprocessingJS = new Action
