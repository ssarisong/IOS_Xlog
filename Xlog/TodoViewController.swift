import UIKit

class TodoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    
    @IBOutlet weak var todoTableView: UITableView!
    @IBOutlet weak var newTodoNameTextField: UITextField!
    @IBOutlet weak var addTodoButton: UIButton!
    @IBOutlet weak var memoTextView: UITextView!
    var todos: [Todo] = []
    var memo: String = ""
    let initDetailMessage = "운동 루틴을 입력해주세요..."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todoTableView.dataSource = self
        todoTableView.delegate = self
        memoTextView.delegate = self
        
        todos = DataManager.shared.getAllTodos()
        memoTextView.text = DataManager.shared.getMemo() ?? initDetailMessage
        if memoTextView.text == "" {
            memoTextView.text = initDetailMessage
        }
        if memoTextView.text == initDetailMessage {
            memoTextView.textColor = UIColor.lightGray
        } else {
            memoTextView.textColor = UIColor.black
        }
        
        memoTextView.layer.borderColor = UIColor.lightGray.cgColor
        memoTextView.layer.borderWidth = 1.0
        memoTextView.layer.cornerRadius = 8.0
        
        addTodoButton.layer.cornerRadius = 8.0
        
        newTodoNameTextField.layer.borderColor = UIColor.lightGray.cgColor
        newTodoNameTextField.layer.borderWidth = 1.0
        newTodoNameTextField.layer.cornerRadius = 8.0
        
        todoTableView.layer.borderColor = UIColor.lightGray.cgColor
        todoTableView.layer.borderWidth = 1.0
        todoTableView.layer.cornerRadius = 8.0
        
        todoTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        todos = DataManager.shared.getAllTodos()
        let memo = DataManager.shared.getMemo() ?? initDetailMessage
        memoTextView.text = memo
        if memoTextView.text == "" {
            memoTextView.text = initDetailMessage
        }
        if memoTextView.text == initDetailMessage {
            memoTextView.textColor = UIColor.lightGray
        } else {
            memoTextView.textColor = UIColor.black
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if memoTextView.text != initDetailMessage {
            DataManager.shared.saveMemo(memoTextView.text)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as? TodoTableViewCell else {
            return UITableViewCell()
        }
        
        let todo = todos[indexPath.row]
        
        cell.name.text = todo.name
        cell.checkBox.setImage(UIImage(systemName: todo.checked ? "checkmark.circle.fill" : "checkmark.circle"), for: .normal)
        
        cell.checkBox.tag = indexPath.row
        cell.checkBox.addTarget(self, action: #selector(checkBoxTapped(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataManager.shared.deleteTodo(at: indexPath.row)
            todos = DataManager.shared.getAllTodos()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == initDetailMessage {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = initDetailMessage
            textView.textColor = UIColor.lightGray
        } else {
            DataManager.shared.saveMemo(textView.text)
        }
    }
    
    @IBAction func addTodoButtonClicked(_ sender: Any) {
        guard let todoName = newTodoNameTextField.text, !todoName.isEmpty else {
            return
        }
        
        let newTodo = Todo(name: todoName, checked: false)
        print(newTodo)
        DataManager.shared.addTodo(newTodo)
        todos.append(newTodo)
        
        newTodoNameTextField.text = ""
        print(todos)
        todoTableView.reloadData()
    }
    
    @IBAction func checkBoxTapped(_ sender: UIButton) {
        let index = sender.tag
        todos[index].checked.toggle()
        DataManager.shared.updateTodo(at: index, with: todos[index])
        todoTableView.reloadData()
    }
}
