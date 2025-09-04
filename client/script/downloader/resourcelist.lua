if not MODULE_GAMECLIENT or not MINI_CLIENT then
  return
end
Require("\\script\\misc\\clientevent.lua")

local szReplaceFile = "\\setting\\downloader\\file_replace.txt"
MiniResource.tbMapExtRes = {
  --	["lingxiucun"] = "map_level_1",
  --	["xiangmiyuan"] = "map_level_5",
}
-- 跳过强制下载地图
MiniResource.tbMapSkip = {
  ["qingluodao2"] = 1,
}
MiniResource.nShowInfo = 0
MiniResource.MapResourceLimitSize = 10 * 1024 * 1024 -- 限制大小，对老玩家才有效
MiniResource.nOldPlayerLevel = 30 -- 老玩家判断方式，等级大于该值才算老玩家

local szBaseResKey = "base"
function MiniResource._GetMapResList(szMapName)
  return MiniResource:GetMapRes(szMapName)
end

-- 需要下载的地图描述
MiniResource.tbMapListWor = {
  -- 桃溪镇
  "\\map_publish\\taoxizhen2.wor",
  -- 花灯乱
  "\\map_publish\\huadengluan2.wor",
  -- 船舱
  "\\map_publish\\ercengchuancang.wor",
  "\\map_publish\\sancengchuancang.wor",
  -- 青螺岛
  "\\map_publish\\qingluodao2.wor",
  -- 任务新手村
  "\\map_publish\\jiangjincun.wor",
  "\\map_publish\\yunzhongzhen.wor",
  "\\map_publish\\yonglezhen.wor",
  -- 碧落谷
  "\\map_publish\\biluogu1.wor",
  -- 汴京府
  "\\map_publish\\bianjingfu1.wor",
  -- 逍遥谷些列
  "\\map_publish\\xiaoyaogu_lv4.wor",
  "\\map_publish\\dalao.wor",
  "\\map_publish\\xiakedao_yb.wor",
  "\\map_publish\\xiaoyaogu_lv3.wor",
  "\\map_publish\\xoyo_108.wor",
  "\\map_publish\\xoyo_109.wor",
  "\\map_publish\\xoyo_110.wor",
  "\\map_publish\\xoyo_111.wor",
  "\\map_publish\\shandong_12.wor",
  "\\map_publish\\ganlugu_tongdao.wor",
  "\\map_publish\\ganlugu_jintou.wor",
  "\\map_publish\\waiyingxiongzhong.wor",
  "\\map_publish\\xoyo_116.wor",
  "\\map_publish\\jimohuashuizhai.wor",
  -- 后续任务
  "\\map_publish\\gaibang.wor",
  "\\map_publish\\yanziwu.wor",
  "\\map_publish\\wudujiao.wor",
  "\\map_publish\\yuanshisenlin.wor",
  "\\map_publish\\daoxiangcun.wor",
  "\\map_publish\\longquancun.wor",
  "\\map_publish\\kunlunpai.wor",
  "\\map_publish\\jianxingfeng.wor",
  "\\map_publish\\wudangpai.wor",
  "\\map_publish\\longhuhuanjing.wor",
  "\\map_publish\\shaolinpai.wor",
  "\\map_publish\\talin.wor",
  "\\map_publish\\tianrenjiao.wor",
  "\\map_publish\\jinguohuangling.wor",
  "\\map_publish\\balingxian.wor",
  "\\map_publish\\shiguzhen.wor",
  "\\map_publish\\emeipai.wor",
  "\\map_publish\\jiulaofeng.wor",
  "\\map_publish\\tangmen.wor",
  "\\map_publish\\hupanzhulin.wor",
  "\\map_publish\\cuiyanmen.wor",
  "\\map_publish\\longmenzhen.wor",
}

MiniResource.tbResource = {
  -- 桃溪镇
  { szBaseResKey, "\\setting\\downloader\\reslist\\village\\image_taoxizhen_1.txt" },
  { "map_wor", MiniResource.tbMapListWor },
  { "map_taoxizhen", MiniResource._GetMapResList, "taoxizhen2" },
  { "player_base_stand_run", "\\setting\\downloader\\reslist\\village\\player_base_stand_run.txt" }, -- 站立，跑步，攻击
  { "npc_taoxizhen_1", "\\setting\\downloader\\reslist\\village\\npc_taoxizhen_1.txt" },
  { "image_taoxizhen_2", "\\setting\\downloader\\reslist\\village\\image_taoxizhen_2.txt" },
  { "npc_taoxizhen_2", "\\setting\\downloader\\reslist\\village\\npc_taoxizhen_2.txt" },
  { "player_base_ride", "\\setting\\downloader\\reslist\\village\\player_base_ride.txt" }, -- 玩家骑马相关
  { "player_base_horse", "\\setting\\downloader\\reslist\\village\\player_base_horse.txt" }, -- 马部件
  { "npc_taoxizhen_3", "\\setting\\downloader\\reslist\\village\\npc_taoxizhen_3.txt" },
  { "fightskill_icon", "\\setting\\downloader\\reslist\\fightskill_icon.txt" },
  -- 花灯乱
  { "map_huadengluan", MiniResource._GetMapResList, "huadengluan2" },
  { "image_huadengluan_1", "\\setting\\downloader\\reslist\\village\\image_huadengluan_1.txt" },
  { "npc_huadengluan_1", "\\setting\\downloader\\reslist\\village\\npc_huadengluan_1.txt" },
  { "image_huadengluan_2", "\\setting\\downloader\\reslist\\village\\image_huadengluan_2.txt" },
  { "npc_huadengluan_2", "\\setting\\downloader\\reslist\\village\\npc_huadengluan_2.txt" },
  { "image_huadengluan_3", "\\setting\\downloader\\reslist\\village\\image_huadengluan_3.txt" },
  -- 青螺岛
  { "map_qingluodao_part", "\\setting\\downloader\\reslist\\village\\map_qingluodao_part.txt" },
  { "npc_qingluodao_part", "\\setting\\downloader\\reslist\\village\\npc_qingluodao_part.txt" },
  { "image_qingluodao_part", "\\setting\\downloader\\reslist\\village\\image_qingluodao_part.txt" },
  -- 二层船舱
  { "map_ercengchuancang", MiniResource._GetMapResList, "ercengchuancang" },
  { "npc_ercengchuancang", "\\setting\\downloader\\reslist\\village\\npc_ercengchuancang.txt" },
  { "image_ercengchuancang", "\\setting\\downloader\\reslist\\village\\image_ercengchuancang.txt" },
  -- 三层船舱
  { "npc_sancengchuancang", MiniResource._GetMapResList, "sancengchuancang" },
  { "image_sancengchuancang", "\\setting\\downloader\\reslist\\village\\image_sancengchuancang.txt" },
  -- 青螺岛
  { "map_qingluodao", MiniResource._GetMapResList, "qingluodao2" },
  -- 名字命名错了，是青螺岛任务载具[2012/9/14 17:14:43]目前屏蔽掉，太大了
  --{"npc_biluogu",				"\\setting\\downloader\\reslist\\biluogu_chariot.txt"},
  -- 任务三个新手村
  { "map_jiangjincun", MiniResource._GetMapResList, "jiangjincun" },
  { "map_yunzhongzhen", MiniResource._GetMapResList, "yunzhongzhen" },
  { "map_yonglezhen", MiniResource._GetMapResList, "yonglezhen" },
  -- 任务藏宝地图,碧落谷
  { "map_biluogu1", MiniResource._GetMapResList, "biluogu1" },
  -- 汴京府
  { "map_bianjingfu1", MiniResource._GetMapResList, "bianjingfu1" },
  -- 逍遥谷
  { "map_xiaoyao4", MiniResource._GetMapResList, "xiaoyaogu_lv4" },
  { "map_dalao", MiniResource._GetMapResList, "dalao" },
  { "map_xiakedao_yb", MiniResource._GetMapResList, "xiakedao_yb" },
  { "map_xiaoyao3", MiniResource._GetMapResList, "xiaoyaogu_lv3" },
  { "map_xoyo_108", MiniResource._GetMapResList, "xoyo_108" },
  { "map_xoyo_109", MiniResource._GetMapResList, "xoyo_109" },
  { "map_xoyo_110", MiniResource._GetMapResList, "xoyo_110" },
  { "map_xoyo_111", MiniResource._GetMapResList, "xoyo_111" },
  { "map_shandong_12", MiniResource._GetMapResList, "shandong_12" },
  { "map_ganlugu_tongdao", MiniResource._GetMapResList, "ganlugu_tongdao" },
  { "map_ganlugu_jintou", MiniResource._GetMapResList, "ganlugu_jintou" },
  { "map_waiyingxiongzhong", MiniResource._GetMapResList, "waiyingxiongzhong" },
  { "map_xoyo_116", MiniResource._GetMapResList, "xoyo_116" },
  { "map_jimohuashuizhai", MiniResource._GetMapResList, "jimohuashuizhai" },
  -- 剩余地图
  { "map_gaibang", MiniResource._GetMapResList, "gaibang" },
  { "map_yanziwu", MiniResource._GetMapResList, "yanziwu" },
  { "map_wudujiao", MiniResource._GetMapResList, "wudujiao" },
  { "map_yuanshisenlin", MiniResource._GetMapResList, "yuanshisenlin" },
  { "map_daoxiangcun", MiniResource._GetMapResList, "daoxiangcun" },
  { "map_longquancun", MiniResource._GetMapResList, "longquancun" },
  { "map_kunlunpai", MiniResource._GetMapResList, "kunlunpai" },
  { "map_jianxingfeng", MiniResource._GetMapResList, "jianxingfeng" },
  { "map_wudangpai", MiniResource._GetMapResList, "wudangpai" },
  { "map_longhuhuanjing", MiniResource._GetMapResList, "longhuhuanjing" },
  { "map_shaolinpai", MiniResource._GetMapResList, "shaolinpai" },
  { "map_talin", MiniResource._GetMapResList, "talin" },
  { "map_tianrenjiao", MiniResource._GetMapResList, "tianrenjiao" },
  { "map_jinguohuangling", MiniResource._GetMapResList, "jinguohuangling" },
  { "map_balingxian", MiniResource._GetMapResList, "balingxian" },
  { "map_shiguzhen", MiniResource._GetMapResList, "shiguzhen" },
  { "map_emeipai", MiniResource._GetMapResList, "emeipai" },
  { "map_jiulaofeng", MiniResource._GetMapResList, "jiulaofeng" },
  { "map_tangmen", MiniResource._GetMapResList, "tangmen" },
  { "map_hupanzhulin", MiniResource._GetMapResList, "hupanzhulin" },
  { "map_cuiyanmen", MiniResource._GetMapResList, "cuiyanmen" },
  { "map_longmenzhen", MiniResource._GetMapResList, "longmenzhen" },
}
-- 10级的门派技能
MiniResource.tbFightSkill = {
  [1] = "\\setting\\downloader\\reslist\\fightskill\\shaolin.txt",
  [2] = "\\setting\\downloader\\reslist\\fightskill\\tianwang.txt",
  [3] = "\\setting\\downloader\\reslist\\fightskill\\tangmen.txt",
  [4] = "\\setting\\downloader\\reslist\\fightskill\\wudu.txt",
  [5] = "\\setting\\downloader\\reslist\\fightskill\\emei.txt",
  [6] = "\\setting\\downloader\\reslist\\fightskill\\cuiyan.txt",
  [7] = "\\setting\\downloader\\reslist\\fightskill\\gaibang.txt",
  [8] = "\\setting\\downloader\\reslist\\fightskill\\tianren.txt",
  [9] = "\\setting\\downloader\\reslist\\fightskill\\wudang.txt",
  [10] = "\\setting\\downloader\\reslist\\fightskill\\kunlun.txt",
  [11] = "\\setting\\downloader\\reslist\\fightskill\\mingjiao.txt",
  [12] = "\\setting\\downloader\\reslist\\fightskill\\daliduanshi.txt",
  [13] = "\\setting\\downloader\\reslist\\fightskill\\gumupai.txt",
}

function MiniResource:Init()
  self.tbReplaceFile = {}
  local tbFileData = Lib:LoadTabFile(szReplaceFile)
  for _, tbItem in ipairs(tbFileData) do
    self.tbReplaceFile[tbItem["Source"]] = tbItem["Dest"]
  end
end

function MiniResource:GetGroupName(nStep)
  if not MiniResource.tbResource[nStep] then
    return nil
  end
  return MiniResource.tbResource[nStep][1]
end

function MiniResource:GetGroupStep(szGroupName)
  for i = 1, #MiniResource.tbResource do
    if MiniResource.tbResource[i][1] == szGroupName then
      return i
    end
  end
end

function MiniResource:IsGroupExist(szGroupName)
  for _, tbItem in ipairs(self.tbResource) do
    if tbItem[1] == szGroupName then
      return 1
    end
  end

  return 0
end

-- 获得一个组的资源列表，去掉已经下载的，替换资源的
function MiniResource:GetGroupResourceList(nStep)
  assert(nStep <= #self.tbResource)
  local tbResList = {}
  local cFileSource = self.tbResource[nStep][2]
  local szResType = type(cFileSource)
  if szResType == "string" then
    local tbFileData = Lib:LoadTabFile(cFileSource)
    if not tbFileData then
      print(cFileSource, "can not open.")
    end
    assert(tbFileData)
    for _, v in ipairs(tbFileData) do
      tbResList[#tbResList + 1] = v["ResPath"]
    end
  elseif szResType == "table" then
    tbResList = cFileSource
  elseif szResType == "function" then
    tbResList = self.tbResource[nStep][2](unpack(self.tbResource[nStep], 3))
  else
    print(szResType)
    assert(false)
  end

  -- 去掉替换资源
  local tbRet = {}
  for _, szFile in ipairs(tbResList) do
    local szSubstitute = self.tbReplaceFile[szFile]
    if not szSubstitute then
      tbRet[#tbRet + 1] = szFile
    elseif szSubstitute ~= "" then
      tbRet[#tbRet + 1] = szSubstitute
    end
  end

  return tbRet
end

-- 测试看当前步骤是否完成
function MiniResource:FirstStep()
  self.nCurrStep = 0
  self:GoNextStep()
end

function MiniResource:CheckStepState()
  local tbFileList = self:GetGroupResourceList(self.nCurrStep)
  local nPercent = GetResourceCompletePercent(tbFileList)
  self:ShowInfo("【资源】" .. self:GetGroupName(self.nCurrStep) .. "完成" .. nPercent .. "%")
  if nPercent >= 100 then
    if type(self.tbResource[self.nCurrStep][3]) == "function" then
      Lib:CallBack({ self.tbResource[self.nCurrStep][3], self.tbResource[self.nCurrStep][1] })
    end
    return self:GoNextStep()
  end
end

function MiniResource:GoNextStep()
  if self.nCurrStep + 1 > #self.tbResource then
    return 0
  end

  self.nCurrStep = self.nCurrStep + 1

  local tbFileList = self:GetGroupResourceList(self.nCurrStep)
  assert(tbFileList)

  RequestMultiResource(1, tbFileList)
  self:ShowInfo("【资源】" .. self:GetGroupName(self.nCurrStep) .. "开始下载")
end

function MiniResource:InsertNpcResource(strKey)
  if self:IsGroupExist(strKey) == 1 then
    return 1
  end

  local tbData = GetNpcResourceList(strKey)
  assert(tbData)
  table.insert(self.tbResource, { strKey, tbData, NpcResourceComplete })
  self:ShowInfo("插入资源" .. strKey)
end

-- 玩家选择门派或路线
function MiniResource:OnSelectFaction()
  local szFile = self.tbFightSkill[me.nFaction]
  if not szFile or me.nLevel > 30 then -- 级别大于30就忽略了
    return 0
  end

  local tbFileData = Lib:LoadTabFile(szFile)
  if not tbFileData then
    print(szFile, "can not open.")
    return 0
  end

  local tbResList = {}
  for _, v in ipairs(tbFileData) do
    tbResList[#tbResList + 1] = v["ResPath"]
  end
  -- 请求下载技能资源
  RequestMultiResource(129, tbResList)
end

function MiniResource:OnClientStart()
  Timer:Register(Env.GAME_FPS * 2, self.CheckStepState, self)
  -- 注册事件通知
  UiNotify:RegistNotify(UiNotify.emCOREEVENT_SYNC_FACTION, self.OnSelectFaction, self)
end

function MiniResource:ShowInfo(szMsg)
  if MiniResource.nShowInfo == 1 then
    me.Msg(szMsg)
  end
end

------------------------------------------------------------------------------
function MiniResource:GetMapRes(strMapName)
  MiniResource.tbMapRes = MiniResource.tbMapRes or {}
  if MiniResource.tbMapRes[strMapName] then
    return MiniResource.tbMapRes[strMapName]
  end

  local tbResList = {}
  -- 路径文件
  table.insert(tbResList, "\\map_publish\\" .. strMapName .. "\\path.txt")

  -- 地图逻辑
  local strWorFileName = "\\map_publish\\" .. strMapName .. ".wor"
  local tbWorFileData = Lib:LoadIniFile(strWorFileName)
  if not tbWorFileData then
    print("MiniResource:GetMapRes", strWorFileName)
    print(debug.traceback())
  end
  --	assert(tbWorFileData);
  if tbWorFileData then
    local szRect = tbWorFileData["MAIN"]["rect"]
    local _, _, left, top, right, bottom = string.find(szRect, "(%d+),(%d+),(%d+),(%d+)")
    local strFormat = "\\map_publish\\" .. strMapName .. "\\v_%03d\\%03d_region_c.dat"
    for v = top, bottom do
      for h = left, right do
        table.insert(tbResList, string.format(strFormat, v, h))
      end
    end
  end

  -- 地图资源
  local strResFileName = "\\setting\\downloader\\reslist\\map\\" .. strMapName .. "\\element_res.txt"
  local tbResFileData = Lib:LoadTabFile(strResFileName)
  if tbResFileData then
    local nEnd = #tbResFileData
    if me.nLevel >= self.nOldPlayerLevel then
      table.sort(tbResFileData, self._fnMapResCmp)
      local tb = {}
      for i, v in pairs(tbResFileData) do
        tb[i] = v["ResPath"]
      end
      nEnd = GetEndPosWithSizeLimit(tb, self.MapResourceLimitSize)
    end
    for i = 1, nEnd do
      table.insert(tbResList, tbResFileData[i]["ResPath"])
    end
  end

  -- 基础资源，第一次进入地图下载
  local nStep = self:GetGroupStep(szBaseResKey)
  assert(nStep)
  if self.nCurrStep <= nStep then
    local tbResEx = self:GetGroupResourceList(nStep)
    for _, szResFile in ipairs(tbResEx) do
      table.insert(tbResList, szResFile)
    end
  end

  -- 特殊处理
  local strExtResKey = MiniResource.tbMapExtRes[strMapName]
  if strExtResKey then
    local nStep = self:GetGroupStep(strExtResKey)
    if nStep then
      local tbResEx = self:GetGroupResourceList(nStep)
      for _, szResFile in ipairs(tbResEx) do
        table.insert(tbResList, szResFile)
      end
    else
      print(strMapName, strExtResKey, "is not exist.")
    end
  end

  -- 去掉替换资源
  local tbRet = {}
  for _, szFile in ipairs(tbResList) do
    local szSubstitute = self.tbReplaceFile[szFile]
    if not szSubstitute then
      tbRet[#tbRet + 1] = szFile
    elseif szSubstitute ~= "" then
      tbRet[#tbRet + 1] = szSubstitute
    end
  end

  MiniResource.tbMapRes[strMapName] = tbRet

  return tbRet
end

function MiniResource:EnterMap(strMapName)
  MiniResource.tbCompleteMap = MiniResource.tbCompleteMap or {}
  if MiniResource.tbCompleteMap[strMapName] == 1 then
    return 1
  end
  -- 跳过
  if 1 == MiniResource.tbMapSkip[strMapName] then
    return 1
  end

  local tbResList = self:GetMapRes(strMapName)
  local nPercent = GetResourceCompletePercent(tbResList)
  if nPercent >= 100 then
    self:OnMapLoadFinish(strMapName, 0)
    return 1
  end

  RequestMultiResource(130, tbResList)
  if MiniResource.nMapCheckTimerId then
    Timer:Close(MiniResource.nMapCheckTimerId)
    MiniResource.nMapCheckTimerId = nil
  end
  LoadingProgress(0)
  MiniResource.nMapCheckTimerId = Timer:Register(Env.GAME_FPS * 2, self.CheckMapState, self, strMapName)

  me.CallServerScript({ "MiniDownloadInfoCmd", "ClientSyncMapState", 0 })
  if MiniResource.nDownloadInfoTimer then
    Timer:Close(MiniResource.nDownloadInfoTimer)
    MiniResource.nDownloadInfoTimer = nil
  end
  MiniResource.nDownloadInfoTimer = Timer:Register(Env.GAME_FPS * 10, self.SyncDownloadInfo, self)
end

function MiniResource:CheckMapState(strMapName)
  local tbResList = self:GetMapRes(strMapName)
  local nPercent = GetResourceCompletePercent(tbResList)
  LoadingProgress(nPercent)
  if nPercent >= 100 then
    MiniResource:OnMapLoadFinish(strMapName)
  end
end

function MiniResource:SyncDownloadInfo()
  local tbInfo = GetMiniDownloadInfo()
  if not tbInfo then
    Timer:Close(MiniResource.nDownloadInfoTimer)
    MiniResource.nDownloadInfoTimer = nil
    return 0
  end
  local szStep = self:GetGroupName(self.nCurrStep)
  local nSpeed = math.floor(tbInfo.nActualSpeed * 100 / 1024) / 100
  local nPercent = tbInfo.nPercent

  me.CallServerScript({ "MiniDownloadInfoCmd", "ClientSendMiniDowloadInfo2", szStep, nSpeed, nPercent })
end

function MiniResource:OnMapLoadFinish(strMapName, bSyncState)
  self:ShowInfo("地图" .. strMapName .. "完成")
  if MiniResource.nMapCheckTimerId then
    Timer:Close(MiniResource.nMapCheckTimerId)
    MiniResource.nMapCheckTimerId = nil
  end

  MiniResource.tbMapRes[strMapName] = nil
  MiniResource.tbCompleteMap[strMapName] = 1

  -- 通知自动寻路地图资源加载完成事件
  UiNotify:OnNotify(UiNotify.emCOREEVENT_AUTOPATH_DELAYLOAD_SUCC)

  bSyncState = bSyncState or 1
  if bSyncState ~= 0 then
    me.CallServerScript({ "MiniDownloadInfoCmd", "ClientSyncMapState", 1 })
  end

  if MiniResource.nDownloadInfoTimer then
    Timer:Close(MiniResource.nDownloadInfoTimer)
    MiniResource.nDownloadInfoTimer = nil
  end
end

-- 注意，这里要用【.】，table.sort的调用方式，不会有self值
function MiniResource._fnMapResCmp(var1, var2)
  local tbPriority = {
    { "\\map_element\\室外地表\\", 1 },
    { "\\map_element\\室内地表\\", 2 },
    { "\\map_element\\美术图素\\d地表\\", 3 },
    { "\\map_element\\美术图素\\x雪地\\", 4 },
    { "\\map_element\\美术图素\\d道路\\", 5 },
    { "\\map_element\\美术图素\\g高地\\", 6 },
    { "\\map_element\\美术图素\\j建筑\\", 7 },
  }

  local nPri1, nPri2 = 10000, 10000 -- 一个很大的值
  for _, tb in pairs(tbPriority) do
    if string.find(var1["ResPath"], tb[1]) then
      nPri1 = tb[2]
    end

    if string.find(var2["ResPath"], tb[1]) then
      nPri2 = tb[2]
    end
  end

  return nPri1 < nPri2
end

------------------------------------------------------------------------------------
-- 初始运行
ClientEvent:RegisterClientStartFunc(MiniResource.OnClientStart, MiniResource)

MiniResource:Init()
MiniResource:FirstStep()
