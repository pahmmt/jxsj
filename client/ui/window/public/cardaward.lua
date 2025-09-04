-- 文件名　：cardaward.lua
-- 创建者　：jiazhenwei
-- 创建时间：2012-05-14 14:18:04
-- 功能    ：卡牌奖励界面

local uiCardAward = Ui:GetClass("cardaward")
local tbObject = Ui.tbLogic.tbObject
local tbTempItem = Ui.tbLogic.tbTempItem

uiCardAward.Txt_Title = "Txt_Title"
uiCardAward.TxtEx_Msg = "TxtEx_Msg"
uiCardAward.Btn_Card = "Btn_Card_"
uiCardAward.Obj_Item = "obj_Item_"
uiCardAward.Img_Item = "Img_Item_"
uiCardAward.Btn_Close = "Btn_Close"
uiCardAward.Btn_State = "Btn_State"
uiCardAward.Btn_CloseEx = "Btn_CloseEx"

uiCardAward.STATE_VIEWALLITEM = 1 --显示所有奖励的界面
uiCardAward.STATE_SELECTAWARD = 2 --选择领取奖励界面
uiCardAward.STATE_VIEWSELECTED = 3 --显示领取后的奖励界面
uiCardAward.STATE_VIEWSELECTED_C = 4 --显示领取后的奖励界面可以继续

uiCardAward.nCardCount = 6

uiCardAward.tbItemView = {
  ["money"] = { "\\image\\icon\\task\\prize_money.spr", "银两%s" },
  ["bindmoney"] = { "\\image\\icon\\task\\prize_money.spr", "绑定银两%s" },
  ["bindcoin"] = { "\\image\\item\\other\\scriptitem\\jintiao_xiao.spr", "绑定金币%s" },
  ["gatherpoint"] = { "\\image\\icon\\task\\prize_energy.spr", "活力%s点" },
  ["makepoint"] = { "\\image\\icon\\task\\prize_vires.spr", "精力%s点" },
  ["repute"] = { "\\image\\icon\\task\\prize_repute.spr", "声望：%s" },
  ["title"] = { "\\image\\item\\other\\merchant\\techan_023.spr", "称号：%s" },
  ["default"] = { "\\image\\item\\other\\quest\\quest_0026_s.spr", "神秘奖励" },
}

uiCardAward.tbItemViewEx = { "money", "bindmoney", "bindcoin", "gatherpoint", "makepoint", "repute", "title", "default" }

uiCardAward.OBJ_BASEAWARD = {}
uiCardAward.OBJ_BASEAWARD_Wnd = {}
for i = 1, uiCardAward.nCardCount do
  uiCardAward.OBJ_BASEAWARD[i] = "obj_Item_" .. i
  uiCardAward.OBJ_BASEAWARD_Wnd["obj_Item_" .. i] = i
end

function uiCardAward:Init()
  self.nState = self.STATE_VIEWALLITEM --当前处于什么阶段
  self.tbObjManager = {} --obj管理器
  self.tbImgManager = {} --img管理器
  self.TimerStop = 0
  self.TimerChangerObj = 0
  self.TimerClose = 0
end

function uiCardAward:UpdateItem(tbItem, nX, nY)
  local pItem = tbItem.pItem
  ObjGrid_ChangeSubScript(self.szUiGroup, self.szObjGrid, tostring(tbItem.nCount), nX, nY)
end

function uiCardAward:OnObjGridEnter(szWnd, nX, nY)
  local tbObj = nil

  if self.OBJ_BASEAWARD_Wnd[szWnd] then
    local nIndex = self.OBJ_BASEAWARD_Wnd[szWnd]
    tbObj = self.tbBaseAwardGrid[nIndex]:GetObj(nX, nY)
  end

  if not tbObj then
    return 0
  end

  local pItem = tbObj.pItem
  if not pItem then
    return 0
  end

  Wnd_ShowMouseHoverInfo(self.UIGROUP, szWnd, pItem.GetCompareTip(Item.TIPS_NORMAL, tbObj.szBindType))
end

function uiCardAward:OnCreate()
  self.tbBaseAwardGrid = {}
  for i, szGrid in pairs(self.OBJ_BASEAWARD) do
    self.tbBaseAwardGrid[i] = tbObject:RegisterContainer(self.UIGROUP, szGrid, 1, 1, nil, "cardaward")
    self.tbBaseAwardGrid[i].OnObjGridEnter = self.OnObjGridEnter
    self.tbBaseAwardGrid[i].UpdateItem = self.UpdateItem
  end
end

function uiCardAward:OnDestroy()
  for _, tbCont in pairs(self.tbBaseAwardGrid) do
    tbObject:UnregContainer(tbCont)
  end
end

--打开界面
function uiCardAward:OnOpen()
  self:UpdateEx()
  Timer:Register(9, self.Update, self)
  --self:Update();
end

function uiCardAward:UpdateEx()
  Txt_SetTxt(self.UIGROUP, self.Txt_Title, CardAward.tbPlayerAward.szTitle or "卡牌奖励")
  if CardAward.tbPlayerAward.tbMsg then
    TxtEx_SetText(self.UIGROUP, self.TxtEx_Msg, CardAward.tbPlayerAward.tbMsg[CardAward.tbPlayerAward.nState] or CardAward.tbPlayerAward.tbMsg[#CardAward.tbPlayerAward.tbMsg] or "")
  end
  for i, tbInfor in ipairs(CardAward.tbPlayerAward.tbAwards) do
    Wnd_SetEnable(self.UIGROUP, self.Btn_Card .. i, 1)
    Img_SetFrame(self.UIGROUP, self.Btn_Card .. i, 1)
    Wnd_SetEnable(self.UIGROUP, self.Obj_Item .. i, 0)
    Wnd_Hide(self.UIGROUP, self.Obj_Item .. i)
    Wnd_SetEnable(self.UIGROUP, self.Img_Item .. i, 0)
    Wnd_Hide(self.UIGROUP, self.Img_Item .. i)
    Btn_SetTxt(self.UIGROUP, self.Btn_State, "开始")
    Wnd_SetEnable(self.UIGROUP, self.Btn_State, 0)
  end
  if not CardAward.tbPlayerAward.bBack then
    Wnd_SetEnable(self.UIGROUP, self.Btn_CloseEx, 0)
    Wnd_Hide(self.UIGROUP, self.Btn_CloseEx)
  end
end

--关闭的时候，提示，
function uiCardAward:OnClose()
  if self.TimerStop > 0 then
    Timer:Close(self.TimerStop)
    self.TimerStop = 0
  end
  if self.TimerChangerObj > 0 then
    Timer:Close(self.TimerChangerObj)
    self.TimerChangerObj = 0
  end
  if self.TimerClose > 0 then
    Timer:Close(self.TimerClose)
    self.TimerClose = 0
  end
  if CardAward.tbPlayerAward.bBack then
    me.CallServerScript({ "OnCardAwardEnd" })
  end
  CardAward.tbPlayerAward = {}
end

--刷新界面
function uiCardAward:Update()
  Txt_SetTxt(self.UIGROUP, self.Txt_Title, CardAward.tbPlayerAward.szTitle or "卡牌奖励")
  if CardAward.tbPlayerAward.tbMsg then
    TxtEx_SetText(self.UIGROUP, self.TxtEx_Msg, CardAward.tbPlayerAward.tbMsg[CardAward.tbPlayerAward.nState] or CardAward.tbPlayerAward.tbMsg[#CardAward.tbPlayerAward.tbMsg] or "")
  end
  if CardAward.tbPlayerAward.nState == self.STATE_VIEWALLITEM or CardAward.tbPlayerAward.nState == self.STATE_VIEWSELECTED or CardAward.tbPlayerAward.nState == self.STATE_VIEWSELECTED_C then
    for i, tbInfor in ipairs(CardAward.tbPlayerAward.tbAwards) do
      Wnd_SetEnable(self.UIGROUP, self.Btn_Card .. i, 0)
      if tbInfor.bSelected then
        Img_SetFrame(self.UIGROUP, self.Btn_Card .. i, 3)
      else
        Img_SetFrame(self.UIGROUP, self.Btn_Card .. i, 2)
      end
      if tbInfor.szType == "item" then
        Wnd_SetEnable(self.UIGROUP, self.Obj_Item .. i, 1)
        Wnd_Show(self.UIGROUP, self.Obj_Item .. i)
        Wnd_SetEnable(self.UIGROUP, self.Img_Item .. i, 0)
        Wnd_Hide(self.UIGROUP, self.Img_Item .. i)
        local tbObj = self:CreateTempItem(tbInfor.varValue[1], tbInfor.varValue[2], tbInfor.varValue[3], tbInfor.varValue[4], tbInfor.varValue[5] or 0, tbInfor.varValue[6])
        if tbObj then
          self.tbBaseAwardGrid[i]:SetObj(tbObj)
          table.insert(self.tbObjManager, tbObj)
        end
      else
        Wnd_SetEnable(self.UIGROUP, self.Img_Item .. i, 1)
        Wnd_Show(self.UIGROUP, self.Img_Item .. i)
        Wnd_SetEnable(self.UIGROUP, self.Obj_Item .. i, 0)
        Wnd_Hide(self.UIGROUP, self.Obj_Item .. i)
        Img_SetImage(self.UIGROUP, self.Img_Item .. i, 1, self.tbItemView[tbInfor.szType][1] or self.tbItemView["default"][1])
        if tbInfor.szType ~= "repute" then
          Wnd_SetTip(self.UIGROUP, self.Img_Item .. i, string.format(self.tbItemView[tbInfor.szType][2], tbInfor.varValue) or self.tbItemView["default"][2])
        else
          Wnd_SetTip(self.UIGROUP, self.Img_Item .. i, string.format(self.tbItemView[tbInfor.szType][2], tbInfor.varValue[4]) or self.tbItemView["default"][2])
        end
        table.insert(self.tbImgManager, self.tbItemView[tbInfor.szType][1] or self.tbItemView["default"][1])
      end
    end
    Wnd_SetEnable(self.UIGROUP, self.Btn_State, 1)
  elseif CardAward.tbPlayerAward.nState == self.STATE_SELECTAWARD then
    for i, tbInfor in ipairs(CardAward.tbPlayerAward.tbAwards) do
      if tbInfor.bSelected then
        Wnd_SetEnable(self.UIGROUP, self.Btn_Card .. i, 0)
        Img_SetFrame(self.UIGROUP, self.Btn_Card .. i, 3)
        if tbInfor.szType == "item" then
          Wnd_SetEnable(self.UIGROUP, self.Obj_Item .. i, 1)
          Wnd_Show(self.UIGROUP, self.Obj_Item .. i)
          Wnd_SetEnable(self.UIGROUP, self.Img_Item .. i, 0)
          Wnd_Hide(self.UIGROUP, self.Img_Item .. i)
          local tbObj = self:CreateTempItem(tbInfor.varValue[1], tbInfor.varValue[2], tbInfor.varValue[3], tbInfor.varValue[4], tbInfor.varValue[5] or 0, tbInfor.varValue[6])
          if tbObj then
            self.tbBaseAwardGrid[i]:SetObj(tbObj)
            table.insert(self.tbObjManager, tbObj)
          end
        else
          Wnd_SetEnable(self.UIGROUP, self.Img_Item .. i, 1)
          Wnd_Show(self.UIGROUP, self.Img_Item .. i)
          Wnd_SetEnable(self.UIGROUP, self.Obj_Item .. i, 0)
          Wnd_Hide(self.UIGROUP, self.Obj_Item .. i)
          Img_SetImage(self.UIGROUP, self.Img_Item .. i, 1, self.tbItemView[tbInfor.szType][1] or self.tbItemView["default"][1])
          if tbInfor.szType ~= "repute" then
            Wnd_SetTip(self.UIGROUP, self.Img_Item .. i, string.format(self.tbItemView[tbInfor.szType][2], tbInfor.varValue) or self.tbItemView["default"][2])
          else
            Wnd_SetTip(self.UIGROUP, self.Img_Item .. i, string.format(self.tbItemView[tbInfor.szType][2], tbInfor.varValue[4]) or self.tbItemView["default"][2])
          end
          table.insert(self.tbImgManager, self.tbItemView[tbInfor.szType][1] or self.tbItemView["default"][1])
        end
        Wnd_SetEnable(self.UIGROUP, self.Btn_State, 1)
      else
        Wnd_SetEnable(self.UIGROUP, self.Btn_Card .. i, 1)
        Img_SetFrame(self.UIGROUP, self.Btn_Card .. i, 1)
        Wnd_SetEnable(self.UIGROUP, self.Obj_Item .. i, 0)
        Wnd_Hide(self.UIGROUP, self.Obj_Item .. i)
        Wnd_SetEnable(self.UIGROUP, self.Img_Item .. i, 0)
        Wnd_Hide(self.UIGROUP, self.Img_Item .. i)
      end
      Btn_SetTxt(self.UIGROUP, self.Btn_State, "选择礼物")
      Wnd_SetEnable(self.UIGROUP, self.Btn_State, 0)
    end
  end
  if not CardAward.tbPlayerAward.bBack then
    Wnd_SetEnable(self.UIGROUP, self.Btn_CloseEx, 0)
    Wnd_Hide(self.UIGROUP, self.Btn_CloseEx)
  end
  return 0
end

function uiCardAward:OnButtonClick(szWnd, nParam)
  if not szWnd then
    return
  end
  if szWnd == self.Btn_Close or szWnd == self.Btn_CloseEx then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.Btn_State then
    if CardAward.tbPlayerAward.nState == self.STATE_VIEWALLITEM then
      self:ChangeCard()
    elseif CardAward.tbPlayerAward.nState == self.STATE_VIEWSELECTED then
      UiManager:CloseWindow(self.UIGROUP)
    elseif CardAward.tbPlayerAward.nState == self.STATE_VIEWSELECTED_C then
      self:Continue()
    end
  else
    for i = 1, 6 do
      local szBtnWnd = self.Btn_Card .. i
      if szBtnWnd == szWnd then
        self:OnSelectBtn(i)
      end
    end
  end
end

--选牌
function uiCardAward:OnSelectBtn(nIndex)
  --选过一次的就要付费选了
  if CardAward:CheckRoundAward() == 1 then
    CardAward:GetRoundAward_C(nIndex)
  elseif CardAward.tbPlayerAward.nPerPayCount and CardAward.tbPlayerAward.nPerPayCount > 0 then
    CardAward:OpenOneCard_C(nIndex)
  end
end

function uiCardAward:Continue()
  if CardAward.tbPlayerAward.bBack then
    CardAward.tbPlayerAward.bBack = nil
  end
  me.CallServerScript({ "OnCardAwardContinue" })
end

--洗牌按钮
function uiCardAward:ChangeCard()
  CardAward:OnStart_C()
end

function uiCardAward:ViewOneCard()
  self:Update()
  Btn_SetTxt(self.UIGROUP, self.Btn_State, "关闭卡牌")
  Wnd_SetEnable(self.UIGROUP, self.Btn_State, 0)
end

--开始洗牌
function uiCardAward:ChangeCard2()
  self.TimerStop = Timer:Register(2 * 18, self.Stop, self)
  self.TimerChangerObj = Timer:Register(1, self.ChangerObj, self)
  Wnd_SetEnable(self.UIGROUP, self.Btn_State, 0)
end

--结束
function uiCardAward:EndCard(bContinue)
  self:Update()
  Timer:Register(18, self.EndCard2, self, bContinue)
  return 0
end

function uiCardAward:EndCard2(bContinue)
  if bContinue == 1 then
    Btn_SetTxt(self.UIGROUP, self.Btn_State, "继续下一次")
    CardAward.tbPlayerAward.nState = self.STATE_VIEWSELECTED_C
  else
    Btn_SetTxt(self.UIGROUP, self.Btn_State, "结束")
    CardAward.tbPlayerAward.nState = self.STATE_VIEWSELECTED
  end
  Wnd_SetEnable(self.UIGROUP, self.Btn_State, 1)
  self:Update()
  if CardAward.tbPlayerAward.bBack and bContinue ~= 1 then
    Btn_SetTxt(self.UIGROUP, self.Btn_State, "继续下一次")
    Wnd_SetEnable(self.UIGROUP, self.Btn_State, 0)
  end
  return 0
end

--timer关闭
function uiCardAward:CloseCard()
  UiManager:CloseWindow(self.UIGROUP)
  self.TimerClose = 0
  return 0
end

--停止，改变按状态
function uiCardAward:Stop()
  if self.TimerChangerObj > 0 then
    Timer:Close(self.TimerChangerObj)
    self.TimerChangerObj = 0
  end
  CardAward.tbPlayerAward.nState = self.STATE_SELECTAWARD
  Wnd_SetEnable(self.UIGROUP, self.Btn_State, 0)
  self:Update()
  self.TimerStop = 0
  return 0
end

--变换obj和img
function uiCardAward:ChangerObj()
  for i = 1, 6 do
    Wnd_SetEnable(self.UIGROUP, self.Btn_Card .. i, 0)
    Img_SetFrame(self.UIGROUP, self.Btn_Card .. i, 2)
    local nType = 2 - math.fmod(MathRandom(100), 2)
    if #self.tbObjManager <= 0 and nType == 1 then
      nType = 2
    end
    if #self.tbImgManager <= 0 and nType == 2 then
      nType = 1
    end
    if nType == 1 then
      Wnd_SetEnable(self.UIGROUP, self.Obj_Item .. i, 1)
      Wnd_Show(self.UIGROUP, self.Obj_Item .. i)
      Wnd_SetEnable(self.UIGROUP, self.Img_Item .. i, 0)
      Wnd_Hide(self.UIGROUP, self.Img_Item .. i)
      local tbObj = self.tbObjManager[MathRandom(#self.tbObjManager)]
      if tbObj then
        self.tbBaseAwardGrid[i]:SetObj(tbObj)
      end
    else
      Wnd_SetEnable(self.UIGROUP, self.Img_Item .. i, 1)
      Wnd_Show(self.UIGROUP, self.Img_Item .. i)
      Wnd_SetEnable(self.UIGROUP, self.Obj_Item .. i, 0)
      Wnd_Hide(self.UIGROUP, self.Obj_Item .. i)
      local nIndex = MathRandom(#self.tbImgManager)
      Img_SetImage(self.UIGROUP, self.Img_Item .. i, 1, self.tbImgManager[nIndex] or self.tbItemView["default"][1])
      Wnd_SetTip(self.UIGROUP, self.Img_Item .. i, "")
    end
  end
  return
end

function uiCardAward:CreateTempItem(nGenre, nDetail, nParticular, nLevel, nBind, nCount)
  local pItem = tbTempItem:Create(nGenre, nDetail, nParticular, nLevel, -1)
  if not pItem then
    return
  end

  local tbObj = {}
  tbObj.nType = Ui.OBJ_TEMPITEM
  tbObj.pItem = pItem
  tbObj.pItem.SetCount(nCount or 1)
  tbObj.nCount = nCount or 1

  if nBind == 1 then
    tbObj.szBindType = "获取绑定"
  end
  return tbObj
end
