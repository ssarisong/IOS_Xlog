import Foundation

struct ExerciseRecord: Codable {
    var type: String
    var startDate: Date
    var endDate: Date
    var details: String
}

struct Todo: Codable {
    var name: String
    var checked: Bool
}

class DataManager {
    static let shared = DataManager()
    
    private init() {
        loadRecords()
        loadTodos()
        loadMemo()
    } // 싱글톤 패턴을 위한 private 초기화
    
    private var records: [ExerciseRecord] = []
    private var todos: [Todo] = []
    private var memo: String?
    
    // ExerciseRecord 관련 메서드
    func addRecord(_ record: ExerciseRecord) {
        records.append(record)
        saveRecords()
    }
    
    func getAllRecords() -> [ExerciseRecord] {
        return records.sorted(by: { $0.startDate > $1.startDate })
    }
    
    func deleteRecord(at index: Int) {
        let sortedRecords = getAllRecords()
        let recordToDelete = sortedRecords[index]
        
        if let originalIndex = records.firstIndex(where: { $0.type == recordToDelete.type && $0.startDate == recordToDelete.startDate && $0.endDate == recordToDelete.endDate && $0.details == recordToDelete.details }) {
            records.remove(at: originalIndex)
            saveRecords()
        } else {
            print("Record not found")
        }
    }
    
    func deleteRecord(_ record: ExerciseRecord) {
        if let index = records.firstIndex(where: { $0.type == record.type && $0.startDate == record.startDate && $0.endDate == record.endDate && $0.details == record.details }) {
            records.remove(at: index)
            saveRecords()
        } else {
            print("Record not found")
        }
    }
    
    private func saveRecords() {
        if let encoded = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(encoded, forKey: "exerciseRecords")
        }
    }
    
    private func loadRecords() {
        if let savedData = UserDefaults.standard.data(forKey: "exerciseRecords"),
           let decodedRecords = try? JSONDecoder().decode([ExerciseRecord].self, from: savedData) {
            records = decodedRecords
        }
    }
    
    // Todo 관련 메서드
    func addTodo(_ todo: Todo) {
        todos.append(todo)
        saveTodos()
    }
    
    func getAllTodos() -> [Todo] {
        return todos
    }
    
    func deleteTodo(at index: Int) {
        guard index >= 0 && index < todos.count else {
            print("Invalid index")
            return
        }
        todos.remove(at: index)
        saveTodos()
    }
    
    func updateTodo(at index: Int, with todo: Todo) {
        guard index >= 0 && index < todos.count else {
            print("Invalid index")
            return
        }
        todos[index] = todo
        saveTodos()
    }
    
    private func saveTodos() {
        if let encoded = try? JSONEncoder().encode(todos) {
            UserDefaults.standard.set(encoded, forKey: "todos")
        }
    }
    
    private func loadTodos() {
        if let savedData = UserDefaults.standard.data(forKey: "todos"),
           let decodedTodos = try? JSONDecoder().decode([Todo].self, from: savedData) {
            todos = decodedTodos
        }
    }

    // Memo 관련 메서드
    func saveMemo(_ memo: String) {
        self.memo = memo
        UserDefaults.standard.set(memo, forKey: "memo")
    }
    
    func getMemo() -> String? {
        return UserDefaults.standard.string(forKey: "memo")
    }
    
    func updateMemo(_ memo: String) {
        saveMemo(memo)
    }
    
    private func loadMemo() {
        self.memo = UserDefaults.standard.string(forKey: "memo")
    }
}
