import QtQuick 2.0
import Sailfish.Silica 1.0
import "../delegate"


Item{
    id: main
    property ListModel listModel
    property bool whoIAm //False = Aller | true = retour

    SilicaListView {
        id: listView
//        model: listModel
        anchors.fill: parent
        header: PageHeader {
            title: pageTitle
        }
        model: ListModel{
            ListElement{
                line: "Test"
            }
            ListElement{
                line: "Test"
            }
            ListElement{
                line: "Test"
            }
            ListElement{
                line: "Test"
            }
            ListElement{
                line: "Test"
            }
            ListElement{
                line: "Test"
            }
        }

        delegate:MainDelegate{

        }
        PullDownMenu {
            id: pullDownMenu
            MenuItem {
                text: "Add Itin"
                onClicked: {
                    var ret = pageStack.push(Qt.resolvedUrl("../SecondPage.qml"), {whereFrom : whoIAm});
                    ret.accepted.connect(function(){
                        console.debug("User accepted : " + dataRequest.scheduleList.length)
                        dataRequest.addItineraire(dataRequest.scheduleList);
                    })
                    ret.rejected.connect(function(){
                        console.debug("User refected : " + dataRequest.scheduleList.length)
                    })
                }
            }
        }
        VerticalScrollDecorator {}
    }
}


