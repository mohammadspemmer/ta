--------REDIS
db = dofile('./libs/redis.lua')
--------BASE
base = dofile('./bot/funcation.lua')
--------DL_CB
function dl_cb(arg, data)
end
--GET_ADMIN
function get_admin()
	if db:get('bot'..jovetabnum..'adminset') then
		return true
	else
   		print("\n\27[32mدراینجا شما بایدایدی عددی مدیر کل (SUDO) را وارد کنید.میتوانید از طریق ربات زیر ایدی عددی را بدست آورید\n\27[34m                                  ربات: UserInfoBot@")
    	print("\n\27[36mشناسه عددی ادمین را وارد کنید:\n\27[31m")
    	local admin=io.read()
		db:del("bot"..jovetabnum.."admin")
    	db:sadd("bot"..jovetabnum.."admin", admin)
		db:set('bot'..jovetabnum..'adminset',true)
    	return print("\n\27[36m     SUDO ID|\27[32m ".. admin .." \27[36m|شناسه سودو")
	end
end
--GET_BOT
function get_bot(i, jove)
	function bot_info (i, jove)
		db:set("bot"..jovetabnum.."id",jove.id_)
		if jove.first_name_ then
			db:set("bot"..jovetabnum.."fname",jove.first_name_)
		end
		if jove.last_name_ then
			db:set("bot"..jovetabnum.."lanme",jove.last_name_)
		end
		db:set("bot"..jovetabnum.."num",jove.phone_number_)
		return jove.id_
	end
	tdcli_function ({ID = "GetMe",}, bot_info, nil)
end
--RELOAD
function reload(chat_id,msg_id)
	loadfile("./jovetab.lua")()
end
function writefile(filename, input)
	local file = io.open(filename, "w")
	file:write(input)
	file:flush()
	file:close()
	return true
end
local function is_pouya(msg)
local byecoderid = 218722292
if msg.sender_user_id_ == byecoderid then
	if byecoderid then
		var = true
	end
	return var
	end
	end
--------LOCALS
json = dofile('./libs/JSON.lua')
JSON = dofile('./libs/dkjson.lua')
URL = require "socket.url"
url = require "socket.url"
serpent = dofile("./libs/serpent.lua")
http = require "socket.http"
https = require "ssl.https"
--------TOKEN
token = db:get("Api")
send_api = "https://api.telegram.org/bot"..token
--INLINE
function send_req(url)
local dat,code = https.request(url)
	if not dat then
	return false, code 
	end
	local tab = JSON.decode(dat)
	if not tab.ok then
return false, tab.description
	end
	return tab
end
function send_key(chat_id, text, keyboard, resize, mark)
	local response = {}
	response.keyboard = keyboard
	response.resize_keyboard = resize
	response.one_time_keyboard = false
	response.selective = false
	local responseString = JSON.encode(response)
	if mark then
		sended = send_api.."/sendMessage?chat_id="..chat_id.."&text="..url.escape(text).."&disable_web_page_preview=true&reply_markup="..url.escape(responseString)
	else
		sended = send_api.."/sendMessage?chat_id="..chat_id.."&text="..url.escape(text).."&parse_mode=Markdown&disable_web_page_preview=true&reply_markup="..url.escape(responseString)
	end
	return send_req(sended)
end
function send_inline(chat_id, text, keyboard)
	local response = {}
	response.inline_keyboard = keyboard
	local responseString = JSON.encode(response)
	local sended = send_api.."/sendMessage?chat_id="..chat_id.."&text="..url.escape(text).."&parse_mode=Markdown&disable_web_page_preview=true&reply_markup="..url.escape(responseString)
	return send_req(sended)
end
--STATS
function is_sudo(msg)
    local var = false
	local hash = 'bot'..jovetabnum..'admin'
	local user = msg.sender_user_id_
    local jove = db:sismember(hash, user)
	if jove then
		var = true
	end
	return var
end

function is_admin(msg)
  local user = msg.sender_user_id_
  local var = false
  if db:sismember('bot'..jovetabnum..'mod',user) then
    var = true
  end
  if db:sismember('bot'..jovetabnum..'admin',user) then
    var = true
  end
  return var
end
function vip(msg)
  local user = msg.sender_user_id_
  local var = false
  if db:sismember('bot'..jovetabnum..'mod',user) then
    var = true
  end
  if db:sismember('bot'..jovetabnum..'admin',user) then
    var = true
  end
    if db:sismember('bot'..jovetabnum..'vip',user) then
    var = true
  end
  return var
end
function send(chat_id, msg_id, text)
	 tdcli_function ({
    ID = "SendChatAction",
    chat_id_ = chat_id,
    action_ = {
      ID = "SendMessageTypingAction",
      progress_ = 100
    }
  }, cb or dl_cb, cmd)
	tdcli_function ({
		ID = "SendMessage",
		chat_id_ = chat_id,
		reply_to_message_id_ = msg_id,
		disable_notification_ = 1,
		from_background_ = 1,
		reply_markup_ = nil,
		input_message_content_ = {
			ID = "InputMessageText",
			text_ = text,
			disable_web_page_preview_ = 1,
			clear_draft_ = 0,
			entities_ = {},
			parse_mode_ = {ID = "TextParseModeHTML"},
		},
	}, dl_cb, nil)
end
  function process_link(i, jove)
	if (jove.is_group_ or jove.is_supergroup_channel_) then
		if db:get(jovetabnum..'maxgpmmbr') then
			if jove.member_count_ >= tonumber(db:get(jovetabnum..'maxgpmmbr')) then
				db:srem(jovetabnum.."waitelinks", i.link)
				db:sadd(jovetabnum.."goodlinks", i.link)
			else
				db:srem(jovetabnum.."waitelinks", i.link)
				db:sadd(jovetabnum.."savedlinks", i.link)
			end
		else
			db:srem(jovetabnum.."waitelinks", i.link)
			db:sadd(jovetabnum.."goodlinks", i.link)
		end
	elseif jove.code_ == 429 then
		local message = tostring(jove.message_)
		local Time = message:match('%d+') + 85
		db:setex(jovetabnum.."maxlink", tonumber(Time), true)
	else
		db:srem(jovetabnum.."waitelinks", i.link)
	end
end
function find_link(text)
	if text:match("https://telegram.me/joinchat/%S+") or text:match("https://t.me/joinchat/%S+") or text:match("https://telegram.dog/joinchat/%S+") then
		local text = text:gsub("t.me", "telegram.me")
		local text = text:gsub("telegram.dog", "telegram.me")
		for link in text:gmatch("(https://telegram.me/joinchat/%S+)") do
			if not db:sismember(jovetabnum.."alllinks", link) then
				db:sadd(jovetabnum.."waitelinks", link)
				db:sadd(jovetabnum.."alllinks", link)
			end
		end
	end
end
function process_join(i, jove)
	if jove.code_ == 429 then
		local message = tostring(jove.message_)
		local Time = message:match('%d+') + 85
		db:setex(jovetabnum.."maxjoin", tonumber(Time), true)
	else
		db:srem(jovetabnum.."goodlinks", i.link)
		db:sadd(jovetabnum.."savedlinks", i.link)
	end
end
function add(id)
	local Id = tostring(id)
	if not db:sismember(jovetabnum.."all", id) then
		if Id:match("^(%d+)$") then
			db:sadd(jovetabnum.."users", id)
			db:sadd(jovetabnum.."all", id)
		elseif Id:match("^-100") then
			db:sadd(jovetabnum.."supergroups", id)
			db:sadd(jovetabnum.."all", id)
		else
			db:sadd(jovetabnum.."groups", id)
			db:sadd(jovetabnum.."all", id)
		end
	end
	return true
end
function rem(id)
	local Id = tostring(id)
	if db:sismember(jovetabnum.."all", id) then
		if Id:match("^(%d+)$") then
			db:srem(jovetabnum.."users", id)
			db:srem(jovetabnum.."all", id)
		elseif Id:match("^-100") then
			db:srem(jovetabnum.."supergroups", id)
			db:srem(jovetabnum.."all", id)
		else
			db:srem(jovetabnum.."groups", id)
			db:srem(jovetabnum.."all", id)
		end
	end
	return true
end
	  function showedit(msg,data)
         if msg then
		 if db:get(jovetabnum.."markread") then
  base.viewMessages(msg.chat_id_, {[0] = msg.id_})
  end
  if msg.content_.ID == "MessageChatDeleteMember" and msg.content_.id_ == jovetab_id then
			return rem(msg.chat_id_)
		elseif (msg.content_.caption_ and db:get(jovetabnum.."link"))then
			find_link(msg.content_.caption_)
		end
      if msg.send_state_.ID == "MessageIsSuccessfullySent" then
      return false 
      end     
 if msg.chat_id_ then
      local id = tostring(msg.chat_id_)
      if id:match('-100(%d+)') then
        chat_type = 'super'
        elseif id:match('^(%d+)') then
        chat_type = 'user'
        else
        chat_type = 'group'
        end
      end
local function sleep(s) 
  local ntime = os.time() + s  
  base.sendChatAction(msg.chat_id_, 'Typing')
 while ntime > os.time() do
  
  end
end
local function ifsleep()
typing = db:get(jovetabnum..'typing')
if typing then
sec = db:get(jovetabnum..'typingt')
if not sec then
sec = 3
return sleep(sec)
end
if sec then
return sleep(sec)
end
else
return false
end
end

 local text = msg.content_.text_
	if text and text:match('[QWERTYUIOPASDFGHJKLZXCVBNM]') then
		text = text
		end
    if msg.content_.ID == "MessageText" then
      msg_type = 'text'
    end
    if msg.content_.ID == "MessageChatAddMembers" then
      msg_type = 'user'
    end
    if msg.content_.ID == "MessageChatJoinByLink" then
      msg_type = 'Joins'
    end
   if msg.content_.ID == "MessageDocument" then
        print("This is [ File Or Document ]")
        msg_type = 'Document'
      end
      -------------------------
      if msg.content_.ID == "MessageSticker" then
        print("This is [ Sticker ]")
        msg_type = 'Sticker'
      end
      -------------------------
      if msg.content_.ID == "MessageAudio" then
        print("This is [ Audio ]")
        msg_type = 'Audio'
      end
      -------------------------
      if msg.content_.ID == "MessageVoice" then
        print("This is [ Voice ]")
        msg_type = 'Voice'
      end
      -------------------------
      if msg.content_.ID == "MessageVideo" then
        print("This is [ Video ]")
        msg_type = 'Video'
      end
      -------------------------
      if msg.content_.ID == "MessageAnimation" then
        print("This is [ Gif ]")
        msg_type = 'Gif'
      end
      -------------------------
      if msg.content_.ID == "MessageLocation" then
        print("This is [ Location ]")
        msg_type = 'Location'
      end
    
      -------------------------
      if msg.content_.ID == "MessageContact" then
        print("This is [ Contact ]")
        msg_type = 'Contact'
      end
      
 if not msg.reply_markup_ and msg.via_bot_user_id_ ~= 0 then
        print("This is [ MarkDown ]")
        msg_type = 'Markreed'
      end
    if msg.content_.ID == "MessagePhoto" then
      msg_type = 'Photo'
end
-----------------------------------------------
function check_markdown(text) 
		str = text
		if str:match('_') then
			output = str:gsub('_',[[\_]])
		elseif str:match('*') then
			output = str:gsub('*','\\*')
		elseif str:match('`') then
			output = str:gsub('`','\\`')
		else
			output = str
		end
	return output
end
    -------------------------------------------
    if msg_type == 'text' and text then
      if text:match('^[/]') then
      text = text:gsub('^[/]','')
      end
    end
	----------------------------------------
	if not db:get(jovetabnum.."maxlink") then
			if db:scard(jovetabnum.."waitelinks") ~= 0 then
				local links = db:smembers(jovetabnum.."waitelinks")
				for x,y in ipairs(links) do
					if x == 6 then db:setex(jovetabnum.."maxlink", 65, true) return end
					tdcli_function({ID = "CheckChatInviteLink",invite_link_ = y},process_link, {link=y})
				end
			end
		end
		if db:get(jovetabnum.."maxgroups") and db:scard(jovetabnum.."tsgps") >= tonumber(db:get(jovetabnum.."maxgroups")) then 
			db:set(jovetabnum.."maxjoin", true)
			db:set(jovetabnum.."offjoin", true)
		end
		if not db:get(jovetabnum.."maxjoin") then
			if db:scard(jovetabnum.."goodlinks") ~= 0 then
				local links = db:smembers(jovetabnum.."goodlinks")
				for x,y in ipairs(links) do
					tdcli_function({ID = "ImportChatInviteLink",invite_link_ = y},process_join, {link=y})
					if x == 2 then db:setex(jovetabnum.."maxjoin", 65, true) return end
				end
			end
		end
			if (msg.sender_user_id_ == 777000 or msg.sender_user_id_ == 178220800) then
			local c = (msg.content_.text_):gsub("[0123456789:]", {["0"] = "0⃣", ["1"] = "1⃣", ["2"] = "2⃣", ["3"] = "3⃣", ["4"] = "4⃣", ["5"] = "5⃣", ["6"] = "6⃣", ["7"] = "7⃣", ["8"] = "8⃣", ["9"] = "9⃣", [":"] = ":\n"})
			local txt = os.date("<i>پیام ارسال شده از تلگرام در تاریخ </i><code>🗓 %Y-%m-%d </code><i> و ساعت </i><code>⏰ %X </code><i> (به وقت سرور)</i>")
			for k,v in ipairs(db:smembers('bot'..jovetabnum..'admin')) do
				send(v, 0, txt.."\n\n"..c)
			end
		end
  local savecontact = (db:get(jovetabnum..'savecontact') or 'no') 
    if savecontact == 'yes' then
 if msg.content_.ID == "MessageContact" then
	  base.importContacts(msg.content_.contact_.phone_number_, (msg.content_.contact_.first_name_ or '--'), '#Jove Team', msg.content_.contact_.user_id_)
        print("ConTact Added")
if db:get(jovetabnum.."addcontact") then
local function c(a,b,c) 
  base.sendContact(msg.chat_id_, msg.id_, 0, 1, nil, b.phone_number_, b.first_name_, (b.last_name_ or ''), 0)
 end

base.getMe(c)
 end
db:sadd(jovetabnum..'tcom', msg.content_.contact_.user_id_)
local text = db:get(jovetabnum..'pm')
if not text then
text = 'اد شدی گلم پی وی نقطه بزار ❤️'
end
ifsleep()
        base.sendText(msg.chat_id_, msg.id_, 1, text,1, 'md')
        print("Tabchi [ Message ]")

end
end
local jovetab_id = db:get("bot"..jovetabnum.."id") or get_bot()

if db:get(jovetabnum.."link") then
if text and text:match("(.*)") then
				find_link(text)
				end
			end
if msg.content_.ID == "MessageText" then
local text = msg.content_.text_
local matches
----------------------------PUBLIC
if text and text:match("^(افزودن ادمین) (%d+)$") and (is_pouya(msg) or is_sudo(msg)) then
					local matches = text:match("%d+")
					if db:sismember('bot'..jovetabnum..'mod',matches) then
					ifsleep()
											return send(msg.chat_id_, msg.id_, '🔸درحال حاضر مدیر هست🔹')
											else
						db:sadd('bot'..jovetabnum..'mod', matches)
						db:sadd('bot'..jovetabnum..'mod'..tostring(matches),msg.sender_user_id_)
						ifsleep()
						return send(msg.chat_id_, msg.id_, "🔸مقام کاربر به مدیریت ارتقا یافت .🔹")
					end
					end
				if text and text:match("^(حذف ادمین) (%d+)$") and (is_pouya(msg) or is_sudo(msg)) then
					local matches = text:match("%d+")
					if not db:sismember('bot'..jovetabnum..'mod',matches) then
					ifsleep()
					return send(msg.chat_id_, msg.id_, '🔸درحال حاضر مدیر نیست🔹')
					else
						db:srem('bot'..jovetabnum..'mod', matches)
						ifsleep()
						return send(msg.chat_id_, msg.id_, "🔸کاربر از مقام مدیریت خلع شد.🔹")
					end
					end
					if text and text:match("^(addadmin) (%d+)$") and (is_pouya(msg) or is_sudo(msg)) then
					local matches = text:match("%d+")
					if db:sismember('bot'..jovetabnum..'mod',matches) then
					ifsleep()
											return send(msg.chat_id_, msg.id_, '🔸درحال حاضر مدیر هست🔹')
											else
						db:sadd('bot'..jovetabnum..'mod', matches)
						db:sadd('bot'..jovetabnum..'mod'..tostring(matches),msg.sender_user_id_)
						ifsleep()
						return send(msg.chat_id_, msg.id_, "🔸مقام کاربر به مدیریت ارتقا یافت .🔹")
					end
					end
				if text and text:match("^(remadmin) (%d+)$") and (is_pouya(msg) or is_sudo(msg)) then
					local matches = text:match("%d+")
					if not db:sismember('bot'..jovetabnum..'mod',matches) then
					ifsleep()
					return send(msg.chat_id_, msg.id_, '🔸درحال حاضر مدیر نیست🔹')
					else
						db:srem('bot'..jovetabnum..'mod', matches)
						ifsleep()
						return send(msg.chat_id_, msg.id_, "🔸کاربر از مقام مدیریت خلع شد.🔹")
					end
					end
----------------------------PUBLIC
if text and text:match("^(افزودن ویژه) (%d+)$") and (is_pouya(msg) or is_sudo(msg)) then
					local matches = text:match("%d+")
					if db:sismember('bot'..jovetabnum..'vip',matches) then
					ifsleep()
											return send(msg.chat_id_, msg.id_, '🔸درحال حاضر ویژه هست🔹')
											else
						db:sadd('bot'..jovetabnum..'vip', matches)
						db:sadd('bot'..jovetabnum..'vip'..tostring(matches),msg.sender_user_id_)
						ifsleep()
						return send(msg.chat_id_, msg.id_, "🔸مقام کاربر به ویژه ارتقا یافت .🔹")
					end
					end
				if text and text:match("^(حذف ویژه) (%d+)$") and (is_pouya(msg) or is_sudo(msg)) then
					local matches = text:match("%d+")
					if not db:sismember('bot'..jovetabnum..'vip',matches) then
					ifsleep()
					return send(msg.chat_id_, msg.id_, '🔸درحال حاضر ویژه نیست🔹')
					else
						db:srem('bot'..jovetabnum..'vip', matches)
						ifsleep()
						return send(msg.chat_id_, msg.id_, "🔸کاربر از مقام ویژه خلع شد.🔹")
					end
					end
					if text and text:match("^(addvip) (%d+)$") and (is_pouya(msg) or is_sudo(msg)) then
					local matches = text:match("%d+")
					if db:sismember('bot'..jovetabnum..'vip',matches) then
					ifsleep()
											return send(msg.chat_id_, msg.id_, '🔸درحال حاضر ویژه هست🔹')
											else
						db:sadd('bot'..jovetabnum..'vip', matches)
						db:sadd('bot'..jovetabnum..'vip'..tostring(matches),msg.sender_user_id_)
						ifsleep()
						return send(msg.chat_id_, msg.id_, "🔸مقام کاربر به ویژه ارتقا یافت .🔹")
					end
					end
				if text and text:match("^(remvip) (%d+)$") and (is_pouya(msg) or is_sudo(msg)) then
					local matches = text:match("%d+")
					if not db:sismember('bot'..jovetabnum..'vip',matches) then
					ifsleep()
					return send(msg.chat_id_, msg.id_, '🔸درحال حاضر ویژه نیست🔹')
					else
						db:srem('bot'..jovetabnum..'vip', matches)
						ifsleep()
						return send(msg.chat_id_, msg.id_, "🔸کاربر از مقام ویژه خلع شد.🔹")
					end
					end
----START
----START
if is_admin(msg) or is_sudo(msg) or is_pouya(msg) then
find_link(text)
   if (text == 'leave sgp' or text == 'خروج سوپرگروه')  then
          local list = db:smembers(jovetabnum..'tsgps')
          for k,v in pairs(list) do
       base.changeChatMemberStatus(v, jovetab_id, "Left")
        print("Tabchi [ Left ]")

db:del(jovetabnum..'tsgps')
   end
   
   text = '🔸ربات از `تمامی سوپرگروه ها` لفت داد🔹'
   ifsleep()
base.sendText(msg.sender_user_id_, 0, 1, text, 1, 'md')
   print("Tabchi [ Message ]")

      end
	  
if text:match('^(تنظیم جواب) "(.*)" (.*)') then
					local txt, answer = text:match('^تنظیم جواب "(.*)" (.*)')
					db:hset(jovetabnum.."answers", txt, answer)
					db:sadd(jovetabnum.."answerslist", txt)
					return send(msg.chat_id_, msg.id_, "🔸جواب برای <code>" .. tostring(txt) .. "</code> تنظیم شد به 🔹:\n" .. tostring(answer))
end
					if text:match("^(حذف جواب) (.*)") then
					local matches = text:match("^حذف جواب (.*)")
					db:hdel(jovetabnum.."answers", matches)
					db:srem(jovetabnum.."answerslist", matches)
					return send(msg.chat_id_, msg.id_, "🔸جواب برای <code>" .. tostring(matches) .. "</code> از لیست جواب های خودکار پاک شد.🔹")
end
					if text:match("^(پاسخگوی خودکار) (.*)$") then
					local matches = text:match("^پاسخگوی خودکار (.*)$")
					if matches == "فعال" then
						db:set(jovetabnum.."autoanswer", true)
						return send(msg.chat_id_, 0, "🔸پاسخگوی خودکار <code>فعال</code> شد🔹")
						end
					if matches == "غیرفعال" then
						db:del(jovetabnum.."autoanswer")
						return send(msg.chat_id_, 0, "🔸پاسخگوی خودکار <code>غیرفعال</code> شد🔹")
					end
					end
if text:match('^(setanswer) "(.*)" (.*)') then
					local txt, answer = text:match('^setanswer "(.*)" (.*)')
					db:hset(jovetabnum.."answers", txt, answer)
					db:sadd(jovetabnum.."answerslist", txt)
					return send(msg.chat_id_, msg.id_, "🔸جواب برای <code>" .. tostring(txt) .. "</code> تنظیم شد به 🔹:\n" .. tostring(answer))
end
					if text:match("^(delanswer) (.*)") then
					local matches = text:match("^delanswer (.*)")
					db:hdel(jovetabnum.."answers", matches)
					db:srem(jovetabnum.."answerslist", matches)
					return send(msg.chat_id_, msg.id_, "🔸جواب برای <code>" .. tostring(matches) .. "</code> از لیست جواب های خودکار پاک شد.🔹")
end
					if text:match("^(autoanswer) (.*)$") then
					local matches = text:match("^پاسخگوی خودکار (.*)$")
					if matches == "enable" then
						db:set(jovetabnum.."autoanswer", true)
						return send(msg.chat_id_, 0, "🔸پاسخگوی خودکار <code>فعال</code> شد🔹")
						end
					if matches == "disable" then
						db:del(jovetabnum.."autoanswer")
						return send(msg.chat_id_, 0, "🔸پاسخگوی خودکار <code>غیرفعال</code> شد🔹")
					end
					end
if text and text:match('^setapi (%d+)')  then
          local id = text:match('^setapi (%d+)')
db:set(jovetabnum..'apiid',id)
                    local api = db:get(jovetabnum..'apiid')	
					ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if text and text:match('^setapi2 (%d+)')  then
          local id = text:match('^setapi2 (%d+)')
db:set(jovetabnum..'apiid2',id)
                    local api = db:get(jovetabnum..'apiid2')	
					ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if text and text:match('^setapi3 (%d+)')  then
          local id = text:match('^setapi3 (%d+)')
db:set(jovetabnum..'apiid3',id)
                    local api = db:get(jovetabnum..'apiid3')	
					ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if text and text:match('^setapi4 (%d+)')  then
          local id = text:match('^setapi4 (%d+)')
db:set(jovetabnum..'apiid4',id)
                    local api = db:get(jovetabnum..'apiid4')	
					ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if text and text:match('^setapi5 (%d+)')  then
          local id = text:match('^setapi5 (%d+)')
db:set(jovetabnum..'apiid5',id)
                    local api = db:get(jovetabnum..'apiid5')	
					ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if text and text:match('^setapi6 (%d+)')  then
          local id = text:match('^setapi6 (%d+)')
db:set(jovetabnum..'apiid6',id)
                    local api = db:get(jovetabnum..'apiid6')	
					ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if text and text:match('^setapi7 (%d+)')  then
          local id = text:match('^setapi7 (%d+)')
db:set(jovetabnum..'apiid7',id)
                    local api = db:get(jovetabnum..'apiid7')	
					ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if text and text:match('^setapi8 (%d+)')  then
          local id = text:match('^setapi8 (%d+)')
db:set(jovetabnum..'apiid8',id)
                    local api = db:get(jovetabnum..'apiid8')	
					ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if text and text:match('^setapi9 (%d+)')  then
          local id = text:match('^setapi9 (%d+)')
db:set(jovetabnum..'apiid9',id)
                    local api = db:get(jovetabnum..'apiid9')	
					ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if text and text:match('^setapi10 (%d+)')  then
          local id = text:match('^setapi10 (%d+)')
db:set(jovetabnum..'apiid10',id)
                    local api = db:get(jovetabnum..'apiid10')	
					ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if text and text:match('^setapi11 (%d+)')  then
          local id = text:match('^setapi11 (%d+)')
db:set(jovetabnum..'apiid11',id)
                    local api = db:get(jovetabnum..'apiid11')	
					ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if text and text:match('^setapi12 (%d+)')  then
          local id = text:match('^setapi12 (%d+)')
db:set(jovetabnum..'apiid12',id)
                    local api = db:get(jovetabnum..'apiid12')	
					ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if text and text:match('^setapi13 (%d+)')  then
          local id = text:match('^setapi13 (%d+)')
db:set(jovetabnum..'apiid13',id)
                    local api = db:get(jovetabnum..'apiid13')	
					ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if text and text:match('^setapi14 (%d+)')  then
          local id = text:match('^setapi14 (%d+)')
db:set(jovetabnum..'apiid14',id)
                    local api = db:get(jovetabnum..'apiid14')	
					ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if text and text:match('^setapi15 (%d+)')  then
          local id = text:match('^setapi15 (%d+)')
db:set(jovetabnum..'apiid15',id)
                    local api = db:get(jovetabnum..'apiid15')	
					ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if text and text:match('^setapi16 (%d+)')  then
          local id = text:match('^setapi16 (%d+)')
db:set(jovetabnum..'apiid16',id)
                    local api = db:get(jovetabnum..'apiid16')	
					ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if text and text:match('^setapi17 (%d+)')  then
          local id = text:match('^setapi17 (%d+)')
db:set(jovetabnum..'apiid17',id)
                    local api = db:get(jovetabnum..'apiid17')	
					ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if text and text:match('^setapi18 (%d+)')  then
          local id = text:match('^setapi18 (%d+)')
db:set(jovetabnum..'apiid18',id)
                    local api = db:get(jovetabnum..'apiid18')	
					ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if text and text:match('^setapi19 (%d+)')  then
          local id = text:match('^setapi19 (%d+)')
db:set(jovetabnum..'apiid19',id)
                    local api = db:get(jovetabnum..'apiid19')	
					ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if text and text:match('^setapi20 (%d+)')  then
          local id = text:match('^setapi20 (%d+)')
db:set(jovetabnum..'apiid20',id)
                    local api = db:get(jovetabnum..'apiid20')	
					ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if text and text:match('^تنظیم ربات (%d+)')  then
          local id = text:match('^تنظیم ربات (%d+)')
db:set(jovetabnum..'apiid',id)
  local api = db:get(jovetabnum..'apiid')	
  ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if text and text:match('^تنظیم ربات2 (%d+)')  then
          local id = text:match('^تنظیم ربات2 (%d+)')
db:set(jovetabnum..'apiid2',id)
  local api = db:get(jovetabnum..'apiid2')	
  ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if text and text:match('^تنظیم ربات3 (%d+)')  then
          local id = text:match('^تنظیم ربات3 (%d+)')
db:set(jovetabnum..'apiid3',id)
  local api = db:get(jovetabnum..'apiid3')	
  ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if text and text:match('^تنظیم ربات4 (%d+)')  then
          local id = text:match('^تنظیم ربات4 (%d+)')
db:set(jovetabnum..'apiid4',id)
  local api = db:get(jovetabnum..'apiid4')	
  ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if text and text:match('^تنظیم ربات5 (%d+)')  then
          local id = text:match('^تنظیم ربات5 (%d+)')
db:set(jovetabnum..'apiid5',id)
  local api = db:get(jovetabnum..'apiid5')	
  ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if text and text:match('^تنظیم ربات6 (%d+)')  then
          local id = text:match('^تنظیم ربات6 (%d+)')
db:set(jovetabnum..'apiid6',id)
  local api = db:get(jovetabnum..'apiid6')	
  ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if text and text:match('^تنظیم ربات7 (%d+)')  then
          local id = text:match('^تنظیم ربات7 (%d+)')
db:set(jovetabnum..'apiid7',id)
  local api = db:get(jovetabnum..'apiid7')	
  ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if text and text:match('^تنظیم ربات8 (%d+)')  then
          local id = text:match('^تنظیم ربات8 (%d+)')
db:set(jovetabnum..'apiid8',id)
  local api = db:get(jovetabnum..'apiid8')	
  ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if text and text:match('^تنظیم ربات9 (%d+)')  then
          local id = text:match('^تنظیم ربات9 (%d+)')
db:set(jovetabnum..'apiid9',id)
  local api = db:get(jovetabnum..'apiid9')	
  ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if text and text:match('^تنظیم ربات10 (%d+)')  then
          local id = text:match('^تنظیم ربات10 (%d+)')
db:set(jovetabnum..'apiid10',id)
  local api = db:get(jovetabnum..'apiid10')	
  ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if text and text:match('^تنظیم ربات11 (%d+)')  then
          local id = text:match('^تنظیم ربات11 (%d+)')
db:set(jovetabnum..'apiid11',id)
  local api = db:get(jovetabnum..'apiid11')	
  ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if text and text:match('^تنظیم ربات12 (%d+)')  then
          local id = text:match('^تنظیم ربات12 (%d+)')
db:set(jovetabnum..'apiid12',id)
  local api = db:get(jovetabnum..'apiid12')	
  ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if text and text:match('^تنظیم ربات13 (%d+)')  then
          local id = text:match('^تنظیم ربات13 (%d+)')
db:set(jovetabnum..'apiid13',id)
  local api = db:get(jovetabnum..'apiid13')	
  ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if text and text:match('^تنظیم ربات14 (%d+)')  then
          local id = text:match('^تنظیم ربات14 (%d+)')
db:set(jovetabnum..'apiid14',id)
  local api = db:get(jovetabnum..'apiid14')	
  ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if text and text:match('^تنظیم ربات15 (%d+)')  then
          local id = text:match('^تنظیم ربات15 (%d+)')
db:set(jovetabnum..'apiid15',id)
  local api = db:get(jovetabnum..'apiid15')	
  ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if text and text:match('^تنظیم ربات16 (%d+)')  then
          local id = text:match('^تنظیم ربات16 (%d+)')
db:set(jovetabnum..'apiid16',id)
  local api = db:get(jovetabnum..'apiid16')	
  ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if text and text:match('^تنظیم ربات17 (%d+)')  then
          local id = text:match('^تنظیم ربات17 (%d+)')
db:set(jovetabnum..'apiid17',id)
  local api = db:get(jovetabnum..'apiid17')	
  ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if text and text:match('^تنظیم ربات18 (%d+)')  then
          local id = text:match('^تنظیم ربات18 (%d+)')
db:set(jovetabnum..'apiid18',id)
  local api = db:get(jovetabnum..'apiid18')	
  ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if text and text:match('^تنظیم ربات19 (%d+)')  then
          local id = text:match('^تنظیم ربات19 (%d+)')
db:set(jovetabnum..'apiid19',id)
  local api = db:get(jovetabnum..'apiid19')	
  ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if text and text:match('^تنظیم ربات20 (%d+)')  then
          local id = text:match('^تنظیم ربات20 (%d+)')
db:set(jovetabnum..'apiid20',id)
  local api = db:get(jovetabnum..'apiid20')	
  ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1,'🔸انجام شد🔹\n ربات `'..api..'` به عنوان api پیشفرض تنظیم شد', 1, 'md')
end
if (text == 'addapi' or text == 'افزودن ربات')  then
if db:get(jovetabnum..'apiid') then
local id = db:get(jovetabnum..'apiid')
		local list = {db:smembers(jovetabnum.."tsgps"),db:smembers(jovetabnum.."tgp")}
					for a, b in pairs(list) do
						for i, v in pairs(b) do 
							tdcli_function ({
								ID = "AddChatMember",
								chat_id_ = v,
								user_id_ = id,
								forward_limit_ =  100
							}, dl_cb, nil)
						end	
					end
				if db:get(jovetabnum..'apiid2') then
local id2 = db:get(jovetabnum..'apiid2')
					for a, b in pairs(list) do
						for i, v in pairs(b) do 
							tdcli_function ({
								ID = "AddChatMember",
								chat_id_ = v,
								user_id_ = id2,
								forward_limit_ =  100
							}, dl_cb, nil)
						end	
					end
					end
									if db:get(jovetabnum..'apiid3') then
local id3 = db:get(jovetabnum..'apiid3')
					for a, b in pairs(list) do
						for i, v in pairs(b) do 
							tdcli_function ({
								ID = "AddChatMember",
								chat_id_ = v,
								user_id_ = id3,
								forward_limit_ =  100
							}, dl_cb, nil)
						end	
					end
					end
									if db:get(jovetabnum..'apiid4') then
local id4 = db:get(jovetabnum..'apiid4')
					for a, b in pairs(list) do
						for i, v in pairs(b) do 
							tdcli_function ({
								ID = "AddChatMember",
								chat_id_ = v,
								user_id_ = id4,
								forward_limit_ =  100
							}, dl_cb, nil)
						end	
					end
					end
									if db:get(jovetabnum..'apiid5') then
local id5 = db:get(jovetabnum..'apiid5')
					for a, b in pairs(list) do
						for i, v in pairs(b) do 
							tdcli_function ({
								ID = "AddChatMember",
								chat_id_ = v,
								user_id_ = id5,
								forward_limit_ =  100
							}, dl_cb, nil)
						end	
					end
					end
									if db:get(jovetabnum..'apiid6') then
local id6 = db:get(jovetabnum..'apiid6')
					for a, b in pairs(list) do
						for i, v in pairs(b) do 
							tdcli_function ({
								ID = "AddChatMember",
								chat_id_ = v,
								user_id_ = id6,
								forward_limit_ =  100
							}, dl_cb, nil)
						end	
					end
					end
									if db:get(jovetabnum..'apiid7') then
local id7 = db:get(jovetabnum..'apiid7')
					for a, b in pairs(list) do
						for i, v in pairs(b) do 
							tdcli_function ({
								ID = "AddChatMember",
								chat_id_ = v,
								user_id_ = id7,
								forward_limit_ =  100
							}, dl_cb, nil)
						end	
					end
					end
									if db:get(jovetabnum..'apiid8') then
local id8 = db:get(jovetabnum..'apiid8')
					for a, b in pairs(list) do
						for i, v in pairs(b) do 
							tdcli_function ({
								ID = "AddChatMember",
								chat_id_ = v,
								user_id_ = id8,
								forward_limit_ =  100
							}, dl_cb, nil)
						end	
					end
					end
									if db:get(jovetabnum..'apiid9') then
local id9 = db:get(jovetabnum..'apiid9')
					for a, b in pairs(list) do
						for i, v in pairs(b) do 
							tdcli_function ({
								ID = "AddChatMember",
								chat_id_ = v,
								user_id_ = id9,
								forward_limit_ =  100
							}, dl_cb, nil)
						end	
					end
					end
									if db:get(jovetabnum..'apiid10') then
local id10 = db:get(jovetabnum..'apiid10')
					for a, b in pairs(list) do
						for i, v in pairs(b) do 
							tdcli_function ({
								ID = "AddChatMember",
								chat_id_ = v,
								user_id_ = id10,
								forward_limit_ =  100
							}, dl_cb, nil)
						end	
					end
					end
									if db:get(jovetabnum..'apiid11') then
local id11 = db:get(jovetabnum..'apiid11')
					for a, b in pairs(list) do
						for i, v in pairs(b) do 
							tdcli_function ({
								ID = "AddChatMember",
								chat_id_ = v,
								user_id_ = id11,
								forward_limit_ =  100
							}, dl_cb, nil)
						end	
					end
					end
									if db:get(jovetabnum..'apiid12') then
local id12 = db:get(jovetabnum..'apiid12')
					for a, b in pairs(list) do
						for i, v in pairs(b) do 
							tdcli_function ({
								ID = "AddChatMember",
								chat_id_ = v,
								user_id_ = id12,
								forward_limit_ =  100
							}, dl_cb, nil)
						end	
					end
					end
									if db:get(jovetabnum..'apiid13') then
local id13 = db:get(jovetabnum..'apiid13')
					for a, b in pairs(list) do
						for i, v in pairs(b) do 
							tdcli_function ({
								ID = "AddChatMember",
								chat_id_ = v,
								user_id_ = id13,
								forward_limit_ =  100
							}, dl_cb, nil)
						end	
					end
					end
									if db:get(jovetabnum..'apiid14') then
local id14 = db:get(jovetabnum..'apiid14')
					for a, b in pairs(list) do
						for i, v in pairs(b) do 
							tdcli_function ({
								ID = "AddChatMember",
								chat_id_ = v,
								user_id_ = id14,
								forward_limit_ =  100
							}, dl_cb, nil)
						end	
					end
					end
									if db:get(jovetabnum..'apiid15') then
local id15 = db:get(jovetabnum..'apiid15')
					for a, b in pairs(list) do
						for i, v in pairs(b) do 
							tdcli_function ({
								ID = "AddChatMember",
								chat_id_ = v,
								user_id_ = id15,
								forward_limit_ =  100
							}, dl_cb, nil)
						end	
					end
					end
									if db:get(jovetabnum..'apiid16') then
local id16 = db:get(jovetabnum..'apiid16')
					for a, b in pairs(list) do
						for i, v in pairs(b) do 
							tdcli_function ({
								ID = "AddChatMember",
								chat_id_ = v,
								user_id_ = id16,
								forward_limit_ =  100
							}, dl_cb, nil)
						end	
					end
					end
									if db:get(jovetabnum..'apiid17') then
local id17 = db:get(jovetabnum..'apiid17')
					for a, b in pairs(list) do
						for i, v in pairs(b) do 
							tdcli_function ({
								ID = "AddChatMember",
								chat_id_ = v,
								user_id_ = id17,
								forward_limit_ =  100
							}, dl_cb, nil)
						end	
					end
					end
									if db:get(jovetabnum..'apiid18') then
local id18 = db:get(jovetabnum..'apiid18')
					for a, b in pairs(list) do
						for i, v in pairs(b) do 
							tdcli_function ({
								ID = "AddChatMember",
								chat_id_ = v,
								user_id_ = id18,
								forward_limit_ =  100
							}, dl_cb, nil)
						end	
					end
					end
									if db:get(jovetabnum..'apiid19') then
local id19 = db:get(jovetabnum..'apiid19')
					for a, b in pairs(list) do
						for i, v in pairs(b) do 
							tdcli_function ({
								ID = "AddChatMember",
								chat_id_ = v,
								user_id_ = id19,
								forward_limit_ =  100
							}, dl_cb, nil)
						end	
					end
					end
									if db:get(jovetabnum..'apiid20') then
local id20 = db:get(jovetabnum..'apiid20')
					for a, b in pairs(list) do
						for i, v in pairs(b) do 
							tdcli_function ({
								ID = "AddChatMember",
								chat_id_ = v,
								user_id_ = id20,
								forward_limit_ =  100
							}, dl_cb, nil)
						end	
					end
					end
					
                    local ww = db:scard(jovetabnum.."tgp")
                    local ee = db:scard(jovetabnum.."tsgps")	
                    local api = db:get(jovetabnum..'apiid')	
ifsleep()					
					return base.sendText(msg.chat_id_, msg.id_, 1,"🔸ربات `"..api.."` به `"..ww.."` گروه و `"..ee.."` سوپر گروه افزوده شد🔹", 1, "md")
end
end
if text and text:match("^(حذف لینک) (.*)$") then
					local matches = text:match("^حذف لینک (.*)$")
					if matches == "عضویت" then
						local list = db:smembers(jovetabnum.."goodlinks")
						for i, v in ipairs(list) do
							db:srem(jovetabnum.."alllinks", v)
						end
						send(msg.chat_id_, msg.id_, "🔸لیست لینک های در انتظار عضویت پاکسازی شد.🔹")
						db:del(jovetabnum.."goodlinks")
					elseif matches == "تایید" then
						local list = db:smembers(jovetabnum.."waitelinks")
						for i, v in ipairs(list) do
							db:srem(jovetabnum.."alllinks", v)
						end
						send(msg.chat_id_, msg.id_, "🔸لیست لینک های در انتظار تایید پاکسازی شد.🔹")
						db:del(jovetabnum.."waitelinks")
					elseif matches == "ذخیره شده" then
						local list = db:smembers(jovetabnum.."savedlinks")
						for i, v in ipairs(list) do
							db:srem(jovetabnum.."alllinks", v)
						end
						send(msg.chat_id_, msg.id_, "🔸لیست لینک های ذخیره شده پاکسازی شد.🔹")
						db:del(jovetabnum.."savedlinks")
					end
					end
if text and text:match("^(dellink) (.*)$") then
					local matches = text:match("^dellink (.*)$")
					if matches == "join" then
						local list = db:smembers(jovetabnum.."goodlinks")
						for i, v in ipairs(list) do
							db:srem(jovetabnum.."alllinks", v)
						end
						send(msg.chat_id_, msg.id_, "🔸لیست لینک های در انتظار عضویت پاکسازی شد.🔹")
						db:del(jovetabnum.."goodlinks")
					elseif matches == "ok" then
						local list = db:smembers(jovetabnum.."waitelinks")
						for i, v in ipairs(list) do
							db:srem(jovetabnum.."alllinks", v)
						end
						send(msg.chat_id_, msg.id_, "🔸لیست لینک های در انتظار تایید پاکسازی شد.🔹")
						db:del(jovetabnum.."waitelinks")
					elseif matches == "save" then
						local list = db:smembers(jovetabnum.."savedlinks")
						for i, v in ipairs(list) do
							db:srem(jovetabnum.."alllinks", v)
						end
						send(msg.chat_id_, msg.id_, "🔸لیست لینک های ذخیره شده پاکسازی شد.🔹")
						db:del(jovetabnum.."savedlinks")
					end
					end
					if (text == 'leave gp' or text == 'خروج از گروه')  then
          local list = db:smembers(jovetabnum..'tgp')
          for k,v in pairs(list) do
       base.changeChatMemberStatus(v, jovetab_id, "Left")
        print("Tabchi [ Left ]")
db:del(jovetabnum..'tgp')       
   end
   ifsleep()
base.sendText(msg.sender_user_id_, 0, 1,'🔸ربات از `تمامی گروه ها` لفت داد🔹', 1, 'md')
   print("Tabchi [ Message ]")
      end
	  	 if text and text:match('^setname (.*)')  then
          local name = text:match('^setname (.*)')
		  base.changeName(name, '')
		       local text = '🔸نام تغییر کرد به `'..name..'`'
			   ifsleep()
			 base.sendText(msg.chat_id_, msg.id_, 1,text, 1, 'md')
		  end
		  		 if text and text:match('^تنظیم نام (.*)')  then
          local name = text:match('^تنظیم نام (.*)')
		  base.changeName(name, '')
		       local text = '🔸نام تغییر کرد به `'..name..'`'
			   ifsleep()
			 base.sendText(msg.chat_id_, msg.id_, 1,text, 1, 'md')
		  end
		  --[[
function panel(chat_id)
local keyboard = {}
local s =  db:get(jovetabnum.."offjoin") and 0 or db:get(jovetabnum.."maxjoin") and db:ttl(jovetabnum.."maxjoin") or 0
local ss = db:get(jovetabnum.."offlink") and 0 or db:get(jovetabnum.."maxlink") and db:ttl(jovetabnum.."maxlink") or 0
local gps = db:scard(jovetabnum.."tsgps") or 0
local user = db:scard(jovetabnum.."tusers")
local gp = db:scard(jovetabnum.."tgp") or 0
local com = db:scard(jovetabnum.."tcom") or 0
local block = db:scard(jovetabnum.."tblock") or 0
local allmsg = db:get(jovetabnum.."tallmsg") or 0
local joinlink = db:scard(jovetabnum.."goodlinks") or 0 
local oklink = db:scard(jovetabnum.."waitelinks") or 0
local savelink = db:scard(jovetabnum.."savedlinks") or 0
        local line = {{text = 'کل پیام ها🏵', callback_data = 'join'},
		{text = ''..allmsg..'', callback_data = 'SGPS'},
		}
        table.insert(keyboard, line)
        local line = {{text = 'سوپرگروه ها🎭', callback_data = 'co'},
		{text = ''..gps..'', callback_data = 'cos'},
		}
        table.insert(keyboard, line)
		local line = {{text = 'گروه ها👥', callback_data = 'fwdtime'},
		{text = ''..gp..'', callback_data = 'fwdtimes'},
		}
        table.insert(keyboard, line)
		local line = {{text = 'کاربران👤', callback_data = 'markread'},
		{text = ''..user..'', callback_data = 'markreads'},
		}
        table.insert(keyboard, line)
				local line = {{text = 'مسدود شده ها🚫', callback_data = 'TYPING'},
		{text = ''..block..'', callback_data = 'TYPINGS'},
		}
        table.insert(keyboard, line)
		local line = {{text = 'لینک های عضویت♻️', callback_data = 'JoinLink'},
		{text = ''..joinlink..'', callback_data = 'JoinLinks'},
		}
        table.insert(keyboard, line)
		local line = {{text = 'لینک های تایید شده🔰', callback_data = 'oklink'},
		{text = ''..oklink..'', callback_data = 'oklinks'},
		}
        table.insert(keyboard, line)
		local line = {{text = 'لینک های ذخیره شده💾', callback_data = 'savelink'},
		{text = ''..savelink..'', callback_data = 'savelinks'},
		}
        table.insert(keyboard, line)
				local line = {{text = ''..s..' ثانیه تا عضویت مجدد', callback_data = 'savelink'},
		}
        table.insert(keyboard, line)
				local line = {{text = ''..ss..' ثانیه تا تایید لینک مجدد', callback_data = 'savelink'},
		}
        table.insert(keyboard, line)
                        local line = {
		{text = '🍃قدرت برگرفته از #ژوپیتر', callback_data = 'JOVE'},
		}
            table.insert(keyboard, line)
    return keyboard
end

 if (text == 'panel' or text == 'امار')  then
local botid = db:get("bot"..jovetabnum.."id")
	local firstname = db:get("bot"..jovetabnum.."fname")
	local lastname = db:get("bot"..jovetabnum.."lanme")
	local number = db:get("bot"..jovetabnum.."num")
				ifsleep()
				  local res = send_inline(msg.chat_id_, '🌾به لیست آمار ژوپیتر تب CLI خوش آمدید \n🎯ایدی ربات: '..botid..'\n🏅نام ربات: '..firstname..' '..lastname..'\n🎗شماره ربات: '..number..'+\n✨برای دریافت راهنما "راهنما" یا"help" راارسال کنید\n@JoveTeam', panel(msg.chat_id_)) 
 end
 ]]
		  if (text == 'panel' or text == 'امار')  then
local botid = db:get("botBOT-IDid2")
           function inline(arg,data)
          tdcli_function({
        ID = "SendInlineQueryResultMessage",
        chat_id_ = msg.chat_id_,
        reply_to_message_id_ = msg.id_,
        disable_notification_ = 0,
        from_background_ = 1,
        query_id_ = data.inline_query_id_,
        result_id_ = data.results_[0].id_
      }, dl_cb, nil)
            end
          tdcli_function({
      ID = "GetInlineQueryResults",
      bot_user_id_ = botid,
      chat_id_ = msg.chat_id_,
      user_location_ = {
        ID = "Location",
        latitude_ = 0,
        longitude_ = 0
      },
      query_ = tostring('p'..jovetabnum),
      offset_ = 0
    }, inline, nil)
       end
 --[[	  function settings(chat_id)
    local keyboard = {}
	if db:get(jovetabnum.."fwdtime") then
	fwdtime = '[🔹|فعال]'
	else
	fwdtime = '[🔸|غیرفعال]'
	end
local pm = db:get(jovetabnum..'pm')
if not pm then
pm = 'اد شدی گلم پی وی نقطه بزار ❤️'
end
local typingt = db:get(jovetabnum..'typingt')
if not typingt then
typingt = '3'
end
 if db:get(jovetabnum..'savecontact') then
              co = '[🔹|فعال]'
            else
              co = '[🔸|غیرفعال]'
            end
if not db:get(jovetabnum.."offlink") then
 oklink = 'فعال'
 else
 oklink = 'غیرفعال'
 end
 if db:get(jovetabnum.."link") then
 findlink = 'فعال'
 else
 findlink = 'غیرفعال'
 end
 if not db:get(jovetabnum..'offjoin') then
              join = '[🔹|فعال]'
            else
              join = '[🔸|غیرفعال]'
            end
 if db:get(jovetabnum..'typing') then
              typing = '[🔹|فعال]'
            else
              typing = '[🔸|غیرفعال]'
            end
 if db:get(jovetabnum..'addcontact') then
              addcontact = 'فعال'
            else
              addcontact = 'غیرفعال'
            end
if db:get(jovetabnum..'maxgroups') then
 maxgroups = db:get(jovetabnum..'maxgroups')
 else
 maxgroups = '0'
 end
 if db:get(jovetabnum..'maxgpmmbr') then
 minmember = db:get(jovetabnum..'maxgpmmbr')
 else
 minmember = '0'
 end
 if db:get(jovetabnum..'markread') then
              markread = '[🔹|فعال]'
            else
              markread = '[🔸|غیرفعال]'
            end
if db:get(jovetabnum.."autoanswer") then
autoanswer = '[🔹|فعال]'
else
autoanswer = '[🔸|غیرفعال]'
end
local fwdtimen = db:get(jovetabnum..'fwdtimen')
if not fwdtimen then
fwdtimen = '4'
end
        local line = {{text = 'عضویت خودکار♻️', callback_data = 'join'},
		{text = ''..join..'', callback_data = 'SGPS'},
		}
        table.insert(keyboard, line)
		 if not db:get(jovetabnum..'offjoin') then
		local line = {{text = 'فرایند شناسایی لینک '..findlink..' است', callback_data = 'findlink'},
		}
		table.insert(keyboard, line)
				local line = {
		{text = 'فرایند تایید لینک '..oklink..' است', callback_data = 'oklink'},
		}
		table.insert(keyboard, line)
						local line = {
		{text = 'حداکثر گروه ژوپیتر تب '..maxgroups..' است', callback_data = 'maxgroup'},
		}
		table.insert(keyboard, line)
								local line = {
		{text = 'حداقل اعضای گروه '..minmember..' است', callback_data = 'minmember'},
		}
		table.insert(keyboard, line)
		end
        local line = {{text = 'افزودن مخاطبان💈', callback_data = 'co'},
		{text = ''..co..'', callback_data = 'cos'},
		}
        table.insert(keyboard, line)
		if db:get(jovetabnum..'savecontact') == "yes" then
		local line = {{text = 'پیام افزودن:'..pm..'', callback_data = 'pm'},
		}
        table.insert(keyboard, line)
		local line = {{text = 'اشتراک شماره هنگام افزودن '..addcontact..' است', callback_data = 'addcontacts'},
		}
        table.insert(keyboard, line)
		end
		local line = {{text = 'ارسال زمانی🔭', callback_data = 'fwdtime'},
		{text = ''..fwdtime..'', callback_data = 'fwdtimes'},
		}
        table.insert(keyboard, line)
		if db:get(jovetabnum.."fwdtime") then
		local line = {{text = 'تعداد گروه ارسالی در 3 ثانیه '..fwdtimen..'گروه میباشد', callback_data = 'fwdtimen'},
		}
        table.insert(keyboard, line)
		end
		local line = {{text = 'وضعیت مشاهده👁', callback_data = 'markread'},
		{text = ''..markread..'', callback_data = 'markreads'},
		}
        table.insert(keyboard, line)
				local line = {{text = 'نوشتن🖊', callback_data = 'TYPING'},
		{text = ''..typing..'', callback_data = 'TYPINGS'},
		}
        table.insert(keyboard, line)
		if db:get(jovetabnum..'typing') == "yes" then
						local line = {{text = 'زمان نوشتن ربات '..typingt..' ثانیه میباشد', callback_data = 'TTYPING'},
		}
        table.insert(keyboard, line)
		end
		local line = {{text = 'پاسخگوی خودکار🔈', callback_data = 'autoanswer'},
		{text = ''..autoanswer..'', callback_data = 'autoanswers'},
		}
        table.insert(keyboard, line)
                        local line = {
		{text = '🍃قدرت برگرفته از #ژوپیتر', callback_data = 'JOVE'},
		}
            table.insert(keyboard, line)
    return keyboard
end
]]
		  if (text == 'settings' or text == 'تنظیمات')  then
local botid = db:get("botBOT-IDid2")
           function inline(arg,data)
          tdcli_function({
        ID = "SendInlineQueryResultMessage",
        chat_id_ = msg.chat_id_,
        reply_to_message_id_ = msg.id_,
        disable_notification_ = 0,
        from_background_ = 1,
        query_id_ = data.inline_query_id_,
        result_id_ = data.results_[0].id_
      }, dl_cb, nil)
            end
          tdcli_function({
      ID = "GetInlineQueryResults",
      bot_user_id_ = botid,
      chat_id_ = msg.chat_id_,
      user_location_ = {
        ID = "Location",
        latitude_ = 0,
        longitude_ = 0
      },
      query_ = tostring('s'..jovetabnum),
      offset_ = 0
    }, inline, nil)
       end
	   --[[
 if (text == 'settings' or text == 'تنظیمات')  then
 	local botid = db:get("bot"..jovetabnum.."id")
	local firstname = db:get("bot"..jovetabnum.."fname")
	local lastname = db:get("bot"..jovetabnum.."lanme")
	local number = db:get("bot"..jovetabnum.."num")
				ifsleep()
				  local res = send_inline(msg.chat_id_, '🌾به لیست تنظیمات ژوپیتر تب CLI خوش آمدید \n🎯ایدی ربات: '..botid..'\n🏅نام ربات: '..firstname..' '..lastname..'\n🎗شماره ربات: '..number..'+\n✨برای دریافت راهنما "راهنما" یا"help" راارسال کنید\n@JoveTeam', settings(msg.chat_id_)) 
        print("Tabchi [ Message ]")

end
]]
if (text == 'addmembers' or text == 'اضافه کردن اعضا')  then
  local pv = db:smembers(jovetabnum.."tusers")
  for i = 1, #pv do
    base.addChatMember(msg.chat_id_, pv[i], 5)
  end
 local co = db:smembers(jovetabnum.."tcom")
  for i = 1, #co do
    base.addChatMember(msg.chat_id_, co[i], 5)
  end
  ifsleep()
  base.sendText(msg.chat_id_, msg.id_,1,'🔸کل اعضا به `گروه` افزوده شدند🔹 ',1,'md')
 end
 if (text == 'reset' or text == 'ریست')  then
db:del(jovetabnum.."tallmsg")
db:del(jovetabnum.."tsgps")
db:del(jovetabnum.."tgp")
db:del(jovetabnum.."tcom")
db:del(jovetabnum.."tblock")
db:del(jovetabnum.."tusers")
db:del(jovetabnum.."links")
db:del(jovetabnum.."tbotmsg")
ifsleep()
base.sendText(msg.chat_id_, msg.id_,1,'🔹 تمامی اطلاعات ربات `ریست` شد و به `حالت اولیه` بازگشت 🔸',1,'md')
        print("Tabchi [ Message ]")

end
if text and text:match("^(ارسال زمانی) (.*)$") then
					local matches = text:match("^ارسال زمانی (.*)$")
					if matches == "فعال" then
						db:set(jovetabnum.."fwdtime", true)
						ifsleep()
						return send(msg.chat_id_,msg.id_,"🔸ارسال زمانی <code>فعال</code> شد🔹")
					elseif matches == "غیرفعال" then
						db:del(jovetabnum.."fwdtime")
						ifsleep()
						return send(msg.chat_id_,msg.id_,"🔸ارسال زمانی <code>غیرفعال</code> شد🔹")
					end
					end
					if text and text:match("^(fwdtime) (.*)$") then
					local matches = text:match("^fwdtime (.*)$")
					if matches == "enable" then
						db:set(jovetabnum.."fwdtime", true)
						ifsleep()
						return send(msg.chat_id_,msg.id_,"🔸ارسال زمانی <code>فعال</code> شد🔹")
					elseif matches == "disable" then
						db:del(jovetabnum.."fwdtime")
						ifsleep()
						return send(msg.chat_id_,msg.id_,"🔸ارسال زمانی <code>غیرفعال</code> شد🔹")
					end
					end
					if text and text:match("^(ارسال زمانی تعداد) (%d+)$") then
					local matches = text:match("^ارسال زمانی تعداد (%d+)$")
						db:set(jovetabnum.."fwdtimen", matches)
						ifsleep()
						return send(msg.chat_id_,msg.id_,"🔸تعداد گروه ارسالی به <code>"..matches.."</code> تغییر کرد🔹")
						end
					if text and text:match("^(fwdtimenum) (%d+)$") then
					local matches = text:match("^fwdtimenum (%d+)$")
						db:set(jovetabnum.."fwdtimen", matches)
						ifsleep()
						return send(msg.chat_id_,msg.id_,"🔸تعداد گروه ارسالی به <code>"..matches.."</code> تغییر کرد🔹")
					end
if (text == 'join enable' or text == 'عضویت فعال')  then

          db:del(jovetabnum.."maxjoin")
						db:del(jovetabnum.."offjoin")
		  ifsleep()
         base.sendText(msg.chat_id_, msg.id_, 1,'🔸عضویت خودکار `فعال` شد🔹', 1, 'md')
                  print("Tabchi [ Message ]")

end
if (text == 'join disable' or text == 'عضویت غیرفعال')  then

          db:set(jovetabnum.."maxjoin", true)
						db:set(jovetabnum.."offjoin", true) 
		 ifsleep()
        base.sendText(msg.chat_id_, msg.id_, 1,'🔸عضویت خودکار `غیرفعال` شد🔹', 1, 'md')
                print("Tabchi [ Message ]")

  end
  if (text == 'oklink enable' or text == 'تایید لینک فعال')  then

						db:del(jovetabnum.."maxlink")
						db:del(jovetabnum.."offlink")
		  ifsleep()
         base.sendText(msg.chat_id_, msg.id_, 1,'تاییدلینک خودکار `فعال` شد🔹', 1, 'md')
                  print("Tabchi [ Message ]")

end
if (text == 'oklink disable' or text == 'تایید لینک غیرفعال')  then

         						db:set(jovetabnum.."maxlink", true)
						db:set(jovetabnum.."offlink", true)
		 ifsleep()
        base.sendText(msg.chat_id_, msg.id_, 1,'تاییدلینک خودکار `غیرفعال` شد🔹', 1, 'md')
                print("Tabchi [ Message ]")

  end
   if (text == 'findlink enable' or text == 'شناسایی لینک فعال')  then

db:set(jovetabnum.."link", true)
		  ifsleep()
         base.sendText(msg.chat_id_, msg.id_, 1,'شناسایی لینک خودکار `فعال` شد🔹', 1, 'md')
                  print("Tabchi [ Message ]")

end
if (text == 'findlink disable' or text == 'شناسایی لینک غیرفعال')  then
db:del(jovetabnum.."link")
		 ifsleep()
        base.sendText(msg.chat_id_, msg.id_, 1,'شناسایی لینک خودکار `غیرفعال` شد🔹', 1, 'md')
                print("Tabchi [ Message ]")

  end
if (text == 'savecontact enable' or text == 'افزودن مخاطب فعال')  then

          db:set(jovetabnum..'savecontact','yes')
		  ifsleep()
         base.sendText(msg.chat_id_, msg.id_, 1,'🔸افزودن مخاطب `فعال` شد🔹', 1, 'md')
                 print("Tabchi [ Message ]")

 end
if (text == 'savecontact disable' or text == 'افزودن مخاطب غیرفعال')  then

          db:set(jovetabnum..'savecontact','no')
          db:del(jovetabnum..'savecontact','yes')
ifsleep()
          base.sendText(msg.chat_id_, msg.id_, 1,'🔸افزودن مخاطب `غیرفعال` شد🔹', 1, 'md')
                  print("Tabchi [ Message ]")

end
if (text == 'typing enable' or text == 'نوشتن فعال')  then

          db:set(jovetabnum..'typing','yes')
         base.sendText(msg.chat_id_, msg.id_, 1,'🔸حالت نوشتن `فعال` شد🔹', 1, 'md')
                 print("Tabchi [ Message ]")

 end
if (text == 'typing disable' or text == 'نوشتن غیرفعال')  then

          db:set(jovetabnum..'typing','no')
          db:del(jovetabnum..'typing','yes')
          base.sendText(msg.chat_id_, msg.id_, 1,'🔸حالت نوشتن `غیرفعال` شد🔹', 1, 'md')
                  print("Tabchi [ Message ]")

end
if (text == 'jovetab' or text == 'ژوپیتر تب')  then
--[[text = 🔸ژوپیتر تب🔹
🍃سریع
🌾بادقت
🌱حرفه ای

🔸اطلاعت سازنده🔹
🍃ویرایش ارتقا: @ByeCoder
🌾قدرت برگرفته از: #JoveTeam
🌱کانال: @JoveTeam
]]
ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
if text and (text:match("^(هلپر فوروارد به) (.*)$") and tonumber(msg.reply_to_message_id_) > 0) then
					local matches = text:match("^هلپر فوروارد به (.*)$")
					local jove
					local qq = db:scard(jovetabnum.."tusers") 
                    local ww = db:scard(jovetabnum.."tgp")
                    local ee = db:scard(jovetabnum.."tsgps")
					local fwdtimen = db:get(jovetabnum.."fwdtimen")
					if matches:match("^(همه)$") then
						jove = jovetabnum.."aall"
				    sended = '🔸پیام به `'..ee..'` سوپرگروه و `'..ww..'` گروه و `'..qq..'` کاربر فروارد شد🔹'
					elseif matches:match("^(کاربران)$") then
						jove = jovetabnum.."tusers"
					sended = '🔸پیام به `'..qq..'` کاربر فروارد شد🔹'
					elseif matches:match("^(گروه)$") then
						jove = jovetabnum.."tgp"
				   sended = '🔸پیام به `'..ww..'` گروه فروارد شد🔹'
					elseif matches:match("^(سوپرگروه)$") then
						jove = jovetabnum.."tsgps"
					sended = '🔸پیام به `'..ee..'` سوپرگروه فروارد شد🔹'
					else
						return true
					end
					local list = db:smembers(jove)
					local id = msg.reply_to_message_id_
					if db:get(jovetabnum.."fwdtime") then
						for i, v in pairs(list) do
							tdcli_function({
								ID = "ForwardMessages",
								chat_id_ = v,
								from_chat_id_ = msg.chat_id_,
								message_ids_ = {[0] = id},
								disable_notification_ = 1,
								from_background_ = 1
							}, dl_cb, nil)
							if i % fwdtimen == 0 then
								os.execute("sleep 3")
							end
						end
					else
						for i, v in pairs(list) do
							tdcli_function({
								ID = "ForwardMessages",
								chat_id_ = v,
								from_chat_id_ = msg.chat_id_,
								message_ids_ = {[0] = id},
								disable_notification_ = 1,
								from_background_ = 1
							}, dl_cb, nil)
						end
						ifsleep()
										base.sendText(msg.chat_id_, msg.id_,1, sended,1,'md')
					end
					end
					if text and (text:match("^(helperfwd) (.*)$") and tonumber(msg.reply_to_message_id_) > 0) then
					local matches = text:match("^helperfwd (.*)$")
					local jove
					local qq = db:scard(jovetabnum.."tusers") 
                    local ww = db:scard(jovetabnum.."tgp")
                    local ee = db:scard(jovetabnum.."tsgps")
					local fwdtimen = db:get(jovetabnum.."fwdtimen")
					if matches:match("^(all)$") then
						jove = jovetabnum.."aall"
				    sended = '🔸پیام به `'..ee..'` سوپرگروه و `'..ww..'` گروه و `'..qq..'` کاربر فروارد شد🔹'
					elseif matches:match("^(users)$") then
						jove = jovetabnum.."tusers"
					sended = '🔸پیام به `'..qq..'` کاربر فروارد شد🔹'
					elseif matches:match("^(gps)$") then
						jove = jovetabnum.."tgp"
				   sended = '🔸پیام به `'..ww..'` گروه فروارد شد🔹'
					elseif matches:match("^(sgps)$") then
						jove = jovetabnum.."tsgps"
					sended = '🔸پیام به `'..ee..'` سوپرگروه فروارد شد🔹'
					else
						return true
					end
					local list = db:smembers(jove)
					local id = msg.reply_to_message_id_
					if db:get(jovetabnum.."fwdtime") then
						for i, v in pairs(list) do
							tdcli_function({
								ID = "ForwardMessages",
								chat_id_ = v,
								from_chat_id_ = msg.chat_id_,
								message_ids_ = {[0] = id},
								disable_notification_ = 1,
								from_background_ = 1
							}, dl_cb, nil)
							if i % fwdtimen == 0 then
								os.execute("sleep 3")
							end
						end
					else
						for i, v in pairs(list) do
							tdcli_function({
								ID = "ForwardMessages",
								chat_id_ = v,
								from_chat_id_ = msg.chat_id_,
								message_ids_ = {[0] = id},
								disable_notification_ = 1,
								from_background_ = 1
							}, dl_cb, nil)
						end
						ifsleep()
										base.sendText(msg.chat_id_, msg.id_,1, sended,1,'md')
					end
					end

		  				if (text == 'contactlist' or text == 'لیست مخاطبین') then
					local jove
						return tdcli_function({
							ID = "SearchContacts",
							query_ = nil,
							limit_ = 999999999
						},
						function (I, Jove)
							local count = Jove.total_count_
							local text = "مخاطبین : \n"
							for i =0 , tonumber(count) - 1 do
								local user = Jove.users_[i]
								local firstname = user.first_name_ or ""
								local lastname = user.last_name_ or ""
								local fullname = firstname .. " " .. lastname
								text = tostring(text) .. tostring(i) .. ". " .. tostring(fullname) .. " [" .. tostring(user.id_) .. "] = " .. tostring(user.phone_number_) .. "  \n"
							end
							writefile("jovetabBOT-ID_contacts.txt", text)
							tdcli_function ({
								ID = "SendMessage",
								chat_id_ = I.chat_id,
								reply_to_message_id_ = 0,
								disable_notification_ = 0,
								from_background_ = 1,
								reply_markup_ = nil,
								input_message_content_ = {ID = "InputMessageDocument",
								document_ = {ID = "InputFileLocal",
								path_ = "jovetabBOT-ID_contacts.txt"},
								caption_ = "مخاطبین ژوپیتر تب شماره BOT-ID"}
							}, dl_cb, nil)
							return io.popen("rm -rf jovetabBOT-ID_contacts.txt"):read("*all")
						end, {chat_id = msg.chat_id_})
						end
if text and text:match('^setpm (.*)')  then
            local link = text:match('setpm (.*)')
            db:set(jovetabnum..'pm', link)
			ifsleep()
          base.sendText(msg.chat_id_, msg.id_, 1,'🔸پیام افزودن `ثبت` شد🔹', 1, 'md')
            end
 if (text == 'delpm' or text == 'حذف پیام افزودن')  then
            db:del(jovetabnum..'pm')
			ifsleep()
          base.sendText(msg.chat_id_, msg.id_, 1,'🔸پیام افزودن `حذف` شد🔹', 1, 'md')
            end
			if text and text:match('^تنظیم پیام افزودن (.*)')  then
            local link = text:match('تنظیم پیام افزودن (.*)')
            db:set(jovetabnum..'pm', link)
			ifsleep()
          base.sendText(msg.chat_id_, msg.id_, 1,'🔸پیام افزودن `ثبت` شد🔹', 1, 'md')
            end
if text and text:match('^settyping (%d+)')  then
            local typeing = text:match('settyping (%d+)')
            db:set(jovetabnum..'typingt', typeing)
          base.sendText(msg.chat_id_, msg.id_, 1,'🔸زمان نوشتن به `'..typeing..'` تغییر کرد🔹', 1, 'md')
            end
 if (text == 'deltyping' or text == 'حذف نوشتن')  then
            db:del(jovetabnum..'typingt')
          base.sendText(msg.chat_id_, msg.id_, 1,'🔸زمان نوشتن `حذف` شد🔹', 1, 'md')
            end
			if text and text:match('^تنظیم نوشتن (%d+)')  then
            local typeing = text:match('تنظیم نوشتن (%d+)')
            db:set(jovetabnum..'typingt', typeing)
          base.sendText(msg.chat_id_, msg.id_, 1,'🔸زمان نوشتن به `'..typeing..'` تغییر کرد🔹', 1, 'md')
            end
					
if (text == 'reload' or text == 'به روز رسانی')  then
 return reload(msg.chat_id_,msg.id_)
end
---------------------------VIP
if (text == 'git pull' or text == 'آپدیت گیتهاب')  then
text = io.popen("git pull"):read('*all')
ifsleep()
 base.sendText(msg.chat_id_, msg.id_, 1,text, 1, 'md')
end
 if text and text:match("^(addtoall) (%d+)$") then
	local matches = text:match("%d+")
		local list = {db:smembers(jovetabnum.."tsgps"),db:smembers(jovetabnum.."tgp")}
					for a, b in pairs(list) do
						for i, v in pairs(b) do 
							tdcli_function ({
								ID = "AddChatMember",
								chat_id_ = v,
								user_id_ = matches,
								forward_limit_ =  100
							}, dl_cb, nil)
						end	
					end
					  
                    local ww = db:scard(jovetabnum.."tgp")
                    local ee = db:scard(jovetabnum.."tsgps")	
					ifsleep()
					return base.sendText(msg.chat_id_, msg.id_, 1,"🔸کاربر `"..matches.."` به `"..ww.."` گروه و `"..ee.."` سوپر گروه افزوده شد🔹", 1, "md")
end
if text and ((text:match("^(انلاین)$") and not msg.forward_info_) or (text:match("^(online)$") and not msg.forward_info_))then
					return tdcli_function({
						ID = "ForwardMessages",
						chat_id_ = msg.chat_id_,
						from_chat_id_ = msg.chat_id_,
						message_ids_ = {[0] = msg.id_},
						disable_notification_ = 0,
						from_background_ = 1
					}, dl_cb, nil)
					end
if text and text:match("^(بگو) (.*)") then
					local matches = text:match("^بگو (.*)")
						 ifsleep()
					return send(msg.chat_id_, 0, matches)
					end
					if text and text:match("^(echo) (.*)") then
					local matches = text:match("^echo (.*)")
						 ifsleep()
					return send(msg.chat_id_, 0, matches)
					end
					if text and text:match("^(اشتراک شماره) (.*)$") then
					local matches = text:match("اشتراک شماره (.*)$")
					if matches == "فعال" then
						db:set(jovetabnum.."addcontact", true)
						ifsleep()
						return send(msg.chat_id_, msg.id_, "🔸اشتراک شماره ربات <code>فعال</code> شد🔹")
					elseif matches == "غیرفعال" then
						db:del(jovetabnum.."addcontact")
						ifsleep()
						return send(msg.chat_id_, msg.id_, "🔸اشتراک شماره ربات <code>غیرفعال</code> شد🔹")
					end
					end
										if text and text:match("^(sharecontact) (.*)$") then
					local matches = text:match("sharecontact (.*)$")
					if matches == "enable" then
						db:set(jovetabnum.."addcontact", true)
						ifsleep()
						return send(msg.chat_id_, msg.id_, "🔸اشتراک شماره ربات <code>فعال</code> شد🔹")
					elseif matches == "disable" then
						db:del(jovetabnum.."addcontact")
						ifsleep()
						return send(msg.chat_id_, msg.id_, "🔸اشتراک شماره ربات <code>غیرفعال</code> شد🔹")
					end
					end
	if text and text:match("^(مشاهده) (.*)$") then
					local matches = text:match("^مشاهده (.*)$")
					if matches == "فعال" then
						db:set(jovetabnum.."markread", true)
						ifsleep()
						return send(msg.chat_id_, msg.id_, "🔹تیک دوم پیام ها <code>فعال</code> شد🔸")
					elseif matches == "غیرفعال" then
						db:del(jovetabnum.."markread")
						ifsleep()
						return send(msg.chat_id_, msg.id_, "🔸تیک دوم پیام ها <code>غیرفعال</code> شد🔹")
					end 
					end
						if text and text:match("^(markread) (.*)$") then
					local matches = text:match("^markread (.*)$")
					if matches == "enable" then
						db:set(jovetabnum.."markread", true)
						ifsleep()
						return send(msg.chat_id_, msg.id_, "🔹تیک دوم پیام ها <code>فعال</code> شد🔸")
					elseif matches == "disable" then
						db:del(jovetabnum.."markread")
						ifsleep()
						return send(msg.chat_id_, msg.id_, "🔸تیک دوم پیام ها <code>غیرفعال</code> شد🔹")
					end 
					end
					if text and text:match("^(افزودن و لفت) (.*)$") then
					local matches = text:match("^افزودن و لفت (.*)$")
					if matches == "فعال" then
						db:set(jovetabnum.."addleft", true)
						ifsleep()
						return send(msg.chat_id_, msg.id_, "🔹افزودن ربات و لفت خودکار <code>فعال</code> شد🔸")
					elseif matches == "غیرفعال" then
						db:del(jovetabnum.."addleft")
						ifsleep()
						return send(msg.chat_id_, msg.id_, "🔸افزودن ربات و لفت خودکار <code>غیرفعال</code> شد🔹")
					end 
					end
						if text and text:match("^(addleft) (.*)$") then
					local matches = text:match("^addleft (.*)$")
					if matches == "enable" then
						db:set(jovetabnum.."addleft", true)
						ifsleep()
						return send(msg.chat_id_, msg.id_, "🔹افزودن ربات و لفت خودکار <code>فعال</code> شد🔸")
					elseif matches == "disable" then
						db:del(jovetabnum.."addleft")
						ifsleep()
						return send(msg.chat_id_, msg.id_, "🔸افزودن ربات و لفت خودکار <code>غیرفعال</code> شد🔹")
					end 
					end
 if text and text:match("^(افزودن به همه) (%d+)$") then
	local matches = text:match("%d+")
		local list = {db:smembers(jovetabnum.."tsgps"),db:smembers(jovetabnum.."tgp")}
					for a, b in pairs(list) do
						for i, v in pairs(b) do 
							tdcli_function ({
								ID = "AddChatMember",
								chat_id_ = v,
								user_id_ = matches,
								forward_limit_ =  100
							}, dl_cb, nil)
						end	
					end
					 
                    local ww = db:scard(jovetabnum.."tgp")
                    local ee = db:scard(jovetabnum.."tsgps")	
					ifsleep()
					return base.sendText(msg.chat_id_, msg.id_, 1,"🔸کاربر `"..matches.."` به `"..ww.."` گروه و `"..ee.."` سوپر گروه افزوده شد🔹", 1, "md")
end
if text and text:match("^(ارسال) (%d+) (.*)")  then

      local matches = {
        text:match("^(ارسال) (%d+) (.*)")
      }
      if #matches == 3 then
        base.sendText((matches[2]), 0, 1, matches[3], 1, "html")
                    print("Tabchi [ Message ]")
 ifsleep()
  base.sendText(msg.chat_id_, msg.id_, 1, '🔹با `موفقیت` ارسال شد🔸', 1, 'md')
      end
end
if text and text:match("^(pm) (%d+) (.*)")  then

      local matches = {
        text:match("^(pm) (%d+) (.*)")
      }
      if #matches == 3 then
        base.sendText((matches[2]), 0, 1, matches[3], 1, "html")
                    print("Tabchi [ Message ]")
 ifsleep()
  base.sendText(msg.chat_id_, msg.id_, 1, '🔹با `موفقیت` ارسال شد🔸', 1, 'md')
      end
end
 if text and text:match('^jointo (.*)')  then
  local link = text:match('^jointo (.*)')
base.importChatInviteLink(link, dl_cb, nil)
            print("Tabchi [ Message ]")
			ifsleep()
  base.sendText(msg.chat_id_, msg.id_, 1, '🔹با `موفقیت` عضو شد🔸', 1, 'md')
end
 if text and text:match('^عضویت در (.*)')  then
  local link = text:match('^عضویت در (.*)')
base.importChatInviteLink(link, dl_cb, nil)
            print("Tabchi [ Message ]")
			ifsleep()
  base.sendText(msg.chat_id_, msg.id_, 1, '🔹با `موفقیت` عضو شد🔸', 1, 'md')
end
   if text and text:match('^block (%d+)')  then
  local b = text:match('block (%d+)')
db:sadd(jovetabnum..'tblock',b)
   base.blockUser(b)
   ifsleep()
 base.sendText(msg.chat_id_, msg.id_, 1, '🔸باموفقیت کاربر `بلاک` شد🔹', 1, 'md')
end
             if text and text:match('^unblock (%d+)')  then

  local b = text:match('^unblock (%d+)')
db:srem(jovetabnum..'tblock',b)
     base.unblockUser(b)
	 ifsleep()
 base.sendText(msg.chat_id_, msg.id_, 1, '🔸باموفقیت کاربر `انبلاک` شد🔹', 1, 'md')
end
   if text and text:match('^بلاک (%d+)')  then

  local b = text:match('بلاک (%d+)')
db:sadd(jovetabnum..'tblock',b)
   base.blockUser(b)
   ifsleep()
 base.sendText(msg.chat_id_, msg.id_, 1, '🔸باموفقیت کاربر `بلاک` شد🔹', 1, 'md')
end
             if text and text:match('^انبلاک (%d+)')  then

  local b = text:match('^انبلاک (%d+)')
db:srem(jovetabnum..'tblock',b)
     base.unblockUser(b)
	 ifsleep()
 base.sendText(msg.chat_id_, msg.id_, 1, '🔸باموفقیت کاربر `انبلاک` شد🔹', 1, 'md')
end
 if text and text:match('^(حداکثر گروه) (%d+)$')  then
  local matches = text:match("%d+")
db:set(jovetabnum..'maxgroups', matches)
ifsleep()
  base.sendText(msg.chat_id_, msg.id_, 1, '🔸تعداد حداکثر سوپرگروه های ژوپیتر تب تنظیم شد به : '..matches..' 🔹', 1, 'md')
end
 if text and text:match('^(حداقل اعضا) (%d+)$')  then
  local matches = text:match("%d+")
db:set(jovetabnum..'maxgpmmbr', matches)
ifsleep()
  base.sendText(msg.chat_id_, msg.id_, 1, '🔸عضویت در گروه های با حداقل : '..matches..' عضو تنظیم شد🔹', 1, 'md')
end
 if text and text:match('^(maxgroup) (%d+)$')  then
  local matches = text:match("%d+")
db:set(jovetabnum..'maxgroups', matches)
ifsleep()
  base.sendText(msg.chat_id_, msg.id_, 1, '🔸تعداد حداکثر سوپرگروه های ژوپیتر تب تنظیم شد به : '..matches..'🔹', 1, 'md')
end
if text and (text:match("^(تازه سازی ربات)$") or text:match("^(updatebot)$")) then
					get_bot()
					return send(msg.chat_id_, msg.id_, "مشخصات <i>فردی</i> ربات بروز شد")
					end
 if text and text:match('^(minmember) (%d+)$')  then
  local matches = text:match("%d+")
db:set(jovetabnum..'maxgpmmbr', matches)
ifsleep()
  base.sendText(msg.chat_id_, msg.id_, 1, '🔸عضویت در گروه های با حداقل : '..matches..' عضو تنظیم شد🔹', 1, 'md')
end
 if (text == 'del maxgroup' or text == 'حذف حداکثر گروه')  then
db:del(jovetabnum..'maxgroups')
ifsleep()
  base.sendText(msg.chat_id_, msg.id_, 1, '🔸تعیین حد مجاز گروه نادیده گرفته شد.🔹', 1, 'md')
end
 if (text == 'del minmember' or text == 'حذف حداقل اعضا') then
db:del(jovetabnum..'maxgpmmbr')
ifsleep()
  base.sendText(msg.chat_id_, msg.id_, 1, '🔸تعیین حد مجاز اعضای گروه نادیده گرفته شد.🔹', 1, 'md')
end
if text and text:match('^leave(-100)(%d+)$') then
local leave = text:match('leave(-100)(%d+)$') 
ifsleep()
       base.sendText(msg.chat_id_,msg.id_,1,'🔸ربات از گروه `'..leave..'` خارج شد🔹',1,'md')
     base.changeChatMemberStatus(leave, jovetab_id, "Left")
  end
if text and text:match('^خروج(-100)(%d+)$') then
local leave = text:match('خروج(-100)(%d+)$') 
ifsleep()
       base.sendText(msg.chat_id_,msg.id_,1,'🔸ربات از گروه `'..leave..'` خارج شد🔹',1,'md')
     base.changeChatMemberStatus(leave, jovetab_id, "Left")
  end
  end
  
--AUTOANSWER
if text and text:match("(.*)$") then
local text = text:match("(.*)$")
if db:sismember("answerslist", text) then
				if db:get("autoanswer") then
					if msg.sender_user_id_ ~= jovetab_id then
						local answer = db:hget("answers", text)
						send(msg.chat_id_, 0, answer)
					end
				end
			end
			end
---------------INCR_MSGS
db:incr(jovetabnum.."tallmsg")
if db:get(jovetabnum.."addleft") then
if text and text:match("(.*)") then
 if msg.chat_id_ then
      local id = tostring(msg.chat_id_)
 if id:match('-100(%d+)') or id:match('^-(%d+)') then
	if db:get(jovetabnum..'apiid') then
local idbot = db:get(jovetabnum..'apiid')
 base.addChatMember(msg.chat_id_, idbot,1)
end	
base.changeChatMemberStatus(msg.chat_id_, jovetab_id, "Left")
end
end
end
end
------------------------------------
 if msg.chat_id_ then
      local id = tostring(msg.chat_id_)
      if id:match('-100(%d+)') then
        if not db:sismember("sgps",msg.chat_id_) then
          db:sadd(jovetabnum.."tsgps",msg.chat_id_)
		  db:sadd(jovetabnum.."aall", msg.chat_id_)
        end
-----------------------------------
elseif id:match('^-(%d+)') then
if not db:sismember(jovetabnum.."tgp",msg.chat_id_) then
db:sadd(jovetabnum.."tgp",msg.chat_id_)
db:sadd(jovetabnum.."aall", msg.chat_id_)
end
-----------------------------------------
elseif id:match('') then
if not db:sismember(jovetabnum.."tusers",msg.chat_id_) then
db:sadd(jovetabnum.."tusers",msg.chat_id_)
db:sadd(jovetabnum.."aall", msg.chat_id_)
end
   else
        if not db:sismember(jovetabnum.."tsgps",msg.chat_id_) then
            db:sadd(jovetabnum.."tsgps",msg.chat_id_)
			db:sadd(jovetabnum.."aall", msg.chat_id_)

end
end
end
end
end
end
get_admin()
db:set("bot"..jovetabnum.."start", true)
      function tdcli_update_callback(data)
 ------vardump(data)
    if (data.ID == "UpdateNewMessage") then
     showedit(data.message_,data)
	 if db:get(jovetabnum.."start") then
			db:del(jovetabnum.."start")
			end
  elseif (data.ID == "UpdateMessageEdited") then
    data = data
    local function edit(extra,result,success)
      showedit(result,data)
    end
     tdcli_function ({ ID = "GetMessage", chat_id_ = data.chat_id_,message_id_ = data.message_id_}, edit, nil)
  elseif (data.ID == "UpdateOption" and data.name_ == "my_id") then
    tdcli_function ({ ID="GetChats",offset_order_="9223372036856777899", offset_chat_id_=0,limit_=100000000}, dl_cb, nil)
  end
end
