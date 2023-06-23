import UIKit
import CoreData

class AddEditViewController: UIViewController
{
    // UI References
    @IBOutlet weak var AddEditTeamLabel: UILabel!
    @IBOutlet weak var UpdateButton: UIButton!
    
    // Movie Fields
    @IBOutlet weak var teamNameTextField: UITextField!
    @IBOutlet weak var gameTypeTextField: UITextField!
    @IBOutlet weak var coachTextField: UITextField!
    @IBOutlet weak var captainTextField: UITextField!
    @IBOutlet weak var playersTextView: UITextView!
    @IBOutlet weak var homeVenueTextField: UITextField!
    @IBOutlet weak var championshipsWonTextField: UITextField!
    @IBOutlet weak var foundedYearTextField: UITextField!
    @IBOutlet weak var leagueTextField: UITextField!
    @IBOutlet weak var websiteURLTextField: UITextField!
    @IBOutlet weak var logoURLTextField: UITextField!
    
    var teams: SportsTeams?
    var dataViewController: DataViewController?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let teams = teams
        {
            // Editing existing movie
            teamNameTextField.text = teams.teamName
            gameTypeTextField.text = teams.gameType
            coachTextField.text = teams.coach
            captainTextField.text = teams.captain
            playersTextView.text = teams.players
            homeVenueTextField.text = teams.homeVenue
            championshipsWonTextField.text = "\(teams.championshipsWon)"
            foundedYearTextField.text = "\(teams.foundedYear)"
            leagueTextField.text = teams.league
            websiteURLTextField.text = teams.websiteURL
            logoURLTextField.text = teams.logoURL
        }
        else
        {
            AddEditTeamLabel.text = "Add Teams"
            UpdateButton.setTitle("Add", for: .normal)
        }
    }
    
    @IBAction func CancelButton_Pressed(_ sender: UIButton)
    {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func UpdateButton_Pressed(_ sender: UIButton)
    {
        // Retrieve the app delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else
        {
            return
        }

        // Retrieve the managed object context
        let context = appDelegate.persistentContainer.viewContext

        if let teams = teams
        {
            // Editing existing teams
            teams.teamName = teamNameTextField.text
            teams.gameType = gameTypeTextField.text
            teams.coach = coachTextField.text
            teams.captain = captainTextField.text
            teams.players = playersTextView.text
            teams.homeVenue = homeVenueTextField.text
            teams.championshipsWon = Int16(championshipsWonTextField.text ?? "") ?? 0
            teams.foundedYear = Int16(foundedYearTextField.text ?? "") ?? 0
            teams.league = leagueTextField.text
            teams.websiteURL = websiteURLTextField.text
            teams.logoURL = logoURLTextField.text
        } else {
            // Creating a new teams
            let newTeam = SportsTeams(context: context)
            newTeam.teamName = teamNameTextField.text
            newTeam.gameType = gameTypeTextField.text
            newTeam.coach = coachTextField.text
            newTeam.captain = captainTextField.text
            newTeam.players = playersTextView.text
            newTeam.homeVenue = homeVenueTextField.text
            newTeam.championshipsWon = Int16(championshipsWonTextField.text ?? "") ?? 0
            newTeam.foundedYear = Int16(foundedYearTextField.text ?? "") ?? 0
            newTeam.league = leagueTextField.text
            newTeam.websiteURL = websiteURLTextField.text
            newTeam.logoURL = logoURLTextField.text
        }

        // Save the changes in the context
        do {
            try context.save()
            dataViewController?.fetchData()
            dismiss(animated: true, completion: nil)
        } catch {
            print("Failed to save data: \(error)")
        }
    }
    
}
