//
//  AlertMessages.swift
//  Medicard
//
//  Created by Al John Albuera on 11/27/16.
//  Copyright © 2016 Al John Albuera. All rights reserved.
//

import UIKit

class AlertMessages: NSObject {
    
    public static let errorTitle = "Hold On"
    public static let successTitle = "Success!"
    public static let uploadPhotoTitle = "Upload Photo"
    public static let noInternetConnectionMessage = "Please check your internet connection."
    public static let successUploadPhoto = "You have successfully uploaded your photo."
    public static let errorUploadPhoto = "Failed to upload photo. Please try again."
    public static let successAccountCreated = "You have successfully created an account. Please login to begin."
    public static let errorEmptyFields = "Please fill up the required fields.";
    public static let errorAlreadAdded = "Something went wrong. Member Account was not found."
    public static let errorNotADependent = "Something went wrong. Dependent Member ID is not your dependent."
    public static let successAddDependent = "You have successfully added a dependent."
    public static let warningLogout = "Are you sure you want to logout?"
    public static let warningUploadPhoto = "Updating of Photo will request a validation from MediCard?"
    public static let errorCredentials = "It seems like you've got the wrong username/password. Please try again."
    public static let errorAccountLocked = "Account is locked due to incorrect input of your username or password 3 times."
    public static let errorNoUserAccount = "No User Account for entered username."
    public static let errorRequestPassword = "Something went wrong. Unable to request a new password."
    public static let successRequestPassword = "You have successfully requested a new password."
    public static let succesCheckEmailPassword = "Password has been sent to your email address."
    public static let warningPasswordValidation = "Password must have at least one (1) capitalized letter, one (1) number and a minimum of eight (8) characters."
    public static let sucessChangePassword = "You have successfully changed your password."
    public static let errorChangePassword = "Something went wrong. Unable to change your password. Please try again."
    public static let warningVerifyMember = "Please make sure that you typed a valid information."
    public static let warningPasswordMinimum = "Password must contain a minimum of 8 characters."
    public static let warningCharacterMinimum = "Username must contain a minimum of 3 characters."
    public static let warningInvalidUsername = "Username invalid. It must not contain blank spaces."
    public static let warningInvalidEmail = "Invalid email Address. Please try again."
    public static let warningPasswordDidntMatch = "Password did not match. Please try again."
    public static let warningPasswordRetypePassDidntMatch = "New Password and Re-Type Password did not match. Please try again."
    public static let warningSomethingWrong = "Something went wrong. Please try again."
    public static let warningInvalidNumber = "Invalid mobile number. Please try again."
    public static let warningInvalidMemberCodeAndUsername = "Something went wrong. Incorrect Email Address or MemberCode."
    public static let warningInvalidUsernamePassword = "Something went wrong. Incorrect username or password."
    
    public static let warningMemberAccountDoesntMatch = "Date of Birth does not match with MediCard ID number."
    public static let warningMemberAccountAlreadyExist = "Account is already existing."
    public static let warningInputMemberID = "Please input Dependent member ID."
    
    
}
