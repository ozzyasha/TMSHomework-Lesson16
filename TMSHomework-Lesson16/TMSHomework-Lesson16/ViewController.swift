//
//  ViewController.swift
//  TMSHomework-Lesson16
//
//  Created by Наталья Мазур on 15.01.24.
//

import UIKit

class ViewController: UIViewController {
    let circleView = UIView()
    let tapGesture = UITapGestureRecognizer()
    let longPressGesture = UILongPressGestureRecognizer()
    let panGesture = UIPanGestureRecognizer()

    var symbolsArray = ["👆", "👇", "👈", "👉"]
    var buttonsArray: [UIButton] = []
    var buttonsHStackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupButtonsStack()
        setupCircle()
    }

    func setupButtonsStack() {
        buttonsHStackView.axis = .horizontal
        buttonsHStackView.alignment = .center
        buttonsHStackView.distribution = .fillEqually
        buttonsHStackView.spacing = 20

        buttonsHStackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(buttonsHStackView)

        setupHStackConstraints()

        setupButtonsArray()
        buttonsArray.forEach { button in
            buttonsHStackView.addArrangedSubview(button)
        }
        setupButtonsConstraints()
    }

    func setupButtonsArray() {
        symbolsArray.forEach { symbol in
            let moveButton = UIButton()
            moveButton.backgroundColor = UIColor.orange
            buttonsArray.append(moveButton)

            setupButtonView(button: moveButton, title: symbol)
        }
    }

    func setupButtonView(button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor.systemGray6
        button.layer.cornerRadius = 20

        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    func setupCircle() {
        view.addSubview(circleView)

        circleView.frame = CGRect(x: view.center.x, y: view.center.y, width: 50, height: 50)
        circleView.layer.cornerRadius = circleView.frame.width / 2
        circleView.backgroundColor = UIColor(red: CGFloat(Double.random(in: 1 / 255 ... 255 / 255)), green: CGFloat(Double.random(in: 1 / 255 ... 255 / 255)), blue: CGFloat(Double.random(in: 1 / 255 ... 254 / 255)), alpha: 1.0)

        tapGesture.addTarget(self, action: #selector(circleTapped))
        longPressGesture.addTarget(self, action: #selector(circleLongPressed))
        panGesture.addTarget(self, action: #selector(circlePanned))

        circleView.addGestureRecognizer(tapGesture)
        circleView.addGestureRecognizer(longPressGesture)
        circleView.addGestureRecognizer(panGesture)
    }

    func setupHStackConstraints() {
        NSLayoutConstraint.activate([
            buttonsHStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            buttonsHStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    func setupButtonsConstraints() {
        buttonsArray.forEach({ button in
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 70),
                button.heightAnchor.constraint(equalToConstant: 70),
            ])
        })
    }

    @objc func buttonTapped(_ sender: UIButton) {
        let circleLeft = Int(circleView.frame.minX)
        let circleRight = Int(circleView.frame.maxX)
        let circleBottom = Int(circleView.frame.maxY)
        let circleTop = Int(circleView.frame.minY)
        let circleSide = Int(circleView.bounds.size.width)

        if sender.titleLabel?.text == "👆" {
            if circleTop > Int(buttonsHStackView.frame.maxY + 30) {
                UIView.animate(withDuration: 0.2) {
                    self.circleView.frame = CGRect(x: circleLeft, y: circleTop - 30, width: circleSide, height: circleSide)
                }
            }
        } else if sender.titleLabel?.text == "👇" {
            if circleBottom < Int(view.safeAreaLayoutGuide.layoutFrame.maxY - 30) {
                UIView.animate(withDuration: 0.2) {
                    self.circleView.frame = CGRect(x: circleLeft, y: circleTop + 30, width: circleSide, height: circleSide)
                }
            }
        } else if sender.titleLabel?.text == "👈" {
            if circleLeft > 30 {
                UIView.animate(withDuration: 0.2) {
                    self.circleView.frame = CGRect(x: circleLeft - 30, y: circleTop, width: circleSide, height: circleSide)
                }
            }
        } else if sender.titleLabel?.text == "👉" {
            if circleRight < Int(UIScreen.main.bounds.size.width) - 30 {
                UIView.animate(withDuration: 0.2) {
                    self.circleView.frame = CGRect(x: circleLeft + 30, y: circleTop, width: circleSide, height: circleSide)
                }
            }
        }
    }

    @objc func circleTapped(_ gesture: UITapGestureRecognizer) {
        circleView.removeFromSuperview()

        let safeAreaWidth = Int(view.safeAreaLayoutGuide.layoutFrame.size.width)
        let stackBottom = Int(buttonsHStackView.frame.maxY)
        let safeAreaBottom = Int(view.safeAreaLayoutGuide.layoutFrame.maxY)

        let circleSide = Int(circleView.bounds.size.width)

        circleView.frame = CGRect(x: Int.random(in: 1 ..< (safeAreaWidth - circleSide)), y: Int.random(in: (stackBottom + circleSide) ..< (safeAreaBottom - circleSide)), width: circleSide, height: circleSide)
        circleView.backgroundColor = UIColor(red: CGFloat(Double.random(in: 1 / 255 ... 255 / 255)), green: CGFloat(Double.random(in: 1 / 255 ... 255 / 255)), blue: CGFloat(Double.random(in: 1 / 255 ... 254 / 255)), alpha: 1.0)

        view.addSubview(circleView)
    }

    @objc func circleLongPressed(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            print("LongPressed")
            UIView.animate(withDuration: 1.0, delay: 0.0, options: .autoreverse, animations: {
                self.circleView.transform = CGAffineTransform(scaleX: 2, y: 2)
            }, completion: { _ in
                self.circleView.transform = .identity
            })
        }
    }

    @objc func circlePanned(_ gesture: UIPanGestureRecognizer) {
        UIView.animate(withDuration: 0.05) {
            self.circleView.center = gesture.location(in: self.circleView.superview)
        }
    }
}

// ДЗ №16:
// Создать приложение со следующим функционалом:
// Появление разноцветного кружочка, который по тапу исчезает и появляется в новом месте.

// ДЗ №17:
// Написать приложение со следующим функционалом:
// На экране кружок по центру. Четыре кнопки: вверх, вниз, вправо, влево.
// При нажатии соответствующей кнопки, кружок перемещается с анимацией на фиксированное расстояние.
// За края экрана не выходит, на кнопки не налезает.
