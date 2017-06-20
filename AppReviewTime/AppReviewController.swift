//
//  ViewController.swift
//  AppReviewTime
//
//  Created by Timothy Barnard on 20/06/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Kanna
import Alamofire

enum urlType: String {
    case appReview = "http://appreviewtimes.com"
    case iosRaw = "http://appreviewtimes.com/ios/raw-data"
    case macRaw = "http://appreviewtimes.com/mac/raw-data"
}

enum Device {
    case ios
    case mac
}

struct Review {
    var dateStr: String = ""
    var date: Date = Date()
    var dayNo: Int = 0
    var dayCount: Int = 0
}


class AppViewController {

    func scrapeAppReviewTime( for url: urlType, postCompleted : @escaping (_ succeeded: Bool, _ data: String) -> ()) {
        Alamofire.request(url.rawValue).responseString { response in
            print("\(response.result.isSuccess)")
            if let html = response.result.value {
                postCompleted(true, html)
            }
        }
    }
    
    func parseHTML(html: String, for device: Device ) -> String {
        if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            if device == .ios {
                return self.parseiOSHTML(ios: doc)
            } else {
                return self.parseMacHTML(mac: doc)
            }
        }
        return "-"
    }
    
    private func parseiOSHTML(ios doc: HTMLDocument) -> String {
        for item in doc.xpath("//div[@class='column grid-6 review ios']") {
            
            for dayNumber in item.xpath("//p[@class='average']") {
                guard let day = dayNumber.text else {
                    continue
                }
                return day
            }
        }
        return "-"
    }
    
    private func parseMacHTML(mac doc: HTMLDocument) -> String {
        for item in doc.xpath("//div[@class='column grid-6 review mac']") {
            
            for dayNumber in item.xpath("//p[@class='average']") {
                guard let day = dayNumber.text else {
                    continue
                }
                return day
            }
        }
        return "-"
    }
}

extension AppViewController {
    
    func parseHTMLRawData(html: String ) -> [[Review]]?? {
        if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            return self.parseRawHTML(mac: doc)
        }
        return nil
    }


    private func parseRawHTML(mac doc: HTMLDocument) -> [[Review]]? {
        
        var allReviews = [[Review]]()
        let newReviewArr = [Review]()
        allReviews.append(newReviewArr)
        
        var currentDate = Date()
        var currentIndex = 0
        
        var rowIndex = 0
        
        for item in doc.xpath("//table[@class='reviews-table current_data']/tbody/tr") {
            
            var review = Review()
            
            for (index, tdTags) in item.css("td").enumerated() {
                
                if !(tdTags.text?.isEmpty)! {
                    switch index {
                    case 1:
                        review.dayCount = Int(tdTags.text ?? "0")!
                        break
                    case 2:
                        review.dateStr = tdTags.text ?? ""
                        guard let dateString = tdTags.text else {
                            continue
                        }
                        if dateString.contains("Today") {
                            review.date = Date()
                        } else if dateString.contains("Yesterday") {
                            review.date = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
                        } else {
                            review.date = strToDate(date: tdTags.text!)!
                        }
                        review.dayNo = review.date.day()
                        
                        if rowIndex == 0 {
                            currentDate = review.date
                        }
                        
                        break
                    default:
                        break
                    }
                }
            }
            if currentDate.day() != review.date.day() {
                currentDate = review.date
                currentIndex = currentIndex + 1
            }
            
            if allReviews.count <= currentIndex {
                
                let newReviewArr = [Review]()
                allReviews.append(newReviewArr)
            }
            
            allReviews[currentIndex].append(review)
            
            rowIndex += 1;

        }
        return allReviews
    }
    
    private func strToDate(date dateString: String) -> Date? {
        
        let datePart = dateString.components(separatedBy: " ")
        
        if datePart.count > 2 {
        
            let day = datePart[0].dropLast(2)
            let mon = datePart[1]
            
            let dateStr = day + "-" + mon
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d-MMM"
            let date = dateFormatter.date(from:dateStr)
            return date
        }
        
        return nil
    }

}

extension String {
    func dropLast(_ n: Int = 1) -> String {
        return String(characters.dropLast(n))
    }
    var dropLast: String {
        return dropLast()
    }
}

extension Date
{
    func day() -> Int
    {
        //Get Hour
        let calendar = NSCalendar.current
        let hour = calendar.component(.day, from: self)
        //Return Hour
        return hour
    }
}
