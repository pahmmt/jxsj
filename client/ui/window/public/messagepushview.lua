-----------------------------------------------------
-- 文件名		: messagepushview.lua
-- 创建者　		: huangxiaoming
-- 创建时间		：2012/11/2 9:25
-- 功能描述		: 消息推送
-----------------------------------------------------

local uiMessagePushView = Ui:GetClass("messagepushview")
local tbNewCalendar = Ui.tbLogic.tbNewCalendar
local tbMessagePush = Ui.tbLogic.tbMessagePush

uiMessagePushView.MAX_VIEW_COUNT = tbMessagePush.MAX_VIEW_COUNT -- 最多显示的个数
uiMessagePushView.IMAGE_MESSAGE = "ImgMessage"
uiMessagePushView.IMAGE_EFFECT = "ImgMessageEffect"

uiMessagePushView.FLICKER_TIME = 20 -- 闪动20秒
uiMessagePushView.FLICKER_SPRPATH = "\\image\\icon\\other\\autoskill.spr"
uiMessagePushView.BACKGROUND_SPRPATH = "\\image\\icon\\other\\kuang.spr"

--------------按钮响应事件--------------------------
uiMessagePushView.tbClickEventList = {
  ["OpenWindow"] = "OnEventOpenWindow", -- 打开指定窗口,参数1：窗口名字
  ["OpenCalendar"] = "OnEventOpenCalendar", -- 打开活动日历，参数1：活动ID
  ["ClientAutoPath"] = "OnEventClientAutoPath", -- 客户端寻路
  ["ServerAutoPath"] = "OnEventServerAutoPath", -- 无线传送符寻路
  ["UseItem"] = "OnEventUseItem", -- 使用道具
  ["CallServerScript"] = "OnEventCallServerScript", -- 调用服务端脚本
}
------------------------------------------------------

function uiMessagePushView:Init()
  self.tbCurMessageList = {} -- 当前列表
  self.tbPreMessageList = {} -- 上一次的列表
  self.tbFlickerTime = {} -- 闪动开始时间nId - time
end

function uiMessagePushView:OnOpen()
  local tbMessageList = tbMessagePush:GetPushMessageList()
  self:Update(tbMessageList)
  if self.nTimerId then
    Timer:Close(self.nTimerId)
  end
  self.nTimerId = Timer:Register(18, self.Timer_Update, self)
end

function uiMessagePushView:OnClose()
  if self.nTimerId then
    Timer:Close(self.nTimerId)
    self.nTimerId = nil
  end
end

function uiMessagePushView:Timer_Update()
  local tbMessageList = tbMessagePush:GetPushMessageList()
  self:Update(tbMessageList)
  return 18
end

function uiMessagePushView:Update(tbMessageList)
  self.tbPreMessageList = self.tbCurMessageList
  self.tbCurMessageList = {}
  for i = 1, self.MAX_VIEW_COUNT do
    if not tbMessageList[i] then
      break
    end
    self.tbCurMessageList[i] = tbMessageList[i]
  end
  local tbNewMsgIndex = self:GetNewMessageIndex()
  self:UpdateUi(tbNewMsgIndex)
end

function uiMessagePushView:UpdateUi(tbNewMsgIndex)
  tbNewMsgIndex = tbNewMsgIndex or {}
  -- 更新一下UI
  for i = 1, self.MAX_VIEW_COUNT do
    local szImgMessage = self.IMAGE_MESSAGE .. i
    if self.tbCurMessageList[i] then
      if not self.tbPreMessageList[i] or self.tbCurMessageList[i].nId ~= self.tbPreMessageList[i].nId then
        Wnd_Show(self.UIGROUP, szImgMessage)
        Img_SetImage(self.UIGROUP, szImgMessage, 1, self.tbCurMessageList[i].szImagePath)
      end
    else
      if self.tbPreMessageList[i] then
        Wnd_Hide(self.UIGROUP, szImgMessage)
      end
    end
  end
  if tbNewMsgIndex and #tbNewMsgIndex > 0 then
    local nTime = GetTime()
    for _, nIndex in ipairs(tbNewMsgIndex) do
      self.tbFlickerTime[self.tbCurMessageList[nIndex].nId] = {}
      self.tbFlickerTime[self.tbCurMessageList[nIndex].nId].nStarted = 0
      self.tbFlickerTime[self.tbCurMessageList[nIndex].nId].nTime = nTime
    end
  end
  for nIndex, tbMessage in ipairs(self.tbCurMessageList) do
    local szImgEffect = self.IMAGE_EFFECT .. nIndex
    if self.tbFlickerTime[tbMessage.nId] then
      if self.tbFlickerTime[tbMessage.nId].nStarted == 0 then
        self.tbFlickerTime[tbMessage.nId].nStarted = 1
        Wnd_Show(self.UIGROUP, szImgEffect)
        Img_SetImage(self.UIGROUP, szImgEffect, 1, self.FLICKER_SPRPATH)
        Img_PlayAnimation(self.UIGROUP, szImgEffect, 1, 100)
      else
        if GetTime() - self.tbFlickerTime[tbMessage.nId].nTime > self.FLICKER_TIME then
          self.tbFlickerTime[tbMessage.nId] = nil
          Img_PlayAnimation(self.UIGROUP, szImgEffect, 0)
          Img_SetImage(self.UIGROUP, szImgEffect, 1, self.BACKGROUND_SPRPATH)
        else
          Wnd_Show(self.UIGROUP, szImgEffect)
          Img_SetImage(self.UIGROUP, szImgEffect, 1, self.FLICKER_SPRPATH)
          Img_PlayAnimation(self.UIGROUP, szImgEffect, 1, 100)
        end
      end
    else
      Img_SetImage(self.UIGROUP, szImgEffect, 1, self.BACKGROUND_SPRPATH)
    end
  end
end

-- 检查是否新提醒进来，返回新提醒所在的格子
function uiMessagePushView:GetNewMessageIndex()
  local tbDiff = {}
  for i, tbCurMessage in ipairs(self.tbCurMessageList) do
    if (not self.tbPreMessageList[i]) or (self.tbPreMessageList[i].nId ~= tbCurMessage.nId) then
      local nExsit = 0
      for _, tbTemp in pairs(self.tbPreMessageList) do
        if tbTemp.nId == tbCurMessage.nId then
          nExsit = 1
          break
        end
      end
      if nExsit == 0 then
        tbDiff[#tbDiff + 1] = i
      end
    end
  end
  return tbDiff
end

function uiMessagePushView:OnMouseEnter(szWnd)
  local szTip = ""
  for i = 1, self.MAX_VIEW_COUNT do
    if self.tbCurMessageList[i] and (szWnd == self.IMAGE_MESSAGE .. i or szWnd == self.IMAGE_EFFECT .. i) then
      szTip = self.tbCurMessageList[i].szTip
      break
    end
  end
  if szTip and szTip ~= "" then
    Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, "", szTip)
  end
end

function uiMessagePushView:OnButtonClick(szWnd, nParam)
  for i = 0, self.MAX_VIEW_COUNT do
    if self.tbCurMessageList[i] and (szWnd == self.IMAGE_MESSAGE .. i or szWnd == self.IMAGE_EFFECT .. i) then
      local nClickRet = 1
      if self.tbCurMessageList[i].szClickEvent then
        local szFuncName = self.tbClickEventList[self.tbCurMessageList[i].szClickEvent]
        if szFuncName then
          nClickRet = self[szFuncName](self, self.tbCurMessageList[i].tbClickParam)
        end
      end
      if self.tbCurMessageList[i].nClickDisappear == 1 and nClickRet == 1 then -- 点击消失
        if self.tbCurMessageList[i].nTaskType > 0 then
          tbMessagePush:AchieveTask(self.tbCurMessageList[i].nTaskType, self.tbCurMessageList[i].nTaskIndex)
        end
        self.tbPreMessageList = self.tbCurMessageList
        self.tbFlickerTime[self.tbPreMessageList[i].nId] = nil
        self.tbCurMessageList = {}
        for j = 1, #self.tbPreMessageList do
          if j ~= i then
            table.insert(self.tbCurMessageList, self.tbPreMessageList[j])
          end
        end
        self:UpdateUi()
      end
      break
    end
  end
end

-- 点击参加按钮函数响应
-- 打开指定窗口
function uiMessagePushView:OnEventOpenWindow(tbParam)
  UiManager:OpenWindow(tbParam[1])
  return 1
end

-- 点击参加按钮函数响应
-- 打开指定窗口
function uiMessagePushView:OnEventOpenCalendar(tbParam)
  UiManager:OpenWindow(Ui.UI_NEWCALENDARVIEW)
  Ui(Ui.UI_NEWCALENDARVIEW):UpdataSelectMatchStates(tonumber(tbParam[1]))
  return 1
end

-- 客户端显示寻路
function uiMessagePushView:OnEventClientAutoPath(tbParam)
  local tbPathInfo = {}
  local tbOpt = {}
  for i = 1, #tbParam do
    local szParam = tbParam[i]
    local nSit = string.find(szParam, ":")
    if nSit and nSit > 0 then
      local szDesc = string.sub(szParam, 1, nSit - 1)
      local szContent = string.sub(szParam, nSit + 1, string.len(szParam))
      local tbPos = Lib:SplitStr(szContent)
      table.insert(tbOpt, { szDesc, Ui.tbLogic.tbAutoPath.ProcessClick, Ui.tbLogic.tbAutoPath, { nMapId = tonumber(tbPos[1]), nX = tonumber(tbPos[2]), nY = tonumber(tbPos[3]) } })
    end
  end
  table.insert(tbOpt, "我再考虑一下")
  Dialog:Say("请选择你要去的地点：", tbOpt)
  return 1
end

-- 打开服务端传寻路
function uiMessagePushView:OnEventServerAutoPath(tbParam)
  me.CallServerScript({ "PlayerCmd", "GoFubenEnter", tonumber(tbParam[1]), tonumber(tbParam[2]) })
  return 1
end

-- 客户端使用道具
function uiMessagePushView:OnEventUseItem(tbParam)
  local tbFind = me.FindItemInBags(tonumber(tbParam[1]), tonumber(tbParam[2]), tonumber(tbParam[3]), tonumber(tbParam[4]))
  if #tbFind <= 0 then
    Dialog:Say(string.format("你的背包里没有%s。", KItem.GetNameById(tonumber(tbParam[1]), tonumber(tbParam[2]), tonumber(tbParam[3]), tonumber(tbParam[4]))))
    return 0
  end
  return me.UseItem(tbFind[1].nRoom, tbFind[1].nX, tbFind[1].nY)
end

-- 调用服务端脚本
function uiMessagePushView:OnEventCallServerScript(tbParam)
  return me.CallServerScript({ "PlayerCmd", "ApplyMessagePushMsg", tbParam[1], tbParam[2], tbParam[3], tbParam[4] })
end
