
local function pre_process(msg)
  local data = load_data(_config.moderation.data)
  -- SERVICE MESSAGE
  if msg.action and msg.action.type then
    local action = msg.action.type
    -- Check if banned user joins chat by link
    if action == 'chat_add_user_link' then
      local user_id = msg.from.id
      print('Checking invited user '..user_id)
      local banned = is_banned(user_id, msg.to.id)
      if banned or is_gbanned(user_id) then -- Check it with redis
      print('User is banned!')
      local print_name = user_print_name(msg.from):gsub("‮", "")
	  local name = print_name:gsub("_", "")
      savelog(msg.to.id, name.." ["..msg.from.id.."] is banned and kicked ! ")-- Save to logs
      kick_user(user_id, msg.to.id)
      end
    end
    -- Check if banned user joins chat
    if action == 'chat_add_user' then
      local user_id = msg.action.user.id
      print('Checking invited user '..user_id)
      local banned = is_banned(user_id, msg.to.id)
      if banned and not is_momod2(msg.from.id, msg.to.id) or is_gbanned(user_id) and not is_admin2(msg.from.id) then -- Check it with redis
        print('User is banned!')
      local print_name = user_print_name(msg.from):gsub("‮", "")
	  local name = print_name:gsub("_", "")
        savelog(msg.to.id, name.." ["..msg.from.id.."] added a banned user >"..msg.action.user.id)-- Save to logs
        kick_user(user_id, msg.to.id)
        local banhash = 'addedbanuser:'..msg.to.id..':'..msg.from.id
        redis:incr(banhash)
        local banhash = 'addedbanuser:'..msg.to.id..':'..msg.from.id
        local banaddredis = redis:get(banhash)
        if banaddredis then
          if tonumber(banaddredis) >= 4 and not is_owner(msg) then
            kick_user(msg.from.id, msg.to.id)-- Kick user who adds ban ppl more than 3 times
          end
          if tonumber(banaddredis) >=  8 and not is_owner(msg) then
            ban_user(msg.from.id, msg.to.id)-- Kick user who adds ban ppl more than 7 times
            local banhash = 'addedbanuser:'..msg.to.id..':'..msg.from.id
            redis:set(banhash, 0)-- Reset the Counter
          end
        end
      end
     if data[tostring(msg.to.id)] then
       if data[tostring(msg.to.id)]['settings'] then
         if data[tostring(msg.to.id)]['settings']['lock_bots'] then
           bots_protection = data[tostring(msg.to.id)]['settings']['lock_bots']
          end
        end
      end
    if msg.action.user.username ~= nil then
      if string.sub(msg.action.user.username:lower(), -3) == 'bot' and not is_momod(msg) and bots_protection == "yes" then --- Will kick bots added by normal users
          local print_name = user_print_name(msg.from):gsub("‮", "")
		  local name = print_name:gsub("_", "")
          savelog(msg.to.id, name.." ["..msg.from.id.."] added a bot > @".. msg.action.user.username)-- Save to logs
          kick_user(msg.action.user.id, msg.to.id)
      end
   end
 end
    -- No further checks
  return msg
  end
  -- banned user is talking !
  if msg.to.type == 'chat' or msg.to.type == 'channel' then
    local group = msg.to.id
    local texttext = 'groups'
    --if not data[tostring(texttext)][tostring(msg.to.id)] and not is_realm(msg) then -- Check if this group is one of my groups or not
    --chat_del_user('chat#id'..msg.to.id,'user#id'..our_id,ok_cb,false)
    --return
    --end
    local user_id = msg.from.id
    local chat_id = msg.to.id
    local banned = is_banned(user_id, chat_id)
    if banned or is_gbanned(user_id) then -- Check it with redis
      print('Banned user talking!')
      local print_name = user_print_name(msg.from):gsub("‮", "")
	  local name = print_name:gsub("_", "")
      savelog(msg.to.id, name.." ["..msg.from.id.."] banned user is talking !")-- Save to logs
      kick_user(user_id, chat_id)
      msg.text = ''
    end
  end
  return msg
end

local function banall_by_reply(extra, success, result)
	if result.to.peer_type == 'chat' or result.to.peer_type == 'channel' then
		local chat = 'chat#id'..result.to.peer_id
		local channel = 'channel#id'..result.to.peer_id
	if tonumber(result.from.peer_id) == tonumber(our_id) then -- Ignore bot
			return
	end
	if is_admin2(result.from.peer_id) then -- Ignore admins
		return
	end
		banall_user(result.from.peer_id)
		send_large_msg(chat, "User "..result.from.peer_id.." Golobally Banned")
		send_large_msg(channel, "کاربر از تمام گروه های ربات محروم شد.\nآیدی : "..result.from.peer_id)
	else
		return
	end
end

local function unbanall_by_reply(extra, success, result)
	if result.to.peer_type == 'chat' or result.to.peer_type == 'channel' then
	local user_id = result.from.peer_id
		local chat = 'chat#id'..result.to.peer_id
		local channel = 'channel#id'..result.to.peer_id
	if tonumber(result.from.peer_id) == tonumber(our_id) then -- Ignore bot
			return
	end
	if is_admin2(result.from.peer_id) then -- Ignore admins
		return
	end
     if not is_gbanned(result.from.peer_id) then
       return result.from.peer_id..' is already un-Gbanned.'
      end
	  if is_gbanned(result.from.peer_id) then
		unbanall_user(result.from.peer_id)
		send_large_msg(chat, "User "..result.from.peer_id.." Golobally un-Banned")
		send_large_msg(channel, "کاربر از محرومیت گروه های ربات خارج شد.\nآیدی : "..result.from.peer_id)
	end
	end
end

local function unban_by_reply(extra, success, result)
	if result.to.peer_type == 'chat' or result.to.peer_type == 'channel' then
		local chat = 'chat#id'..result.to.peer_id
		local channel = 'channel#id'..result.to.peer_id
	if tonumber(result.from.peer_id) == tonumber(our_id) then -- Ignore bot
			return
	end
	if is_admin2(result.from.peer_id) then -- Ignore admins
		return
	end
		send_large_msg(chat, "User "..result.from.peer_id.." un-Banned")
		send_large_msg(channel, "کاربر از محرومیت گروه خارج شد.\nآیدی : "..result.from.peer_id)
		local hash =  'banned:'..result.to.peer_id
		redis:srem(hash, result.from.peer_id)
	else
		return
	end
end

local function kick_ban_res(extra, success, result)
      local chat_id = extra.chat_id
	  local chat_type = extra.chat_type
	  if chat_type == "chat" then
		receiver = 'chat#id'..chat_id
	  else
		receiver = 'channel#id'..chat_id
	  end
	  if success == 0 then
		return send_large_msg(receiver, "Cannot find user by that username!")
	  end
      local member_id = result.peer_id
      local user_id = member_id
      local member = result.username
	  local from_id = extra.from_id
      local get_cmd = extra.get_cmd
       if get_cmd == "kick" then
         if member_id == from_id then
            send_large_msg(receiver, "You can't kick yourself")
			return
         end
         if is_momod2(member_id, chat_id) and not is_admin2(sender) then
            send_large_msg(receiver, "You can't kick mods/owner/admins")
			return
         end
		 kick_user(member_id, chat_id)
      elseif get_cmd == 'ban' then
        if is_momod2(member_id, chat_id) and not is_admin2(sender) then
			send_large_msg(receiver, "You can't ban mods/owner/admins")
			return
        end
        send_large_msg(receiver, 'کاربر از گروه محروم شد.\nیوزر : @'..member..'\nآیدی : '..member_id)
		ban_user(member_id, chat_id)
      elseif get_cmd == 'unban' then
        send_large_msg(receiver, 'کاربر از محرومیت گروه خارج شد.\nیوزر : @'..member..'\nآیدی : '..member_id)
        local hash =  'banned:'..chat_id
        redis:srem(hash, member_id)
        return 'User '..user_id..' unbanned'
      elseif get_cmd == 'banall' then
        send_large_msg(receiver, 'کاربر از تمام گروه های ربات محروم شد.\nیوزر : @'..member..'\nآیدی : '..member_id)
		banall_user(member_id)
      elseif get_cmd == 'unbanall' then
        send_large_msg(receiver, 'کاربر از محرومیت گروه های ربات خارج شد.\nیوزر : @'..member..'\nآیدی : '..member_id)
	    unbanall_user(member_id)
    end
end

local function run(msg, matches)
local support_id = msg.from.id
 if matches[1]:lower() == 'id' and msg.to.type == "chat" or msg.to.type == "user" then
    if msg.to.type == "user" then
      return "Your id : "..msg.from.id
    end
    if type(msg.reply_id) ~= "nil" then
      local print_name = user_print_name(msg.from):gsub("‮", "")
	  local name = print_name:gsub("_", "")
        savelog(msg.to.id, name.." ["..msg.from.id.."] used /id ")
        id = get_message(msg.reply_id,get_message_callback_id, false)
    elseif matches[1]:lower() == 'id' then
      local name = user_print_name(msg.from)
      savelog(msg.to.id, name.." ["..msg.from.id.."] used /id ")
local text = "_🇮🇷 Group ID : _*"..msg.to.id.."*\n_🇮🇷 Group Name : _*"..msg.to.title.."*"
send_api_msg(msg, get_receiver_api(msg), text, true, 'md')
end
  end
  if matches[1]:lower() == 'kickme' and msg.to.type == "chat" then-- /kickme
  local receiver = get_receiver(msg)
    if msg.to.type == 'chat' then
      local print_name = user_print_name(msg.from):gsub("‮", "")
	  local name = print_name:gsub("_", "")
      savelog(msg.to.id, name.." ["..msg.from.id.."] left using kickme ")-- Save to logs
      chat_del_user("chat#id"..msg.to.id, "user#id"..msg.from.id, ok_cb, false)
    end
  end

  if not is_momod(msg) then -- Ignore normal users
    return
  end

  if matches[1]:lower() == "banlist" then -- Ban list !
    local chat_id = msg.to.id
    if matches[2] and is_admin1(msg) then
      chat_id = matches[2]
    end
    return ban_list(chat_id)
  end

  if matches[1]:lower() == 'ban' then-- /ban
    if type(msg.reply_id)~="nil" and is_momod(msg) then
      if is_admin1(msg) then
		msgr = get_message(msg.reply_id,ban_by_reply_admins, false)
      else
        msgr = get_message(msg.reply_id,ban_by_reply, false)
      end
      local user_id = matches[2]
      local chat_id = msg.to.id
    elseif string.match(matches[2], '^%d+$') then
        if tonumber(matches[2]) == tonumber(our_id) then
         	return
        end
		if not is_admin1(msg) and is_momod2(matches[2], msg.to.id) then
			return "you can't ban mods/owner/admins"
		end
        if tonumber(matches[2]) == tonumber(msg.from.id) then
          	return "You can't ban your self !"
        end
        local print_name = user_print_name(msg.from):gsub("‮", "")
	    local name = print_name:gsub("_", "")
		local receiver = get_receiver(msg)
        savelog(msg.to.id, name.." ["..msg.from.id.."] baned user ".. matches[2])
        ban_user(matches[2], msg.to.id)
		send_large_msg(receiver, 'User ['..matches[2]..'] banned')
      else
		local cbres_extra = {
		chat_id = msg.to.id,
		get_cmd = 'ban',
		from_id = msg.from.id,
		chat_type = msg.to.type
		}
		local username = string.gsub(matches[2], '@', '')
		resolve_username(username, kick_ban_res, cbres_extra)
    end
  end

if matches[1]:lower() == 'kick' then
    if type(msg.reply_id)~="nil" and is_momod(msg) then
      if is_admin1(msg) then
        msgr = get_message(msg.reply_id,Kick_by_reply_admins, false)
      else
        msgr = get_message(msg.reply_id,Kick_by_reply, false)
      end
	elseif string.match(matches[2], '^%d+$') then
		if tonumber(matches[2]) == tonumber(our_id) then
			return
		end
		if not is_admin1(msg) and is_momod2(matches[2], msg.to.id) then
			return "you can't kick mods/owner/admins"
		end
		if tonumber(matches[2]) == tonumber(msg.from.id) then
			return "You can't kick your self !"
		end
    local user_id = matches[2]
    local chat_id = msg.to.id
		local print_name = user_print_name(msg.from):gsub("‮", "")
		local name = print_name:gsub("_", "")
		savelog(msg.to.id, name.." ["..msg.from.id.."] kicked user ".. matches[2])
		kick_user(user_id, chat_id)
	else
		local cbres_extra = {
			chat_id = msg.to.id,
			get_cmd = 'kick',
			from_id = msg.from.id,
			chat_type = msg.to.type
		}
		local username = string.gsub(matches[2], '@', '')
		resolve_username(username, kick_ban_res, cbres_extra)
	end
end

	if not is_admin1(msg) and not is_support(support_id) then
		return
	end
	if matches[1]:lower() == 'banall' then-- /ban
    if type(msg.reply_id)~="nil" and is_momod(msg) then
      if is_admin1(msg) then
		msgr = get_message(msg.reply_id,banall_by_reply, false)
      end
      local user_id = matches[2]
      local chat_id = msg.to.id
    elseif string.match(matches[2], '^%d+$') then
        if tonumber(matches[2]) == tonumber(our_id) then
         	return
        end
		if not is_admin1(msg) and is_momod2(matches[2], msg.to.id) then
			return "you can't ban mods/owner/admins"
		end
        if tonumber(matches[2]) == tonumber(msg.from.id) then
          	return "You can't ban your self !"
        end
        local print_name = user_print_name(msg.from):gsub("‮", "")
	    local name = print_name:gsub("_", "")
		local receiver = get_receiver(msg)
        savelog(msg.to.id, name.." ["..msg.from.id.."] banedall user ".. matches[2])
        banall_user(matches[2])
		send_large_msg(receiver, 'کاربر از تمام گروه های ربات محروم شد\nایدی : ['..matches[2]..']')
      else
		local cbres_extra = {
		chat_id = msg.to.id,
		get_cmd = 'banall',
		from_id = msg.from.id,
		chat_type = msg.to.type
		}
		local username = string.gsub(matches[2], '@', '')
		resolve_username(username, kick_ban_res, cbres_extra)
    end
  end

 if matches[1]:lower() == 'unbanall' then-- /ban
    if type(msg.reply_id)~="nil" and is_momod(msg) then
      if is_admin1(msg) then
		msgr = get_message(msg.reply_id,unbanall_by_reply, false)
      end
      local user_id = matches[2]
      local chat_id = msg.to.id
    elseif string.match(matches[2], '^%d+$') then
        if tonumber(matches[2]) == tonumber(our_id) then
         	return
        end
        local print_name = user_print_name(msg.from):gsub("‮", "")
	    local name = print_name:gsub("_", "")
		local receiver = get_receiver(msg)
        savelog(msg.to.id, name.." ["..msg.from.id.."] unbanedall user ".. matches[2])
        unbanall_user(matches[2])
		send_large_msg(receiver, 'کاربر از محرومیت گروه های ربات خارج شد\nایدی : ['..matches[2]..']')
      else
		local cbres_extra = {
		chat_id = msg.to.id,
		get_cmd = 'unbanall',
		from_id = msg.from.id,
		chat_type = msg.to.type
		}
		local username = string.gsub(matches[2], '@', '')
		resolve_username(username, kick_ban_res, cbres_extra)
    end
  end

if matches[1]:lower() == 'unban' then-- /ban
    if type(msg.reply_id)~="nil" and is_momod(msg) then
      if is_momod(msg) then
		msgr = get_message(msg.reply_id,unban_by_reply, false)
      end
      local user_id = matches[2]
      local chat_id = msg.to.id
    elseif string.match(matches[2], '^%d+$') then
        if tonumber(matches[2]) == tonumber(our_id) then
         	return
        end
        local print_name = user_print_name(msg.from):gsub("‮", "")
	    local name = print_name:gsub("_", "")
		local receiver = get_receiver(msg)
        savelog(msg.to.id, name.." ["..msg.from.id.."] unban user ".. matches[2])
        local hash = 'banned:'..msg.to.id
         redis:srem(hash, matches[2])
		send_large_msg(receiver, 'User ['..matches[2]..'] unbanned')
      else
		local cbres_extra = {
		chat_id = msg.to.id,
		get_cmd = 'unban',
		from_id = msg.from.id,
		chat_type = msg.to.type
		}
		local username = string.gsub(matches[2], '@', '')
		resolve_username(username, kick_ban_res, cbres_extra)
    end
  end
if matches[1]:lower() == 'del' then 
      if not is_solid(msg) then
        return "شما سلید نیستید!"
      end
if matches[2] == 'gbanlist' then
local hash = 'gbanned'
send_large_msg(get_receiver(msg), "لیست سوپر بن پاک شد.")
redis:del(hash)
     end
end
  if matches[1]:lower() == "gbanlist" then -- Global ban list
    return banall_list()
  end
end

return {
  patterns = {
    "^[#!/]([Bb]anall) (.*)$",
    "^[#!/]([Bb]anall)$",
	"^[#!/]([Uu]ubanall)$",
    "^[#!/]([Bb]anlist) (.*)$",
    "^[#!/]([Bb]anlist)$",
    "^[#!/]([Dd]el) (.*)$",
    "^[#!/]([Gg]banlist)$",
	"^[#!/]([Kk]ickme)",
    "^[#!/]([Kk]ick)$",
	"^[#!/]([Bb]an)$",
    "^[#!/]([Bb]an) (.*)$",
    "^[#!/]([Uu]nban) (.*)$",
    "^[#!/]([Uu]nbanall) (.*)$",
    "^[#!/]([Uu]nbanall)$",
    "^[#!/]([Kk]ick) (.*)$",
    "^[#!/]([Uu]nban)$",
    --"^[#!/]([Ii]d)$",
    "^!!tgservice (.+)$"
  },
  run = run,
  pre_process = pre_process
}
