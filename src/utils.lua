local utils = {}

---
-- Pretty print table
-- Thanks to http://lua-users.org/wiki/TableSerialization
local function tablePrint(tt, indent, done)
   local done = done or {}
   local indent = indent or 0
   if type(tt) == "table" then
      for key, value in pairs(tt) do
	 io.write(string.rep(" ", indent)) -- indent it
	 if type(value) == "table" and not done[value] then
	    done[value] = true
	    io.write(string.format("[%s] => table\n", tostring(key)))
	    io.write(string.rep(" ", indent + 4)) -- indent it
	    io.write("(\n")
	    tablePrint(value, indent + 7, done)
	    io.write(string.rep(" ", indent + 4)) -- indent it
	    io.write(")\n")
	 else
	    io.write(string.format("[%s] => %s\n",
				   tostring(key), tostring(value)))
	 end
      end
   else
      io.write(tt .. "\n")
   end
end

local function readConfigFile()
   local initTab = {}
   local sectName
   local headPttrn = "%[(%w+)%]"
   local elemPttrn = "(%w+)%s+=%s+(https://www.virustotal.com/vtapi/v2/(%a+)/(%a+))"
   
   local fh, msg = io.open(os.getenv('HOME') .. '/.luaviral/urls', 'r')
   if fh == nil then
      error("error opening config.ini file: " .. tostring(msg))
   end
   
   for line in fh:lines() do
      local sn = string.match(line, headPttrn)
      if sn ~= nil then
	 initTab[sn] = {}
	 sectName = sn
      else
	 local key, value = string.match(line, elemPttrn)
	 if key and value then
	    initTab[sectName][key] = value
	 end
      end
   end
   
   return initTab
end

utils.getConfig  = readConfigFile
utils.tablePrint = tablePrint

return utils
