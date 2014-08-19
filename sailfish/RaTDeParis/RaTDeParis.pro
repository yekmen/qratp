# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = RaTDeParis

CONFIG += sailfishapp
QT += widgets

VERSION = 0.3
DEFINES += APPLICATION_VERSION=\"\\\"$$VERSION\\\"\"

SOURCES += src/RaTDeParis.cpp \
    src/stations.cpp \
    src/lines.cpp \
    src/directions.cpp \
    src/datarequest.cpp \
    src/schedule2.cpp \
    src/offlinedata.cpp

OTHER_FILES += qml/RaTDeParis.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    qml/pages/SecondPage.qml \
    rpm/RaTDeParis.spec \
    rpm/RaTDeParis.yaml \
    RaTDeParis.desktop \
    qml/pages/tools/SelectedItem.qml \
    qml/pages/tools/Choose.qml \
    qml/pages/tools/search.js \
    qml/pages/tools/PageItem.qml \
    qml/js/Offline.js \
    qml/pages/tools/SideBar.qml \
    qml/js/TabDataBase.js \
    qml/pages/tools/ItNameInputDialog.qml \
    qml/js/RequestID.js \
    qml/pages/delegate/MainDelegateItem.qml \
    qml/pages/AboutPage.qml

HEADERS += \
    src/UrlCreator.h \
    src/stations.h \
    src/lines.h \
    src/jsonderializer.h \
    src/directions.h \
    src/datarequest.h \
    src/schedule2.h \
    src/offlinedata.h

RESOURCES += \
    resource.qrc

