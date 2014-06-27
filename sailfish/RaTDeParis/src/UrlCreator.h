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
#ifndef URLCREATOR_H
#define URLCREATOR_H
#include <QUrl>
namespace url {
inline const QUrl getLines()
{
    return QUrl("http://metro.breizh.im/dev/ratp_api.php?action=getLineList");
}
inline const QUrl getDirections(const int &line)
{
    return QUrl(QString("http://metro.breizh.im/dev/ratp_api.php?action=getDirectionList&line=%1").arg(line));
}
inline const QUrl getStations(const int &line, const int &direction)
{
    return QUrl(QString("http://metro.breizh.im/dev/ratp_api.php?action=getStationList&line=%1&direction=%2").arg(line).arg(direction));
}
inline const QUrl getSchedules(const int &line, const int &direction, const int &station)
{
    return QUrl(QString("http://metro.breizh.im/dev/ratp_api.php?action=getSchedule&line=%1&direction=%2&station=%3")
                .arg(line)
                .arg(direction)
                .arg(station));
}
}


#endif // URLCREATOR_H
