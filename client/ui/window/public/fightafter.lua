-- 文件名  : fightafter.lua
-- 创建者  : zounan
-- 创建时间: 2010-07-26 15:59:01
-- 描述    : 战后系统 界面
local uiFightAfter = Ui:GetClass("fightafter")
local tbFightAfter = Ui.tbLogic.tbFightAfter
local tbTimer = Ui.tbLogic.tbTimer
local tbObject = Ui.tbLogic.tbObject
local tbAwardInfo = Ui.tbLogic.tbAwardInfo
local tbTempItem = Ui.tbLogic.tbTempItem

uiFightAfter.TOTAL_EVALUATION = 10 --评价总共是10个等级
uiFightAfter.EVALUATION_YANHUA = 7 --评价前3级才有烟花 即8级以上
uiFightAfter.ANIMATION_INTERVAL = 18 * 10 --评价烟花动画;
uiFightAfter.GRADE_INTERVAL = 18 * 10 --评价字体动画;

uiFightAfter.BUTTON_CLOSE = "BtnClose"
uiFightAfter.BUTTON_AWARD = "BtnAward"
uiFightAfter.BUTTON_REFRESH = "BtnRefresh"

uiFightAfter.PAGE_GRADE = "PageGrade"
uiFightAfter.PAGE_TEAMER = "PageTeamer"
uiFightAfter.PAGE_AWARD = "PageAward"

uiFightAfter.IMG_LEFT = "ImgLeft" --左边图像
uiFightAfter.IMG_RIGHT = "ImgRight" --右边图像
uiFightAfter.IMG_GRADE = "ImgGrade" --评分

uiFightAfter.TXT_KILLNPC = "TxtKillNpc" --杀死NPC
uiFightAfter.TXT_KILLBOSS = "TxtKillBoss" --杀死BOSS
uiFightAfter.TXT_USETIME = "TxtUseTime" --通关时间
uiFightAfter.TXT_LEVEL = "TxtLevel" --关卡等级
uiFightAfter.TXT_SCORE = "TxtScore" --得分
uiFightAfter.TXT_RANDOM = "TxtRandom" --随机副本

uiFightAfter.BTN_MEMRELATION = "BtnMemberRelation"
--[[
 "TxtMemberName1"; --队伍成员
 "[TxtMemberRelation1"; --关系
 "TxxMemberRelation1"; --加为好友

"TxtMemberFavor1"; --亲密度
"TxtMemberBuffer1" --加成

--]]

uiFightAfter.nTimerId = 0
uiFightAfter.TIMER_SHOW = 2 -- 2秒刷一次？
uiFightAfter.TIMER_YANHUA = --烟花特效的播放时间
  {
    [1] = 1.5,
    [2] = 3,
    [3] = 3,
  }

uiFightAfter.GRID_COUNT = 1 -- 奖励格子 暂时只有1个

uiFightAfter.GRID_AWARD = {}
uiFightAfter.TXT_AWARDNUM = {}
for i = 1, uiFightAfter.GRID_COUNT do
  uiFightAfter.GRID_AWARD[i] = "ObjAward" .. i
  uiFightAfter.TXT_AWARDNUM[i] = "TxtAwardNum" .. i
end

-- obj name to index
uiFightAfter.OBJ_INDEX = {}
for i = 1, uiFightAfter.GRID_COUNT do
  uiFightAfter.OBJ_INDEX["ObjAward" .. i] = i
end

--先写几种简单的
uiFightAfter.RELATION_SHIP = {
  [1] = "好友", -- 单方好友
  [2] = "好友", -- 双方好友
  [3] = "帮会好友",
  [4] = "家族好友",
  [5] = "侠侣", -- 侠侣
  [6] = "黑名单", -- 黑名单
  [7] = "仇人", -- 仇人
}

--Img_SetImage(self.UIGROUP, string.format("BtnMatch%d",i),1,"left_1.spr");

-- on create
function uiFightAfter:OnCreate()
  self.tbGridCont = {}
  for i, szGrid in pairs(self.GRID_AWARD) do
    self.tbGridCont[i] = tbObject:RegisterContainer(self.UIGROUP, szGrid, 1, 1, nil, "award")
    self.tbGridCont[i].OnObjGridEnter = self.OnObjGridEnter
  end
end

-- on destroy
function uiFightAfter:OnDestroy()
  for _, tbCont in pairs(self.tbGridCont) do
    tbObject:UnregContainer(tbCont)
  end
end

--bShowAtOnce 立刻显示
function uiFightAfter:OnOpen(tbInstance, tbPlayerAward)
  self.szInstanceId = tbInstance.szInstanceId
  self.tbInstance = tbInstance
  self.tbPlayerAward = tbPlayerAward
  self.bVisiable = 1
  self.nState = 0
  self.nWeak = 0 --
  self.nYanhuaId = 0
  self.nRelationId = 0
  Wnd_Hide(self.UIGROUP, self.PAGE_AWARD)
  Wnd_Hide(self.UIGROUP, self.PAGE_TEAMER)
  self:HideScore()
  self:PlayYanhua()
  self:OnTimer_Show()
  self.nTimerId = tbTimer:Register(Env.GAME_FPS * self.TIMER_SHOW, self.OnTimer_Show, self)
  --self[szPlayerName] = "";
  --	return self[szState](self, tbNotifyMatch);
end

function uiFightAfter:PlayYanhua()
  if not self.tbInstance then
    return
  end

  local nYanhuaLevel = self.tbInstance.nGrade - self.EVALUATION_YANHUA
  if nYanhuaLevel <= 0 then
    Wnd_Hide(self.UIGROUP, self.IMG_LEFT)
    Wnd_Hide(self.UIGROUP, self.IMG_RIGHT)
  else
    Img_SetImage(self.UIGROUP, self.IMG_LEFT, 1, string.format("\\image\\effect\\other\\evaluation\\left_%d.spr", nYanhuaLevel))
    Img_SetImage(self.UIGROUP, self.IMG_RIGHT, 1, string.format("\\image\\effect\\other\\evaluation\\right_%d.spr", nYanhuaLevel))
    Img_PlayAnimation(self.UIGROUP, self.IMG_LEFT, 1, self.ANIMATION_INTERVAL)
    Img_PlayAnimation(self.UIGROUP, self.IMG_RIGHT, 1, self.ANIMATION_INTERVAL)
    self.nYanhuaId = tbTimer:Register(Env.GAME_FPS * self.TIMER_YANHUA[nYanhuaLevel], self.OnTimer_CloseYanhua, self)
  end
end

function uiFightAfter:OnClose()
  self.szInstanceId = 0
  self.tbInstance = nil
  self.tbPlayerAward = {}
  self.bVisiable = 0
  self.nState = 0
  self.nWeak = 0 --衰减
  if self.nTimerId ~= 0 then
    tbTimer:Close(self.nTimerId)
    self.nTimerId = 0
  end

  if self.nYanhuaId ~= 0 then
    tbTimer:Close(self.nYanhuaId)
    self.nYanhuaId = 0
  end

  if self.nRelationId ~= 0 then
    tbTimer:Close(self.nRelationId)
    self.nRelationId = 0
  end

  self:ClearGrid()
end

-- tips callback
function uiFightAfter:OnObjGridEnter(szWnd, nX, nY)
  local nIndex = self.OBJ_INDEX[szWnd]
  local tbObj = self.tbGridCont[nIndex]:GetObj(nX, nY)

  if not tbObj then
    return 0
  end

  local pItem = tbObj.pItem
  if not pItem then
    return 0
  end

  Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, pItem.GetCompareTip(Item.TIPS_NORMAL, tbObj.szBindType))
end

-- clear all grid obj
function uiFightAfter:ClearGrid()
  for i = 1, self.GRID_COUNT do
    local tbObj = self.tbGridCont[i]:GetObj()
    tbAwardInfo:DelAwardInfoObj(tbObj)
    self.tbGridCont[i]:SetObj(nil)
  end
end

function uiFightAfter:IsWindowVisible()
  return self.bVisiable or 0
end

function uiFightAfter:OnTimer_Show()
  if not self.tbInstance then
    return 0
  end
  self.nState = self.nState + 1
  if self.nState == 1 then
    self:ShowGrade()
    return Env.GAME_FPS * 3
  elseif self.nState == 2 then
    self:ShowTeamer()
    return Env.GAME_FPS * 3
  elseif self.nState == 3 then
    self:ShowAward()
    return 0
  end
  return 0
end

function uiFightAfter:OnTimer_CloseYanhua()
  Wnd_Hide(self.UIGROUP, self.IMG_LEFT)
  Wnd_Hide(self.UIGROUP, self.IMG_RIGHT)
  return 0
end

function uiFightAfter:OnTimer_RefreshRelation()
  if self.szInstanceId ~= 0 then
    me.CallServerScript({ "FightAfterRefresh", self.szInstanceId })
  end
  return 0
end

--第一阶段 显示玩家分数
function uiFightAfter:ShowGrade()
  if not self.tbInstance then
    return
  end

  --	Wnd_Hide(self.UIGROUP, self.IMG_LEFT);
  --	Wnd_Hide(self.UIGROUP, self.IMG_RIGHT);
  Txt_SetTxt(self.UIGROUP, self.TXT_KILLNPC, string.format("击杀敌人：<color=gold>%d<color>", self.tbInstance.nKillNpc))
  Txt_SetTxt(self.UIGROUP, self.TXT_KILLBOSS, string.format("击杀BOSS：<color=gold>%d<color>", self.tbInstance.nKillBoss))
  local nHour, nMin, nSec = Lib:TransferSecond2NormalTime(self.tbInstance.nUseTime)
  local nTotalMin = nHour * 60 + nMin
  if self.tbInstance.bComplete == 0 then
    Txt_SetTxt(self.UIGROUP, self.TXT_USETIME, "通关时间：<color=gold>--<color>")
  else
    Txt_SetTxt(self.UIGROUP, self.TXT_USETIME, string.format("通关时间：<color=gold>%d分钟<color>", nTotalMin))
  end
  Txt_SetTxt(self.UIGROUP, self.TXT_LEVEL, string.format("关卡星级：<color=gold>%d级<color>", self.tbInstance.nLevel))
  if self.tbInstance.bRandom == 1 then
    Txt_SetTxt(self.UIGROUP, self.TXT_RANDOM, "随机副本：<color=gold>是<color>")
  else
    Txt_SetTxt(self.UIGROUP, self.TXT_RANDOM, "随机副本：<color=gold>否<color>")
  end
  self:ShowScore()

  --Img_StopAnimation(self.UIGROUP, self.IMG_LEFT);
  --Img_StopAnimation(self.UIGROUP, self.IMG_RIGHT);

  --分数
  Txt_SetTxt(self.UIGROUP, self.TXT_SCORE, string.format("<color=gold>评价：%d0分<color>", self.tbInstance.nScore))
  return 1
end

--第二阶段 显示队友
function uiFightAfter:ShowTeamer()
  --	Wnd_Hide(self.UIGROUP, self.IMG_LEFT);
  --	Wnd_Hide(self.UIGROUP, self.IMG_RIGHT);
  if not self.tbInstance or not self.tbPlayerAward then
    return
  end

  Wnd_Show(self.UIGROUP, self.PAGE_TEAMER)

  for i = 1, 5 do
    Wnd_Hide(self.UIGROUP, string.format("PageSetMember%d", i))
  end

  for nIndex, tbBuffer in ipairs(self.tbPlayerAward.tbBufferList) do
    Wnd_Show(self.UIGROUP, string.format("PageSetMember%d", nIndex))
    Txt_SetTxt(self.UIGROUP, string.format("TxtMemberName%d", nIndex), self.tbInstance.tbTeamer[tbBuffer.nIndex].szName)
    if tbBuffer.nRelationType == 0 then
      Wnd_Hide(self.UIGROUP, string.format("TxtMemberRelation%d", nIndex))
      if UiVersion == Ui.Version001 then
        Wnd_Show(self.UIGROUP, string.format("TxxMemberRelation%d", nIndex))
      else
        Wnd_Show(self.UIGROUP, self.BTN_MEMRELATION .. nIndex)
      end
    else
      Wnd_Show(self.UIGROUP, string.format("TxtMemberRelation%d", nIndex))
      if UiVersion == Ui.Version001 then
        Wnd_Hide(self.UIGROUP, string.format("TxxMemberRelation%d", nIndex))
      else
        Wnd_Hide(self.UIGROUP, self.BTN_MEMRELATION .. nIndex)
      end
      Txt_SetTxt(self.UIGROUP, string.format("TxtMemberRelation%d", nIndex), self.RELATION_SHIP[tbBuffer.nRelationType])
    end

    if tbBuffer.nFavorLevel > 0 and tbBuffer.nFavorAdd > 0 then
      Txt_SetTxt(self.UIGROUP, string.format("TxtMemberFavor%d", nIndex), string.format("%d级<color=gold>(+%d)<color>", tbBuffer.nFavorLevel, tbBuffer.nFavorAdd))
    elseif tbBuffer.nFavorLevel > 0 then
      Txt_SetTxt(self.UIGROUP, string.format("TxtMemberFavor%d", nIndex), string.format("%d级", tbBuffer.nFavorLevel))
    else
      Txt_SetTxt(self.UIGROUP, string.format("TxtMemberFavor%d", nIndex), "--")
    end

    local szBuffer = "--"
    if tbBuffer.nBufferPercent ~= 0 then
      szBuffer = string.format("<color=gold>+%d%%<color>", tbBuffer.nBufferPercent)
    end
    Txt_SetTxt(self.UIGROUP, string.format("TxtMemberBuffer%d", nIndex), szBuffer)
  end
  --[[
	 "TxtMemberName1"; --队伍成员
 "[TxtMemberRelation1"; --关系
 "TxxMemberRelation1"; --加为好友

"TxtMemberFavor1"; --亲密度
"TxtMemberBuffer1" --加成
--]]
end

--第三阶段 显示奖励
function uiFightAfter:ShowAward()
  if not self.tbInstance or not self.tbPlayerAward then
    return
  end
  self:ClearGrid()
  Wnd_Show(self.UIGROUP, self.PAGE_AWARD)

  for nIndex, tbItemInfo in ipairs(self.tbPlayerAward.tbItemList) do
    local tbObj = self:CreateTempItem(tbItemInfo.tbItemId[1], tbItemInfo.tbItemId[2], tbItemInfo.tbItemId[3], tbItemInfo.tbItemId[4], 1) -- 暂时都绑定
    if tbObj then
      self.tbGridCont[nIndex]:SetObj(tbObj)
    end
    ObjGrid_ShowSubScript(self.UIGROUP, self.GRID_AWARD[nIndex], 1, 0, 0)
    ObjGrid_ChangeSubScript(self.UIGROUP, self.GRID_AWARD[nIndex], tostring(tbItemInfo.nItemCount), 0, 0)
    Wnd_Hide(self.UIGROUP, self.TXT_AWARDNUM[nIndex])
    --	Txt_SetTxt(self.UIGROUP,self.TXT_AWARDNUM[nIndex], string.format("  X %d",tbItemInfo.nItemCount));
  end
end

-- create temp item
function uiFightAfter:CreateTempItem(nGenre, nDetail, nParticular, nLevel, nBind)
  local pItem = tbTempItem:Create(nGenre, nDetail, nParticular, nLevel, -1)
  if not pItem then
    return
  end

  local tbObj = {}
  tbObj.nType = Ui.OBJ_TEMPITEM
  tbObj.pItem = pItem
  tbObj.nCount = 1

  if nBind == 1 then
    tbObj.szBindType = "获取绑定"
  end

  return tbObj
end

function uiFightAfter:HideAll() end

--收到服务器的刷新程序？
function uiFightAfter:OnAwardRefresh(szInstanceId, tbPlayerAward)
  if self:IsWindowVisible() == 0 then
    return
  end

  if self.szInstanceId ~= szInstanceId then
    return
  end

  if self.nState == 0 then
    return
  end

  self.tbPlayerAward = tbPlayerAward

  --只刷新队友关系和奖励
  self:ShowTeamer()
  if self.nState >= 3 then
    self:ShowAward()
  end
end

function uiFightAfter:OnButtonClick(szWnd, nParam)
  if szWnd == self.BUTTON_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BUTTON_AWARD then
    me.CallServerScript({ "FightAfterAward", self.szInstanceId })
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BUTTON_REFRESH then
    me.CallServerScript({ "FightAfterRefresh", self.szInstanceId })
  end
  if UiVersion == Ui.Version002 then
    for i = 1, 5 do
      local szBtn = self.BTN_MEMRELATION .. i
      if szWnd == szBtn then
        self:AddFriendByName(i)
        break
      end
    end
  end
end

--延迟处理
function uiFightAfter:OnTimer_SetText(szWnd, szText)
  if szText and string.len(szText) > 0 then
    TxtEx_SetText(self.UIGROUP, szWnd, szText)
  end
  return 0
end

function uiFightAfter:HideScore()
  Wnd_Hide(self.UIGROUP, self.TXT_KILLBOSS)
  Wnd_Hide(self.UIGROUP, self.TXT_KILLNPC)
  Wnd_Hide(self.UIGROUP, self.TXT_USETIME)
  Wnd_Hide(self.UIGROUP, self.TXT_LEVEL)
  Wnd_Hide(self.UIGROUP, self.TXT_SCORE)
  Wnd_Hide(self.UIGROUP, self.IMG_GRADE)
end

function uiFightAfter:ShowScore()
  Wnd_Show(self.UIGROUP, self.TXT_KILLBOSS)
  Wnd_Show(self.UIGROUP, self.TXT_KILLNPC)
  Wnd_Show(self.UIGROUP, self.TXT_USETIME)
  Wnd_Show(self.UIGROUP, self.TXT_LEVEL)
  Wnd_Show(self.UIGROUP, self.TXT_SCORE)

  if not self.tbInstance then
    return
  end

  Img_SetImage(self.UIGROUP, self.IMG_GRADE, 1, string.format("\\image\\effect\\other\\evaluation\\evaluation_%02d.spr", self.tbInstance.nGrade))
  Wnd_Show(self.UIGROUP, self.IMG_GRADE)
  Img_PlayAnimation(self.UIGROUP, self.IMG_GRADE, 1, self.GRADE_INTERVAL)
end

function uiFightAfter:Link_friend_OnClick(szWnd, szRecId)
  if not self.tbInstance then
    return
  end

  if not self.tbPlayerAward or not self.tbPlayerAward.tbBufferList then
    return
  end
  local nRecId = tonumber(szRecId)
  if not nRecId then
    return
  end

  local tbBuffer = self.tbPlayerAward.tbBufferList[nRecId]
  if not tbBuffer then
    return
  end

  AddFriendByName(self.tbInstance.tbTeamer[tbBuffer.nIndex].szName)
  self.nRelationId = tbTimer:Register(Env.GAME_FPS * 1, self.OnTimer_RefreshRelation, self)
end

function uiFightAfter:AddFriendByName(nRecId)
  if not self.tbInstance then
    return
  end

  if not self.tbPlayerAward or not self.tbPlayerAward.tbBufferList then
    return
  end

  local tbBuffer = self.tbPlayerAward.tbBufferList[nRecId]
  if not tbBuffer then
    return
  end

  AddFriendByName(self.tbInstance.tbTeamer[tbBuffer.nIndex].szName)
  self.nRelationId = tbTimer:Register(Env.GAME_FPS * 1, self.OnTimer_RefreshRelation, self)
end
--[[
function uiFightAfter:RegisterEvent()
	local tbRegEvent = 
	{
	--	{ UiNotify.emCOREEVENT_UPDATEONLINEEXPSTATE,				self.OnRefreshOnlineState	},	
	--	emCOREEVENT_DELETE_RELATION
	--  emCOREEVENT_SYNC_RELATION_INFO
	--    emCONFIRMATION_RELATION_TMPFRIEND			= 50,       // 收到好友申请
    --    emCONFIRMATION_RELATION_BLACKLIST			= 51,       // 收到被加入黑名单的消息
    --  emCONFIRMATION_RELATION_BINDFRIEND
	};
	return tbRegEvent;
end

--延迟处理
function uiFightAfter:OnTimer_SetText(szWnd, szText)
	if szText and string.len(szText) > 0 then
		TxtEx_SetText(self.UIGROUP, szWnd, szText);
	end
	return 0;
end

--]]
