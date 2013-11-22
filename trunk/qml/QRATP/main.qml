import QtQuick 1.1
import com.nokia.meego 1.0

PageStackWindow {
    id: appWindow

    initialPage: mainPage
//    initialPage: home

    MainPage {
        id: mainPage
    }
    AddItineraire{

    }

    QueryDialog {
        id: aboutDialog
        titleText: "Application Title"
        message: "(C) [year] [your name]\n[version]"
    }
}
