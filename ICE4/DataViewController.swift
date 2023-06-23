import UIKit
import CoreData

class DataViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var tableView: UITableView!
    var teams: [Team] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        fetchData()
    }
    
    func fetchData()
    {
        guard let appDelegate = UIApplication.shared.delegate as?
                AppDelegate else
        {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Team> = Team.fetchRequest()
        
        do {
            teams = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("Failed to fetch data: \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    
    // Updated for ICE5
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SportsTeamsCell", for: indexPath) as! SportsTeamsTableViewCell
        
        let team = teams[indexPath.row]
        
        cell.teamNameLabel?.text = team.teamName
        cell.gameTypeLabel?.text = team.gameType
        cell.championshipsWonLabel?.text = "\(team.championshipsWon)"
        cell.foundedYearLabel?.text = "\(team.foundedYear)"
        
        return cell
    }
    
    
    // New for ICE5
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "AddEditSegue", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let team = teams[indexPath.row]
            ShowDeleteConfirmationAlert(for: team) { confirmed in
                if confirmed
                {
                    self.deleteTeam(at: indexPath)
                }
            }
        }
    }
    
    @IBAction func AddButton_Pressed(_ sender: UIButton)
    {
        performSegue(withIdentifier: "AddEditSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "AddEditSegue"
        {
            if let addEditVC = segue.destination as? AddEditViewController
            {
                addEditVC.dataViewController = self
                if let indexPath = sender as? IndexPath
                {
                    // Editing existing movie
                    let team = teams[indexPath.row]
                    addEditVC.team = team
                } else {
                    // Adding new movie
                    addEditVC.team = nil
                }
            }
        }
    }
    
    func ShowDeleteConfirmationAlert(for team: Team, completion: @escaping (Bool) -> Void)
    {
        let alert = UIAlertController(title: "Delete Team", message: "Are you sure you want to delete this team?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion(false)
        })
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            completion(true)
        })
        
        present(alert, animated: true, completion: nil)
    }
    
    func deleteTeam(at indexPath: IndexPath)
    {
        let team = teams[indexPath.row]
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else
        {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        context.delete(team)
        
        do {
            try context.save()
            teams.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } catch {
            print("Failed to delete teams: \(error)")
        }
    }
}
