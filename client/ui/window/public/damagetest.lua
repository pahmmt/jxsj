----------------------------------------
-- 显示受到的伤害 仅供测试用，不能用于别的地方
-- ZhangDeheng
-- 2008/11/6  14:41
----------------------------------------

local uiDamageTest = Ui:GetClass("damagetest")

uiDamageTest.IsOpen = 0
uiDamageTest.TEXTE_MSG = "TxtMsg"
uiDamageTest.SHOW_TEXT = "总测试时间：%s\n受伤害总量：<color=White>%s<color>\n生命回复量：<color=White>%s<color>\n有效回复率：<color=White>%.2f%%<color>\n"
uiDamageTest.nTime = 0
uiDamageTest.nDamage = 0
uiDamageTest.nDrug = 0

-- 初始化
function uiDamageTest:Init() end

function uiDamageTest:OnOpen() end

-- 对外调用 当需要打开计时面板时调用
function uiDamageTest:OpenWindow()
  if uiDamageTest.IsOpen == 0 then
    uiDamageTest.IsOpen = 1
    UiManager:CloseWindow(Ui.UI_TASKTRACK) -- 关闭任务跟踪
    UiManager:OpenWindow(Ui.UI_DAMAGETEST)
    uiDamageTest.nTimerId = Timer:Register(Env.GAME_FPS, uiDamageTest.Refresh, uiDamageTest)
    SendChannelMsg("GM", "?pl FightSkill:StartDamageAccount(me.nId)")
  else
    uiDamageTest.IsOpen = 0
    UiManager:OpenWindow(Ui.UI_TASKTRACK) -- 任务跟踪
    UiManager:CloseWindow(Ui.UI_DAMAGETEST)
  end
end

function uiDamageTest:Refresh()
  uiDamageTest.nTime = uiDamageTest.nTime + 1
  local szMsg = ""
  if uiDamageTest.nTime > 3600 then
    local nHour = math.floor(uiDamageTest.nTime / 3600)
    local nMin = math.floor((uiDamageTest.nTime % 3600) / 60)
    szMsg = string.format("<color=White>%d小时%d分！<color>", nHour, nMin)
  else
    local nMin = math.floor(uiDamageTest.nTime / 60)
    local nSec = math.floor(uiDamageTest.nTime % 60)
    szMsg = string.format("<color=White>%d分%d秒！<color>", nMin, nSec)
  end

  local nPercent = 100
  if uiDamageTest.nDamage < uiDamageTest.nDrug and uiDamageTest.nDrug ~= 0 then
    nPercent = uiDamageTest.nDamage * 100 / uiDamageTest.nDrug
  end

  szMsg = string.format(uiDamageTest.SHOW_TEXT, szMsg, uiDamageTest.nDamage, uiDamageTest.nDrug, nPercent)
  Txt_SetTxt(Ui.UI_DAMAGETEST, uiDamageTest.TEXTE_MSG, szMsg)
end

function uiDamageTest:RefreshMsg(nDamage, nDrug)
  if nDamage ~= 0 then
    uiDamageTest.nDamage = nDamage
  end
  if nDrug ~= 0 then
    uiDamageTest.nDrug = uiDamageTest.nDrug + nDrug
  end
end

function uiDamageTest:OnClose()
  SendChannelMsg("GM", "?pl FightSkill:EndDamageAccount(me.nId)")
  uiDamageTest.IsOpen = 0
  uiDamageTest.nDamage = 0
  uiDamageTest.nDrug = 0
  uiDamageTest.nTime = 0
  if uiDamageTest.nTimerId then
    Timer:Close(uiDamageTest.nTimerId)
    uiDamageTest.nTimerId = nil
  end
end
-- 对外 关闭计时面板时调用
function uiDamageTest:CloseWindow()
  UiManager:CloseWindow(Ui.UI_DAMAGETEST)
end
