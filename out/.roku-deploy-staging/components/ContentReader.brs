Sub init()
    m.top.functionName = "fetch"
End Sub
  
Sub fetch()
    listContent = createObject("roSGNode", "ContentNode")
    request = createObject("roUrlTransfer")
    request.setCertificatesFile("common:/certs/ca-bundle.crt")
    request.initClientCertificates()
    request.setUrl("https://www.youtube.com/feeds/videos.xml?playlist_id=PLPXlJ6AsahlQ69SEjCuMvo9vTF1LOw8H1")
    xml = request.getToString() 
    response = CreateObject("roXMLElement")
    if not response.Parse(xml) then stop

    listItems = []
    For Each entry In response.entry
        itemContent = {
            TITLE: entry.title.GetText(),
            URL: "pkg:/videos/"+entry.GetNamedElements("yt:videoId").GetText()+".mp4",
            SDPOSTERURL: entry.GetNamedElements("media:group").GetNamedElements("media:thumbnail")@url,
            STREAMFORMAT: "mp4"
        }
        listItems.Push(itemContent)
    End For

    listContent.Update(listItems, true)
    m.top.content = listContent
End Sub