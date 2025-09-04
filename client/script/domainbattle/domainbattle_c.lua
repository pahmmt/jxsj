-- 领土争夺战 Client脚本
-- zhengyuhua
-------------------------------------------------------------------------------

if not MODULE_GAMECLIENT then
  return
end

function Domain:Init_Client()
  self.nDataVer = -1
end

Domain:Init_Client()

-- 客户端申请数据
function Domain:ApplyData()
  me.CallServerScript({ "DomainCmd", "ApplyData", self.nDataVer })
end

-- 客户端收到数据
function Domain:RecvData(tbDomainInfo, nDataVer, nDomainVersion)
  self:SetDomainInfo(tbDomainInfo)
  self.nDataVer = nDataVer
  self.nDomainVersion = nDomainVersion
  CoreEventNotify(UiNotify.emCOREEVENT_SYNC_DOMAININFO, nDomainVersion)
end

function Domain:GetDomainVersion_C()
  return self.nDomainVersion
end

-- 即时战报 同步最小信息（全局信息）
function Domain:s2cBattleMinInfo(tbMinInfo, tbMapSort)
  local szType, tbData = me.GetCampaignDate()
  if szType ~= "DomainBattle" then
    return
  end
  if not tbData.tbMinInfo then
    tbData.tbMinInfo = {}
    tbData.tbMapSort = {}
  end
  if tbMinInfo then
    for nMapId, nScore in pairs(tbMinInfo) do
      tbData.tbMinInfo[nMapId] = nScore
    end
  end
  if tbMapSort then
    for nMapId, nSort in pairs(tbMapSort) do
      tbData.tbMapSort[nMapId] = nSort
    end
  end
  me.SetCampaignDate("DomainBattle", tbData, 0)
  CoreEventNotify(UiNotify.emCOREEVENT_SYNC_DOMAININFO)
end

-- 即时战报 同步排名信息（区域信息）
function Domain:s2cBattleSortInfo(tbSortInfo)
  local szType, tbData = me.GetCampaignDate()
  if szType ~= "DomainBattle" then
    tbData = {}
  end
  tbData.tbSortInfo = tbSortInfo
  me.SetCampaignDate("DomainBattle", tbData, 0)
  CoreEventNotify(UiNotify.emCOREEVENT_SYNC_DOMAININFO)
end

-- 同步即时战报有效时间
function Domain:SetDomainInfoTimeOut(nFrame)
  local szType, tbData = me.GetCampaignDate()
  if szType ~= "DomainBattle" then
    return
  end
  me.SetCampaignDate("DomainBattle", tbData, nFrame)
end
