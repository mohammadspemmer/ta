--------DL_CB
function dl_cb(arg, data)
end
--GET_ADMIN(SUDO)
function get_admin()
	if db:get('botBOT-IDadminapiset') then
		return true
	else
   		print("\n\27[32mدراینجا شما بایدایدی عددی مدیر کل (SUDO) را وارد کنید.میتوانید از طریق ربات زیر ایدی عددی را بدست آورید\n\27[34m                                  ربات: UserInfoBot@")
    	print("\n\27[36mشناسه عددی ادمین را وارد کنید:\n\27[31m")
    	local admin=io.read()
		db:del("botBOT-IDadminapi")
    	db:sadd("botBOT-IDadminapi", admin)
		db:set('botBOT-IDadminapiset',true)
    	return print("\n\27[36m     SUDO ID|\27[32m ".. admin .." \27[36m|شناسه سودو")
	end
end
--GET_API(TOKEN)
function get_api()
	if db:get('ApiSet') then
		return true
	else
   		print("\n\27[32mتوکن ربات خود را در این قسمت وارد کنید تا ما بتوانیم به ربات شما دسترسی داشته باشیم\n\27[34m")
    	print("\n\27[36mتوکن را وارد کنید:\n\27[31m")
    	local api=io.read()
		db:del("Api")
    	db:set("Api", api)
		db:set('ApiSet',true)
    	return print("\n\27[36m     TOKEN|\27[32m ".. api .." \27[36m|توکن ربات")
	end
end
function get_bot(i, jove)
	function bot_info (i, jove)
		db:set("botBOT-IDid",jove.id_)
		if jove.first_name_ then
			db:set("botBOT-IDfname",jove.first_name_)
		end
		if jove.last_name_ then
			db:set("botBOT-IDlanme",jove.last_name_)
		end
		db:set("botBOT-IDnum",jove.phone_number_)
		return jove.id_
	end
	tdcli_function ({ID = "GetMe",}, bot_info, nil)
end
--------REDIS
db = dofile('./libs/redis.lua')
--------BASE
base = dofile('./bot/funcation.lua')
--------ByeCoder
byecoder = 218722292
--------TOKEN
if db:get("Api") then
token = db:get("Api")
else
get_api()
end
send_api = "https://api.telegram.org/bot"..token
--------LOCALS
json = dofile('./libs/JSON.lua')
JSON = dofile('./libs/dkjson.lua')
URL = require "socket.url"
url = require "socket.url"
serpent = dofile("./libs/serpent.lua")
http = require "socket.http"
https = require "ssl.https"
local offset = 0
--PROFILE
--SEND
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
function getInputFile(file)
  if file:match('/') then
    infile = {ID = "InputFileLocal", path_ = file}
  elseif file:match('^%d+$') then
    infile = {ID = "InputFileId", id_ = file}
  else
    infile = {ID = "InputFilePersistentId", persistent_id_ = file}
  end

  return infile
end
function sendphoto(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, photo, caption)
 caption = caption
  sendaction(chat_id, "UploadPhoto", 20)
  tdcli_function ({
    ID = "SendMessage",
    chat_id_ = chat_id,
    reply_to_message_id_ = reply_to_message_id,
    disable_notification_ = disable_notification,
    from_background_ = from_background,
    reply_markup_ = reply_markup,
    input_message_content_ = {
      ID = "InputMessagePhoto",
      photo_ = getInputFile(photo),
      added_sticker_file_ids_ = {},
      width_ = 0,
      height_ = 0,
      caption_ = caption
    },
  }, dl_cb, nil)
end
function sendmsgs(chat_id, msg_id, text)
return sendtext(chat_id, msg_id, 1, text, 1)
end
function sendaction(chat_id, action, progress)
  tdcli_function ({
    ID = "SendChatAction",
    chat_id_ = chat_id,
    action_ = {
      ID = "SendMessage" .. action .. "Action",
      progress_ = progress or 100
    }
  }, dl_cb, nil)
end
function getpro(user_id, callback, extra)
tdcli_function ({
    ID = "GetUserProfilePhotos",
    user_id_ = user_id,
    offset_ = 0,
    limit_ = 1
  }, callback, extra)
end
local function getpro2(extra, result, success)
   if result.photos_[0] then
      msg = extra.msg
      sendphoto(msg.chat_id_, msg.id_, 0, 1, nil, result.photos_[0].sizes_[1].photo_.persistent_id_, 'شناسه سوپر گروه : '..msg.chat_id_..'\nشناسه شما : '..msg.sender_user_id_, msg.id_)
   else
      sendmsgs(msg.chat_id_, msg.id_, 'شناسه سوپر گروه : '..msg.chat_id_..'\nشناسه شما : <i>'..msg.sender_user_id_.."</i>")
   end
end

function vardump(value)
  print(serpent.block(value, {comment=false}))
end

--WRITE_FILE_TERMINAL
function writefile(filename, input)
	local file = io.open(filename, "w")
	file:write(input)
	file:flush()
	file:close()
	return true
end
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

 function edit( message_id, text, keyboard)
  local urlk = send_api .. '/editMessageText?&inline_message_id='..message_id..'&text=' .. URL.escape(text)
    urlk = urlk .. '&parse_mode=Markdown'
  if keyboard then
    urlk = urlk..'&reply_markup='..URL.escape(json:encode(keyboard))
  end
    return https.request(urlk)
  end
function Canswer(callback_query_id, text, show_alert)
	local urlk = send_api .. '/answerCallbackQuery?callback_query_id=' .. callback_query_id .. '&text=' .. URL.escape(text)
	if show_alert then
		urlk = urlk..'&show_alert=true'
	end
  https.request(urlk)
	end
  function answer(inline_query_id, query_id , title , description , text , keyboard)
  local results = {{}}
         results[1].id = query_id
         results[1].type = 'article'
         results[1].description = description
         results[1].title = title
         results[1].message_text = text
  urlk = send_api .. '/answerInlineQuery?inline_query_id=' .. inline_query_id ..'&results=' .. URL.escape(json:encode(results))..'&parse_mode=Markdown&cache_time=' .. 1
  if keyboard then
   results[1].reply_markup = keyboard
  urlk = send_api .. '/answerInlineQuery?inline_query_id=' .. inline_query_id ..'&results=' .. URL.escape(json:encode(results))..'&parse_mode=Markdown&cache_time=' .. 1
  end
    https.request(urlk)
  end
--STATS
local function is_pouya(msg)
local byecoderid = 218722292
if msg.sender_user_id_ == byecoderid then
	if byecoderid then
		var = true
	end
	return var
	end
	end

function is_sudo(msg)
    local var = false
	local hash = 'botBOT-IDadminapi'
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
  if db:sismember('botBOT-IDmodapi',user) then
    var = true
  end
  if db:sismember('botBOT-IDadminapi',user) then
    var = true
  end
  return var
end
function vip(msg)
  local var = false
  for v,user in pairs(config_vip) do
    if user == msg.sender_user_id_ then
      var = true
    end
  end
  return var
end
--START
	  function showedit(msg,data)
         if msg then
  base.viewMessages(msg.chat_id_, {[0] = msg.id_})
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
    local function sleep(s) 
  local ntime = os.time() + s  
  base.sendChatAction(msg.chat_id_, 'Typing')
 while ntime > os.time() do
  
  end
end  
local function ifsleep()
typing = db:get('typing')
if typing then
sec = db:get('typingt')
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
 if not msg.reply_markup_ and msg.via_bot_user_id_ ~= 0 then
        print("This is [ MarkDown ]")
        msg_type = 'Markreed'
      end
    if msg.content_.ID == "MessagePhoto" then
      msg_type = 'Photo'
end
local tabchi_id = db:get("botBOT-IDid") or get_bot()
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

--------------------------------PUBLIC
if text and text:match("^(افزودن ادمین) (%d+)$") and (is_pouya(msg) or is_sudo(msg)) then
					local matches = text:match("%d+")
					if db:sismember('botBOT-IDmodapi',matches) then
					ifsleep()
											return send(msg.chat_id_, msg.id_, '🔸درحال حاضر مدیر هست🔹')
											else
						db:sadd('botBOT-IDmodapi', matches)
						db:sadd('botBOT-IDmodapi'..tostring(matches),msg.sender_user_id_)
						ifsleep()
						return send(msg.chat_id_, msg.id_, "🔸مقام کاربر به مدیریت ارتقا یافت .🔹")
					end
					end
				if text and text:match("^(حذف ادمین) (%d+)$") and (is_pouya(msg) or is_sudo(msg)) then
					local matches = text:match("%d+")
					if not db:sismember('botBOT-IDmodapi',matches) then
					ifsleep()
					return send(msg.chat_id_, msg.id_, '🔸درحال حاضر مدیر نیست🔹')
					else
						db:srem('botBOT-IDmodapi', matches)
						ifsleep()
						return send(msg.chat_id_, msg.id_, "🔸کاربر از مقام مدیریت خلع شد.🔹")
					end
					end
					if text and text:match("^(addadmin) (%d+)$") and (is_pouya(msg) or is_sudo(msg)) then
					local matches = text:match("%d+")
					if db:sismember('botBOT-IDmodapi',matches) then
					ifsleep()
											return send(msg.chat_id_, msg.id_, '🔸درحال حاضر مدیر هست🔹')
											else
						db:sadd('botBOT-IDmodapi', matches)
						db:sadd('botBOT-IDmodapi'..tostring(matches),msg.sender_user_id_)
						ifsleep()
						return send(msg.chat_id_, msg.id_, "🔸مقام کاربر به مدیریت ارتقا یافت .🔹")
					end
					end
				if text and text:match("^(remadmin) (%d+)$") and (is_pouya(msg) or is_sudo(msg)) then
					local matches = text:match("%d+")
					if not db:sismember('botBOT-IDmodapi',matches) then
					ifsleep()
					return send(msg.chat_id_, msg.id_, '🔸درحال حاضر مدیر نیست🔹')
					else
						db:srem('botBOT-IDmodapi', matches)
						ifsleep()
						return send(msg.chat_id_, msg.id_, "🔸کاربر از مقام مدیریت خلع شد.🔹")
					end
					end
if is_sudo(msg) or is_admin(msg) or is_pouya(msg) then

if (text == 'reset' or text == 'ریست')  then
db:del("tallmsg")
db:del("asgp")
db:del("tgp")
db:del("tusers")
ifsleep()
base.sendText(msg.chat_id_, msg.id_,1,'🔹 تمامی اطلاعات ربات `ریست` شد و به `حالت اولیه` بازگشت 🔸',1,'md')
        print("Tabchi [ Message ]")
end
if (text == 'id' or text == 'ایدی')  then
         local user = msg.sender_user_id_
         return getpro(user, getpro2, {msg = msg})
end
		  
if (text == 'reload' or text == 'به روز رسانی')  then
 dofile('./bot/funcation.lua')
 dofile('./bot/api.lua')
 ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1, '🔹تمامی `فعالیت های` ربات از سر گرفته شد🔸', 1, 'md')
end
 -----------------inline
function panel(chat_id)
    local keyboard = {}
	local asgp = db:scard("asgp")
	local agp = db:scard("agp")
	local ausers =  db:scard("ausers")
	local aallmsg = db:get("aallmsg")
	if db:get("fwdtime") then
	fwdtime = '[🔹|فعال]'
	else
	fwdtime = '[🔸|غیرفعال]'
	end
	 if db:get('typing') then
              typing = '[🔹|فعال]'
            else
              typing = '[🔸|غیرفعال]'
            end
			if db:get("autoanswer") then
autoanswer = '[🔹|فعال]'
else
autoanswer = '[🔸|غیرفعال]'
end
	local typingt = db:get('typingt')
if not typingt then
typingt = '3'
end
local fwdtimen = db:get('fwdtimen')
if not fwdtimen then
fwdtimen = '4'
end
				local line = {{text = 'کل پیام ها🌱', callback_data = 'show:ALLMSG'},
		{text = ''..aallmsg..'', callback_data = 'ALLMSGS'},
		}
		 table.insert(keyboard, line)
        local line = {{text = 'سوپرگروه ها🌾', callback_data = 'SGP'},
		{text = ''..asgp..'', callback_data = 'SGPS'},
		}
        table.insert(keyboard, line)
        local line = {{text = 'گروه ها🍂', callback_data = 'GP'},
		{text = ''..agp..'', callback_data = 'GPS'},
		}
        table.insert(keyboard, line)
        local line = {{text = 'کاربران✨', callback_data = 'USER'},
		{text = ''..ausers..'', callback_data = 'USERS'},
		}
        table.insert(keyboard, line)
		local line = {{text = 'ارسال زمانی🔭', callback_data = 'FWDTIME'},
		{text = ''..fwdtime..'', callback_data = 'FWDTIMES'},
		}
        table.insert(keyboard, line)
		if db:get("fwdtime") then
		local line = {{text = 'تعداد گروه ارسالی در 3 ثانیه '..fwdtimen..'گروه میباشد', callback_data = 'TTYPING'},
		}
        table.insert(keyboard, line)
		end
				local line = {{text = 'نوشتن🖊', callback_data = 'TYPING'},
		{text = ''..typing..'', callback_data = 'TYPINGS'},
		}
        table.insert(keyboard, line)
		if db:get("typing") == "yes" then
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
   if (text == 'panel' or text == 'امار') then
ifsleep()   
  local res = send_inline(msg.chat_id_, '🌾به لیست آمار ژوپیتر تب API خوش آمدید\n✨برای دریافت راهنما "راهنما" یا"help" راارسال کنید\n@JoveTeam', panel(msg.chat_id_)) 
  end
if not db:get("lang"..msg.chat_id_) then
local selectlang = {{"english","فارسی"}}
if text == 'start' or text == 'بازگشت به منوی اصلی' or text == 'back' then
ifsleep()
send_key(msg.chat_id_, '🌾لطفا زبان خود را انتخاب کنید\n🌾Please Select your language\n@JoveTeam', selectlang, true)
end
if text == 'english' then
db:set("lang"..msg.chat_id_, "english")
ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1, '🔹زبان دستورات ربات شما به `انگلیسی` تغییر پیدا کرد🔸', 1, 'md')
end
if text == 'فارسی' then
db:set("lang"..msg.chat_id_, "persian")
ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1, '🔹زبان دستورات ربات شما به `فارسی` تغییر پیدا کرد🔸', 1, 'md')
end
end

if db:get("lang"..msg.chat_id_) == "english" then
local mkey = {{"panel","help","reset"},{'git pull','settings'},{'support','jovetab'},{'changelang','id'},{'manage'}}
if text == 'start' or text == 'english' or text == 'back' then
ifsleep()
send_key(msg.chat_id_, 'یکی از دکمه ها را انتخاب کنید', mkey, true)
end
local akey = {{"addleft enable","addleft disable"},{"oklink enable","oklink disable"},{"findlink enable","findlink disable"},{"autoanswer enable","autoanswer disable"},{"fwdtime enable","fwdtime disable"},{'join enable','join disable'},{'savecontact enable','savecontact disable'},{'typing enable','typing disable'},{'markread enable','markread disable'},{'sharecontact enable','sharecontact disable'},{'back'}}
if text == 'manage' then
if not db:sismember("ausers",msg.chat_id_) then
ifsleep()
send_key(msg.chat_id_, 'به پنل مدیریتی ژوپیتر تب خوش آمدید.یک کلید را انتخاب کنید', akey, true)
else
ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1, '🔹این امکان تنها برای `سوپرگروه` مدیریتی میباشد🔸', 1, 'md')
end
end
end

if db:get("lang"..msg.chat_id_) == "persian" then
local mkey = {{"امار","راهنما","ریست"},{'آپدیت گیتهاب','تنظیمات'},{'پشتبانی','ژوپیتر تب'},{'تغییر زبان','ایدی'},{'مدیریت'}}
if text == 'start' or text == 'بازگشت به منوی اصلی' or text == 'فارسی' then
ifsleep()
send_key(msg.chat_id_, 'یکی از دکمه ها را انتخاب کنید', mkey, true)
end
local akey = {{"افزودن و لفت فعال","افزودن و لفت غیرفعال"},{"تایید لینک فعال","تایید لینک غیرفعال"},{"شناسایی لینک فعال","شناسایی لینک غیرفعال"},{"پاسخگوی خودکار فعال","پاسخگوی خودکار غیرفعال"},{"نوشتن فعال","نوشتن غیرفعال"},{"ارسال زمانی فعال","ارسال زمانی غیرفعال"},{'عضویت فعال','عضویت غیرفعال'},{'افزودن مخاطب فعال','افزودن مخاطب غیرفعال'},{'نوشتن فعال','نوشتن غیرفعال'},{'مشاهده فعال','مشاهده غیرفعال'},{'اشتراک شماره فعال','اشتراک شماره غیرفعال'},{'بازگشت به منوی اصلی'}}
if text == 'مدیریت' then
if not db:sismember("ausers",msg.chat_id_) then
ifsleep()
send_key(msg.chat_id_, 'به پنل مدیریتی ژوپیتر تب خوش آمدید.یک کلید را انتخاب کنید', akey, true)
else
ifsleep()
base.sendText(msg.chat_id_, msg.id_, 1, '🔹این امکان تنها برای `سوپرگروه` مدیریتی میباشد🔸', 1, 'md')
end
end
end
if text == "changelang" or text == "تغییر زبان" then
local lang = db:get("lang"..msg.chat_id_)
local selectlang = {{"english","فارسی"}}
ifsleep()
send_key(msg.chat_id_, '🌾لطفا زبان خود جدید خود راانتخاب کنید.زبان شما:'..lang..'\n🌾Please Select your new language.Your default lang:'..lang..'\n@JoveTeam', selectlang, true)
db:del("lang"..msg.chat_id_)
end

					if text and text:match("^(ارسال زمانی) (.*)$") then
					local matches = text:match("^ارسال زمانی (.*)$")
					if matches == "فعال" then
						db:set("fwdtime", true)
						ifsleep()
						return send(msg.chat_id_,msg.id_,"🔸ارسال زمانی <code>فعال</code> شد🔹")
					elseif matches == "غیرفعال" then
						db:del("fwdtime")
						ifsleep()
						return send(msg.chat_id_,msg.id_,"🔸ارسال زمانی <code>غیرفعال</code> شد🔹")
					end
					end
					if text and text:match("^(fwdtime) (.*)$") then
					local matches = text:match("^fwdtime (.*)$")
					if matches == "enable" then
						db:set("fwdtime", true)
						ifsleep()
						return send(msg.chat_id_,msg.id_,"🔸ارسال زمانی <code>فعال</code> شد🔹")
					elseif matches == "disable" then
						db:del("fwdtime")
						ifsleep()
						return send(msg.chat_id_,msg.id_,"🔸ارسال زمانی <code>غیرفعال</code> شد🔹")
					end
					end
					if text and text:match("^(ارسال زمانی تعداد) (%d+)$") then
					local matches = text:match("^ارسال زمانی تعداد (%d+)$")
						db:set("fwdtimen", matches)
						ifsleep()
						return send(msg.chat_id_,msg.id_,"🔸تعداد گروه ارسالی به <code>"..matches.."</code> تغییر کرد🔹")
						end
					if text and text:match("^(fwdtimenum) (%d+)$") then
					local matches = text:match("^fwdtimenum (%d+)$")
						db:set("fwdtimen", matches)
						ifsleep()
						return send(msg.chat_id_,msg.id_,"🔸تعداد گروه ارسالی به <code>"..matches.."</code> تغییر کرد🔹")
					end
					if (text == 'typing enable' or text == 'نوشتن فعال')  then

          db:set('typing','yes')
		  ifsleep()
         base.sendText(msg.chat_id_, msg.id_, 1,'🔸حالت نوشتن `فعال` شد🔹', 1, 'md')
                 print("Tabchi [ Message ]")

 end
 if text and text:match('^(تنظیم جواب) "(.*)" (.*)') then
					local txt, answer = text:match('^تنظیم جواب "(.*)" (.*)')
					db:hset("answers", txt, answer)
					db:sadd("answerslist", txt)
					return send(msg.chat_id_, msg.id_, "🔸جواب برای <code>" .. tostring(txt) .. "</code> تنظیم شد به 🔹:\n" .. tostring(answer))
end
					if text:match("^(حذف جواب) (.*)") then
					local matches = text:match("^حذف جواب (.*)")
					db:hdel("answers", matches)
					db:srem("answerslist", matches)
					return send(msg.chat_id_, msg.id_, "🔸جواب برای <code>" .. tostring(matches) .. "</code> از لیست جواب های خودکار پاک شد.🔹")
end
					if text:match("^(پاسخگوی خودکار) (.*)$") then
					local matches = text:match("^پاسخگوی خودکار (.*)$")
					if matches == "فعال" then
						db:set("autoanswer", true)
						return send(msg.chat_id_, 0, "🔸پاسخگوی خودکار <code>فعال</code> شد🔹")
						end
					if matches == "غیرفعال" then
						db:del("autoanswer")
						return send(msg.chat_id_, 0, "🔸پاسخگوی خودکار <code>غیرفعال</code> شد🔹")
					end
					end
if text:match('^(setanswer) "(.*)" (.*)') then
					local txt, answer = text:match('^setanswer "(.*)" (.*)')
					db:hset("answers", txt, answer)
					db:sadd("answerslist", txt)
					return send(msg.chat_id_, msg.id_, "🔸جواب برای <code>" .. tostring(txt) .. "</code> تنظیم شد به 🔹:\n" .. tostring(answer))
end
if (text:match("^(تازه سازی ربات)$") or text:match("^(updatebot)$")) then
					get_bot()
					return send(msg.chat_id_, msg.id_, "مشخصات <i>فردی</i> ربات بروز شد")
					end
if text:match('^(setrealm)') then
					db:set("realm", msg.chat_id_)
					return send(msg.chat_id_, msg.id_, "🔸به عنوان ریلم تنظیم شد🔹:\n" .. tostring(msg.chat_id_))
end
					if text:match("^(delanswer) (.*)") then
					local matches = text:match("^delanswer (.*)")
					db:hdel("answers", matches)
					db:srem("answerslist", matches)
					return send(msg.chat_id_, msg.id_, "🔸جواب برای <code>" .. tostring(matches) .. "</code> از لیست جواب های خودکار پاک شد.🔹")
end
					if text:match("^(autoanswer) (.*)$") then
					local matches = text:match("^پاسخگوی خودکار (.*)$")
					if matches == "enable" then
						db:set("autoanswer", true)
						return send(msg.chat_id_, 0, "🔸پاسخگوی خودکار <code>فعال</code> شد🔹")
						end
					if matches == "disable" then
						db:del("autoanswer")
						return send(msg.chat_id_, 0, "🔸پاسخگوی خودکار <code>غیرفعال</code> شد🔹")
					end
					end
if (text == 'typing disable' or text == 'نوشتن غیرفعال')  then

          db:set('typing','no')
          db:del('typing','yes')
		  ifsleep()
          base.sendText(msg.chat_id_, msg.id_, 1,'🔸حالت نوشتن `غیرفعال` شد🔹', 1, 'md')
                  print("Tabchi [ Message ]")

end
if text and text:match('^settyping (%d+)')  then
            local typeing = text:match('settyping (%d+)')
            db:set('typingt', typeing)
			ifsleep()
          base.sendText(msg.chat_id_, msg.id_, 1,'🔸زمان نوشتن به `'..typeing..'` تغییر کرد🔹', 1, 'md')
            end
 if (text == 'deltyping' or text == 'حذف نوشتن')  then
            db:del('typingt')
			ifsleep()
          base.sendText(msg.chat_id_, msg.id_, 1,'🔸زمان نوشتن `حذف` شد🔹', 1, 'md')
            end
			if text and text:match('^تنظیم نوشتن (%d+)')  then
            local typeing = text:match('تنظیم نوشتن (%d+)')
            db:set('typingt', typeing)
			ifsleep()
          base.sendText(msg.chat_id_, msg.id_, 1,'🔸زمان نوشتن به `'..typeing..'` تغییر کرد🔹', 1, 'md')
            end
					if text and (text:match("^(فوروارد به) (.*)$") and tonumber(msg.reply_to_message_id_) > 0) then
					local matches = text:match("^فوروارد به (.*)$")
					local jove
					local qq = db:scard("ausers") 
                    local ww = db:scard("agp")
                    local ee = db:scard("asgp")	
					local fwdtimen = db:get("fwdtimen")
					if matches:match("^(همه)$") then
						jove = "aall"
				    sended = '🔸پیام به `'..ee..'` سوپرگروه و `'..ww..'` گروه و `'..qq..'` کاربر فروارد شد🔹'
					elseif matches:match("^(کاربران)$") then
						jove = "ausers"
					sended = '🔸پیام به `'..qq..'` کاربر فروارد شد🔹'
					elseif matches:match("^(گروه)$") then
						jove = "agp"
				   sended = '🔸پیام به `'..ww..'` گروه فروارد شد🔹'
					elseif matches:match("^(سوپرگروه)$") then
						jove = "asgp"
					sended = '🔸پیام به `'..ee..'` سوپرگروه فروارد شد🔹'
					else
						return true
					end
					local list = db:smembers(jove)
					local id = msg.reply_to_message_id_
					if db:get("fwdtime") then
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
					if text and (text:match("^(fwd) (.*)$") and tonumber(msg.reply_to_message_id_) > 0) then
					local matches = text:match("^fwd (.*)$")
					local jove
					local qq = db:scard("ausers") 
                    local ww = db:scard("agp")
                    local ee = db:scard("asgp")	
					local fwdtimen = db:get("fwdtimen")
					if matches:match("^(all)$") then
						jove = "aall"
				    sended = '🔸پیام به `'..ee..'` سوپرگروه و `'..ww..'` گروه و `'..qq..'` کاربر فروارد شد🔹'
					elseif matches:match("^(users)$") then
						jove = "ausers"
					sended = '🔸پیام به `'..qq..'` کاربر فروارد شد🔹'
					elseif matches:match("^(gps)$") then
						jove = "agp"
				   sended = '🔸پیام به `'..ww..'` گروه فروارد شد🔹'
					elseif matches:match("^(sgps)$") then
						jove = "asgp"
					sended = '🔸پیام به `'..ee..'` سوپرگروه فروارد شد🔹'
					else
						return true
					end
					local list = db:smembers(jove)
					local id = msg.reply_to_message_id_
					if db:get("fwdtime") then
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
if (text == 'git pull' or text == 'آپدیت گیتهاب')  then
text = io.popen("git pull"):read('*all')
ifsleep()
 base.sendText(msg.chat_id_, msg.id_, 1,text, 1, 'md')
end
        if (text == 'bcsgp' or text == 'پخش سوپرگروه')  then
          function cb(a,b,c)
          local text = b.content_.text_
          local list = db:smembers('asgp')
          for k,v in pairs(list) do
        base.sendText(v, 0, 1, text,1, 'md')
          end
   local gps = db:scard("asgp")     
     local text = '🔸پیام شما از زبان ربات به `'..gps..'` سوپرگروه ارسال شد🔹'
	 ifsleep()
       base.sendText(msg.chat_id_, msg.id_, 1, text, 1, 'md')
          end
          base.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),cb)
          end
		  function jovetab(chat_id)
    local keyboard = {}
        local line = {
		{text = '🔸ژوپیتر تب🔹', callback_data = 'config:settings:'..chat_id},
		}
		 table.insert(keyboard, line)
				local line = {{text = '🍃سریع', callback_data = 'config:settings:'..chat_id},
		{text = '🌾بادقت', callback_data = 'config:settings:'..chat_id},
		}
		 table.insert(keyboard, line)
        local line = {{text = '🌱حرفه ای', callback_data = 'config:settings:'..chat_id},
		{text = '🌱امکانات ویژه', callback_data = 'config:settings:'..chat_id},
		}
        table.insert(keyboard, line)
        local line = {{text = '🔸اطلاعت سازنده🔹', callback_data = 'config:settings:'..chat_id},
		}
        table.insert(keyboard, line)
        local line = {{text = ':ویرایش ارتقا🍃', url = 'https://t.me/ByeCoder'},
		{text = '@ByeCoder', url = 'https://t.me/ByeCoder'},
		}
        table.insert(keyboard, line)
                        local line = {
		{text = ':قدرت برگرفته از🌾', url = 'https://t.me/JoveTeam'},
		{text = '#JoveTeam', url = 'https://t.me/JoveTeam'},
		}
            table.insert(keyboard, line)
			                        local line = {
		{text = ':کانال🌱', url = 'https://t.me/JoveTeam'},
		{text = ' @JoveTeam', url = 'https://t.me/JoveTeam'},
		}
            table.insert(keyboard, line)
    return keyboard
end
 
if (text == 'jovetab' or text == 'ژوپیتر تب')  then
ifsleep()
  local res = send_inline(msg.chat_id_, '🌾ژوپیتر تب نسخه 2.3\n@JoveTeam', jovetab(msg.chat_id_)) 
end
  if (text == 'bcgp' or text == 'پخش گروه')  then
          function cb(a,b,c)
          local text = b.content_.text_
          local list = db:smembers('agp')
          for k,v in pairs(list) do
        base.sendText(v, 0, 1, text,1, 'md')
          end
					local gp = db:scard("agp")     
     local text = '🔸پیام شما از زبان ربات به `'..gp..'` گروه ارسال شد🔹'
	 ifsleep()
       base.sendText(msg.chat_id_, msg.id_, 1, text, 1, 'md')		
          end
          base.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),cb)
          end
  if (text == 'bcuser' or text == 'پخش کاربر')  then
          function cb(a,b,c)
          local text = b.content_.text_
          local list = db:smembers('ausers')
          for k,v in pairs(list) do
        base.sendText(v, 0, 1, text,1, 'md')
          end
local uu = db:scard("ausers")     
     local text = '🔸پیام شما از زبان ربات به `'..uu..'` کاربر ارسال شد🔹'
	 ifsleep()
       base.sendText(msg.chat_id_, msg.id_, 1, text, 1, 'md')
          end
          base.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_),cb)
          end
end

--AUTOANSWER
if text and text:match("(.*)$") then
local text = text:match("(.*)$")
if db:sismember("answerslist", text) then
				if db:get("autoanswer") then
					if msg.sender_user_id_ ~= tabchi_id then
						local answer = db:hget("answers", text)
						send(msg.chat_id_, 0, answer)
					end
				end
			end
			end
--INCREAZE_MSGS
db:incr("aallmsg")
--ADDSUPERGROUP
 if msg.chat_id_ then
      local id = tostring(msg.chat_id_)
      if id:match('-100(%d+)') then
        if not db:sismember("asgp",msg.chat_id_) then
          db:sadd("asgp",msg.chat_id_)
        end
--ADDGROUP
elseif id:match('^-(%d+)') then
if not db:sismember("agp",msg.chat_id_) then
db:sadd("agp",msg.chat_id_)
db:sadd("aall", msg.chat_id_)
end
--ADDUSER
elseif id:match('') then
if not db:sismember("ausers",msg.chat_id_) then
db:sadd("ausers",msg.chat_id_)
db:sadd("aall", msg.chat_id_)
end
   else
        if not db:sismember("asgp",msg.chat_id_) then
            db:sadd("asgp",msg.chat_id_)
            db:sadd("aall", msg.chat_id_)
end
end
end
end

local function run()
 while true do
    local updates = getUpdates()
--vardump(updates)

        for i=1, #updates.result do
          local msg = updates.result[i]
          offset = msg.update_id + 1
          if msg.inline_query then
            local q = msg.inline_query
if q.query:match('s(%d+)') then
              local chat = '-'..q.query:match('s(%d+)')
			  local boti = q.query:match('s(%d+)')
			  local botid = db:get("bot"..boti.."id")
if q.from.id == 218722292 or q.from.id == tonumber(botid) then
	local firstname = db:get("bot"..boti.."fname")
	local lastname = db:get("bot"..boti.."lanme")
	local number = db:get("bot"..boti.."num")
	local realm = db:get("realm")
	if db:get(boti.."fwdtime") then
	fwdtime = '[🔹|فعال]'
	else
	fwdtime = '[🔸|غیرفعال]'
	end
local pm = db:get(boti..'pm')
if not pm then
pm = 'اد شدی گلم پی وی نقطه بزار ❤️'
end
local typingt = db:get(boti..'typingt')
if not typingt then
typingt = '3'
end
 if db:get(boti..'savecontact') then
              co = '[🔹|فعال]'
            else
              co = '[🔸|غیرفعال]'
            end
if not db:get(boti.."offlink") then
 oklink = 'فعال'
 else
 oklink = 'غیرفعال'
 end
 if db:get(boti.."link") then
 findlink = 'فعال'
 else
 findlink = 'غیرفعال'
 end
 if not db:get(boti..'offjoin') then
              join = '[🔹|فعال]'
            else
              join = '[🔸|غیرفعال]'
            end
 if db:get(boti..'typing') then
              typing = '[🔹|فعال]'
            else
              typing = '[🔸|غیرفعال]'
            end
 if db:get(boti..'addcontact') then
              addcontact = 'فعال'
            else
              addcontact = 'غیرفعال'
            end
if db:get(boti..'maxgroups') then
 maxgroups = db:get(boti..'maxgroups')
 else
 maxgroups = '0'
 end
 if db:get(boti..'maxgpmmbr') then
 minmember = db:get(boti..'maxgpmmbr')
 else
 minmember = '0'
 end
 if db:get(boti..'markread') then
              markread = '[🔹|فعال]'
            else
              markread = '[🔸|غیرفعال]'
            end
if db:get(boti.."autoanswer") then
autoanswer = '[🔹|فعال]'
else
autoanswer = '[🔸|غیرفعال]'
end
local fwdtimen = db:get(boti..'fwdtimen')
if not fwdtimen then
fwdtimen = '4'
end
              local keyboard = {}
							keyboard.inline_keyboard = {
								{
                 {text = 'عضویت خودکار♻️', callback_data = 'join'},
		{text = ''..join..'', callback_data = 'SGPS'}
				  },{
				{text = 'فرایند شناسایی لینک '..findlink..' است', callback_data = 'findlink'}
				},{
				{text = 'فرایند تایید لینک '..oklink..' است', callback_data = 'oklink'}
				},{
				{text = 'حداکثر گروه ژوپیتر تب '..maxgroups..' است', callback_data = 'maxgroup'}
				},{
				{text = 'حداقل اعضای گروه '..minmember..' است', callback_data = 'minmember'}
				}
				,{
				{text = 'افزودن مخاطبان💈', callback_data = 'co'},
		{text = ''..co..'', callback_data = 'cos'}
				}
				,{
				{text = 'پیام افزودن:'..pm..'', callback_data = 'pm'}
				}
				,{
				{text = 'اشتراک شماره هنگام افزودن '..addcontact..' است', callback_data = 'addcontacts'}
				}
				,{
				{text = 'ارسال زمانی🔭', callback_data = 'fwdtime'},
		{text = ''..fwdtime..'', callback_data = 'fwdtimes'}
				},{
				{text = 'تعداد گروه ارسالی در 3 ثانیه '..fwdtimen..'گروه میباشد', callback_data = 'fwdtimen'}
				},{
				{text = 'وضعیت مشاهده👁', callback_data = 'markread'},
		{text = ''..markread..'', callback_data = 'markreads'}
				},{
				{text = 'نوشتن🖊', callback_data = 'TYPING'},
		{text = ''..typing..'', callback_data = 'TYPINGS'}
				},{
				{text = 'زمان نوشتن ربات '..typingt..' ثانیه میباشد', callback_data = 'TTYPING'}
				},{
				{text = 'پاسخگوی خودکار🔈', callback_data = 'autoanswer'},
		{text = ''..autoanswer..'', callback_data = 'autoanswers'}
				},
				{
		{text = '🍃قدرت برگرفته از #ژوپیتر', callback_data = 'JOVE'}
		}
							}
            answer(q.id,'settings','تنظیمات ژوپیتر تب '..boti,realm,'🌾به لیست تنظیمات ژوپیتر تب CLI خوش آمدید \n🎯ایدی ربات: '..botid..'\n🏅نام ربات: '..firstname..' '..lastname..'\n✨برای دریافت راهنما "راهنما" یا"help" راارسال کنید\n@JoveTeam',keyboard)
            end
            end

			if q.query:match('p(%d+)') then
              local chat = '-'..q.query:match('p(%d+)')
			  local boti = q.query:match('p(%d+)')
			  local botid = db:get("bot"..boti.."id")
if q.from.id == 218722292 or q.from.id == tonumber(botid) then
	local firstname = db:get("bot"..boti.."fname")
	local lastname = db:get("bot"..boti.."lanme")
	local number = db:get("bot"..boti.."num")
	local realm = db:get("realm")
	local s =  db:get(boti.."offjoin") and 0 or db:get(boti.."maxjoin") and db:ttl(boti.."maxjoin") or 0
local ss = db:get(boti.."offlink") and 0 or db:get(boti.."maxlink") and db:ttl(boti.."maxlink") or 0
local gps = db:scard(boti.."tsgps") or 0
local user = db:scard(boti.."tusers")
local gp = db:scard(boti.."tgp") or 0
local com = db:scard(boti.."tcom") or 0
local block = db:scard(boti.."tblock") or 0
local allmsg = db:get(boti.."tallmsg") or 0
local joinlink = db:scard(boti.."goodlinks") or 0 
local oklink = db:scard(boti.."waitelinks") or 0
local savelink = db:scard(boti.."savedlinks") or 0
              local keyboard = {}
							keyboard.inline_keyboard = {
								{
                 {text = 'کل پیام ها🏵', callback_data = 'join'},
		{text = ''..allmsg..'', callback_data = 'SGPS'}
				  },{
				{text = 'سوپرگروه ها🎭', callback_data = 'co'},
		{text = ''..gps..'', callback_data = 'cos'}
				},{
				{text = 'گروه ها👥', callback_data = 'fwdtime'},
		{text = ''..gp..'', callback_data = 'fwdtimes'}
				},{
				{text = 'کاربران👤', callback_data = 'markread'},
		{text = ''..user..'', callback_data = 'markreads'}
				},{
				{text = 'مسدود شده ها🚫', callback_data = 'TYPING'},
		{text = ''..block..'', callback_data = 'TYPINGS'}
				}
				,{
				{text = 'لینک های عضویت♻️', callback_data = 'JoinLink'},
		{text = ''..joinlink..'', callback_data = 'JoinLinks'}
				}
				,{
				{text = 'لینک های تایید شده🔰', callback_data = 'oklink'},
		{text = ''..oklink..'', callback_data = 'oklinks'}
				}
				,{
				{text = 'لینک های ذخیره شده💾', callback_data = 'savelink'},
		{text = ''..savelink..'', callback_data = 'savelinks'}
				}
				,{
				{text = ''..s..' ثانیه تا عضویت مجدد', callback_data = 'savelink'}
				},{
				{text = ''..ss..' ثانیه تا تایید لینک مجدد', callback_data = 'savelink'}
				},{
				{text = '🍃قدرت برگرفته از #ژوپیتر', callback_data = 'JOVE'}
				}
							}
            answer(q.id,'panel','آمار ژوپیتر تب '..boti,realm,'🌾به لیست آمار ژوپیتر تب CLI خوش آمدید \n🎯ایدی ربات: '..boti..'\n🏅نام ربات: '..firstname..' '..lastname..'\n✨برای دریافت راهنما "راهنما" یا"help" راارسال کنید\n@JoveTeam',keyboard)
            end
            end
						end
end
end
end

end

--CHECKS
get_admin()
db:set("botBOT-IDstart", true)
get_api()
--CALLBACK
      function tdcli_update_callback(data)
 ------vardump(data)
    if (data.ID == "UpdateNewMessage") then

     showedit(data.message_,data)
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