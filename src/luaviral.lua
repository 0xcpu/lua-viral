local optionParser = require 'optparse'
local utils        = require 'utils'
local vrtops       = require 'vrtops'
local urls         = require 'urls'

local help = [[
luaviral 0.1 - A client application that can interact with VirusTotal.

Year: 2016
License: The MIT License (MIT)
    
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

Written by Cornel Punga
Please report bugs at https://github.com/ner0x652/lua-viral

Usage: luaviral [<options>] [<file> | <url>]...

luaviral - VirusTotal client. 

Options:

      -h, --help               display this help, then exit
          --version            display version information, then exit
      -v, --verbose            a combined short and long option
      -f, --file=FILE          Send FILE for scanning
      -s, --file-rescan=FILE   Send FILE for rescanning
      -r, --file-report=FILE   Retrieve file scan reports
      -u, --url=URL            Send URL for scanning
      -i, --url-report=URL     Retrieve url scan reports
      -o, --output=[FILE]      File to write output
]]

local function luaviral()
   local urlsTab = utils.getUrls()
   assert(urlsTab)
   for k, v in pairs(urlsTab) do
      for kk, vv in pairs(v) do
	 urls.URLS[k:lower()][kk] = vv
      end
   end

   local parser = optionParser(help)
   local arg, opts = parser:parse(_G.arg)

   local status, err
   if opts.file and type(opts.file) ~= 'function' then
      status, err = pcall(vrtops.sendFileToScan, opts.file)
      if not status then
	 io.stderr:write(err .. "\n")
	 os.exit(2)
      end
   elseif opts.file_rescan then
      status, err = pcall(vrtops.sendFileToRescan, opts.file_rescan)
      if not status then
	 io.stderr:write(err .. "\n")
	 os.exit(2)
      end
   elseif opts.file_report then
      status, err = pcall(vrtops.getFileScanReport, opts.file_report)
      if not status then
	 io.stderr:write(err .. "\n")
	 os.exit(2)
      end
   elseif opts.url then
      status, err = pcall(vrtops.sendUrlToScan, opts.url)
      if not status then
	 io.stderr:write(err .. "\n")
	 os.exit(2)
      end
   elseif opts.url_report then
      status, err = pcall(vrtops.getUrlScanReport, opts.url_report)
      if not status then
	 io.stderr:write(err .. "\n")
	 os.exit(2)
      end
   else
      parser:help()
   end
end

luaviral()
