/*
    Le RATdeParis
    Copyright (C) 2014  EKMEN Yavuz <yekmen@gmail.com>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
#include "datarequest.h"
#include "UrlCreator.h"

#include <QDebug>

DataRequest::DataRequest(QObject *parent) :
    QObject(parent),
    mgr(NULL),
    mLines(NULL),
    currentRequestID(-1)
{
    mgr = new QNetworkAccessManager(this);
    QObject::connect(mgr, SIGNAL(finished(QNetworkReply*)), this, SLOT(DownloadFinished(QNetworkReply*)));
    // ------- INIT LINES ----//
    mLines = new Lines(this);
    connect(mLines, SIGNAL(linesListChanged()), this, SLOT(linesList()));
    // ------- INIT DIRECTION ----//
    mDirections = new Directions(this);
    connect(mDirections, SIGNAL(directionsListChanged()), this, SLOT(directionsList()));
    // ------- INIT STATION -----//
    mStations = new Stations(this);
    connect(mStations, SIGNAL(stationListChanged()), this, SLOT(stationsList()));
    // -------- INIT SCHEDULE ---------//
    mSchedule = new Schedule2(this);
    connect(mSchedule, SIGNAL(scheduleListChanged()), this, SLOT(scheduleList()));
    // -------- INIT OFFLINEDATA ---------//
    mOfflineData = new OfflineData(this);

}

DataRequest::~DataRequest()
{
}

void DataRequest::getLines(int lineTypeToInt)
{
//    qDebug() << "Get lines " << lineTypeToInt;
    setCurrentType(TypeLines);

    LineType castedLineType = static_cast<LineType>(lineTypeToInt);
    mLines->setCurrentGettingLineType(castedLineType);
    mLines->clear();
    if(!mLines->offlineDataIsExist())
    {
//        qDebug() << "Offline not file exist, download progress ! ";
        QNetworkRequest req(url::getLines());
        mgr->get(req);
    }
    else
    {
//        qDebug() << "Offline file existed ! ";
        QString strReply = mLines->getOfflineData();
        QJsonDocument jsonResponse = QJsonDocument::fromJson(strReply.toUtf8());
        QJsonObject jObject = jsonResponse.object();
        mLines->read(jObject);
    }
}

void DataRequest::getDirections(const int &line)
{
//    qDebug() << "Get direciton : " << line << url::getDirections(line);
    mDirections->clear();
    setCurrentType(TypeDirections);
    QNetworkRequest req(url::getDirections(line));
    mgr->get(req);
}

void DataRequest::getStations(const int &line, const int &direction)
{
//    qDebug() << "Get Stations : " << line << url::getStations(line, direction);
    mStations->clear();
    setCurrentType(TypeStations);
    QNetworkRequest req(url::getStations(line, direction));
    mgr->get(req);
}

void DataRequest::getSchedule(const int &line, const int &direction, const int &station)
{
//    qDebug() << "Get Schedule : " << line << url::getSchedules(line, direction, station);

    //Save schedules
    finalyURL = url::getSchedules(line, direction, station).toString();

    mSchedule->clear();
    setCurrentType(TypeSchedule);
    QNetworkRequest req(url::getSchedules(line, direction, station));
    mgr->get(req);
}

void DataRequest::getSchedule(const QString &aUrl)
{
//    qDebug() << "Get Schedule by URL: " << aUrl;

    mSchedule->clear();
    setCurrentType(TypeSchedule);
    QUrl url(aUrl);
    QNetworkRequest req(url);
    mgr->get(req);
}

void DataRequest::addItineraire()
{
    mOfflineData->addItineraire(finalyURL);
}

QString DataRequest::getScheduleURL()
{
    return finalyURL;
}

int DataRequest::getCurrentRequestID()
{
    return currentRequestID;
}

void DataRequest::refineLine()
{
    emit linesList();
}

void DataRequest::refineStation()
{
    emit stationsListChanged();
}

int DataRequest::makeMeARequestID()
{
    int ret = getCurrentRequestID();
    ret += 1;
    currentRequestID = ret;
    return ret;
}

DataRequest::TypeData DataRequest::getCurrentType() const
{
    return currentType;
}

void DataRequest::setCurrentType(const TypeData &value)
{
    currentType = value;
}

QQmlListProperty<Line> DataRequest::linesList()
{
    emit linesListChanged();
    return mLines->linesList();
}

QQmlListProperty<Direction> DataRequest::directionsList()
{
    emit directionsListChanged();
    return mDirections->directionsList();
}

QQmlListProperty<Station> DataRequest::stationsList()
{
    emit stationsListChanged();
    return mStations->stationList();
}

QQmlListProperty<Schedule> DataRequest::scheduleList()
{
    emit schedulesChanged(currentRequestID);
    return mSchedule->scheduleList();
}

void DataRequest::DownloadFinished(QNetworkReply *aReply)
{
    if(aReply->error()  == QNetworkReply::NoError )
    {
        QVariant strReply = aReply->readAll();
        QJsonDocument jsonResponse = QJsonDocument::fromJson(strReply.toString().toUtf8());
        QJsonObject jObject = jsonResponse.object();

        if(getCurrentType() == TypeLines)
        {
            if(!jsonResponse.isNull())
            {
                if(!mLines->offlineDataIsExist())
                    mLines->saveFile(strReply.toString());

                mLines->read(jObject);
            }
        }
        if(getCurrentType() == TypeDirections)
        {
            if(!jsonResponse.isNull())
            {
                mDirections->read(jObject);
            }
        }
        if(getCurrentType() == TypeStations)
        {
            if(!jsonResponse.isNull())
            {
                mStations->read(jObject);
            }
        }
        if(getCurrentType() == TypeSchedule)
        {
            if(!jsonResponse.isNull())
            {
                mSchedule->read(jObject);
            }
        }
    }
    else
        emit errorDownload(aReply->errorString());

}
