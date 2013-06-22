import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import QtQuick.XmlListModel 2.0
/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"
    // Note! applicationName needs to match the .desktop filename
    applicationName: "uReadIt"
    id: window

    /* 
     This property enables the application to change orientation 
     when the device is rotated. The default is false.
    */
    automaticOrientation: true
    
    width: units.gu(50)
    height: units.gu(75)

    PageStack {
        id: pageStack
        anchors.fill: parent
        Component.onCompleted: pageStack.push(newslist)

        Page {
            id: newslist
            anchors.fill: parent
            title: "RTÉ News"

            Row {
                id: subredditControls
                spacing: units.gu(1)


            }

            XmlListModel {
                id: rteFeed
                source: "http://www.rte.ie/news/rss/news-headlines.xml"
                query: "/rss/channel/item"

                XmlRole { name: "title"; query: "title/string()" }
                XmlRole { name: "link"; query: "link/string()" }
                XmlRole { name: "description"; query: "description/string()" }
            }

            ListView {
                id: articleList
                anchors.top: subredditControls.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right


                model: rteFeed
                delegate: ListItem.Subtitled {
                    text:title
                    subText: description
                    progression:true
                    onClicked: {
                        articleView.title = title
                        articleContent.text = description
                        articleContent.visible = true
                        pageStack.push(articleView)
                    }
                }
            }

           }
        Page {
            id: articleView
            title: 'Article'
            Row {
                id:buttonbar
                Button {
                    id: backbutton
                    text: 'back'
                    onClicked: {
                        pageStack.push(articleList)
                    }
                }
            }

            Row {
                anchors.top: buttonbar.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                TextArea {
                    anchors.fill: parent
                    id: 'articleContent'
                    text: "Hello, world!"
                }
            }

        }
    }
}
