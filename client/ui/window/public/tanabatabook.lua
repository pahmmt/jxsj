-- 文件名　：tanabatabook.lua
-- 创建者　：zhangjunjie
-- 创建时间：2011-07-27 15:38:46
-- 描述：七夕书卷

local tbBook = Ui:GetClass("tanabatabook")

local szContentFile = "\\setting\\event\\jieri\\201108_Tanabata\\tanabatabook.txt"
local BTN_EXIT = "ExitBtn"
local BTN_BACK = "BackBtn"
local BTN_FORWARD = "ForwardBtn"
local TXT_PART = { "TxtPart1", "TxtPart2" }
local MAX_PART_NUM = 2 --最大页数

local function LoadContent()
  local tbContent = Lib:LoadTabFile(szContentFile)
  tbBook.tbContent = {}
  for nIndex, tbInfo in pairs(tbContent) do
    local nBooId = tonumber(tbInfo.BookId)
    local nPartId = tonumber(tbInfo.PartId)
    if not tbBook.tbContent[nBooId] then
      tbBook.tbContent[nBooId] = {}
    end
    tbBook.tbContent[nBooId][nPartId] = tbInfo.Content
  end
end

if not tbBook.tbContent then
  LoadContent()
end

function tbBook:OnClose()
  self.nCurrentBookIndex = 0
  self.nCurrentBookStart = 1 --当前起始页码
  for i = 1, MAX_PART_NUM do
    TxtEx_SetText(self.UIGROUP, TXT_PART[i], " ")
  end
end

function tbBook:PreOpen()
  self.nCurrentBookIndex = 0
  self.nCurrentBookStart = 1 --当前起始页码
end

function tbBook:OnButtonClick(szWnd, nParam)
  if szWnd == BTN_EXIT then
    UiManager:CloseWindow(self.UIGROUP)
  elseif szWnd == BTN_BACK then
    self:BackText()
  elseif szWnd == BTN_FORWARD then
    self:ForwardText()
  end
end

function tbBook:SetTextContent()
  local nStart = self.nCurrentBookStart
  for i = nStart, nStart + 1 do
    if self.tbContent[self.nCurrentBookIndex] then
      if self.tbContent[self.nCurrentBookIndex][i] then
        TxtEx_SetText(self.UIGROUP, TXT_PART[(i % 2) == 0 and 2 or 1], self.tbContent[self.nCurrentBookIndex][i])
      else
        TxtEx_SetText(self.UIGROUP, TXT_PART[(i % 2) == 0 and 2 or 1], " ")
      end
    end
  end
end

function tbBook:BackText()
  local nPartIndex = self.nCurrentBookStart - MAX_PART_NUM
  if nPartIndex < 1 or not self.tbContent[self.nCurrentBookIndex] or not self.tbContent[self.nCurrentBookIndex][nPartIndex] then
    return 0
  end
  self.nCurrentBookStart = self.nCurrentBookStart - MAX_PART_NUM
  self:SetTextContent()
end

function tbBook:ForwardText()
  local nPartIndex = self.nCurrentBookStart + MAX_PART_NUM
  if not self.tbContent[self.nCurrentBookIndex] or not self.tbContent[self.nCurrentBookIndex][nPartIndex] then
    return 0
  end
  self.nCurrentBookStart = self.nCurrentBookStart + MAX_PART_NUM
  self:SetTextContent()
end

function tbBook:OnOpen(nIndex)
  if not nIndex or nIndex <= 0 then
    return 0
  end
  self.nCurrentBookIndex = nIndex
  self:SetTextContent()
end
