local M = {}

export type ColorInput = Color3 | string

function M.GetDisabledColor(color: ColorInput): Color3
	local originalColor = if typeof(color) == "string" then Color3.fromHex(color) else color
	local h, s, v = originalColor:ToHSV()
	return Color3.fromHSV(h, math.clamp(s * 0.5, 0, 1), math.clamp(v * 0.9, 0, 1))
end

return M
