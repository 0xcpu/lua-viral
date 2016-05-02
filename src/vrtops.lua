local lfs      = require 'lfs'
local bit      = require 'bit'
local http_req = require 'http.request'
local ltn12    = require 'ltn12'
local curl     = require 'lcurl'
local utils    = require 'utils'
local urls     = require 'urls'
local lcrypt   = require 'lcrypt'
local ui       = require 'ui'

local vrtops = {}

local function sendFileToScan(filePath)
   assert(filePath)

   local fh, errMsg = lfs.attributes(filePath)
   if fh == nil then
      error(errMsg)
   elseif bit.rshift(fh.size, 20) > 32 then
      error("File size exceeds 32MB(Allowed size by VirusTotal)")
   else
      local fsize = fh.size
      local fname = string.sub(filePath, (string.find(filePath, '/[^/]-$') or 0) + 1)

      local status, apiKey = pcall(utils.getApiKey)
      assert(status, apiKey)

      ui.showVTRequest({
	    operation = "File scan",
	    VTurl     = urls.URLS.file.scan,
	    filePath  = filePath
      })

      local easy = curl.easy()
	 :setopt_url(urls.URLS.file.scan)
	 :setopt_httppost(curl.form()
			     :add_content('apikey', apiKey, 'text/plain')
			     :add_file('file', filePath, 'application/octet-stream',
				       fname, {'Content-length: ' .. fsize}
			 ))
	 :perform()
	 :close()
   end
end

local function sendFileToRescan(filePath)
   assert(filePath)

   local fname = string.sub(filePath, (string.find(filePath, '/[^/]-$') or 0) + 1)
   local fhash = lcrypt.tohex(lcrypt.hash(lcrypt.hashes.sha256,
					  lcrypt.hash_modes.hash,
					  fname):done())
   assert(fhash)

   local status, apiKey = pcall(utils.getApiKey)
   assert(status, apiKey)

   local request = http_req.new_from_uri(urls.URLS.file.rescan)
   request.headers:upsert(':method', 'POST')
   request:set_body('resource=' .. fhash .. '&apikey=' .. apiKey)

   ui.showVTRequest({
	 operation = "File rescan",
	 VTurl     = urls.URLS.file.rescan,
	 filePath  = filePath
   })

   local respHeaders, respStream = request:go()

   local errMsg
   status, errMsg = pcall(ui.showVTResponse, respHeaders, respStream)
   assert(status, errMsg)
end

local function getFileScanReport(filePath)
   assert(filePath)

   local fname = string.sub(filePath, (string.find(filePath, '/[^/]-$') or 0) + 1)
   local fhash = lcrypt.tohex(lcrypt.hash(lcrypt.hashes.sha256,
					  lcrypt.hash_modes.hash,
					  fname):done())
   assert(fhash)

   local status, apiKey = pcall(utils.getApiKey)
   assert(status, apiKey)

   local request = http_req.new_from_uri(urls.URLS.file.report)
   request.headers:upsert(':method', 'POST')
   request:set_body('resource=' .. fhash .. '&apikey=' .. apiKey)

   ui.showVTRequest({
	 operation = "File scan report",
	 VTurl     = urls.URLS.file.report,
	 filePath  = filePath
   })

   local respHeaders, respStream = request:go()

   local errMsg
   status, errMsg = pcall(ui.showVTResponse, respHeaders, respStream, true, 'file')
   assert(status, errMsg)
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

local function getUrlScanReport(rsrc)
   assert(rsrc)
   
   local status, apiKey = pcall(utils.getApiKey)
   assert(status, apiKey)

   local request = http_req.new_from_uri(urls.URLS.url.report)
   request.headers:upsert(':method', 'POST')
   request:set_body('resource=' .. rsrc .. '&apikey=' .. apiKey .. '&scan=1')

   ui.showVTRequest({
	 operation = "URL scan report",
	 VTurl     = urls.URLS.url.report,
	 resource  = rsrc
   })

   local respHeaders, respStream = request:go()

   local errMsg
   status, errMsg = pcall(ui.showVTResponse, respHeaders, respStream, true, 'url')
   assert(status, errMsg)
end

vrtops.sendFileToScan    = sendFileToScan
vrtops.sendFileToRescan  = sendFileToRescan
vrtops.getFileScanReport = getFileScanReport
vrtops.sendUrlToScan     = sendUrlToScan
vrtops.getUrlScanReport  = getUrlScanReport

return vrtops
