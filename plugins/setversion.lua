local function run(msg, matches)
if matches[1] == "setversion" then
if not is_sudo(msg) then
return ''
end
local version = matches[2]
redis:set('bot:version',version)
return 'ورژن ربات تغییر کرد به : '..matches[2]
end
end
return {
patterns ={
"^[!#/](setversion) (.*)$",
},
run = run
}
