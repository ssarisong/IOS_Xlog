import UIKit

class SeeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var exerciseListTableView: UITableView!
    @IBOutlet weak var detailTextView: UITextView!
    var records: [ExerciseRecord] = []
    let initDetailMessage = "운동 기록을 선택해주세요."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exerciseListTableView.dataSource = self
        exerciseListTableView.delegate = self
        
        detailTextView.text = initDetailMessage
        detailTextView.textColor = UIColor.lightGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        records = DataManager.shared.getAllRecords()
        exerciseListTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath) as? RecordTableViewCell else {
            return UITableViewCell()
        }
        
        let record = records[indexPath.row]
        
        cell.typeLabel.text = record.type
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "MM월 dd일"
        cell.dateLabel.text = dateFormatter.string(from: record.startDate)
                
        let duration = Calendar.current.dateComponents([.minute], from: record.startDate, to: record.endDate).minute ?? 0
        cell.durationLabel.text = "\(duration) 분"
        cell.detailTextLabel?.text = record.details
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataManager.shared.deleteRecord(at: indexPath.row)
            records = DataManager.shared.getAllRecords()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRecord = records[indexPath.row]
        detailTextView.text = selectedRecord.details
        detailTextView.textColor = UIColor.black
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        detailTextView.text = initDetailMessage
    }

}
