package = "lualog"
version = "0.1-1"
rockspec_format = "3.0"
source = {
   url = "git://github.com/Desvelao/lualog",
   tag = "v0.1.1",
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
      ["lualog.init"] = "init.lua",
      ["lualog.luachalk.init"] = "luachalk/init.lua",
      ["lualog.luachalk.colors"] = "luachalk/colors.lua"
   }
}

