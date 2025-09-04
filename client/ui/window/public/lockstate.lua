local uiLockState = Ui:GetClass("lockstate")

function uiLockState:OnOpen()
  ForbitGameSpace(1)
end

function uiLockState:OnClose()
  ForbitGameSpace(0)
end
