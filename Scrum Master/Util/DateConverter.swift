import Foundation


class DateConverter: NSObject {
    
    static func toDbDate(date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm"
        
        return df.string(from: date)
    }
    
    static func toDisplayDate(dbDate: String) -> String? {
        let inputDf = DateFormatter()
        inputDf.dateFormat = "yyyy-MM-dd HH:mm"
        
        let outputDf = DateFormatter()
        outputDf.dateFormat = "dd-MM-yyyy"
        
        guard let date = inputDf.date(from: dbDate) else {
            return nil
        }
        return outputDf.string(from: date)
    }
    
    static func toDisplayFullDate(dbDate: String) -> String? {
        let inputDf = DateFormatter()
        inputDf.dateFormat = "yyyy-MM-dd HH:mm"
        
        let outputDf = DateFormatter()
        outputDf.dateFormat = "dd-MM-yyyy HH:mm"
        
        guard let date = inputDf.date(from: dbDate) else {
            return nil
        }
        return outputDf.string(from: date)
    }
    
    static func toDateObject(dbDate: String) -> Date? {
        let inputDf = DateFormatter()
        inputDf.dateFormat = "yyyy-MM-dd HH:mm"
        
        return inputDf.date(from: dbDate)
    }
}
