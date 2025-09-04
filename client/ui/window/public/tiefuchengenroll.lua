-------------------------------------------------------
-- 文件名　：tiefuchengenroll.lua
-- 创建者　：huangxiaoming
-- 创建时间：2010-09-29 14:25:10
-- 文件描述：
-------------------------------------------------------

local uiTieFuChengEnroll = Ui:GetClass("tiefuchengenroll")

uiTieFuChengEnroll.Btn_Close = "BtnClose"
uiTieFuChengEnroll.Lst_RegisterForm = "LstRegisterForm"
uiTieFuChengEnroll.Txt_Info = "TxtInfo"
uiTieFuChengEnroll.Btn_TongApply = "BtnTongApply"
uiTieFuChengEnroll.Btn_PlayerRegist = "BtnPlayerRegist"
uiTieFuChengEnroll.Txt_GroupCount = "TxtGroupCount"
uiTieFuChengEnroll.BTN_GLOBAL_AREA = "btn_global_area"
-- uiTieFuChengEnroll.tbRegistTong = {[1] = {szTongName, szGateway, nMemberCount, nSuccess}};

-- 收到服务器端数据
function uiTieFuChengEnroll:OnRecvData(nCaptain, tbSignup)
  if not nCaptain or not tbSignup then
    return 0
  end

  local nCount = 0
  local nTotal = 0
  local tbRegistTong = {}
  for szTongName, tbInfo in pairs(tbSignup) do
    table.insert(tbRegistTong, {
      szTongName = szTongName,
      szGateway = tbInfo.szGateway,
      nMemberCount = tbInfo.nMemberCount,
      nSuccess = tbInfo.nSuccess,
    })
    if tbInfo.nSuccess == 1 then
      nCount = nCount + 1
    end
    nTotal = nTotal + 1
  end

  local _Sort = function(tbA, tbB)
    if tbA.nSuccess > tbB.nSuccess then
      return true
    elseif tbA.nMemberCount > tbB.nMemberCount then
      return true
    end
    return false
  end

  table.sort(tbRegistTong, _Sort)
  self.tbRegistTong = tbRegistTong

  self:SetBtnState(nCaptain)
  self:UpdateRegistTongList(nCount, nTotal)
end

function uiTieFuChengEnroll:UpdateRegistTongList(nCount, nTotal)
  for nIndex, tbInfo in ipairs(self.tbRegistTong or {}) do
    Lst_SetCell(self.UIGROUP, self.Lst_RegisterForm, nIndex, 0, Lib:StrFillC(tbInfo.szTongName, 20))
    Lst_SetCell(self.UIGROUP, self.Lst_RegisterForm, nIndex, 1, Lib:StrFillC(ServerEvent:GetServerNameByGateway(tbInfo.szGateway), 15))
    if tbInfo.nSuccess == 1 then
      Lst_SetCell(self.UIGROUP, self.Lst_RegisterForm, nIndex, 2, Lib:StrFillC("获得资格", 16))
    else
      Lst_SetCell(self.UIGROUP, self.Lst_RegisterForm, nIndex, 2, Lib:StrFillC(string.format("%s人", tbInfo.nMemberCount), 16))
      Lst_SetLineColor(self.UIGROUP, self.Lst_RegisterForm, nIndex, 0xffFFFF00)
    end
  end
  Txt_SetTxt(self.UIGROUP, self.Txt_GroupCount, string.format("报名帮会数量：%s / %s", nCount, nTotal))
end

function uiTieFuChengEnroll:SetBtnState(nCaptain)
  if nCaptain == 1 then
    Wnd_SetEnable(self.UIGROUP, self.Btn_TongApply, 1)
    Wnd_SetEnable(self.UIGROUP, self.Btn_PlayerRegist, 0)
  else
    Wnd_SetEnable(self.UIGROUP, self.Btn_TongApply, 0)
    Wnd_SetEnable(self.UIGROUP, self.Btn_PlayerRegist, 1)
  end
end

function uiTieFuChengEnroll:OnButtonClick(szWnd, nParam)
  -- close
  if szWnd == uiTieFuChengEnroll.Btn_Close then
    UiManager:CloseWindow(self.UIGROUP)

  -- regist
  elseif szWnd == uiTieFuChengEnroll.Btn_PlayerRegist then
    me.CallServerScript({ "ApplyMemberSignup" })

  -- apply
  elseif szWnd == uiTieFuChengEnroll.Btn_TongApply then
    local tbMsg = {}
    tbMsg.szMsg = "确定本帮参加此次跨服城战？"
    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex)
      if nOptIndex == 2 then
        me.CallServerScript({ "ApplyCaptainSignup" })
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
  elseif szWnd == self.BTN_GLOBAL_AREA then
    UiManager:OpenWindow(Ui.UI_GLOBAL_AREA)
  end
end

function uiTieFuChengEnroll:DisableAll()
  Wnd_SetEnable(self.UIGROUP, self.Btn_TongApply, 0)
  Wnd_SetEnable(self.UIGROUP, self.Btn_PlayerRegist, 0)
end
