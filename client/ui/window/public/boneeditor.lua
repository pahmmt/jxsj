-------------------------------------------------------
----文件名		：	boneeditor.lua
----创建者		：	xuantao@kingsoft.com
----创建时间	：	2012/7/27 9:44:52
----功能描述	：	骨骼动画配置编辑器
--------------------------------------------------------

local uiWnd = Ui:GetClass("boneeditor")

local MODEL_PATH = "\\model\\"
local MODEL_CFG_PATH = "\\setting\\model\\"
local PRODUCT_PATH = "\\setting\\model\\product\\"

local WND_MAIN = "Main"
local BONE_EDITER = "BontEditor"
local TXT_ERROR = "Z_Txt_Error_Message"

local TXT_MODEL_INFO = "Txt_Model_Info"
-- button op -- final btn state
local BTN_CLOSE = "Btn_Close" -- 关闭按钮
local BTN_CLOSE_WND = "Btn_Close_Wnd"
local BTN_SAVE_EDT = "Btn_Save_Cfg"
local BTN_GIVEUP_EDT = "Btn_Give_Up"
-- base property
local BTN_SELECT_MALE = "Btn_Select_Male"
local BTN_SELECT_FMALE = "Btn_Select_Fmale"
local BTN_HEAD_SHOW = "Btn_Head_Res_Show"
local BTN_ARMOR_SHOW = "Btn_Armor_Res_Show"
local BTN_WEAPON_SHOW = "Btn_Weapon_Res_Show"
local BTN_HORSE_SHOW = "Btn_Horse_Res_Show"
local BTN_MANTLE_SHOW = "Btn_Mantle_Res_Show"
local BTN_WIND_SHOW = "Btn_Wind_Res_Show"
local EDT_HEAD_RES = "Edt_Head_Res"
local EDT_ARMOR_RES = "Edt_Armor_Res"
local EDT_WEAPON_RES = "Edt_Weapon_Res"
local EDT_HORSE_RES = "Edt_Horse_Res"
local EDT_MANTLE_RES = "Edt_Mantle_Res"
local EDT_WIND_RES = "Edt_Wind_Res"
local SD_OVRE_RES_EDT = "Z_Sd_Over_Res_Edt"
-- control cfg
local BTN_AUTO_PLAY = "Btn_Auto_Play"
local BTN_AUTO_TURN = "Btn_Auto_Turn"
local BTN_PREV_FRAME = "Btn_Prev_Frame"
local BTN_NEXT_FRAME = "Btn_Next_Frame"
local EDT_FRAME_SET = "Edt_Frame_Set"
local BTN_PREV_DIR = "Btn_Prev_Dir"
local BTN_NEXT_DIR = "Btn_Next_Dir"
local EDT_DIR_SET = "Edt_Dir_Set"
local BTN_ADD_INTERVAL = "Btn_Next_Interval"
local BTN_SUB_INTERVAL = "Btn_Prev_Inerval"
local EDT_INTERVAL_SET = "Edt_Interval_Set"
-- animation cfg
local BTN_GENERATE = "Btn_Generate"
local BTN_SELECT_ACTION = "Btn_Select_Action"
local BTN_SELECT_PART = "Btn_Select_Part"
local TXT_CUR_ACTION = "Txt_Cur_Action"
local TXT_SELECT_PART = "Txt_Cur_Part"
local TXT_SKELETON = "Txt_Skeleton_Input"
local TXT_ANIMATION = "Txt_Animation_Input"
local TXT_CFG_FILE = "Txt_Cfg_File"
local BTN_SCHEME_1 = "Btn_Scheme_1"
local BTN_SCHEME_2 = "Btn_Scheme_2"
local BTN_SCHEME_3 = "Btn_Scheme_3"
local EDT_INPUT_BONE = "Edt_Input_Bone"
local CMB_SELECT_BONE = "Cmb_Bone_Name"
local CMB_SELECT_DIR = "Cmb_Bone_Dir"
local LST_BONE_LIST = "Lst_Bone_Name_List"
local LST_BONE_LIST_TITLE = "Lst_Bone_List_Title"
local LST_BONE_DETAIL = "Lst_Bone_Detail"
local LST_BONE_DETAIL_TITLE = "Lst_Bone_Detail_Title"
local BTN_FORCE_SHOW_BONE = "Btn_Force_Show_Bone"
local EDT_BONE_EFFECT = "Edt_Bone_Effect"
local SD_OVER_BONE_SHOW = "Z_Sd_Over_Show"
-- 列表选择框
local SD_LST_SELECT = "Z_SD_LIST_BACK"
local IMG_LST_SELECT = "Img_Select_List_Back"
local BTN_LST_OK = "Btn_Select_OK"
local BTN_LST_CANCEL = "Btn_Select_Cancel"
local LST_SELECT = "Lst_Select"
local TXT_SELECT_TITLE = "Txt_Select_Title"
-- 编辑框
local IMG_INPUT_EDT = "Img_Input_Edt"
local EDT_INPUT_INFO = "Edt_Input_Text"
local TXT_INPUT_TITLE = "Txt_Input_Title"
local BTN_INPUT_OK = "Btn_Input_Accept"
local BTN_INPUT_CANCEL = "Btn_Input_Cancel"

-- 组件配置文件
local tbPartModelCfg = {
  ["helm"] = { szMale = "", szFemale = "" },
  ["armor"] = { szMale = "", szFemale = "" },
  ["weapon"] = { szMale = "", szFemale = "" },
  ["horse"] = { szMale = "m_horse.txt", szFemale = "m_horse.txt" }, -- 目前就配置了马匹吧
  ["mantle"] = { szMale = "", szFemale = "" },
  ["wind"] = { szMale = "", szFemale = "" },
}
-- 列表选择框
local tbSelList = {}
-- 初始化
function tbSelList:init(szUiGroup, szTitle, tbList, tbOnOk, tbOnCancel, szCurSel)
  -- 必要的参数检查
  assert(tbOnOk and tbList)

  self.szTitle = szTitle or ""
  self.szCurSel = szCurSel or ""
  self.szUiGroup = szUiGroup -- 目标界面
  self.tbList = tbList -- 列表
  self.tbCallBack = tbOnOk -- 回调函数
  self.tbCancel = tbOnCancel -- 取消回调
end
-- 切换选择列表内容
function tbSelList:ChangeList(tbList)
  assert(tbList)
  self.tbList = tbList
end
-- 显示选择列表框
function tbSelList:Show(x, y)
  Lst_Clear(self.szUiGroup, LST_SELECT)

  for i, szValue in ipairs(self.tbList) do
    if self.szCurSel == szValue then
      Lst_SetCell(self.szUiGroup, LST_SELECT, i, 0, "√")
    else
      Lst_SetCell(self.szUiGroup, LST_SELECT, i, 0, "")
    end
    Lst_SetCell(self.szUiGroup, LST_SELECT, i, 1, szValue)
  end

  Txt_SetTxt(self.szUiGroup, TXT_SELECT_TITLE, self.szTitle or "")
  Wnd_Show(self.szUiGroup, IMG_LST_SELECT)
  Wnd_Show(self.szUiGroup, SD_LST_SELECT)
  Wnd_Hide(self.szUiGroup, IMG_INPUT_EDT)
  if x and y then
    Wnd_SetPos(self.szUiGroup, IMG_LST_SELECT, x, y)
  end
end
-- 隐藏选择列表框
function tbSelList:Hide()
  Wnd_Hide(self.szUiGroup, SD_LST_SELECT)
end
-- 点击列表项
function tbSelList:OnSelect(nKey)
  local szValue = self.tbList[nKey]
  if not szValue then
    return
  end

  self.tbSelMap = { [szValue] = nKey }
  self.tbSelArray = { szValue }
  table.insert(self.tbCallBack, szValue)
  table.insert(self.tbCallBack, nKey)
  Lib:CallBack(self.tbCallBack)
  table.remove(self.tbCallBack, #self.tbCallBack)
  table.remove(self.tbCallBack, #self.tbCallBack)

  self:Hide()
end
-- 点击OK
function tbSelList:OnOk()
  --	if self.nMaxSel > 1 then
  --		self.tbSelMap = self.tbSelMapTemp;
  --		self.tbSelArray = self.tbSelArrayTemp;
  --		self.tbSelMapTemp = nil;
  --		self.tbSelArrayTemp = nil;
  --
  --		table.insert(self.tbCallBack, self.tbSelMap);
  --		Lib:CallBack(self.tbCallBack);
  --		table.remove(self.tbCallBack, #self.tbCallBack);
  --	end
  self:Hide()
end
-- 点击取消
function tbSelList:OnCancel()
  if self.tbOnCancel then
    Lib:CallBack(self.tbOnCancel)
  end

  self:Hide()
end
---------------------------------------------------------------------------------
-- 输入编辑框
local tbInput = {}
function tbInput:init(szUiGroup, szTitle, tbCallBack, tbCancel, szDefault)
  assert(szUiGroup and tbCallBack)
  self.szDefault = szDefault or ""
  self.szUiGroup = szUiGroup
  self.szTitle = szTitle or "输入框"
  self.tbCallBack = tbCallBack
  self.tbCancel = tbCancel
end

function tbInput:OnOk()
  local szTxt = Edt_GetTxt(self.szUiGroup, EDT_INPUT_INFO)
  table.insert(self.tbCallBack, szTxt)
  Lib:CallBack(self.tbCallBack)
  table.remove(self.tbCallBack, #self.tbCallBack)
  self:Hide()
end

function tbInput:OnCancel()
  if self.tbCancel then
    Lib:CallBack(self.tbCancel)
  end
  self:Hide()
end

function tbInput:Show(x, y)
  Txt_SetTxt(self.szUiGroup, TXT_INPUT_TITLE, self.szTitle)
  Edt_SetTxt(self.szUiGroup, EDT_INPUT_INFO, self.szDefault)

  Wnd_Hide(self.szUiGroup, IMG_LST_SELECT)
  Wnd_Show(self.szUiGroup, SD_LST_SELECT)
  Wnd_Show(self.szUiGroup, IMG_INPUT_EDT)
  --	print("tbInput:Show", x, y, IMG_LST_SELECT, SD_LST_SELECT, IMG_INPUT_EDT)
  if x and y then
    Wnd_SetPos(self.szUiGroup, IMG_INPUT_EDT, x, y)
  end
  Wnd_SetFocus(self.szUiGroup, EDT_INPUT_INFO)
end

function tbInput:Hide()
  Wnd_Hide(self.szUiGroup, SD_LST_SELECT)
end
---------------------------------------------------------------------------------
-- tbPropertyMeta，基础属性元表
local tbPropertyMeta = {
  tbGet = {
    ["nDir"] = 1,
    ["nAction"] = 1,
    --		["szSkeleton"]	= 1,
    --		["szAnimation"]	= 1,
    ["szNpcType"] = 1,
    ["nEffect"] = 1,
    ["bAutoPlay"] = 1,
    ["bAutoTurn"] = 1,
    ["nInterval"] = 1,
    ["nFrame"] = 1,
    ["bForceShow"] = 1,
    ["nResHelm"] = 1,
    ["nResArmor"] = 1,
    ["nResWeapon"] = 1,
    ["nResHorse"] = 1,
    ["nResMantle"] = 1,
    ["nResWind"] = 1,
    ["nFrameNum"] = 1,
    ["bShowHelm"] = 1,
    ["bShowArmor"] = 1,
    ["bShowWeapon"] = 1,
    ["bShowHorse"] = 1,
    ["bShowMantle"] = 1,
    ["bShowWind"] = 1,
  },
  tbSet = {
    ["nDir"] = 1,
    ["nAction"] = 1,
    --		["szSkeleton"]	= 1,
    --		["szAnimation"]	= 1,
    ["szNpcType"] = 1,
    ["nEffect"] = 1,
    ["bAutoPlay"] = 1,
    ["bAutoTurn"] = 1,
    ["nInterval"] = 1,
    ["nFrame"] = 1,
    ["bForceShow"] = 1,
    ["nResHelm"] = 1,
    ["nResArmor"] = 1,
    ["nResWeapon"] = 1,
    ["nResHorse"] = 1,
    ["nResMantle"] = 1,
    ["nResWind"] = 1,
    ["bShowHelm"] = 1,
    ["bShowArmor"] = 1,
    ["bShowWeapon"] = 1,
    ["bShowHorse"] = 1,
    ["bShowMantle"] = 1,
    ["bShowWind"] = 1,
  },
}

function tbPropertyMeta.__index(_, szType)
  if szType and tbPropertyMeta.tbGet[szType] and 1 == tbPropertyMeta.tbGet[szType] then
    return BE_GetParam(Ui.UI_BONE_EDITOR, BONE_EDITER, "GetProperty", szType)
  end
end

function tbPropertyMeta.__newindex(_, szType, Value)
  if szType and Value and tbPropertyMeta.tbSet[szType] and 1 == tbPropertyMeta.tbSet[szType] then
    return BE_SetParam(Ui.UI_BONE_EDITOR, BONE_EDITER, "SetProperty", { [szType] = Value })
  end
end

-----------------------------------------------------------------------------------------------------
-- 窗口函数
function uiWnd:OnCreate()
  -- 编辑框零食数据
  self.szEdtTemp = ""
  self.szEdtFocus = ""
  -- 基础属性
  self.tbProperty = {}
  setmetatable(self.tbProperty, tbPropertyMeta)
  -- 当前的选择列表框
  self.tbCurSelList = nil
  -- 动作选择
  self.tbAction = self:_LoadAction()
  -- 组件选择
  self.tbPart = { "helm", "armor", "weapon", "horse", "mantle", "wind" }
  -- 动画配置
  self.tbAnimationCfg = { nScheme = 0, tbScheme = {}, szPart = "" }
  -- 定时更新的定时器
  self.nUpdateTimer = nil
end

function uiWnd:OnOpen()
  -- 动画配置
  -- self.tbAnimationCfg = {nScheme = 0, tbScheme = {}, szPart = ""};
  -- 骨骼数据
  self.tbBoneData = {
    tbBoneMap = {},
    tbBoneList = {},
    tbTitleSel = {},
  }
  -- 动画数据,骨骼对应的帧数据
  self.tbAniData = {}
  -- 部件
  self.tbDetail = {}

  if not self.tbModelCfg then
    self.tbModelCfg = self:_LoadModelCfg()
  end
  assert(self.tbModelCfg)

  -- 是否正在编辑
  self.bEditing = 0
  -- 是否需要保存
  self.bNeedSave = 0
  -- 当前选择编辑的方向
  self.nCurSelDir = 0
  -- 选前选择编辑的骨骼
  self.nCurSelBone = 0

  -- 控件初始化
  Lst_SetCell(self.UIGROUP, LST_BONE_LIST_TITLE, 1, 0, "名称")
  Lst_SetCell(self.UIGROUP, LST_BONE_LIST_TITLE, 1, 1, "显示")
  Lst_SetCell(self.UIGROUP, LST_BONE_LIST_TITLE, 1, 2, "包含")

  Lst_SetCell(self.UIGROUP, LST_BONE_DETAIL_TITLE, 1, 0, "帧")
  Lst_SetCell(self.UIGROUP, LST_BONE_DETAIL_TITLE, 1, 1, "归属")
  Lst_SetCell(self.UIGROUP, LST_BONE_DETAIL_TITLE, 1, 2, "在前")
  Lst_SetCell(self.UIGROUP, LST_BONE_DETAIL_TITLE, 1, 3, "相对位置")

  -- 定时更新器
  if self.nUpdateTimer then
    Ui.tbLogic.tbTimer:Close(self.nUpdateTimer)
  end
  self.nUpdateTimer = Ui.tbLogic.tbTimer:Register(1, self.OnTimer, self)

  -- 更新基础属性
  self:_UpdateProperty()
  -- 更新控制配置
  self:_UpdateCtrlCfg()
  -- 更新动画配置
  self:_UpdateAniCfg()
  -- 更新按钮配置
  self:_UpdateBtnState()
  -- 更新骨头列表
  self:_UpdateBoneList()
  -- 更新动画细节
  self:_UpdateAniList()
end

function uiWnd:OnClose()
  self:_ChangeSelList(nil, nil)

  if self.nUpdateTimer then
    Ui.tbLogic.tbTimer:Close(self.nUpdateTimer)
  end
  self.nUpdateTimer = nil
  self.bEditing = 0

  self:_Clean()
end

function uiWnd:OnButtonClick(szWnd)
  local bUpdateProperty = 0
  ------------------------------------------------------------------------
  --	property cfg
  if szWnd == BTN_SELECT_MALE then
    Btn_Check(self.UIGROUP, BTN_SELECT_FMALE, 0)
    Btn_Check(self.UIGROUP, BTN_SELECT_MALE, 1)
    self.tbProperty.szNpcType = "MainMan"
  elseif szWnd == BTN_SELECT_FMALE then
    Btn_Check(self.UIGROUP, BTN_SELECT_MALE, 0)
    Btn_Check(self.UIGROUP, BTN_SELECT_FMALE, 1)
    self.tbProperty.szNpcType = "MainLady"
  elseif szWnd == BTN_HEAD_SHOW then
    self.tbProperty.bShowHelm = Btn_GetCheck(self.UIGROUP, szWnd)
  elseif szWnd == BTN_ARMOR_SHOW then
    self.tbProperty.bShowArmor = Btn_GetCheck(self.UIGROUP, szWnd)
  elseif szWnd == BTN_WEAPON_SHOW then
    self.tbProperty.bShowWeapon = Btn_GetCheck(self.UIGROUP, szWnd)
  elseif szWnd == BTN_HORSE_SHOW then
    self.tbProperty.bShowHorse = Btn_GetCheck(self.UIGROUP, szWnd)
  elseif szWnd == BTN_MANTLE_SHOW then
    self.tbProperty.bShowMantle = Btn_GetCheck(self.UIGROUP, szWnd)
  elseif szWnd == BTN_WIND_SHOW then
    self.tbProperty.bShowWind = Btn_GetCheck(self.UIGROUP, szWnd)
  ------------------------------------------------------------------------
  --	control cfg
  elseif szWnd == BTN_AUTO_PLAY then
    self.tbProperty.bAutoPlay = Btn_GetCheck(self.UIGROUP, szWnd)
    self:_UpdateCtrlCfg()
  elseif szWnd == BTN_AUTO_TURN then
    self.tbProperty.bAutoTurn = Btn_GetCheck(self.UIGROUP, szWnd)
    self:_UpdateCtrlCfg()
  elseif szWnd == BTN_FORCE_SHOW_BONE then
    self.tbProperty.bForceShow = Btn_GetCheck(self.UIGROUP, szWnd)
    self:_UpdateBoneList()
  elseif szWnd == BTN_ADD_INTERVAL then
    self.tbProperty.nInterval = self.tbProperty.nInterval + 1
    self:_UpdateCtrlCfg()
  elseif szWnd == BTN_SUB_INTERVAL then
    self.tbProperty.nInterval = self.tbProperty.nInterval > 0 and self.tbProperty.nInterval - 1 or 0
    self:_UpdateCtrlCfg()
  elseif szWnd == BTN_PREV_FRAME then
    local nDirFrame = self.tbProperty.nFrameNum / 8
    self.tbProperty.nFrame = (self.tbProperty.nFrame - 1 + nDirFrame) % nDirFrame
    self:OnTimer()
  elseif szWnd == BTN_NEXT_FRAME then
    local nDirFrame = self.tbProperty.nFrameNum / 8
    self.tbProperty.nFrame = (self.tbProperty.nFrame + 1) % nDirFrame
    self:OnTimer()
  elseif szWnd == BTN_PREV_DIR then
    self.tbProperty.nDir = (self.tbProperty.nDir - 1 + 8) % 8
    self:OnTimer()
  elseif szWnd == BTN_NEXT_DIR then
    self.tbProperty.nDir = (self.tbProperty.nDir + 1) % 8
    self:OnTimer()
  ------------------------------------------------------------------------
  --	animation cfg
  elseif szWnd == BTN_SELECT_ACTION then
    local szAction = self.tbAction[self.tbProperty.nAction + 1]
    local tbSel = Lib:NewClass(tbSelList, self.UIGROUP, "<color=yellow>选择动作<color>", self.tbAction, { self._SelectAction, self }, nil, szAction)
    self:_ChangeSelList(tbSel, TXT_CUR_ACTION)
  elseif szWnd == BTN_SELECT_PART then
    local tbSel = Lib:NewClass(tbSelList, self.UIGROUP, "<color=yellow>选择组件<color>", self.tbPart, { self._SelectPart, self }, nil, self.tbAnimationCfg.szPart)
    self:_ChangeSelList(tbSel, TXT_SELECT_PART)
  elseif szWnd == BTN_SCHEME_1 then
    self.tbAnimationCfg.nScheme = 1
    self:_UpdateAniCfg()
  elseif szWnd == BTN_SCHEME_2 then
    self.tbAnimationCfg.nScheme = 2
    self:_UpdateAniCfg()
  elseif szWnd == BTN_SCHEME_3 then
    self.tbAnimationCfg.nScheme = 3
    self:_UpdateAniCfg()
  elseif szWnd == BTN_GENERATE then
    self:_Generate()
  ------------------------------------------------------------------------
  --	other cfg
  elseif szWnd == BTN_INPUT_OK then
    self.tbCurSelList:OnOk()
  elseif szWnd == BTN_INPUT_CANCEL then
    self.tbCurSelList:OnCancel()
  elseif szWnd == BTN_CLOSE or szWnd == BTN_CLOSE_WND then
    self:_CloseWindow()
  elseif szWnd == BTN_SAVE_EDT then
    self:_Save2File()
  elseif szWnd == BTN_GIVEUP_EDT then
    self:_Clean()
  elseif szWnd == SD_LST_SELECT then
    self:_ChangeSelList(nil, nil)
  end
end

function uiWnd:OnEditFocus(szWnd)
  self.szEdtTemp = Edt_GetTxt(self.UIGROUP, szWnd)
  self.szEdtFocus = szWnd
  Edt_SetTxt(self.UIGROUP, szWnd, "")
end
-- 编辑框拾取焦点
function uiWnd:OnEditSubmit(szWnd)
  --self:OnEditEnter(szWnd);
  local szTxt = Edt_GetTxt(self.UIGROUP, szWnd)
  local szLast = self.szEdtTemp
  self.szEdtTemp = ""
  self.szEdtFocus = ""

  --	print("OnEditSubmit", szWnd, szTxt, szLast)
  if "" == szTxt then
    Edt_SetTxt(self.UIGROUP, szWnd, szLast)
    return
  elseif szTxt == self.szEdtTemp then
    return
  end

  if szWnd == EDT_HEAD_RES then
    self.tbProperty.nResHelm = tonumber(szTxt)
    if "helm" == self.tbAnimationCfg.szPart then
      self:_UpdateAniCfg()
    end
  elseif szWnd == EDT_ARMOR_RES then
    self.tbProperty.nResArmor = tonumber(szTxt)
    if "armor" == self.tbAnimationCfg.szPart then
      self:_UpdateAniCfg()
    end
  elseif szWnd == EDT_WEAPON_RES then
    self.tbProperty.nResWeapon = tonumber(szTxt)
    if "weapon" == self.tbAnimationCfg.szPart then
      self:_UpdateAniCfg()
    end
  elseif szWnd == EDT_HORSE_RES then
    self.tbProperty.nResHorse = tonumber(szTxt)
    if "horse" == self.tbAnimationCfg.szPart then
      self:_UpdateAniCfg()
    end
  elseif szWnd == EDT_MANTLE_RES then
    self.tbProperty.nResMantle = tonumber(szTxt)
    if "mantle" == self.tbAnimationCfg.szPart then
      self:_UpdateAniCfg()
    end
  elseif szWnd == EDT_WIND_RES then
    self.tbProperty.nResWind = tonumber(szTxt)
    if "wind" == self.tbAnimationCfg.szPart then
      self:_UpdateAniCfg()
    end
  elseif szWnd == EDT_FRAME_SET then
    local nFrame = tonumber(szTxt)
    local nDirFrame = self.tbProperty.nFrameNum / 8
    if nFrame < 0 then
      nFrame = 0
    end
    if nDirFrame > 0 then
      nFrame = nFrame % nDirFrame
    end
    self.tbProperty.nFrame = nFrame
  elseif szWnd == EDT_DIR_SET then
    local nDir = tonumber(szTxt)
    if nDir < 0 then
      nDir = 0
    end
    nDir = nDir % 8
    self.tbProperty.nDir = nDir
  elseif szWnd == EDT_BONE_EFFECT then
    local nEffect = tonumber(szTxt)
    if nEffect and nEffect >= 0 then
      self.tbProperty.nEffect = nEffect
    else
      Edt_SetTxt(self.UIGROUP, EDT_BONE_EFFECT, tostring(self.tbProperty.nEffect))
    end
  end
end
-- 编辑框回车事件
function uiWnd:OnEditEnter(szWnd)
  --	print("OnEditEnter", szWnd)
  Wnd_SetFocus(self.UIGROUP, WND_MAIN)
  if szWnd == EDT_INPUT_INFO then
    self.tbCurSelList:OnOk()
  end
end
-- 列表框选择事件
function uiWnd:OnListSel(szWnd, nKey, nIndex)
  if szWnd == LST_SELECT and self.tbCurSelList then
    self.tbCurSelList:OnSelect(nKey, nIndex)
  end
end
-- 列表框右键点击事件
function uiWnd:OnListRClick(szWnd, nKey, nIndex)
  if 1 == self.bEditing then
    if szWnd == LST_BONE_DETAIL_TITLE or szWnd == LST_BONE_DETAIL then
      self:_EditBoneAni(szWnd, nKey, nIndex)
      Lst_SetCurKey(self.UIGROUP, szWnd, nKey)
    elseif szWnd == LST_BONE_LIST_TITLE or szWnd == LST_BONE_LIST then
      self:_EditBoneDef(szWnd, nKey, nIndex)
      Lst_SetCurKey(self.UIGROUP, szWnd, nKey)
    end
  end
end

function uiWnd:OnListOver(szWnd, nKey, nIndex)
  --print("OnListOver", szWnd, nKey, nIndex)
  if szWnd == LST_BONE_LIST_TITLE then
    self:_ShowBoneListTitleTip(nKey, nIndex)
  elseif szWnd == LST_BONE_DETAIL_TITLE then
    self:_ShowBoneDetailTitleTip(nKey, nIndex)
  end
end

function uiWnd:OnComboBoxIndexChange(szWnd, nIndex)
  if szWnd == CMB_SELECT_DIR then
    self.nCurSelDir = nIndex
    self:_UpdateAniList()
  elseif szWnd == CMB_SELECT_BONE then
    self.nCurSelBone = nIndex
    self:_UpdateAniList()
  end
end

-- 每帧更新数据
function uiWnd:OnTimer()
  local nFrame = self.tbProperty.nFrame
  local nDir = self.tbProperty.nDir
  local nFrameNum = self.tbProperty.nFrameNum
  local szInfo = ""
  szInfo = szInfo .. "总帧数：" .. nFrameNum .. "\n"
  szInfo = szInfo .. "方  向：" .. nDir .. "\n"
  szInfo = szInfo .. "方向帧：" .. nFrame
  Txt_SetTxt(self.UIGROUP, TXT_MODEL_INFO, szInfo)

  if self.szEdtFocus ~= EDT_FRAME_SET then
    Txt_SetTxt(self.UIGROUP, EDT_FRAME_SET, tostring(nFrame))
  end
  if self.szEdtFocus ~= EDT_DIR_SET then
    Txt_SetTxt(self.UIGROUP, EDT_DIR_SET, tostring(nDir))
  end
  if self.szEdtFocus ~= EDT_INTERVAL_SET then
    Txt_SetTxt(self.UIGROUP, EDT_INTERVAL_SET, tostring(self.tbProperty.nInterval))
  end

  return 1
end

function uiWnd:_Generate()
  if self.tbAnimationCfg.nScheme <= 0 or self.tbAnimationCfg.nScheme > 3 then
    self:_ShowError("没有选择创建方案！")
    return 0
  end

  self.tbDetail = BE_GetParam(self.UIGROUP, BONE_EDITER, "GetDetailName", self.tbAnimationCfg.szPart)
  if not self.tbDetail or 0 == #self.tbDetail then
    self:_ShowError("你选择的组件有问题！")
    return 0
  end

  local bRet = 0
  if 1 == self.tbAnimationCfg.nScheme then
    local szSkeleton = self.tbAnimationCfg.tbScheme[1].szSkeleton
    local szAnimation = self.tbAnimationCfg.tbScheme[1].szAnimation
    if szSkeleton and szAnimation then
      szSkeleton = MODEL_PATH .. self.tbAnimationCfg.szPart .. "\\" .. szSkeleton
      szAnimation = MODEL_PATH .. self.tbAnimationCfg.szPart .. "\\" .. szAnimation
      bRet = BE_Generate(self.UIGROUP, BONE_EDITER, self.tbAnimationCfg.szPart, { nScheme = 1, szSkeleton = szSkeleton, szAnimation = szAnimation })
    end
  elseif 2 == self.tbAnimationCfg.nScheme then
  elseif 3 == self.tbAnimationCfg.nScheme then
  end

  if 0 == bRet then
    self:_ShowError("生成配置失败！")
  elseif 1 == bRet then
    local tbBoneList = BE_GetParam(self.UIGROUP, BONE_EDITER, "GetBoneName", "") or {}
    ClearComboBoxItem(self.UIGROUP, CMB_SELECT_BONE)
    ClearComboBoxItem(self.UIGROUP, CMB_SELECT_DIR)
    for i, szBone in ipairs(tbBoneList) do
      ComboBoxAddItem(self.UIGROUP, CMB_SELECT_BONE, i - 1, szBone)
    end
    if #tbBoneList > 0 then
      ComboBoxSelectItem(self.UIGROUP, CMB_SELECT_BONE, 0)
    end

    ComboBoxAddItem(self.UIGROUP, CMB_SELECT_DIR, -1, "ALL")
    ComboBoxAddItem(self.UIGROUP, CMB_SELECT_DIR, 0, "0")
    ComboBoxAddItem(self.UIGROUP, CMB_SELECT_DIR, 1, "1")
    ComboBoxAddItem(self.UIGROUP, CMB_SELECT_DIR, 2, "2")
    ComboBoxAddItem(self.UIGROUP, CMB_SELECT_DIR, 3, "3")
    ComboBoxAddItem(self.UIGROUP, CMB_SELECT_DIR, 4, "4")
    ComboBoxAddItem(self.UIGROUP, CMB_SELECT_DIR, 5, "5")
    ComboBoxAddItem(self.UIGROUP, CMB_SELECT_DIR, 6, "6")
    ComboBoxAddItem(self.UIGROUP, CMB_SELECT_DIR, 7, "7")
    ComboBoxSelectItem(self.UIGROUP, CMB_SELECT_DIR, 0)

    self.bEditing = 1
    self.bNeedSave = 1

    self:_UpdateAniCfg()
    self:_UpdateProperty()
    self:_UpdateAniData()
    self:_UpdateBoneList()
    self:_UpdateAniList()
    self:_UpdateBtnState()
  end
end

function uiWnd:_Clean()
  self:_ChangeSelList(nil, nil)

  self.tbBoneData = {
    tbBoneMap = {},
    tbBoneList = {},
    tbTitleSel = {},
  }
  -- 动画数据,骨骼对应的帧数据
  self.tbAniData = {}

  self.bNeedSave = 0
  self.bEditing = 0
  --	-- 部件
  --	self.tbDetail = {};
  -- 当前选择编辑的方向
  self.nCurSelDir = 0
  -- 选前选择编辑的骨骼
  self.nCurSelBone = 0
  -- 清掉部分数据就可以了
  self.tbAnimationCfg = { nScheme = 0, tbScheme = {}, szPart = self.tbAnimationCfg.szPart }
  --	Lst_Clear(self.UIGROUP, LST_BONE_DETAIL);
  --	Lst_Clear(self.UIGROUP, LST_BONE_LIST);

  BE_Clean(self.UIGROUP, BONE_EDITER)

  self:_UpdateProperty()
  -- 更新控制配置
  self:_UpdateCtrlCfg()
  -- 更新动画配置
  self:_UpdateAniCfg()
  -- 更新按钮配置
  self:_UpdateBtnState()
  -- 更新骨头列表
  self:_UpdateBoneList()
  -- 更新动画细节
  self:_UpdateAniList()
end

function uiWnd:_CloseWindow()
  if 1 == self.bNeedSave then
    local tbWnd = self
    local tbMsg = {}
    tbMsg.szTitle = "退出警告"
    tbMsg.szMsg = "是否保存文件"
    tbMsg.nOptCount = 2
    local function delay()
      tbWnd:_Save2File()
      return 0
    end
    function tbMsg:Callback(nOptIndex)
      if nOptIndex == 2 then
        Ui.tbLogic.tbTimer:Register(1, delay)
      else
        UiManager:CloseWindow(tbWnd.UIGROUP)
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
  else
    UiManager:CloseWindow(self.UIGROUP)
  end
end

function uiWnd:_ChangeSelList(tbSel, szDepend, nOffset_X, nOffset_Y)
  if self.tbCurSelList then
    self.tbCurSelList:Hide()
  end

  local x, y
  if szDepend and "" ~= szDepend then
    local _, _, a_x, a_y = Wnd_GetPos(self.UIGROUP, szDepend)
    local _, height = Wnd_GetSize(self.UIGROUP, szDepend)
    x = a_x
    y = a_y + height
  end
  if nOffset_X and nOffset_Y then
    x = (x or 0) + nOffset_X
    y = (y or 0) + nOffset_Y
  end

  if x and y then
    local _, _, a_x, a_y = Wnd_GetPos(self.UIGROUP, WND_MAIN)
    x = x - a_x
    y = y - a_y
  end

  self.tbCurSelList = tbSel
  if self.tbCurSelList then
    self.tbCurSelList:Show(x, y)
  end
end

function uiWnd:_LoadAction()
  local tbAction
  local szFile = KFile.ReadTxtFile("\\setting\\player\\res\\player_act.txt")
  szFile = Lib:ReplaceStr(szFile, "\r", "")
  tbAction = Lib:SplitStr(szFile, "\n")
  table.remove(tbAction, 1)

  local nCount = #tbAction
  local nRemove = nCount + 1

  for i = nCount, 1, -1 do
    if "" == tbAction[i] then
      nRemove = i
    else
      break
    end
  end

  for i = 1, nCount - nRemove + 1 do
    table.remove(tbAction, #tbAction)
  end

  return tbAction
end

function uiWnd:_LoadModelCfg()
  local tbModelCfg = {}
  local tbColName = Lib:CopyTB1(self.tbAction)
  table.insert(tbColName, 1, "EqName")
  table.insert(tbColName, 2, "Model")
  --Lib:ShowTB(tbColName);
  for szType, tbCfg in pairs(tbPartModelCfg) do
    tbModelCfg[szType] = {}
    tbModelCfg[szType].tbMaleCfg = Lib:LoadTabFile(MODEL_CFG_PATH .. tbCfg.szMale, tbColName)
    tbModelCfg[szType].tbFemaleCfg = Lib:LoadTabFile(MODEL_CFG_PATH .. tbCfg.szFemale, tbColName)
  end
  return tbModelCfg
end
-- 编辑骨头数据
function uiWnd:_EditBoneAni(szList, nKey, nCell)
  -- 没有选择对象
  if not self.nCurSelBone or not self.nCurSelDir then
    return
  end

  local x, y = GetCursorPos()
  local szBone = GetComboBoxItemText(self.UIGROUP, CMB_SELECT_BONE, self.nCurSelBone)
  local nDir = GetComboBoxItemId(self.UIGROUP, CMB_SELECT_DIR, self.nCurSelDir) or -1
  local nDirFrame = self.tbProperty.nFrameNum / 8
  local nSelFrame = 0
  local nFrome = 0
  local nTo = 0
  if -1 ~= nDir then
    nFrome = 1 + nDir * nDirFrame
    nTo = nFrome + nDirFrame - 1
    nSelFrame = nFrome - 1 + nKey
  else
    nFrome = 1
    nTo = self.tbProperty.nFrameNum
    nSelFrame = nKey
  end

  if szList == LST_BONE_DETAIL_TITLE then
    nSelFrame = -1
  end

  local tbCansel = { self._SelectCancel, self }
  local tbCallBack = { self._SelectCancel, self, szList, nKey, szBone, nDir, nSelFrame }
  local szInfo = ""
  if szList == LST_BONE_DETAIL_TITLE then
    szInfo = "<color=yellow>骨骼：" .. szBone .. "\n方向：" .. nDir .. "\n 帧 ：" .. tostring(nFrome) .. " ~ " .. tostring(nTo) .. "<color>"
  elseif szList == LST_BONE_DETAIL then
    szInfo = "<color=yellow>骨骼：" .. szBone .. "\n方向：" .. nDir .. "\n 帧 ：" .. tostring(nFrome + nKey - 1) .. "<color>"
  else
    return
  end

  if 1 == nCell then
    tbCallBack[1] = self._SelectBelong
    local szTitle = "选择归宿\n" .. szInfo
    local tbSel = Lib:NewClass(tbSelList, self.UIGROUP, szTitle, self.tbDetail, tbCallBack, tbCansel)
    self:_ChangeSelList(tbSel, nil, x, y)
  elseif 2 == nCell then
    tbCallBack[1] = self._SelectFront
    local tbList = { "后", "前" }
    local szTitle = "选择前后关系\n" .. szInfo
    local tbSel = Lib:NewClass(tbSelList, self.UIGROUP, szTitle, tbList, tbCallBack, tbCansel)
    self:_ChangeSelList(tbSel, nil, x, y)
  elseif 3 == nCell then
    tbCallBack[1] = self._EditBonePos
    local szTitle = "编辑坐标\n" .. szInfo
    local tbSel = Lib:NewClass(tbInput, self.UIGROUP, szTitle, tbCallBack, tbCansel)
    self:_ChangeSelList(tbSel, nil, x, y)
  end
end

function uiWnd:_SelectAction(szAction, nKey)
  --	print("_SelectAction", szAction, nKey);
  if szAction and "" ~= szAction then
    Txt_SetTxt(self.UIGROUP, TXT_CUR_ACTION, szAction)
    self.tbProperty.nAction = nKey - 1
  end
  self:_UpdateAniCfg()
  self:_ChangeSelList(nil, nil)
end

function uiWnd:_SelectPart(szPart, nKey)
  --	print("_SelectPart", szPart, nKey);
  self.tbAnimationCfg.szPart = szPart
  self.tbDetail = BE_GetParam(self.UIGROUP, BONE_EDITER, "GetDetailName", szPart)
  --	Lib:ShowTB(self.tbDetail);
  self:_UpdateAniCfg()
  self:_ChangeSelList(nil, nil)
end
--
--function uiWnd:_SelectDetail(szDetail, nKey)
--	print("_SelectDetail", szDetail, nKey);
--
--	self:_ChangeSelList(nil, nil);
--end

function uiWnd:_SelectBelong(szWndLst, nKey, szBone, nDir, nFrame, szDetail)
  --	print("_SelectBelong", szWndLst, nKey, szBone, nDir, nFrame, szDetail);
  self:_ChangeSelList(nil, nil)

  if szWndLst == LST_BONE_DETAIL then
    local tbFrame = self.tbAniData[szBone] or {}
    local tbAni = tbFrame[nFrame + 1]
    --Lib:ShowTB(tbFrame or {});
    --		print("kkkkkkkkkkkkkkkkkkk", nFrame, type(nFrame));
    --Lib:ShowTB(tbAni or {});
    if tbAni then
      BE_SetParam(self.UIGROUP, BONE_EDITER, "SetBoneInfo", { ["szBone"] = szBone, ["nFrame"] = nFrame, ["szBelong"] = szDetail })
      tbAni.szBelong = szDetail
      self:_UpdateAniList()
      self:_MarkNeedSave()
    end
  elseif szWndLst == LST_BONE_DETAIL_TITLE then
    BE_SetParam(self.UIGROUP, BONE_EDITER, "SetBoneInfo", { ["szBone"] = szBone, ["nDir"] = nDir, ["szBelong"] = szDetail })
    -- 这个就需要更新一下数据了
    self:_UpdateAniData()
    self:_UpdateAniList()
    self:_MarkNeedSave()
  end
end

function uiWnd:_SelectFront(szWndLst, nKey, szBone, nDir, nFrame, szFront)
  --	print("_SelectFront", szWndLst, nKey, szFront, nFrame);
  self:_ChangeSelList(nil, nil)

  local bFront = 0
  if szFront == "前" then
    bFront = 1
  end

  if szWndLst == LST_BONE_DETAIL then
    local tbFrame = self.tbAniData[szBone] or {}
    local tbAni = tbFrame[nFrame]
    if tbAni then
      BE_SetParam(self.UIGROUP, BONE_EDITER, "SetBoneInfo", { ["szBone"] = szBone, ["nFrame"] = nFrame - 1, ["bFront"] = bFront })
      tbAni.bFront = bFront
      self:_UpdateAniList()
      self:_MarkNeedSave()
    end
  elseif szWndLst == LST_BONE_DETAIL_TITLE then
    BE_SetParam(self.UIGROUP, BONE_EDITER, "SetBoneInfo", { ["szBone"] = szBone, ["nDir"] = nDir, ["bFront"] = bFront })
    -- 这个就需要更新一下数据了
    self:_UpdateAniData()
    self:_UpdateAniList()
    self:_MarkNeedSave()
  end
end

-- 列表选择取消
function uiWnd:_SelectCancel()
  self:_ChangeSelList(nil, nil)
end

function uiWnd:_EditBoneDef(szWnd, nKey, nCell)
  if szWnd == LST_BONE_LIST then
    local szBone = self.tbBoneData.tbBoneList[nKey]
    if not szBone or "" == szBone then
      assert(false)
      return
    end

    local tbBone = self.tbBoneData.tbBoneMap[szBone]
    if not tbBone then
      assert(false)
      return
    end

    if 1 == nCell then
      if 1 == tbBone.bShow then
        tbBone.bShow = 0
        Lst_SetCell(self.UIGROUP, szWnd, nKey, nCell, "×")
      else
        tbBone.bShow = 1
        Lst_SetCell(self.UIGROUP, szWnd, nKey, nCell, "√")
      end
      BE_SetParam(self.UIGROUP, BONE_EDITER, "SetBoneInfo", { ["szBone"] = szBone, bShow = tbBone.bShow })
    elseif 2 == nCell then
      if 1 == tbBone.bInclude then
        tbBone.bInclude = 0
        Lst_SetCell(self.UIGROUP, szWnd, nKey, nCell, "×")
      else
        tbBone.bInclude = 1
        Lst_SetCell(self.UIGROUP, szWnd, nKey, nCell, "√")
      end
      self:_MarkNeedSave()
    end
  elseif szWnd == LST_BONE_LIST_TITLE then
    -- 默认值不一样
    if 1 == nCell then
      self.tbBoneData.tbTitleSel[nCell] = self.tbBoneData.tbTitleSel[nCell] or 1
    elseif 2 == nCell then
      self.tbBoneData.tbTitleSel[nCell] = self.tbBoneData.tbTitleSel[nCell] or 0
    end
    self.tbBoneData.tbTitleSel[nCell] = 0 == self.tbBoneData.tbTitleSel[nCell] and 1 or 0
    if 1 == nCell then
      for szBone, tbBone in pairs(self.tbBoneData.tbBoneMap) do
        tbBone.bShow = self.tbBoneData.tbTitleSel[nCell]
        BE_SetParam(self.UIGROUP, BONE_EDITER, "SetBoneInfo", { ["szBone"] = szBone, bShow = tbBone.bShow })
      end
      self:_UpdateBoneList()
    elseif 2 == nCell then
      for _, tbBone in pairs(self.tbBoneData.tbBoneMap) do
        tbBone.bInclude = self.tbBoneData.tbTitleSel[nCell]
      end
      self:_UpdateBoneList()
      self:_MarkNeedSave()
    end
  end
end

function uiWnd:_EditBonePos(szWndLst, nKey, szBone, nDir, nFrame, szPos)
  --	print("_EditBonePos", szWndLst, nKey, szBone, nDir, nFrame, szPos);
  local tbPos = Lib:SplitStr(szPos, ",")
  if not tonumber(tbPos[1]) or not tonumber(tbPos[2]) then
    self:_ShowError("你输入的位置坐标不合法，格式为【100.0,100.0f】\n", szPos)
    return
  end
  szPos = tonumber(tbPos[1]) .. "," .. tonumber(tbPos[2])

  if szWndLst == LST_BONE_DETAIL then
    local tbFrame = self.tbAniData[szBone] or {}
    local tbAni = tbFrame[nFrame]
    --Lib:ShowTB(tbFrame or {});
    --		print("kkkkkkkkkkkkkkkkkkk", nFrame, type(nFrame));
    if tbAni then
      BE_SetParam(self.UIGROUP, BONE_EDITER, "SetBoneInfo", { ["szBone"] = szBone, ["nFrame"] = nFrame - 1, ["szPosition"] = szPos })
      tbAni.szPosition = szPos
      self:_UpdateAniList()
      self:_MarkNeedSave()
    end
  elseif szWndLst == LST_BONE_DETAIL_TITLE then
    BE_SetParam(self.UIGROUP, BONE_EDITER, "SetBoneInfo", { ["szBone"] = szBone, ["nDir"] = nDir, ["szPosition"] = szPos })
    -- 这个就需要更新一下数据了
    self:_UpdateAniData()
    self:_UpdateAniList()
    self:_MarkNeedSave()
  end
end
-- 更新基础属性
function uiWnd:_UpdateProperty()
  Btn_Check(self.UIGROUP, BTN_SELECT_MALE, 0)
  Btn_Check(self.UIGROUP, BTN_SELECT_FMALE, 0)
  local szNpcType = self.tbProperty.szNpcType
  if "MainMan" == szNpcType then
    Btn_Check(self.UIGROUP, BTN_SELECT_MALE, 1)
  elseif "MainLady" == szNpcType then
    Btn_Check(self.UIGROUP, BTN_SELECT_FMALE, 1)
  else
    print(debug.traceback())
  end

  -- 资源
  Edt_SetInt(self.UIGROUP, EDT_HEAD_RES, self.tbProperty.nResHelm)
  Edt_SetInt(self.UIGROUP, EDT_ARMOR_RES, self.tbProperty.nResArmor)
  Edt_SetInt(self.UIGROUP, EDT_WEAPON_RES, self.tbProperty.nResWeapon)
  Edt_SetInt(self.UIGROUP, EDT_HORSE_RES, self.tbProperty.nResHorse)
  Edt_SetInt(self.UIGROUP, EDT_MANTLE_RES, self.tbProperty.nResMantle)
  Edt_SetInt(self.UIGROUP, EDT_WIND_RES, self.tbProperty.nResWind)

  -- 是否显示
  Btn_Check(self.UIGROUP, BTN_HEAD_SHOW, self.tbProperty.bShowHelm)
  Btn_Check(self.UIGROUP, BTN_ARMOR_SHOW, self.tbProperty.bShowArmor)
  Btn_Check(self.UIGROUP, BTN_WEAPON_SHOW, self.tbProperty.bShowWeapon)
  Btn_Check(self.UIGROUP, BTN_HORSE_SHOW, self.tbProperty.bShowHorse)
  Btn_Check(self.UIGROUP, BTN_MANTLE_SHOW, self.tbProperty.bShowMantle)
  Btn_Check(self.UIGROUP, BTN_WIND_SHOW, self.tbProperty.bShowWind)

  local tbPart2Wnd = {}
  tbPart2Wnd["helm"] = "Txt_Head_Res"
  tbPart2Wnd["armor"] = "Txt_Armor_Res"
  tbPart2Wnd["weapon"] = "Txt_Weapon_Res"
  tbPart2Wnd["horse"] = "Txt_Horse_Res"
  tbPart2Wnd["mantle"] = "Txt_Mantle_Res"
  tbPart2Wnd["wind"] = "Txt_Wind_Res"
  local szPartWnd = tbPart2Wnd[self.tbAnimationCfg.szPart]
  if 1 == self.bEditing and szPartWnd then
    local x, y = Wnd_GetPos(self.UIGROUP, szPartWnd)
    Wnd_SetPos(self.UIGROUP, SD_OVRE_RES_EDT, x, y)
    Wnd_Show(self.UIGROUP, SD_OVRE_RES_EDT)
  else
    Wnd_Hide(self.UIGROUP, SD_OVRE_RES_EDT)
  end
end
-- 更新控制配置
function uiWnd:_UpdateCtrlCfg()
  local bFrame = 0
  local bDir = 0
  local bInterval = 1
  local bAutoPlay = self.tbProperty.bAutoPlay
  local bAutoTurn = self.tbProperty.bAutoTurn
  Btn_Check(self.UIGROUP, BTN_AUTO_PLAY, bAutoPlay)
  Btn_Check(self.UIGROUP, BTN_AUTO_TURN, bAutoTurn)

  if 0 == bAutoPlay then
    bFrame = 1
    bDir = 1
    bInterval = 0
  end

  if 0 == bAutoTurn then
    bDir = 1
  end

  if 1 == bInterval then
    if 0 == self.tbProperty.nInterval then
      Wnd_SetEnable(self.UIGROUP, BTN_SUB_INTERVAL, 0)
    else
      Wnd_SetEnable(self.UIGROUP, BTN_SUB_INTERVAL, 1)
    end
    Wnd_SetEnable(self.UIGROUP, BTN_ADD_INTERVAL, 1)
  else
    Wnd_SetEnable(self.UIGROUP, BTN_SUB_INTERVAL, 0)
    Wnd_SetEnable(self.UIGROUP, BTN_ADD_INTERVAL, 0)
  end

  if 1 == bFrame then
    Wnd_SetEnable(self.UIGROUP, BTN_PREV_FRAME, 1)
    Wnd_SetEnable(self.UIGROUP, BTN_NEXT_FRAME, 1)
    Wnd_SetEnable(self.UIGROUP, EDT_FRAME_SET, 1)
    --Edt_EnableKeyInput(self.UIGROUP, EDT_FRAME_SET, 1);
  else
    Wnd_SetEnable(self.UIGROUP, BTN_PREV_FRAME, 0)
    Wnd_SetEnable(self.UIGROUP, BTN_NEXT_FRAME, 0)
    Wnd_SetEnable(self.UIGROUP, EDT_FRAME_SET, 0)
    --Edt_EnableKeyInput(self.UIGROUP, EDT_FRAME_SET, 0);
  end

  if 1 == bDir then
    Wnd_SetEnable(self.UIGROUP, BTN_PREV_DIR, 1)
    Wnd_SetEnable(self.UIGROUP, BTN_NEXT_DIR, 1)
    Wnd_SetEnable(self.UIGROUP, EDT_DIR_SET, 1)
    --Edt_EnableKeyInput(self.UIGROUP, EDT_DIR_SET, 1);
  else
    Wnd_SetEnable(self.UIGROUP, BTN_PREV_DIR, 0)
    Wnd_SetEnable(self.UIGROUP, BTN_NEXT_DIR, 0)
    Wnd_SetEnable(self.UIGROUP, EDT_DIR_SET, 0)
    --Edt_EnableKeyInput(self.UIGROUP, EDT_DIR_SET, 0);
  end

  -- 更新界面计数显示
  self:OnTimer()
end

function uiWnd:_TransPart2Res(szPart)
  if "helm" == szPart then
    return self.tbProperty.nResHelm
  elseif "armor" == szPart then
    return self.tbProperty.nResArmor
  elseif "weapon" == szPart then
    return self.tbProperty.nResWeapon
  elseif "horse" == szPart then
    return self.tbProperty.nResHorse
  elseif "mantle" == szPart then
    return self.tbProperty.nResMantle
  elseif "wind" == szPart then
    return self.tbProperty.nResWind
  end
end
-- 更新动画配置
function uiWnd:_UpdateAniCfg()
  local nAction = (self.tbProperty.nAction or 0) + 1
  local szAction = self.tbAction[nAction]
  Txt_SetTxt(self.UIGROUP, TXT_CUR_ACTION, szAction)
  Txt_SetTxt(self.UIGROUP, TXT_SELECT_PART, self.tbAnimationCfg.szPart or "")

  if 1 == self.bEditing then
    Wnd_SetEnable(self.UIGROUP, BTN_SCHEME_1, 0)
    Wnd_SetEnable(self.UIGROUP, BTN_SCHEME_2, 0)
    Wnd_SetEnable(self.UIGROUP, BTN_SCHEME_3, 0)
    Wnd_SetEnable(self.UIGROUP, BTN_GENERATE, 0)
    Wnd_SetEnable(self.UIGROUP, BTN_SELECT_PART, 0)
    Wnd_SetEnable(self.UIGROUP, BTN_SELECT_ACTION, 0)

    return 0
  end

  Wnd_SetEnable(self.UIGROUP, BTN_SELECT_ACTION, 1)
  Wnd_SetEnable(self.UIGROUP, BTN_SELECT_PART, 1)

  if not self.tbAnimationCfg.szPart or "" == self.tbAnimationCfg.szPart then
    Wnd_SetEnable(self.UIGROUP, BTN_SCHEME_1, 0)
    Wnd_SetEnable(self.UIGROUP, BTN_SCHEME_2, 0)
    Wnd_SetEnable(self.UIGROUP, BTN_SCHEME_3, 0)
    Wnd_SetEnable(self.UIGROUP, BTN_GENERATE, 0)
    Txt_SetTxt(self.UIGROUP, TXT_SKELETON, "骨骼：")
    Txt_SetTxt(self.UIGROUP, TXT_ANIMATION, "动画：")
    Txt_SetTxt(self.UIGROUP, TXT_CFG_FILE, "文件：")
    --		Txt_SetTxt(self.UIGROUP, TXT_SELECT_PART, "");
    --Edt_SetTxt(self.UIGROUP, EDT_INPUT_BONE, "");
    return 0
  else
    --		Txt_SetTxt(self.UIGROUP, TXT_SELECT_PART, self.tbAnimationCfg.szPart);
    Wnd_SetEnable(self.UIGROUP, BTN_SCHEME_1, 1)
    Wnd_SetEnable(self.UIGROUP, BTN_SCHEME_2, 1)
    Wnd_SetEnable(self.UIGROUP, BTN_SCHEME_3, 1)
  end

  Btn_Check(self.UIGROUP, BTN_SCHEME_1, 0)
  Btn_Check(self.UIGROUP, BTN_SCHEME_2, 0)
  Btn_Check(self.UIGROUP, BTN_SCHEME_3, 0)
  if self.tbAnimationCfg.nScheme == 1 then
    Btn_Check(self.UIGROUP, BTN_SCHEME_1, 1)
  elseif self.tbAnimationCfg.nScheme == 2 then
    Btn_Check(self.UIGROUP, BTN_SCHEME_2, 1)
  elseif self.tbAnimationCfg.nScheme == 3 then
    Btn_Check(self.UIGROUP, BTN_SCHEME_3, 1)
  end

  local nResId = self:_TransPart2Res(self.tbAnimationCfg.szPart) or -1
  local szDetail = "tbMaleCfg"
  if self.tbProperty.szNpcType == "MainLady" then
    szDetail = "tbFemaleCfg"
  end

  -- 检测方案一是否可行
  local tbModel = self.tbModelCfg[self.tbAnimationCfg.szPart] or {}
  tbModel = tbModel[szDetail] or {}
  tbModel = tbModel[nResId + 1] or {}
  --	Lib:ShowTB(tbModel);
  --	Lib:ShowTB(self.tbAnimationCfg);
  --	print(szDetail, nResId)
  if not tbModel[szAction] or "" == tbModel[szAction] or not tbModel["Model"] or "" == tbModel["Model"] then
    if self.nScheme == 1 then
      self.nScheme = 0
    end
    Btn_Check(self.UIGROUP, BTN_SCHEME_1, 0)
    Wnd_SetEnable(self.UIGROUP, BTN_SCHEME_1, 0)
  else
    Txt_SetTxt(self.UIGROUP, TXT_SKELETON, "骨骼：" .. tbModel["Model"])
    Txt_SetTxt(self.UIGROUP, TXT_ANIMATION, "动画：" .. tbModel[szAction])
    self.tbAnimationCfg.tbScheme[1] = {}
    self.tbAnimationCfg.tbScheme[1].szSkeleton = tbModel["Model"]
    self.tbAnimationCfg.tbScheme[1].szAnimation = tbModel[szAction]
    Wnd_SetEnable(self.UIGROUP, BTN_SCHEME_1, 1)
  end

  -- 方案二目前不支持
  Btn_Check(self.UIGROUP, BTN_SCHEME_2, 0)
  Wnd_SetEnable(self.UIGROUP, BTN_SCHEME_2, 0)

  -- 方案三也不支持
  Btn_Check(self.UIGROUP, BTN_SCHEME_3, 0)
  Wnd_SetEnable(self.UIGROUP, BTN_SCHEME_3, 0)

  if 0 == self.bEditing and self.tbAnimationCfg.nScheme > 0 and self.tbAnimationCfg.nScheme <= 3 then
    Wnd_SetEnable(self.UIGROUP, BTN_GENERATE, 1)
  else
    Wnd_SetEnable(self.UIGROUP, BTN_GENERATE, 0)
  end
end
-- 更新按钮状态
function uiWnd:_UpdateBtnState()
  if 1 == self.bEditing then
    Wnd_SetEnable(self.UIGROUP, BTN_GIVEUP_EDT, 1)
  else
    Wnd_SetEnable(self.UIGROUP, BTN_GIVEUP_EDT, 0)
  end

  if 1 == self.bNeedSave then
    Wnd_SetEnable(self.UIGROUP, BTN_SAVE_EDT, 1)
  else
    Wnd_SetEnable(self.UIGROUP, BTN_SAVE_EDT, 0)
  end
end

-- 骨头内容
function uiWnd:_UpdateAniList()
  Lst_Clear(self.UIGROUP, LST_BONE_DETAIL)
  if 1 ~= self.bEditing then
    Wnd_SetEnable(self.UIGROUP, CMB_SELECT_DIR, 0)
    Wnd_SetEnable(self.UIGROUP, CMB_SELECT_BONE, 0)
    return
  else
    Wnd_SetEnable(self.UIGROUP, CMB_SELECT_DIR, 1)
    Wnd_SetEnable(self.UIGROUP, CMB_SELECT_BONE, 1)
  end
  -- 木有选择要显示的内容
  if not self.nCurSelBone or not self.nCurSelDir then
    return
  end

  local szBone = GetComboBoxItemText(self.UIGROUP, CMB_SELECT_BONE, self.nCurSelBone)
  local nDir = GetComboBoxItemId(self.UIGROUP, CMB_SELECT_DIR, self.nCurSelDir)
  local nDirFrame = self.tbProperty.nFrameNum / 8
  local nFrome = 0
  local nNum = nDirFrame * 8
  if not nDir or not szBone then
    return
  end

  if -1 ~= nDir then
    nFrome = nDir * nDirFrame
    nNum = nDirFrame
  end

  if not szBone or not self.tbAniData[szBone] then
    return
  end

  local tbFrames = self.tbAniData[szBone]
  nNum = math.min(nNum, #tbFrames - nFrome)

  for i = 1, nNum do
    local nFrame = nFrome + i
    local tbBone = tbFrames[nFrame]
    Lst_SetCell(self.UIGROUP, LST_BONE_DETAIL, i, 0, tostring(nFrame))
    Lst_SetCell(self.UIGROUP, LST_BONE_DETAIL, i, 1, tbBone.szBelong == "" and "无" or tbBone.szBelong)
    Lst_SetCell(self.UIGROUP, LST_BONE_DETAIL, i, 2, tbBone.bFront == 1 and "√" or "×")
    Lst_SetCell(self.UIGROUP, LST_BONE_DETAIL, i, 3, tbBone.szPosition)
  end
end
-- 骨头列表
function uiWnd:_UpdateBoneList()
  Lst_Clear(self.UIGROUP, LST_BONE_LIST)
  Btn_Check(self.UIGROUP, BTN_FORCE_SHOW_BONE, self.tbProperty.bForceShow)
  Edt_SetTxt(self.UIGROUP, EDT_BONE_EFFECT, tostring(self.tbProperty.nEffect))
  Wnd_Hide(self.UIGROUP, SD_OVER_BONE_SHOW)

  if 0 == self.bEditing then
    Wnd_SetEnable(self.UIGROUP, BTN_FORCE_SHOW_BONE, 0)
    Edt_EnableKeyInput(self.UIGROUP, EDT_BONE_EFFECT, 0)
    return 0
  end

  if 1 == self.tbProperty.bForceShow then
    --Wnd_Show(self.UIGROUP, SD_OVER_BONE_SHOW);
  end

  Edt_EnableKeyInput(self.UIGROUP, EDT_BONE_EFFECT, 1)
  Wnd_SetEnable(self.UIGROUP, BTN_FORCE_SHOW_BONE, 1)

  for i, szBone in ipairs(self.tbBoneData.tbBoneList) do
    local tbInfo = self.tbBoneData.tbBoneMap[szBone]
    Lst_SetCell(self.UIGROUP, LST_BONE_LIST, i, 0, szBone)
    Lst_SetCell(self.UIGROUP, LST_BONE_LIST, i, 1, (tbInfo.bShow == 1 and "√" or "×"))
    Lst_SetCell(self.UIGROUP, LST_BONE_LIST, i, 2, (tbInfo.bInclude == 1 and "√" or "×"))
  end
end
-- 更新骨头数据
function uiWnd:_UpdateAniData()
  local tbBoneMap = self.tbBoneData.tbBoneMap

  self.tbBoneData.tbBoneList = BE_GetParam(self.UIGROUP, BONE_EDITER, "GetBoneName") or {}
  self.tbAniData = {}
  self.tbBoneData.tbBoneMap = {}

  for i, szBone in ipairs(self.tbBoneData.tbBoneList) do
    if tbBoneMap[szBone] then
      self.tbBoneData.tbBoneMap[szBone] = tbBoneMap[szBone]
    else
      self.tbBoneData.tbBoneMap[szBone] = { bShow = 1, bInclude = 0 }
    end

    self.tbAniData[szBone] = BE_GetParam(self.UIGROUP, BONE_EDITER, "GetBoneInfo", szBone)
  end
end
-- 标记需要保存
function uiWnd:_MarkNeedSave()
  self.bNeedSave = 1
  self:_UpdateBtnState()
end
-- 保存到文件中
function uiWnd:_Save2File(szFile)
  szFile = szFile or ""
  if not szFile or "" == szFile then
    local szPart = self.tbAnimationCfg.szPart
    local nResId = self:_TransPart2Res(szPart)
    if not nResId then
      print("我擦嘞", szPart)
      return
    end
    local szResId = tostring(nResId)
    local nStrLen = string.len(szResId)
    for i = 1, 3 - nStrLen do
      szResId = "0" .. szResId
    end

    local szDefault = PRODUCT_PATH .. szPart .. "\\" .. szPart .. szResId .. "\\"
    if "MainLady" == self.tbProperty.szNpcType then
      szDefault = szDefault .. "f_"
    elseif "MainMan" == self.tbProperty.szNpcType then
      szDefault = szDefault .. "m_"
    else
      assert(false)
    end

    szDefault = szDefault .. szPart .. "_" .. self.tbAction[self.tbProperty.nAction + 1] .. ".txt"
    szFile = string.lower(szDefault)
    --		print(szDefault);
    print(szFile)
  end

  local szBoneList = ""
  for _, szBone in ipairs(self.tbBoneData.tbBoneList) do
    local tbBone = self.tbBoneData.tbBoneMap[szBone]
    if tbBone and 1 == tbBone.bInclude then
      szBoneList = szBoneList .. szBone .. ","
    end
  end

  if "" == szBoneList then
    self:_ShowError("我靠，至少也要包含一个骨头啊！")
  elseif szFile then
    local tbWnd = self
    local tbMsg = {}
    tbMsg.szMsg = "保存配置文件：\n<color=yellow>" .. szFile .. "<color>"
    tbMsg.nOptCount = 2
    function tbMsg:Callback(nOptIndex)
      if nOptIndex == 2 then
        if 1 == BE_Save(tbWnd.UIGROUP, BONE_EDITER, szFile, szBoneList) then
          tbWnd.bNeedSave = 0
          tbWnd:_UpdateBtnState()
          tbWnd:_ShowError("<color=yellow>保存文件成功【" .. szFile .. "】<color>")
        else
          tbWnd:_ShowError("保存文件失败【" .. szFile .. "】")
        end
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
  else
    --		print("QQQQQQQQQQQQQQQQQQQQQQ")
  end
end

-- 显示tip
function uiWnd:_ShowBoneListTitleTip(nKey, nCell)
  if 1 ~= nKey or 0 == self.bEditing then
    return
  end
  local szTip = ""
  if 0 == nCell then
    szTip = "骨骼名称"
  elseif 1 == nCell then
    szTip = "是否展示\n\n<color=yellow>右键点击格子<color>切换显示状态\n只是针对编辑器"
  elseif 2 == nCell then
    szTip = "是否包含\n\n<color=yellow>右键点击格子<color>切换是否包含标志\n包含的意思是指是否生成的配置文件中包含该骨头\n<color=red>注意：这很重要<color>"
  end

  if "" ~= szTip then
    Wnd_ShowMouseHoverInfoEx(self.UIGROUP, LST_BONE_LIST_TITLE, "", szTip, "", 1, "", "", "", 1, 0, 0, 1)
  end
end

function uiWnd:_ShowBoneDetailTitleTip(nKey, nCell)
  if 1 ~= nKey or 0 == self.bEditing then
    return
  end

  local szTip = ""
  local nDir = GetComboBoxItemId(self.UIGROUP, CMB_SELECT_DIR, self.nCurSelDir) or -1
  local szBone = GetComboBoxItemText(self.UIGROUP, CMB_SELECT_BONE, self.nCurSelBone) or ""
  if 0 == nCell then
    szTip = "帧数\n"
    if -1 == nDir then
      szTip = szTip .. "\n在所有方向下的帧数。"
    else
      szTip = szTip .. "\n骨头" .. szBone .. "在<color=yellow> " .. nDir .. " <color>下所属部件。"
    end
  elseif 1 == nCell then
    szTip = "骨头所属部件\n"
    if -1 == nDir then
      szTip = szTip .. "\n在所有方向下所属的部件。"
    else
      szTip = szTip .. "\n骨头" .. szBone .. "在<color=yellow> " .. nDir .. " <color>下所属部件。"
    end
    szTip = szTip .. "\n\n<color=yellow>右键点击格子<color>编辑骨头的归属设置\n注意：骨头只有在归宿某一存在部件的情况下才能正常表现。"
  elseif 2 == nCell then
    szTip = "骨头渲染的前后关系\n"
    if -1 == nDir then
      szTip = szTip .. "\n在所有方向下的渲染前后关系。"
    else
      szTip = szTip .. "\n骨头" .. szBone .. "在<color=yellow> " .. nDir .. " <color>下的渲染前后关系。"
    end
    szTip = szTip .. "\n\n<color=yellow>右键点击格子<color>编辑骨头的渲染前后关系\n注意：该字段影响骨头与部件的遮挡关系。"
  elseif 3 == nCell then
    szTip = "骨头的渲染位置\n"
    if -1 == nDir then
      szTip = szTip .. "\n在所有方向下的渲染位置。"
    else
      szTip = szTip .. "\n骨头" .. szBone .. "在<color=yellow> " .. nDir .. " <color>下的渲染位置。"
    end
    szTip = szTip .. "\n\n<color=yellow>右键点击格子<color>编辑骨头的渲染位置\n注意：渲染位置是相对于角色位置的偏移。"
    --	elseif 4 == nCell then
    --		szTip = "骨头渲染的前后关系\n";
    --		if -1 == nDir then
    --			szTip = szTip .. "\n在所有方向下的渲染前后关系。";
    --		else
    --			szTip = szTip .. "\n骨头" .. szBone .. "在<color=yellow> " .. nDir .. " <color>下的渲染前后关系。";
    --		end
    --		szTip = szTip .. "\n\n<color=yellow>双击格子<color>编辑骨头的渲染前后关系\n注意：该字段影响骨头与部件的遮挡关系。";
  end

  if "" ~= szTip then
    Wnd_ShowMouseHoverInfoEx(self.UIGROUP, LST_BONE_DETAIL_TITLE, "", szTip, "", 1, "", "", "", 1, 0, 0, 1)
  end
end

function uiWnd:_ShowError(szError, nSecond)
  nSecond = nSecond or 4
  Txt_SetTxt(self.UIGROUP, TXT_ERROR, szError)
  local function hide(szGroup, szWnd)
    Txt_SetTxt(szGroup, szWnd, "")
    return 0
  end

  Ui.tbLogic.tbTimer:Register(18 * nSecond, hide, self.UIGROUP, TXT_ERROR)
end
