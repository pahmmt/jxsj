-------------------------------------------------------
-- 文件名　：playerEditor.lua
-- 创建者　：sutingwei
-- 创建时间：2012/8/20 9:01:35
-- 文件描述：角色属性面板声望Scroll面板简易编辑器
-------------------------------------------------------

local tbPlayerEditor = Ui:GetClass("playereditor")
local tbObject = Ui.tbLogic.tbObject
local tbMouse = Ui.tbLogic.tbMouse
local tbPreViewMgr = Ui.tbLogic.tbPreViewMgr
local tbTempData = Ui.tbLogic.tbTempData
local tbTempItem = Ui.tbLogic.tbTempItem

tbPlayerEditor.EDITOR = "EdtText"
tbPlayerEditor.EDITORSHOW = "ReputeInfoWndTxtExShow"
tbPlayerEditor.BTNCLOSE = "BtnClose"
tbPlayerEditor.SAVEFILE = "SaveFile"
tbPlayerEditor.SAVEFILETITLE = "EdtTitle"
tbPlayerEditor.CLEAREDITOR = "ClearFile"

tbPlayerEditor.SZFILENAMEFIX = "\\setting\\others\\"
tbPlayerEditor.SZTALE = ".txt"

tbPlayerEditor.NUM_LABEL = 20
tbPlayerEditor.BTN_LABEL = {}
for i = 1, tbPlayerEditor.NUM_LABEL do
  tbPlayerEditor.BTN_LABEL[i] = { "label" .. i }
end

function tbPlayerEditor:OnCreate() end

function tbPlayerEditor:OnDestroy() end

-- 打开
function tbPlayerEditor:OnOpen()
  self:ReadCfgFile()
  self:SetButton()
end

-- 关闭
function tbPlayerEditor:OnClose() end

function tbPlayerEditor:OnEditChange(szWnd)
  if szWnd == self.EDITOR then
    local szText = Edt_GetTxt(self.UIGROUP, self.EDITOR)
    TxtEx_SetText(self.UIGROUP, self.EDITORSHOW, szText)
  end
end

function tbPlayerEditor:OnButtonClick(szWnd, nParam)
  if szWnd == self.BTNCLOSE then
    UiManager:CloseWindow(Ui.UI_PLAYEREDITOR)
    return
  end
  if szWnd == self.SAVEFILE then
    self:SaveFile()
    return
  end
  if szWnd == self.CLEAREDITOR then
    Edt_SetTxt(self.UIGROUP, self.EDITOR, "")
    return
  end
  if self.tbLabelConfig then
    for i = 1, #self.tbLabelConfig do
      if szWnd == self.BTN_LABEL[i][1] then
        self:AddLable(szWnd)
        return
      end
    end
  end
end

function tbPlayerEditor:SaveFile()
  local szText = Edt_GetTxt(self.UIGROUP, self.EDITOR)
  local szTitle = Edt_GetTxt(self.UIGROUP, self.SAVEFILETITLE)
  if szTitle ~= "" then
    KIo.WriteFile(self.SZFILENAMEFIX .. szTitle .. self.SZTALE, szText)
  end
end

function tbPlayerEditor:ReadCfgFile()
  local tbLabel = Lib:LoadTabFile("\\setting\\player\\lableedit.txt")

  if not tbLabel then -- 如果读取失败则直接返回 不执行下面的步骤
    return
  end
  self.tbLabelConfig = {}
  self.tbLabelSpc = {}
  if #tbLabel > 0 then
    for i = 1, #tbLabel do
      self.tbLabelConfig[i] = tbLabel[i]
    end
    for i = 1, #tbLabel do --	点击的时候便于寻址
      self.tbLabelSpc["label" .. i] = tbLabel[i].Info
    end
  end
end

function tbPlayerEditor:SetButton()
  if not self.tbLabelConfig then
    return
  end
  for i = 1, #self.tbLabelConfig do
    Btn_SetTxt(self.UIGROUP, self.BTN_LABEL[i][1], self.tbLabelConfig[i].Label)
  end
end

function tbPlayerEditor:AddLable(szWnd)
  local szText = Edt_GetTxt(self.UIGROUP, self.EDITOR)
  local szLabel = self.tbLabelSpc[szWnd]
  local szAdded = szText .. szLabel
  Edt_SetTxt(self.UIGROUP, self.EDITOR, szAdded)
end
