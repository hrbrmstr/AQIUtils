import Foundation

// https://archive.epa.gov/ttn/ozone/web/pdf/rg701.pdf
// https://www.airnow.gov/sites/default/files/2020-05/aqi-technical-assistance-document-sept2018.pdf

class AQIUtils {
  
  private static let  index_low : [Double] = [  0,  51, 101, 151, 201, 301, 401 ]
  private static let index_high : [Double] = [ 50, 100, 150, 200, 300, 400, 500 ]
  
  public enum Pollutant : String {
    
    public typealias RawValue = String
    
    case unknown = "Unknown"
    case pm2p5 = "PM2.5"
    case pm10 = "PM 10"
    case co = "Carbon Monoxide"
    case so2 = "Sulfur Dioxide"

  }
  
  public enum AQICategory : String {
    
    public typealias RawValue = String
    
    case invalid = "Invalid"
    case good = "Good"
    case moderate = "Moderate"
    case unhealthySensitive = "Unhealthy for Sensitive Groups"
    case unhealthy = "Unhealthy"
    case veryUnhealthy = "Very Unhealthy"
    case hazardous = "Hazardous"
    
  }
  
  public struct AQIResult : CustomDebugStringConvertible {
    
    public var debugDescription: String {
      return "AQIResult(aqi: \(aqi), category: \(category.rawValue), pollutant: \(pollutant.rawValue))"
    }
    
    var aqi : Int
    var category : AQICategory
    var pollutant : Pollutant
    
  }
  
  private static func c2aqi(pollutant : Pollutant, concentration : Double, breakpoints_low : [Double], breakpoints_high : [Double]) -> AQIResult {
     
    if (concentration > breakpoints_high.last!) { return(AQIResult(aqi: -1, category: .invalid, pollutant: pollutant)) }
    
    let rank = breakpoints_high.map({ concentration <= $0  }).firstIndex(where: { $0 == true })!
    let result = ceil(
        (index_high[rank] - index_low[rank]) /
          (breakpoints_high[rank] - breakpoints_low[rank]) * (concentration - breakpoints_low[rank]) + index_low[rank]
      )
    
    if (result <= 50) {
      return(AQIResult(aqi: Int(result), category: .good, pollutant: pollutant))
    } else if (result <= 100) {
      return(AQIResult(aqi: Int(result), category: .moderate, pollutant: pollutant))
    } else if (result <= 150) {
      return(AQIResult(aqi: Int(result), category: .unhealthySensitive, pollutant: pollutant))
    } else if (result <= 200) {
      return(AQIResult(aqi: Int(result), category: .unhealthy, pollutant: pollutant))
    } else if (result <= 300) {
      return(AQIResult(aqi: Int(result), category: .veryUnhealthy, pollutant: pollutant))
    } else if (result <= 400) {
      return(AQIResult(aqi: Int(result), category: .hazardous, pollutant: pollutant))
    } else if (result <= 500) {
      return(AQIResult(aqi: Int(result), category: .hazardous, pollutant: pollutant))
    } else {
      return(AQIResult(aqi: Int(result), category: .invalid, pollutant: pollutant))
    }
            
  }

  public static func pm2p5_aqi(concentration: Double) -> AQIResult {
    let pm2p5_bpl : [Double] = [    0, 12.1, 35.5,  55.5, 150.5, 250.5, 350.5 ]
    let pm2p5_bph : [Double] = [ 12.0, 35.4, 55.4, 150.4, 250.4, 350.4, 500.4 ]
    return(c2aqi(pollutant: .pm2p5, concentration: concentration, breakpoints_low: pm2p5_bpl, breakpoints_high: pm2p5_bph))
  }
  
  public static func pm10_aqi(concentration: Double) -> AQIResult {
    let pm10_bpl : [Double] = [  0,  55, 155, 255, 355, 425, 505 ]
    let pm10_bph : [Double] = [ 54, 154, 254, 354, 424, 504, 604 ]
    return(c2aqi(pollutant: .pm10, concentration: concentration, breakpoints_low: pm10_bpl, breakpoints_high: pm10_bph))
  }
  
  public static func co_aqi(concentration: Double) -> AQIResult {
    let co_bpl : [Double] = [   0, 4.5,  9.5, 12.5, 15.5, 30.5, 40.5 ]
    let cp_bph : [Double] = [ 4.4, 9.4, 12.4, 15.4, 30.4, 40.4, 50.4 ]
    return(c2aqi(pollutant: .co, concentration: concentration, breakpoints_low: co_bpl, breakpoints_high: cp_bph))
  }

  public static func so2_aqi(concentration: Double) -> AQIResult {
    let so2_bpl : [Double] = [  0, 36,  76, 186, 305, 605,  805 ]
    let so2_bph : [Double] = [ 35, 75, 185, 304, 604, 804, 1004 ]
    return(c2aqi(pollutant: .so2, concentration: concentration*1000, breakpoints_low: so2_bpl, breakpoints_high: so2_bph))
  }
  
}

