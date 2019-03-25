package = "lualog"
version = "0.1-3"
rockspec_format = "3.0"
source = {
   url = "git://github.com/Desvelao/lualog",
   tag = "v0.1.3",
   dir = "lualog"
}
description = {
   summary = "Simple logger for Lua.",
   detailed = [[
      Create a simple logger for Lua with some configurations as show date, stylized tags and logger name.
   ]],
   homepage = "https://github.com/Desvelao/lualog",
   issues_url = "https://github.com/Desvelao/lualog/issues",
   maintainer = "Desvelao",
   license = "MIT"
}
dependencies = {
    "lua >= 5.1"
}
build = {
   type = "builtin",
   modules = {
      ["lualog.init"] = "lualog/init.lua",
      ["lualog.colorizer"] = "lualog/colorizer.lua",
      ["lualog.colors"] = "lualog/colors.lua",
      ["lualog.inspect"] = "lualog/inspect.lua",
      ["lualog.util"] = "lualog/util.lua",
   }
}

