--
-- Tên tệp: studioscore_def.lua
-- Tác giả: hanruofei
-- Thời gian: 2011/6/24 9:16
-- Bình luận:
--

StudioScore.bIsOpen = StudioScore.bIsOpen or true

StudioScore.tbScoredBuyItems = {} -- Mục cộng điểm khi mua đồ
StudioScore.tbScoredSellItems = {} -- Mục cộng điểm khi bán đồ
StudioScore.tbActivityScores = {} -- Mục cộng điểm khi tham gia hoạt động

StudioScore.tbScoreSetting = {
  buy = {},
  sell = {},
  activity = {},
}

StudioScore.tbTaskId2ScoreItem = {}

function StudioScore:LoadSettingItem(v)
  local Score = tonumber(v.Score)
  if not Score then
    print("Điểm:" .. tostring(Score) .. " không phải là định dạng số hợp lệ")
    return
  end

  local nTaskId = tonumber(v.nTaskId) or 0
  if nTaskId == 0 and math.floor(Score) ~= Score then
    print("Điểm là số thập phân, nhưng nTaskId là 0")
    return
  end

  return { nTaskId = nTaskId, Score = Score, nMaxCount = tonumber(v.nMaxCount) }
end

function StudioScore:LoadSetting(szSettingFile)
  local tbData = Lib:LoadTabFile(szSettingFile)
  if not tbData then
    print("Tệp " .. szSettingFile .. " tải thất bại!")
    return
  end

  for i, v in ipairs(tbData) do
    if v.szName == "" then
      print(szSettingFile .. " Dòng " .. i .. " chưa chỉ định szName, bỏ qua")
    elseif v.szType == "" then
      print(szSettingFile .. " Dòng " .. i .. " chưa chỉ định szType, bỏ qua")
    else
      if not self.tbScoreSetting[v.szType] then
        self.tbScoreSetting[v.szType] = {}
      end
      if self.tbScoreSetting[v.szType][v.szName] then
        print(szSettingFile .. " Dòng " .. i .. " chỉ định szName trùng lặp, bỏ qua")
      else
        local tbItem = self:LoadSettingItem(v)
        if tbItem then
          self.tbScoreSetting[v.szType][v.szName] = tbItem
          local nTaskId = tonumber(v.nTaskId) or 0
          if nTaskId ~= 0 then
            if self.tbTaskId2ScoreItem[nTaskId] then
              if self.tbTaskId2ScoreItem[nTaskId].Score ~= tbItem.Score then
                print("Cùng một TaskId " .. nTaskId .. " tương ứng với các mục có Điểm khác nhau, lỗi!")
              end
            else
              self.tbTaskId2ScoreItem[nTaskId] = tbItem
            end
          end
        end
      end
    end
  end
end

StudioScore:LoadSetting("\\setting\\player\\score_def.txt")
