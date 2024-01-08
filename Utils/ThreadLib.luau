local ThreadLib = {}

function ThreadLib.New(f)
	local this  = { }
	this.active = false
	this.func   = f

	-- private
	local function Fire(ff)
		local event = Instance.new('BindableEvent')
		event.Event:connect(function ()
			ff(this)
		end)
		event:Fire()
	end

	-- public
--	function this:SetFunc(f)
--		this.func = f
--		return this
--	end

	function this:Start(t)
		this.active = true
		if this.func then
			Fire(this.func)
			if t and type(t) == 'number' then
				delay(t, function ()
					this.active = false
				end)
			end
		end
		return this
	end

	function this:Stop()
		this.active = false
		return this
	end

	function this:Destroy()
		 this:Stop()
		 this.func = nil
	end

	return this
end

return ThreadLib
