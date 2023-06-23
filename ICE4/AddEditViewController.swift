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
    
    var team: Team?
    var dataViewController: DataViewController?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let team = team
        {
            // Editing existing movie
            teamNameTextField.text = team.teamName
            gameTypeTextField.text = team.gameType
            coachTextField.text = team.coach
            captainTextField.text = team.captain
            playersTextView.text = team.players
            homeVenueTextField.text = team.homeVenue
            championshipsWonTextField.text = "\(team.championshipsWon)"
            foundedYearTextField.text = "\(team.foundedYear)"
            leagueTextField.text = team.league
            websiteURLTextField.text = team.websiteURL
            logoURLTextField.text = team.logoURL
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

        if let team = team
        {
            // Editing existing teams
            team.teamName = teamNameTextField.text
            team.gameType = gameTypeTextField.text
            team.coach = coachTextField.text
            team.captain = captainTextField.text
            team.players = playersTextView.text
            team.homeVenue = homeVenueTextField.text
            team.championshipsWon = Int16(championshipsWonTextField.text ?? "") ?? 0
            team.foundedYear = Int16(foundedYearTextField.text ?? "") ?? 0
            team.league = leagueTextField.text
            team.websiteURL = websiteURLTextField.text
            team.logoURL = logoURLTextField.text
        } else {
            // Creating a new teams
            let newTeam = Team(context: context)
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
