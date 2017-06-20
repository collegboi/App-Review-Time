//
//  TodayViewController.swift
//  AppReviewTimeExt
//
//  Created by Timothy Barnard on 20/06/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa
import NotificationCenter

class TodayViewController: NSViewController, NCWidgetProviding {

    @IBOutlet weak var iOSLabel: NSTextField!
    @IBOutlet weak var macLabel: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    
    var appViewController: AppViewController?
    static let DefaultMargin: CGFloat = 5.0 // Derived from margin between collection view and label in
    
    override var nibName: String? {
        return "TodayViewController"
    }
    
    override func viewDidLoad() {
        
        appViewController = AppViewController()
    }
    
    override func viewDidAppear() {
        if #available(OSX 10.11, *) {
            fetch({ (complete) in})
        }
    }
    
    fileprivate func fetch(_ completionHandler : @escaping (_ succeeded: Bool) -> ()) {
        
        self.getDayValue { (result) in
            self.getMacRawDayValue()
            
            completionHandler(result)
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        
        self.fetch { (result) in
            if result {
                completionHandler(.newData)
            } else {
                completionHandler(.failed)
            }
        }
    }
    
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInset: EdgeInsets) -> EdgeInsets {
        return EdgeInsets(top: defaultMarginInset.top + TodayViewController.DefaultMargin, left: defaultMarginInset.left - 20.0, bottom: defaultMarginInset.bottom, right: 0.0)
    }

    
    func getDayValue( fetchHandler : @escaping (_ succeeded: Bool) -> ()) {
        
        appViewController?.scrapeAppReviewTime(for: .appReview, postCompleted: { (complete, data) in
            if complete {
                self.macLabel.stringValue = "Mac " + self.appViewController!.parseHTML(html: data, for: .mac)
                self.iOSLabel.stringValue = "iOS " + self.appViewController!.parseHTML(html: data, for: .ios)
                fetchHandler(true)
            } else {
                fetchHandler(false)
            }
        })
    }
    
    func getMacRawDayValue() {
        
        appViewController?.scrapeAppReviewTime(for: .macRaw, postCompleted: { (complete, data) in
            if complete {
                let allReviews = self.appViewController?.parseHTMLRawData(html: data)!
                
                
            }
        })
    }
}
