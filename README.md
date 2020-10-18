# AQIUtils

Swift class to convert pollutant concentration values to AQI

## Examples

```swift
debugPrint("concentration: 15.70 => \(AQIUtils.pm10_aqi(concentration: 15.70))")
// "concentration: 15.70 => AQIResult(aqi: 15, category: Good, pollutant: PM10)"
```

```swift
debugPrint("concentration: 13.36 => \(AQIUtils.pm2p5_aqi(concentration: 13.36))")
// "concentration: 13.36 => AQIResult(aqi: 54, category: Moderate, pollutant: PM2.5)"
```

```swift
debugPrint("concentration: 31.20 => \(AQIUtils.co_aqi(concentration: 31.2))")
// "concentration: 31.20 => AQIResult(aqi: 308, category: Hazardous, pollutant: Carbon Monoxide)"
```

```swift
debugPrint("concentration:  0.15 => \(AQIUtils.so2_aqi(concentration: 0.15))")
// "concentration:  0.15 => AQIResult(aqi: 135, category: Unhealthy for Sensitive Groups, pollutant: Sulfur Dioxide)"
```
