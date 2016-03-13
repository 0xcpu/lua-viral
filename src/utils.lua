utils = {}

function readConfigFile()
   local initTab = {}
   local sectName
   local headPttrn = "%[(%w+)%]"
   local elemPttrn = "(%w+)%s+=%s+([%-]?%w+[%.]?[%w]*)"
   
   local fh, msg = io.open("config.ini", "r")
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

utils.getConfig = readConfigFile

return utils
