# Lualog
This is a simple logger for Lua.

Create a simple logger for Lua with some configurations as show date, stylized tags and logger name.
# Install
- Using Luarocks
```bash
luarocks install lualog --local # local instalation
luarocks install lualog --tree lua_modules # current directory installation to lua_modules folder
```
- Dowloading

Dowload this repository and renamed the folder to `lualog` and place it at your project

# Usage
```lua
-- Example
local Lualog = require'lualog'

local logger = Lualog.new{
    tag = 'Lualog', -- a logger tag. default: ''
    styles = {dev = 'yellow', crash = 'bgred'}, -- define custom methods and their style. default: {}
    ignore_levels = {'dev'}, -- ignore levels (array). default: {}
    show_date = true, -- show date. default: false
    datestring = '%I:%M:%S' -- date string for os.date(). default: '%I:%M:%S'
}
logger.info('Hi. This\' a info message')
logger.dev('Ignored level. See ignore_levels table field')
logger.crash('A crash!','Oh no!') -- Support multiple args
```
# License
MIT