#include "download_data.h"
#include <QDebug>
DownloadData::DownloadData(QObject *parent) :
    QObject(parent)
{

}
QString DownloadData::list_to_str(QStringList list_a_convert)
{
    QString str_retour;
    for(int i = 0;i<list_a_convert.size();i++)
    {
        str_retour = list_a_convert[i];
    }
    return str_retour;
}
void DownloadData::nom_arret(QString str_bus)
{
//    requete(QString("http://wap.ratp.fr/siv/schedule?service=next&reseau=bus&lineid=B76&referer=station&stationname=*").arg(str_bus));
}
void DownloadData::bus(QString data_qml)
{
//    count("stationid="); Nombre d'occurance !
    QStringList coupelist = data_qml.split("<body>",QString::SkipEmptyParts);
    QString str_premier_coupe;
    QString toto;
    int inc = 573;
    str_premier_coupe = list_to_str(coupelist);
//    qDebug() << str_premier_coupe.section();

    for(int i = 0; i<str_premier_coupe.size();i++){
        qDebug() << "Ah ! ====== " << str_premier_coupe.section("stationid=",1,1);
        qDebug() << "Ah ! ====== " << str_premier_coupe.indexOf("stationid=",1);
//        inc = 573 + i;
//        qDebug() << "1er occurance = " << str_premier_coupe.at(inc);
//        toto = str_premier_coupe.at(inc);

        if(toto.operator ==("station=")){
            qDebug() << "dans le if" << i;

        }
        else{
           // qDebug() << "pas de =";
        }
    }
}
void DownloadData::check_url(QString qml_url)
{
    qDebug() << qml_url;
//    if(qml_url.operator ==())
}

void DownloadData::heur_direction(QString data)
{
    QStringList coupelist = data.split("<body>",QString::SkipEmptyParts);
    QStringList image_final_list;
    //*****************************************//
    resultcoupe = list_to_str(coupelist);
    QStringList imageBus_list  = resultcoupe.split("class='float'",QString::SkipEmptyParts);
    str_coupe = list_to_str(imageBus_list);
    str_image_final = str_coupe.section("<",9,9);
    image_final_list = str_image_final.split("src=",QString::SkipEmptyParts);
    str_image_final = list_to_str(image_final_list).remove("/>").remove(234).remove("Arrt").remove(0,1).remove(QChar('"')).remove(">").trimmed();
    //234 = ê

    /*-------------------------ON a l'image ------------------*/
    str_nom_arret = str_coupe.section("<",10,11).remove("b class=").remove("</b>").remove("bwhite").remove(">").remove(QChar('"'));
    /*---------------------- On a le nom de l'arret ----------*/

    str_heur_actuel = str_coupe.section("<",15,15).remove("div class=").remove(QChar('"')).remove(">").remove("bg2");
    /*---------------------- On a l'heur actuel --------------*/

    str_direction = str_coupe.section("<",20,21).remove("b class=").remove("</b>").remove("bwhite").remove(">").remove(QChar('"'));
    /*----------------------- On a la direction --------------*/

    //------------------------- 1er temps d'arriver ---------------------//
    str_temps1 = str_coupe.section("<",26,27).remove("</b>").remove("b>");
    /*--------------------------2eme temps d'arriere -------------------*/
    str_temps2 = str_coupe.section("<",32,33).remove("</b>").remove("b>");

//    qDebug() << "Arret = " << str_nom_arret;
//    qDebug() << "Heur = " << str_heur_actuel;
//    qDebug() << "Direction = "<< str_direction;
//    qDebug() << "Prochaine bus = " << str_temps1 << "&" << str_temps2;
//    qDebug() << str_image_final;
    emit dataTraiter();

}

void DownloadData::setNomArret(QString htmlData)
{
    QStringList coupelist = htmlData.split("<body>",QString::SkipEmptyParts);
    QString str_contenu;
    str_contenu = list_to_str(coupelist);
    //    qDebug() << " -----------------------------------------------"<<str_contenu.split("<div class=\"bg1\">",QString::SkipEmptyParts);

    QString coupage;
    QString::SectionFlag flag = QString::SectionSkipEmpty;

    QStringList parcours;                //Ou se trouve les lieu
    QStringList coupelist2;


    QString resultcoupe;                   //Resultat du coupage
    QString resultcoupe2;                 //Resulat du Dernier coupage

    parcours << "<div class=";
    //**********  On fait un 1er coupage *******//
    coupelist = htmlData.split("<div class=");

//    qDebug() << coupelist;
    qDebug() <<"Nb occurrence = " <<list_to_str(coupelist).count("class=");
//    //*****************************************//
//    for(int i = 0;i<coupelist.size();i++)
//    {
//        resultcoupe = coupelist[i];     //Tous se trouve dans Resulcoupe
//    }

//    for(int i = 0;i<parcours.size();i++)
//    {
//        coupage = parcours[i];
//        //*** On doit mettre le lieu dans le split ***//
//        coupelist2 = resultcoupe.split(coupage,QString::SkipEmptyParts);
//        /**************************************/
//        for(int y=0;y<coupelist2.size();y++)
//        {
//            resultcoupe2 = coupelist2[y];
//            qDebug() << resultcoupe2;


//        }

//    }




}
