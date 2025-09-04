-----------------------------------------------------
--文件名		：	blogviewplayer.lua
--创建者		：	zhangjianyu(lucifer~yu)
--创建时间		：	2008-10-9
--功能描述		：	查看玩家BLOG界面
------------------------------------------------------

local uiBlogViewPlayer = Ui:GetClass("blogviewplayer")

local MARRIAGE_TYPE = { "形单影只", "心有所属" }
local PAGE_BLOG = "BtnBlog"

-- 博客查看分页变量
local TXT_INFOBLOGNAME = "TxtInfoBlogName"
local TXT_INFOBLOGMONICKER = "TxtInfoBlogMonicker"
local TXT_INFOBLOGOCCUPATION = "TxtInfoBlogOccupation"
local TXT_INFOBLOGSEX = "TxtInfoBlogSex"
local TXT_INFOBLOGTAG = "TxtInfoBlogTag"
local BTN_BLOGFRIENDONLY = "BtnBlogFriendOnly"
local TXT_INFOBLOGBIRTHDAY_Y = "TxtInfoBlogBirthday_y"
local TXT_INFOBLOGBIRTHDAY_M = "TxtInfoBlogBirthday_m"
local TXT_INFOBLOGBIRTHDAY_D = "TxtInfoBlogBirthday_d"
local TXT_INFOBLOGCITY = "TxtInfoBlogCity"
local CMB_BLOGMARRIAGE = "ComboBoxFatherBlog"
local TXT_INFOBLOGLIKE = "TxtInfoBlogLike"
local BTN_BLOGBLOG = "BtnBlogBlog"
local TXT_INFOBLOGBLOG = "TxtInfoBlogBlog"
local TXT_INFOBLOGDIANDI = "TxtInfoBlogDianDi"
local BTN_BLOGLINGCHEN = "BtnBlogLingchen"
local BTN_BLOGSHANGWU = "BtnBlogShangwu"
local BTN_BLOGZHONGWU = "BtnBlogZhongwu"
local BTN_BLOGXIAWU = "BtnBlogXiawu"
local BTN_BLOGWANSHANG = "BtnBlogWanshang"
local BTN_BLOGWUYE = "BtnBlogWuye"
local BTN_OK = "BtnEditBlogSave"
local BTN_NOT = "BtnEditBlogCancel"
local BTN_CLOSE = "BtnClose"
local BTN_PUBLISHBLOG = "BtnPublishBlog"
local TXT_PROVINCE = "TxtBlogProvince"
local TXT_CITY = "TxtBlogProvinceCity"
local TXT_BLOGMARRIAGE = "TxtBlogMarriageInfo"
local TXT_STARNAME = "TxtStarBlog"

-- SNS相关
local BTN_TTENCENT_PIC = "BtnTTencentPic"
local BTN_TSINA_PIC = "BtnTSinaPic"
local TXT_TTENCENT = "TxtTTencent"
local TXT_TSINA = "TxtTSina"
local BTN_TTENCENT = "BtnTTencent"
local BTN_TSINA = "BtnTSina"

local MSG_USING_SNS = "<color=yellow>点击打开微博页面<color>"
local MSG_NOT_USING_SNS = "<color=148,174,165>没有进行授权关联<color>"
local LABEL_FOLLOWED = "已收听"
local LABEL_CLICK_FOLLOW = "点击收听"

local STAR_MAP = {
  ["白羊座"] = { 3, 21, 4, 19 },
  ["金牛座"] = { 4, 20, 5, 20 },
  ["双子座"] = { 5, 21, 6, 21 },
  ["巨蟹座"] = { 6, 22, 7, 22 },
  ["狮子座"] = { 7, 23, 8, 22 },
  ["处女座"] = { 8, 23, 9, 22 },
  ["天枰座"] = { 9, 23, 10, 23 },
  ["天蝎座"] = { 10, 24, 11, 22 },
  ["射手座"] = { 11, 23, 12, 21 },
  ["摩羯座"] = { 12, 22, 1, 19 },
  ["水平座"] = { 1, 20, 2, 18 },
  ["双鱼座"] = { 2, 19, 3, 20 },
}

function uiBlogViewPlayer:OnOpen(szPlayerName)
  if type(szPlayerName) ~= "string" then
    return
  else
    self.szPlayerName = szPlayerName
    UiManager.bEditBlogState = 0
    PProfile:Require(szPlayerName)

    if Sns.bIsOpen == 0 then
      return
    end

    --查询该角色的SNS信息
    local function fnCallback(tbInfos)
      self:OnSnsInfoReceived(tbInfos)
    end
    PProfile:RequireSnsInfo({ szPlayerName }, fnCallback)
    self.tbSnsAccount = {}
    self:InitSnsControls()
  end
end

function uiBlogViewPlayer:OnCreate()
  local tb = {
    [Sns.SNS_T_TENCENT] = { BTN_TTENCENT_PIC, TXT_TTENCENT, BTN_TTENCENT },
    [Sns.SNS_T_SINA] = { BTN_TSINA_PIC, TXT_TSINA, BTN_TSINA },
  }
  self.tbSnsControls = tb
end

function uiBlogViewPlayer:InitSnsControls()
  for nSnsId, tbControls in pairs(self.tbSnsControls) do
    local tbSns = Sns:GetSnsObject(nSnsId)
    Wnd_SetVisible(self.UIGROUP, tbControls[2], 0)
    Wnd_SetVisible(self.UIGROUP, tbControls[3], 0)
  end
end

function uiBlogViewPlayer:OnSnsInfoReceived(tbInfos)
  local tbPlayerInfo = tbInfos[self.szPlayerName] or {}
  local nBegin = PProfile.emPF_BUFTASK_TTENCENT
  local nEnd = PProfile.emPF_BUFTASK_TSINA
  for i = nBegin, nEnd do
    local szAccount = tbPlayerInfo[i]
    local nSnsId = Sns:ToSnsId(i)
    local szTxtControl = self.tbSnsControls[nSnsId][2]
    local szBtnControl = self.tbSnsControls[nSnsId][3]
    local tbSns = Sns:GetSnsObject(nSnsId)
    if szAccount and #szAccount > 0 then
      self.tbSnsAccount[nSnsId] = szAccount
      Txt_SetTxt(self.UIGROUP, szTxtControl, MSG_USING_SNS)
      local szMyAccount = Sns.tbAccount[nSnsId]
      if szMyAccount then
        if szAccount ~= szMyAccount then
          local callback = function(bIsFollowing)
            if bIsFollowing == 1 then
              Btn_SetTxt(self.UIGROUP, szBtnControl, LABEL_FOLLOWED)
              Wnd_SetEnable(self.UIGROUP, szBtnControl, 0)
            else
              Btn_SetTxt(self.UIGROUP, szBtnControl, LABEL_CLICK_FOLLOW)
              Wnd_SetEnable(self.UIGROUP, szBtnControl, 1)
            end
            Wnd_SetVisible(self.UIGROUP, szBtnControl, 1)
          end
          Sns:IsFollowing(nSnsId, szAccount, callback)
        else
          Wnd_SetVisible(self.UIGROUP, szBtnControl, 0)
        end
      else
        Btn_SetTxt(self.UIGROUP, szBtnControl, LABEL_CLICK_FOLLOW)
        Wnd_SetVisible(self.UIGROUP, szBtnControl, 1)
      end
    else
      Txt_SetTxt(self.UIGROUP, szTxtControl, MSG_NOT_USING_SNS)
      Wnd_SetVisible(self.UIGROUP, szBtnControl, 0)
    end
    Wnd_SetVisible(self.UIGROUP, szTxtControl, 1)
  end
end

function uiBlogViewPlayer:OnButtonClick(szWnd, nParam)
  if szWnd == BTN_CLOSE or szWnd == BTN_OK or szWnd == BTN_NOT then
    UiManager:CloseWindow(self.UIGROUP)
  elseif BTN_BLOGBLOG == szWnd then
    local tbBlogMsg = {}
    tbBlogMsg.szMsg = "提示：你的浏览器将自动打开访问该网址，请谨防木马病毒！"
    tbBlogMsg.nOptCount = 2
    local blogUrl = Edt_GetTxt(self.UIGROUP, TXT_INFOBLOGBLOG)
    function tbBlogMsg:Callback(nOptIndex, szUrl)
      if nOptIndex == 2 then
        ShellExecute(szUrl)
      end
    end
    if blogUrl ~= nil and blogUrl ~= "" then
      UiManager:OpenWindow(Ui.UI_MSGBOX, tbBlogMsg, blogUrl)
    end
  elseif szWnd == TXT_TTENCENT then
    self:GoToSnsAccount(Sns.SNS_T_TENCENT)
  elseif szWnd == TXT_TSINA then
    self:GoToSnsAccount(Sns.SNS_T_SINA)
  elseif szWnd == BTN_TTENCENT_PIC then
    self:GoToSnsAccount(Sns.SNS_T_TENCENT, 1)
  elseif szWnd == BTN_TSINA_PIC then
    self:GoToSnsAccount(Sns.SNS_T_SINA, 1)
  elseif szWnd == BTN_TTENCENT then
    self:ChangeSnsRelation(Sns.SNS_T_TENCENT, szWnd)
  elseif szWnd == BTN_TSINA then
    self:ChangeSnsRelation(Sns.SNS_T_SINA, szWnd)
  elseif szWnd == BTN_PUBLISHBLOG then
    Ui(Ui.UI_SNS_ENTRANCE):OpenSNSmain()
  end
end

function uiBlogViewPlayer:GoToSnsAccount(nSnsId, bGoToHomePage)
  local tbSns = Sns:GetSnsObject(nSnsId)
  local szAccount = self.tbSnsAccount[nSnsId]
  if szAccount then
    local szUrl = tbSns:GetAccountTweetPageUrl(szAccount)
    Sns:GoToUrl(szUrl)
  elseif bGoToHomePage == 1 then
    Sns:GoToUrl(tbSns.URL_HOMEPAGE)
  end
end

function uiBlogViewPlayer:ChangeSnsRelation(nSnsId, szWnd)
  local szAccount = self.tbSnsAccount[nSnsId]
  if not szAccount then
    return
  end

  local tbSns = Sns:GetSnsObject(nSnsId)
  local szMyAccount = Sns.tbAccount[nSnsId]
  --我没有授权，询问是否打开授权窗口
  if not szMyAccount then
    --确认框
    local tbMsg = {
      szMsg = string.format("要收听别人，需要先关联到<color=yellow>%s<color>，是否进行关联？", tbSns.szName),
      nOptCount = 2,
    }
    function tbMsg:Callback(nOptIndex)
      --确定按钮
      if nOptIndex == 2 then
        UiManager:CloseWindow(Ui.UI_BLOGVIEWPLAYER)
        UiManager:OpenWindow(Ui.UI_SNS_VERIFIER, nSnsId)
      end
    end
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbMsg)
  else
    local callback = function()
      Btn_SetTxt(self.UIGROUP, szWnd, LABEL_FOLLOWED)
      Wnd_SetEnable(self.UIGROUP, szWnd, 0)
    end
    Sns:Follow(nSnsId, szAccount, self.szPlayerName, callback)
  end
end

function uiBlogViewPlayer:RegisterEvent()
  local tbRegEvent = {
    { UiNotify.emCOREEVENT_SYNC_BLOGINFO, self.OnUpdatePageAllBlog },
  }
  return tbRegEvent
end

function uiBlogViewPlayer:RegisterMessage()
  local tbRegMsg = {}
  return tbRegMsg
end

function uiBlogViewPlayer:OnUpdatePageAllBlog(RealName, NickName, Profession, Tip, Favor, blog, diary, city, sex, birth, love, online, friendonly)
  if UiManager.bEditBlogState == 0 then
    self:OnUpdatePageBlog(RealName, NickName, Profession, Tip, Favor, blog, diary, city, sex, birth, love, online, friendonly)
  end
end

function uiBlogViewPlayer:OnUpdatePageBlog(szName, szBlogMonicker, szFaction, szBlogTag, szLike, szBlogBlog, szDianDi, szBlogCity, nSex, nBlogBirthday, nMarriageType, nOnlineTime, nFriendOnly)
  if nFriendOnly == 1 and szName == "" and szBlogMonicker == "" and szFaction == "" and szBlogTag == "" and szLike == "" and szBlogBlog == "" and szDianDi == "" and szBlogCity == "" and nSex == 0 and nBlogBirthday == 0 and nMarriageType == 0 and nOnlineTime == 0 then
    local tbBlogMsg = {}
    tbBlogMsg.szMsg = "你还不是该玩家好友，不能查看任何内容，快快和其成为好友查看精彩内容吧！"
    tbBlogMsg.nOptCount = 1
    UiManager:OpenWindow(Ui.UI_MSGBOX, tbBlogMsg, blogUrl)
    UiManager:CloseWindow(self.UIGROUP)
  end

  -- 更新博客基本信息
  Txt_SetTxt(self.UIGROUP, TXT_INFOBLOGNAME, szName)

  Txt_SetTxt(self.UIGROUP, TXT_INFOBLOGMONICKER, szBlogMonicker)

  Txt_SetTxt(self.UIGROUP, TXT_INFOBLOGOCCUPATION, szFaction)

  if nSex == 1 then
    Txt_SetTxt(self.UIGROUP, TXT_INFOBLOGSEX, "女")
  else
    Txt_SetTxt(self.UIGROUP, TXT_INFOBLOGSEX, "男")
  end

  Txt_SetTxt(self.UIGROUP, TXT_INFOBLOGTAG, szBlogTag)

  Wnd_SetEnable(self.UIGROUP, BTN_BLOGFRIENDONLY, 0)
  local bCanSee = nFriendOnly
  if bCanSee == 1 then
    Img_SetFrame(self.UIGROUP, BTN_BLOGFRIENDONLY, 2)
  else
    Img_SetFrame(self.UIGROUP, BTN_BLOGFRIENDONLY, 0)
  end

  local nmonth = 0
  local nday = 0
  local nyear = 0
  nmonth, nday, nyear = TOOLS_SpliteDate(nBlogBirthday)
  --nyear	= 2008-nyear;
  --nmonth = nmonth + 1;
  --nday = nday + 1;
  local szStarName = self:BirthDay2Star(nmonth, nday)
  if UiVersion ~= Ui.Version001 then
    Txt_SetTxt(self.UIGROUP, TXT_STARNAME, szStarName)
  end
  local szyear = KPProfile.ValueToData(nyear)
  local szmonth = KPProfile.ValueToData(nmonth)
  local szday = KPProfile.ValueToData(nday)
  if nyear < 1980 then
    Txt_SetTxt(self.UIGROUP, TXT_INFOBLOGBIRTHDAY_Y, "80年以前")
  else
    Txt_SetTxt(self.UIGROUP, TXT_INFOBLOGBIRTHDAY_Y, szyear .. "年")
  end
  Txt_SetTxt(self.UIGROUP, TXT_INFOBLOGBIRTHDAY_M, szmonth .. "月")
  Txt_SetTxt(self.UIGROUP, TXT_INFOBLOGBIRTHDAY_D, szday .. "日")
  if UiVersion == Ui.Version001 then
    Txt_SetTxt(self.UIGROUP, TXT_INFOBLOGCITY, szBlogCity)
  else
    local szProvince, szCity = self:ParseBlogCity(szBlogCity)
    Txt_SetTxt(self.UIGROUP, TXT_PROVINCE, szProvince)
    Txt_SetTxt(self.UIGROUP, TXT_CITY, szCity)
  end
  if UiVersion == Ui.Version001 then
    ClearComboBoxItem(self.UIGROUP, CMB_BLOGMARRIAGE)
    for i = 1, #MARRIAGE_TYPE do
      ComboBoxAddItem(self.UIGROUP, CMB_BLOGMARRIAGE, i, MARRIAGE_TYPE[i])
    end
    local lmt = nMarriageType - 1
    if lmt >= 0 and lmt <= (#MARRIAGE_TYPE - 1) then
      ComboBoxSelectItem(self.UIGROUP, CMB_BLOGMARRIAGE, lmt)
    else
      ComboBoxSelectItem(self.UIGROUP, CMB_BLOGMARRIAGE, 0)
    end
  else
    if nMarriageType == 2 then
      Txt_SetTxt(self.UIGROUP, TXT_BLOGMARRIAGE, "心有所属")
    else
      Txt_SetTxt(self.UIGROUP, TXT_BLOGMARRIAGE, "形单影只")
    end
  end
  local like = szLike
  if like == "" then
    Edt_SetTxt(self.UIGROUP, TXT_INFOBLOGLIKE, "（写下你特有的爱好吧！）")
  else
    Edt_SetTxt(self.UIGROUP, TXT_INFOBLOGLIKE, like)
  end

  Edt_SetTxt(self.UIGROUP, TXT_INFOBLOGBLOG, szBlogBlog)
  if szBlogBlog == "" then
    Wnd_SetEnable(self.UIGROUP, BTN_BLOGBLOG, 0)
  else
    Wnd_SetEnable(self.UIGROUP, BTN_BLOGBLOG, 1)
  end

  local dianDI = szDianDi
  if dianDI == "" then
    Edt_SetTxt(self.UIGROUP, TXT_INFOBLOGDIANDI, "（可以在这里写下你愿意和朋友分享的一切内容）")
  else
    Edt_SetTxt(self.UIGROUP, TXT_INFOBLOGDIANDI, dianDI)
  end

  Wnd_SetEnable(self.UIGROUP, BTN_BLOGLINGCHEN, 0)
  Wnd_SetEnable(self.UIGROUP, BTN_BLOGSHANGWU, 0)
  Wnd_SetEnable(self.UIGROUP, BTN_BLOGZHONGWU, 0)
  Wnd_SetEnable(self.UIGROUP, BTN_BLOGXIAWU, 0)
  Wnd_SetEnable(self.UIGROUP, BTN_BLOGWANSHANG, 0)
  Wnd_SetEnable(self.UIGROUP, BTN_BLOGWUYE, 0)

  local lingChen = 0
  local shangWu = 0
  local zhongWu = 0
  local xiaWu = 0
  local wanShang = 0
  local wuYe = 0

  lingChen, shangWu, zhongWu, xiaWu, wanShang, wuYe = KPProfile.ValueOffset(nOnlineTime)

  if lingChen == 1 then
    Img_SetFrame(self.UIGROUP, BTN_BLOGLINGCHEN, 2)
  else
    Img_SetFrame(self.UIGROUP, BTN_BLOGLINGCHEN, 0)
  end

  if shangWu == 1 then
    Img_SetFrame(self.UIGROUP, BTN_BLOGSHANGWU, 2)
  else
    Img_SetFrame(self.UIGROUP, BTN_BLOGSHANGWU, 0)
  end

  if zhongWu == 1 then
    Img_SetFrame(self.UIGROUP, BTN_BLOGZHONGWU, 2)
  else
    Img_SetFrame(self.UIGROUP, BTN_BLOGZHONGWU, 0)
  end

  if xiaWu == 1 then
    Img_SetFrame(self.UIGROUP, BTN_BLOGXIAWU, 2)
  else
    Img_SetFrame(self.UIGROUP, BTN_BLOGXIAWU, 0)
  end

  if wanShang == 1 then
    Img_SetFrame(self.UIGROUP, BTN_BLOGWANSHANG, 2)
  else
    Img_SetFrame(self.UIGROUP, BTN_BLOGWANSHANG, 0)
  end

  if wuYe == 1 then
    Img_SetFrame(self.UIGROUP, BTN_BLOGWUYE, 2)
  else
    Img_SetFrame(self.UIGROUP, BTN_BLOGWUYE, 0)
  end
end

-- 解析城市
function uiBlogViewPlayer:ParseBlogCity(szBlogCity)
  local nSeparate = string.find(szBlogCity, "\\")
  if not nSeparate then
    return "无", "无"
  end
  local szProvice = string.sub(szBlogCity, 0, nSeparate - 1)
  local szCity = string.sub(szBlogCity, nSeparate + 1)
  if szProvice == "" or szCity == "" then
    return "无", "无"
  end
  return szProvice, szCity
end

-- 生日转星座
function uiBlogViewPlayer:BirthDay2Star(nMonth, nDay)
  for szStarName, tbInfo in pairs(STAR_MAP) do
    if (nMonth == tbInfo[1] and nDay >= tbInfo[2]) or (nMonth == tbInfo[3] and nDay <= tbInfo[4]) then -- 星座是跨月的
      return szStarName
    end
  end
  return ""
end
