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
