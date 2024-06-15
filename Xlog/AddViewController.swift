import UIKit

class AddViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {
    @IBOutlet weak var exerciseTypePicker: UIPickerView!
    @IBOutlet weak var startDateTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    // 운동 종류
    let exerciseTypes = ["Running", "Cycling", "Swimming", "Yoga", "Weight Training"]
    // detailsTextView의 Placeholder 텍스트
    let detailsPlaceholder = "오늘 운동한 세부 내용을 입력하세요..."
    
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
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        let selectedExercise = exerciseTypes[exerciseTypePicker.selectedRow(inComponent: 0)]
        let startDate = startDateTimePicker.date
        let endDate = endTimePicker.date
        let details = detailsTextView.text == detailsPlaceholder ? "" : detailsTextView.text
            
        let newRecord = ExerciseRecord(type: selectedExercise, startDate: startDate, endDate: endDate, details: details!)
          
        print(newRecord)
        //DataManager.shared.addRecord(newRecord)
            
        // 성공 메시지를 띄우기 위해 UIAlertController 사용
        let alertController = UIAlertController(title: "성공", message: "운동 기록이 성공적으로 추가되었습니다!", preferredStyle: .alert)
            
        // 확인 버튼 추가
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            // 확인 버튼을 눌렀을 때, 현재 ViewController를 닫습니다.
            self.dismiss(animated: true, completion: nil)
        }
            
        alertController.addAction(confirmAction)
            
        // UIAlertController 표시
        self.present(alertController, animated: true, completion: nil)
    }
}
