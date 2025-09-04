-----------------------------------------------------
--文件名		：	sns_follow.lua
--创建者		：	wangzhiguang
--创建时间		：	2011-03-18
--功能描述		：	推荐收听人面板
------------------------------------------------------

local uiSnsFollow = Ui:GetClass("sns_follow")

local TXT_DESC = "TxtDesc"
local BUTTON_CLOSE = "BtnClose"
local BUTTON_OK = "BtnOK"
local BUTTON_CANCEL = "BtnCancel"
local BUTTON_JXSJ = "BtnJXSJ"

local MSG_DESC = "你的好友也使用了<color=yellow>%s<color>，你可以收听他们："

local tbBtnFriends = {
  "BtnFriend1",
  "BtnFriend2",
  "BtnFriend3",
  "BtnFriend4",
  "BtnFriend5",
  "BtnFriend6",
  "BtnFriend7",
  "BtnFriend8",
  "BtnFriend9",
  "BtnFriend10",
}

local tbBtnGroups = {
  "BtnGroup1",
  "BtnGroup2",
  "BtnGroup3",
  "BtnGroup4",
  "BtnGroup5",
  "BtnGroup6",
}

function uiSnsFollow:OnOpen(nSnsId)
  local tbSns = Sns:GetSnsObject(nSnsId)
  self.tbSns = tbSns
  self:InitControlState()
  self:FindPromo(tbSns)

  -- 关注官方微博
  for i, tbInfo in ipairs(Sns.tbOfficiaGroup[self.tbSns.nId]) do
    local szWnd = tbBtnGroups[i]
    Btn_Check(self.UIGROUP, szWnd, 1)
    Btn_SetTxt(self.UIGROUP, szWnd, tbInfo.szName)
    Wnd_SetTip(self.UIGROUP, szWnd, tbInfo.szTitle)
    Wnd_SetVisible(self.UIGROUP, szWnd, 1)
  end
end

function uiSnsFollow:InitControlState()
  Btn_Check(self.UIGROUP, BUTTON_JXSJ, 1)
  Wnd_SetVisible(self.UIGROUP, TXT_DESC, 0)

  for i, szWnd in ipairs(tbBtnGroups) do
    Wnd_SetVisible(self.UIGROUP, szWnd, 0)
    Btn_Check(self.UIGROUP, szWnd, 0)
  end

  for _, szWnd in ipairs(tbBtnFriends) do
    Wnd_SetVisible(self.UIGROUP, szWnd, 0)
    Btn_Check(self.UIGROUP, szWnd, 0)
  end
end

function uiSnsFollow:FindPromo(tbSns)
  local _, tbFriends = me.Relation_GetRelationList()
  local tbResult = {}
  local nValue = 2 ^ (tbSns.nId - 1)
  for szName, tbData in pairs(tbFriends) do
    if tbData.nSnsBind > 0 and KLib.BitOperate(tbData.nSnsBind, "&", nValue) > 0 then
      tbResult[#tbResult + 1] = tbData
    end
  end

  --按亲密度倒序
  local function fnSort(x, y)
    return x.nFavor > y.nFavor and true or false
  end
  table.sort(tbResult, fnSort)
  --构造一个最多10个元素的角色名数组
  local n = math.min(10, #tbResult)
  for i = 1, n do
    tbResult[i] = tbResult[i].szPlayer
  end
  self.tbFriends = tbResult

  --获取这些好友的SNS帐户名
  local fnCallback = function(tbInfo)
    self:ProcessAccount(tbInfo)
  end
  PProfile:RequireSnsInfo(tbResult, fnCallback)
end

function uiSnsFollow:ProcessAccount(tbInfo)
  local nParamId = Sns:ToProfileParamId(self.tbSns.nId)
  local szMyAccount = Sns.tbAccount[self.tbSns.nId]
  local tbFriends = {}
  for i, szName in ipairs(self.tbFriends) do
    if tbInfo and tbInfo[szName] and tbInfo[szName][nParamId] then
      local szAccount = tbInfo[szName][nParamId]
      if szAccount and #szAccount > 0 and szAccount ~= szMyAccount then
        local n = #tbFriends + 1
        tbFriends[n] = { ["szName"] = szName, ["szAccount"] = szAccount }
        local szWnd = tbBtnFriends[n]
        Btn_Check(self.UIGROUP, szWnd, 1)
        Btn_SetTxt(self.UIGROUP, szWnd, szName)
        Wnd_SetVisible(self.UIGROUP, szWnd, 1)
      end
    end
  end
  self.tbFriends = tbFriends
  if #tbFriends == 0 then
    Wnd_SetVisible(self.UIGROUP, TXT_DESC, 0)
    return
  else
    Txt_SetTxt(self.UIGROUP, TXT_DESC, string.format(MSG_DESC, self.tbSns.szName))
    Wnd_SetVisible(self.UIGROUP, TXT_DESC, 1)
  end
end

function uiSnsFollow:OnButtonClick(szWnd, nParam)
  if szWnd == BUTTON_OK then
    self:Follow()
    self:Close()
  elseif szWnd == BUTTON_CANCEL or szWnd == BUTTON_CLOSE then
    self:Close()
  end
end

function uiSnsFollow:Follow()
  local nSnsId = self.tbSns.nId
  if Btn_GetCheck(self.UIGROUP, BUTTON_JXSJ) == 1 then
    Sns:Follow(nSnsId, Sns.tbOfficialAccount[nSnsId], "剑侠世界官方微博")
  end
  for i, tb in ipairs(self.tbFriends) do
    local szWnd = tbBtnFriends[i]
    if Btn_GetCheck(self.UIGROUP, szWnd) == 1 then
      Sns:Follow(nSnsId, tb.szAccount, tb.szName)
    end
  end
  for i, tbInfo in ipairs(Sns.tbOfficiaGroup[nSnsId]) do
    local szWnd = tbBtnGroups[i]
    if Btn_GetCheck(self.UIGROUP, szWnd) == 1 then
      Sns:Follow(nSnsId, tbInfo.szAccount, tbInfo.szName)
    end
  end
end

function uiSnsFollow:Close()
  UiManager:CloseWindow(self.UIGROUP)
  UiManager:OpenWindow(Ui.UI_SNS_MAIN, nil, self.tbSns.nId)
end
