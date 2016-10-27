--Begin supergrpup.lua
--Check members #Add supergroup
local function check_member_super(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local data = cb_extra.data
  local msg = cb_extra.msg
  if success == 0 then
	send_large_msg(receiver, "ابتدا منو ادمین سوپر گروه کنید!")
  end
  for k,v in pairs(result) do
    local member_id = v.peer_id
    if member_id ~= our_id then
      -- SuperGroup configuration
      data[tostring(msg.to.id)] = {
        group_type = 'SuperGroup',
		long_id = msg.to.peer_id,
		moderators = {},
        set_owner = member_id ,
        settings = {
          set_name = string.gsub(msg.to.title, '_', ' '),
		  lock_arabic = 'no',
		  lock_link = "yes",
		  lock_url = "yes",
          flood = 'yes',
		  lock_spam = 'yes',
		  lock_sticker = 'no',
		  member = 'no',
     lock_bots = 'yes',
     lock_tags = 'yes',
		  public = 'yes',
		  lock_rtl = 'no',
		  expiretime = 'null',
		  welcome = '✅',
		  chat = '✅',
		  kickme = '✅',
		  --lock_contacts = 'no',
		  strict = 'no'
        }
      }
      save_data(_config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = {}
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.to.id)] = msg.to.id
      save_data(_config.moderation.data, data)
	  local text = 'سوپر گروه اضافه شد'
      return reply_msg(msg.id, text, ok_cb, false)
    end
  end
end

--Check Members #rem supergroup
local function check_member_superrem(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local data = cb_extra.data
  local msg = cb_extra.msg
  for k,v in pairs(result) do
    local member_id = v.id
    if member_id ~= our_id then
	  -- Group configuration removal
      data[tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = nil
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
	  local text = 'سوپر گروه حذف شد و ربات آن را به رسمیت نمیشناسد'
      return reply_msg(msg.id, text, ok_cb, false)
    end
  end
end

--Function to Add supergroup
local function superadd(msg)
	local data = load_data(_config.moderation.data)
	local receiver = get_receiver(msg)
    channel_get_users(receiver, check_member_super,{receiver = receiver, data = data, msg = msg})
end

--Function to remove supergroup
local function superrem(msg)
	local data = load_data(_config.moderation.data)
    local receiver = get_receiver(msg)
    channel_get_users(receiver, check_member_superrem,{receiver = receiver, data = data, msg = msg})
end

--Get and output admins and bots in supergroup
local function callback(cb_extra, success, result)
local i = 1
local chat_name = string.gsub(cb_extra.msg.to.print_name, "_", " ")
local member_type = cb_extra.member_type
local text = member_type.." for "..chat_name..":\n"
for k,v in pairsByKeys(result) do
if not v.first_name then
	name = " "
else
	vname = v.first_name:gsub("‮", "")
	name = vname:gsub("_", " ")
	end
		text = text.."\n"..i.." - "..name.."["..v.peer_id.."]"
		i = i + 1
	end
    send_large_msg(cb_extra.receiver, text)
end

local function callback_clean_bots (extra, success, result)
	local msg = extra.msg
	local receiver = 'channel#id'..msg.to.id
	local channel_id = msg.to.id
	for k,v in pairs(result) do
		local bot_id = v.peer_id
		kick_user(bot_id,channel_id)
	end
end

--Get and output info about supergroup
local function callback_info(cb_extra, success, result)
local title ="اطلاعات سوپر گروه ["..result.title.."]\n\n"
local user_num = "تعداد عضو: "..result.participants_count.."\n"
local admin_num = "تعداد ادمین: "..result.admins_count.."\n"
local kicked_num = "تعداد افراد اخراج شده: "..result.kicked_count.."\n\n"
local channel_id = "آیدی سوپر گروه: "..result.peer_id.."\n"
if result.username then
	channel_username = "Username: @"..result.username
else
	channel_username = ""
end
local text = title..admin_num..user_num..kicked_num..channel_id..channel_username
    send_large_msg(cb_extra.receiver, text)
end

--Get and output members of supergroup
local function callback_who(cb_extra, success, result)
local text = "Members for "..cb_extra.receiver
local i = 1
for k,v in pairsByKeys(result) do
if not v.print_name then
	name = " "
else
	vname = v.print_name:gsub("‮", "")
	name = vname:gsub("_", " ")
end
	if v.username then
		username = " @"..v.username
	else
		username = ""
	end
	text = text.."\n"..i.." - "..name.." "..username.." [ "..v.peer_id.." ]\n"
	--text = text.."\n"..username
	i = i + 1
end
    local file = io.open("./groups/lists/supergroups/"..cb_extra.receiver..".txt", "w")
    file:write(text)
    file:flush()
    file:close()
    send_document(cb_extra.receiver,"./groups/lists/supergroups/"..cb_extra.receiver..".txt", ok_cb, false)
	post_msg(cb_extra.receiver, text, ok_cb, false)
end

--Get and output list of kicked users for supergroup
local function callback_kicked(cb_extra, success, result)
--vardump(result)
local text = "Kicked Members for SuperGroup "..cb_extra.receiver.."\n\n" 
local i = 1
for k,v in pairsByKeys(result) do
if not v.print_name then
	name = " "
else
	vname = v.print_name:gsub("‮", "")
	name = vname:gsub("_", " ")
end
	if v.username then
		name = name.." @"..v.username
	end
	text = text.."\n"..i.." - "..name.." [ "..v.peer_id.." ]\n"
	i = i + 1
end
    local file = io.open("./groups/lists/supergroups/kicked/"..cb_extra.receiver..".txt", "w")
    file:write(text)
    file:flush()
    file:close()
    send_document(cb_extra.receiver,"./groups/lists/supergroups/kicked/"..cb_extra.receiver..".txt", ok_cb, false)
	--send_large_msg(cb_extra.receiver, text)
end

--Begin supergroup locks
local function lock_group_links(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_link_lock = data[tostring(target)]['settings']['lock_link']
  if group_link_lock == 'yes' then
    return 'ضد تبلیغ از قبل فعال بوده است'
  else
    data[tostring(target)]['settings']['lock_link'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'ضد تبلیغ فعال شد'
  end
end

local function unlock_group_links(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_link_lock = data[tostring(target)]['settings']['lock_link']
  if group_link_lock == 'no' then
    return 'ضد تبلیغ از قبل غیرفعال بوده است'
  else
    data[tostring(target)]['settings']['lock_link'] = 'no'
    save_data(_config.moderation.data, data)
    return 'ضد تبلیغ غیرفعال شد'
  end
end


local function lock_group_cmd(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_cmd_lock = data[tostring(target)]['settings']['lock_cmd']
  if group_cmd_lock == 'yes' then
    return 'قفل دستورات از قبل فعال بوده است'
  else
    data[tostring(target)]['settings']['lock_cmd'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'قفل دستورات فعال شد'
  end
end

local function unlock_group_cmd(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_cmd_lock = data[tostring(target)]['settings']['lock_cmd']
  if group_cmd_lock == 'no' then
    return 'قفل دستورات از قبل غیرفعال بوده است'
  else
    data[tostring(target)]['settings']['lock_cmd'] = 'no'
    save_data(_config.moderation.data, data)
    return 'قفل دستورات غیرفعال شد'
  end
end

local function lock_group_url(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_url_lock = data[tostring(target)]['settings']['lock_url']
  if group_url_lock == 'yes' then
    return 'ضد Url از قبل فعال بوده است'
  else
    data[tostring(target)]['settings']['lock_url'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'ضد Url فعال شد'
  end
end

local function unlock_group_url(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_url_lock = data[tostring(target)]['settings']['lock_url']
  if group_url_lock == 'no' then
    return 'ضد Url از قبل غیرفعال بوده است'
  else
    data[tostring(target)]['settings']['lock_url'] = 'no'
    save_data(_config.moderation.data, data)
    return 'ضد Url غیرفعال شد'
  end
end

local function lock_group_spam(msg, data, target)
  if not is_momod(msg) then
    return
  end
  if not is_owner(msg) then
    return "شما صاحب گروه نیستید!"
  end
  local group_spam_lock = data[tostring(target)]['settings']['lock_spam']
  if group_spam_lock == 'yes' then
    return 'ضد اسپم از قبل فعال بوده است'
  else
    data[tostring(target)]['settings']['lock_spam'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'ضد اسپم فعال شد'
  end
end

local function unlock_group_spam(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_spam_lock = data[tostring(target)]['settings']['lock_spam']
  if group_spam_lock == 'no' then
    return 'ضد اسپم از قبل غیرفعال بوده است'
  else
    data[tostring(target)]['settings']['lock_spam'] = 'no'
    save_data(_config.moderation.data, data)
    return 'ضد اسپم غیرفعال شد'
  end
end

local function lock_group_flood(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_flood_lock = data[tostring(target)]['settings']['flood']
  if group_flood_lock == 'yes' then
    return 'ضد فلود از قبل فعال بوده است'
  else
    data[tostring(target)]['settings']['flood'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'ضد فلود فعال شد'
  end
end

local function unlock_group_flood(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_flood_lock = data[tostring(target)]['settings']['flood']
  if group_flood_lock == 'no' then
    return 'ضد فلود از قبل غیرفعال بوده است'
  else
    data[tostring(target)]['settings']['flood'] = 'no'
    save_data(_config.moderation.data, data)
    return 'ضد فلود غیرفعال شد'
  end
end

--[[local function lock_group_arabic(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_arabic_lock = data[tostring(target)]['settings']['lock_arabic']
  if group_arabic_lock == 'yes' then
    return 'Arabic is already locked' 
  else
    data[tostring(target)]['settings']['lock_arabic'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'Arabic has been locked' 
  end
end

local function unlock_group_arabic(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_arabic_lock = data[tostring(target)]['settings']['lock_arabic']
  if group_arabic_lock == 'no' then
    return 'Arabic/Persian is already unlocked'
  else
    data[tostring(target)]['settings']['lock_arabic'] = 'no'
    save_data(_config.moderation.data, data)
    return 'Arabic/Persian has been unlocked'
  end
end]]

local function lock_group_membermod(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_member_lock = data[tostring(target)]['settings']['lock_member']
  if group_member_lock == 'yes' then
    return 'کاربران گروه از قبل قفل بوده است'
  else
    data[tostring(target)]['settings']['lock_member'] = 'yes'
    save_data(_config.moderation.data, data)
  end
  return 'کاربران گروه قفل شدند'
end

local function unlock_group_membermod(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_member_lock = data[tostring(target)]['settings']['lock_member']
  if group_member_lock == 'no' then
    return 'کاربران گروه قفل نبوده است'
  else
    data[tostring(target)]['settings']['lock_member'] = 'no'
    save_data(_config.moderation.data, data)
    return 'کاربران گروه از قفل خارج شدند'
  end
end

local function lock_group_bots(msg, data, target)
  if not is_momod(msg) then
    return ""
  end
  local group_bots_lock = data[tostring(target)]['settings']['lock_bots']
  if group_bots_lock == 'yes' then
    return 'محافظت دربرابر ورود ربات ها از قبل فعال بود.'
  else
    data[tostring(target)]['settings']['lock_bots'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'محافظت دربرابر ورود ربات ها فعال شد.'
  end
end

local function unlock_group_bots(msg, data, target)
  if not is_momod(msg) then
    return ""
  end
  local group_bots_lock = data[tostring(target)]['settings']['lock_bots']
  if group_bots_lock == 'no' then
    return 'محافظت دربرابر ورود ربات ها از قبل فعال نبود.'
  else
    data[tostring(target)]['settings']['lock_bots'] = 'no'
    save_data(_config.moderation.data, data)
    return 'محافظت دربرابر ربات ها غیر فعال شد.'
  end
end

local function lock_group_tag(msg, data, target)
if not is_momod(msg) then
return ""
end
local group_tag_lock = data[tostring(target)]['settings']['lock_tags']
if group_tag_lock == 'yes' then
return 'ضد تگ از قبل فعال بود'
else
data[tostring(target)]['settings']['lock_tags'] = 'yes'
save_data(_config.moderation.data, data)
return 'ضد تگ فعال شد'
end
end
local function unlock_group_tag(msg, data, target)
if not is_momod(msg) then
return ""
end
local group_tag_lock = data[tostring(target)]['settings']['lock_tags']
if group_tag_lock == 'no' then
return 'ضد تگ از قبل غیرفعال بود'
else
data[tostring(target)]['settings']['lock_tags'] = 'no'
save_data(_config.moderation.data, data)
return 'ضد تگ غیر فعال شد'
end
end

--[[local function lock_group_rtl(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_rtl_lock = data[tostring(target)]['settings']['lock_rtl']
  if group_rtl_lock == 'yes' then
    return 'RTL is already locked'
  else
    data[tostring(target)]['settings']['lock_rtl'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'RTL has been locked'
  end
end

local function unlock_group_rtl(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_rtl_lock = data[tostring(target)]['settings']['lock_rtl']
  if group_rtl_lock == 'no' then
    return 'RTL is already unlocked'
  else
    data[tostring(target)]['settings']['lock_rtl'] = 'no'
    save_data(_config.moderation.data, data)
    return 'RTL has been unlocked'
  end
end]]
local function lock_group_welcome(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_welcome_lock = data[tostring(target)]['settings']['welcome']
  if group_welcome_lock == '✅' then
    return 'پیام خوش امد گویی از قبل فعال بوده است'
  else
    data[tostring(target)]['settings']['welcome'] = '✅'
    save_data(_config.moderation.data, data)
    return 'پیام خوش امد گویی فعال شد'
  end
end

local function unlock_group_welcome(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_welcome_lock = data[tostring(target)]['settings']['welcome']
  if group_welcome_lock == '❌' then
    return 'پیام خوش امد گویی از قبل غیرفعال بوده است'
  else
    data[tostring(target)]['settings']['welcome'] = '❌'
    save_data(_config.moderation.data, data)
    return 'پیام خوش امد گویی غیرفعال شد'
  end
end

local function lock_group_chatrobot(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_chatrobot_lock = data[tostring(target)]['settings']['chat']
  if group_chatrobot_lock == '✅' then
    return 'چت با ربات از قبل فعال بوده است'
  else
    data[tostring(target)]['settings']['chat'] = '✅'
    save_data(_config.moderation.data, data)
    return 'چت با ربات فعال شد'
  end
end

local function unlock_group_chatrobot(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_chatrobot_lock = data[tostring(target)]['settings']['chat']
  if group_chatrobot_lock == '❌' then
    return 'چت با ربات از قبل غیرفعال بوده است'
  else
    data[tostring(target)]['settings']['chat'] = '❌'
    save_data(_config.moderation.data, data)
    return 'چت با ربات غیرفعال شد'
  end
end

local function lock_group_kickme(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_kickme_lock = data[tostring(target)]['settings']['kickme']
  if group_kickme_lock == '✅' then
    return 'دستور kickme از قبل فعال بوده است'
  else
    data[tostring(target)]['settings']['kickme'] = '✅'
    save_data(_config.moderation.data, data)
    return 'دستور kickme فعال شد'
  end
end

local function unlock_group_kickme(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_kickme_lock = data[tostring(target)]['settings']['kickme']
  if group_kickme_lock == '❌' then
    return 'دستور kickme از قبل غیرفعال بوده است'
  else
    data[tostring(target)]['settings']['kickme'] = '❌'
    save_data(_config.moderation.data, data)
    return 'دستور kickme غیرفعال شد'
  end
end

local function lock_group_sticker(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_sticker_lock = data[tostring(target)]['settings']['lock_sticker']
  if group_sticker_lock == 'yes' then
    return 'ضد استیکر از قبل فعال بوده است'
  else
    data[tostring(target)]['settings']['lock_sticker'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'ضد استیکر فعال شد'
  end
end

local function unlock_group_sticker(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_sticker_lock = data[tostring(target)]['settings']['lock_sticker']
  if group_sticker_lock == 'no' then
    return 'ضد استیکر از قبل غیرفعال بوده است'
  else
    data[tostring(target)]['settings']['lock_sticker'] = 'no'
    save_data(_config.moderation.data, data)
    return 'ضد استیکر غیرفعال شد'
  end
end

local function lock_group_contacts(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_contacts_lock = data[tostring(target)]['settings']['lock_contacts']
  if group_contacts_lock == 'yes' then
    return 'ضد اشتراک گذاشتن مخاطب از قبل فعال بوده است'
  else
    data[tostring(target)]['settings']['lock_contacts'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'ضد اشتراک گذاشتن مخاطب فعال شد'
  end
end

local function unlock_group_contacts(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_contacts_lock = data[tostring(target)]['settings']['lock_contacts']
  if group_contacts_lock == 'no' then
    return 'ضد اشتراک گذاشتن مخاطب از قبل غیرفعال بوده است'
  else
    data[tostring(target)]['settings']['lock_contacts'] = 'no'
    save_data(_config.moderation.data, data)
    return 'ضد اشتراک گذاشتن مخاطب غیرفعال شد'
  end
end

local function enable_strict_rules(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_strict_lock = data[tostring(target)]['settings']['strict']
  if group_strict_lock == 'yes' then
    return 'Settings are already strictly enforced'
  else
    data[tostring(target)]['settings']['strict'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'Settings will be strictly enforced'
  end
end

local function disable_strict_rules(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_strict_lock = data[tostring(target)]['settings']['strict']
  if group_strict_lock == 'no' then
    return 'Settings are not strictly enforced'
  else
    data[tostring(target)]['settings']['strict'] = 'no'
    save_data(_config.moderation.data, data)
    return 'Settings will not be strictly enforced' 
  end
end
--End supergroup locks

--'Set supergroup rules' function
local function set_rulesmod(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local data_cat = 'rules'
  data[tostring(target)][data_cat] = rules
  save_data(_config.moderation.data, data)
  return 'قوانین گروه ثبت شد'
end

--'Get supergroup rules' function
local function get_rules(msg, data)
  local data_cat = 'rules'
  if not data[tostring(msg.to.id)][data_cat] then
    return 'قوانین گروه در دسترس نیست'
  end
  local rules = data[tostring(msg.to.id)][data_cat]
  local group_name = data[tostring(msg.to.id)]['settings']['set_name']
  local rules = group_name..' \nقوانین گروه:\n\n'..rules:gsub("/n", " ")
  return rules
end

--Set supergroup to public or not public function
local function set_public_membermod(msg, data, target)
  if not is_momod(msg) then
    return "شما مدیر گروه نیستید!"
  end
  local group_public_lock = data[tostring(target)]['settings']['public']
  local long_id = data[tostring(target)]['long_id']
  if not long_id then
	data[tostring(target)]['long_id'] = msg.to.peer_id 
	save_data(_config.moderation.data, data)
  end
  if group_public_lock == 'yes' then
    return 'گروه از قبل عمومی بوده است'
  else
    data[tostring(target)]['settings']['public'] = 'yes'
    save_data(_config.moderation.data, data)
  end
  return 'گروه عمومی شد'
end

local function unlock_group_porn(msg, data, target)
      if not is_momod(msg) then
        return "شما مدیر گروه نیستید!"
      end
  local porn = data[tostring(target)]['settings']['lock_porn']
  if porn == '🔓' then
    return 'محتوای بزرگ سالان از قبل غیرفعال بوده است'
  else
    data[tostring(target)]['settings']['lock_porn'] = '🔓'
    save_data(_config.moderation.data, data)
    return 'محتوای بزرگ سالان غیرفعال شد'
  end
end

local function lock_group_porn(msg, data, target)
      if not is_momod(msg) then
        return "شما مدیر گروه نیستید!"
      end
  local porn = data[tostring(target)]['settings']['lock_porn']
  if porn == '🔐' then
    return 'محتوای بزرگ سالان از قبل فعال بوده است'
  else
    data[tostring(target)]['settings']['lock_porn'] = '🔐'
    save_data(_config.moderation.data, data)
    return 'محتوای بزرگ سالان فعال شد'
  end
end
local function unset_public_membermod(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_public_lock = data[tostring(target)]['settings']['public']
  local long_id = data[tostring(target)]['long_id']
  if not long_id then
	data[tostring(target)]['long_id'] = msg.to.peer_id 
	save_data(_config.moderation.data, data)
  end
  if group_public_lock == 'no' then
    return 'گروه از قبل خصوصی بوده است'
  else
    data[tostring(target)]['settings']['public'] = 'no'
	data[tostring(target)]['long_id'] = msg.to.long_id 
    save_data(_config.moderation.data, data)
    return 'گروه خصوصی شد'
  end
end

--Show supergroup settings; function
function show_supergroup_settingsmod(msg, target)
 	if not is_momod(msg) then
    	return
  	end
	local data = load_data(_config.moderation.data)
    if data[tostring(target)] then
     	if data[tostring(target)]['settings']['flood_msg_max'] then
        	NUM_MSG_MAX = tonumber(data[tostring(target)]['settings']['flood_msg_max'])
        	print('custom'..NUM_MSG_MAX)
      	else
        	NUM_MSG_MAX = 5
      	end
    end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['public'] then
			data[tostring(target)]['settings']['public'] = 'yes'
		end
	end
	--[[if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_rtl'] then
			data[tostring(target)]['settings']['lock_rtl'] = 'no'
		end
	end]]

	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_bots'] then
			data[tostring(target)]['settings']['lock_bots'] = 'no'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_tags'] then
			data[tostring(target)]['settings']['lock_tags'] = 'yes'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_url'] then
			data[tostring(target)]['settings']['lock_url'] = 'yes'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_member'] then
			data[tostring(target)]['settings']['lock_member'] = 'no'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_cmd'] then
			data[tostring(target)]['settings']['lock_cmd'] = 'no'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['welcome'] then
			data[tostring(target)]['settings']['welcome'] = '✅'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['chat'] then
			data[tostring(target)]['settings']['chat'] = '✅'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['kickme'] then
			data[tostring(target)]['settings']['kickme'] = '✅'
		end
	end
    local group_type = "Normal"
    if  data[tostring(msg.to.id)]['group_type'] then
    group_type = data[tostring(msg.to.id)]['group_type']
    end
    local version = "1.0"
    if redis:get('bot:version') then
    version = redis:get('bot:version')
    end
local expiretime = redis:hget('expiretime', get_receiver(msg))
    local expire = ''
  if not expiretime then
  expire = expire..'Unlimited'
  else
   local now = tonumber(os.time())
   expire =  expire..math.floor((tonumber(expiretime) - tonumber(now)) / 86400) + 1
 end
	
  local settings = data[tostring(target)]['settings']
      local text = "*SuperGroup Settings :*\n*["..msg.to.print_name:gsub("_"," ").."]*\n\n_SuperGroup Public : "..settings.public.."_\n_Lock SuperGroup Link : "..settings.lock_link.."_\n_Lock SuperGroup Url : "..settings.lock_url.."_\n_Lock SuperGroup Tags : "..settings.lock_tags.."_\n_Lock SuperGroup Member : "..settings.lock_member.."_\n_Lock SuperGroup Spam : "..settings.lock_spam.."_\n_Lock SuperGroup Flood : "..settings.flood.."_\n_Bots Protection : "..settings.lock_bots.."_\n_Flood Sensitivity : "..NUM_MSG_MAX.."_\n_Bot Commands : "..settings.lock_cmd.."_\n_Welcome Message : "..settings.welcome.."_\n_Chat With Robot : "..settings.chat.."_\n_Kickme Command : "..settings.kickme.."_\n_SuperGroup Type :_ *"..group_type.."*\n_Bot Version :_ *"..version.."*\n_Strict Settings : "..settings.strict.."_\n_Expiry Date SuperGroup :_ *"..expire.."* _Day_\n\n[Beyond Team Channel](Telegram.Me/BeyondTeam)"
  --local text = ":["..msg.to.print_name:gsub("_"," ").."] تنظیمات سوپر گروه\n\n> قفل کاربران گروه: "..settings.lock_member.."\n> قفل تبلیغ: "..settings.lock_link.."\n> قفل اسپم: "..settings.lock_spam.."\n> قفل فلود: "..settings.flood.."\n> حساسیت ضد فلود: "..NUM_MSG_MAX.."\n> Strict settings: "..settings.strict
local text = string.gsub(text,'yes','🔐')
  local text = string.gsub(text,'no','🔓')
send_api_msg(msg, get_receiver_api(msg), text, true, 'md')
  end

function show_supergroup_mutes(msg, target)
 	if not is_momod(msg) then
    	return
  	end
	local data = load_data(_config.moderation.data)
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['mute_text'] then
			data[tostring(target)]['settings']['mute_text'] = 'no'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['mute_audio'] then
			data[tostring(target)]['settings']['mute_audio'] = 'no'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['mute_service'] then
			data[tostring(target)]['settings']['mute_service'] = 'no'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['mute_photo'] then
			data[tostring(target)]['settings']['mute_photo'] = 'no'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['mute_forward'] then
			data[tostring(target)]['settings']['mute_forward'] = 'no'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['mute_reply'] then
			data[tostring(target)]['settings']['mute_reply'] = 'no'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['mute_emoji'] then
			data[tostring(target)]['settings']['mute_emoji'] = 'no'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['mute_video'] then
			data[tostring(target)]['settings']['mute_video'] = 'no'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['mute_gif'] then
			data[tostring(target)]['settings']['mute_gif'] = 'no'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['mute_doc'] then
			data[tostring(target)]['settings']['mute_doc'] = 'no'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['mute_all'] then
			data[tostring(target)]['settings']['mute_all'] = 'no'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_porn'] then
		data[tostring(target)]['settings']['lock_porn'] = 'no'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_contacts'] then
			data[tostring(target)]['settings']['lock_contacts'] = 'no'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_sticker'] then
			data[tostring(target)]['settings']['lock_sticker'] = 'no'
		end
	end
  local settings = data[tostring(target)]['settings']
  	local text = "*MuteList For :*\n*["..msg.to.print_name:gsub("_"," ").."]*\n\n_Mute SuperGroup All : "..settings.mute_all.."_\n_Mute SuperGroup Text : "..settings.mute_text.."_\n_Mute SuperGroup Sticker : "..settings.lock_sticker.."_\n_Mute SuperGroup Photo : "..settings.mute_photo.."_\n_Mute SuperGroup Video : "..settings.mute_video.."_\n_Mute SuperGroup Audio : "..settings.mute_audio.."_\n_Mute SuperGroup Gifs : "..settings.mute_gif.."_\n_Mute SuperGroup Contact : "..settings.lock_contacts.."_\n_Mute SuperGroup File : "..settings.mute_doc.."_\n_Mute SuperGroup Forward : "..settings.mute_forward.."_\n_Mute SuperGroup Reply : "..settings.mute_reply.."_\n_Mute SuperGroup Emoji : "..settings.mute_emoji.."_\n_Mute SuperGroup TgService : "..settings.mute_service.."_\n\n[Beyond Team Channel](Telegram.Me/BeyondTeam)"
local text = string.gsub(text,'yes','🔇')
  local text = string.gsub(text,'no','🔊')
send_api_msg(msg, get_receiver_api(msg), text, true, 'md')
end

local function set_welcomemod(msg, data, target)
      if not is_momod(msg) then
        return "شما مدیر گروه نیستید"
      end
  local data_cat = 'welcome_msg'
  data[tostring(target)][data_cat] = rules
  save_data(_config.moderation.data, data)
  return 'پیام خوش امد گویی :\n'..rules..'\n---------------\nبرای نمایش نام کاربر و نام گروه یا قوانین  میتوانید به صورت زیر عمل کنید\n\n /set welcome salam {name} be goroohe {group} khosh amadid \n ghavanine gorooh: {rules} \n\nربات به صورت هوشمند نام گروه , نام کاربر و قوانین را به جای {name}و{group} و {rules} اضافه میکند.'
end

local function set_expiretime(msg, data, target)
      if not is_sudo(msg) then
        return "شما ادمین ربات نیستید!"
      end
  local hash = 'expiretime'
local expired = matches[2]..'.'..matches[3]..'.'..matches[4]
redis:hset (hash, get_receiver(msg), expired)
  return 'تاریخ انقضای گروه به '..expired..' ست شد'
end

local function promote_admin(receiver, member_username, user_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'channel#id', '')
  local member_tag_username = string.gsub(member_username, '@', '(at)')
  if not data[group] then
    return
  end
  if data[group]['moderators'][tostring(user_id)] then
    return send_large_msg(receiver, member_username..' از قبل مدیر گروه بوده است')
  end
  data[group]['moderators'][tostring(user_id)] = member_tag_username
  save_data(_config.moderation.data, data)
end

local function demote_admin(receiver, member_username, user_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'channel#id', '')
  if not data[group] then
    return
  end
  if not data[group]['moderators'][tostring(user_id)] then
    return send_large_msg(receiver, member_tag_username..' مدیر گروه نیست')
  end
  data[group]['moderators'][tostring(user_id)] = nil
  save_data(_config.moderation.data, data)
end

local function promote2(receiver, member_username, user_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'channel#id', '')
  local member_tag_username = string.gsub(member_username, '@', '(at)')
  if not data[group] then
    return send_large_msg(receiver, 'سوپر گروه اضافه نشده است!')
  end
  if data[group]['moderators'][tostring(user_id)] then
    return send_large_msg(receiver, member_username..' از قبل مدیر گروه بوده است')
  end
  data[group]['moderators'][tostring(user_id)] = member_tag_username
  save_data(_config.moderation.data, data)
  send_large_msg(receiver, member_username..' به لیست مدیران گروه اضافه شد')
end

local function demote2(receiver, member_username, user_id)
  local data = load_data(_config.moderation.data)
  local member_tag_username = string.gsub(member_username, '@', '(at)')
  local group = string.gsub(receiver, 'channel#id', '')
  if not data[group] then
    return send_large_msg(receiver, 'گروه اضافه نشده است!')
  end
  if not data[group]['moderators'][tostring(user_id)] then
    return send_large_msg(receiver, member_tag_username..' مدیر گروه نیست')
  end
  data[group]['moderators'][tostring(user_id)] = nil
  save_data(_config.moderation.data, data)
  send_large_msg(receiver, member_username..' از لیست مدیران گروه پاک شد')
end

local function modlist(msg)
  local data = load_data(_config.moderation.data)
  local groups = "groups"
  if not data[tostring(groups)][tostring(msg.to.id)] then
    return 'سوپر گروه اضافه نشده است!'
  end
  -- determine if table is empty
  if next(data[tostring(msg.to.id)]['moderators']) == nil then
    return 'هیچ مدیری در گروه وجود ندارد'
  end
  local i = 1
  local message = 'لیست مدیران گروه ' .. string.gsub(msg.to.print_name, '_', ' ') .. ':\n\n'
  for k,v in pairs(data[tostring(msg.to.id)]['moderators']) do
  if string.match(v , "(at)") then v = v:gsub(".at.","@") end
    message = message ..i..' - '..v..' [' ..k.. '] \n' 
    i = i + 1
  end
  return message
end

--silent_user By @SoLiD021
function silentuser_by_reply(extra, success, result)
	 local user_id = result.from.peer_id
		local receiver = extra.receiver
		local chat_id = result.to.peer_id
		print(user_id)
		print(chat_id)
		if is_muted_user(chat_id, user_id) then
			return send_large_msg(receiver, " ["..user_id.."] از قبل به لیست Mute کاربران اضافه شده بود")
		end
   if is_owner(extra.msg) then
			mute_user(chat_id, user_id)
		return 	send_large_msg(receiver, " ["..user_id.."] به لیست Mute کاربران اضافه شد")
	end
end

local function silentuser_by_id(extra, success, result)
		local user_id = result.peer_id
		local receiver = extra.receiver
		local chat_id = string.gsub(receiver, 'channel#id', '')
		if is_muted_user(chat_id, user_id) then
			return send_large_msg(receiver, " ["..user_id.."] از قبل به لیست Mute کاربران اضافه شده بود")
		end
   if is_owner(extra.msg) then
			mute_user(chat_id, user_id)
		return 	send_large_msg(receiver, " ["..user_id.."] به لیست Mute کاربران اضافه شد")
	end
end

local function silentuser_by_username(extra, success, result)
		local user_id = result.peer_id
		local receiver = extra.receiver
		local chat_id = string.gsub(receiver, 'channel#id', '')
		if is_muted_user(chat_id, user_id) then
			return send_large_msg(receiver, " ["..user_id.."] از قبل به لیست Mute کاربران اضافه شده بود")
		end
   if is_owner(extra.msg) then
			mute_user(chat_id, user_id)
		return 	send_large_msg(receiver, " ["..user_id.."] به لیست Mute کاربران اضافه شد")
	end
end

--unsilent_user By @SoLiD021
function unsilentuser_by_reply(extra, success, result)
	 local user_id = result.from.peer_id
		local receiver = extra.receiver
		local chat_id = result.to.peer_id
		print(user_id)
		print(chat_id)
		if is_muted_user(chat_id, user_id) then
			unmute_user(chat_id, user_id)
			send_large_msg(receiver, "["..user_id.."] از لیست Mute کاربران حذف شد")
else
			send_large_msg(receiver, "["..user_id.."] از قبل در لیست Mute کاربران نبوده")
		end
	end

local function unsilentuser_by_id(extra, success, result)
		local user_id = result.peer_id
		local receiver = extra.receiver
		local chat_id = string.gsub(receiver, 'channel#id', '')
		if is_muted_user(chat_id, user_id) then
			unmute_user(chat_id, user_id)
			send_large_msg(receiver, "["..user_id.."] از لیست Mute کاربران حذف شد")
else
			send_large_msg(receiver, "["..user_id.."] از قبل در لیست Mute کاربران نبوده")
		end
	end

local function unsilentuser_by_username(extra, success, result)
		local user_id = result.peer_id
		local receiver = extra.receiver
		local chat_id = string.gsub(receiver, 'channel#id', '')
		if is_muted_user(chat_id, user_id) then
			unmute_user(chat_id, user_id)
			send_large_msg(receiver, "["..user_id.."] از لیست Mute کاربران حذف شد")
else
			send_large_msg(receiver, "["..user_id.."] از قبل در لیست Mute کاربران نبوده")
		end
	end

-- Start by reply actions
function get_message_callback(extra, success, result)
	local get_cmd = extra.get_cmd
	local msg = extra.msg
	local data = load_data(_config.moderation.data)
	local print_name = user_print_name(msg.from):gsub("‮", "")
	local name_log = print_name:gsub("_", " ")
    if get_cmd == "id" and not result.action then
		local channel = 'channel#id'..result.to.peer_id
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] obtained id for: ["..result.from.peer_id.."]") 
		id1 = send_large_msg(channel, result.from.peer_id)
	elseif get_cmd == 'id' and result.action then
		local action = result.action.type
		if action == 'chat_add_user' or action == 'chat_del_user' or action == 'chat_rename' or action == 'chat_change_photo' then
			if result.action.user then
				user_id = result.action.user.peer_id
			else
				user_id = result.peer_id
			end
			local channel = 'channel#id'..result.to.peer_id
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] obtained id by service msg for: ["..user_id.."]")
			id1 = send_large_msg(channel, user_id)
		end
    elseif get_cmd == "idfrom" then
		local channel = 'channel#id'..result.to.peer_id
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] obtained id for msg fwd from: ["..result.fwd_from.peer_id.."]")
		id2 = send_large_msg(channel, result.fwd_from.peer_id)
    elseif get_cmd == 'channel_block' and not result.action then
		local member_id = result.from.peer_id
		local channel_id = result.to.peer_id
    if member_id == msg.from.id then
      return send_large_msg("channel#id"..channel_id, "Leave using kickme command")
    end
    if is_momod2(member_id, channel_id) and not is_admin2(msg.from.id) then
			   return send_large_msg("channel#id"..channel_id, "You can't kick mods/owner/admins")
    end
    if is_admin2(member_id) then
         return send_large_msg("channel#id"..channel_id, "You can't kick other admins")
    end
		--savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: ["..user_id.."] by reply")
		kick_user(member_id, channel_id)
	elseif get_cmd == 'channel_block' and result.action and result.action.type == 'chat_add_user' then
		local user_id = result.action.user.peer_id
		local channel_id = result.to.peer_id
    if member_id == msg.from.id then
      return send_large_msg("channel#id"..channel_id, "Leave using kickme command") 
    end
    if is_momod2(member_id, channel_id) and not is_admin2(msg.from.id) then
			   return send_large_msg("channel#id"..channel_id, "شما نمی توانید ادمین/مدیران/صاحب گروه را اخراج کنید")
    end
    if is_admin2(member_id) then
         return send_large_msg("channel#id"..channel_id, "شما نمی توانید سایر ادمین ها را اخراج کنید")
    end
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: ["..user_id.."] by reply to sev. msg.")
		kick_user(user_id, channel_id)
	elseif get_cmd == "del" then
		delete_msg(result.id, ok_cb, false)
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] deleted a message by reply")
	elseif get_cmd == "setadmin" then
		local user_id = result.from.peer_id
		local channel_id = "channel#id"..result.to.peer_id
		channel_set_admin(channel_id, "user#id"..user_id, ok_cb, false)
		if result.from.username then
			text = "@"..result.from.username.." به لیست سرپرستان گروه اضافه شد"
		else
			text = "[ "..user_id.." ] به لیست سرپرستان گروه اضافه شد"
		end
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] set: ["..user_id.."] as admin by reply") 
		send_large_msg(channel_id, text)
	elseif get_cmd == "demoteadmin" then
		local user_id = result.from.peer_id
		local channel_id = "channel#id"..result.to.peer_id
		if is_admin2(result.from.peer_id) then
			return send_large_msg(channel_id, "شما ادمین کل را نمی توانید برکنار کنید")
		end
		channel_demote(channel_id, "user#id"..user_id, ok_cb, false)
		if result.from.username then
			text = "@"..result.from.username.." از لیست سرپرستان گروه حذف شد"
		else
			text = "[ "..user_id.." ] از لیست مدیران گروه پاک شد"
		end
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] demoted: ["..user_id.."] from admin by reply")
		send_large_msg(channel_id, text)
	elseif get_cmd == "setowner" then
		local group_owner = data[tostring(result.to.peer_id)]['set_owner']
		if group_owner then
		local channel_id = 'channel#id'..result.to.peer_id
			if not is_admin2(tonumber(group_owner)) and not is_support(tonumber(group_owner)) then
				local user = "user#id"..group_owner
				channel_demote(channel_id, user, ok_cb, false)
			end
			local user_id = "user#id"..result.from.peer_id
			channel_set_admin(channel_id, user_id, ok_cb, false)
			data[tostring(result.to.peer_id)]['set_owner'] = tostring(result.from.peer_id)
			save_data(_config.moderation.data, data)
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] set: ["..result.from.peer_id.."] as owner by reply")
			if result.from.username then
				text = "@"..result.from.username.." [ "..result.from.peer_id.." ] به صاحب گروه منتصب شد"
			else
				text = "[ "..result.from.peer_id.." ] به صاحب گروه منتصب شد"
			end
			send_large_msg(channel_id, text)
		end
	elseif get_cmd == "promote" then
		local receiver = result.to.peer_id
		local full_name = (result.from.first_name or '')..' '..(result.from.last_name or '')
		local member_name = full_name:gsub("‮", "")
		local member_username = member_name:gsub("_", " ")
		if result.from.username then
			member_username = '@'.. result.from.username
		end
		local member_id = result.from.peer_id
		if result.to.peer_type == 'channel' then
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] promoted mod: @"..member_username.."["..result.from.peer_id.."] by reply")
		promote2("channel#id"..result.to.peer_id, member_username, member_id)
	    --channel_set_mod(channel_id, user, ok_cb, false)
		end
	elseif get_cmd == "demote" then
		local receiver = result.to.peer_id
		local full_name = (result.from.first_name or '')..' '..(result.from.last_name or '')
		local member_name = full_name:gsub("‮", "")
		local member_username = member_name:gsub("_", " ")
		if result.from.username then
			member_username = '@'.. result.from.username
		end
		local member_id = result.from.peer_id
		if result.to.peer_type == 'channel' then
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] demoted mod: @"..member_username.."["..result.from.peer_id.."] by reply")
		demote2("channel#id"..result.to.peer_id, member_username, member_id)
	    --channel_set_mod(channel_id, user, ok_cb, false)
		end
	elseif get_cmd == 'mute_user' then
		if result.service then
			local action = result.action.type
			if action == 'chat_add_user' or action == 'chat_del_user' or action == 'chat_rename' or action == 'chat_change_photo' then
				if result.action.user then
					user_id = result.action.user.peer_id
				end
			end
			if action == 'chat_add_user_link' then
				if result.from then
					user_id = result.from.peer_id
				end
			end
		else
			user_id = result.from.peer_id
		end
		local receiver = extra.receiver
		local chat_id = msg.to.id
		print(user_id)
		print(chat_id)
		if is_muted_user(chat_id, user_id) then
			unmute_user(chat_id, user_id)
			send_large_msg(receiver, "["..user_id.."] از لیست Mute کاربران حذف شد")
		elseif is_admin1(msg) then
			mute_user(chat_id, user_id)
			send_large_msg(receiver, " ["..user_id.."] به لیست Mute کاربران اضافه شد")
		end
	end
end

--By ID actions
local function cb_user_info(extra, success, result)
	local receiver = extra.receiver
	local user_id = result.peer_id
	local get_cmd = extra.get_cmd
	local data = load_data(_config.moderation.data)
	--[[if get_cmd == "setadmin" then
		local user_id = "user#id"..result.peer_id
		channel_set_admin(receiver, user_id, ok_cb, false)
		if result.username then
			text = "@"..result.username.." has been set as an admin"
		else
			text = "[ "..result.peer_id.." ] has been set as an admin"
		end
			send_large_msg(receiver, text)]]
	if get_cmd == "demoteadmin" then
		if is_admin2(result.peer_id) then
			return send_large_msg(receiver, "شما ادمین کل را نمی توانید برکنار کنید")
		end
		local user_id = "user#id"..result.peer_id
		channel_demote(receiver, user_id, ok_cb, false)
		if result.username then
			text = "@"..result.username.." از لیست سرپرستان گروه حذف شد"
			send_large_msg(receiver, text)
		else
			text = "[ "..result.peer_id.." ] از لیست سرپرستان گروه حذف شد"
			send_large_msg(receiver, text)
		end
	elseif get_cmd == "promote" then
		if result.username then
			member_username = "@"..result.username
		else
			member_username = string.gsub(result.print_name, '_', ' ')
		end
		promote2(receiver, member_username, user_id)
	elseif get_cmd == "demote" then
		if result.username then
			member_username = "@"..result.username
		else
			member_username = string.gsub(result.print_name, '_', ' ')
		end
		demote2(receiver, member_username, user_id)
	end
end

-- Begin resolve username actions
local function callbackres(extra, success, result)
  local member_id = result.peer_id
  local member_username = "@"..result.username
  local get_cmd = extra.get_cmd
	if get_cmd == "res" then
		local user = result.peer_id
		local name = string.gsub(result.print_name, "_", " ")
		local channel = 'channel#id'..extra.channelid
		send_large_msg(channel, user..'\n'..name)
		return user
	elseif get_cmd == "id" then
		local user = result.peer_id
		local channel = 'channel#id'..extra.channelid
		send_large_msg(channel, user)
		return user
  elseif get_cmd == "invite" then
    local receiver = extra.channel
    local user_id = "user#id"..result.peer_id
    channel_invite(receiver, user_id, ok_cb, false)
	--[[elseif get_cmd == "channel_block" then
		local user_id = result.peer_id
		local channel_id = extra.channelid
    local sender = extra.sender
    if member_id == sender then
      return send_large_msg("channel#id"..channel_id, "Leave using kickme command")
    end
		if is_momod2(member_id, channel_id) and not is_admin2(sender) then
			   return send_large_msg("channel#id"..channel_id, "You can't kick mods/owner/admins")
    end
    if is_admin2(member_id) then
         return send_large_msg("channel#id"..channel_id, "You can't kick other admins")
    end
		kick_user(user_id, channel_id)
	elseif get_cmd == "setadmin" then
		local user_id = "user#id"..result.peer_id
		local channel_id = extra.channel
		channel_set_admin(channel_id, user_id, ok_cb, false)
		if result.username then
			text = "@"..result.username.." has been set as an admin"
			send_large_msg(channel_id, text)
		else
			text = "@"..result.peer_id.." has been set as an admin"
			send_large_msg(channel_id, text)
		end
	elseif get_cmd == "setowner" then
		local receiver = extra.channel
		local channel = string.gsub(receiver, 'channel#id', '')
		local from_id = extra.from_id
		local group_owner = data[tostring(channel)]['set_owner']
		if group_owner then
			local user = "user#id"..group_owner
			if not is_admin2(group_owner) and not is_support(group_owner) then
				channel_demote(receiver, user, ok_cb, false)
			end
			local user_id = "user#id"..result.peer_id
			channel_set_admin(receiver, user_id, ok_cb, false)
			data[tostring(channel)]['set_owner'] = tostring(result.peer_id)
			save_data(_config.moderation.data, data)
			savelog(channel, name_log.." ["..from_id.."] set ["..result.peer_id.."] as owner by username")
		if result.username then
			text = member_username.." [ "..result.peer_id.." ] added as owner"
		else
			text = "[ "..result.peer_id.." ] added as owner"
		end
		send_large_msg(receiver, text)
  end]]
	elseif get_cmd == "promote" then
		local receiver = extra.channel
		local user_id = result.peer_id
		--local user = "user#id"..result.peer_id
		promote2(receiver, member_username, user_id)
		--channel_set_mod(receiver, user, ok_cb, false)
	elseif get_cmd == "demote" then
		local receiver = extra.channel
		local user_id = result.peer_id
		local user = "user#id"..result.peer_id
		demote2(receiver, member_username, user_id)
	elseif get_cmd == "demoteadmin" then
		local user_id = "user#id"..result.peer_id
		local channel_id = extra.channel
		if is_admin2(result.peer_id) then
			return send_large_msg(channel_id, "شما ادمین کل را نمی توانید برکنار کنید")
		end
		channel_demote(channel_id, user_id, ok_cb, false)
		if result.username then
			text = "@"..result.username.." از لیست سرپرستان گروه حذف شد"
			send_large_msg(channel_id, text)
		else
			text = "@"..result.peer_id.." از لیست سرپرستان گروه حذف شد"
			send_large_msg(channel_id, text)
		end
		local receiver = extra.channel
		local user_id = result.peer_id
		demote_admin(receiver, member_username, user_id)
	elseif get_cmd == 'mute_user' then
		local user_id = result.peer_id
		local receiver = extra.receiver
		local chat_id = string.gsub(receiver, 'channel#id', '')
		if is_muted_user(chat_id, user_id) then
			unmute_user(chat_id, user_id)
			send_large_msg(receiver, " ["..user_id.."] از لیست Mute کاربران پاک شد")
		elseif is_owner(extra.msg) then
			mute_user(chat_id, user_id)
			send_large_msg(receiver, " ["..user_id.."] به لیست Mute کاربران اضافه شد")
		end
	end
end
--End resolve username actions

--Begin non-channel_invite username actions
local function in_channel_cb(cb_extra, success, result)
  local get_cmd = cb_extra.get_cmd
  local receiver = cb_extra.receiver
  local msg = cb_extra.msg
  local data = load_data(_config.moderation.data)
  local print_name = user_print_name(cb_extra.msg.from):gsub("‮", "")
  local name_log = print_name:gsub("_", " ")
  local member = cb_extra.username
  local memberid = cb_extra.user_id
  if member then
    text = 'No user @'..member..' in this SuperGroup.'
  else
    text = 'No user ['..memberid..'] in this SuperGroup.' 
  end
if get_cmd == "channel_block" then
  for k,v in pairs(result) do
    vusername = v.username
    vpeer_id = tostring(v.peer_id)
    if vusername == member or vpeer_id == memberid then
     local user_id = v.peer_id
     local channel_id = cb_extra.msg.to.id
     local sender = cb_extra.msg.from.id
      if user_id == sender then
        return send_large_msg("channel#id"..channel_id, "Leave using kickme command")
      end
      if is_momod2(user_id, channel_id) and not is_admin2(sender) then
        return send_large_msg("channel#id"..channel_id, "You can't kick mods/owner/admins") 
      end
      if is_admin2(user_id) then
        return send_large_msg("channel#id"..channel_id, "You can't kick other admins")
      end
      if v.username then
        text = ""
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: @"..v.username.." ["..v.peer_id.."]") 
      else
        text = ""
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: ["..v.peer_id.."]")
      end
      kick_user(user_id, channel_id)
    end
  end
elseif get_cmd == "setadmin" then
   for k,v in pairs(result) do
    vusername = v.username
    vpeer_id = tostring(v.peer_id)
    if vusername == member or vpeer_id == memberid then
      local user_id = "user#id"..v.peer_id
      local channel_id = "channel#id"..cb_extra.msg.to.id
      channel_set_admin(channel_id, user_id, ok_cb, false)
      if v.username then
        text = "@"..v.username.." ["..v.peer_id.."] به لیست سرپرستان گروه اضافه شد"
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] set admin @"..v.username.." ["..v.peer_id.."]")
      else
        text = "["..v.peer_id.."] به لیست سرپرستان گروه اضافه شد"
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] set admin "..v.peer_id)
      end
	  if v.username then
		member_username = "@"..v.username
	  else
		member_username = string.gsub(v.print_name, '_', ' ')
	  end
		local receiver = channel_id
		local user_id = v.peer_id
		promote_admin(receiver, member_username, user_id)
    end
    send_large_msg(channel_id, text)
 end
 elseif get_cmd == 'setowner' then
	for k,v in pairs(result) do
		vusername = v.username
		vpeer_id = tostring(v.peer_id)
		if vusername == member or vpeer_id == memberid then
			local channel = string.gsub(receiver, 'channel#id', '')
			local from_id = cb_extra.msg.from.id
			local group_owner = data[tostring(channel)]['set_owner']
			if group_owner then
				if not is_admin2(tonumber(group_owner)) and not is_support(tonumber(group_owner)) then
					local user = "user#id"..group_owner
					channel_demote(receiver, user, ok_cb, false)
				end
					local user_id = "user#id"..v.peer_id
					channel_set_admin(receiver, user_id, ok_cb, false)
					data[tostring(channel)]['set_owner'] = tostring(v.peer_id)
					save_data(_config.moderation.data, data)
					savelog(channel, name_log.."["..from_id.."] set ["..v.peer_id.."] as owner by username")
				if result.username then
					text = member_username.." ["..v.peer_id.."] به صاحب گروه منتصب شد"
				else
					text = "به صاحب گروه منتصب شد ["..v.peer_id.."]"
				end
			end
		elseif memberid and vusername ~= member and vpeer_id ~= memberid then
			local channel = string.gsub(receiver, 'channel#id', '')
			local from_id = cb_extra.msg.from.id
			local group_owner = data[tostring(channel)]['set_owner']
			if group_owner then
				if not is_admin2(tonumber(group_owner)) and not is_support(tonumber(group_owner)) then
					local user = "user#id"..group_owner
					channel_demote(receiver, user, ok_cb, false)
				end
				data[tostring(channel)]['set_owner'] = tostring(memberid)
				save_data(_config.moderation.data, data)
				savelog(channel, name_log.."["..from_id.."] set ["..memberid.."] as owner by username")
				text = "["..memberid.."] به صاحب گروه منتصب شد"
			end
		end
	end
 end
send_large_msg(receiver, text)
end
--End non-channel_invite username actions
function muted_user_list2(chat_id)
	local hash =  'mute_user:'..chat_id
	local list = redis:smembers(hash)
	local text = "لیست کاربران Mute شده ["..chat_id.."]:\n\n"
	for k,v in pairsByKeys(list) do
  		local user_info = redis:hgetall('user:'..v)
		if user_info and user_info.print_name then
			local print_name = string.gsub(user_info.print_name, "_", " ")
			local print_name = string.gsub(print_name, "‮", "")
			text = text..k.." - "..print_name.." ["..v.."]\n"
		else
		text = text..k.." - [ "..v.." ]\n"
	        end
        end
  return text
end
--'Set supergroup photo' function
local function set_supergroup_photo(msg, success, result)
  local data = load_data(_config.moderation.data)
  local receiver = get_receiver(msg)
  if success then
    local file = 'data/photos/channel_photo_'..msg.to.id..'.jpg' 
    print('File downloaded to:', result)
    os.rename(result, file)
    print('File moved to:', file)
    channel_set_photo(receiver, file, ok_cb, false)
    data[tostring(msg.to.id)]['settings']['set_photo'] = file
    save_data(_config.moderation.data, data)
    send_large_msg(receiver, 'عکس جدید با موفقیت ذخیره شد', ok_cb, false)
  else
    print('Error downloading: '..msg.id)
    send_large_msg(receiver, 'عملیات ناموفق، مجددا تلاش کنید!', ok_cb, false) 
  end
end

--Run function
local function run(msg, matches)
	if msg.to.type == 'chat' then
		if matches[1]:lower() == 'tosuper' then 
			if not is_admin1(msg) then
				return
			end
			local receiver = get_receiver(msg)
			chat_upgrade(receiver, ok_cb, false)
		end
	elseif msg.to.type == 'channel'then
		if matches[1]:lower() == 'tosuper' then
			if not is_admin1(msg) then
				return
			end
			return "از قبل سوپر گروه بوده است"
		end
	end
	if msg.to.type == 'channel' then
	local support_id = msg.from.id
	local receiver = get_receiver(msg)
	local print_name = user_print_name(msg.from):gsub("‮", "")
	local name_log = print_name:gsub("_", " ")
	local data = load_data(_config.moderation.data)
		if matches[1]:lower() == 'add' and not matches[2] then
			if not is_admin1(msg) and not is_support(support_id) then
				return
			end
			if is_super_group(msg) then
				return reply_msg(msg.id, 'سوپر گروه از قبل اضافه شده است!', ok_cb, false)
			end
			print("SuperGroup "..msg.to.print_name.."("..msg.to.id..") added")
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] added SuperGroup")
			superadd(msg)
			set_mutes(msg.to.id)
			channel_set_admin(receiver, 'user#id'..msg.from.id, ok_cb, false)
		end

		if matches[1]:lower() == 'rem' and is_admin1(msg) and not matches[2] then
			if not is_super_group(msg) then
				return reply_msg(msg.id, 'سوپر گروه اضافه نشده است!', ok_cb, false)
			end
			print("SuperGroup "..msg.to.print_name.."("..msg.to.id..") removed")
			superrem(msg)
			rem_mutes(msg.to.id)
		end

		if matches[1]:lower() == "gpinfo" then 
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup info")
			channel_info(receiver, callback_info, {receiver = receiver, msg = msg})
		end

		if matches[1]:lower() == "admins" then
			--if not is_owner(msg) and not is_support(msg.from.id) then
			--	return
			--end
			member_type = 'Admins'
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup Admins list")
			admins = channel_get_admins(receiver,callback, {receiver = receiver, msg = msg, member_type = member_type})
		end

		if matches[1]:lower() == "owner" then
			local group_owner = data[tostring(msg.to.id)]['set_owner']
			if not group_owner then
				return "این گروه صاحبی ندارد.\nلطفا با نوشتن دستور زیر به گروه پشتیبانی ربات بیاید و اطلاع دهید\n/linksp"
			end
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] used /owner")
			return "صاحب گروه می باشد ["..group_owner..']'
		end

		if matches[1]:lower() == "modlist" then
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested group modlist")
			return modlist(msg)
			-- channel_get_admins(receiver,callback, {receiver = receiver})
		end

		if matches[1]:lower() == "bots" and is_momod(msg) then 
			member_type = 'Bots'
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup bots list")
			channel_get_bots(receiver, callback, {receiver = receiver, msg = msg, member_type = member_type})
		end

		if matches[1]:lower() == "who" and not matches[2] and is_momod(msg) then
			local user_id = msg.from.peer_id
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup users list")
			channel_get_users(receiver, callback_who, {receiver = receiver})
		end

		if matches[1]:lower() == "kicked" and is_momod(msg) then
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested Kicked users list")
			channel_get_kicked(receiver, callback_kicked, {receiver = receiver})
		end

		if matches[1]:lower() == 'del' and is_momod(msg) then
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'del',
					msg = msg
				}
				delete_msg(msg.id, ok_cb, false)
				get_message(msg.reply_id, get_message_callback, cbreply_extra)
			end
		end

		if matches[1]:lower() == 'block' and is_momod(msg) then 
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'channel_block',
					msg = msg
				}
				get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1]:lower() == 'block' and string.match(matches[2], '^%d+$') then
				--[[local user_id = matches[2]
				local channel_id = msg.to.id
				if is_momod2(user_id, channel_id) and not is_admin2(user_id) then
					return send_large_msg(receiver, "You can't kick mods/owner/admins")
				end
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: [ user#id"..user_id.." ]")
				kick_user(user_id, channel_id)]]
				local	get_cmd = 'channel_block'
				local	msg = msg
				local user_id = matches[2]
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, user_id=user_id})
			elseif msg.text:match("@[%a%d]") then
			--[[local cbres_extra = {
					channelid = msg.to.id,
					get_cmd = 'channel_block',
					sender = msg.from.id
				}
			    local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: @"..username)
				resolve_username(username, callbackres, cbres_extra)]]
			local get_cmd = 'channel_block'
			local msg = msg
			local username = matches[2]
			local username = string.gsub(matches[2], '@', '')
			channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, username=username})
			end
		end

		if matches[1]:lower() == 'id' then
			if type(msg.reply_id) ~= "nil" and is_momod(msg) and not matches[2] then
				local cbreply_extra = {
					get_cmd = 'id',
					msg = msg
				}
				get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif type(msg.reply_id) ~= "nil" and matches[2] == "from" and is_momod(msg) then
				local cbreply_extra = {
					get_cmd = 'idfrom',
					msg = msg
				}
				get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif msg.text:match("@[%a%d]") then
				local cbres_extra = {
					channelid = msg.to.id,
					get_cmd = 'id'
				}
				local username = matches[2]
				local username = username:gsub("@","")
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested ID for: @"..username)
				resolve_username(username,  callbackres, cbres_extra)
			else
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup ID")
				return "آی دی (ID) سوپر گروه " ..string.gsub(msg.to.print_name, "_", " ").. ":\n\n"..msg.to.id
			end
		end

		if matches[1]:lower() == '' then
			if msg.to.type == 'channel' then
            return 'این دستور در سوپر گروه غیرفعال است'
			end
		end

		if matches[1]:lower() == 'newlink' and is_momod(msg)then
			local function callback_link (extra , success, result)
			local receiver = get_receiver(msg)
				if success == 0 then
					send_large_msg(receiver, '*خطا: دریافت لینک گروه ناموفق*\nدلیل: ربات سازنده گروه نمی باشد.\nاز دستور setlink/ برای ثبت لینک استفاده کنید')
					data[tostring(msg.to.id)]['settings']['set_link'] = nil
					save_data(_config.moderation.data, data)
				else
					send_large_msg(receiver, "لینک جدید ساخته شد\n\nبرای نمایش لینک جدید، دستور زیر را تایپ کنی\n/link")
					data[tostring(msg.to.id)]['settings']['set_link'] = result
					save_data(_config.moderation.data, data)
				end
			end
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] attempted to create a new SuperGroup link")
			export_channel_link(receiver, callback_link, false)
		end

		if matches[1]:lower() == 'setlink' and is_owner(msg) then
			data[tostring(msg.to.id)]['settings']['set_link'] = 'waiting'
			save_data(_config.moderation.data, data)
			return 'لطفا لینک جدید را ارسال کنید'
		end

		if msg.text then
			if msg.text:match("^(https://telegram.me/joinchat/%S+)$") and data[tostring(msg.to.id)]['settings']['set_link'] == 'waiting' and is_owner(msg) then
				data[tostring(msg.to.id)]['settings']['set_link'] = msg.text
				save_data(_config.moderation.data, data)
				return "لینک ست شد"
			end
		end 

		if matches[1]:lower() == 'link' then
			if not is_momod(msg) then
				return
			end
			local group_link = data[tostring(msg.to.id)]['settings']['set_link']
			if not group_link then
				return "برای اولین بار ابتدا باید newlink/ را تایپ کنید"
			end
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested group link ["..group_link.."]")
			local text = "لینک ورود به سوپر گروه :\n["..msg.to.title.."]("..group_link..")"
send_api_msg(msg,get_receiver_api(msg),text,true,'md',msg.to.title,group_link)
end

		if matches[1]:lower() == 'gplink' then
			if not is_momod(msg) then
				return
			end
			local group_link = data[tostring(msg.to.id)]['settings']['set_link']
			if not group_link then
				return "برای اولین بار ابتدا باید newlink/ را تایپ کنید"
			end
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested group link ["..group_link.."]")
			return "لینک سوپر گروه:\n"..group_link
		end

		if matches[1]:lower() == "invite" and is_sudo(msg) then
			local cbres_extra = {
				channel = get_receiver(msg),
				get_cmd = "invite"
			}
			local username = matches[2]
			local username = username:gsub("@","")
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] invited @"..username)
			resolve_username(username,  callbackres, cbres_extra)
		end

		if matches[1]:lower() == 'res' and is_momod(msg) then 
			local cbres_extra = {
				channelid = msg.to.id,
				get_cmd = 'res'
			}
			local username = matches[2]
			local username = username:gsub("@","")
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] resolved username: @"..username) 
			resolve_username(username,  callbackres, cbres_extra)
		end

		if matches[1]:lower() == 'kick' and is_momod(msg) then
			local receiver = channel..matches[3]
			local user = "user#id"..matches[2]
			chaannel_kick(receiver, user, ok_cb, false)
		end

			if matches[1]:lower() == 'setadmin' then
				if not is_support(msg.from.id) and not is_owner(msg) then
					return
				end
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'setadmin',
					msg = msg
				}
				setadmin = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1]:lower() == 'setadmin' and string.match(matches[2], '^%d+$') then
			--[[]	local receiver = get_receiver(msg)
				local user_id = "user#id"..matches[2]
				local get_cmd = 'setadmin'
				user_info(user_id, cb_user_info, {receiver = receiver, get_cmd = get_cmd})]]
				local	get_cmd = 'setadmin'
				local	msg = msg
				local user_id = matches[2]
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, user_id=user_id})
			elseif matches[1]:lower() == 'setadmin' and not string.match(matches[2], '^%d+$') then
				--[[local cbres_extra = {
					channel = get_receiver(msg),
					get_cmd = 'setadmin'
				}
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] set admin @"..username)
				resolve_username(username, callbackres, cbres_extra)]]
				local	get_cmd = 'setadmin'
				local	msg = msg
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, username=username})
			end
		end

		if matches[1]:lower() == 'demoteadmin' then
			if not is_support(msg.from.id) and not is_owner(msg) then
				return
			end
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'demoteadmin',
					msg = msg
				}
				demoteadmin = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1]:lower() == 'demoteadmin' and string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local user_id = "user#id"..matches[2]
				local get_cmd = 'demoteadmin'
				user_info(user_id, cb_user_info, {receiver = receiver, get_cmd = get_cmd})
			elseif matches[1]:lower() == 'demoteadmin' and not string.match(matches[2], '^%d+$') then
				local cbres_extra = {
					channel = get_receiver(msg),
					get_cmd = 'demoteadmin'
				}
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] demoted admin @"..username)
				resolve_username(username, callbackres, cbres_extra)
			end
		end

		if matches[1]:lower() == 'setowner' and is_owner(msg) then
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'setowner',
					msg = msg
				}
				setowner = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1]:lower() == 'setowner' and string.match(matches[2], '^%d+$') then
		--[[	local group_owner = data[tostring(msg.to.id)]['set_owner']
				if group_owner then
					local receiver = get_receiver(msg)
					local user_id = "user#id"..group_owner
					if not is_admin2(group_owner) and not is_support(group_owner) then
						channel_demote(receiver, user_id, ok_cb, false)
					end
					local user = "user#id"..matches[2]
					channel_set_admin(receiver, user, ok_cb, false)
					data[tostring(msg.to.id)]['set_owner'] = tostring(matches[2])
					save_data(_config.moderation.data, data)
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set ["..matches[2].."] as owner")
					local text = "[ "..matches[2].." ] added as owner"
					return text
				end]]
				local	get_cmd = 'setowner'
				local	msg = msg
				local user_id = matches[2]
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, user_id=user_id})
			elseif matches[1]:lower() == 'setowner' and not string.match(matches[2], '^%d+$') then
				local	get_cmd = 'setowner'
				local	msg = msg
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, username=username})
			end
		end

		if matches[1]:lower() == 'promote' then
		  if not is_momod(msg) then
				return
			end
			if not is_owner(msg) then
				return "فقط صاحب گروه توانایی اضافه کردن مدیر را دارد"
			end
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'promote',
					msg = msg
				}
				promote = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'promote' and string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local user_id = "user#id"..matches[2]
				local get_cmd = 'promote'
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] promoted user#id"..matches[2])
				user_info(user_id, cb_user_info, {receiver = receiver, get_cmd = get_cmd})
			elseif matches[1]:lower() == 'promote' and not string.match(matches[2], '^%d+$') then
				local cbres_extra = {
					channel = get_receiver(msg),
					get_cmd = 'promote',
				}
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] promoted @"..username) 
				return resolve_username(username, callbackres, cbres_extra)
			end
		end

		if matches[1]:lower() == 'setmod' and is_sudo(msg) then
			channel = get_receiver(msg)
			user_id = 'user#id'..matches[2]
			channel_set_mod(channel, user_id, ok_cb, false)
			return "به ادمین گروه منتصب شد"
		end
		if matches[1]:lower() == 'remmod' and is_sudo(msg) then
			channel = get_receiver(msg)
			user_id = 'user#id'..matches[2]
			channel_demote(channel, user_id, ok_cb, false)
			return "از ادمین گروه برداشته شد"
		end

		if matches[1]:lower() == 'demote' then
			if not is_momod(msg) then
				return
			end
			if not is_owner(msg) then
				return "فقط صاحب گروه قادر به حذف کردن مدیر می باشد"
			end
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'demote',
					msg = msg
				}
				demote = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1]:lower() == 'demote' and string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local user_id = "user#id"..matches[2]
				local get_cmd = 'demote'
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] demoted user#id"..matches[2])
				user_info(user_id, cb_user_info, {receiver = receiver, get_cmd = get_cmd})
			elseif not string.match(matches[2], '^%d+$') then
				local cbres_extra = {
					channel = get_receiver(msg),
					get_cmd = 'demote'
				}
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] demoted @"..username)
				return resolve_username(username, callbackres, cbres_extra)
			end
		end

		if matches[1]:lower() == "setname" and is_momod(msg) then
			local receiver = get_receiver(msg)
			local set_name = string.gsub(matches[2], '_', '')
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] renamed SuperGroup to: "..matches[2])
			rename_channel(receiver, set_name, ok_cb, false)
		end

		if msg.service and msg.action.type == 'chat_rename' then
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] renamed SuperGroup to: "..msg.to.title)
			data[tostring(msg.to.id)]['settings']['set_name'] = msg.to.title
			save_data(_config.moderation.data, data)
		end

		if matches[1]:lower() == "setdesc" and is_momod(msg) then
			local receiver = get_receiver(msg)
			local about_text = matches[2]
			local data_cat = 'description'
			local target = msg.to.id
			data[tostring(target)][data_cat] = about_text
			save_data(_config.moderation.data, data)
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup description to: "..about_text)
			channel_set_about(receiver, about_text, ok_cb, false)
			return "موضوع گروه عوض شد\n\nبرای دیدن تغییرات، Description گروه را مشاهده کنید"
		end

		
		
		if matches[1]:lower() == "setusername" and is_admin1(msg) then
			local function ok_username_cb (extra, success, result)
				local receiver = extra.receiver
				if success == 1 then
					send_large_msg(receiver, "SuperGroup username Set.\n\nSelect the chat again to see the changes.") 
				elseif success == 0 then
					send_large_msg(receiver, "Failed to set SuperGroup username.\nUsername may already be taken.\n\nNote: Username can use a-z, 0-9 and underscores.\nMinimum length is 5 characters.")
				end
			end
			local username = string.gsub(matches[2], '@', '')
			channel_set_username(receiver, username, ok_username_cb, {receiver=receiver})
		end
     if matches[1]:lower() == 'uexpiretime' and not matches[3] then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] has changed group expire time to [unlimited]")
        expired = 'Unlimited'
        local target = get_receiver(msg)
	local hash = 'expiretime:'..target
    redis:hset(hash, expired)
        return 'تاریخ انقضای گروه به '..expired..' تغییر یافت'
    end
	if matches[1]:lower() == 'expiretime' then
	  if tonumber(matches[2]) < 95 or tonumber(matches[2]) > 96 then
        return "اولین match باید بین 95 تا 96 باشد"
      end
	  if tonumber(matches[3]) < 01 or tonumber(matches[3]) > 12 then
        return "دومین match باید بین 01 تا 12 باشد"
      end
	  if tonumber(matches[4]) < 01 or tonumber(matches[4]) > 31 then
        return "سومین match باید بین 01 تا 31 باشد"
      end
	  
        expired = matches[2]..'.'..matches[3]..'.'..matches[4]
        local target = get_receiver(msg)
	local hash = 'expiretime:'..target
    redis:set(hash, expired)
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] has changed group expire time to ["..matches[2]/matches[3]/matches[4].."]")
        return 'تاریخ انقضای گروه به '..expired..' تغییر یافت'
    end
		if matches[1]:lower() == 'setrules' and is_momod(msg) then
			rules = matches[2]
			local target = msg.to.id
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] has changed group rules to ["..matches[2].."]")
			return set_rulesmod(msg, data, target)
		end
		if matches[1] == 'setwlc' and is_momod(msg) then
			rules = matches[2]
			local target = msg.to.id
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] has changed group welcome to ["..matches[2].."]")
			return set_welcomemod(msg, data, target)
		end
		if msg.media then
			if msg.media.type == 'photo' and data[tostring(msg.to.id)]['settings']['set_photo'] == 'waiting' and is_momod(msg) then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] set new SuperGroup photo")
				load_photo(msg.id, set_supergroup_photo, msg)
				return
			end
		end
		if matches[1]:lower() == 'setphoto' and is_momod(msg) then
			data[tostring(msg.to.id)]['settings']['set_photo'] = 'waiting'
			save_data(_config.moderation.data, data)
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] started setting new SuperGroup photo")
			return 'برای تغییر عکس گروه ،یک عکس بفرستید'
		end

		if matches[1]:lower() == 'clean' then
			if not is_momod(msg) then
				return
			end
			if not is_momod(msg) then
				return "فقط مدیر قادر به حذف تمامی مدیران می باشد"
			end
			if matches[2] == 'modlist' then
				if next(data[tostring(msg.to.id)]['moderators']) == nil then
					return 'هیچ مدیری در این گروه وجود ندارد'
				end
				for k,v in pairs(data[tostring(msg.to.id)]['moderators']) do
					data[tostring(msg.to.id)]['moderators'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] cleaned modlist")
				return 'تمامی مدیران از لیست مدیریت پاک شدند'
			end
			if matches[2] == 'rules' then
				local data_cat = 'rules'
				if data[tostring(msg.to.id)][data_cat] == nil then
					return "قانون یا قوانینی ثبت نشده است"
				end
				data[tostring(msg.to.id)][data_cat] = nil
				save_data(_config.moderation.data, data)
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] cleaned rules")
				return 'قوانین گروه پاک شد'
			end
                        if matches[2]:lower() == 'welcome' then
	                        local hash = 'usecommands:'..msg.from.id..':'..msg.to.id
                                redis:incr(hash)
                                rules = matches[3]
                                local target = msg.to.id
                                savelog(msg.to.id, name_log.." ["..msg.from.id.."] has changed group welcome message to ["..matches[3].."]")
                                return set_welcomemod(msg, data, target)
                        end
			if matches[2] == 'desc' then 
				local receiver = get_receiver(msg)
				local about_text = ' '
				local data_cat = 'description'
				if data[tostring(msg.to.id)][data_cat] == nil then
					return 'موضوعی برای گروه ثبت نشده است'
				end
				data[tostring(msg.to.id)][data_cat] = nil
				save_data(_config.moderation.data, data)
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] cleaned about")
				channel_set_about(receiver, about_text, ok_cb, false)
				return "موضوع گروه پاک شد"
			end
if matches[2] == 'banlist' then
local chat_id = msg.to.id
local hash = 'banned:'..chat_id
send_large_msg(get_receiver(msg), "لیست بن پاک شد.")
redis:del(hash)
end
			if matches[2] == 'silentlist' then
				chat_id = msg.to.id
				local hash =  'mute_user:'..chat_id
					redis:del(hash)
				return "لیست تمامی کاربران Mute شده پاک شد"
			end
			if matches[2] == 'username' and is_admin1(msg) then
				local function ok_username_cb (extra, success, result)
					local receiver = extra.receiver
					if success == 1 then
						send_large_msg(receiver, "SuperGroup username cleaned.")
					elseif success == 0 then
						send_large_msg(receiver, "Failed to clean SuperGroup username.")
					end
				end
				local username = ""
				channel_set_username(receiver, username, ok_username_cb, {receiver=receiver})
			end
			if matches[2] == "bots" and is_momod(msg) then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked all SuperGroup bots")
				channel_get_bots(receiver, callback_clean_bots, {msg = msg})
			end
		end

		if matches[1]:lower() == 'lock' and is_momod(msg) then
			local target = msg.to.id
			if matches[2] == 'link' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked link posting ")
				return lock_group_links(msg, data, target)
			end
			if matches[2] == 'cmd' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked bot commands ")
				return lock_group_cmd(msg, data, target)
			end
			if matches[2] == 'url' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked url posting ")
				return lock_group_url(msg, data, target)
			end
			if matches[2] == 'spam' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked spam ") 
				return lock_group_spam(msg, data, target)
			end
			if matches[2] == 'flood' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked flood ")
				return lock_group_flood(msg, data, target)
			end

			--[[if matches[2] == 'arabic' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked arabic ")
				return lock_group_arabic(msg, data, target)
			end]]
			if matches[2] == 'member' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked member ")
				return lock_group_membermod(msg, data, target)
			end
			if matches[2] == 'bots' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked bots ")
				return lock_group_bots(msg, data, target)
			end
			if matches[2] == 'tag' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked tags ")
				return lock_group_tag(msg, data, target)
			end
			--[[if matches[2]:lower() == 'rtl' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked rtl chars. in names")
				return lock_group_rtl(msg, data, target)
			end]]

			if matches[2] == 'strict' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked enabled strict settings")
				return enable_strict_rules(msg, data, target)
			end
		end

		if matches[1]:lower() == 'unlock' and is_momod(msg) then
			local target = msg.to.id
			if matches[2] == 'link' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked link posting")
				return unlock_group_links(msg, data, target)
			end
			if matches[2] == 'cmd' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked bot commands")
				return unlock_group_cmd(msg, data, target)
			end
			if matches[2] == 'url' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked url posting")
				return unlock_group_url(msg, data, target)
			end
			if matches[2] == 'spam' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked spam")
				return unlock_group_spam(msg, data, target)
			end
			if matches[2] == 'flood' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked flood") 
				return unlock_group_flood(msg, data, target)
			end
			--[[if matches[2] == 'arabic' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked Arabic")
				return unlock_group_arabic(msg, data, target)
			end]]
			if matches[2] == 'member' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked member ") 
				return unlock_group_membermod(msg, data, target)
			end
			if matches[2] == 'bots' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked bots ") 
				return unlock_group_bots(msg, data, target)
			end
			if matches[2] == 'tag' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked tags ") 
				return unlock_group_tag(msg, data, target)
			end
			--[[if matches[2]:lower() == 'rtl' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked RTL chars. in names") 
				return unlock_group_rtl(msg, data, target)
			end]]

			if matches[2] == 'strict' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked disabled strict settings")
				return disable_strict_rules(msg, data, target)
			end
		end

		if matches[1]:lower() == 'setflood' then
			if not is_momod(msg) then
				return
			end
			if tonumber(matches[2]) < 5 or tonumber(matches[2]) > 20 then
				return "عدد اشتباه، باید بین [5 تا 20] باشد"
			end
			local flood_max = matches[2]
			data[tostring(msg.to.id)]['settings']['flood_msg_max'] = flood_max
			save_data(_config.moderation.data, data)
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] set flood to ["..matches[2].."]")
			return 'تعداد اسپم روی '..matches[2]..' ست شد'
		end
		if matches[1]:lower() == 'public' and is_momod(msg) then
			local target = msg.to.id
			if matches[2] == 'yes' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] set group to: public")
				return set_public_membermod(msg, data, target)
			end 
			if matches[2] == 'no' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: not public")
				return unset_public_membermod(msg, data, target)
			end
		end


		if matches[1]:lower() == 'mute' then
  if not is_momod(msg) then
    return
  end
			local chat_id = msg.to.id
			local target = msg.to.id
			if matches[2] == 'audio' then
			local msg_type = 'Audio'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					data[tostring(msg.to.id)]['settings']['mute_audio'] = 'yes'
                    save_data(_config.moderation.data, data)
					return "فیلتر فایل های صوتی فعال شد"
				else
					return "فیلتر فایل های صوتی از قبل فعال بوده است"
				end
			end
			if matches[2] == 'forward' then
			local msg_type = 'Forward'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					data[tostring(msg.to.id)]['settings']['mute_forward'] = 'yes'
                    save_data(_config.moderation.data, data)
					return "فیلتر فروارد فعال شد"
				else
					return "فیلتر فروارد از قبل فعال بوده است"
				end
			end
			if matches[2] == 'reply' then
			local msg_type = 'Reply'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					data[tostring(msg.to.id)]['settings']['mute_reply'] = 'yes'
                    save_data(_config.moderation.data, data)
					return "فیلتر ریپلی فعال شد"
				else
					return "فیلتر ریپلی از قبل فعال بوده است"
				end
			end
			if matches[2] == 'emoji' then
			local msg_type = 'Emoji'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					data[tostring(msg.to.id)]['settings']['mute_emoji'] = 'yes'
                    save_data(_config.moderation.data, data)
					return "فیلتر ایموجی فعال شد"
				else
					return "فیلتر ایموجی از قبل فعال بوده است"
				end
			end
			if matches[2] == 'sticker' or matches[2] == 'stickers' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] mute sticker posting")
				return lock_group_sticker(msg, data, target)
			end
			if matches[2] == 'contact' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] mute contact posting")
				return lock_group_contacts(msg, data, target)
			end
		    if matches[2] == 'porn' then
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] mute porn ")
			return lock_group_porn(msg, data, target)
		    end
			if matches[2] == 'service' then
			local msg_type = 'service'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type) 
					mute(chat_id, msg_type)
					data[tostring(msg.to.id)]['settings']['mute_service'] = 'yes'
                    save_data(_config.moderation.data, data)
					return "فیلتر پیام ورود و خروج افراد فعال شد"
				else
					return "فیلتر پیام ورود و خروج افراد از قبل فعال بوده است"
				end
			end
			if matches[2] == 'photo' then
			local msg_type = 'Photo'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					data[tostring(msg.to.id)]['settings']['mute_photo'] = 'yes'
                    save_data(_config.moderation.data, data)
					return "فیلتر عکس فعال شد"
				else
					return "فیلتر عکس از قبل فعال بوده است"
				end
			end
			if matches[2] == 'video' then
			local msg_type = 'Video'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					data[tostring(msg.to.id)]['settings']['mute_video'] = 'yes'
                    save_data(_config.moderation.data, data)
					return "فیلتر فیلم فعال شد"
				else
					return "فیلتر فیلم از قبل فعال بوده است"
				end
			end
			if matches[2] == 'gif' then
			local msg_type = 'Gifs'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					data[tostring(msg.to.id)]['settings']['mute_gif'] = 'yes'
                    save_data(_config.moderation.data, data)
					return "فیلتر Gif فعال شد"
				else
					return "فیلتر Gif از قبل فعال بوده است"
				end
			end
			if matches[2] == 'doc' then
			local msg_type = 'Documents'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					data[tostring(msg.to.id)]['settings']['mute_doc'] = 'yes'
                    save_data(_config.moderation.data, data)
					return "فیلتر فایل ها فعال شد"
				else
					return "فیلتر فایل ها از قبل فعال بوده است"
				end
			end
			if matches[2] == 'text' then
			local msg_type = 'Text'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					data[tostring(msg.to.id)]['settings']['mute_text'] = 'yes'
                    save_data(_config.moderation.data, data)
					return "فیلتر ارسال متن فعال شد"
				else
					return "فیلتر ارسال متن از قبل فعال بوده است"
				end
			end
			if matches[2] == 'all' then
			local msg_type = 'All'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					data[tostring(msg.to.id)]['settings']['mute_all'] = 'yes'
                    save_data(_config.moderation.data, data)
					return "فیلتر تمامی پیام ها فعال شد"
				else
					return "فیلتر تمامی پیام ها از قبل فعال بوده است"
				end
			end
		end
		if matches[1]:lower() == 'unmute' then
  if not is_momod(msg) then
    return
  end
			local chat_id = msg.to.id
			local target = msg.to.id
			if matches[2] == 'audio' then
			local msg_type = 'Audio'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
					data[tostring(msg.to.id)]['settings']['mute_audio'] = 'no'
                    save_data(_config.moderation.data, data)
					return "فیلتر فایل های صوتی غیرفعال شد"
				else
					return "فیلتر فایل های صوتی از قبل غیرفعال بوده است"
				end
			end
			if matches[2] == 'forward' then
			local msg_type = 'Forward'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
					data[tostring(msg.to.id)]['settings']['mute_forward'] = 'no'
                    save_data(_config.moderation.data, data)
					return "فیلتر فروارد غیرفعال شد"
				else
					return "فیلتر فروارد از قبل غیرفعال بوده است"
				end
			end
			if matches[2] == 'reply' then
			local msg_type = 'Reply'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
					data[tostring(msg.to.id)]['settings']['mute_reply'] = 'no'
                    save_data(_config.moderation.data, data)
					return "فیلتر ریپلی غیرفعال شد"
				else
					return "فیلتر ریپلی از قبل غیرفعال بوده است"
				end
			end
			if matches[2] == 'emoji' then
			local msg_type = 'Emoji'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
					data[tostring(msg.to.id)]['settings']['mute_emoji'] = 'no'
                    save_data(_config.moderation.data, data)
					return "فیلتر ایموجی غیرفعال شد"
				else
					return "فیلتر ایموجی از قبل غیرفعال بوده است"
				end
			end

			if matches[2] == 'sticker' or  matches[2] == 'stickers' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unmute sticker posting")
				return unlock_group_sticker(msg, data, target)
			end
			if matches[2] == 'contact' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unmute contact posting") 
				return unlock_group_contacts(msg, data, target)
			end
		    if matches[2] == 'porn' then
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] unmute porn ") 
			return unlock_group_porn(msg, data, target)
		    end
			if matches[2] == 'service' then
			local msg_type = 'service'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
					data[tostring(msg.to.id)]['settings']['mute_service'] = 'no'
                    save_data(_config.moderation.data, data)
					return "فیلتر پیام ورود و خروج افراد غیرفعال شد"
				else
					return "فیلتر پیام ورود و خروج افراد از قبل غیرفعال بوده است"
				end
			end
			if matches[2] == 'photo' then
			local msg_type = 'Photo'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
					data[tostring(msg.to.id)]['settings']['mute_photo'] = 'no'
                    save_data(_config.moderation.data, data)
					return "فیلتر عکس غیرفعال شد"
				else
					return "فیلتر عکس از قبل غیرفعال بوده است"
				end
			end
			if matches[2] == 'video' then
			local msg_type = 'Video'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
					data[tostring(msg.to.id)]['settings']['mute_video'] = 'no'
                    save_data(_config.moderation.data, data)
					return "فیلتر فیلم غیرفعال شد"
				else
					return "فیلتر فیلم از قبل غیرفعال بوده است"
				end
			end
			if matches[2] == 'gif' then 
			local msg_type = 'Gifs' 
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type) 
					unmute(chat_id, msg_type) 
					data[tostring(msg.to.id)]['settings']['mute_gif'] = 'no'
                    save_data(_config.moderation.data, data)
					return "فیلتر Gif غیرفعال شد"
				else
					return "فیلتر Gif از قبل غیرفعال بوده است"
				end
			end
			if matches[2] == 'doc' then 
			local msg_type = 'Documents' 
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type) 
					unmute(chat_id, msg_type)
					data[tostring(msg.to.id)]['settings']['mute_doc'] = 'no'
                    save_data(_config.moderation.data, data)
					return "فیلتر فایل ها غیرفعال شد"
				else
					return "فیلتر فایل ها از قبل غیرفعال بوده است"
				end
			end
			if matches[2] == 'text' then
			local msg_type = 'Text'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute message")
					unmute(chat_id, msg_type)
					data[tostring(msg.to.id)]['settings']['mute_text'] = 'no'
                    save_data(_config.moderation.data, data)
					return "فیلتر ارسال متن غیرفعال شد"
				else
					return "فیلتر ارسال متن از قبل غیرفعال بوده است"
				end
			end
			if matches[2] == 'all' then
			local msg_type = 'All'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
					data[tostring(msg.to.id)]['settings']['mute_all'] = 'no'
                    save_data(_config.moderation.data, data)
					return "فیلتر تمامی پیام ها غیرفعال شد"
				else
					return "فیلتر تمامی پیام ها از قبل غیرفعال بوده است"
				end
			end
		end

if matches[1]:lower() == 'wlc' then
      local target = msg.to.id
      if matches[2]:lower() == 'enable' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked welcome ")
        return lock_group_welcome(msg, data, target)
      end
	if matches[2] == 'disable' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked welcome ")
        return unlock_group_welcome(msg, data, target)
      end
	end
if matches[1]:lower() == 'chat' then
      local target = msg.to.id
      if matches[2]:lower() == 'enable' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked welcome ")
        return lock_group_chatrobot(msg, data, target)
      end
	if matches[2] == 'disable' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked welcome ")
        return unlock_group_chatrobot(msg, data, target)
      end
	end

if matches[1]:lower() == 'kickme' then
      local target = msg.to.id
      if matches[2]:lower() == 'enable' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] enabled kickme ")
        return lock_group_kickme(msg, data, target)
      end
	if matches[2] == 'disable' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] disabled kickme ")
        return unlock_group_kickme(msg, data, target)
      end
	end

--By @SoLiD021
		if matches[1]:lower() == "silent" and is_momod(msg) then
			local chat_id = msg.to.id
			local hash = "mute_user"..chat_id
			local user_id = ""
			if type(msg.reply_id) ~= "nil" then
				local receiver = get_receiver(msg)
				muteuser = get_message(msg.reply_id, silentuser_by_reply, {receiver = receiver, msg = msg})
			elseif matches[1]:lower() == "silent" and string.match(matches[2], '^%d+$') then
				local user_id = matches[2]
				if is_muted_user(chat_id, user_id) then
					return "["..user_id.."] از قبل به لیست Mute کاربران اضافه شده بود"
      end
				if is_momod(msg) then
					mute_user(chat_id, user_id)
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] added ["..user_id.."] to the muted users list")
					return "["..user_id.."] به لیست Mute کاربران اضافه شد"
				end
			elseif matches[1]:lower() == "silent" and not string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				resolve_username(username, silentuser_by_username, {receiver = receiver, get_cmd = get_cmd, msg=msg})
			end
		end

--By @SoLiD021
		if matches[1]:lower() == "unsilent" and is_momod(msg) then
			local chat_id = msg.to.id
			local hash = "mute_user"..chat_id
			local user_id = ""
			if type(msg.reply_id) ~= "nil" then
				local receiver = get_receiver(msg)
				muteuser = get_message(msg.reply_id, unsilentuser_by_reply, {receiver = receiver, msg = msg})
			elseif matches[1]:lower() == "unsilent" and string.match(matches[2], '^%d+$') then
				local user_id = matches[2]
				if is_muted_user(chat_id, user_id) then
					unmute_user(chat_id, user_id)
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] removed ["..user_id.."] from the muted users list")
					return "["..user_id.."] از لیست Mute کاربران حذف شد"
    else
					return "["..user_id.."] از قبل در لیست Mute کاربران نبوده"
				end
			elseif matches[1]:lower() == "unsilent" and not string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				resolve_username(username, unsilentuser_by_username, {receiver = receiver, msg=msg})
			end
		end

		if matches[1]:lower() == "mutelist" and is_momod(msg) then
			local target = msg.to.id
			if not has_mutes(target) then
				set_mutes(target)
				return show_supergroup_mutes(msg, target)
			end
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup muteslist")
			return show_supergroup_mutes(msg, target)
		end
--Arian
		if matches[1]:lower() == "silentlist" and is_momod(msg) then
			local chat_id = msg.to.id
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup mutelist")
			local hash =  'mute_user:'..msg.to.id
	        local list = redis:smembers(hash)
         	local text = "لیست کاربران Mute شده ["..msg.to.id.."]:\n\n"
         	for k,v in pairsByKeys(list) do
  	    	local user_info = redis:hgetall('user:'..v)
	    	if user_info and user_info.print_name then
			local print_name = string.gsub(user_info.print_name, "_", " ")
			local print_name = string.gsub(print_name, "‮", "")
			text = text..k.." - "..print_name.." ["..v.."]\n"
		else
		text = text..k.." - [ "..v.." ]\n"
	        end
        end
        return text

		end

		if matches[1]:lower() == 'settings' and is_momod(msg) then
			local target = msg.to.id
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup settings ")
			return show_supergroup_settingsmod(msg, target)
		end

		if matches[1]:lower() == 'rules' then
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested group rules")
			return get_rules(msg, data)
		end

		--[[if matches[1] == 'help' and not is_owner(msg) then
			text = "Dar Hale Sakhte shodan:|"
			reply_msg(msg.id, text, ok_cb, false)
		elseif matches[1] == 'help' and is_owner(msg) then
			local name_log = user_print_name(msg.from)
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] Used /superhelp") 
			return super_help()
		end]]

		if matches[1] == 'peer_id' and is_admin1(msg)then
			text = msg.to.peer_id
			reply_msg(msg.id, text, ok_cb, false)
			post_large_msg(receiver, text)
		end

		if matches[1] == 'msg.to.id' and is_admin1(msg) then
			text = msg.to.id
			reply_msg(msg.id, text, ok_cb, false)
			post_large_msg(receiver, text)
		end

		--Admin Join Service Message
		if msg.service then
		local action = msg.action.type
			if action == 'chat_add_user_link' then
				if is_owner2(msg.from.id) then
					local receiver = get_receiver(msg)
					local user = "user#id"..msg.from.id
					savelog(msg.to.id, name_log.." Admin ["..msg.from.id.."] joined the SuperGroup via link")
					channel_set_admin(receiver, user, ok_cb, false)
				end
				if is_support(msg.from.id) and not is_owner2(msg.from.id) then
					local receiver = get_receiver(msg)
					local user = "user#id"..msg.from.id
					savelog(msg.to.id, name_log.." Support member ["..msg.from.id.."] joined the SuperGroup")
					channel_set_mod(receiver, user, ok_cb, false)
				end
			end
			if action == 'chat_add_user' then
				if is_owner2(msg.action.user.id) then
					local receiver = get_receiver(msg)
					local user = "user#id"..msg.action.user.id
					savelog(msg.to.id, name_log.." Admin ["..msg.action.user.id.."] added to the SuperGroup by [ "..msg.from.id.." ]")
					channel_set_admin(receiver, user, ok_cb, false)
				end
				if is_support(msg.action.user.id) and not is_owner2(msg.action.user.id) then
					local receiver = get_receiver(msg)
					local user = "user#id"..msg.action.user.id
					savelog(msg.to.id, name_log.." Support member ["..msg.action.user.id.."] added to the SuperGroup by [ "..msg.from.id.." ]") 
					channel_set_mod(receiver, user, ok_cb, false)
				end
			end
		end
		if matches[1] == 'msg.to.peer_id' then
			post_large_msg(receiver, msg.to.peer_id)
		end
	end
end

local function pre_process(msg)
  if not msg.text and msg.media then
    msg.text = '['..msg.media.type..']'
  end
  return msg
end

return {
  patterns = {
	"^[!/#]([Aa]dd)$",
	"^[!/]([Rr]em)$",
	"^[!/]([Mm]ove) (.*)$",
	"^[!/]([Gg][Pp][Ii]nfo)$",
	"^[!/]([Aa]dmins)$",
	"^[!/]([Oo]wner)$",
	"^[!/]([Mm]odlist)$",
	"^[!/]([Bb]ots)$",
	"^[!/]([Ww]ho)$",
	"^[!/]([Kk]icked)$",
    "^[!/]([Bb]lock) (.*)",
	"^[!/]([Bb]lock)",
	"^[!/]([Tt]osuper)$",
	--"^[!/]([Ii][Dd])$",
	--"^[!/]([Ii][Dd]) (.*)$",
	"^[!/]([Kk]ickme) (.*)$",
	"^[!/]([Kk]ick) (.*)$",
	"^[!/]([Nn]ewlink)$",
	"^[!/]([Ss]etlink)$",
	"^[!/]([Ll]ink)$",
	"^[!/]([Hh]plink)$",
	"^[!/]([Gg]plink)$",
	"^[!/]([Hh]plink)$",
	"^[!/]([Rr]es) (.*)$",
	"^[!/]([Ss]etadmin) (.*)$",
	"^[!/]([Ss]etadmin)",
	"^[!/]([Dd]emoteadmin) (.*)$",
	"^[!/]([Dd]emoteadmin)",
	"^[!/]([Ss]etowner) (.*)$",
	"^[!/]([Ss]etowner)$",
	"^[!/]([Pp]romote) (.*)$",
	"^[!/]([Pp]romote)",
	"^[!/]([Dd]emote) (.*)$",
	"^[!/]([Dd]emote)",
	"^[!/]([Ss]etname) (.*)$",
	--"^[!/]([Ss]etwlc) (.*)$",
	"^[!/]([Ss]etdesc) (.*)$",
	"^[!/]([Ss]etrules) (.*)$",
	"^[!/]([Ss]etphoto)$",
	"^[!/]([Ss]etusername) (.*)$",
	"^[!/]([Uu][Ee]xpiretime)$",
        "^[!/]([Ee]xpiretime) (.*) (.*) (.*)$",
	"^[!/]([Dd]el)$",
	"^[!/]([Ll]ock) (.*)$",
	"^[!/]([Uu]nlock) (.*)$",
	"^[!/]([Mm]ute) ([^%s]+)$",
	"^[!/]([Uu]nmute) ([^%s]+)$",
	"^[!/]([Ss]ilent)$",
	"^[!/]([Ss]ilent) (.*)$",
	"^[!/]([Uu]nsilent)$",
	"^[!/]([Uu]nsilent) (.*)$",
	"^[!/]([Pp]ublic) (.*)$",
	"^[!/]([Ss]ettings)$",
	"^[!/]([Rr]ules)$",
	"^[!/]([Ss]etflood) (%d+)$",
	"^[!/]([Cc]lean) (.*)$",
	--"^[!/]([Hh]elp)$",
	"^[!/]([Ss]ilentlist)$",
	"^[!/]([Mm]utelist)$",
        "[!/](setmod) (.*)",
	"[!/](remmod) (.*)",
       "^[!/]([Ww]lc) (.*)$",
       "^[!/]([Cc]hat) (.*)$",
	"^([Aa]dd)$",
	"^([Rr]em)$",
	"^([Mm]ove) (.*)$",
	"^([Gg][Pp][Ii]nfo)$",
	"^([Aa]dmins)$",
	"^([Oo]wner)$",
	"^([Mm]odlist)$",
	"^([Bb]ots)$",
	"^([Ww]ho)$",
	"^([Kk]icked)$",
    "^([Bb]lock) (.*)",
	"^([Bb]lock)",
	"^([Tt]osuper)$",
	--"^([Ii][Dd])$",
	--"^([Ii][Dd]) (.*)$",
	"^([Kk]ickme) (.*)$",
	"^([Kk]ick) (.*)$",
	"^([Nn]ewlink)$",
	"^([Ss]etlink)$",
	"^([Ll]ink)$",
	"^([Hh]plink)$",
	"^([Gg]plink)$",
	"^([Hh]plink)$",
	"^([Rr]es) (.*)$",
	"^([Ss]etadmin) (.*)$",
	"^([Ss]etadmin)",
	"^([Dd]emoteadmin) (.*)$",
	"^([Dd]emoteadmin)",
	"^([Ss]etowner) (.*)$",
	"^([Ss]etowner)$",
	"^([Pp]romote) (.*)$",
	"^([Pp]romote)",
	"^([Dd]emote) (.*)$",
	"^([Dd]emote)",
	"^([Ss]etname) (.*)$",
	--"^([Ss]etwlc) (.*)$",
	"^([Ss]etdesc) (.*)$",
	"^([Ss]etrules) (.*)$",
	"^([Ss]etphoto)$",
	"^([Ss]etusername) (.*)$",
	"^([Uu][Ee]xpiretime)$",
        "^([Ee]xpiretime) (.*) (.*) (.*)$",
	"^([Dd]el)$",
	"^([Ll]ock) (.*)$",
	"^([Uu]nlock) (.*)$",
	"^([Mm]ute) ([^%s]+)$",
	"^([Uu]nmute) ([^%s]+)$",
	"^([Ss]ilent)$",
	"^([Ss]ilent) (.*)$",
	"^([Uu]nsilent)$",
	"^([Uu]nsilent) (.*)$",
	"^([Pp]ublic) (.*)$",
	"^([Ss]ettings)$",
	"^([Rr]ules)$",
	"^([Ss]etflood) (%d+)$",
	"^([Cc]lean) (.*)$",
	--"^([Hh]elp)$",
	"^([Ss]ilentlist)$",
	"^([Mm]utelist)$",
  "(setmod) (.*)",
	"(remmod) (.*)",
 "^([Ww]lc) (.*)$",
 "^([Cc]hat) (.*)$",
    "^(https://telegram.me/joinchat/%S+)$",
	--"msg.to.peer_id",
	"%[(document)%]",
	"%[(photo)%]",
	"%[(video)%]",
	"%[(audio)%]",
	"%[(contact)%]",
	"^!!tgservice (.+)$",
  },
  run = run,
  pre_process = pre_process
}
--End supergrpup.lua
--By @Rondoozle
