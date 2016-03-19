local lfs = require 'lfs'
local bit = require 'bit'

local vrtops = {}

local function sendFileToScan(file)
   assert(file)

   local fh, errMsg = lfs.attributes(file)
   if fh == nil then
      error(errMsg)
   elseif bit.rshift(fh.size, 10) > 32 then
      error("File size exceeds 32MB(Allowd size by VirusTotal)")
   else return end
end

vrtops.sendFileToScan = sendFileToScan

return vrtops
