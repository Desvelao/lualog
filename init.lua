local chalk = require'luachalk'
local Lualog = {}
Lualog.__index = Lualog

--- Create a Lualog instance
-- @param options <table> Options
-- @param options.log_color <string> Define default log color style. Default: 'blue'
-- @param options.show_date <boolean> Flag to show date. Default: false
-- @param options.datestring <string> Date string. Default: '%I:%M:%S'
-- @param options.tag <string> Logger tag. Default: '%I:%M:%S'
-- @param options.ignore_levels <string[]> Array of levels ignored. Default: {}
-- @param options.styles <{}> Table that define styles. Default: {}
-- style_name = style<string>
-- @return Lualog instance
function Lualog.new(options)
    options = options or {}
    local default = {
            log_color = 'blue',
            show_date = false,
            datestring = '%I:%M:%S',
            tag = ''
        }
    local log = {
        __options = {
            ignore_levels = {},
            show_date = options.show_date or default.show_date,
            datestring = options.datestring or default.datestring,
            tag = options.tag or default.tag
        }
    }
    options.ignore_levels = options.ignore_levels or {}
    for _,level in ipairs(options.ignore_levels) do
        log.__options.ignore_levels[level] = true
    end
    log.__log = function(style, tag)
        return function(...)
            if(not log.__options.ignore_levels[tag]) then
                local prefix = ''
                if(log.__options.show_date) then
                    prefix = prefix .. os.date(log.__options.datestring) .. ' '
                end
                if(#log.__options.tag > 0) then
                    prefix = prefix .. log.__options.tag .. ' '
                end
                print(prefix..chalk.ustr(style,tag),...) -- .. ' '.. str
            end
        end
    end
    --- Info log
    -- @param str <string> Message to show
    log.info = log.__log('blue','info')
    --- Warn log
    -- @param str <string> Message to show
    log.warn = log.__log('yellow','warn')
    --- Error log
    -- @param str <string> Message to show
    log.error = log.__log('red','error')
    options.styles = options.styles or {}
    for style,opt_style in pairs(options.styles) do
        log[style] = log.__log(opt_style or default.log_color ,style)
    end
    setmetatable(log,Lualog)
    return log
end

return Lualog

--     -- Example
--     -- local Lualog = require'lualog'
--     print('Example Lualog')
--     local logger = Lualog.new{
--         tag = 'Lualog', -- a logger tag. default: ''
--         styles = {dev = 'yellow', crash = 'bgred'}, -- define custom methods and their style. default: {}
--         ignore_levels = {'dev'}, -- ignore levels (array). default: {}
--         show_date = true, -- show date. default: false
--         datestring = '%I:%M:%S' -- date stringfor os.date(). default: '%I:%M:%S'
--     }
--     logger.info('Hi. This\' a info message')
--     logger.dev('Ignored level. See ignore_levels table field')
--     logger.crash('A crash!','Oh no!') -- Support multiple args
