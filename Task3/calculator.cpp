#include "calculator.h"
Calculator::Calculator(QWidget *parent) : QWidget(parent) {
    firstNumber = new QLineEdit(this);
    secondNumber = new QLineEdit(this);
    QPushButton *addButton = new QPushButton("Сложить", this);
    resultLabel = new QLabel("Результат: ", this);
    QVBoxLayout *layout = new QVBoxLayout;
    layout->addWidget(firstNumber);
    layout->addWidget(secondNumber);
    layout->addWidget(addButton);
    layout->addWidget(resultLabel);
    setLayout(layout);
    connect(addButton, &QPushButton::clicked, this, &Calculator::addNumbers);
}
void Calculator::addNumbers() {
    bool ok1, ok2;
    double num1 = firstNumber->text().toDouble(&ok1);
    double num2 = secondNumber->text().toDouble(&ok2);
    
    if (ok1 && ok2) {
        double sum = num1 + num2;
        resultLabel->setText("Результат: " + QString::number(sum));
    } else {
        resultLabel->setText("Ошибка ввода");
    }
}