#ifndef DATAREQUEST_H
#define DATAREQUEST_H

#include <QObject>
#include "lines.h"
#include "schedule2.h"
#include "directions.h"
#include "stations.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QUrl>
#include <QUrlQuery>

#include <QJsonValue>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QVector>

class DataRequest : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QQmlListProperty<Line> linesList READ linesList NOTIFY linesListChanged)
    Q_PROPERTY(QQmlListProperty<Direction> directionsList READ directionsList NOTIFY directionsListChanged)
    Q_PROPERTY(QQmlListProperty<Station> stationsList READ stationsList NOTIFY stationsListChanged)
    Q_PROPERTY(QQmlListProperty<Schedule> scheduleList READ scheduleList NOTIFY schedulesChanged)

public:
    enum TypeData{
        TypeLines,
        TypeDirections,
        TypeStations,
        TypeSchedule
    };

    explicit DataRequest(QObject *parent = 0);
    ~DataRequest();
    Q_INVOKABLE void getLines(int lineTypeToInt);
    Q_INVOKABLE void getDirections(const int &line);
    Q_INVOKABLE void getStations(const int &line, const int &direction);
    Q_INVOKABLE void getSchedule(const int &line, const int &direction, const int &station);

    TypeData getCurrentType() const;
    void setCurrentType(const TypeData &value);
private:
    QNetworkAccessManager *mgr;
    TypeData currentType;
    Lines* mLines;
    Directions* mDirections;
    Stations* mStations;
    Schedule2* mSchedule;
public slots:
    void DownloadFinished(QNetworkReply *aReply);
    QQmlListProperty<Line> linesList();
    QQmlListProperty<Direction> directionsList();
    QQmlListProperty<Station> stationsList();
    QQmlListProperty<Schedule> scheduleList();
signals:
    void errorDownload(QString error);
    void downloaded();
    void linesListChanged();
    void directionsListChanged();
    void stationsListChanged();
    void schedulesChanged();
};

#endif // DATAREQUEST_H
