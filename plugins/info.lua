--[[
#
# Show users information in groups 
#
# author: Arian < @Dragon_Born > 
# our channel: @GPMod
# Version: 2016-04-02
#
# Features added:
# -- setrank on reply
# -- get users info with their IDs and @username
#
]]

do
local Arian = 157059515 --put your id here(BOT OWNER ID)
local Sosha = 0 
--local Sosha2 = 164484149

local function setrank(msg, name, value,receiver) -- setrank function
  local hash = nil

    hash = 'rank:'..msg.to.id..':variables'

  if hash then
    redis:hset(hash, name, value)
	return reply_msg(msg.id, 'set Rank for ('..name..') To : '..value, ok_cb,  true)
  end
end


local function res_user_callback(extra, success, result) -- /info <username> function
  if success == 1 then  
  if result.username then
   Username = '@'..result.username
   else
   Username = '----'
  end
    local text = 'Full name : '..(result.first_name or '')..' '..(result.last_name or '')..'\n'
               ..'User name: '..Username..'\n'
               ..'ID : '..result.peer_id..'\n\n'
	local hash = 'rank:'..extra.chat2..':variables'
	local value = redis:hget(hash, result.id)
    if not value then
	 if result.peer_id == tonumber(Arian) then
	   text = text..'Rank : ادمین کل ربات (Executive Admin) \n\n'
	   elseif result.peer_id == tonumber(Sosha) then
	   text = text..'Rank : ادمین ارشد ربات (Full Access Admin) \n\n'
	   --elseif result.peer_id == tonumber(Sosha2) then
	   --text = text..'Rank : مدیر ارشد ربات (Full Access Admin) \n\n'
	  elseif is_admin2(result.peer_id) then
	   text = text..'Rank : Admin \n\n'
	  elseif is_owner2(result.peer_id, extra.chat2) then
	   text = text..'Rank : Owner \n\n'
	  elseif is_momod2(result.peer_id, extra.chat2) then
	    text = text..'Rank : Moderator \n\n'
      else
	    text = text..'Rank : Member \n\n'
	 end
   else
   text = text..'Rank : '..value..'\n\n'
  end
  local uhash = 'user:'..result.peer_id
  local user = redis:hgetall(uhash)
  local um_hash = 'msgs:'..result.peer_id..':'..extra.chat2
  user_info_msgs = tonumber(redis:get(um_hash) or 0)
  text = text..'Total messages : '..user_info_msgs..'\n\n'
  text = text..'@BeyondTeam'
  send_msg(extra.receiver, text, ok_cb,  true)
  else
	send_msg(extra.receiver, ' Username not found.', ok_cb, false)
  end
end

local function action_by_id(extra, success, result)  -- /info <ID> function
 if success == 1 then
 if result.username then
   Username = '@'..result.username
   else
   Username = '----'
 end
   local text = 'Full name : '..(result.first_name or '')..' '..(result.last_name or '')..'\n'
               ..'Username: '..Username..'\n'
               ..'ID : '..result.peer_id..'\n\n'
  local hash = 'rank:'..extra.chat2..':variables'
  local value = redis:hget(hash, result.peer_id)
  if not value then
	 if result.peer_id == tonumber(Arian) then
	   text = text..'Rank : ادمین کل ربات (Executive Admin) \n\n'
	   elseif result.peer_id == tonumber(Sosha) then
	   text = text..'Rank : ادمین ارشد ربات (Full Access Admin) \n\n'
	   elseif result.peer_id == tonumber(Sosha2) then
	   text = text..'Rank : مدیر ارشد ربات (Full Access Admin) \n\n'
	  elseif is_admin2(result.peer_id) then
	   text = text..'Rank : Admin \n\n'
	  elseif is_owner2(result.peer_id, extra.chat2) then
	   text = text..'Rank : Owner \n\n'
	  elseif is_momod2(result.peer_id, extra.chat2) then
	   text = text..'Rank : Moderator \n\n'
	  else
	   text = text..'Rank : Member \n\n'
	  end
   else
    text = text..'Rank : '..value..'\n\n'
  end
  local uhash = 'user:'..result.peer_id
  local user = redis:hgetall(uhash)
  local um_hash = 'msgs:'..result.peer_id..':'..extra.chat2
  user_info_msgs = tonumber(redis:get(um_hash) or 0)
  text = text..'Total messages : '..user_info_msgs..'\n\n'
  text = text..'@BeyondTeam'
  send_msg(extra.receiver, text, ok_cb,  true)
  else
  send_msg(extra.receiver, 'id not found.\nuse : /info @username', ok_cb, false)
  end
end

local function action_by_reply(extra, success, result)-- (reply) /info  function
		if result.from.username then
		   Username = '@'..result.from.username
		   else
		   Username = '----'
		 end
  local text = 'Full name : '..(result.from.first_name or '')..' '..(result.from.last_name or '')..'\n'
               ..'Username : '..Username..'\n'
               ..'ID : '..result.from.peer_id..'\n\n'
	local hash = 'rank:'..result.to.id..':variables'
		local value = redis:hget(hash, result.from.peer_id)
		 if not value then
		    if result.from.peer_id == tonumber(Arian) then
	send_document(extra.receiver, "./info/"..result.from.peer_id..".webp", ok_cb, false)
		       text = text..'Rank : ادمین کل ربات (Executive Admin) \n\n'
			   elseif result.peer_id == tonumber(Sosha) then
	send_document(extra.receiver, "./info/"..result.from.peer_id..".webp", ok_cb, false)
	           text = text..'Rank : ادمین ارشد ربات (Full Access Admin) \n\n'
	          --elseif result.peer_id == tonumber(Sosha2) then
	          --text = text..'Rank : مدیر ارشد ربات (Full Access Admin) \n\n'
		     elseif is_admin2(result.from.peer_id) then
	send_document(extra.receiver, "./info/"..result.from.peer_id..".webp", ok_cb, false)
		       text = text..'Rank : Admin \n\n'
		     elseif is_owner2(result.from.peer_id, result.to.peer_id) then
	send_document(extra.receiver, "./info/"..result.from.peer_id..".webp", ok_cb, false)
		       text = text..'Rank : Owner \n\n'
		     elseif is_momod2(result.from.peer_id, result.to.peer_id) then
	send_document(extra.receiver, "./info/"..result.from.peer_id..".webp", ok_cb, false)
		       text = text..'Rank : Moderator \n\n'
		 else
	send_document(extra.receiver, "./info/"..result.from.peer_id..".webp", ok_cb, false)
		       text = text..'Rank : Member \n\n'
			end
		  else
	send_document(extra.receiver, "./info/"..result.from.peer_id..".webp", ok_cb, false)
		   text = text..'Rank : '..value..'\n\n'
		 end
         local user_info = {} 
  local uhash = 'user:'..result.from.peer_id
  local user = redis:hgetall(uhash)
  local um_hash = 'msgs:'..result.from.peer_id..':'..result.to.peer_id
  user_info_msgs = tonumber(redis:get(um_hash) or 0)
  text = text..'Total messages : '..user_info_msgs..'\n\n'
  text = text..'@BeyondTeam'
  reply_msg(result.id, text, ok_cb, true)
end

local function action_by_reply2(extra, success, result)
local value = extra.value
setrank(result, result.from.peer_id, value, extra.receiver)
end

local function run(msg, matches)
 if matches[1]:lower() == 'setrank' then
  local hash = 'usecommands:'..msg.from.id..':'..msg.to.id
  redis:incr(hash)
  if not is_sudo(msg) then
    return "این دستور فقط برای ادمین های اصلی ربات فعال می باشد"
  end
  local receiver = get_receiver(msg)
  local Reply = msg.reply_id
  if msg.reply_id then
  local value = string.sub(matches[2], 1, 1000)
    msgr = get_message(msg.reply_id, action_by_reply2, {receiver=receiver, Reply=Reply, value=value})
  else
  local name = string.sub(matches[2], 1, 50)
  local value = string.sub(matches[3], 1, 1000)
  local text = setrank(msg, name, value)

  return text
  end
  end
 if matches[1]:lower() == 'info' and not matches[2] then
  local receiver = get_receiver(msg)
  local Reply = msg.reply_id
  if msg.reply_id then
    msgr = get_message(msg.reply_id, action_by_reply, {receiver=receiver, Reply=Reply})
  else
  if msg.from.username then
   Username = '@'..msg.from.username
   else
   Username = '----'
   end
   local text = 'First name : '..(msg.from.first_name or '----')..'\n'
   local text = text..'Last name : '..(msg.from.last_name or '----')..'\n'	
   local text = text..'Username : '..Username..'\n'
   local text = text..'ID : '..msg.from.id..'\n\n'
   local hash = 'rank:'..msg.to.id..':variables'
	if hash then
	  local value = redis:hget(hash, msg.from.id)
	  if not value then
		if msg.from.id == tonumber(Arian) then
	send_document(get_receiver(msg), "./info/"..msg.from.id..".webp", ok_cb, false)
		 text = text..'Rank : ادمین کل ربات (Executive Admin) \n\n'
		 elseif msg.from.id == tonumber(Sosha) then
	send_document(get_receiver(msg), "./info/"..msg.from.id..".webp", ok_cb, false)
		 text = text..'Rank : ادمین ارشد ربات (Full Access Admin) \n\n'
		elseif is_sudo(msg) then
	send_document(get_receiver(msg), "./info/"..msg.from.id..".webp", ok_cb, false)
		 text = text..'Rank : Admin \n\n'
		elseif is_owner(msg) then
	send_document(get_receiver(msg), "./info/"..msg.from.id..".webp", ok_cb, false)
		 text = text..'Rank : Owner \n\n'
		elseif is_momod(msg) then
	send_document(get_receiver(msg), "./info/"..msg.from.id..".webp", ok_cb, false)
		 text = text..'Rank : Moderator \n\n'
		else
	send_document(get_receiver(msg), "./info/"..msg.from.id..".webp", ok_cb, false)
		 text = text..'Rank : Member \n\n'
		end
	  else
	send_document(get_receiver(msg), "./info/"..msg.from.id..".webp", ok_cb, false)
	   text = text..'Rank : '..value..'\n'
	  end
	end
	 local uhash = 'user:'..msg.from.id
 	 local user = redis:hgetall(uhash)
  	 local um_hash = 'msgs:'..msg.from.id..':'..msg.to.id
	 user_info_msgs = tonumber(redis:get(um_hash) or 0)
	 text = text..'Total messages : '..user_info_msgs..'\n\n'
    if msg.to.type == 'chat' or msg.to.type == 'channel' then
	 text = text..'Group name : '..msg.to.title..'\n'
     text = text..'Group ID : '..msg.to.id
    end
	text = text..'\n\n@BeyondTeam'
    return reply_msg(msg.id, text, ok_cb, true)
    end
  end
  if matches[1]:lower() == 'info' and matches[2] then
   local user = matches[2]
   local chat2 = msg.to.id
   local receiver = get_receiver(msg)
   if string.match(user, '^%d+$') then
	  user_info('user#id'..user, action_by_id, {receiver=receiver, user=user, text=text, chat2=chat2})
    elseif string.match(user, '^@.+$') then
      username = string.gsub(user, '@', '')
      msgr = resolve_username(username, res_user_callback, {receiver=receiver, user=user, text=text, chat2=chat2})
   end
  end
end

return {
  description = 'Know your information or the info of a chat members.',
  usage = {
    '!info: Return your info and the chat info if you are in one.',
    '(Reply)!info: Return info of replied user if used by reply.',
    '!info <id>: Return the info\'s of the <id>.',
    '!info @<user_name>: Return the member @<user_name> information from the current chat.',
	'!setrank <userid> <rank>: change members rank.',
	'(Reply)!setrank <rank>: change members rank.',
  },
  patterns = {
    "^[/!]([Ii][Nn][Ff][Oo])$",
    "^[/!]([Ii][Nn][Ff][Oo]) (.*)$",
	"^[/!]([Ss][Ee][Tt][Rr][Aa][Nn][Kk]) (%d+) (.*)$",
	"^[/!]([Ss][Ee][Tt][Rr][Aa][Nn][Kk]) (.*)$",
  },
  run = run
}

end

-- By Arian
