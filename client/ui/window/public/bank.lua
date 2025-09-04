-- 文件名　：bank.lua
-- 创建者　：furuilei
-- 创建时间：2008-11-17 09:53:16

local uiBank = Ui:GetClass("bank")
local tbTimer = Ui.tbLogic.tbTimer
uiBank.DAYSECOND = 3600 * 24
uiBank.nCount = 0

uiBank.BTNCLOSE = "Btn_Close"
uiBank.BTNSAVEGOLD = "Btn_GoldSave"
uiBank.BTNDRAWGOLD = "Btn_GoldDraw"
uiBank.BTNCANCELGOLDLIMIT = "Btn_CancelGoldLimit"
uiBank.BTNMODIFYGOLDLIMIT = "Btn_ModifyGoldLimit"
uiBank.BTNSAVESILVER = "Btn_SilverSave"
uiBank.BTNDRAWSILVER = "Btn_SilverDraw"
uiBank.BTNCANCELSILVERLIMIT = "Btn_CancelSilverLimit"
uiBank.BTNMODIFYSILVERLIMIT = "Btn_ModifySilverLimit"
uiBank.EDIT_GOLDSAVE = "Edit_GoldSave"
uiBank.EDIT_GOLDDRAW = "Edit_GoldDraw"
uiBank.EDIT_GOLDLIMIT = "Edit_GoldLimit"
uiBank.TXT_GOLDINFO = "Txt_GoldInfo3"
uiBank.EDIT_SILVERSAVE = "Edit_SilverSave"
uiBank.EDIT_SILVERDRAW = "Edit_SilverDraw"
uiBank.EDIT_SILVERLIMIT = "Edit_SilverLimit"
uiBank.TXT_GOLDSUM = "Txt_GoldSum"
uiBank.TXT_GOLDLIMIT = "Txt_GoldLimit"
uiBank.TXT_SILVERSUM = "Txt_SilverSum"
uiBank.TXT_SILVERLIMIT = "Txt_SilverLimit"
uiBank.TXT_SILVERINFO = "Txt_SilverInfo3"
uiBank.TXT_GOLDINFO1 = "Txt_GoldInfo1"
uiBank.TXT_GOLDINFO2 = "Txt_GoldInfo2"
uiBank.TXT_SILVERINFO1 = "Txt_SilverInfo1"
uiBank.TXT_SILVERINFO2 = "Txt_SilverInfo2"

uiBank.REFRESHTIME = Env.GAME_FPS * 2 -- 定时刷新 1秒钟

function uiBank:Init() end

function uiBank:OnOpen()
  me.CallServerScript({ "BankCmd", "DoEfficient" })
end

-- 刷新金币区和银两区信息
function uiBank:OnUpdateInfo(nCoin)
  self:UpdateGoldInfo(nCoin)
  self:UpdateSilverInfo()
end

-- 金币未生效上限的提示信息
function uiBank:UpdateGoldInfo(nChangeCoin)
  if nChangeCoin then
    if nChangeCoin > 0 then
      me.Msg("您成功存入<color=224,181,100>" .. nChangeCoin .. "个金币<color>。")
    elseif nChangeCoin < 0 then
      me.Msg("您成功取出<color=224,181,100>" .. math.abs(nChangeCoin) .. "个金币<color>。")
    end
  end

  local nEfficientTime = me.GetTask(Bank.TASK_GROUP, Bank.TASK_ID_GOLD_EFFICIENT_DAY)
  local szData = os.date("%Y年%m月%d日 %H:%M", nEfficientTime)
  local nUnEfficientGoldLimit = me.GetTask(Bank.TASK_GROUP, Bank.TASK_ID_GOLD_UNEFFICIENT_LIMIT)
  local nGoldSum = me.GetTask(Bank.TASK_GROUP, Bank.TASK_ID_GOLD_SUM)
  local nGoldLimit = me.GetTask(Bank.TASK_GROUP, Bank.TASK_ID_GOLD_LIMIT)
  local szGoldInfo = ""
  Wnd_SetEnable(self.UIGROUP, self.BTNCANCELGOLDLIMIT, 1)
  if nUnEfficientGoldLimit == 0 or nEfficientTime == 0 then
    szGoldInfo = "<color=224,181,100>您当前没有未生效的金币支取上限。<color>"
    Wnd_SetEnable(self.UIGROUP, self.BTNCANCELGOLDLIMIT, 0)
  else
    szGoldInfo = "上次修改的金币支取上限为：<color=224,181,100>" .. nUnEfficientGoldLimit .. "金<color>。\n生效日期:<color=224,181,100>" .. szData .. "<color>"
  end

  local szGoldSum = "您目前在本店存有：<color=224,181,100>" .. nGoldSum .. "（金币）<color>"
  local szGoldLimit = "当前每日支取上限：<color=224,181,100>" .. nGoldLimit .. "（金币）<color>"
  Txt_SetTxt(self.UIGROUP, self.TXT_GOLDINFO, szGoldInfo)
  Txt_SetTxt(self.UIGROUP, self.TXT_GOLDINFO1, szGoldSum)
  Txt_SetTxt(self.UIGROUP, self.TXT_GOLDINFO2, szGoldLimit)
  Edt_SetTxt(self.UIGROUP, self.EDIT_GOLDSAVE, 0)
  Edt_SetTxt(self.UIGROUP, self.EDIT_GOLDDRAW, 0)
  Edt_SetTxt(self.UIGROUP, self.EDIT_GOLDLIMIT, 0)
end

-- 银两未生效上限的提示信息
function uiBank:UpdateSilverInfo()
  local nSilverSum = me.GetTask(Bank.TASK_GROUP, Bank.TASK_ID_SILVER_SUM)
  local nSilverLimit = me.GetTask(Bank.TASK_GROUP, Bank.TASK_ID_SILVER_LIMIT)
  local nUnEfficientSilverLimit = me.GetTask(Bank.TASK_GROUP, Bank.TASK_ID_SILVER_UNEFFICIENT_LIMIT)
  local nEfficientTime = me.GetTask(Bank.TASK_GROUP, Bank.TASK_ID_SILVER_EFFICIENT_DAY)
  local szData = os.date("%Y年%m月%d日 %H:%M", nEfficientTime)
  local szSilverInfo = ""
  Wnd_SetEnable(self.UIGROUP, self.BTNCANCELSILVERLIMIT, 1)
  if nUnEfficientSilverLimit == 0 or nEfficientTime == 0 then
    szSilverInfo = "<color=224,181,100>您目前没有未生效的银两支取上限。<color>"
    Wnd_SetEnable(self.UIGROUP, self.BTNCANCELSILVERLIMIT, 0)
  else
    szSilverInfo = "上次修改的银两支取上限为：<color=224,181,100>" .. nUnEfficientSilverLimit .. "两<color>。\n生效日期：<color=224,181,100>" .. szData .. "<color>"
  end

  local szSilverSum = "您目前在本店存有：<color=224,181,100>" .. nSilverSum .. "（两）<color>"
  local szSilverLimit = "当前每日支取上限：<color=224,181,100>" .. nSilverLimit .. "（两）<color>"
  Txt_SetTxt(self.UIGROUP, self.TXT_SILVERINFO, szSilverInfo)
  Txt_SetTxt(self.UIGROUP, self.TXT_SILVERINFO1, szSilverSum)
  Txt_SetTxt(self.UIGROUP, self.TXT_SILVERINFO2, szSilverLimit)
  Edt_SetTxt(self.UIGROUP, self.EDIT_SILVERSAVE, 0)
  Edt_SetTxt(self.UIGROUP, self.EDIT_SILVERDRAW, 0)
  Edt_SetTxt(self.UIGROUP, self.EDIT_SILVERLIMIT, 0)
end

function uiBank:OnClose() end

-- 按键响应
function uiBank:OnButtonClick(szWnd)
  if szWnd == uiBank.BTNCLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == uiBank.BTNSAVEGOLD then
    self:OnBtnSaveGold()
  elseif szWnd == uiBank.BTNDRAWGOLD then
    self:OnBtnDrawGold()
  elseif szWnd == uiBank.BTNCANCELGOLDLIMIT then
    self:OnBtnCancelGoldLimit()
  elseif szWnd == uiBank.BTNMODIFYGOLDLIMIT then
    self:OnBtnModifyGoldLimit()
  elseif szWnd == uiBank.BTNSAVESILVER then
    self:OnBtnSaveSilver()
  elseif szWnd == uiBank.BTNDRAWSILVER then
    self:OnBtnDrawSilver()
  elseif szWnd == uiBank.BTNCANCELSILVERLIMIT then
    self:OnBtnCancelSilverLimit()
  elseif szWnd == uiBank.BTNMODIFYSILVERLIMIT then
    self:OnBtnModifySilverLimit()
  end
end

-- 用来处理存储金币的操作
function uiBank:OnBtnSaveGold()
  local nGoldSaveCount = Edt_GetInt(self.UIGROUP, self.EDIT_GOLDSAVE)
  if not nGoldSaveCount then
    return
  end

  local nMaxSaveCount = me.nCoin
  local szMsg = ""
  if nMaxSaveCount <= 0 then
    szMsg = "您身上已经没有金币了，不能进行该操作。"
  elseif nGoldSaveCount <= 0 then
    szMsg = "您输入的数字有误，请重新输入。"
  elseif nGoldSaveCount > nMaxSaveCount then
    szMsg = "您身上金币不够，不能进行该操作。"
  elseif nGoldSaveCount + me.GetTask(Bank.TASK_GROUP, Bank.TASK_ID_GOLD_SUM) > Bank.MAX_COIN then
    szMsg = "您存储的金币达到了您目前等级段允许存储的最大额度。"
  end
  if szMsg ~= "" then
    UiManager:OpenWindow(Ui.UI_INFOBOARD, szMsg)
    return
  end

  local tbMsg = {}
  tbMsg.szMsg = "您准备存入<color=224,181,100>" .. nGoldSaveCount .. "金币<color>。确定吗？"
  tbMsg.nOptCount = 2
  tbMsg.tbOptTitle = { "取消", "确定" }
  function tbMsg:Callback(nOptIndex, nGoldSaveCount)
    if nOptIndex == 2 then
      me.CallServerScript({ "BankCmd", "GoldSave", nGoldSaveCount })
    end
  end
  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, nGoldSaveCount)
end

-- 用来处理取出金币的操作
function uiBank:OnBtnDrawGold()
  local nGoldDrawCount = Edt_GetInt(self.UIGROUP, self.EDIT_GOLDDRAW)
  if not nGoldDrawCount then
    return
  end

  local nEfficientTime = me.GetTask(Bank.TASK_GROUP, Bank.TASK_ID_GOLD_EFFICIENT_DAY)
  local nGoldSum = me.GetTask(Bank.TASK_GROUP, Bank.TASK_ID_GOLD_SUM)
  local nGoldLimit = me.GetTask(Bank.TASK_GROUP, Bank.TASK_ID_GOLD_LIMIT)
  local nMaxTakeOutCount = nGoldLimit
  if nGoldSum < nGoldLimit then
    nMaxTakeOutCount = nGoldSum
  end
  local szMsg = ""
  if nGoldSum <= 0 then
    szMsg = szMsg .. "您没有在本钱庄存入金币。"
  elseif not nGoldDrawCount or nGoldDrawCount <= 0 or nGoldDrawCount > nMaxTakeOutCount then
    szMsg = szMsg .. "您的输入有误，请重新输入。"
  end
  if szMsg ~= "" then
    UiManager:OpenWindow(Ui.UI_INFOBOARD, szMsg)
    return
  end

  local tbMsg = {}
  tbMsg.szMsg = "您准备取出<color=224,181,100>" .. nGoldDrawCount .. "金币<color>。确定吗？"
  tbMsg.nOptCount = 2
  tbMsg.tbOptTitle = { "取消", "确定" }
  function tbMsg:Callback(nOptIndex, nGoldDrawCount)
    if nOptIndex == 2 then
      me.CallServerScript({ "BankCmd", "GoldDraw", nGoldDrawCount })
    end
  end
  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, nGoldDrawCount)
end

-- 取消未生效的金币支取上限
function uiBank:OnBtnCancelGoldLimit()
  local nEfficientTime = me.GetTask(Bank.TASK_GROUP, Bank.TASK_ID_GOLD_EFFICIENT_DAY)
  local nUnEfficientGoldLimit = me.GetTask(Bank.TASK_GROUP, Bank.TASK_ID_GOLD_UNEFFICIENT_LIMIT)
  if nEfficientTime == 0 or nUnEfficientGoldLimit == 0 then
    local szMsg = "<color=red>没有未生效的金币支取上限，操作失败！<color>"
    UiManager:OpenWindow(Ui.UI_INFOBOARD, szMsg)
    return
  end
  local szData = os.date("%Y年%m月%d日 %H:%M", nEfficientTime)
  local nGoldLimit = me.GetTask(Bank.TASK_GROUP, Bank.TASK_ID_GOLD_LIMIT)

  local tbMsg = {}
  tbMsg.szMsg = "您要取消的金币支取上限为<color=224,181,100>" .. nUnEfficientGoldLimit .. "<color>，将于<color=224,181,100>" .. szData .. "<color>生效。确定吗？"
  tbMsg.nOptCount = 2
  tbMsg.tbOptTitle = { "取消", "确定" }
  function tbMsg:Callback(nOptIndex)
    if nOptIndex == 2 then
      me.CallServerScript({ "BankCmd", "CancelGoldLimit" })
    end
  end
  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
end

-- 修改金币支取上限
function uiBank:OnBtnModifyGoldLimit()
  local nNewGoldLimit = Edt_GetInt(self.UIGROUP, self.EDIT_GOLDLIMIT)
  if not nNewGoldLimit or nNewGoldLimit <= 0 or nNewGoldLimit > Bank.MAX_COIN then
    local szMsg = "<color=red>您的输入有误，请重新输入。<color>"
    UiManager:OpenWindow(Ui.UI_INFOBOARD, szMsg)
    return
  end
  local nGoldLimit = me.GetTask(Bank.TASK_GROUP, Bank.TASK_ID_GOLD_LIMIT)
  local nTime = GetTime()
  local szData = ""
  if nNewGoldLimit <= nGoldLimit then
    szData = "现在"
  else
    nTime = nTime + 5 * self.DAYSECOND
    szData = os.date("%Y年%m月%d日 %H:%M", nTime)
  end

  local tbMsg = {}
  tbMsg.szMsg = "您新的金币支取上限为<color=224,181,100>" .. nNewGoldLimit .. "<color>，将于<color=224,181,100>" .. szData .. "<color>开始生效。确定吗？"
  tbMsg.nOptCount = 2
  tbMsg.tbOptTitle = { "取消", "确定" }
  function tbMsg:Callback(nOptIndex, nNewGoldLimit)
    if nOptIndex == 2 then
      me.CallServerScript({ "BankCmd", "ModifyGoldLimit", nNewGoldLimit })
    end
  end
  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, nNewGoldLimit)
end

-- 存入银两操作
function uiBank:OnBtnSaveSilver()
  local nSilverSaveCount = Edt_GetInt(self.UIGROUP, self.EDIT_SILVERSAVE)
  local nMaxSaveCount = me.nCashMoney
  local szMsg = ""
  if nMaxSaveCount <= 0 then
    szMsg = "您身上已经没有银两了，不能进行该操作。"
  elseif nSilverSaveCount <= 0 then
    szMsg = "您输入的数字有误，请重新输入。"
  elseif nSilverSaveCount > nMaxSaveCount then
    szMsg = "您身上银两不够，不能进行该操作。"
  elseif nSilverSaveCount + me.GetTask(Bank.TASK_GROUP, Bank.TASK_ID_SILVER_SUM) > Bank.MAX_MONEY then
    szMsg = "您存储的银两达到了您目前等级段允许存储的最大额度。"
  end
  if szMsg ~= "" then
    UiManager:OpenWindow(Ui.UI_INFOBOARD, szMsg)
    return
  end

  local tbMsg = {}
  tbMsg.szMsg = "您准备存入<color=224,181,100>" .. nSilverSaveCount .. "银两<color>。确定吗？"
  tbMsg.nOptCount = 2
  tbMsg.tbOptTitle = { "取消", "确定" }
  function tbMsg:Callback(nOptIndex, nSilverSaveCount)
    if nOptIndex == 2 then
      me.CallServerScript({ "BankCmd", "SilverSave", nSilverSaveCount })
    end
  end
  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, nSilverSaveCount)
end

-- 取出银两
function uiBank:OnBtnDrawSilver()
  local nSilverDrawCount = Edt_GetInt(self.UIGROUP, self.EDIT_SILVERDRAW)
  if not nSilverDrawCount then
    return
  end
  local nSilverSum = me.GetTask(Bank.TASK_GROUP, Bank.TASK_ID_SILVER_SUM)
  local nSilverLimit = me.GetTask(Bank.TASK_GROUP, Bank.TASK_ID_SILVER_LIMIT)
  local nMaxTakeOutCount = nSilverLimit
  if nSilverSum < nSilverLimit then
    nMaxTakeOutCount = nSilverSum
  end
  local szMsg = ""
  if nSilverSum <= 0 then
    szMsg = szMsg .. "您没有在本钱庄存入银两。"
  elseif not nSilverDrawCount or nSilverDrawCount <= 0 or nSilverDrawCount > nMaxTakeOutCount then
    szMsg = szMsg .. "您的输入有误，请重新输入。"
  end
  if szMsg ~= "" then
    UiManager:OpenWindow(Ui.UI_INFOBOARD, szMsg)
    return
  end

  local tbMsg = {}
  tbMsg.szMsg = "您准备取出<color=224,181,100>" .. nSilverDrawCount .. "银两<color>。确定吗？"
  tbMsg.nOptCount = 2
  tbMsg.tbOptTitle = { "取消", "确定" }
  function tbMsg:Callback(nOptIndex, nSilverDrawCount)
    if nOptIndex == 2 then
      me.CallServerScript({ "BankCmd", "SilverDraw", nSilverDrawCount })
    end
  end
  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, nSilverDrawCount)
end

-- 取消未生效的银两支取上限
function uiBank:OnBtnCancelSilverLimit()
  local nEfficientTime = me.GetTask(Bank.TASK_GROUP, Bank.TASK_ID_SILVER_EFFICIENT_DAY)
  local nUnEfficientSilverLimit = me.GetTask(Bank.TASK_GROUP, Bank.TASK_ID_SILVER_UNEFFICIENT_LIMIT)
  if nEfficientTime == 0 or nUnEfficientSilverLimit == 0 then
    local szMsg = "<color=red>没有未生效的银两支取上限，操作失败！<color>"
    UiManager:OpenWindow(Ui.UI_INFOBOARD, szMsg)
    return
  end
  local szData = os.date("%Y年%m月%d日 %H:%M", nEfficientTime)
  local nSilverLimit = me.GetTask(Bank.TASK_GROUP, Bank.TASK_ID_SILVER_LIMIT)

  local tbMsg = {}
  tbMsg.szMsg = "您要取消的银两支取上限为<color=224,181,100>" .. nUnEfficientSilverLimit .. "<color>，将于<color=224,181,100>" .. szData .. "<color>生效。确定吗？"
  tbMsg.nOptCount = 2
  tbMsg.tbOptTitle = { "取消", "确定" }
  function tbMsg:Callback(nOptIndex)
    if nOptIndex == 2 then
      me.CallServerScript({ "BankCmd", "CancelSilverLimit" })
    end
  end
  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
end

-- 修改银两支取上限
function uiBank:OnBtnModifySilverLimit()
  local nNewSilverLimit = Edt_GetInt(self.UIGROUP, self.EDIT_SILVERLIMIT)
  if not nNewSilverLimit or nNewSilverLimit <= 0 or nNewSilverLimit > Bank.MAX_COIN then
    local szMsg = "<color=red>您的输入有误，请重新输入。<color>"
    UiManager:OpenWindow(Ui.UI_INFOBOARD, szMsg)
    return
  end
  local nSilverLimit = me.GetTask(Bank.TASK_GROUP, Bank.TASK_ID_SILVER_LIMIT)
  local nTime = GetTime()
  local szData = ""

  if nNewSilverLimit <= nSilverLimit then
    szData = "现在"
  else
    nTime = nTime + 5 * self.DAYSECOND
    szData = os.date("%Y年%m月%d日 %H:%M", nTime)
  end

  local tbMsg = {}
  tbMsg.szMsg = "您新的银两支取上限为<color=224,181,100>" .. nNewSilverLimit .. "<color>，将于<color=224,181,100>" .. szData .. "<color>开始生效。确定吗？"
  tbMsg.nOptCount = 2
  tbMsg.tbOptTitle = { "取消", "确定" }
  function tbMsg:Callback(nOptIndex, nNewSilverLimit)
    if nOptIndex == 2 then
      me.CallServerScript({ "BankCmd", "ModifySilverLimit", nNewSilverLimit })
    end
  end
  UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg, nNewSilverLimit)
end

-- 对各个编辑框输入数字进行限制
function uiBank:OnEditChange(szWndName, nParam)
  local nCurPrice = 0
  local nCurNum = 0
  local nMaxCount = 0

  if not szWndName then
    assert(false)
    return
  end

  nCurNum = Edt_GetInt(self.UIGROUP, szWndName)
  if szWndName == self.EDIT_GOLDSAVE then
    nMaxCount = me.nCoin
  elseif szWndName == self.EDIT_GOLDDRAW then
    local nGoldLimit = me.GetTask(Bank.TASK_GROUP, Bank.TASK_ID_GOLD_LIMIT)
    local nGoldSum = me.GetTask(Bank.TASK_GROUP, Bank.TASK_ID_GOLD_SUM)
    nMaxCount = nGoldLimit
    if nGoldSum < nGoldLimit then
      nMaxCount = nGoldSum
    end
  elseif szWndName == self.EDIT_GOLDLIMIT then
    nMaxCount = Bank.MAX_COIN
  elseif szWndName == self.EDIT_SILVERSAVE then
    nMaxCount = me.nCashMoney
  elseif szWndName == self.EDIT_SILVERDRAW then
    local nSilverLimit = me.GetTask(Bank.TASK_GROUP, Bank.TASK_ID_SILVER_LIMIT)
    local nSilverSum = me.GetTask(Bank.TASK_GROUP, Bank.TASK_ID_SILVER_SUM)
    nMaxCount = nSilverLimit
    if nSilverSum < nSilverLimit then
      nMaxCount = nSilverSum
    end
  elseif szWndName == self.EDIT_SILVERLIMIT then
    nMaxCount = Bank.MAX_MONEY
  end

  if nCurNum < 0 then
    nCurNum = 0
  elseif nCurNum > nMaxCount then
    nCurNum = nMaxCount
  end

  if nCurNum == self.nCount or nCurNum == 0 then
    return
  end

  self.nCount = nCurNum
  Edt_SetTxt(self.UIGROUP, szWndName, self.nCount)
  self.nCount = 0
end

function uiBank:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_UPDATEBANKINFO, self.OnUpdateInfo, nCoin },
  }
  return tbRegEvent
end
