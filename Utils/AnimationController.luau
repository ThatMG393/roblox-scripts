local Players = game:GetService("Players")

local AnimationUtil = {}
AnimationUtil.__index = AnimationUtil

function AnimationUtil.new(config)
	local localPlayer = Players.LocalPlayer
	local localChar = localPlayer.Character

	if not localChar then
		config.OnError("Character not loaded")
		return nil
	end

	local self = setmetatable({
		Running = false,
		Speed = config.Speed or 1,
		OnError = config.OnError or function() end,
		OnStatusChange = config.OnStatusChange or function() end,
		R6AnimId = config.R6AnimId,
		R15AnimId = config.R15AnimId,
		LocalHumanoid = localChar:WaitForChild("Humanoid"),
		LocalRoot = localChar:FindFirstChild("HumanoidRootPart"),
	}, AnimationUtil)

	if not (self.LocalHumanoid and self.LocalRoot) then
		config.OnError("Required instances not found")
		return nil
	end

	return self
end

function AnimationUtil:_LoadAnimation()
	local isR6 = not self.LocalHumanoid.Parent:FindFirstChild("UpperTorso")
	local animId = isR6 and self.R6AnimId or self.R15AnimId

	local animation = Instance.new("Animation")
	animation.AnimationId = animId
	self.AnimationTrack = self.LocalHumanoid:WaitForChild("Animator"):LoadAnimation(animation)
end

function AnimationUtil:Start()
	if self.Running then
		return
	end
	self.Running = true

	self:_LoadAnimation()
	self.AnimationTrack:Play()
	self.AnimationTrack:AdjustSpeed(self.Speed)
	self.OnStatusChange("Started")
end

function AnimationUtil:Stop()
	self.Running = false
	self.AnimationTrack:Stop()
	self.OnStatusChange("Stopped")
end

function AnimationUtil:FollowTarget(targetName, offset)
	local target = Players:FindFirstChild(targetName)
	if not target or not target.Character then
		return
	end

	local targetHumanoid = target.Character:WaitForChild("Humanoid")
	local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
	if not targetRoot or not targetHumanoid then
		return
	end

	targetHumanoid.Died:Connect(function()
		self:Stop()
	end)

	self.LocalHumanoid.Died:Connect(function()
		self:Stop()
	end)

	task.spawn(function()
		while self.Running do
			self.LocalRoot.CFrame = targetRoot.CFrame * offset
			task.wait()
		end
	end)
end

return AnimationUtil
