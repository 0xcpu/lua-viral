local optionParser = require 'optparse'
local utils        = require 'utils'

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
      -s, --file-rescan        Send FILE for rescanning
      -r, --file-report        Retrieve file scan reports
      -u, --url=URL            Send URL for scanning
      -i, --url-report         Retrieve url scan reports
      -o, --output=[FILE]      File to write output

]]

local function luaviral()
   local parser = optionParser(help)
   local arg, opts = parser:parse(_G.arg)
end

luaviral()
