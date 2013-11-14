#ifndef DOWNLOADATA_H
#define DOWNLOADATA_H

#include <QObject>
#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkReply>
#include <QtNetwork/QNetworkRequest>
#include <QStringList>

class DownloadData : public QObject
{
    Q_OBJECT

private:
    //QString recu_data;
    QString str_coupe;  //On a afiné le resultat, Tous est la !!!
    QString str_image_final;
    QString str_nom_arret;
    QString str_heur_actuel;
    QString str_direction;
    QString str_temps1;
    QString str_temps2;
public:
    explicit DownloadData(QObject *parent = 0);

    void declaration(int choix);
    QString list_to_str(QStringList list_a_convert);

   Q_INVOKABLE void heur_direction(QString data);
    void nom_arret(QString str_bus);
    Q_INVOKABLE void bus(QString data_qml);
    Q_INVOKABLE void check_url(QString qml_url);

    QString resultcoupe;        //Resultat du coupage

    Q_INVOKABLE QVariant getstr_heur(){return str_heur_actuel;}
    Q_INVOKABLE QVariant getstr_nom_arret(){return str_nom_arret;}
    Q_INVOKABLE QVariant getstr_temps1(){return str_temps1;}
    Q_INVOKABLE QVariant getstr_temps2(){return str_temps2;}
    Q_INVOKABLE QVariant getarret(){return str_nom_arret;}
    Q_INVOKABLE QVariant getimagelink(){return str_image_final;}
    Q_INVOKABLE QVariant getdirection(){return str_direction;}
    Q_INVOKABLE void setNomArret(QString htmlData);
    
signals:
    void dataTraiter();
};

#endif // DOWNLOAD_DATA_H
