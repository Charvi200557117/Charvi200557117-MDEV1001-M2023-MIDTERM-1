import Foundation
import UIKit
import CoreData

func seedData() {
    guard let url = Bundle.main.url(forResource: "teams", withExtension: "json") else {
        print("JSON file not found.")
        return
    }
    
    guard let data = try? Data(contentsOf: url) else {
        print("Failed to read JSON file.")
        return
    }
    
    guard let jsonArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
        print("Failed to parse JSON.")
        return
    }
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        print("AppDelegate not found.")
        return
    }
    
    let context = appDelegate.persistentContainer.viewContext
    
    for jsonObject in jsonArray {
        let team = Team(context: context)
        
        //teamID?
        team.teamName = jsonObject["teamName"] as? String
        team.gameType = jsonObject["gameType"] as? String
        team.coach = jsonObject["coach"] as? String
        team.captain = jsonObject["captain"] as? String
        team.players = jsonObject["players"] as? String
        team.homeVenue = jsonObject["homeVenue"] as? String
        team.championshipsWon = jsonObject["championshipsWon"] as? Int16 ?? 0
        team.foundedYear = jsonObject["foundedYear"] as? Int16 ?? 0
        team.league = jsonObject["league"] as? String
        team.websiteURL = jsonObject["websiteURL"] as? String
        team.logoURL = jsonObject["logoURL"] as? String
        
        // Save the context after each movie is created
        do {
            try context.save()
        } catch {
            print("Failed to save team: \(error)")
        }
    }
    
    print("Data seeded successfully.")
}
