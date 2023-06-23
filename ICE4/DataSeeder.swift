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
        let teams = SportsTeams(context: context)
        
        //teamID?
        teams.teamName = jsonObject["teamName"] as? String
        teams.gameType = jsonObject["gameType"] as? String
        teams.coach = jsonObject["coach"] as? String
        teams.captain = jsonObject["captain"] as? String
        teams.players = jsonObject["players"] as? String
        teams.homeVenue = jsonObject["homeVenue"] as? String
        teams.championshipsWon = jsonObject["championshipsWon"] as? Int16 ?? 0
        teams.foundedYear = jsonObject["foundedYear"] as? Int16 ?? 0
        teams.league = jsonObject["league"] as? String
        teams.websiteURL = jsonObject["websiteURL"] as? String
        teams.logoURL = jsonObject["logoURL"] as? String
        
        // Save the context after each movie is created
        do {
            try context.save()
        } catch {
            print("Failed to save team: \(error)")
        }
    }
    
    print("Data seeded successfully.")
}
