-----------------------------------------------------
--文件名		：	saypanel.lua
--创建者		：	wuwei1
--创建时间	：	2007-02-06
--功能描述	：	对话面板。
--修改备注   : 增加了对话框面板的list的标签解析，by zhangjunjie 2010/12/6
------------------------------------------------------

local uiSayPanel = Ui:GetClass("saypanel")

local IMG_HEAD_PIC = "ImgHeadPic"
local IMG_CONTENT_PIC = "ImgContentPic"
local WND_SAY = "WndSay" -- 主信息面板
local WND_SEL = "WndSel" -- 选项面板
local TXT_DIALOG = "TxtDialog"
local TXT_DIALOG2 = "TxtDialog2"
local LST_SELECT_ARRAY = "LstSelectArray"
local BTN_CLOSE = "BtnClose"

local LEFT = 10
local CLICK_FRAME = { 0, 2, 1, 2 } -- spr动作帧依次是Up, UpOver, Down, DownOver
local SELECT_IMAGE = "\\image\\ui\\001a\\dialog\\say_choose.spr"

local tbTempItem = Ui.tbLogic.tbTempItem --临时道具，用于显示tip

local tbTipInfo = {} --选项对应的tips table
uiSayPanel.tbNowInfo = {} --上次当前对话列表
uiSayPanel.tbPosList = {}

function uiSayPanel:OnListOver(szWnd, nParam)
  self:ShowTip(szWnd, nParam)
end

function uiSayPanel:OnOpen(tbParam)
  if UiManager:WindowVisible(Ui.UI_GUTMODEL) == 1 then
    BlackSky:EndDark()
  end
  tbTipInfo = {}
  local szHead, szPic, szContent = self:ParseQuestion(tbParam[1])
  Img_SetImage(self.UIGROUP, IMG_HEAD_PIC, 1, szHead)
  Img_SetImage(self.UIGROUP, IMG_CONTENT_PIC, 1, szPic)

  local nImgHeight = 0
  if #szPic > 0 then
    local _, n = Wnd_GetSize(self.UIGROUP, IMG_CONTENT_PIC)
    nImgHeight = n
  end
  local nTemp, nTxtHeight = 0, 0
  local nPos, nEnd = string.find(szContent, "<newdialog>")
  if nPos and nPos == 1 then
    szContent = string.sub(szContent, nEnd + 1)
    TxtEx_SetText(self.UIGROUP, TXT_DIALOG2, szContent)
    nTemp, nTxtHeight = Wnd_GetSize(self.UIGROUP, TXT_DIALOG2)
  else
    Txt_SetTxt(self.UIGROUP, TXT_DIALOG, szContent)
    nTemp, nTxtHeight = Wnd_GetSize(self.UIGROUP, TXT_DIALOG)
  end
  nTxtHeight = nTxtHeight + 30
  if nTxtHeight < 60 then
    nTxtHeight = 60
  end

  Wnd_SetPos(self.UIGROUP, TXT_DIALOG, LEFT, nImgHeight + 5)
  Wnd_SetPos(self.UIGROUP, LST_SELECT_ARRAY, LEFT, nTxtHeight + nImgHeight + 5)

  local nYOffset = 0
  local bAutoTutorial = 0
  for i = 1, #tbParam[2] do
    local szTemp, tbTemp = self:GetListContent(tbParam[2][i])
    if Tutorial.tbDialogAuto[szTemp] and i <= 10 and bAutoTutorial == 0 then
      Tutorial:AutoDialogTutorial(szTemp)
      bAutoTutorial = 1
    end
    table.insert(tbTipInfo, tbTemp)
    Lst_SetCell(self.UIGROUP, LST_SELECT_ARRAY, i, 2, szTemp)
    Lst_SetImageCell(self.UIGROUP, LST_SELECT_ARRAY, i, 0, SELECT_IMAGE, unpack(CLICK_FRAME))
  end
  self.tbNowInfo = tbParam
  self.tbPosList = { LEFT, nTxtHeight + nImgHeight + 5 }
  ScrPnl_Update(self.UIGROUP, WND_SAY)
end

function uiSayPanel:OnButtonClick(szWnd, nParam)
  if szWnd == BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  end
end

--响应鼠标点击事件
function uiSayPanel:OnListSel(szWnd, nParam)
  if nParam == 0 then
    return 0
  end
  if szWnd == LST_SELECT_ARRAY then
    me.AnswerQestion(nParam - 1)
    Tutorial:DialogClick(nParam)
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiSayPanel:OnEscExclusiveWnd(szWnd)
  UiManager:CloseWindow(self.UIGROUP)
end

function uiSayPanel:ParseQuestion(szQuestion)
  local _, i, szHeadImg = string.find(szQuestion, "<head:([^>]*)>")
  local _, j, szPic = string.find(szQuestion, "<pic:([^>]*)>")

  if not i then
    i = 0
  end
  if not j then
    j = 0
  end

  local nOffset = math.max(i, j) + 1
  local szQues = string.sub(szQuestion, nOffset, -1)

  if not szHeadImg then
    szHeadImg = ""
  end

  if not szPic then
    szPic = ""
  end

  if not szQues then
    szQues = ""
  end

  return szHeadImg, szPic, szQues
end

function uiSayPanel:GetListContent(szOpt)
  local szTemp = ""
  local szTips = ""
  local tbTemp = {}
  local nItemBegin, nItemEnd = string.find(szOpt, "<item=([^>]*)>")
  local nTipBegin, nTipEnd = string.find(szOpt, "<tip=([^>]*)>")
  if not nItemBegin and not nTipBegin then
    szTemp = szOpt
  else
    szTemp = string.sub(szOpt, 1, math.min(nItemBegin or #szOpt, nTipBegin or #szOpt) - 1)
    szTips = string.sub(szOpt, math.min(nItemBegin or #szOpt, nTipBegin or #szOpt), math.min(nItemEnd or #szOpt, nTipEnd or #szOpt))
    tbTemp = self:GetTipParam(szTips)
  end
  return szTemp, tbTemp
end

function uiSayPanel:GetTipParam(szTip)
  local tbTemp = {}
  local szTemp = ""
  local nItemBegin, nItemEnd = string.find(szTip, "<item=")
  local nTipBegin, nTipEnd = string.find(szTip, "<tip=")
  szTemp = string.sub(szTip, (nItemEnd or nTipEnd) + 1, #szTip - 1)
  if string.len(szTemp) == 0 then
    return tbTemp
  end
  if nItemBegin then
    tbTemp = Lib:SplitStr(szTemp, ",")
    for i, v in ipairs(tbTemp) do
      tbTemp[i] = tonumber(v)
    end
    tbTemp.IsItemTip = 1
  elseif nTipBegin then
    table.insert(tbTemp, szTemp)
    tbTemp.IsItemTip = 0
  end
  return tbTemp
end

--显示list对应的tip
function uiSayPanel:ShowTip(szWnd, nParam)
  local nLength = Lib:CountTB(tbTipInfo)
  local pItem = nil
  if nLength == 0 then
    return
  end
  if tbTipInfo[nParam] then
    if tbTipInfo[nParam].IsItemTip == 1 then
      pItem = tbTempItem:Create(tbTipInfo[nParam][1], tbTipInfo[nParam][2], tbTipInfo[nParam][3], tbTipInfo[nParam][4])
      if not pItem then
        return
      end
      local nWidth, nHeight = Wnd_GetSize(self.UIGROUP)
      local nX, nY = Wnd_GetPos(self.UIGROUP)
      local szTitle, szTip, szViewImage = pItem.GetTip(Item.TIPS_PREVIEW)
      Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, szTitle, szTip, szViewImage, "", "", "", nX + nWidth, nY, 1)
      tbTempItem:Destroy(pItem)
    elseif tbTipInfo[nParam].IsItemTip == 0 then
      Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, "", tbTipInfo[nParam][1])
    else
      Wnd_HideMouseHoverInfo()
    end
  end
end
