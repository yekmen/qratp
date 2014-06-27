#include "lines.h"
#include <QFile>
#include <QTextStream>
#include <QDebug>
#include <QJsonArray>

Lines::Lines(QObject *parent):
    JsonDerializer(parent)
{

}

Lines::~Lines()
{

}

void Lines::read(const QJsonObject &jsonObj)
{
    QJsonArray ar = jsonObj["lines"].toArray();
//    qDebug() << "Lets goo !! " << ar.size();

    for(int i = 0; i < ar.size(); i++)
    {
        QJsonObject jObj = ar.at(i).toObject();
        Line *line = new Line(jObj.value("id").toVariant().toInt(),
                              jObj.value("type_id").toVariant().toInt(),
                              jObj.value("line").toString(),
                              jObj.value("type_id").toString());

        if(getCurrentGettingLineType() == line->getLineType())
            mLines.push_back(line);
//        else if(getCurrentGettingLineType() == "0" || getCurrentGettingLineType() == "")
//            qWarning() << "" << getCurrentGettingLineType() << line->getLineType();
//        else  //is not a bus|metro|rer ...

    }
    emit linesListChanged();
}

void Lines::clear()
{
    mLines.clear();
    qDebug() << "[Lines] list has been cleared !";
}


QQmlListProperty<Line> Lines::linesList()
{
    return QQmlListProperty<Line>(this, mLines);
}

QString Lines::getOfflineData() const
{
    QFile file("./lines.json");
    QString ret;
    if(file.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        while (!file.atEnd()) {
            QByteArray line = file.readLine();
            ret = (QString)line;
        }
    }
    return ret;
}

void Lines::saveFile(QString jsonData)
{
    QFile file("./lines.json");
    if(file.open(QIODevice::WriteOnly | QIODevice::Text))
    {
        QTextStream out(&file);
        out << jsonData;
        file.close();
        qDebug() << "SAVING OK";
    }
    else
        qDebug() << "ERROR !";
}

bool Lines::offlineDataIsExist() const
{
    QFile file("./lines.json");
    return file.exists();
}
LineType Lines::getCurrentGettingLineType() const
{
    return currentGettingLineType;
}

void Lines::setCurrentGettingLineType(const LineType &value)
{
    currentGettingLineType = value;
}





LineType Line::getLineType() const
{
    return lineType;
}

void Line::setLineType(const LineType &value)
{
    lineType = value;
}
