import UIKit

class SeeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var exerciseListTableView: UITableView!
    var records: [ExerciseRecord] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exerciseListTableView.dataSource = self
        exerciseListTableView.delegate = self
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
        dateFormatter.dateStyle = .short
        cell.dateLabel.text = dateFormatter.string(from: record.startDate)
                
        let duration = Calendar.current.dateComponents([.minute], from: record.startDate, to: record.endDate).minute ?? 0
        cell.durationLabel.text = "\(duration) 분"
        cell.detailTextLabel?.text = record.details
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // DataManager에서 기록 삭제
            DataManager.shared.deleteRecord(at: indexPath.row)
                
            // 로컬 데이터 업데이트
            records = DataManager.shared.getAllRecords()
                
            // 테이블 뷰 업데이트
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
