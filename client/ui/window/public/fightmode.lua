local uiFightMode = Ui:GetClass("fightmode")

local BTNANNEAL = "BtnAnneal"
local BTNCAMP_PK = "BtnCamp_pk"
local BTNTONG_PK = "BtnTong_pk"
local BTNBUTCHER_PK = "BtnButcher_pk"

function uiFightMode:OnOpen()
  local nKinId = me.GetKinMember()
  if nKinId and nKinId <= 0 then
    Wnd_SetEnable(self.UIGROUP, BTNTONG_PK, 0)
  end

  if me.dwTongId and (me.dwTongId ~= 0) then
    Btn_SetTxt(self.UIGROUP, BTNTONG_PK, "°ï»áÄ£Ê½")
  end
end

function uiFightMode:OnButtonClick(szWnd, nParam)
  if szWnd == BTNANNEAL then
    me.nPkModel = Player.emKPK_STATE_PRACTISE
  elseif szWnd == BTNCAMP_PK then
    me.nPkModel = Player.emKPK_STATE_CAMP
  elseif szWnd == BTNTONG_PK then
    me.nPkModel = Player.emKPK_STATE_TONG
  elseif szWnd == BTNBUTCHER_PK then
    me.nPkModel = Player.emKPK_STATE_BUTCHER
  end
  UiManager:CloseWindow(self.UIGROUP)
end
