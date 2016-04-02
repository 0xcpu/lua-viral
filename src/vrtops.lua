local lfs = require 'lfs'
local bit = require 'bit'
local http = require 'socket.http'
local ltn12 = require 'ltn12'
local utils = require 'utils'

local vrtops = {}

local function sendFileToScan(file)
   assert(file)

   local fh, errMsg = lfs.attributes(file)
   if fh == nil then
      error(errMsg)
   elseif bit.rshift(fh.size, 20) > 32 then
      error("File size exceeds 32MB(Allowed size by VirusTotal)")
   else
      local fsize = fh.size
      fh, errMsg = io.open(file, 'rb')
      if fh == nil then
	 error(errMsg)
      end

      local respBody = {}
      local url = 'https://www.virustotal.com/vtapi/v2/file/scan'
      local _, code, headers, status = http.request{
	 method  = "POST",
	 url     = url,
	 source  = ltn12.source.file(fh),
	 sink    = ltn12.sink.table(respBody),
	 headers = {
	    ['Accept']          = '*/*',
	    ['Accept-Encoding'] = 'gzip, deflate',
	    ['Accept-Language'] = 'en-us',
	    ['Content-Type']    = 'application/x-www-form-urlencoded',
	    ['Content-length']  = fsize,
	    ['apikey']          = 'dbfd022d379fad9d177f55eefc1d166224beef5efd73a7ae06aaf3a05f658ce4'
	 }
      }

      io.stdout:write(tostring(status) .. ' \n')
      io.stdout:write(tostring(code) .. ' \n')
      utils.tablePrint(headers)
      io.stdout:write('-----\n')
      utils.tablePrint(respBody)
   end
end

vrtops.sendFileToScan = sendFileToScan

return vrtops
