//
//  iOSViewController.swift
//  AppReviewTime
//
//  Created by Timothy Barnard on 20/06/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class iOSViewController: NSViewController {
    
    @IBOutlet weak var iOSLabel: NSTextField!
    
    @IBOutlet weak var appReviewGraph: AppReviewGraph!
    
    var appViewController: AppViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        appViewController = AppViewController()
        self.getiOSDayValue()
    }
    
    override func viewDidAppear() {
        self.getiOSRawDayValue()
    }
    
    func getiOSDayValue() {
        
        appViewController?.scrapeAppReviewTime(for: .appReview, postCompleted: { (complete, data) in
            if complete {
                self.iOSLabel.stringValue = self.appViewController!.parseHTML(html: data, for: .ios)
            }
        })
    }
    
    func getiOSRawDayValue() {
        
        appViewController?.scrapeAppReviewTime(for: .iosRaw, postCompleted: { (complete, data) in
            if complete {
                let allReviews = self.appViewController?.parseHTMLRawData(html: data)!
    
                self.appReviewGraph.setChart("iOS", values: allReviews!)
            }
        })
    }
    
}
