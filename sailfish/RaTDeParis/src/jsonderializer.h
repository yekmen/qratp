#ifndef JSONDERIALIZER_H
#define JSONDERIALIZER_H

#include <QJsonObject>
#include <QObject>

class JsonDerializer : public QObject
{
    Q_OBJECT
public:
     JsonDerializer(QObject *parent =0):
        QObject(parent)
    {

    }
//    ~JsonDerializer(){}
    virtual void read(const QJsonObject &jsonObj) = 0;
     virtual void clear() = 0;
//    virtual void write(QJsonObject &jsonObj)= 0;
};

#endif // JSONDERIALIZER_H
