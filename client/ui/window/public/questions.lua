-- 文件名　：questions.lua
-- 创建者　：sunduoliang
-- 创建时间：2009-12-18 10:58:19
-- 描述　  ：

local UiQuest = Ui:GetClass("questions")
UiQuest.BTN_CLOSE = "BtnClose"
UiQuest.IE_WND = "IEWnd"

--第一个字段是游戏，例如：jxsj
--第二个字段玩家passport, 例如： testet321
--第三个字段玩家所在唯一标识区服，例如： gateway这个字段, 剑三的就是 z01, z02 之类的
--第三个字段玩家的游戏角色名；例如： 角色名
--第四个字段是区名，例如：电信区，没有就为 -
--第五个字段就服名，例如：
--第六个字段就是等级，例如：32
--#
--CRC32校验码
--#
--16位随机码

function UiQuest:OnOpen(szHttp)
  local szRetUrl = szHttp .. "?k="
  local szGate = GetGatewayName()
  local szStr = string.sub(szGate, 5, 6)
  local SUV = "电信"
  local tbSerSuv = {
    ["02"] = "网通",
    ["05"] = "网通",
    ["11"] = "网通",
  }
  SUV = tbSerSuv[szStr] or SUV
  local szServerName = GetServerName()
  szServerName = string.gsub(szServerName, "^【.*%s+([^ ]*)】.*$", "%1")
  szServerName = string.gsub(szServerName, "^([^ ]*)%s+%-%s+.*$", "%1")
  szServerName = string.gsub(szServerName, "^%s*(.-)%s*$", "%1")
  local szOldUrl = "jxsj" .. " " .. me.szAccount .. " " .. szGate .. " " .. me.szName .. " " .. SUV .. " " .. szServerName .. " " .. me.nLevel
  --local szOldUrl = SUV.." "..szServerName.." "..szGate.." "..me.szAccount.." "..me.szName.." "..me.nLevel;
  --print(szOldUrl);
  local nCRC = TOOLS_MiscCRC32(szOldUrl)
  local szUrl = szOldUrl .. "#" .. nCRC .. "#" .. self:GetRandom16Num()
  local szEncryptUrl = TOOLS_EncryptBase64(szUrl)
  local sz16EncryptUrl = TOOLS_To16Str(szEncryptUrl, string.len(szUrl)) .. "&open"
  IE_Navigate(self.UIGROUP, self.IE_WND, szRetUrl .. sz16EncryptUrl)
  --print(sz16EncryptUrl);
  Wnd_SetFocus(self.UIGROUP, self.EDIT_SEARCH)
end

function UiQuest:GetRandom16Num()
  local szStr = ""
  for i = 1, 16 do
    szStr = szStr .. MathRandom(0, 9)
  end
  return szStr
end

function UiQuest:OnIeComplete(szWnd, szUrl)
  if szWnd == self.IE_WND then
    local nStart, nEnd = string.find(szUrl, "about:blank")
    if nStart and nStart >= 0 then
      --local nStatus = tonumber(string.sub(szUrl, nEnd+1, -1)) or 0;
      --如果答题完跳转了，说明答完
      me.CallServerScript({ "Questionnaires", 1 })
      self:OnEscExclusiveWnd()
      return 0
    end
  end
end

function UiQuest:OnEscExclusiveWnd()
  UiManager:CloseWindow(self.UIGROUP)
end

function UiQuest:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTN_CLOSE then
    UiManager:CloseWindow(self.UIGROUP)
  end
end
