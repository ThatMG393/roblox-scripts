local M = {}

export type ColorInput = Color3 | string

function M:hexToColor3(hex: string): Color3
	hex = hex:gsub("#", "")
	local r = tonumber(hex:sub(1,2), 16)
	local g = tonumber(hex:sub(3,4), 16)
	local b = tonumber(hex:sub(5,6), 16)
	
	if not (r and g and b) then
		error("Invalid hex color format")
	end
	
	return Color3.new(r / 255, g / 255, b / 255)
end

function M:color3ToHex(color: Color3): string
	local r = math.floor(color.R * 255)
	local g = math.floor(color.G * 255)
	local b = math.floor(color.B * 255)
	return string.format("#%02X%02X%02X", r, g, b)
end

function M:getDisabledColor(color: ColorInput): Color3
	local originalColor = if typeof(color) == "string" then M:hexToColor3(color) else color
	local h, s, v = originalColor:ToHSV()
	return Color3.fromHSV(h, math.clamp(s * 0.6, 0, 1), math.clamp(v + 0.15, 0, 1))
end

return M
