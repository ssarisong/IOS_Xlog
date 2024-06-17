import UIKit

class AddViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {
    @IBOutlet weak var exerciseTypePicker: UIPickerView!
    @IBOutlet weak var startDateTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    // 운동 종류
    let exerciseTypes = ["걷기", "달리기", "수영", "요가/필라테스", "헬스", "자전거", "축구", "농구", "탁구", "배구", "야구", "배드민턴/테니스", "줄넘기", "볼링", "골프", "등산"]
    // detailsTextView의 Placeholder 텍스트
    let detailsPlaceholder = """
        오늘 한 운동 일지를 입력하세요...
    
        [예시]
        오늘 한 운동은 수영이고, 세부 분야는 접영이다.
        어제 잠을 별로 못 자서 컨디션이 안 좋았는지 오늘은 평소보다
        수영하는 것이 힘들었던 것 같다.
        오늘은 1시간 정도 접영을 했으니, 내일은 20분 정도 접영하고 
        나머지 40분 동안 자유영을 할 예정이다.
        오늘은 잠 꼭 일찍 자야지!!
    """
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Picker View 설정
        exerciseTypePicker.delegate = self
        exerciseTypePicker.dataSource = self
        
        // Text View 설정
        detailsTextView.delegate = self
        detailsTextView.text = detailsPlaceholder
        detailsTextView.textColor = UIColor.lightGray
        
        // Text View 테두리 설정
        detailsTextView.layer.borderColor = UIColor.lightGray.cgColor
        detailsTextView.layer.borderWidth = 1.0
        detailsTextView.layer.cornerRadius = 8.0
        
        resetFields()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return exerciseTypes.count
    }
    
    // UIPickerViewDelegate 메서드
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return exerciseTypes[row]
    }
        
    // UITextViewDelegate 메서드
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == detailsPlaceholder {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
        
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = detailsPlaceholder
            textView.textColor = UIColor.lightGray
        }
    }
    
    func resetFields() {
        exerciseTypePicker.selectRow(0, inComponent: 0, animated: false)
        
        let calendar = Calendar.current
        var startDate = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        var endDate = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        startDate.second = 0
        startDate.nanosecond = 0
        endDate.second = 0
        endDate.nanosecond = 0
        endDate.minute = endDate.minute! + 1
        if let startModifiedDate = calendar.date(from: startDate) {
            startDateTimePicker.date = startModifiedDate
        }
        if let endModifiedDate = calendar.date(from: endDate) {
            endTimePicker.date = endModifiedDate
        }
        
        detailsTextView.text = detailsPlaceholder
        detailsTextView.textColor = UIColor.lightGray
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        let selectedExercise = exerciseTypes[exerciseTypePicker.selectedRow(inComponent: 0)]
        
        let calendar = Calendar.current
        let startDate = startDateTimePicker.date
        var endDate = endTimePicker.date
        var endDateComponents = calendar.dateComponents([.hour, .minute, .second], from: endDate)
        endDateComponents.year = calendar.component(.year, from: startDate)
        endDateComponents.month = calendar.component(.month, from: startDate)
        endDateComponents.day = calendar.component(.day, from: startDate)
        if let newEndDate = calendar.date(from: endDateComponents) {
            endDate = newEndDate
        }
        
        let details = detailsTextView.text == detailsPlaceholder ? "" : detailsTextView.text
            
        let newRecord = ExerciseRecord(type: selectedExercise, startDate: startDate, endDate: endDate, details: details!)
          
        print(newRecord)
        if endDate <= startDate {
            let alertController = UIAlertController(title: "실패", message: "운동 시간을 다시 설정해주세요!", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
                // 확인 버튼을 눌렀을 때, 현재 ViewController를 닫습니다.
                self.dismiss(animated: true, completion: nil)
            }
                
            alertController.addAction(confirmAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            DataManager.shared.addRecord(newRecord)
            
            resetFields()
            
            let alertController = UIAlertController(title: "성공", message: "운동 기록이 성공적으로 추가되었습니다!", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
                // 확인 버튼을 눌렀을 때, 현재 ViewController를 닫습니다.
                self.dismiss(animated: true, completion: nil)
            }
            
            alertController.addAction(confirmAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
