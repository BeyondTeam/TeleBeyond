local function run(msg, matches)
if matches[1] == "sethelp" then
if not is_sudo(msg) then
return 'شما سودو نیستید'
end
if msg.to.type == 'channel' then
local help = matches[2]
redis:set('bot:help',help)
return 'لیست جدید دستورات ربات ثبت شد'
end
end
if matches[1] == 'help' then
if not is_momod(msg) then
return 
end
if msg.to.type == 'channel' then
    local hash = ('bot:help')
    local help = redis:get(hash)
    if not help then
    return 'لیست دستورات ثبت نشده'
    else
    reply_msg(msg.id, help, ok_cb, false)
    end
    end
    end
if matches[1] == 'delhelp' then
if not is_sudo(msg) then
return 'شما سودو نیستید'
end
if msg.to.type == 'channel' then
    local hash = ('bot:help')
    redis:del(hash)
return 'لیست دستورات ربات پاک شد'
end
end
if matches[1] == "sethelp" then
if not is_sudo(msg) then
return 'شما سودو نیستید'
end
if msg.to.type == 'chat' then
local help = matches[2]
redis:set('bot:helpgp',help)
return 'لیست جدید دستورات ربات ثبت شد'
end
end
if matches[1] == 'help' then
if not is_momod(msg) then
return 
end
if msg.to.type == 'chat' then
    local hash = ('bot:helpgp')
    local help = redis:get(hash)
    if not help then
    return 'لیست دستورات ثبت نشده'
    else
    reply_msg(msg.id, help, ok_cb, false)
    end
    end
    end
if matches[1] == 'delhelp' then
if not is_sudo(msg) then
return 'شما سودو نیستید'
end
if msg.to.type == 'chat' then
    local hash = ('bot:helpgp')
    redis:del(hash)
return 'لیست دستورات ربات پاک شد'
end
end
if matches[1] == "sethelpfun" then
if not is_sudo(msg) then
return 'شما سودو نیستید'
end
local helpfun = matches[2]
redis:set('bot:helpfun',helpfun)
return 'لیست جدید دستورات فان ثبت شد'
end
if matches[1] == 'helpfun' then
    local hash = ('bot:helpfun')
    local helpfun = redis:get(hash)
    if not helpfun then
    return 'لیست دستورات فان ثبت نشده'
    else
    reply_msg(msg.id, helpfun, ok_cb, false)
    end
    end
if matches[1] == 'delhelpfun' then
if not is_sudo(msg) then
return 'شما سودو نیستید'
end
    local hash = ('bot:helpfun')
    redis:del(hash)
return 'لیست دستورات فان پاک شد'
end
end
return {
patterns ={
"^[!#/](sethelp) (.*)$",
"^[!#/](help)$",
"^[!#/](delhelp)$",
"^[!#/](sethelpfun) (.*)$",
"^[!#/](helpfun)$",
"^[!#/](delhelpfun)$",
},
run = run
}
