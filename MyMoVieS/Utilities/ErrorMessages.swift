//
//  ErrorMessages.swift
//  MyMoVieS
//
//  Created by Abdulloh on 30/07/24.
//

import Foundation

enum GFError: String, Error {
    case invalidUsername = "This is an invalid request."
    case unableTo = "Unable to complete your request. Check your internet connection."
    case invalidRes = "Invalid response from server."
    case invalidData = "The data received from the server is invalid 1."
    case invalidData2 = "The data received from the server is invalid 2."
}
