-----------------------------------------------------
--文件名		：	sns_client.lua
--创建者		：	wangzhiguang
--创建时间		：	2011-03-18
--功能描述		：	SNS功能客户端逻辑
------------------------------------------------------

Require("\\script\\lib\\json.lua")
Require("\\script\\sns\\sns_def.lua")
Require("\\script\\sns\\sns_base.lua")

--存储异步执行中的任务信息
Sns.nJobId = 1
Sns.tbJobs = {}
Sns.tbAccount = Sns.tbAccount or {} --为了重载
Sns.SAVE_SCREEN_NOTIFY_THRESHOLD = 5 --5次截图后就不再弹气泡提示
Sns.nSaveScreenCount = 0
Sns.nTimelineInterval = 600 --每10分钟查询一次时间线

--创建微博操作任务
function Sns:CreateJob(tbSns, szHttpMethod, szHttpCallback, szUrlCallback)
  local nJobId = self.nJobId
  self.nJobId = nJobId + 1
  local tbJob = {
    ["nId"] = nJobId,
    ["tbSns"] = tbSns,
    ["szHttpMethod"] = szHttpMethod,
    ["szHttpCallback"] = szHttpCallback,
  }
  if szUrlCallback then
    tbJob["szUrlCallback"] = szUrlCallback
  end
  self.tbJobs[nJobId] = tbJob
  return tbJob
end

--通过ID获取缓存的微博操作任务
function Sns:GetJob(nJobId)
  return self.tbJobs[nJobId]
end

--向服务端请求数字签名后的URL
function Sns:RequestSignedUrl(szUrl, szTokenKey, szTokenSecret, tbJob)
  me.CallServerScript({
    "SnsCmd",
    "OAuthSignUrl",
    tbJob.tbSns.nId,
    tbJob.tbSns.nSignMethod,
    szUrl,
    tbJob.szHttpMethod,
    szTokenKey,
    szTokenSecret,
    tbJob.nId,
  })
end

--URL签名后的统一处理函数
function Sns:OnSignedUrl(szSignedUrl, nJobId)
  local tbJob = assert(self:GetJob(nJobId))
  if not tbJob.szUrlCallback then
    --大多数情况都直接请求
    self:DoHttpRequest(szSignedUrl, tbJob)
  else
    --特殊情况，需要对URL做处理。目前是TweetWithPic
    local f = assert(self[tbJob.szUrlCallback])
    f(self, szSignedUrl, tbJob)
  end
end

--收到HTTP响应后的统一处理函数
function Sns:OnHttpResponse(szResponse, nJobId)
  local function GetJob(nId)
    local tbJob = assert(Sns.tbJobs[nId])
    if tbJob and tbJob.bKeepJob ~= 1 then
      Sns.tbJobs[nId] = nil
    end
    return tbJob
  end
  local tbJob = GetJob(nJobId)
  local f = assert(self[tbJob.szHttpCallback])
  f(self, szResponse, tbJob)
end

--客户端重新加载SNS相关的脚本
function Sns:Reload()
  DoScript("\\script\\lib\\json.lua")
  DoScript("\\script\\sns\\sns_def.lua")
  DoScript("\\script\\sns\\sns_client.lua")
  DoScript("\\script\\sns\\sns_base.lua")
  DoScript("\\script\\sns\\sns_t_tencent.lua")
  DoScript("\\script\\sns\\sns_t_sina.lua")
end

--执行普通的GET和POST请求，也就是不带图片的
function Sns:DoHttpRequest(szUrl, tbJob)
  if tbJob.szHttpMethod == Sns.HTTP_METHOD_GET then
    HttpGet(szUrl, tbJob.nId)
  else
    local szPureUrl, szPostArgs
    local nIndex = string.find(szUrl, "?")
    if nIndex then
      szPureUrl = string.sub(szUrl, 0, nIndex - 1)
      szPostArgs = string.sub(szUrl, nIndex + 1)
    else
      szPureUrl = szUrl
      szPostArgs = ""
    end
    HttpPost(szPureUrl, szPostArgs, tbJob.nId)
  end
end

--从HTTP的json响应得到一个lua table
function Sns:ParseJsonResponse(szJsonValue)
  local szAnsi = Utf8ToAnsi(szJsonValue)
  if self.bDebug == 1 then
    print("================================================================================")
    print(szAnsi)
    print("================================================================================")
  end
  return Lib.json.decode(szAnsi)
end

--开始授权流程
function Sns:BeginAuthorization(nSnsId)
  local tbSns = Sns:GetSnsObject(nSnsId)
  local tbJob = self:CreateJob(tbSns, tbSns.HTTP_METHOD_REQUEST_TOKEN, "RequestToken_OnHttpResponse")
  tbJob.bKeepJob = 1
  local szCallbackUrl = self:GetOAuthCallbackUrl(tbJob)
  local szUrl = tbSns:GetUrl_RequestToken(szCallbackUrl)
  --注意,在申请request_token的时候,
  --只用consumer key和consumer secret进行签名
  self:RequestSignedUrl(szUrl, "", "", tbJob)
  return tbJob.nId
end

--获取request token请求中oauth_callback参数对应的url
function Sns:GetOAuthCallbackUrl(tbJob)
  local nPort = GetOAuthHttpListenPort()
  if nPort == 0 then
    return nil
  else
    local szUrl = string.format("http://127.0.0.1:%d/?id=%d", nPort, tbJob.nId)
    szUrl = UrlEncode(szUrl)
    return szUrl
  end
end

--程序截获到对http://127.0.0.1:[nPort]/?oauth_verifier=[szVerifier]&id=[nId]的访问后
--提取出oauth_verifier=[szVerifier]&id=[nId]部分，
--作为参数szQueryString调此函数
--id对应Sns:BeginAuthorization的返回值tbJob.nId
function Sns:ProcessOAuthCallback(szQueryString)
  local tb = Sns:ParseQueryString(szQueryString)
  if tb then
    local szVerifier = tb["oauth_verifier"]
    local nJobId = tonumber(tb["id"])
    if type(szVerifier) == "string" and type(nJobId) == "number" then
      local tbJob = self:GetJob(nJobId)
      if not tbJob then
        return
      end

      local uiSnsVerifier = Ui.tbWnd[Ui.UI_SNS_VERIFIER]
      local callback
      if UiManager:WindowVisible(uiSnsVerifier.UIGROUP) == 1 then
        callback = function()
          uiSnsVerifier:Close(1)
        end
      else
        callback = function()
          UiManager:OpenWindow(Ui.UI_SNS_FOLLOW, tbJob.tbSns.nId)
        end
      end
      self:RequestToken_OnVerifierEntered(szVerifier, tbJob, callback)
    end
  end
end

function Sns:RequestToken_OnHttpResponse(szResponse, tbJob)
  local tbSns = tbJob.tbSns
  local szTokenKey, szTokenSecret = tbSns:ExtractTokenAndSecret(szResponse)
  if not szTokenKey or not szTokenSecret then
    print("Invalid token/secret!")
    return
  else
    tbJob.szTokenKey = szTokenKey
    tbJob.szTokenSecret = szTokenSecret
    local szUrl = tbSns:GetUrl_Authorize(szTokenKey)
    OpenBrowser(szUrl)
  end
end

--用户输入授权码后的处理
function Sns:RequestToken_OnVerifierEntered(szVerifier, tbJob, fnCallback)
  assert(tbJob)
  local tbSns = tbJob.tbSns
  tbJob.szHttpCallback = "AccessToken_OnHttpResponse"
  tbJob.fnCallback = fnCallback
  tbJob.szHttpMethod = tbSns.HTTP_METHOD_ACCESS_TOKEN
  tbJob.bKeepJob = 0
  local szUrl = tbSns:GetUrl_AccessToken(szVerifier)
  self:RequestSignedUrl(szUrl, tbJob.szTokenKey, tbJob.szTokenSecret, tbJob)
end

function Sns:AccessToken_OnHttpResponse(szResponse, tbJob)
  local tbSns = tbJob.tbSns
  local szTokenKey, szTokenSecret = tbSns:ExtractTokenAndSecret(szResponse)
  if szTokenKey and szTokenSecret then
    --回调在取到帐号信息后再处理
    self:SaveAuthInfo(tbSns, szTokenKey, szTokenSecret, tbJob.fnCallback)
    Ui(Ui.UI_TASKTIPS):Begin(string.format("【社交网络】关联至<color=yellow>%s<color>成功。", tbSns.szName))
  else
    Ui(Ui.UI_TASKTIPS):Begin(string.format("【社交网络】关联至<color=yellow>%s<color>失败。", tbSns.szName))
  end
end

function Sns:NotifyServer(nSnsId, nEventKind, ...)
  me.CallServerScript({ "SnsCmd", "OnClientEvent", nSnsId, nEventKind, ... })
end

function Sns:SaveAuthInfo(tbSns, szTokenKey, szTokenSecret, fnCallback)
  tbSns:SetTokenKey(szTokenKey)
  tbSns:SetTokenSecret(szTokenSecret)
  me.CallServerScript({ "SnsCmd", "SetSnsBind", tbSns.nId, 1 })
  self:GetSelfInfo(tbSns, szTokenKey, szTokenSecret, fnCallback)
end

function Sns:ClearAuthInfo(tbSns)
  tbSns:SetTokenKey("")
  tbSns:SetTokenSecret("")
  me.CallServerScript({ "SnsCmd", "SetSnsBind", tbSns.nId, 0 })
  local szAccount = self.tbAccount[tbSns.nId]
  if szAccount then
    self:DeleteSelfInfo(tbSns)
    self.tbAccount[tbSns.nId] = nil
    self:NotifyServer(tbSns.nId, Sns.EVENT_UNAUTHORIZED, { ["szAccount"] = szAccount })
  else
    local nProfileParamId = self:ToProfileParamId(tbSns.nId)
    local callback = function(tbInfo)
      self:DeleteSelfInfo(tbSns)
      local szAccount = tbInfo[me.szName][nProfileParamId]
      self:NotifyServer(tbSns.nId, Sns.EVENT_UNAUTHORIZED, { ["szAccount"] = szAccount })
    end
    PProfile:RequireSnsInfo({ me.szName }, callback)
  end
end

--从SNS服务获取用户本人帐号信息
function Sns:GetSelfInfo(tbSns, szTokenKey, szTokenSecret, fnCallback)
  local szUrl = tbSns:GetUrl_SelfInfo()
  local tbJob = self:CreateJob(tbSns, tbSns.HTTP_METHOD_SELF_INFO, "GetSelfInfo_OnHttpResponse")
  tbJob.fnCallback = fnCallback
  self:RequestSignedUrl(szUrl, szTokenKey, szTokenSecret, tbJob)
end

function Sns:GetSelfInfo_OnHttpResponse(szResponse, tbJob)
  local tbSns = tbJob.tbSns
  local tbResponse = self:ParseJsonResponse(szResponse)
  local nRet = tbSns:AnalyseResponse(tbResponse)
  if nRet == Sns.SNS_RESULT_OK then
    local szUserName = tbSns:GetUserName(tbResponse)
    if #szUserName > 0 then
      local szHttpAddress = tbSns:GetProfileImageUrl(tbResponse)
      tbSns:AddMySnsImgFilePath(szHttpAddress)
      self.tbAccount[tbSns.nId] = szUserName
      local nProfileParamId = self:ToProfileParamId(tbSns.nId)
      PProfile:ApplyEditStr(nProfileParamId, szUserName)
      self:NotifyServer(tbSns.nId, Sns.EVENT_AUTHORIZED, { ["szAccount"] = szUserName })
      if type(tbJob.fnCallback) == "function" then
        tbJob.fnCallback()
      end
    end
  end
end

function Sns:GetSnsHeadImgInfo(tbSns)
  local szTokenKey = tbSns:GetTokenKey()
  if #szTokenKey > 0 then
    local szTokenSecret = tbSns:GetTokenSecret()
    local callback = function(tbInfo)
      return 1
    end

    local szUrl = tbSns:GetUrl_SelfInfo()
    local tbJob = self:CreateJob(tbSns, tbSns.HTTP_METHOD_SELF_INFO, "GetSnsHeadImgInfo_OnHttpResponse")
    tbJob.fnCallback = callback
    self:RequestSignedUrl(szUrl, szTokenKey, szTokenSecret, tbJob)
  end
end

function Sns:GetSnsHeadImgInfo_OnHttpResponse(szResponse, tbJob)
  local tbSns = tbJob.tbSns
  local tbResponse = self:ParseJsonResponse(szResponse)
  local nRet = tbSns:AnalyseResponse(tbResponse)
  if nRet == Sns.SNS_RESULT_OK then
    local szUserName = tbSns:GetUserName(tbResponse)
    if #szUserName > 0 then
      local szHttpAddress = tbSns:GetProfileImageUrl(tbResponse)
      tbSns:AddMySnsImgFilePath(szHttpAddress)
      if type(tbJob.fnCallback) == "function" then
        tbJob.fnCallback()
      end
    end
  end
end

function Sns:DeleteSelfInfo(tbSns)
  local nProfileParamId = self:ToProfileParamId(tbSns.nId)
  PProfile:ApplyEditStr(nProfileParamId, "")
end

--被服务端调用，弹出入口按钮的泡泡
function Sns:OnNotifyNewTweet(szPopupMessage, szTweet)
  local uiSnsEntrance = Ui.tbWnd[Ui.UI_SNS_ENTRANCE]
  uiSnsEntrance:SetNextTweet(szTweet)
  uiSnsEntrance:ShowPopupTip(szPopupMessage)
  uiSnsEntrance:Blink(5)
end

--发送一条广播
--假设已授权，未授权的处理在窗口open时处理
function Sns:Tweet(nSnsId, szTweet, fnCallback)
  if type(szTweet) ~= "string" or #szTweet == 0 then
    print("Tweet can not be empty!")
    return
  end
  --必须做这两步处理，否则muti-byte character会乱码的
  szTweet = AnsiToUtf8(szTweet)
  szTweet = UrlEncode(szTweet)
  local tbSns = Sns:GetSnsObject(nSnsId)
  local tbJob = self:CreateJob(tbSns, tbSns.HTTP_METHOD_TWEET, "Tweet_OnHttpResponse")
  tbJob.fnCallback = fnCallback
  local szUrl = tbSns:GetUrl_Tweet(szTweet)
  local szTokenKey = tbSns:GetTokenKey()
  local szTokenSecret = tbSns:GetTokenSecret()
  self:RequestSignedUrl(szUrl, szTokenKey, szTokenSecret, tbJob)
end

function Sns:Tweet_OnHttpResponse(szResponse, tbJob)
  self:Tweet_ProcessResult(tbJob, szResponse, 0)
end
function Sns:Tweet_ProcessResult(tbJob, szResponse, bWithPic)
  local tbSns = tbJob.tbSns
  local tbResponse = self:ParseJsonResponse(szResponse)
  local nRetCode, szError = tbSns:AnalyseResponse(tbResponse)

  local szMsg
  if nRetCode == Sns.SNS_RESULT_OK then
    szMsg = string.format("【社交网络】发布消息至<color=yellow>%s<color>成功。", tbSns.szName)
    local nEventKind = bWithPic == 0 and Sns.EVENT_TWEET or Sns.EVENT_TWEET_PIC
    local szTweetId = tbSns:GetTweetId(tbResponse)
    local tbData = {
      ["szAccount"] = self.tbAccount[tbSns.nId],
      ["szTweetId"] = szTweetId,
    }
    self:NotifyServer(tbSns.nId, nEventKind, tbData)
    if type(tbJob.fnCallback) == "function" then
      tbJob.fnCallback()
    end
  elseif nRetCode == Sns.SNS_RESULT_REVOKED then
    szMsg = string.format("【社交网络】貌似您取消了和<color=yellow>%s<color>帐号的关联。为了正常使用，需要重新关联。", tbSns.szName)
    self:ClearAuthInfo(tbSns)
  elseif nRetCode == Sns.SNS_RESULT_FAIL then
    szMsg = string.format("【社交网络】发布消息至<color=yellow>%s<color>失败。", tbSns.szName)
  end
  me.Msg(szMsg)
end

--发送一条带图片的广播
--假设已授权，未授权的处理在窗口open时处理
function Sns:TweetWithPic(nSnsId, szTweet, szPicPath, fnCallback)
  if type(szTweet) ~= "string" or #szTweet == 0 then
    print("Tweet can not be empty!")
    return
  end
  if type(szPicPath) ~= "string" or #szPicPath == 0 then
    print("Pic Path can not be empty!")
    return
  end
  --必须做这两步处理，否则muti-byte character会乱码的
  szTweet = AnsiToUtf8(szTweet)
  szTweet = UrlEncode(szTweet)
  local tbSns = Sns:GetSnsObject(nSnsId)
  local tbJob = self:CreateJob(tbSns, tbSns.HTTP_METHOD_TWEET_WITH_PIC, "TweetWithPic_OnHttpResponse", "TweetWithPic_OnSignedUrl")
  tbJob.szPicPath = szPicPath
  tbJob.fnCallback = fnCallback
  --这里参数带上图片路径是为了统一接口。虽然目前URL还用不到该路径
  local szUrl = tbSns:GetUrl_TweetWithPic(szTweet, szPicPath)
  local szTokenKey = tbSns:GetTokenKey()
  local szTokenSecret = tbSns:GetTokenSecret()
  self:RequestSignedUrl(szUrl, szTokenKey, szTokenSecret, tbJob)
end

function Sns:TweetWithPic_OnSignedUrl(szUrl, tbJob)
  local tbSns = tbJob.tbSns
  local tbPostArgs
  szUrl, tbPostArgs = self:SplitUrl(szUrl)
  HttpPostPic(szUrl, tbPostArgs, tbSns.PARAM_NAME_PIC, tbJob.szPicPath, tbJob.nId)
end

function Sns:TweetWithPic_OnHttpResponse(szResponse, tbJob)
  self:Tweet_ProcessResult(tbJob, szResponse, 1)
end

function Sns:SplitUrl(szUrl)
  local nIndex = string.find(szUrl, "?")
  local szPureUrl = string.sub(szUrl, 0, nIndex - 1)
  local szPostArgs = string.sub(szUrl, nIndex + 1)

  local tbPostArgs = {}
  szPostArgs = string.gsub(szPostArgs, "[&=]", " ")
  local n = 1
  for w in string.gmatch(szPostArgs, "([^ ]+)") do
    --将value转换为URL ENCODE前的格式, 因为multipart/form-data定义中的value不需要被转义
    if n % 2 == 0 then
      w = UrlDecode(w)
    end
    tbPostArgs[n] = w
    n = n + 1
  end

  return szPureUrl, tbPostArgs
end

function Sns:TestCallback(szResponse, nJobId)
  --print(szResponse);
  print("nJobId:", nJobId)
  print("Response Length:", #szResponse)
end

--收听某人
function Sns:Follow(nSnsId, szAccount, szPlayerName, fnCallback)
  local tbSns = Sns:GetSnsObject(nSnsId)
  local szUrl = tbSns:GetUrl_Follow(szAccount)
  local tbJob = self:CreateJob(tbSns, tbSns.HTTP_METHOD_FOLLOW, "Follow_OnHttpResponse")
  tbJob.szAccount = szAccount
  tbJob.szPlayerName = szPlayerName
  tbJob.fnCallback = fnCallback
  local szTokenKey = tbSns:GetTokenKey()
  local szTokenSecret = tbSns:GetTokenSecret()
  self:RequestSignedUrl(szUrl, szTokenKey, szTokenSecret, tbJob)
end

function Sns:Follow_OnHttpResponse(szResponse, tbJob)
  local tbSns = tbJob.tbSns
  local tbResponse = self:ParseJsonResponse(szResponse)
  local nRetCode, szError = tbSns:AnalyseFollowResponse(tbResponse)
  local szMsg
  if nRetCode == Sns.SNS_RESULT_OK then
    szMsg = string.format("【社交网络】在<color=yellow>%s<color>收听<color=yellow>%s<color>成功。", tbSns.szName, tbJob.szPlayerName)
    local tbData = {
      ["szMyAccount"] = self.tbAccount[tbSns.nId],
      ["szTargetAccount"] = tbJob.szAccount,
      ["szTargetPlayerName"] = tbJob.szPlayerName,
    }
    self:NotifyServer(tbSns.nId, Sns.EVENT_FOLLOW, tbData)
    if type(tbJob.fnCallback) == "function" then
      tbJob.fnCallback()
    end
  elseif nRetCode == Sns.SNS_RESULT_REVOKED then
    szMsg = string.format("【社交网络】貌似您取消了和<color=yellow>%s<color>帐号的关联。为了正常使用，需要重新关联。", tbSns.szName)
    self:ClearAuthInfo(tbSns)
  elseif nRetCode == Sns.SNS_RESULT_FAIL then
    szMsg = string.format("【社交网络】在<color=yellow>%s<color>收听<color=yellow>%s<color>失败。", tbSns.szName, tbJob.szPlayerName)
  end
  me.Msg(szMsg)
end

--取消收听某人
function Sns:Unfollow(nSnsId, szAccount, szPlayerName, fnCallback)
  local tbSns = Sns:GetSnsObject(nSnsId)
  local szUrl = tbSns:GetUrl_Unfollow(szAccount)
  local tbJob = self:CreateJob(tbSns, tbSns.HTTP_METHOD_UNFOLLOW, "Unfollow_OnHttpResponse")
  tbJob.szAccount = szAccount
  tbJob.szPlayerName = szPlayerName
  tbJob.fnCallback = fnCallback
  local szTokenKey = tbSns:GetTokenKey()
  local szTokenSecret = tbSns:GetTokenSecret()
  self:RequestSignedUrl(szUrl, szTokenKey, szTokenSecret, tbJob)
end

function Sns:Unfollow_OnHttpResponse(szResponse, tbJob)
  local tbSns = tbJob.tbSns
  local tbResponse = self:ParseJsonResponse(szResponse)
  local nRetCode, szError = tbSns:AnalyseUnfollowResponse(tbResponse)
  local szMsg
  if nRetCode == Sns.SNS_RESULT_OK then
    szMsg = string.format("【社交网络】在<color=yellow>%s<color>取消收听<color=yellow>%s<color>成功。", tbSns.szName, tbJob.szPlayerName)
    local tbData = {
      ["szMyAccount"] = self.tbAccount[tbSns.nId],
      ["szTargetAccount"] = tbJob.szAccount,
      ["szTargetPlayerName"] = tbJob.szPlayerName,
    }
    self:NotifyServer(tbSns.nId, Sns.EVENT_UNFOLLOW, tbData)
    if type(tbJob.fnCallback) == "function" then
      tbJob.fnCallback()
    end
  elseif nRetCode == Sns.SNS_RESULT_REVOKED then
    szMsg = string.format("【社交网络】貌似您取消了和<color=yellow>%s<color>帐号的关联。为了正常使用，需要重新关联。", tbSns.szName)
    self:ClearAuthInfo(tbSns)
  elseif nRetCode == Sns.SNS_RESULT_FAIL then
    szMsg = string.format("【社交网络】在<color=yellow>%s<color>取消收听<color=yellow>%s<color>失败。", tbSns.szName, tbJob.szPlayerName)
  end
  me.Msg(szMsg)
end

function Sns:IsFollowing(nSnsId, szAccount, fnCallback)
  local tbSns = Sns:GetSnsObject(nSnsId)
  local szUrl = tbSns:GetUrl_IsFollowing(szAccount)
  local tbJob = self:CreateJob(tbSns, tbSns.HTTP_METHOD_IS_FOLLOWING, "IsFollowing_OnHttpResponse")
  tbJob.szAccount = szAccount
  tbJob.fnCallback = fnCallback
  local szTokenKey = tbSns:GetTokenKey()
  local szTokenSecret = tbSns:GetTokenSecret()
  self:RequestSignedUrl(szUrl, szTokenKey, szTokenSecret, tbJob)
end

function Sns:IsFollowing_OnHttpResponse(szResponse, tbJob)
  local tbSns = tbJob.tbSns
  local tbResponse = self:ParseJsonResponse(szResponse)
  local nRetCode, szError = tbSns:AnalyseResponse(tbResponse)
  if nRetCode == Sns.SNS_RESULT_OK then
    if type(tbJob.fnCallback) == "function" then
      local bIsFollowing = tbSns:AnalyseIsFollowingResponse(tbResponse, tbJob.szAccount)
      if bIsFollowing == 1 or bIsFollowing == 0 then
        tbJob.fnCallback(bIsFollowing)
      end
    end
  elseif nRetCode == Sns.SNS_RESULT_REVOKED then
    self:ClearAuthInfo(tbSns)
  end
end

function Sns:OnEnterGame()
  -- 重置头像
  ResetMyPortrait()
  self.bInGame = 1
  --清除上个登录角色可能遗留的数据
  self.tbAccount = {} --玩家自己的SNS帐号
  self.tbHasNewTweet = {} --玩家好友是否发新微博的标记
  self.tbFriendAccount = --玩家好友的SNS帐号
    {
      [Sns.SNS_T_TENCENT] = {},
      [Sns.SNS_T_SINA] = {},
    }
  local uiSnsMain = Ui.tbWnd[Ui.UI_SNS_MAIN] or Ui:GetClass("sns_main")
  uiSnsMain:DeleteTweet()
  uiSnsMain:DeleteScreen()

  if Sns.bIsOpen == 0 then
    return
  end

  --为了保证修改角色数据有效，延迟执行到加载完全
  self.nEnterGameRegisterId = Timer:Register(18 * 3, self._OnEnterGame, self)

  --读取截图次数
  local nCount = self:GetSaveScreenCount()
  self.nSaveScreenCount = math.max(self.nSaveScreenCount, nCount)

  local uiScreen = Ui.tbWnd[Ui.UI_CAPTURE_SCREEN]
  uiSnsMain:OnEnterGame()
  uiScreen:OnEnterGame()
  Sns:GetAllSnsImgPath()
  self:GetMySnsInfo()
  local tbRelation = Ui.tbWnd[Ui.UI_RELATIONNEW]
  tbRelation:OnEnterGame()
end

function Sns:GetAllSnsImgPath()
  for nSnsId, tbSns in pairs(Sns.tbSns) do
    tbSns:ResetImgTable()
    tbSns:CheckAllImgDuringFold()
  end
end

function Sns:GetHttpImageFileName(nSnsId, szHttpAddress)
  local tbSns = Sns:GetSnsObject(nSnsId)
  if not tbSns then
    return 0
  end
  --	return tbSns:GetHttpImgFileName(szHttpAddress);
end

function Sns:GetImagePath(nSnsId, szPlayerName)
  local tbSns = Sns:GetSnsObject(nSnsId)
  if not tbSns then
    return nil
  end

  local szFilePathFold = tbSns.szPathFold
  local szFileName = tbSns:GetHttpImgFileName(szPlayerName)

  if szPlayerName == me.szName then
    szFileName = tbSns.szMyFileName
  else
    if szFileName and not tbSns.tbImageName2Http[szFileName] or tbSns.tbImageName2Http[szFileName] == "" then
      if not tbSns.tbFriendApplyImgCount then
        tbSns.tbFriendApplyImgCount = {}
      end

      if not tbSns.tbFriendApplyImgCount[szFileName] then
        tbSns.tbFriendApplyImgCount[szFileName] = 0
      end
      if tbSns.tbFriendApplyImgCount[szFileName] < Sns.MAX_APPLY_FRIEND_COUNT then
        self:ApplyPlayerSnsImg(nSnsId, szPlayerName)
        tbSns.tbFriendApplyImgCount[szFileName] = tbSns.tbFriendApplyImgCount[szFileName] + 1
      end
    end
  end

  local szMyPath = szFilePathFold .. "\\" .. szFileName
  if IsDownLoadFileExist(szMyPath) == 1 then
    return szMyPath
  end

  return nil
end

function Sns:SendSnsImg_Client(nSnsId, szPlayer, szHttpAddress)
  local tbSns = Sns:GetSnsObject(nSnsId)
  if not tbSns then
    return nil
  end
  local szMyFileName = tbSns:GetHttpImgFileName(szPlayer)
  if not szMyFileName then
    return
  end
  tbSns.tbImageName2Http[szMyFileName] = szHttpAddress
  tbSns.tbName2Image[szPlayer] = szMyFileName
  tbSns.tbImgFileName[szMyFileName] = 0
  tbSns:DownloadPlayerImg(szHttpAddress, szMyFileName)
end

function Sns:ApplyMySnsImg_Client(nSnsId)
  if Sns.bIsOpen ~= 1 then
    return 0
  end

  local tbSns = Sns:GetSnsObject(nSnsId)
  if not tbSns then
    return nil
  end

  local szHttpAddress = tbSns.szMyImgHttpAddress
  me.CallServerScript({ "ApplyUpdateMySnsImg", nSnsId, szHttpAddress })
end

function Sns:DownloadPlayerImg()
  for nSnsId, tbSns in pairs(Sns.tbSns) do
    tbSns:ProcessMySnsImg()
    tbSns:ProcessAllPlayerImg()
  end
  return
end

function Sns:ApplyPlayerSnsImg(nSnsId, szPlayerName)
  local tbSns = Sns.tbSns[nSnsId]
  if not tbSns.tbApplyTime then
    tbSns.tbApplyTime = {}
  end

  if not tbSns.tbApplyTime[szPlayerName] then
    tbSns.tbApplyTime[szPlayerName] = 0
  end

  if szPlayerName == me.szName then
    self:GetSnsHeadImgInfo(tbSns)
    return
  end

  local nNowTime = GetTime()
  if nNowTime - tbSns.tbApplyTime[szPlayerName] > 30 then
    tbSns.tbApplyTime[szPlayerName] = nNowTime
    me.CallServerScript({ "ApplyPlayerSnsImgAddress", nSnsId, szPlayerName })
  end
end

--角色登录后获取玩家本人及好友的SNS帐号信息。
--完成后获取定时轮询好友时间线检查是否有新tweet
function Sns:_OnEnterGame()
  self:ClearTimer("nEnterGameRegisterId")
  for nSnsId, tbSns in pairs(Sns.tbSns) do
    local szTokenKey = tbSns:GetTokenKey()
    if #szTokenKey > 0 then
      self:GetFriendSnsInfo()
      break
    end
  end
end

function Sns:OnLeaveGame()
  self.bInGame = 0
  self:ClearTimer("nEnterGameRegisterId")
  self:ClearTimer("nTimelineRegisterId")
  local tbRelation = Ui.tbWnd[Ui.UI_RELATIONNEW]
  tbRelation:OnLeaveGame()
end

function Sns:GetMySnsInfo()
  for nSnsId, tbSns in pairs(Sns.tbSns) do
    self:GetSnsHeadImgInfo(tbSns)
    tbSns:AddMySnsImgFilePath()
  end
end

function Sns:ClearTimer(szRegisterIdName)
  local nRegisterId = self[szRegisterIdName]
  if nRegisterId then
    self[szRegisterIdName] = nil
    Timer:Close(nRegisterId)
  end
end

function Sns:GetFriendSnsInfo()
  local function fnCallback(tbInfo)
    local function SaveSnsInfo(tbInfo)
      local tbMyAccount = tbInfo[me.szName]
      for nProfileParamId, szAccount in pairs(tbMyAccount) do
        if #szAccount > 0 then
          local nSnsId = Sns:ToSnsId(nProfileParamId)
          Sns.tbAccount[nSnsId] = szAccount
        end
      end
      local tb = Sns.tbFriendAccount
      for szPlayerName, tbInner in pairs(tbInfo) do
        for nProfileParamId, szAccount in pairs(tbInner) do
          if #szAccount > 0 then
            local nSnsId = Sns:ToSnsId(nProfileParamId)
            local tbAccount = tb[nSnsId][szAccount] or {}
            tbAccount[#tbAccount + 1] = szPlayerName
            tb[nSnsId][szAccount] = tbAccount
          end
        end
      end
    end
    SaveSnsInfo(tbInfo)
    self:GetAllTimeline()
    self.nTimelineRegisterId = Timer:Register(18 * self.nTimelineInterval, self.GetAllTimeline, self)
  end

  local tbPlayerName = { me.szName }
  local _, tbFriends = me.Relation_GetRelationList()
  for szPlayerName, tbInfo in pairs(tbFriends) do
    if tbInfo.nSnsBind > 0 then
      tbPlayerName[#tbPlayerName + 1] = szPlayerName
    end
  end
  PProfile:RequireSnsInfo(tbPlayerName, fnCallback)
end

function Sns:GetAllTimeline()
  local function GetUntilTime(nSnsId)
    local nLastTime = self:GetLastTimestamp(nSnsId)
    local nUntilTime = GetTime() - 3600 --最大获取1小时内的
    if nLastTime > 0 then
      nUntilTime = math.max(nLastTime, nUntilTime)
    end
    return nUntilTime
  end
  for nSnsId, tbSns in pairs(self.tbSns) do
    local nUntilTime = GetUntilTime(nSnsId)
    self:GetTimeline(tbSns, 1, nUntilTime)
  end
end

function Sns:GetLastTimestampFilePath(nSnsId)
  return GetPlayerPrivatePath() .. string.format("timeline_timestamp_%d.txt", nSnsId)
end

function Sns:GetLastTimestamp(nSnsId)
  local szFilePath = self:GetLastTimestampFilePath(nSnsId)
  local szTime = KIo.ReadTxtFile(szFilePath)
  return tonumber(szTime) or 0
end

function Sns:SetLastTimestamp(nSnsId, nTime)
  local szFilePath = self:GetLastTimestampFilePath(nSnsId)
  KIo.WriteFile(szFilePath, tostring(nTime))
end

--截图事件处理，被ui\script\manager\mgr.lua调用
function Sns:OnSaveScreenComplete(tbImageInfo, bFromKeyboard, bCaptureScreenState)
  ----按PrintScreen键截图
  if bFromKeyboard == 1 then
    --如果是在普通状态，提示玩家
    if bCaptureScreenState ~= 1 then
      local uiSnsEntrance = Ui.tbWnd[Ui.UI_SNS_ENTRANCE]
      uiSnsEntrance:Blink(4)
      local nCount = self.nSaveScreenCount
      if nCount < self.SAVE_SCREEN_NOTIFY_THRESHOLD then
        uiSnsEntrance:ShowPopupTip("您可以通过<color=yellow>社交网络<color>把截图分享给朋友们哦！")
        self.nSaveScreenCount = nCount + 1
        self:SetSaveScreenCount(self.nSaveScreenCount)
      end
    end
    local uiSnsMain = Ui.tbWnd[Ui.UI_SNS_MAIN]
    --是否在截图状态决定是否打开sns_main窗口
    uiSnsMain:OnSaveScreenComplete(tbImageInfo, bCaptureScreenState)
  --鼠标右键开始截图
  else
    local uiSnsScreen = Ui.tbWnd[Ui.UI_CAPTURE_SCREEN]
    uiSnsScreen:OnSaveScreenComplete(tbImageInfo)
  end
end

function Sns:GetSaveScreenCountFilePath()
  return "\\user\\history\\save_screen.txt"
end

function Sns:GetSaveScreenCount()
  local szFilePath = self:GetSaveScreenCountFilePath()
  local szCount = KIo.ReadTxtFile(szFilePath)
  return tonumber(szCount) or 0
end

function Sns:SetSaveScreenCount(nCount)
  local szFilePath = self:GetSaveScreenCountFilePath()
  KIo.WriteFile(szFilePath, tostring(self.nSaveScreenCount))
end

function Sns:GoToUrl(szUrl)
  if Ui.szMode == "a" then
    OpenBrowser(szUrl)
  else
    UiManager:OpenWindow(Ui.UI_SNS_BROWSER, szUrl)
  end
end

function Sns:GetTimeline(tbSns, bFirstPage, nUntilTime, tbTimeline)
  local szTokenKey = tbSns:GetTokenKey()
  local szTokenSecret = tbSns:GetTokenSecret()
  if #szTokenKey == 0 or #szTokenSecret == 0 then
    return
  end
  local tbJob = self:CreateJob(tbSns, Sns.HTTP_METHOD_GET, "GetTimeline_OnHttpResponse")
  tbJob.bFirstPage = bFirstPage
  tbJob.nUntilTime = nUntilTime
  local szUrl = tbSns:GetTimelineUrl(bFirstPage, tbTimeline)
  self:RequestSignedUrl(szUrl, szTokenKey, szTokenSecret, tbJob)
  self:SetLastTimestamp(tbSns.nId, GetTime())
end

function Sns:GetTimeline_OnHttpResponse(szResponse, tbJob)
  local tbSns = tbJob.tbSns
  local tbResponse = self:ParseJsonResponse(szResponse)
  local nRet = tbSns:AnalyseResponse(tbResponse)
  if nRet == Sns.SNS_RESULT_OK then
    local tbTimeline = tbSns:ParseTimelineResponse(tbResponse)
    local tbFriendAccount = Sns.tbFriendAccount[tbSns.nId]
    local bNeedNextRequest = #tbTimeline > 0 and 1 or 0
    for n, tbTweet in ipairs(tbTimeline) do
      if tbTweet.nTime > tbJob.nUntilTime then
        if tbTweet.bOriginal == 1 then
          local tbAccount = tbFriendAccount[tbTweet.szAccount]
          if tbAccount then
            for n, szPlayerName in ipairs(tbAccount) do
              local tb = Sns.tbHasNewTweet[szPlayerName] or {}
              tb[tbSns.nId] = tbTweet.szAccount
              Sns.tbHasNewTweet[szPlayerName] = tb
            end
          end
        end
      else
        bNeedNextRequest = 0
        break
      end
    end
    if bNeedNextRequest == 1 then
      self:GetTimeline(tbSns, 0, tbJob.nUntilTime, tbTimeline)
    end
  elseif nRet == Sns.SNS_RESULT_REVOKED then
    local szMsg = string.format("【社交网络】貌似您取消了和<color=yellow>%s<color>帐号的关联。为了正常使用，需要重新关联。", tbSns.szName)
    self:ClearAuthInfo(tbSns)
    me.Msg(szMsg)
  end
end
