#include <QApplication>
#include <QDeclarativeEngine>
#include <QDeclarativeContext>
#include "qmlapplicationviewer.h"
#include <QDebug>

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    QmlApplicationViewer viewer;

    qDebug() << viewer.engine()->offlineStoragePath();

    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/QRATP/main.qml"));
    viewer.showExpanded();

    return app->exec();
}
