local ThreadLib = { }

function ThreadLib.NewThread(func)
	local Thread = {
		CoroFunc = func,
		Coroutine = nil
	}

	function Thread.Start()
		Thread.Coroutine = coroutine.create(func)
		coroutine.resume(Thread.Coroutine)
	end

	function Thread.Stop()
		if Thread.Coroutine == nil then return end
		return coroutine.yield(Thread.Coroutine)
	end

	return Thread
end

return ThreadLib
