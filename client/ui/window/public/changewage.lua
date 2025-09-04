-----------------------------------------------------
--文件名		：	changewage.lua
--创建者		：	zhengyuhua
--创建时间		：	2007-10-15
--功能描述		：	调整帮会工资水平界面
------------------------------------------------------

local uiChangeWage = Ui:GetClass("changewage")

local BUTTON_OK = "BtnOk"
local BUTTON_CANCEL = "BtnCancel"
local BUTTON_CLOSE = "BtnClose"
local TEXT_WAGE_LEVEL = "TxtWageLevel"
local TEXT_CALC_TOTAL_WAGE = "TxtCalcTotalWage"
local SCRBAR_WAGE_LEVEL = "ScrbarWageLevel"
local TEXT_WAGE_EXPLAIN_INFO = "TxtExplainInfo"

local WAGE_INFO = "任何有帮会股份的帮会正式成员，均可以到“武林盟主特使”处领取帮会分红。帮会分红每周发放一次，发放的分红会从帮会建设资金里扣除。调整分红比例将消耗 100帮会行动力，并且对分红比例的修改将会在下一周生效。"

function uiChangeWage:Init()
  self.nCurLevel = 0
  self.nPreWage = 0
  self.nBuildFund = 0
end

function uiChangeWage:InitWage()
  Txt_SetTxt(self.UIGROUP, TEXT_WAGE_EXPLAIN_INFO, WAGE_INFO)
  local tbCount = self:GetCrowdCount()
end

function uiChangeWage:OnOpen(nLevel, nFund)
  if nLevel then
    self.nCurLevel = nLevel
  end
  if nFund then
    self.nBuildFund = nFund
  end
  self:InitWage()
  ScrBar_SetCurValue(self.UIGROUP, SCRBAR_WAGE_LEVEL, self.nCurLevel)
  self:UpdateCurWage()
end

-- 滚动栏移动响应函数
function uiChangeWage:OnScorllbarPosChanged(szWnd, nParam)
  if szWnd == SCRBAR_WAGE_LEVEL then
    self.nCurLevel = nParam
    self:UpdateCurWage()
  end
end

function uiChangeWage:OnButtonClick(szWnd, nParam)
  if (szWnd == BUTTON_CANCEL) or (szWnd == BUTTON_CLOSE) then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == BUTTON_OK then
    me.CallServerScript({ "TongCmd", "ChangeTakeStock", self.nCurLevel })
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiChangeWage:UpdateCurWage()
  Txt_SetTxt(self.UIGROUP, TEXT_WAGE_LEVEL, "分红比例： " .. self.nCurLevel)
  self:UpdateCurPreWage()
end

function uiChangeWage:UpdateCurPreWage()
  local nFund = math.ceil(self.nBuildFund * self.nCurLevel / 100)
  Txt_SetTxt(self.UIGROUP, TEXT_CALC_TOTAL_WAGE, "预计消耗： " .. nFund)
end

-- [[ 暂时去掉，可能以后还会用 zhengyuhua
function uiChangeWage:GetCrowdCount()
  local nCaptain = 0
  local nEmissary = 0
  local nExcellent = 0
  local nNormal = 0
  local nSigned = 0
  local pTong = KTong.GetSelfTong()
  local pKinIt = pTong.GetKinItor()
  local pCurKin = pKinIt.GetCurKin()
  while pCurKin do
    local cMemberItor = pCurKin.GetMemberItor()
    local cMember = cMemberItor.GetCurMember()
    while cMember do
      local nFigure = cMember.GetFigure()
      if nFigure == 1 then
        nCaptain = nCaptain + 1
      elseif cMember.GetEnvoyFigure() ~= 0 then
        nEmissary = nEmissary + 1
      elseif cMember.GetBitExcellent() == 1 then
        nExcellent = nExcellent + 1
      end
      if nFigure < Kin.FIGURE_SIGNED then
        nNormal = nNormal + 1
      elseif nFigure == Kin.FIGURE_SIGNED then
        nSigned = nSigned + 1
      end
      cMember = cMemberItor.NextMember()
    end
    pCurKin = pKinIt.NextKin()
  end
  return { nCaptain, nEmissary, nExcellent, nNormal, nSigned }
end
-- ]]
