//
//  SelectVerbsTableViewCell.swift
//  Verregular
//
//  Created by Даниил Сивожелезов on 31.05.2024.
//

import UIKit
import SnapKit

final class SelectVerbsTableViewCell: UITableViewCell {
    enum State {
        case select, unselect
        
        var image: UIImage {
            switch self {
            case .select:
                return UIImage.checkmark
            case .unselect:
                return UIImage(systemName: "circlebadge") ?? UIImage.add
            }
        }
    }
    // MARK: - GUI Variables
    private lazy var checkboxImageView: UIImageView = {
        let view = UIImageView()
        
        view.image = State.unselect.image
        view.contentMode = .center
        
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var infinitiveView: UIView = UIView()
    
    private lazy var infinitiveLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()
    
    private lazy var translationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var pastLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var participleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func configure(with verb: Verb, isSelected: Bool) {
        infinitiveLabel.text = verb.infinitive
        translationLabel.text = verb.translation
        pastLabel.text = verb.pastSimple
        participleLabel.text = verb.participle
        
        checkboxImageView.image = isSelected ? State.select.image : State.unselect.image
    }
    
    private func setupUI() {
        
        selectionStyle = .none
        infinitiveView.addSubviews([infinitiveLabel, translationLabel])
        stackView.addArrangedSubviews([infinitiveView, pastLabel, participleLabel])
        addSubviews([checkboxImageView, stackView])
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        checkboxImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        infinitiveLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        infinitiveView.snp.makeConstraints { make in
            make.height.equalTo(69)
        }
        
        translationLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(infinitiveLabel.snp.bottom).offset(0)
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(checkboxImageView.snp.trailing).offset(5)
            make.top.right.bottom.equalToSuperview()
        }
    }
}
