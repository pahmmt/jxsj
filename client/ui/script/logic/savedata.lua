-----------------------------------------------------
--文件名		：	tbSaveData.lua
--创建者		：	tongxuehu
--创建时间		：	2007-8-23 9:10:05
--功能描述		：	脚本保存到客户端的数据
------------------------------------------------------

Ui.tbLogic.tbSaveData = {}
local tbSaveData = Ui.tbLogic.tbSaveData

tbSaveData.tbKeyWords = {
  ["AutoFight"] = 1,
  ["Calendar"] = 1,
  ["CalendarReMindAll"] = 1,
  ["ChannelOption"] = 1,
  ["PreUpdate"] = 1,
  ["GameOption"] = 1,
  ["GameOptimize"] = 1,
  ["ThemeSetting"] = 1,
  ["DailyDate"] = 1,
  ["Relationnew"] = 1,
  ["GameTeamConfig"] = 1,
  ["ThemeSetting"] = 1,
  ["TradeHistory"] = 1,
}

function tbSaveData:Init()
  self.m_nTab = 0
  self.m_strTab = ""
  self.m_tbTmp = {}
  self.m_tbData = {}
  self.m_szFilePath = "\\user\\temp\\ui_setting.data"
  self.m_tbLoadCallback = {}
  self.tbKeyFilePath = {}
  self:LoadSetting()
end

-- 根据关键字获取存储的数据
function tbSaveData:Load(szKey)
  local tbData = self.m_tbData[szKey]
  if not tbData then
    tbData = {}
  end
  return tbData
end

function tbSaveData:CheckSaveData(tbDate)
  local szType = type(tbDate)
  if szType ~= "table" then
    return 0
  end
  if szType == "table" then
    for k, v in pairs(tbDate) do
      if type(k) == "userdata" or type(v) == "userdata" then
        return 0
      end
      if type(v) == "table" then
        self:CheckSaveData(v)
      end
    end
  end
  return 1
end

function tbSaveData:CheckErrorData(szDate)
  if szDate ~= "" then
    if string.find(szDate, "Ptr:") and string.find(szDate, "ClassName:") then
      return 0
    end
    if not Lib:CallBack({ "Lib:Str2Val", szDate }) then -- 因文件hashid等问题，无法读取到正确的包外文件
      return 0
    end
  end
  return 1
end

function tbSaveData:LogError(szData)
  Ui:WriteLog(Dbg.LOG_ERROR, "SaveData", szData)
end

-- 根据关键字保存数据
function tbSaveData:Save(szKey, tbData)
  self.m_tbData[szKey] = tbData
  -- 存储到文件
  local szData = Lib:Val2Str(tbData)
  local szKeyFilePath = self.tbKeyFilePath[szKey]
  if not szKeyFilePath then
    szKeyFilePath = GetPlayerPrivatePath() .. string.lower(szKey) .. ".dat"
    self.tbKeyFilePath[szKey] = szKeyFilePath
  end
  if self:CheckErrorData(szData) == 1 then
    KIo.WriteFile(szKeyFilePath, szData)
  else
    local szSaveData = Lib:Val2Str(tbData)
    self:LogError("BEGIN 保存Key为: " .. szKey .. "保存数据为: " .. szSaveData .. "全部数据为" .. szData .. "END.")
  end
end

-- 注册需要响应配置加载完成的函数
function tbSaveData:RegistLoadCallback(fnLoad, tbTable, ...)
  assert(type(fnLoad) == "function")
  assert(type(tbTable) == "table")
  local tbCall = {}
  tbCall.tbTable = tbTable
  tbCall.fnLoad = fnLoad
  tbCall.tbParam = arg
  table.insert(self.m_tbLoadCallback, tbCall)
end

-- 响应客户端启动、进入游戏的事件读取用户UI配置文件
function tbSaveData:LoadSetting()
  if self.m_szPlayerPrivatePath ~= GetPlayerPrivatePath() then
    self.m_szPlayerPrivatePath = GetPlayerPrivatePath()
    self.m_tbData = nil
    self.m_szFilePath = GetPlayerPrivatePath() .. "ui_setting.dat"

    for szKey, var in pairs(self.tbKeyWords) do
      self.tbKeyFilePath[szKey] = GetPlayerPrivatePath() .. string.lower(szKey) .. ".dat"
    end

    local szData = KIo.ReadTxtFile(self.m_szFilePath)
    if szData then
      if self:CheckErrorData(szData) == 1 then -- TODO: 这里检测一下user目录里是否被因出错写入了非法 userdata数据
        -- 这里先把ui_setting.dat取出来然后把文件分别保存在key的文件里
        self.m_tbData = Lib:Str2Val(szData)
        DeletePrivateFoldFile("ui_setting.dat")
        for szKey, tbData in pairs(self.m_tbData) do
          self:Save(szKey, tbData)
        end
      end
    end

    if not self.m_tbData then
      self.m_tbData = {}
    end

    for szKey, var in pairs(self.tbKeyWords) do
      self:LoadSettingByKey(szKey)
    end
  end

  for i = 1, #self.m_tbLoadCallback do -- 遍历注册函数的表通知配置加载完成事件
    local tbCall = self.m_tbLoadCallback[i]
    tbCall.fnLoad(tbCall.tbTable, unpack(tbCall.tbParam))
  end
end

function tbSaveData:LoadSettingByKey(szKey)
  if not self.m_tbData then
    self.m_tbData = {}
  end

  --	self.tbKeyFilePath[szKey] = GetPlayerPrivatePath().. string.lower(szKey) .. ".dat";
  local szFilePath = self.tbKeyFilePath[szKey]

  assert(szFilePath)

  local szData = KIo.ReadTxtFile(szFilePath)
  if szData then
    if self:CheckErrorData(szData) == 1 then -- TODO: 这里检测一下user目录里是否被因出错写入了非法 userdata数据
      self.m_tbData[szKey] = Lib:Str2Val(szData)
    else
      KIo.WriteFile(szFilePath, "nil")
    end
  end
end
