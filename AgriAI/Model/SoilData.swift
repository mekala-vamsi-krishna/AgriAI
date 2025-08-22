//
//  SoilData.swift
//  AgriAI
//
//  Created by Mekala Vamsi Krishna on 8/22/25.
//

import Foundation

// MARK: - Data Models
struct SoilData {
    var ph: Double
    var nitrogen: Double
    var organicCarbon: Double
    var zinc: Double
    var iron: Double
    var manganese: Double
    var copper: Double
    var boron: Double
}


struct Recommendation: Identifiable {
    let id = UUID()
    let crop: String
    let fertilizer: String
}

// MARK: - Simple Model
class SoilHealthModel {
    func analyze(soil: SoilData) -> [Recommendation] {
        var recs: [Recommendation] = []
        
        if soil.ph < 6.5 {
            recs.append(Recommendation(crop: "Wheat", fertilizer: "Add lime to improve pH"))
        }
        if soil.nitrogen < 200 {
            recs.append(Recommendation(crop: "Rice", fertilizer: "Apply Urea"))
        }
        if soil.organicCarbon < 0.5 {
            recs.append(Recommendation(crop: "Pulses", fertilizer: "Add compost/organic matter"))
        }
        if soil.zinc < 0.8 {
            recs.append(Recommendation(crop: "Maize", fertilizer: "Apply Zinc Sulphate"))
        }
        
        return recs.isEmpty ? [Recommendation(crop: "General", fertilizer: "Soil looks healthy!")] : recs
    }
}
