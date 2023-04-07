Sub init()
  m.imagePoster = m.top.findNode("imagePoster")
  m.innerRect = m.top.findNode("innerRect")
  m.itemCursor = m.top.findNode("itemCursor")
  m.titleLabel = m.top.findNode("titleLabel")
  m.contentArea = m.top.findNode("contentArea")
End Sub

Sub onItemContentChange()
  MARGIN = 10
  BORDER_WIDTH = 3

  m.itemContent = m.top.itemContent
  m.titleLabel.text = m.itemContent.title
  m.imagePoster.uri = m.top.itemContent.SDPOSTERURL
  m.itemCursor.visible = true
  screenBounds = CreateObject("roDeviceInfo").GetDisplaySize()

  m.contentArea.translation = [MARGIN*2, MARGIN]
  contentBounds = m.contentArea.boundingRect() 
  m.itemCursor.width = Min(Max(contentBounds.width + (MARGIN*2), screenBounds.w * 2 / 3), screenBounds.w - (MARGIN*2))
  m.itemCursor.height = contentBounds.height
  m.itemCursor.translation = [MARGIN, MARGIN]
  m.innerRect.visible = true
  m.innerRect.width = m.itemCursor.width - (BORDER_WIDTH*2)
  m.innerRect.height = m.itemCursor.height - (BORDER_WIDTH*2)
  m.innerRect.translation = [MARGIN+BORDER_WIDTH, MARGIN+BORDER_WIDTH]
End Sub

Function Max(a As Integer, b As Integer) As Integer
  If a > b Then return a
  return b
End Function

Function Min(a As Integer, b As Integer) As Integer
  If a < b Then return a
  return b
End Function

Sub onFocusPercentChange()
  m.itemCursor.opacity = m.top.focusPercent
  m.innerRect.opacity = m.top.focusPercent
End Sub
