local ThreadLib = { }

function ThreadLib.NewThread(ft)
	local Thread = {
		Function = ft,
		Coroutine = coroutine.create(ft)
	}

	function Thread.Start()
		coroutine.resume(Thread.Coroutine, Thread.Coroutine)
	end

	function Thread.Stop()
		coroutine.yield(Thread.Coroutine)
	end

	return Thread
end

return ThreadLib
