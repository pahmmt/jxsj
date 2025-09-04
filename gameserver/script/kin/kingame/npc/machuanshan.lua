local tbNpc = Npc:GetClass("machuanshan")

local DYN_MAP_ID_START = 65535 --动态地图起始

function tbNpc:OnDialog()
  if HomeLand:CheckOpen() == 1 then
    local szMsg = "　　家是暖春里的溪流，家是盛夏的树荫，家是深秋的红叶，家是严冬的火把！\n　　在我这里，你可以操作家族相关的事宜。"
    local nRet = HomeLand:GetMapIdByKinId(me.dwKinId)
    if me.nMapId == nRet or (nRet <= 0 and me.nMapId >= DYN_MAP_ID_START) then
      KinGame:OnEnterDialog()
      return 0
    else
      local tbOpt = {
        { "家族关卡", KinGame.OnEnterDialog, KinGame },
        { "<color=green>家族领地<color>", HomeLand.OnEnterDialog, HomeLand },
        { "我只是路过" },
      }
      Dialog:Say(szMsg, tbOpt)
    end
  else
    KinGame:OnEnterDialog()
  end
end
