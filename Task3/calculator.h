#ifndef CALCULATOR_H
#define CALCULATOR_H
#include <QWidget>
#include <QLineEdit>
#include <QPushButton>
#include <QLabel>
#include <QVBoxLayout>
class Calculator : public QWidget {
    Q_OBJECT
public:
    Calculator(QWidget *parent = nullptr);
private slots:
    void addNumbers();
private:
    QLineEdit *firstNumber;
    QLineEdit *secondNumber;
    QLabel *resultLabel;
};
#endif // CALCULATOR_H