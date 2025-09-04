--=================================================
-- 文件名　：homeland.lua
-- 创建者　：furuilei
-- 创建时间：2010-08-25 09:54:27
-- 功能描述：爱我中华活动UI
--=================================================

local uiHomeland = Ui:GetClass("homeland")
local tbEvent = SpecialEvent.tbNationnalDay or {}

uiHomeland.BTN_CLOSE = "Btn_Close"
uiHomeland.TXT_FUDI = "Txt_Fudi"
uiHomeland.TXT_NUM_AREAS = "Txt_Num_Areas"
uiHomeland.TXT_NUM_CARDS = "Txt_Num_Cards"

uiHomeland.TB_AREAINFO = {}
for i = 1, tbEvent.COUNT_AREA do
  local szKeyName = "Txt_AreaInfo_" .. i
  uiHomeland.TB_AREAINFO[i] = szKeyName
end

--=================================================

function uiHomeland:OnOpen(tbFudi)
  self.tbFudi = tbFudi or {}
  self:Update()
end

function uiHomeland:Update()
  self:__Update_AreaInfo()
  self:__Update_Fudi()
  self:__Update_Num_Areas()
  self:__Update_Num_Cards()
end

function uiHomeland:__Update_AreaInfo()
  for nIndex = 1, tbEvent.COUNT_AREA do
    local bFlag = tbEvent:GetAchieveFlag(nIndex)
    local tbAreaInfo = tbEvent:GetAreaInfo(nIndex)
    local szShortName = ""
    if tbAreaInfo then
      if bFlag and 1 == bFlag then
        szShortName = string.format("<color=green>%s<color>", tbAreaInfo.szShortName)
      else
        szShortName = string.format("<color=gray>%s<color>", tbAreaInfo.szShortName)
      end
    end
    Txt_SetTxt(self.UIGROUP, self.TB_AREAINFO[nIndex], szShortName)
  end
end

function uiHomeland:__Update_Fudi()
  local szFudi = "今日福地："

  if not self.tbFudi or #self.tbFudi <= 0 then
    szFudi = szFudi .. "无"
  else
    local tbTemp = {}
    for _, nIndex in pairs(self.tbFudi) do
      local tbAreaInfo = tbEvent:GetAreaInfo(nIndex)
      if tbAreaInfo and tbAreaInfo.szShortName then
        table.insert(tbTemp, tbAreaInfo.szShortName)
      end
    end
    szFudi = szFudi .. string.format("<color=green>%s<color>、<color=green>%s<color>", tbTemp[1] or "", tbTemp[2] or "")
  end

  Txt_SetTxt(self.UIGROUP, self.TXT_FUDI, szFudi)
end

function uiHomeland:__Update_Num_Areas()
  local nCollectNum = tbEvent:GetCollectNum()
  local szMsg = string.format("您已收集地域：<color=green>%s/%s<color>", nCollectNum, tbEvent.COUNT_AREA)
  Txt_SetTxt(self.UIGROUP, self.TXT_NUM_AREAS, szMsg)
end

function uiHomeland:__Update_Num_Cards()
  local nCardNum = me.GetTask(tbEvent.TSK_GROUP, tbEvent.TSKID_COUNT_SUM)
  local szMsg = string.format("您已鉴定卡片：<color=green>%s/%s<color>", nCardNum, tbEvent.COUNT_SUM)
  Txt_SetTxt(self.UIGROUP, self.TXT_NUM_CARDS, szMsg)
end

--=================================================

function uiHomeland:OnClose() end

function uiHomeland:OnButtonClick(szWnd)
  if not szWnd then
    return
  end

  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  end
end

--=================================================

-- 鼠标移动到某个控件上
function uiHomeland:OnMouseEnter(szWnd)
  if not szWnd then
    return
  end

  for i = 1, tbEvent.COUNT_AREA do
    if szWnd == self.TB_AREAINFO[i] then
      self:__ShowMsg(i, szWnd)
      break
    end
  end
end

function uiHomeland:__ShowMsg(nIndex, szWnd)
  if not nIndex or not szWnd or nIndex <= 0 or nIndex > tbEvent.COUNT_AREA then
    return
  end

  local bFlag = tbEvent:GetAchieveFlag(nIndex)
  local szMsg = ""
  if bFlag and bFlag == 1 then
    szMsg = self:__GetMsg_Have(nIndex)
  else
    szMsg = self:__GetMsg_DonotHave(nIndex)
  end
  Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, "", szMsg)
end

function uiHomeland:__GetMsg_Have(nIndex)
  if not nIndex or nIndex <= 0 or nIndex > tbEvent.COUNT_AREA then
    return
  end

  local tbAreaInfo = tbEvent:GetAreaInfo(nIndex)
  local szMsg = ""
  szMsg = szMsg .. string.format("<color=yellow>%s【%s】<color>\n\n<color=green>你已经收集到该区域的信息<color>\n\n%s", tbAreaInfo.szName or "", tbAreaInfo.szShortName or "", tbAreaInfo.szDesc or "")
  return szMsg
end

function uiHomeland:__GetMsg_DonotHave(nIndex)
  if not nIndex or nIndex <= 0 or nIndex > tbEvent.COUNT_AREA then
    return
  end

  local szMsg = "<color=red>你还没有收集到该区域的信息。<color>"
  return szMsg
end
