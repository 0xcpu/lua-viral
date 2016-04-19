local lfs   = require 'lfs'
local bit   = require 'bit'
local http  = require 'socket.http'
local ltn12 = require 'ltn12'
local utils = require 'utils'
local urls  = require 'urls'

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

      local status, apiKey = pcall(utils.getApiKey)
      assert(status, apiKey)
      
      local respBody = {}
      local _, code, headers, status = http.request{
	 method  = "POST",
	 url     = urls.URLS.file.scan,
	 source  = ltn12.source.file(fh),
	 sink    = ltn12.sink.table(respBody),
	 headers = {
	    ['Content-length'] = fsize,
	    ['apikey']         = apiKey
	 }
      }

      io.stdout:write(tostring(status) .. ' \n')
      io.stdout:write(tostring(code) .. ' \n')
      utils.tablePrint(headers)
      utils.tablePrint(respBody)
   end
end

local function sendUrlToScan(url)
   assert(url)

   local status, apiKey = pcall(utils.getApiKey)
   assert(status, apiKey)

   local respBody = {}
   local _, code, headers, status = http.request{
      method  = "POST",
      url     = urls.URLS.url.scan,
      sink    = ltn12.sink.table(respBody),
      headers = {
	 ['Content-length'] = string.len(url),
	 ['url']            = url,
	 ['apikey']         = apiKey
      }
   }

   io.stdout:write(tostring(status) .. ' \n')
   io.stdout:write(tostring(code) .. ' \n')
   utils.tablePrint(headers)
   utils.tablePrint(respBody)
end

vrtops.sendFileToScan = sendFileToScan
vrtops.sendUrlToScan  = sendUrlToScan

return vrtops
