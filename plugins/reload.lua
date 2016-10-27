do
  local function reload_plugins(msg)
    plugins = {}
    load_plugins()
    local text = "_#BOT_ *Reloaded!*\n*#All* _PLugins_ *Reloaded!*\n_#All_ *Changes* _Succesfully_ *Installed.*\n*#TeleBeyond* _Is Ready._"
send_api_msg(msg, get_receiver_api(msg), text, true, 'md')
  end
function run(msg, matches)

if matches[1] == 'reload' then
    if not is_sudo(msg) then
       return ""
    end


return reload_plugins(msg)

    end
  
end

return {
  patterns = {
    "^[!/#](reload)$"
  },
  run = run
}
end
