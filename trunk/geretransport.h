#ifndef GERETRANSPORT_H
#define GERETRANSPORT_H

#include <QObject>
#include <QStringList>
class GereTransport : public QObject
{
    Q_OBJECT
public:
    explicit GereTransport(QObject *parent = 0);
    void afine();
    void arret_bus(QString qml_data);
signals:
    
public slots:
    
};

#endif // GERETRANSPORT_H
