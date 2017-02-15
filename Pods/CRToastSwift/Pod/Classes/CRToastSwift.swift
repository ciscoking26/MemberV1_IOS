//  
//  CRToastSwift.swift
//  CRToastSwift
//  
//  Copyright (c) 2015 Masahiko Tsujita <tsujitamasahiko.dev@icloud.com>
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//  

import UIKit
import CRToast

/**
A NotificationController object displays a notification to the user.
*/
open class NotificationController {
    
    // MARK: - Type Definitions
    
    /**
    Predefined styles of notifications.
    
    - Info:    Blue background, ℹ️ image on the left side.
    - Success: Green background, ✅ image on the left side.
    - Warning: Yellow background, ⚠️ image on the left side.
    - Error:   Red background, ❌ image on the left side.
    */
    public enum Template {
        case info
        case success
        case warning
        case error
        fileprivate var backgroundColor: UIColor {
            get {
                switch self {
                case .info:
                    return UIColor(red:0.176, green:0.522, blue:0.976, alpha:1.0)
                case .success:
                    return UIColor(red:0.126, green:0.835, blue:0.163, alpha:1.0)
                case .warning:
                    return UIColor(red:0.988, green:0.753, blue:0.170, alpha:1.0)
                case .error:
                    return UIColor(red:0.886, green:0.211, blue:0.150, alpha:1.0)
                }
            }
        }
        fileprivate var image: UIImage? {
            get {
                let frameworkBundle = Bundle(for: NotificationController.self)
                guard let resourcesBundlePath = frameworkBundle.path(forResource: "CRToastSwift", ofType: "bundle") else {
                    return nil
                }
                guard let resourcesBundle = Bundle(path: resourcesBundlePath) else {
                    return nil
                }
                switch self {
                case .info:
                    return UIImage(named: "InfoImage", in: resourcesBundle, compatibleWith: nil)
                case .success:
                    return UIImage(named: "SuccessImage", in: resourcesBundle, compatibleWith: nil)
                case .warning:
                    return UIImage(named: "WarningImage", in: resourcesBundle, compatibleWith: nil)
                case .error:
                    return UIImage(named: "ErrorImage", in: resourcesBundle, compatibleWith: nil)
                }
            }
        }
    }
    
    public typealias NotificationType       = CRToastType
    public typealias PresentationType       = CRToastPresentationType
    public typealias AnimationType          = CRToastAnimationType
    public typealias AnimationDirection     = CRToastAnimationDirection
    public typealias InteractionResponder   = CRToastInteractionResponder
    public typealias AccessoryViewAlignment = CRToastAccessoryViewAlignment
    
    // MARK: - Creating NotificationController Objects

    /**
    Initialize a notification with default values.
    Title and subtitle are set to empty values.

    - returns: Initialized notification.
    */
    public init() {
        
    }

    /**
    Initialize a notification with specified title, subtitles, and template.

    - parameter title:      Main text to be shown in the notification.
    - parameter subtitle:   Subtitle text to be shown in the notification.
    - parameter template:   A template of notification.

    - returns: Initialized notification.
    */
    public init(title: String, subtitle: String = "", template: Template? = nil) {
        self.title = title
        self.subtitle = subtitle
        if let template = template {
            self.image = template.image
            self.backgroundColor = template.backgroundColor
        }
    }

    // MARK: - Configuring Notification Title

    /// The main text to be shown in the notification.
    open var title: String = ""

    /// The text alignment for the main text.
    open var titleTextAlignment: NSTextAlignment = .left

    /// The font for the main text.
    open var titleTextFont = UIFont.boldSystemFont(ofSize: 10.0)

    /// The text color for the main text. The default value is white color.
    open var titleTextColor = UIColor.white

    /// The max number of lines of the main text.
    open var titleTextMaxNumberOfLines: Int = 0

    /// The shadow color for the main text.
    open var titleTextShadowColor: UIColor = UIColor.clear

    /// The shadow offset value for the main text.
    open var titleTextShadowOffset: CGSize = CGSize(width: 0.0, height: 0.0)

    // MARK: - Configuring Notification Subtitle

    /// Subtitle text to be shown in the notification.
    open var subtitle: String = ""

    /// The text alignment for the subtitle text.
    open var subtitleTextAlignment: NSTextAlignment = .left

    /// The font for the subtitle text.
    open var subtitleTextFont = UIFont.systemFont(ofSize: 10.0)

    /// The text color for the subtitle text. The default value is white color.
    open var subtitleTextColor = UIColor.white

    /// The max number of lines of the subtitle text.
    open var subtitleTextMaxNumberOfLines: Int = 0

    /// The shadow color for the subtitle text.
    open var subtitleTextShadowColor: UIColor = UIColor.clear

    /// The shadow offset value for the subtitle text.
    open var subtitleTextShadowOffset: CGSize = CGSize(width: 0.0, height: 0.0)
    
    // MARK: - Configuring Basic Appearances
    
    /// The type of the notification. Default value is `NavigationBar`.
    open var notificationType: NotificationType = .navigationBar
    
    /// The type of presentation of the notification. Default vallue is `Cover`.
    open var presentationType: PresentationType = .cover
    
    /// Indicates whether the notification should slide under the staus bar, leaving it visible or not. Default value is `false`.
    open var underStatusBar = false
    
    /// The status bar style for the navigation bar.
    open var statusBarStyle: UIStatusBarStyle = .default
    
    /**
    The preferred height for the
    this will only be used when notification type is set to `Custom`.
    */
    open var preferredHeight: CGFloat = 0
    
    /**
    The general preferred padding for the notification.
    */
    open var preferredPadding: CGFloat = 0

    // MARK: - Configuring Notification Image

    /// The image to be shown on the left side of the notification(Optional).
    open var image: UIImage?
    
    /// The color to tint the image provided. If supplied, `imageWithRenderingMode:` is used with `AlwaysTemplate`.
    open var imageTintColor: UIColor? = nil
    
    /// The image content mode to use for the image.
    open var imageContentMode: UIViewContentMode = .center
    
    /// The alignment of the image.
    open var imageAlignment: AccessoryViewAlignment = .left
    
    // MARK: - Configuring Notification Background
    
    /// The background color of the notification.
    open var backgroundColor = UIColor.darkGray
    
    /// Custom view used as the background of the notification.
    open var backgroundView: UIView?
    
    // MARK: - Configuring Animations

    /// The animation in type for the notification. Default value is `Linear`.
    open var inAnimationType: AnimationType = .linear

    /// The animation in direction for the notification. Default value is `Top`.
    open var inAnimationDirection: AnimationDirection = .top

    /// The animation in time interval for the notification. Default value is 0.4.
    open var inAnimationDuration: TimeInterval = 0.4

    /// The animation out type for the notification. Default value is `Linear`.
    open var outAnimationType: AnimationType = .linear

    /// The animation out direction for the notification. Default value is `Top`.
    open var outAnimationDirection: AnimationDirection = .top
    
    /// The animation out time interval for the notification. Default value is 0.4.
    open var outAnimationDuration: TimeInterval = 0.4
    
    /**
    The notification presentation timeinterval of type for the notification. This is how long the notification
    will be on screen after its presentation but before its dismissal.
    */
    open var duration: TimeInterval = 2.0
    
    /**
    The spring damping coefficient to be used when `inAnimationType` or `outAnimationType` is set to `.Spring`. Currently you can't define separate damping for in and out.
    */
    open var animationSpringDamping: CGFloat = 0.6
    
    /**
    The initial velocity coefficient to be used when `inAnimationType` or `outAnimationType` is set to
    `.Spring`. Currently you can't define initial velocity for in and out.
    */
    open var animationSpringInitialVelocity: CGFloat = 1.0
    
    /**
    The gravity magnitude coefficient to be used when `inAnimationType` or `outAnimationType` is set to
    `.Gravity`. Currently you can't define gravity magnitude for in and out.
    */
    open var animationGravityMagnitude: CGFloat = 1.0

    // MARK: - Configuring User Interactions
    
    /**
    An array of interaction responders.
    */
    open var interactionResponders = [InteractionResponder]()
    
    /**
    An Boolean value indicating whether the notification should not be dismissed automatically and displayed until user interaction is performed.
    If `true`, `duration` will be ignored.
    */
    open var forcesUserInteraction = false
    
    // MARK: - Configuring Activity Indicator
    
    /// A Boolean value indicating whether the activity indicator is visible or not.
    open var activityIndicatorVisible = false
    
    /// An UIActivityIndicatorViewStyle value of the activity indicator.
    open var activityIndicatorViewStyle: UIActivityIndicatorViewStyle = .white
    
    /// The alignment of the activity indicator.
    open var activityIndicatorAlignment: AccessoryViewAlignment = .left
    
    // MARK: - Identifying Notifications
    
    /// A string to identify the notification. This value is set to unique value automatically and you cannot modify it.
    open let identifier = UUID().uuidString
    
    // MARK: - Other Properties
    
    /// A Boolean value indicating whether the notification should rotate automatically. Default value is `true`.
    open var rotatesAutomatically = true
    
    /// A Boolean value whether the notification captures the screen behind the default window. Default value is `true`
    open var capturesDefaultWindow = true
    
    // MARK: - Presenting And Dismissing The Notification
    
    /**
    Present the notification.
    
    - parameter completion: A completion handler to be executed at the completion of the dismissal of the notification.
    */
    open func present(_ completion: (() -> Void)? = nil) {
        
        guard !self.presenting else {
            print("NotificationController: The notification has been already presented.")
            return
        }

        var options = [String : AnyObject]()
        
        options[kCRToastNotificationTypeKey] = self.notificationType.rawValue as AnyObject?
        
        options[kCRToastNotificationPreferredHeightKey] = self.preferredHeight as AnyObject?
        options[kCRToastNotificationPreferredPaddingKey] = self.preferredPadding as AnyObject?
        
        options[kCRToastNotificationPresentationTypeKey] = self.presentationType.rawValue as AnyObject?
        
        options[kCRToastUnderStatusBarKey] = self.underStatusBar as AnyObject?
        
        options[kCRToastKeepNavigationBarBorderKey] = true as AnyObject?
        
        options[kCRToastAnimationInTypeKey] = self.inAnimationType.rawValue as AnyObject?
        options[kCRToastAnimationInDirectionKey] = self.inAnimationDirection.rawValue as AnyObject?
        options[kCRToastAnimationInTimeIntervalKey] = self.inAnimationDuration as AnyObject?
        
        options[kCRToastAnimationOutTypeKey] = self.outAnimationType.rawValue as AnyObject?
        options[kCRToastAnimationOutDirectionKey] = self.outAnimationDirection.rawValue as AnyObject?
        options[kCRToastAnimationOutTimeIntervalKey] = self.outAnimationDuration as AnyObject?
        
        options[kCRToastTimeIntervalKey] = self.duration as AnyObject?
        
        options[kCRToastAnimationSpringDampingKey] = self.animationSpringDamping as AnyObject?
        options[kCRToastAnimationSpringInitialVelocityKey] = self.animationSpringInitialVelocity as AnyObject?
        options[kCRToastAnimationGravityMagnitudeKey] = self.animationGravityMagnitude as AnyObject?
        
        options[kCRToastTextKey] = self.title as AnyObject?
        options[kCRToastTextAlignmentKey] = self.titleTextAlignment.rawValue as AnyObject?
        options[kCRToastFontKey] = self.titleTextFont
        options[kCRToastTextColorKey] = self.titleTextColor
        options[kCRToastTextMaxNumberOfLinesKey] = self.titleTextMaxNumberOfLines as AnyObject?
        options[kCRToastTextShadowColorKey] = self.titleTextShadowColor
        options[kCRToastTextShadowOffsetKey] = NSValue(cgSize: self.titleTextShadowOffset)

        options[kCRToastSubtitleTextKey] = self.subtitle as AnyObject?
        options[kCRToastSubtitleTextAlignmentKey] = self.subtitleTextAlignment.rawValue as AnyObject?
        options[kCRToastSubtitleFontKey] = self.subtitleTextFont
        options[kCRToastSubtitleTextColorKey] = self.subtitleTextColor
        options[kCRToastSubtitleTextMaxNumberOfLinesKey] = self.subtitleTextMaxNumberOfLines as AnyObject?
        options[kCRToastSubtitleTextShadowColorKey] = self.subtitleTextShadowColor
        options[kCRToastSubtitleTextShadowOffsetKey] = NSValue(cgSize: self.subtitleTextShadowOffset)
        
        options[kCRToastStatusBarStyleKey] = self.statusBarStyle.rawValue as AnyObject?
        
        options[kCRToastBackgroundColorKey] = self.backgroundColor
        
        options[kCRToastBackgroundViewKey] = self.backgroundView
        
        if let image = self.image {
            options[kCRToastImageKey] = image
            options[kCRToastImageTintKey] = self.imageTintColor
            options[kCRToastImageAlignmentKey] = self.imageAlignment.rawValue as AnyObject?
            options[kCRToastImageContentModeKey] = self.imageContentMode.rawValue as AnyObject?
        }
        
        options[kCRToastInteractionRespondersKey] = self.interactionResponders as AnyObject?
        
        options[kCRToastShowActivityIndicatorKey] = self.activityIndicatorVisible as AnyObject?
        if self.activityIndicatorVisible {
            options[kCRToastActivityIndicatorAlignmentKey] = self.activityIndicatorAlignment.rawValue as AnyObject?
            options[kCRToastActivityIndicatorViewStyleKey] = self.activityIndicatorViewStyle.rawValue as AnyObject?
        }
        
        options[kCRToastForceUserInteractionKey] = self.forcesUserInteraction as AnyObject?
        
        options[kCRToastAutorotateKey] = self.rotatesAutomatically as AnyObject?
        
        options[kCRToastIdentifierKey] = self.identifier as AnyObject?
        
        options[kCRToastCaptureDefaultWindowKey] = self.capturesDefaultWindow as AnyObject?
        
        CRToastManager.showNotification(options: options, completionBlock: completion)
        
    }
    
    /// The boolean value indicating the notification is being to be or currently presented or not.
    open var presenting: Bool {
        get {
            let identifiers = CRToastManager.notificationIdentifiersInQueue() as! [String]
            return identifiers.contains(self.identifier)
        }
    }
    
    /**
    Dismisses the notification.
    
    - parameter animated: Whether dismissal is performed animated or not.
    */
    open func dismiss(_ animated: Bool = true) {
        CRToastManager.dismissAllNotifications(withIdentifier: self.identifier, animated: animated)
    }

}
