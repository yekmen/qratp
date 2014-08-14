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
#ifndef LINES_H
#define LINES_H

#include "jsonderializer.h"
#include <QUrl>
#include <QQmlListProperty>
#include <QObject>
#include <QDebug>

enum LineType{
    LineType_Bus = 1,
    LineType_Metro = 2,
    LineType_Tram = 6,
    LineType_RER = 3,
    LineType_SNCF = 4
};


class Line : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString line READ getLine NOTIFY lineChanged)
    Q_PROPERTY(QString typeName READ getTypeName)
    Q_PROPERTY(QString urlLine READ getUrlLine NOTIFY urlLineChanged)
    Q_PROPERTY(QString urlType READ getTypeURL NOTIFY urlTypeChanged)
    Q_PROPERTY(int idJson READ getID)
    Q_PROPERTY(int typeID READ getTypeID)
public:
    Line(QObject *parent = 0):QObject(parent){}
    Line(int _id, int _typeID, QString _line, QString _typeName, QObject *parent = 0):
        QObject(parent)
    {
        setID(_id);
        setTypeID(_typeID);
        setTypeName(_typeName);

        if(_line.startsWith("0"))
            setLine(_line.remove(0,1));
        else
            setLine(_line);

        cleanner();
        if(getLine().isEmpty())
            return;

//        qDebug() << getTypeName();
        switch (_typeID)
        {
        case 1: //BUS
//            setTypeURL("http://v1.chervoisin2transport.fr/images/lignes/36/bus.png");
            setLineType(LineType_Bus);
            setTypeURL(":/logo/bus.png");
            setUrlLine(QString("http://v1.chervoisin2transport.fr/images/lignes/36/bus_%1.png").arg(getLine()));
            break;
        case 2:     //Metro
//            setTypeURL("http://v1.chervoisin2transport.fr/images/lignes/36/metro.png");
            setLineType(LineType_Metro);
            setTypeURL(":/logo/metro.png");
            setUrlLine(QString("http://v1.chervoisin2transport.fr/images/lignes/36/metro_%1.png").arg(getLine()));
            break;
//        case 3:
//            if(getTypeName().operator ==("SNCF"))
//            {
////            setTypeURL("http://v1.chervoisin2transport.fr/images/lignes/36/rer.png");
//                setLineType(LineType_RER);
//                setTypeURL(":/logo/rer.png");
//                qDebug() << "RER " << getLine();
//            }
//            break;
        case 4:
//            if(getID() == 356 || getID() ==)
            if(getTypeName().operator ==("RER"))
            {
                setLineType(LineType_RER);
                setTypeURL(":/logo/rer.png");

                if(getLine().operator ==("A"))
                    setUrlLine("http://v1.chervoisin2transport.fr/images/lignes/36/rer_a.png");
                if(getLine().operator ==("B"))
                     setUrlLine("http://v1.chervoisin2transport.fr/images/lignes/36/rer_b.png");
            }
            break;
        case 6: //Tram
            setLineType(LineType_Tram);
            setTypeURL("http://v1.chervoisin2transport.fr/images/lignes/36/tramway.png");
            setTypeURL(":/logo/tramway.png");
            break;
        }
    }
    ~Line(){}

    void cleanner()
    {
        QString str = getLine();

        if(str.operator ==("3B"))
            str = "3bis";
        if(str.operator ==("7B"))
            str = "7bis";

        setLine(str);
    }

    int getID() const
    {
        return mID;
    }

    void setID(int value)
    {
        mID = value;
    }
    int getTypeID() const
    {
        return mTypeID;
    }

    void setTypeID(int value)
    {
        mTypeID = value;
    }
    QString getLine() const
    {
        return mLine;
    }

    void setLine(const QString &value)
    {
        mLine = value;
    }
    QString getTypeName() const
    {
        return mTypeName;
    }

    void setTypeName(const QString &value)
    {
        mTypeName = value;
    }
    QString getUrlLine() const
    {
        return mUrlLine;
    }


    void setUrlLine(const QString &value)
    {
        mUrlLine = value;
    }

    QString getTypeURL() const
    {
        return mTypeURL;
    }

    void setTypeURL(const QString &value)
    {
        mTypeURL = value;
    }


    LineType getLineType() const;
    void setLineType(const LineType &value);

private:
    int mID;
    int mTypeID;
    QString mLine;
    QString mTypeName;
    QString mUrlLine;
    QString mTypeURL;

    LineType lineType;
    //https://v1.chervoisin2transport.fr/images/lignes/360/     --highQ
    //https://v1.chervoisin2transport.fr/images/lignes/36/      --small
signals:
    void lineChanged();
    void urlLineChanged();
    void urlTypeChanged();
};

class Lines : public JsonDerializer
{
    Q_OBJECT
    Q_PROPERTY(QQmlListProperty<Line> linesList READ linesList NOTIFY linesListChanged)
public:
    Lines(QObject *parent = 0);
    ~Lines();
    void read(const QJsonObject &jsonObj);
    void clear();
    QQmlListProperty<Line> linesList();

    QString getOfflineData() const;
    void saveFile(QString jsonData);
    bool offlineDataIsExist() const;
    LineType getCurrentGettingLineType() const;
    void setCurrentGettingLineType(const LineType &value);

private:
    QList<Line*> mLines;
    LineType currentGettingLineType;
signals:
    void linesListChanged();

};

#endif // LINES_H
