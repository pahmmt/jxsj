-- 文件名　：trustee.lua
-- 创建者　：HuangXin
-- 创建时间：2008-03-16 12:50:52

local uiTrustee = Ui:GetClass("trustee")

uiTrustee.LISTPILL = "ListPill"
uiTrustee.EDTBUYCONT = { "EdtBuyCount1", "EdtBuyCount2", "EdtBuyCount3", "EdtBuyCount4" }
uiTrustee.BTNADDCONT = { "BtnAdd1", "BtnAdd2", "BtnAdd3", "BtnAdd4" }
uiTrustee.BTNDECCONT = { "BtnDec1", "BtnDec2", "BtnDec3", "BtnDec4" }
uiTrustee.BTNBUYCONT = { "BtnBuy1", "BtnBuy2", "BtnBuy3", "BtnBuy4" }
uiTrustee.BTNBUYGOLD = "BtnBuyGold"
uiTrustee.TXTNOTE = "TxtNote"
uiTrustee.TXTBINDGOLD = "TxtBindGold"
uiTrustee.TXTGOLD = "TxtGold"
uiTrustee.TXTLEVEL = "TxtLevel"
uiTrustee.BTNCLOSE = "BtnClose"
uiTrustee.LISTCELLCOUNT = Item.IVER_nOpenBaiJuWanLevel
uiTrustee.LISTCELLNUM = 4

function uiTrustee:Init()
  self.tbShow = {}
  self.tbBuyMaxCount = {}
  self.tbPillInfo = {}
end

-- 这个函数是看是否到达一定的时间，那么就可以开启特效白驹的功能
function uiTrustee:RefreshBuyCount() end

function uiTrustee:OnOpen()
  if IVER_g_nSdoVersion == 1 then
    QuerySndaCoin()
  end
  self:RefreshBuyCount()

  self.tbPillInfo = Player.tbOffline:GetPillInfo()
  local tbWasteInfo = Player.tbOffline:GetWasteInfo()

  self:UpdateCurGold()
  self:UpdateLevel()

  local szNote = string.format("你有<color=red>%.1f<color>小时的离线托管时间可以使用白驹丸补充！", tbWasteInfo.nWasteTime / 3600)
  szNote = szNote .. "现在你可以通过购买各种种类的白驹丸来获得此段时间的托管经验（每天最多能离线托管18小时）！\n"
  szNote = szNote .. string.format("【注意：购买时将优先使用<color=red>绑定%s<color>，购买后将直接使用，剩余的托管时间将补充到您的累计托管时间中】", IVER_g_szCoinName)
  Txt_SetTxt(self.UIGROUP, self.TXTNOTE, szNote)

  for i = 1, math.min(#self.tbPillInfo, self.LISTCELLCOUNT) do
    self.tbShow[i] = { self.tbPillInfo[i][1], self.tbPillInfo[i][2] .. IVER_g_szCoinName, self.tbPillInfo[i][3] .. "倍", self.tbPillInfo[i][4] }
  end

  for i = 1, math.min(#self.tbPillInfo, self.LISTCELLCOUNT) do
    if self.tbPillInfo[i][5] == 1 then
      Wnd_Show(self.UIGROUP, self.EDTBUYCONT[i])
      Wnd_Show(self.UIGROUP, self.BTNADDCONT[i])
      Wnd_Show(self.UIGROUP, self.BTNDECCONT[i])
      Wnd_Show(self.UIGROUP, self.BTNBUYCONT[i])
      for j = 1, math.min(#self.tbPillInfo, self.LISTCELLNUM) do
        Lst_SetCell(self.UIGROUP, self.LISTPILL, i, j - 1, self.tbShow[i][j])
      end
      Edt_SetInt(self.UIGROUP, self.EDTBUYCONT[i], self.tbShow[i][4])
    else
      Wnd_Hide(self.UIGROUP, self.EDTBUYCONT[i])
      Wnd_Hide(self.UIGROUP, self.BTNADDCONT[i])
      Wnd_Hide(self.UIGROUP, self.BTNDECCONT[i])
      Wnd_Hide(self.UIGROUP, self.BTNBUYCONT[i])
    end
  end
end

function uiTrustee:UpdateLevel()
  if UiVersion == Ui.Version001 then
    Txt_SetTxt(self.UIGROUP, self.TXTLEVEL, "当前等级是" .. me.nLevel .. "级")
  else
    Txt_SetTxt(self.UIGROUP, self.TXTLEVEL, "等级：" .. me.nLevel)
  end
end

function uiTrustee:UpdateCurGold()
  local nCurBindCoin = me.nBindCoin
  local nCurCoin = 0
  if IVER_g_nSdoVersion == 1 then
    nCurCoin = GetSndaCoin() --me.nCoin;
  else
    nCurCoin = me.nCoin
  end

  for i = 1, math.min(#self.tbPillInfo, self.LISTCELLCOUNT) do
    self.tbBuyMaxCount[i] = math.floor(nCurBindCoin / self.tbPillInfo[i][2]) + math.floor(nCurCoin / self.tbPillInfo[i][2])
    local nCurCount = Edt_GetInt(self.UIGROUP, self.EDTBUYCONT[i])
    if nCurCount then
      if self.tbBuyMaxCount[i] <= 0 then
        Edt_SetInt(self.UIGROUP, self.EDTBUYCONT[i], 1)
      elseif nCurCount > self.tbBuyMaxCount[i] then
        Edt_SetInt(self.UIGROUP, self.EDTBUYCONT[i], self.tbBuyMaxCount[i])
      end
    end
  end
  if UiVersion == Ui.Version001 then
    Txt_SetTxt(self.UIGROUP, self.TXTBINDGOLD, "现有" .. nCurBindCoin .. IVER_g_szBindCoinName)
    Txt_SetTxt(self.UIGROUP, self.TXTGOLD, "现有" .. nCurCoin .. IVER_g_szCoinName)
  else
    Txt_SetTxt(self.UIGROUP, self.TXTBINDGOLD, IVER_g_szBindCoinName .. "：" .. nCurBindCoin)
    Txt_SetTxt(self.UIGROUP, self.TXTGOLD, IVER_g_szCoinName .. "：" .. nCurCoin)
  end
end

function uiTrustee:OnButtonClick(szWnd, nParam)
  for i = 1, math.min(#self.tbPillInfo, self.LISTCELLCOUNT) do
    local nCurCount
    if szWnd == self.BTNADDCONT[i] then
      nCurCount = Edt_GetInt(self.UIGROUP, self.EDTBUYCONT[i])

      if nCurCount and nCurCount < self.tbBuyMaxCount[i] then
        nCurCount = nCurCount + 1
        if nCurCount > 999 then
          nCurCount = 999
        end
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
      if EventManager.IVER_bOpenAccountLockNotEvent == 1 and me.IsAccountLock() ~= 0 then
        me.Msg("你的账号处于锁定状态，无法进行该操作！")
        Account:OpenLockWindow()
        return 0
      end

      local nBuyCount = Edt_GetInt(self.UIGROUP, self.EDTBUYCONT[i])

      local tbParam = Player.tbOffline:GetBuyInfo(i, nBuyCount)

      function tbParam:OnAccept()
        UiManager:CloseWindow(Ui.UI_TRUSTEE)
        me.CallServerScript({ "OfflineBuy", self.nBuyType, self.nBuyCount })
      end

      function tbParam:OnCancel() end

      function tbParam:OnShow()
        local szLimitMsg = ""
        if self.nLevelLimit < 150 and self.nLevelLimit > 0 then
          szLimitMsg = string.format("您是在服务器开放<color=yellow>%d<color>级等级上限以前进行离线托管，所以本次离线经验最多能使您升级到<color=yellow>%d<color>级！\n", self.nLevelLimit, self.nLevelLimit)
        end
        local szShow = string.format(
          "购买物品：<color=red>%s<color>\n购买数量：<color=red>%d<color>个\n"
            .. "获得经验：<color=red>%.f<color>点\n现在等级：%s\n到达等级：%s\n"
            --					"获得精力：<color=red>%.f<color>点\n获得活力：<color=red>%.f<color>点\n" ..
            .. "花费绑定"
            .. IVER_g_szCoinName
            .. "：<color=red>%d<color>个\n"
            .. "花费"
            .. IVER_g_szCoinName
            .. "：<color=red>%d<color>个\n"
            .. "\n购买并使用后剩余<color=red>%s<color>离线托管时间<color=red>%.1f<color>小时\n"
            .. szLimitMsg
            .. string.format("【注意：购买时优先扣除<color=red>%s<color>，%s不足时将扣除<color=yellow>%s<color>，购买后将直接使用】", IVER_g_szBindCoinName, IVER_g_szBindCoinName, IVER_g_szCoinName),
          self.szBuyName,
          self.nBuyCount,
          self.nAddExp,
          self.szCurLevel,
          self.szToLevel,
          --					self.nAddPoint, self.nAddPoint,
          self.nBindCoinCost,
          self.nCoinCost,
          self.szBuyName,
          self.nRestTime / 3600
        )
        return szShow
      end

      UiManager:OpenWindow(Ui.UI_REPORT, tbParam, "购买确认", "")
      break
    end
  end

  if szWnd == self.BTNBUYGOLD then
    UiManager:OpenWindow(Ui.UI_JBEXCHANGE)
  end

  if szWnd == self.BTNCLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiTrustee:OnEditChange(szWndName, nParam)
  local nMaxNum = 999
  for i = 1, math.min(#self.tbPillInfo, self.LISTCELLCOUNT) do
    if szWndName == self.EDTBUYCONT[i] then
      local nCurCount = Edt_GetInt(self.UIGROUP, self.EDTBUYCONT[i])
      if nCurCount then
        if nCurCount < 0 then
          nCurCount = 0
          Edt_SetTxt(self.UIGROUP, self.EDTBUYCONT[i], nCurCount)
        elseif nCurCount >= 0 then
          if nCurCount > self.tbBuyMaxCount[i] then
            nCurCount = self.tbBuyMaxCount[i]
            Edt_SetTxt(self.UIGROUP, self.EDTBUYCONT[i], nCurCount)
          end
          if nCurCount > nMaxNum then
            nCurCount = nMaxNum
            Edt_SetTxt(self.UIGROUP, self.EDTBUYCONT[i], nCurCount)
          end
        end
        break
      end
    end
  end
end

function uiTrustee:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_LEVEL, self.UpdateLevel },
    { UiNotify.emCOREEVENT_JBCOIN_CHANGED, self.UpdateCurGold },
  }
  return tbRegEvent
end
