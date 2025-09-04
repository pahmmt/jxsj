------------------------------------------------------
-- 文件名　：stone_gc.lua
-- 创建者　：dengyong
-- 创建时间：2011-06-10 18:11:52
-- 描  述  ： 宝石GC脚本
------------------------------------------------------
if not MODULE_GC_SERVER then
  return
end

Require("\\script\\item\\stone\\define.lua")

Item.tbStone = Item.tbStone or {}
local tbStone = Item.tbStone

-- 因为还需要通知GS做些事情，仅仅靠KGblTask的同步策略不好做，于是有了这个文件这个函数
function tbStone:SetOpenDay(nTime)
  local nDay = Lib:GetLocalDay(nTime)
  local nOld = KGblTask.SCGetDbTaskInt(DBTASK_STONE_FUNCTION_OPENDAY)

  if nDay ~= nOld then
    -- gs需要做些独立的逻辑
    GlobalExcute({ "Item.tbStone:SetOpenDay", nDay })
    KGblTask.SCSetDbTaskInt(DBTASK_STONE_FUNCTION_OPENDAY, nDay)
  end
end

-- 初始化的时候设置一下宝石系统的整体开关
function Item:StoneSysInit()
  if self.tbStone.IsOpen ~= KGblTask.SCGetDbTaskInt(DBTASK_STONE_FUNCTION_OPENFLAG) then
    KGblTask.SCSetDbTaskInt(DBTASK_STONE_FUNCTION_OPENFLAG, self.tbStone.IsOpen)
  end
end

function tbStone:StoneSendMail()
  local szTitle = "奇珍异宝"
  local szContent = [[
<Sender>白秋琳<Sender>    自上次见面之后，已有月余。先有民间奇工匠找到了在矿石中找出宝石原石的方法，后又有人用古法改良把众多宝石原石打磨成璀璨光华的成品。
    这些珍贵的石头往往有奇效，能除中热，养五脏，安魂魄，疏血脉，明耳目。再后来有人提出把宝石镶嵌在战袍之上的方法，往往气血大提升从而无往不利。实在是获益颇多，故不敢独专，希望你也能去宝石工匠处看看，了解一下情况，并表示微薄的谢意。
    已达到80级的玩家可以去新手村宝石工匠苏梦珍处接取宝石相关任务。
]]
  local nNowTime = tonumber(GetLocalDate("%Y%m%d%H"))
  local nYear, nMonth, nDate, nHour = math.floor(nNowTime / 1000000), math.floor((nNowTime % 1000000) / 10000), math.floor((nNowTime % 10000) / 100), math.floor((nNowTime % 100))
  nYear, nMonth, nDate = Lib:AddDay(nYear, nMonth, nDate, self.nSendMailEndTime)
  Mail.BatchMail:AddIntoGblBuf(szTitle, szContent, tonumber(string.format("%02d%02d%02d%02d", nYear, nMonth, nDate, nHour)))
end

GCEvent:RegisterGCServerStartFunc(Item.StoneSysInit, Item)
