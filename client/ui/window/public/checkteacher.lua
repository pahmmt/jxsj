-----------------------------------------------------
--文件名		：	checkteacher.lua
--创建者		：	tongxuehu@kingsoft.net
--创建时间		：	2007-8-3
--功能描述		：	检查师傅/徒弟是否满足需求的界面
------------------------------------------------------

local uiCheckTeacher = Ui:GetClass("checkteacher")

local BUTTON_SETP_1 = "BtnStep1"
local BUTTON_SETP_2 = "BtnStep2"
local BUTTON_SETP_3_1 = "BtnStep3_1"
local BUTTON_SETP_3_2 = "BtnStep3_2"
local BUTTON_CLOSE = "BtnClose"

function uiCheckTeacher:OnOpen(tbParam)
  self.szPlayer = tbParam[1]
  self.nTOrSFlag = tbParam[2]
end

function uiCheckTeacher:Init()
  self.nTOrSFlag = -1 -- 1拜师 0收徒
  self.szPlayer = ""
end

function uiCheckTeacher:OnButtonClick(szWnd, nParam)
  if szWnd == BUTTON_SETP_1 then
    me.TrainingCheck(self.szPlayer)
  elseif szWnd == BUTTON_SETP_2 then
    SendChatMsg("/" .. self.szPlayer .. " 请问你每周都是哪几天上线？每天又大概是什么时候呢？")
  elseif szWnd == BUTTON_SETP_3_1 then
    me.CallServerScript({ "RelationCmd", "AddRelation_C2S", self.szPlayer, Player.emKPLAYERRELATION_TYPE_TMPFRIEND })
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == BUTTON_SETP_3_2 then
    me.CallServerScript({ "RelationCmd", "TrainingResponse_C2S", self.nTOrSFlag, self.szPlayer, 0 })
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == BUTTON_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  end
end
