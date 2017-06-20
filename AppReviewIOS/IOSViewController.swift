//
//  ViewController.swift
//  AppReviewIOS
//
//  Created by Timothy Barnard on 20/06/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import UIKit

class IOSViewController: UIViewController {
    
    @IBOutlet weak var iosLabel: UILabel!
    @IBOutlet weak var graphView: ReviewGraphView!
    
    var appViewController: AppViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.graphView.drawGraph()
        
        appViewController = AppViewController()
        
        self.loadLabel()
        self.loadGraph()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func loadLabel() {
        
        appViewController?.scrapeAppReviewTime(for: .appReview, postCompleted: { (complete, htmtl) in
            if complete {
                self.iosLabel.text = "iOS " + self.appViewController!.parseHTML(html: htmtl, for: .ios)
            }
        })
    }
    
    func loadGraph() {
        
        appViewController?.scrapeAppReviewTime(for: .iosRaw, postCompleted: { (complete, html) in
            if complete {
                let reviews = self.appViewController!.parseHTMLRawData(html: html)!
                self.graphView.setChart("iOS", values: reviews!)
            }
        })
    }


}

