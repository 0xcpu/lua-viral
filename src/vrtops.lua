local lfs      = require 'lfs'
local bit      = require 'bit'
local http_req = require 'http.request'
local ltn12    = require 'ltn12'
local mime     = require 'mime'
local utils    = require 'utils'
local urls     = require 'urls'
local md5      = require 'md5'
local ui       = require 'ui'

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

      local request = http_req.new_from_uri(urls.URLS.file.scan)
      request.headers:upsert(':method', 'POST')
      request.headers:append('content-length', fsize)

      ui.showVTRequest({
	    operation = "Scan file",
	    VTurl     = urls.URLS.file.scan,
	    file      = file
      })

      local respHeaders, respStream = request:go()
      utils.tablePrint(respHeaders)
      io.stdout:write(respStream:get_body_as_string())
   end
end

local function sendFileToRescan(file)
   assert(file)

   local hash = md5.sumhexa(file)

   local status, apiKey = pcall(utils.getApiKey)
   assert(status, apiKey)

   local request = http_req.new_from_uri(urls.URLS.file.rescan)
   request.headers:upsert(':method', 'POST')
   request:set_body('resource=' .. hash .. '&apikey=' .. apiKey)

   local respHeaders, respStream = request:go()
   io.stdout:write(respStream:get_body_as_string())
end

local function sendUrlToScan(url)
   assert(url)

   local status, apiKey = pcall(utils.getApiKey)
   assert(status, apiKey)

   local request = http_req.new_from_uri(urls.URLS.url.scan)
   request.headers:upsert(':method', 'POST')
   request:set_body('url=' .. url .. '&apikey=' .. apiKey)

   ui.showVTRequest({
	 operation = "Scan url",
	 VTurl     = urls.URLS.url.scan,
	 url       = url
   })

   local respHeaders, respStream = request:go()

   local errMsg
   status, errMsg = pcall(ui.showVTResponse, respHeaders, respStream)
   assert(status, errMsg)
end

vrtops.sendFileToScan   = sendFileToScan
vrtops.sendFileToRescan = sendFileToRescan
vrtops.sendUrlToScan    = sendUrlToScan

return vrtops
