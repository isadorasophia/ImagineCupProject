//
//  ServerConnection.swift
//  DoeNota
//
//  Created by Isa Sophia on 2/12/15.
//  Copyright (c) 2015 Isadora Sophia. All rights reserved.
//

import UIKit

class ServerConnection: NSObject, NSURLConnectionDelegate, NSXMLParserDelegate {
    class var sharedInstance: ServerConnection {
        struct Static {
            static var instance: ServerConnection?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = ServerConnection()
        }
        
        return Static.instance!
    }
    
    class func sendToServer (imageData: NSData, user: NSString, institution: NSString) -> Bool {
        var imageBase64 = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding76CharacterLineLength)
        
        var head = "<?xml version='1.0' encoding='utf-8'?>\n<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:not=\"http://lampiao.ic.unicamp.br:8085/WebServiceNotaFiscal/webservices/NotaFiscalImplementation?wsdl\">\n"
        var body = "<soapenv:Header/>\n<soapenv:Body>\n<not:upload>\n<arg0>\(imageBase64)</arg0>\n<arg1>\(user)</arg1>\n<arg2>\(institution)</arg2>\n<arg3>IOS</arg3>\n"
        var end = "</not:upload>\n</soapenv:Body>\n</soapenv:Envelope>"
        
        var parameters = head + body + end
        
        let urlString = "http://lampiao.ic.unicamp.br:8085/WebServiceNotaFiscal/webservices/NotaFiscalImplementation?wsdl"
        let url = NSURL(string: urlString)
        
        var request = NSMutableURLRequest(URL: url!)
        
        var msgLength = String(countElements(parameters))
        
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(msgLength, forHTTPHeaderField: "Content-Length")
        request.HTTPMethod = "POST"
        request.HTTPBody = parameters.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        //var connection = NSURLConnection(request: request, delegate: self, startImmediately: true)
        
        //connection?.start()
        
        return true
    }
    
    class func connection(connection: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        // Get the request response
    }
    
    class func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        // Connection data
    }
    
    
    class func connectionDidFinishLoading(connection: NSURLConnection!) {
        // Knows that the connection have finished
    }
}
