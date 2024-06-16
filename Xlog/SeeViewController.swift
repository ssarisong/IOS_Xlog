import UIKit
import DGCharts

class SeeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var barChartView: BarChartView!
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
        
        setupChart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        records = DataManager.shared.getAllRecords()
        exerciseListTableView.reloadData()
        
        updateChartData()
    }
    
    func setupChart() {
        barChartView.noDataText = "출력 데이터가 없습니다."
        barChartView.noDataFont = .systemFont(ofSize: 20)
        barChartView.noDataTextColor = .lightGray
        barChartView.backgroundColor = .white
        
        barChartView.chartDescription.enabled = false
        barChartView.pinchZoomEnabled = false
        barChartView.drawBarShadowEnabled = false
        barChartView.drawGridBackgroundEnabled = false
        barChartView.rightAxis.enabled = false
        
        let xAxis = barChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = false
        xAxis.granularity = 1
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        xAxis.valueFormatter = DateValueFormatter(dateFormatter: dateFormatter)
        
        let leftAxis = barChartView.leftAxis
        leftAxis.drawGridLinesEnabled = false
        leftAxis.axisMinimum = 0
    }
    
    func updateChartData() {
        let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let filteredRecords = records.filter { $0.startDate >= oneWeekAgo }
        
        let groupedRecords = Dictionary(grouping: filteredRecords) { (record) -> String in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: record.startDate)
        }
        
        let sortedDates = groupedRecords.keys.sorted()
        var dataEntries: [BarChartDataEntry] = []
        var exerciseTypes: [String: Int] = [:]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for (index, date) in sortedDates.enumerated() {
            if let recordsForDate = groupedRecords[date] {
                var exerciseDurations: [String: Double] = [:]
                
                for record in recordsForDate {
                    let duration = record.endDate.timeIntervalSince(record.startDate) / 60.0 // duration in minutes
                    if let existingDuration = exerciseDurations[record.type] {
                        exerciseDurations[record.type] = existingDuration + duration
                    } else {
                        exerciseDurations[record.type] = duration
                    }
                }
                
                for (type, duration) in exerciseDurations {
                    if exerciseTypes[type] == nil {
                        exerciseTypes[type] = exerciseTypes.count
                    }
                }
                
                
                // 날짜를 TimeInterval로 변환
                if let date = dateFormatter.date(from: date) {
                    let dateDouble = date.timeIntervalSince1970
                    let entry = BarChartDataEntry(x: dateDouble, yValues: Array(exerciseDurations.values))
                    dataEntries.append(entry)
                }
            }
        }
        
        let colors: [UIColor] = [.red, .blue, .green, .yellow, .purple, .orange, .brown, .gray, .cyan, .magenta]
        
        let dataSet = BarChartDataSet(entries: dataEntries, label: "운동 기록")
        dataSet.colors = colors
        
        let chartData = BarChartData(dataSet: dataSet)
        barChartView.data = chartData
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

class DateValueFormatter: AxisValueFormatter {
    private let dateFormatter: DateFormatter
    
    init(dateFormatter: DateFormatter) {
        self.dateFormatter = dateFormatter
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = Date(timeIntervalSince1970: value)
        return dateFormatter.string(from: date)
    }
}
