-- 文件名　：trustee.lua
-- 创建者　：HuangXin
-- 创建时间：2008-03-16 12:50:52

local uiJinghuo = Ui:GetClass("jinghuofuli")

uiJinghuo.LISTPILL = "ListPill"
uiJinghuo.EDTBUYCONT = { "EdtBuyCount1", "EdtBuyCount2" }
uiJinghuo.BTNADDCONT = { "BtnAdd1", "BtnAdd2" }
uiJinghuo.BTNDECCONT = { "BtnDec1", "BtnDec2" }
uiJinghuo.BTNBUYCONT = { "BtnBuy1", "BtnBuy2" }
uiJinghuo.BTNBUYGOLD = "BtnBuyGold"
uiJinghuo.TXTNOTE = "TxtNote"
uiJinghuo.TXTBINDGOLD = "TxtBindGold"
uiJinghuo.TXTGOLD = "TxtGold"
uiJinghuo.TXTMINPRESTIGE = "TxtMinPrestige"
uiJinghuo.BTNCLOSE = "BtnClose"
uiJinghuo.TXTEX_DESC = "TxtExDesc"
uiJinghuo.TXTEX_GOLD_DESC = "TxtExGoldDesc"
uiJinghuo.LISTCELLCOUNT = 2

function uiJinghuo:Init()
  self.tbShow = {}
  self.tbBuyMaxCount = {}
  self.tbPillInfo = {}
end

-- 这个函数是看是否到达一定的时间，那么就可以开启特效白驹的功能
function uiJinghuo:RefreshBuyCount()
  self.tbPillInfo = Player.tbBuyJingHuo:GetPillInfo()
end

function uiJinghuo:OnOpen()
  if IVER_g_nSdoVersion == 1 then
    QuerySndaCoin()
  end
  self:RefreshBuyCount()
  self:UpdateCurGold()
  self:UpdatePrestige()
  self:UpdateBuyCount()

  --	Txt_SetTxt(self.UIGROUP, self.TXTNOTE, szNote);
end

function uiJinghuo:UpdateBuyCount()
  for i = 1, math.min(#self.tbPillInfo, self.LISTCELLCOUNT) do
    local szMsg = self.tbPillInfo[i][4]
    self.tbShow[i] = { self.tbPillInfo[i][1], self.tbPillInfo[i][2] .. IVER_g_szCoinName, self.tbPillInfo[i][3], self.tbPillInfo[i][4] }
  end

  for i = 1, math.min(#self.tbPillInfo, self.LISTCELLCOUNT) do
    Wnd_Show(self.UIGROUP, self.EDTBUYCONT[i])
    Wnd_Show(self.UIGROUP, self.BTNBUYCONT[i])
    Wnd_Show(self.UIGROUP, self.BTNADDCONT[i])
    Wnd_Show(self.UIGROUP, self.BTNDECCONT[i])
    local tbInfo = self.tbPillInfo[i]
    for j = 1, #tbInfo do
      if j == 4 and self.tbShow[i][j] <= 0 then
        if 2 == Player.tbBuyJingHuo:CheckBuyState(me, i) then
          local szMsg = "<color=gray>1<color>"
          Lst_SetCell(self.UIGROUP, self.LISTPILL, i, j - 1, szMsg)
        else
          Lst_SetCell(self.UIGROUP, self.LISTPILL, i, j - 1, self.tbShow[i][j])
        end
      else
        Lst_SetCell(self.UIGROUP, self.LISTPILL, i, j - 1, self.tbShow[i][j])
      end
    end
    Edt_SetInt(self.UIGROUP, self.EDTBUYCONT[i], self.tbShow[i][4])
    if self.tbPillInfo[i][4] <= 0 then
      Wnd_SetEnable(self.UIGROUP, self.BTNADDCONT[i], 0)
      Wnd_SetEnable(self.UIGROUP, self.BTNDECCONT[i], 0)
    else
      Wnd_SetEnable(self.UIGROUP, self.BTNADDCONT[i], 1)
      Wnd_SetEnable(self.UIGROUP, self.BTNDECCONT[i], 1)
    end
  end
end

function uiJinghuo:UpdatePrestige()
  local nWeiWang = KGblTask.SCGetDbTaskInt(DBTASD_EVENT_PRESIGE_RESULT)
  if nWeiWang <= 0 then
    nWeiWang = 60
  end
  local nWeiWangKe = KGblTask.SCGetDbTaskInt(DBTASK_JINGHUOFULI_KE)
  if nWeiWangKe > 0 then
    nWeiWang = nWeiWangKe
  end
  local szMsg = string.format("你当前威望是<color=239,180,52>%s<color>点。<enter>今日福利精活购买的最低威望是<color=239,180,52>%s<color>点，还差<color=239,180,52>%s<color>点就能达到购买条件。你还需要继续<color=red><a=weiwanglink:>提高江湖威望<a><color>哦！<enter>【注意：购买前请确保背包有足够的空间，在各地礼官或通过修炼珠也能开启购买】", me.nPrestige, nWeiWang, nWeiWang - me.nPrestige)
  if me.nPrestige >= nWeiWang then
    szMsg = string.format("你当前威望是<color=239,180,52>%s<color>点。<enter>今日福利精活购买的最低威望是<color=239,180,52>%s<color>点，达到购买条件。请继续<color=red><a=weiwanglink:>维护江湖威望<a><color>哦！<enter>【注意：购买前请确保背包有足够的空间，在各地礼官或通过修炼珠也能开启购买】", me.nPrestige, nWeiWang)
  end
  TxtEx_SetText(self.UIGROUP, self.TXTEX_DESC, szMsg)
  -- Txt_SetTxt(self.UIGROUP, self.TXTMINPRESTIGE,	"购买最低威望需求："..nWeiWang.."点");
end

function uiJinghuo:Link_weiwanglink_OnClick(szWnd)
  Task.tbHelp:OpenNews_C(5, "江湖威望的获取")
end

function uiJinghuo:Link_helpfuli_OnClick(szWnd)
  Task.tbHelp:OpenNews_C(5, "精活药打折卖")
end

function uiJinghuo:UpdateCurGold()
  local nCurBindCoin = me.nBindCoin
  local nCurCoin = 0
  if IVER_g_nSdoVersion == 1 then
    nCurCoin = GetSndaCoin() --me.nCoin;
  else
    nCurCoin = me.nCoin
  end

  for i = 1, math.min(#self.tbPillInfo, self.LISTCELLCOUNT) do
    local nOrgCount = Player.tbBuyJingHuo:GetOrgJingHuoCount(me, i)
    local nExCount = Player.tbBuyJingHuo:GetExJingHuoBuyCount(me, i)
    self.tbBuyMaxCount[i] = nOrgCount + nExCount
    local nCurCount = Edt_GetInt(self.UIGROUP, self.EDTBUYCONT[i])
    if nCurCount then
      if self.tbBuyMaxCount[i] <= 0 then
        Edt_SetInt(self.UIGROUP, self.EDTBUYCONT[i], 1)
      elseif nCurCount > self.tbBuyMaxCount[i] then
        Edt_SetInt(self.UIGROUP, self.EDTBUYCONT[i], self.tbBuyMaxCount[i])
      end
    end
  end
  local szMsg = string.format("你当前的%s为：<color=239,180,52>%s<color><enter>《剑侠世界》四折福利精活为您打造<a=helpfuli:>高收益的网游生活<a>。", IVER_g_szCoinName, nCurCoin)
  -- Txt_SetTxt(self.UIGROUP, self.TXTGOLD,	"现有"..nCurCoin..IVER_g_szCoinName);
  TxtEx_SetText(self.UIGROUP, self.TXTEX_GOLD_DESC, szMsg)
end

function uiJinghuo:OnButtonClick(szWnd, nParam)
  for i = 1, math.min(#self.tbPillInfo, self.LISTCELLCOUNT) do
    local nCurCount
    if szWnd == self.BTNADDCONT[i] then
      nCurCount = Edt_GetInt(self.UIGROUP, self.EDTBUYCONT[i])

      if nCurCount and nCurCount < self.tbBuyMaxCount[i] then
        nCurCount = nCurCount + 1
        Edt_SetInt(self.UIGROUP, self.EDTBUYCONT[i], nCurCount)
      end
      break
    end

    if szWnd == self.BTNDECCONT[i] then
      local nCurCount = Edt_GetInt(self.UIGROUP, self.EDTBUYCONT[i])
      if nCurCount and nCurCount ~= 1 then
        nCurCount = nCurCount - 1
        Edt_SetInt(self.UIGROUP, self.EDTBUYCONT[i], nCurCount)
      end
    end

    if szWnd == self.BTNBUYCONT[i] then
      local nBuyCount = Edt_GetInt(self.UIGROUP, self.EDTBUYCONT[i])
      me.CallServerScript({ "JingHuoBuy", i, nBuyCount })
      break
    end
  end

  if szWnd == self.BTNBUYGOLD then
    if IVER_g_nSdoVersion == 1 then
      OpenSDOWidget()
      return
    end
    me.CallServerScript({ "ApplyOpenOnlinePay" })
  end

  if szWnd == self.BTNCLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiJinghuo:OnEditChange(szWndName, nParam)
  for i = 1, math.min(#self.tbPillInfo, self.LISTCELLCOUNT) do
    if szWndName == self.EDTBUYCONT[i] then
      local nCurCount = Edt_GetInt(self.UIGROUP, self.EDTBUYCONT[i])
      if nCurCount then
        if nCurCount < 1 then
          nCurCount = 1
          Edt_SetInt(self.UIGROUP, self.EDTBUYCONT[i], nCurCount)
        elseif nCurCount > 1 and nCurCount > self.tbBuyMaxCount[i] then
          nCurCount = self.tbBuyMaxCount[i]
          Edt_SetInt(self.UIGROUP, self.EDTBUYCONT[i], nCurCount)
        end
        break
      end
    end
  end
end

function uiJinghuo:RefreshCount()
  self:RefreshBuyCount()
  self:UpdateBuyCount()
end

function uiJinghuo:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_JBCOIN_CHANGED, self.UpdateCurGold },
  }
  return tbRegEvent
end
