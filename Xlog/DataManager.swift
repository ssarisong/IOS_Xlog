//
//  DataManager.swift
//  Xlog
//
//  Created by 송수진 on 6/16/24.
//

import Foundation

struct ExerciseRecord: Codable {
    var type: String
    var startDate: Date
    var endDate: Date
    var details: String
}

class DataManager {
    static let shared = DataManager()
    
    private init() {
        loadRecords()
    } // 싱글톤 패턴을 위한 private 초기화
    
    private var records: [ExerciseRecord] = []
    
    func addRecord(_ record: ExerciseRecord) {
        records.append(record)
        saveRecords()
    }
    
    func getAllRecords() -> [ExerciseRecord] {
        return records
    }
    
    func deleteRecord(at index: Int) {
        guard index >= 0 && index < records.count else {
            print("Invalid index")
            return
        }
        records.remove(at: index)
        saveRecords()
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
}
