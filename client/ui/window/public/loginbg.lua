local tbLoginBg = Ui:GetClass("loginbg")

local IMG_BGMAIN = "ImgMain"
local IMG_LOGO = "ImgLogo"
local IMG_LOGO_TITLE = "ImgLogo_Title"
local IMG_KINGSOFT = "ImgKingsoft"
local IMG_HEALTH = "ImgHealth"
local IMG_ANI_1 = "Ani001"
local IMG_ANI_2 = "Ani002"
local IMG_ANI_3 = "Ani003"
local IMG_ANI_4 = "Ani004"
local TXT_RECORD_CODE = "TxtRecordCode"

local IMAGE_PATH = "\\image\\ui\\001a\\login\\"

local BGIMAGE_INFO = -- 背景图
  {
    a = { UiManager.IVER_szBgAccountImageA, UiManager.IVER_szBgSelectRoleImageA, UiManager.IVER_szBgCreateRoleImageA },
    b = { UiManager.IVER_szBgAccountImageB, UiManager.IVER_szBgSelectRoleImageB, UiManager.IVER_szBgCreateRoleImageB },
    c = { UiManager.IVER_szBgAccountImageC, UiManager.IVER_szBgSelectRoleImageC, UiManager.IVER_szBgCreateRoleImageC },
    d = { UiManager.IVER_szBgAccountImageC, UiManager.IVER_szBgSelectRoleImageC, UiManager.IVER_szBgCreateRoleImageC },
  }

local ANIEAGLE_INFO = -- 鹰的动画
  {
    a = { 300, 0 },
    b = { 500, 0 },
    c = { 600, 0 },
    d = { 600, 0 },
    szImage = "login_ani\\eagle.spr",
  }

local ANIWATER_INFO = -- 流水的动画
  {
    a = { 641, 471 },
    b = { 823, 623 },
    c = { 941, 623 },
    d = { 941, 523 },
    szImage = "",
  }

local ANILIGHT_INFO = -- 光照的动画
  {
    a = { 0, 0 },
    b = { 0, 0 },
    c = { 0, 0 },
    d = { 0, 0 },
    szImage = "login_ani\\light.spr",
  }

local ANIFLYCRANE_INFO = -- 飞鹤的动画
  {
    a = { 0, 400 },
    b = { 0, 530 },
    c = { 0, 530 },
    d = { 0, 430 },
    szImage = "login_ani\\flycrane.spr",
  }

local FALLLEAVE_INFO = --  落叶特效（200909武林世家新背景）
  {
    a = { 0, 0 },
    b = { 0, 0 },
    c = { 100, 0 },
    d = { 100, 0 },
    szImage = "login_ani\\fall_leave.spr",
  }

local ANISTANDCRANE_INFO = -- 站鹤的动画
  {
    a = { 588, 295 },
    b = { 786, 452 },
    c = { 904, 499 },
    d = { 904, 399 },
    szImage = "login_ani\\standcrane.spr",
  }

local ANIFOG_INFO = -- 云雾的动画
  {
    a = { 39, 367 },
    b = { 219, 486 },
    c = { 422, 530 },
    d = { 422, 430 },
    szImage = "login_ani\\fog.spr",
  }

local LOGO_INFO = -- LOGO
  {
    a = { tonumber(UiManager.IVER_nLogo_IMAGEPOS_A_X), tonumber(UiManager.IVER_nLogo_IMAGEPOS_A_Y) },
    b = { tonumber(UiManager.IVER_nLogo_IMAGEPOS_B_X), tonumber(UiManager.IVER_nLogo_IMAGEPOS_B_Y) },
    c = { tonumber(UiManager.IVER_nLogo_IMAGEPOS_C_X), tonumber(UiManager.IVER_nLogo_IMAGEPOS_C_Y) },
    d = { tonumber(UiManager.IVER_nLogo_IMAGEPOS_C_X), tonumber(UiManager.IVER_nLogo_IMAGEPOS_C_Y) },
    szImage = UiManager.IVER_szLogo,
  }

-- Title 是 Logo_info 的子控件
local LOGO_INFO_TITLE = -- LOGO
  {
    a = { 93, 97 },
    b = { 93, 97 },
    c = { 93, 97 },
    d = { 93, 97 },
    szImage = UiManager.IVER_szLogoTitle,
  }

local HEALTH_INFO = -- 健康公告
  {
    a = { 13, tonumber(UiManager.IVER_nHealth_IMAGE_POS_Y_A) },
    b = { 54, 491 },
    c = { 66, 545 },
    d = { 66, 445 },
    szImage = "bg_health_bulletin" .. UiManager.IVER_szVnSpr,
  }

local KINGSOFT_INFO = {
  a = { tonumber(UiManager.IVER_nLogo2_IMAGEPOS_A_X2), 523 },
  b = { tonumber(UiManager.IVER_nLogo2_IMAGEPOS_B_X2), 697 },
  c = { tonumber(UiManager.IVER_nLogo2_IMAGEPOS_C_X2), 727 },
  d = { tonumber(UiManager.IVER_nLogo2_IMAGEPOS_C_X2), 627 },
  szImage = UiManager.IVER_szLogo2,
}

tbLoginBg.MODE_AGREEMENT = 1
tbLoginBg.MODE_SELSVR = 2
tbLoginBg.MODE_LOGIN = 3
tbLoginBg.MODE_SELROLE = 4
tbLoginBg.MODE_NEWROLE = 5

function tbLoginBg:OnOpen(nMode)
  self:UpdateAni()
  self:SetBgImage(nMode)
  self:SetAni(nMode)
  self:SetLogo(nMode)
  self:SetRecordCode(nMode)
end

function tbLoginBg:SetBgImage(nMode)
  if (nMode == self.MODE_AGREEMENT) or (nMode == self.MODE_SELSVR) or (nMode == self.MODE_LOGIN) then
    Img_SetImage(self.UIGROUP, IMG_BGMAIN, 1, IMAGE_PATH .. BGIMAGE_INFO[Ui.szMode][1])
  elseif nMode == self.MODE_SELROLE then
    Img_SetImage(self.UIGROUP, IMG_BGMAIN, 1, IMAGE_PATH .. BGIMAGE_INFO[Ui.szMode][2])
  elseif nMode == self.MODE_NEWROLE then
    Img_SetImage(self.UIGROUP, IMG_BGMAIN, 1, IMAGE_PATH .. BGIMAGE_INFO[Ui.szMode][3])
  end
end

function tbLoginBg:SetAni(nMode)
  if (nMode == self.MODE_AGREEMENT) or (nMode == self.MODE_SELSVR) or (nMode == self.MODE_LOGIN) then
    --200909新资料片去掉
    -- 帐号输入要有光

    --Wnd_Show(self.UIGROUP, IMG_ANI_1);
    --Img_SetImage(self.UIGROUP, IMG_ANI_1, 1, IMAGE_PATH..ANILIGHT_INFO.szImage);
    --Wnd_SetPos(self.UIGROUP, IMG_ANI_1, ANILIGHT_INFO[Ui.szMode][1], ANILIGHT_INFO[Ui.szMode][2]);
    --Img_PlayAnimation(self.UIGROUP, IMG_ANI_1, 1);
    -- 输入帐号要有鹰
    --Wnd_Show(self.UIGROUP, IMG_ANI_2);
    --Img_SetImage(self.UIGROUP, IMG_ANI_2, 1, IMAGE_PATH..ANIEAGLE_INFO.szImage);
    --Wnd_SetPos(self.UIGROUP, IMG_ANI_2, ANIEAGLE_INFO[Ui.szMode][1], ANIEAGLE_INFO[Ui.szMode][2]);
    --Img_PlayAnimation(self.UIGROUP, IMG_ANI_2, 1);

    --200909新资料片新增落叶特效（2010年01月资料片去掉）
    --Wnd_Show(self.UIGROUP, IMG_ANI_1);
    --Img_SetImage(self.UIGROUP, IMG_ANI_1, 1, IMAGE_PATH..FALLLEAVE_INFO.szImage);
    --Wnd_SetPos(self.UIGROUP, IMG_ANI_1, FALLLEAVE_INFO[Ui.szMode][1], FALLLEAVE_INFO[Ui.szMode][2]);
    --Img_PlayAnimation(self.UIGROUP, IMG_ANI_1, 1);
  elseif nMode == self.MODE_SELROLE then
    -- 选人画面要有雾
    Wnd_Show(self.UIGROUP, IMG_ANI_1)
    Img_SetImage(self.UIGROUP, IMG_ANI_1, 1, IMAGE_PATH .. ANIFOG_INFO.szImage)
    Wnd_SetPos(self.UIGROUP, IMG_ANI_1, ANIFOG_INFO[Ui.szMode][1], ANIFOG_INFO[Ui.szMode][2])
    Img_PlayAnimation(self.UIGROUP, IMG_ANI_1, 1)
    -- 鹰
    Wnd_Show(self.UIGROUP, IMG_ANI_2)
    Img_SetImage(self.UIGROUP, IMG_ANI_2, 1, IMAGE_PATH .. ANIEAGLE_INFO.szImage)
    Wnd_SetPos(self.UIGROUP, IMG_ANI_2, ANIEAGLE_INFO[Ui.szMode][1], ANIEAGLE_INFO[Ui.szMode][2])
    Img_PlayAnimation(self.UIGROUP, IMG_ANI_2, 1)
  elseif nMode == self.MODE_NEWROLE then
    -- 新建角色要有雾
    Wnd_Show(self.UIGROUP, IMG_ANI_1)
    Img_SetImage(self.UIGROUP, IMG_ANI_1, 1, IMAGE_PATH .. ANIFOG_INFO.szImage)
    Wnd_SetPos(self.UIGROUP, IMG_ANI_1, ANIFOG_INFO[Ui.szMode][1], ANIFOG_INFO[Ui.szMode][2])
    Img_PlayAnimation(self.UIGROUP, IMG_ANI_1, 1)
    -- 流水
    Wnd_Show(self.UIGROUP, IMG_ANI_2)
    Img_SetImage(self.UIGROUP, IMG_ANI_2, 1, IMAGE_PATH .. ANIWATER_INFO.szImage)
    Wnd_SetPos(self.UIGROUP, IMG_ANI_2, ANIWATER_INFO[Ui.szMode][1], ANIWATER_INFO[Ui.szMode][2])
    Img_PlayAnimation(self.UIGROUP, IMG_ANI_2, 1)
    -- 光
    Wnd_Show(self.UIGROUP, IMG_ANI_3)
    Img_SetImage(self.UIGROUP, IMG_ANI_3, 1, IMAGE_PATH .. ANILIGHT_INFO.szImage)
    Wnd_SetPos(self.UIGROUP, IMG_ANI_3, ANILIGHT_INFO[Ui.szMode][1], ANILIGHT_INFO[Ui.szMode][2])
    Img_PlayAnimation(self.UIGROUP, IMG_ANI_3, 1)
    -- 鹤
    local nHour = os.date("*t", GetTime()).hour
    if (nHour > 6) and (nHour < 11) then
      Wnd_Show(self.UIGROUP, IMG_ANI_4)
      Img_SetImage(self.UIGROUP, IMG_ANI_4, 1, IMAGE_PATH .. ANISTANDCRANE_INFO.szImage)
      Wnd_SetPos(self.UIGROUP, IMG_ANI_4, ANISTANDCRANE_INFO[Ui.szMode][1], ANISTANDCRANE_INFO[Ui.szMode][2])
      Img_PlayAnimation(self.UIGROUP, IMG_ANI_4, 1)
    end
  end
end

function tbLoginBg:UpdateAni()
  Wnd_Hide(self.UIGROUP, IMG_ANI_1)
  Wnd_Hide(self.UIGROUP, IMG_ANI_2)
  Wnd_Hide(self.UIGROUP, IMG_ANI_3)
  Wnd_Hide(self.UIGROUP, IMG_ANI_4)
  Wnd_Hide(self.UIGROUP, IMG_LOGO)
  Wnd_Hide(self.UIGROUP, IMG_LOGO_TITLE)
  Wnd_Hide(self.UIGROUP, IMG_HEALTH)
  Wnd_Hide(self.UIGROUP, IMG_KINGSOFT)
  Wnd_Hide(self.UIGROUP, TXT_RECORD_CODE)
end

function tbLoginBg:SetLogo(nMode)
  if (nMode == self.MODE_AGREEMENT) or (nMode == self.MODE_SELSVR) or (nMode == self.MODE_LOGIN) then
    Wnd_Show(self.UIGROUP, IMG_LOGO)
    Wnd_Show(self.UIGROUP, IMG_LOGO_TITLE)

    Img_SetImage(self.UIGROUP, IMG_LOGO, 1, IMAGE_PATH .. LOGO_INFO.szImage)
    Img_SetImage(self.UIGROUP, IMG_LOGO_TITLE, 1, IMAGE_PATH .. LOGO_INFO_TITLE.szImage)

    Wnd_SetPos(self.UIGROUP, IMG_LOGO, LOGO_INFO[Ui.szMode][1], LOGO_INFO[Ui.szMode][2])
    Wnd_SetPos(self.UIGROUP, IMG_LOGO_TITLE, LOGO_INFO_TITLE[Ui.szMode][1], LOGO_INFO_TITLE[Ui.szMode][2])
  elseif nMode == self.MODE_SELROLE then
    Wnd_Hide(self.UIGROUP, IMG_LOGO)
    Wnd_Hide(self.UIGROUP, IMG_LOGO_TITLE)
  elseif nMode == self.MODE_NEWROLE then
    Wnd_Hide(self.UIGROUP, IMG_LOGO)
    Wnd_Hide(self.UIGROUP, IMG_LOGO_TITLE)
  end
  Wnd_Show(self.UIGROUP, IMG_KINGSOFT)
  Img_SetImage(self.UIGROUP, IMG_KINGSOFT, 1, IMAGE_PATH .. KINGSOFT_INFO.szImage)
  Wnd_SetPos(self.UIGROUP, IMG_KINGSOFT, KINGSOFT_INFO[Ui.szMode][1], KINGSOFT_INFO[Ui.szMode][2])
end

function tbLoginBg:SetHealth(nMode)
  if nMode == self.MODE_LOGIN then
    Wnd_Show(self.UIGROUP, IMG_HEALTH)
    Img_SetImage(self.UIGROUP, IMG_HEALTH, 1, IMAGE_PATH .. HEALTH_INFO.szImage)
    Wnd_SetPos(self.UIGROUP, IMG_HEALTH, HEALTH_INFO[Ui.szMode][1], HEALTH_INFO[Ui.szMode][2])
  else
    Wnd_Hide(self.UIGROUP, IMG_HEALTH)
  end
end

function tbLoginBg:SetRecordCode(nMode)
  if nMode == self.MODE_LOGIN then
    Wnd_Show(self.UIGROUP, TXT_RECORD_CODE)
  else
    Wnd_Hide(self.UIGROUP, TXT_RECORD_CODE)
  end
end
