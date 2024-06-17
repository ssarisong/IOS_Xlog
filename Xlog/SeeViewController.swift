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
        
        exerciseListTableView.layer.borderColor = UIColor.lightGray.cgColor
        exerciseListTableView.layer.borderWidth = 1.0
        exerciseListTableView.layer.cornerRadius = 8.0
        
        detailTextView.layer.borderColor = UIColor.lightGray.cgColor
        detailTextView.layer.borderWidth = 1.0
        detailTextView.layer.cornerRadius = 8.0
        
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
        xAxis.labelCount = 7
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        xAxis.valueFormatter = DateValueFormatter(dateFormatter: dateFormatter)
        
        let leftAxis = barChartView.leftAxis
        leftAxis.drawGridLinesEnabled = false
        leftAxis.axisMinimum = 0
    }
    
    func updateChartData() {
        let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -6, to: Date())!
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd"
        
        var datesInWeek: [String] = []
        var currentDate = oneWeekAgo
        
        while currentDate <= today {
            datesInWeek.append(dateFormatter.string(from: currentDate))
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        let groupedRecords = Dictionary(grouping: records.filter { $0.startDate >= oneWeekAgo }) { (record) -> String in
            return dateFormatter.string(from: record.startDate)
        }
        
        var dataEntries: [BarChartDataEntry] = []
        var exerciseTypes: [String: Int] = [:]
        
        for (index, date) in datesInWeek.enumerated() {
            var exerciseDurations: [String: Double] = [:]
            
            if let recordsForDate = groupedRecords[date] {
                for record in recordsForDate {
                    let duration = record.endDate.timeIntervalSince(record.startDate) / 60.0 // 분 단위로 변환
                    if let existingDuration = exerciseDurations[record.type] {
                        exerciseDurations[record.type] = existingDuration + duration
                    } else {
                        exerciseDurations[record.type] = duration
                    }
                }
            }
            
            // 운동 유형을 일관되게 정렬
            for (type, duration) in exerciseDurations {
                if exerciseTypes[type] == nil {
                    exerciseTypes[type] = exerciseTypes.count
                }
            }
            
            // 운동 유형을 기준으로 yValues 정렬
            let yValues = exerciseTypes.sorted { $0.value < $1.value }.map { exerciseDurations[$0.key] ?? 0.0 }
            let entry = BarChartDataEntry(x: Double(index), yValues: yValues.isEmpty ? [0.0] : yValues)
            dataEntries.append(entry)
        }
        
        let colors: [UIColor] = [.red, .blue, .green, .yellow, .purple, .orange, .brown, .gray, .cyan, .magenta]
        
        let dataSet = BarChartDataSet(entries: dataEntries, label: "운동 종류")
        dataSet.colors = exerciseTypes.keys.sorted(by: { exerciseTypes[$0]! < exerciseTypes[$1]! }).map { type in
            switch type {
            case "걷기":
                return UIColor.red
            case "달리기":
                return UIColor.blue
            case "수영":
                return UIColor.green
            case "요가/필라테스":
                return UIColor.yellow
            case "헬스":
                return UIColor.purple
            case "자전거":
                return UIColor.orange
            case "축구":
                return UIColor.brown
            case "농구":
                return UIColor.lightGray
            case "탁구":
                return UIColor.cyan
            case "배구":
                return UIColor.magenta
            case "야구":
                return UIColor.systemPink
            case "배드민턴/테니스":
                return UIColor.darkGray
            case "줄넘기":
                return UIColor.systemIndigo
            case "볼링":
                return UIColor.systemTeal
            case "골프":
                return UIColor.systemMint
            case "등산":
                return UIColor.black
            default:
                return UIColor.white
            }
        }
        //dataSet.colors = colors
        dataSet.valueFormatter = DefaultValueFormatter(decimals: 0)
        dataSet.valueTextColor = .black
        dataSet.valueFont = .systemFont(ofSize: 10, weight: .light)
        dataSet.drawValuesEnabled = false
        
        let chartData = BarChartData(dataSet: dataSet)
        
        barChartView.data = chartData
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: datesInWeek.map { dateFormatter.string(from: dateFormatter.date(from: $0)!) })
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
