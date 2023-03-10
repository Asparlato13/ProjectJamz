//
//  ActionLabelView.swift
//  jamz app
//
//

import UIKit


//defines a custom view called ActionLabelView. It has a delegate property that conforms to the ActionLabelViewDelegate protocol. The view contains a UILabel and a UIButton, and is designed to be used to display a message and an action button in a compact way.


//The ActionLabelViewViewModel struct is used to provide data for the view, including a text string and the title for the action button.
struct ActionLabelViewViewModel{
    let text: String
    let actionTitle: String
}

//The ActionLabelViewDelegate protocol defines a single method that is called when the user taps the action button.
protocol ActionLabelViewDelegate: AnyObject {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView)
}


class ActionLabelView: UIView {
    
    weak var delegate: ActionLabelViewDelegate?
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
        
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        return button
        
    }()
//The view is initialized with a frame, and the init?(coder: NSCoder) initializer is implemented but marked as fatalError() to prevent initialization from a storyboard or nib.
    override init(frame: CGRect) {
        super.init(frame: frame)
      //  backgroundColor = .red
        clipsToBounds = true
        isHidden = true
        addSubview(button)
        addSubview(label)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    //The didTapButton method is called when the action button is tapped, and it calls the actionLabelViewDidTapButton method on the delegate, passing in the view as an argument.
    @objc func didTapButton() {
        delegate?.actionLabelViewDidTapButton(self)
    }
    
//    The layoutSubviews method is called when the view is laid out. It sets the frame of the button to be at the bottom of the view, with a height of 40 and a width of the view's width. It sets the frame of the label to be at the top of the view, with a height of the view's height minus 45 (to leave room for the button), and a width equal to the view's width.
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = CGRect(x: 0, y: height-40, width: width, height: 40)
        label.frame = CGRect(x: 0, y: 0, width: width, height: height-45)
    }
    
    
    //The configure method takes an instance of the ActionLabelViewViewModel struct as an argument and sets the text of the label and the title of the button to the corresponding properties of the view model.
    func configure(with viewModel: ActionLabelViewViewModel) {
        label.text = viewModel.text
        button.setTitle(viewModel.actionTitle, for: .normal)
    }
    
}
