//
//  SelectVerbsViewController.swift
//  Verregular
//
//  Created by Даниил Сивожелезов on 30.05.2024.
//

import UIKit
import SnapKit

final class SelectVerbsViewController: UITableViewController {
    // MARK: - Properties
    private var dataSource = IrregularVerbs.shared
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Select verbs".localized
        dataSource.selectedVerbs = dataSource.verbs
        tableView.register(SelectVerbsTableViewCell.self, forCellReuseIdentifier: "SelectVerbsTableViewCell")
    }
    
    // MARK: - Private Methods
    private func isSelected(verb: Verb) -> Bool {
        dataSource.selectedVerbs.contains { $0.infinitive == verb.infinitive }
    }
}

// MARK: - UITableViewDataSource
extension SelectVerbsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.verbs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectVerbsTableViewCell",
                                                       for: indexPath) as? SelectVerbsTableViewCell
        else { return UITableViewCell() }
        
        let verb = dataSource.verbs[indexPath.row]
        cell.configure(with: verb, isSelected: isSelected(verb: verb))
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SelectVerbsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let verb = dataSource.verbs[indexPath.row]
        
        if isSelected(verb: verb) {
            dataSource.selectedVerbs.removeAll { $0.infinitive == verb.infinitive }
        } else {
            dataSource.selectedVerbs.append(verb)
        }
    
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
