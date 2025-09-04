-------------------------------------------------------
-- 文件名　 : kingetsalary.lua
-- 创建者　 : zhangjinpin@kingsoft
-- 创建时间 : 2012-07-02 15:31:01
-- 文件描述 :
-------------------------------------------------------

local uiKinGetSalary = Ui:GetClass("kingetsalary")

uiKinGetSalary.BTN_CLOSE = "BtnClose"
uiKinGetSalary.BTN_GET_SALARY = "BtnGetSalary"

uiKinGetSalary.TXT_YINDING = "TxtYinDing"
uiKinGetSalary.TXT_BASE = "TxtIcon01"
uiKinGetSalary.TXT_EXTRA = "TxtIcon02"
uiKinGetSalary.TXT_YUANBAO = "TxtIcon03"

function uiKinGetSalary:OnRecvData(tbInfo)
  if not tbInfo then
    return 0
  end
  Txt_SetTxt(self.UIGROUP, self.TXT_YINDING, string.format("当前可领取的家族银锭为：<color=yellow>%s<color>", tbInfo.nTotal or 0))
  Txt_SetTxt(self.UIGROUP, self.TXT_BASE, string.format("基础银锭\n<color=yellow>%s<color>", tbInfo.nSalary or 0))
  Txt_SetTxt(self.UIGROUP, self.TXT_EXTRA, string.format("家族总工资加成\n<color=yellow>%s<color>", (tbInfo.nTotal or 0) - (tbInfo.nSalary or 0)))
  if (tbInfo.nVipPlayer or 0) >= tonumber(GetLocalDate("%Y%m")) then
    Txt_SetTxt(self.UIGROUP, self.TXT_YUANBAO, string.format("<color=green>家族金元宝<color>\n<color=yellow>%s<color>", math.floor((tbInfo.nTotal or 0) / 1000)))
  else
    Txt_SetTxt(self.UIGROUP, self.TXT_YUANBAO, string.format("<color=red>家族金元宝<color>\n<color=white>%s<color>", "几率获得"))
  end
end

function uiKinGetSalary:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == self.BTN_GET_SALARY then
    me.CallServerScript({ "ApplyKinGetSalary" })
    UiManager:CloseWindow(self.UIGROUP)
  end
end
