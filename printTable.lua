--[[
	Minimal dump library to output table and nested table data
]]
function dump(o)
	if type(o) == 'table' then
		 local s = '{ '
		 for k,v in pairs(o) do
				if type(k) ~= 'number' then k = '"'..k..'"' end
				s = s .. '['..k..'] = ' .. dump(v) .. ','
		 end
		 return s .. '} '
	else
		 return tostring(o)
	end
end

--[[
	Minimal dump library to output table and nested table data formatted
]]
function dumpOther (  value , call_indent)

	if not call_indent then
		call_indent = ""
	end

	local indent = call_indent .. "  "

	local output = ""

	if type(value) == "table" then
			output = output .. "{"
			local first = true
			for inner_key, inner_value in pairs ( value ) do
				if not first then
					output = output .. ", "
				else
					first = false
				end
				output = output .. "\n" .. indent
				output = output  .. inner_key .. " = " .. dumpOther ( inner_value, indent )
			end
			output = output ..  "\n" .. call_indent .. "}"

	elseif type (value) == "userdata" then
		output = "userdata"
	else
		output =  value
	end
	return output
end

--[[
	Recursive table printing function including memory address
]]
function print_r (t)
	local print_r_cache={}
	local function sub_print_r(t,indent)
			if (print_r_cache[tostring(t)]) then
					print(indent.."*"..tostring(t))
			else
					print_r_cache[tostring(t)]=true
					if (type(t)=="table") then
							for pos,val in pairs(t) do
									if (type(val)=="table") then
											print(indent.."["..pos.."] => "..tostring(t).." {")
											sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
											print(indent..string.rep(" ",string.len(pos)+6).."}")
									elseif (type(val)=="string") then
											print(indent.."["..pos..'] => "'..val..'"')
									else
											print(indent.."["..pos.."] => "..tostring(val))
									end
							end
					else
							print(indent..tostring(t))
					end
			end
	end
	if (type(t)=="table") then
			print(tostring(t).." {")
			sub_print_r(t,"  ")
			print("}")
	else
			sub_print_r(t,"  ")
	end
	print()
end
