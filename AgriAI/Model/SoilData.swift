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
    let parameter: String
    let crops: [String]
    let fertilizerAdvice: String
    let irrigation: String
    let diseaseRisk: String
}

class SoilHealthModel {
    func analyze(soil: SoilData) -> [Recommendation] {
        var recs: [Recommendation] = []
        
        // pH Analysis
        if soil.ph < 6.0 {
            recs.append(Recommendation(
                parameter: "Soil pH (Acidic)",
                crops: ["Potato", "Tea", "Pineapple", "Sweet Potato"],
                fertilizerAdvice: "Apply Lime @ 200 kg/acre before sowing.",
                irrigation: "Irrigate every 8–10 days to reduce acidity stress.",
                diseaseRisk: "Acidic soils may increase fungal diseases like Root Rot."
            ))
        } else if soil.ph > 7.5 {
            recs.append(Recommendation(
                parameter: "Soil pH (Alkaline)",
                crops: ["Barley", "Cotton", "Sorghum", "Mustard"],
                fertilizerAdvice: "Apply Gypsum @ 500 kg/acre + add organic manure.",
                irrigation: "Light irrigation every 12–15 days; avoid over-irrigation.",
                diseaseRisk: "High pH soils may cause micronutrient deficiencies (Zn, Fe)."
            ))
        } else {
            recs.append(Recommendation(
                parameter: "Soil pH (Neutral)",
                crops: ["Wheat", "Rice", "Maize", "Pulses", "Vegetables"],
                fertilizerAdvice: "Balanced NPK fertilizers (100:50:50 kg/acre).",
                irrigation: "Maintain normal cycles (7–10 days).",
                diseaseRisk: "Soil pH is good; normal crop risks only."
            ))
        }
        
        // Nitrogen
        if soil.nitrogen < 200 {
            recs.append(Recommendation(
                parameter: "Nitrogen (Low)",
                crops: ["Rice", "Wheat", "Maize", "Sugarcane"],
                fertilizerAdvice: "Apply Urea @ 40–50 kg/acre in split doses.",
                irrigation: "Irrigate immediately after urea application.",
                diseaseRisk: "Low N → Yellowing of leaves (Chlorosis)."
            ))
        } else if soil.nitrogen > 500 {
            recs.append(Recommendation(
                parameter: "Nitrogen (High)",
                crops: ["Leafy Vegetables", "Maize", "Banana"],
                fertilizerAdvice: "Reduce nitrogen usage; use FYM/organic inputs.",
                irrigation: "Avoid excessive irrigation to prevent leaching.",
                diseaseRisk: "Excess N → Lodging in cereals, pest attack risk (Aphids)."
            ))
        }
        
        // Organic Carbon
        if soil.organicCarbon < 0.5 {
            recs.append(Recommendation(
                parameter: "Organic Carbon (Low)",
                crops: ["Pulses", "Groundnut", "Soybean"],
                fertilizerAdvice: "Add Compost/FYM @ 2 tons/acre.",
                irrigation: "Irrigate in longer intervals; organic matter improves water retention.",
                diseaseRisk: "Poor soil health → Higher risk of wilt diseases."
            ))
        } else if soil.organicCarbon >= 0.75 {
            recs.append(Recommendation(
                parameter: "Organic Carbon (High)",
                crops: ["Rice", "Vegetables", "Sugarcane"],
                fertilizerAdvice: "Maintain balance with crop residues & green manure.",
                irrigation: "Irrigation every 7–8 days; good water holding capacity.",
                diseaseRisk: "Rich soils → Usually healthy, but keep check on pest build-up."
            ))
        }
        
        // Micronutrients
        if soil.zinc < 0.8 {
            recs.append(Recommendation(
                parameter: "Zinc (Low)",
                crops: ["Maize", "Wheat", "Sugarcane"],
                fertilizerAdvice: "Apply Zinc Sulphate @ 10–15 kg/acre once in 2 years.",
                irrigation: "Normal irrigation; zinc improves root growth.",
                diseaseRisk: "Zn deficiency → Khaira disease in rice."
            ))
        }
        
        if soil.iron < 4.5 {
            recs.append(Recommendation(
                parameter: "Iron (Low)",
                crops: ["Rice", "Groundnut", "Soybean"],
                fertilizerAdvice: "Apply Ferrous Sulphate @ 25 kg/acre.",
                irrigation: "Flood irrigation helps release Fe in soil.",
                diseaseRisk: "Fe deficiency → Interveinal chlorosis in young leaves."
            ))
        }
        
        if soil.boron < 0.5 {
            recs.append(Recommendation(
                parameter: "Boron (Low)",
                crops: ["Cauliflower", "Mustard", "Sunflower"],
                fertilizerAdvice: "Apply Borax @ 10 kg/acre.",
                irrigation: "Avoid excessive irrigation; leaches Boron.",
                diseaseRisk: "B deficiency → Hollow stem in cauliflower, flower drop."
            ))
        }
        
        return recs.isEmpty ? [
            Recommendation(parameter: "General", crops: ["Wheat", "Rice", "Maize"],
                           fertilizerAdvice: "Balanced NPK use recommended.",
                           irrigation: "Irrigate every 7–10 days.",
                           diseaseRisk: "No major risks detected.")
        ] : recs
    }
}
