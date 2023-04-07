sub init()
    loadComplib()
    m.video = m.top.FindNode("videoPlayer")
    m.list = m.top.FindNode("list")
    m.list.ObserveField("itemSelected", "onItemSelected")
end sub
  
sub initializeList()
    if m.progress = invalid then
      m.progress = CreateObject("roSGNode", "ProgressDialog")
      m.progress.title = "Loading..."
      m.dialog = m.progress
    end if

    m.contentReader = CreateObject("roSGNode", "CompLib:ContentReader")
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

sub loadComplib()
  componentLibrary = m.top.createChild("ComponentLibrary")
  componentLibrary.observeFieldScoped("loadStatus", "onComponentLibraryLoadStatusChange")
  'get the complib url from the manifest
  componentLibrary.uri = createObject("roAppInfo").GetValue("complib_url")
end sub

' observe the ComponentLibrary's loadStatus
sub onComponentLibraryLoadStatusChange(event as object)
  status = event.getData()
  component = event.getRoSgNode()
  print "Complib loadStatus: ", status

  'complib has started loading (but isn't ready yet)
  if status = "loading" then return

  if status = "ready" then
      'Complib has loaded and is ready to use
      initializeList()
  else
      'there was an error loading the complib
      m.dialog = createObject("roSGNode", "Dialog")
      'show a popup explaining that the complib failed to load
      m.dialog.update({
          title: "Error!",
          message: "Failed to load component library"
      })
  end if
end sub
