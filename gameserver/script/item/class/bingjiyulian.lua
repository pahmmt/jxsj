-------------------------------------------------------
-- 文件名　：bingjiyulian.lua
-- 创建者　：zhangjinpin@kingsoft
-- 创建时间：2010-05-25 14:14:49
-- 文件描述：
-------------------------------------------------------

if not MODULE_GAMESERVER then
  return
end

local tbItem = Item:GetClass("bingjiyulian")

function tbItem:OnUse()
  if TimeFrame:GetState("OpenLevel150") ~= 1 then
    me.Msg("只有开放150等级上限的服务器才可以使用。")
    return 0
  end

  if me.nLevel >= 70 then
    me.Msg("该道具只能70级以下的角色使用。")
    return 0
  end

  me.AddLevel(100 - me.nLevel)
  return 1
end
