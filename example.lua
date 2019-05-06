-- Example
local Lualog = require'lualog'

-- Create a instance
local logger = Lualog.new{ -- you can use Lualog() instead Lualog.lew
    tag = 'My Logger', -- a logger tag. default: ''
    styles = {dev = 'yellow', crash = 'bgred', data= 'red'}, -- define custom methods and their style. default: {}
    ignore_levels = {'dev'}, -- ignore levels (array). default: {}
    datestring = '%H:%M:%S', -- date string for os.date(). default: false => Not show
     table_inspect = {
        prettyfy = true, -- pretty print tables
        allow_tostring = true, -- allow table __tostring methamethod to apply instead plugin
        level_depth = 0 -- max table level to inspect
    },
    plugins = {'table-inspect'} -- Add plugins to transform the elements you log. default = {}
                                -- 'table-inspect' is a predefined plugin to inspect tables
}

-- Default logging methods
logger.info('Hi. This\' a info message')
logger.warn('This\' a warning message')
logger.error('A fatal error just happened!')

-- Custom defined logging methods
logger.dev('Ignored level. See ignore_levels table field') -- this log is ignored due to ignore_levels = {'dev'}
logger.crash('A crash!','Oh no!') -- support multiple args
logger.data('My data').info('A log chainning method!') -- chain logging methods but they print at new lines

-- Logging without tags
logger('my_string', true, 2, {id = 'my-id'}) --
logger:print('my_string', true, 2, {id = 'my-id'}) -- same logger()

-- Add custom plugins
function my_plugin(element)
    if(type(element) == 'table' and element.value > 4)then
        return '<Element value=' .. element.value .. '>' -- return a non-nil value to transform your element to logging.
        -- If return nil or no return, next plugin in the plugins queue is executed.
    end
end

logger:use(my_plugin) -- my_plugin is added to plugins queue and will be first to try to apply

logger({value = 10, other_key = 'key-value'})

-- Log to console/terminal
-- '<Element value=10>'
