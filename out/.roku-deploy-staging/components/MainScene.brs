sub init()
    m.video = m.top.FindNode("videoPlayer")
    m.list = m.top.FindNode("list")
    m.list.ObserveField("itemSelected", "onItemSelected")
    initializeList()
end sub
  
sub initializeList()
    if m.progress = invalid then
      m.progress = CreateObject("roSGNode", "ProgressDialog")
      m.progress.title = "Loading..."
      m.dialog = m.progress
    end if

    m.contentReader = CreateObject("roSGNode", "ContentReader")
    m.contentReader.ObserveField("content", "onContentChanged")
    m.contentReader.control = "RUN"
end sub

sub onContentChanged(event as object)
  content = event.GetData()
  m.list.content = content
  m.list.SetFocus(true)

  if m.progress <> invalid then
    m.progress.close = true
    m.progress = invalid
  end if
end sub

sub onItemSelected(event as object)
    videocontent = event.getRoSGNode().content.getChild(event.getData())
    m.video.content = videocontent
    m.video.visible = true
    m.video.setFocus(true)
    m.video.control = "play"
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    handled = false

    if press And key = "back" And m.video.HasFocus() Then
        m.video.control = "stop"
        m.video.visible = false
        m.video.SetFocus(false)
        m.list.SetFocus(true)
        handled = true
    End If

    return handled
  end function
