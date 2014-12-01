' monk.bmx 

Strict

Framework MaxGUI.Drivers
Import MaxGUI.ProxyGadgets

Import brl.eventqueue
Import brl.standardio
Import brl.filesystem
Import brl.system
Import brl.ramstream
Import pub.freeprocess
Import brl.pngloader
Import brl.timer
Import brl.maxutil
Import brl.retro

Import pub.stdc

' added .md markdown suffix
' 

?Win32
Import "monk.o"
?

AppTitle = "Monk"

Const VERSION$="0.40.00"
Const ABOUT$="Monk "+VERSION+" - (c) 2014 Simon Armstrong"

Incbin "monkicon.png"
Incbin "monktoolbar.png"

?Linux
Incbin "window_icon.png"
?

Const TIMER_FREQUENCY=30

Global BCC_VERSION$="{unknown}"	'not valid until codeplay opened

Const EOL$="~n"

Const FileTypes$="monkey,bmx,bbdoc,txt,ini,md,doc,plist,bb,cpp,c,cc,m,cxx,s,glsl,hlsl,lua,py,h,hpp,html,htm,css,js,bat,mm,as,java,bbx,cs,xml,properties,template"
Const FileTypeFilters$="Code Files:"+FileTypes$+";All Files:*"

Const WIKI_URL$="http://blitz-wiki.appspot.com/"
Const WIKI_LOCAL$="/docs/blitz-wiki.appspot.com/"
Const WIKI_LOCAL_SUFFIX$="4d8a.html"

Const WIKI_ARGS$="?format=mobile"
Const WIKI_HOST$="blitz-wiki.appspot.com"
Const WIKI_INDEX$="w/index"
Const WIKI_RSS_INDEX$="w/index.rss"
Const WIKI_SITE_INDEX$="sitemap.xml"

Const CLOUDHOST$="commondatastorage.googleapis.com"
Const CLOUD$="http://"+CLOUDHOST+"/monkeycoder.co.nz/"

Const MonkeyWords$=";"+..
	"void;strict;public;private;property;"+..
	"bool;int;float;string;array;object;mod;continue;exit;"+..
	"include;import;module;extern;"+..
	"new;self;super;eachin;true;false;null;not;"+..
	"extends;abstract;final;native;select;case;default;"+..
	"const;local;global;field;method;function;class;interface;implements;"+..
	"and;or;shl;shr;end;if;then;else;elseif;endif;while;wend;repeat;until;forever;for;to;step;next;return;inline;"+..
	"#rem;"

Const MonkeyFunctions$=";"+..
	"Error;Print;LoadState;LoadString;Millisecs;SaveState;SetUpdateRate;UpdateRate;"+..
	"Cls;DeviceHeight;DeviceWidth;DrawCircle;DrawEllipse;DrawImage;DrawImageRect;DrawLine;DrawOval;DrawPoint;DrawPoly;DrawRect;DrawText;GetAlpha;GetBlend;GetColor;GetFont;GetMatrix;GetScissor;LoadImage;PopMatrix;PushMatrix;Rotate;Scale;SetAlpha;SetBlend;SetColor;SetFont;SetMatrix;SetScissor;Transform;Translate;"+..
	"AccelX;AccelY;AccelZ;DisableKeyboard;EnableKeyboard;GetChar;JoyDown;JoyHit;KeyDown;KeyHit;MouseDown;MouseHit;MouseX;MouseY;TouchDown;TouchHit;TouchX;TouchY;"+..
	"ChannelState;LoadSound;MusicState;PauseChannel;PauseMusic;PlayMusic;PlaySound;ResumeChannel;ResumeMusic;SetChannelPan;SetChannelRate;SetChannelVolume;SetMusicVolume;StopChannel;StopMusic;"+..
	"HALFPI;Pi;TWOPI;"+..
	"ACos;ACosr;ASin;ASinr;ATan;ATan2;ATan2r;ATanr;Abs;Ceil;Clamp;Cos;Cosr;Exp;Floor;Log;Max;Min;Pow;Sgn;Sin;Sinr;Sqrt;Tan;Tanr;"+..
	"List;Map;Stack;Set;FloatList;FloatMap;FloatStack;FloatSet;IntList;IntMap;IntStack;IntSet;StringList;StringMap;StringStack;StringSet;"+..
	"AppArgs;AppPath;ChangeDir;CopyDir;CopyFile;CreateDir;CurrentDir;DeleteDir;DeleteFile;Execute;ExitApp;ExtractDir;FileSize;FileTime;FileType;GetEnv;LoadDir;LoadString;RealPath;SaveString;SetEnv;StripAll;StripDir;StripExt;"

?MacOS
Global SVNCMD$="/usr/bin/svn"
Const LABELOFFSET=2
?Win32
Global SVNCMD$="svn"
Const LABELOFFSET=4
?Linux
Global SVNCMD$="/usr/bin/svn"
Const LABELOFFSET=0
?

Const MENUNEW=1
Const MENUOPEN=2
Const MENUCLOSE=3
Const MENUSAVE=4
Const MENUSAVEAS=5
Const MENUSAVEALL=6
Const MENUPRINT=7
Const MENUQUIT=8

Const MENUUNDO=9
Const MENUREDO=10
Const MENUCUT=11
Const MENUCOPY=12
Const MENUPASTE=13
Const MENUSELECTALL=14
Const MENUGOTO=15
Const MENUINDENT=16
Const MENUOUTDENT=17
Const MENUFIND=18
Const MENUFINDNEXT=19
Const MENUREPLACE=20
Const MENUNEXT=21
Const MENUPREV=22
Const MENUBUILD=23
Const MENURUN=24

Const MENUSTEP=25
Const MENUSTEPIN=26
Const MENUSTEPOUT=27
Const MENUSTOP=28

Const MENULOCKBUILD=29
Const MENUUNLOCKBUILD=30
Const MENUBUILDMODULES=31
Const MENUBUILDALLMODULES=32

Const MENUQUICKENABLED=33
Const MENUDEBUGENABLED=34
Const MENUGUIENABLED=35

Const MENUCOMMANDLINE=36
'Const MENUSYNCMODS=37
Const MENUIMPORTBB=38
Const MENUFINDINFILES=39
Const MENUPROJECTMANAGER=40
Const MENUSHOWCONSOLE=41
Const MENUOPTIONS=42

Const MENUHOME=43
Const MENUBACK=44
Const MENUFORWARD=45
Const MENUQUICKHELP=46
Const MENUABOUT=47

Const MENUNEWVIEW=48
Const MENUDOCMODS=49

Const MENUTRIGGERDOCMODS=50
Const MENUTRIGGERSYNCDOCS=51

Const MENUCLOSEALL=53

Const MENUREFRESH=54
Const MENUBROWSE=55
Const MENUSHELL=56
Const MENUPROPS=57

Const MENUUPDATE=58
Const MENUCOMMIT=59

Const MENUCLOSEOTHERS=60

Const MENUTHREADEDENABLED=61

Const MENUCANCEL=62
Const MENUESCAPE=63
Const MENUBACKSPACE=64

Const MENUREMOVE=65

Const MENURECENT=256

Const TB_BACK=0
Const TB_FORWARDS=1
Const TB_REFRESH=2
Const TB_HOME=3

Const TB_NEW=4
Const TB_OPEN=5
Const TB_CLOSE=6
Const TB_SAVE=7
Const TB_CUT=8
Const TB_COPY=9
Const TB_PASTE=10
Const TB_FIND=11
Const TB_BUILD=12
Const TB_BUILDRUN=13
Const TB_STEP=14
Const TB_STEPIN=15
Const TB_STEPOUT=16
Const TB_STOP=17
Const TB_CONTINUE=18

Const TAB$=Chr(9)
Const QUOTES$=Chr(34)

Global TEMPCOUNT
Global is_demo
Global codeplay:TCodePlay

Function CheckDemo()
	If Not is_demo Return 1
	Notify "This feature is unavailable in the demo version of BlitzMax."
	Return 0
End Function

codeplay=New TCodePlay
codeplay.Initialize

While codeplay.running
	codeplay.poll
Wend

End

Function Quote$(a$)		'add quotes to arg if spaces found
	Local	p
	If Not a.length Return
	If a[0]=34 Return a	'already quoted
	p=a.find(" ")
	If p=-1 Return a	'no spaces
	Return Chr(34)+a+Chr(34)		
End Function

Type TToken
	Field token$
	Field help$
	Field anchor$	
	Field key
	Method Create:TToken(t$,h$,a$,keyword)
		token=t
		help=h
		anchor=a
		key=keyword
		Return Self
	End Method
End Type

Type TQuickHelp
	Field map:TMap=New TMap	'key=lower(token) value=token:TToken
		
	Method AddCommand:TQuickHelp(t$,l$,a$,keyword=True)
		map.Insert t.ToLower(),New TToken.Create(t$,l$,a$,keyword)
	End Method
	
	Method Token$(cmd$)
		Local t:TToken = TToken(map.ValueForKey(cmd.toLower()))
		If t 
			If t.key Return t.token	'keywords get capitalized
			If cmd=t.token Return cmd
		EndIf
	End Method

	Method Key(cmd$)
		Local t:TToken = TToken(map.ValueForKey(cmd.toLower()))
		If t Return t.key
	End Method
	
	Method Help$(cmd$)
		Local t:TToken = TToken(map.ValueForKey(cmd.toLower()))
		If t Return t.help
	End Method
	
	Method Link$(cmd$)
		Local t:TToken = TToken(map.ValueForKey(cmd.toLower()))
		If t Return t.anchor
	End Method

	Function LoadMonkeyCommands:TQuickHelp(monkeypath$,host:TCodePlay)
		Local	qh:TQuickHelp
		Local	i,c,p,q
		Local	token$,help$,anchor$
		
		qh=New TQuickHelp

		For Local l$ = EachIn MonkeyWords.Split(";")

			If l="" Continue
		
			token=l
			help=""
			anchor=""
			
			q=l.findlast("|")
			If q>=0
				help=l[..q]
				anchor=l[q+1..]
			EndIf			

			token=l[..1].ToUpper()+l[1..]
			anchor="wiki:"+token

			qh.AddCommand token,help,anchor			
			qh.AddCommand token,help,anchor
		Next
		
		For Local l$ = EachIn MonkeyFunctions.Split(";")
			token=l
			help="press F1 again to jump see docs on "+l	'TODO: quickhelp array please
			anchor$="wiki:"+l
			qh.AddCommand token,help,anchor,False
		Next

'		qh.ParseHelp monkeypath,"/docs/Modules"
		
		Return qh
	End Function
	
	
	Function LoadCommandsTxt:TQuickHelp(bmxpath$)
		Local	text$
		Local	qh:TQuickHelp
		Local	i:Int,c,p,q
		Local	token$,help$,anchor$
		Try
			text=CacheAndLoadText(bmxpath+"/docs/html/Modules/commands.txt")
		Catch exception:Object
			Return Null
		EndTry
		If Not text Return Null
		qh=New TQuickHelp
		For Local l$ = EachIn Text.Split("~n")
			For i=0 Until l.length
				c=l[i]
				If c=Asc("_") Continue
				If c>=Asc("0") And c<=Asc("9") Continue
				If c>=Asc("a") And c<=Asc("z") Continue
				If c>=Asc("A") And c<=Asc("Z") Continue
				Exit
			Next
			token$=l[..i]
			help$=""
			anchor$=""
			q=l.findlast("|")
			If q>=0
				help=l[..q]
				anchor=l[q+1..]
			EndIf			
			qh.AddCommand token,help,anchor
		Next
		Return qh
	End Function
End Type

Const TOOLSHOW=1
Const TOOLREFRESH=2
Const TOOLNEW=3
Const TOOLOPEN=4
Const TOOLCLOSE=5
Const TOOLSAVE=6
Const TOOLHELP=7
Const TOOLUNDO=8
Const TOOLREDO=9
Const TOOLCUT=10
Const TOOLCOPY=11
Const TOOLPASTE=12
Const TOOLQUICKSAVE=13
Const TOOLSAVEAS=14
Const TOOLGOTO=15
Const TOOLFIND=16
Const TOOLFINDNEXT=17
Const TOOLREPLACE=18
Const TOOLBUILD=19
Const TOOLRUN=20
Const TOOLLOCK=21
Const TOOLUNLOCK=22
Const TOOLSELECT=23
Const TOOLSELECTALL=24
Const TOOLINDENT=25
Const TOOLOUTDENT=26
Const TOOLACTIVATE=27
Const TOOLNAVIGATE=28
Const TOOLNEWVIEW=29
Const TOOLMENU=30
Const TOOLPRINT=31
Const TOOLERROR=32
Const TOOLOUTPUT=32
Const TOOLARCHIVE=33
Const TOOLHISTORY=34
Const TOOLINDEX=35
Const TOOLESCAPE=36
Const TOOLBACKSPACE=37
Const TOOLCRAWL=38

Type TTool
	Method Invoke(command,argument:Object=Null)
	End Method
End Type

Type TRequester
	
	Const STYLE_OK% = 1, STYLE_CANCEL% = 2
	Const STYLE_DIVIDER% = 4, STYLE_STATUS% = 8
	Const STYLE_RESIZABLE% = 16, STYLE_STDBORDER% = 32
	Const STYLE_MODAL% = 64

	Field	host:TCodePlay
	Field	window:TGadget,ok:TGadget,cancel:TGadget,divider:TGadget
	Field	centered, modal

	Method initrequester(owner:TCodeplay,label$,w=260,h=60,flags=STYLE_OK|STYLE_CANCEL|STYLE_DIVIDER,oktext$="OK")
		
		host=owner
		If (flags&STYLE_MODAL) Then flags:|STYLE_STDBORDER
		
		If (flags & (STYLE_CANCEL|STYLE_OK)) Then h:+32;If (flags&STYLE_DIVIDER) Then h:+12
		
		Local windowflags% = WINDOW_TITLEBAR|WINDOW_HIDDEN|WINDOW_CLIENTCOORDS
		If (flags & STYLE_STATUS) Then windowflags:|WINDOW_STATUS
		If (flags & STYLE_RESIZABLE) Then windowflags:|WINDOW_RESIZABLE
		If Not (flags & STYLE_STDBORDER) Then windowflags:|WINDOW_TOOL
		
		window=CreateWindow(label,0,0,w,h,host.window,windowflags)
		
		If (flags & STYLE_RESIZABLE) Then
			If (flags & STYLE_STDBORDER) Then SetMaxWindowSize(window,ClientWidth(Desktop()),ClientHeight(Desktop()))
			SetMinWindowSize(window,w,h)
		EndIf
		
		If (flags & STYLE_OK) Then
			
			ok=CreateButton(oktext,ClientWidth(window)-101,ClientHeight(window)-32,95,26,window,BUTTON_OK)
			SetGadgetLayout(ok,EDGE_CENTERED,EDGE_ALIGNED,EDGE_CENTERED,EDGE_ALIGNED)
			
			If (flags & STYLE_CANCEL) Then
				cancel=CreateButton("Cancel",6,ClientHeight(window)-32,95,26,window,BUTTON_CANCEL)
				SetGadgetLayout(cancel,EDGE_ALIGNED,EDGE_CENTERED,EDGE_CENTERED,EDGE_ALIGNED)
			EndIf
			
		Else
			If (flags & STYLE_CANCEL) Then
				cancel=CreateButton("Close",ClientWidth(window)-101,ClientHeight(window)-32,95,26,window,BUTTON_CANCEL)
				SetGadgetLayout(cancel,EDGE_CENTERED,EDGE_ALIGNED,EDGE_CENTERED,EDGE_ALIGNED)
			EndIf
		EndIf
		
		If (flags & STYLE_DIVIDER) And (flags & (STYLE_OK|STYLE_CANCEL)) Then
			divider = CreateLabel( "", 6, ClientHeight(window)-42, ClientWidth(window)-12, 4, window, LABEL_SEPARATOR )
			SetGadgetLayout(divider,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_CENTERED,EDGE_ALIGNED)
		EndIf
		
		If (flags & STYLE_MODAL) Then modal = True Else modal = False
	
	End Method
	
	Method Show()
		Local	x,y,w,h,win:TGadget
		If Not centered
			win=host.window		
			w=GadgetWidth(window)
			h=GadgetHeight(window)
			x=GadgetX(win)+(GadgetWidth(win)-w)/2
			y=GadgetY(win)+(GadgetHeight(win)-h)/2
			SetGadgetShape window,x,y,w,h
			centered=True
		EndIf
		host.HookRequester Self
		ShowGadget window
		ActivateGadget window
		PollSystem
	End Method
	
	Method Hide()
		EnableGadget host.window
		HideGadget window
		host.UnhookRequester Self
		host.SelectPanel host.currentpanel
	End Method
	
	Method IsModal()
		Return modal
	EndMethod
	
	Method Poll()
	End Method
End Type

Type TPanelRequester Extends TRequester
	Field	tabber:TGadget
	Field	panels:TGadget[]
	Field	index
	
	Method InitPanelRequester(owner:TCodeplay,label$,w=280,h=128)		
		InitRequester owner,label,w,h,STYLE_OK|STYLE_CANCEL|STYLE_STDBORDER|STYLE_MODAL
		tabber=CreateTabber(6,6,w-12,h-12,window)
		SetGadgetLayout tabber,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED
	End Method

	Method SetPanelIndex(i)
		HideGadget panels[index]
		index=i
		ShowGadget panels[index]
		SelectGadgetItem tabber,index	
	End Method
	
	Method SetPanel(panel:TGadget)
		Local	i
		For Local p:TGadget = EachIn panels
			If p=panel SetPanelIndex i;Exit
			i:+1
		Next
	End Method
	
	Method AddPanel:TGadget(name$)
		Local	panel:TGadget
		panel=CreatePanel(0,0,ClientWidth(tabber),ClientHeight(tabber),tabber)
		SetGadgetLayout panel,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED
		HideGadget panel
		AddGadgetItem tabber,name
		panels=panels[..panels.length+1]
		panels[panels.length-1]=panel
		Return panel
	End Method
	
	Method RemovePanel(panel)
	End Method
	
End Type

Type TCmdLineRequester Extends TRequester
	Field	label:TGadget,textfield:TGadget

	Method Poll()
		Select EventSource()
			Case window
				If EventID()=EVENT_WINDOWCLOSE
					Hide
				EndIf
			Case ok
				If EventID()=EVENT_GADGETACTION
					host.SetCommandLine TextFieldText(textfield)
					Hide
				EndIf			
			Case cancel
				If EventID()=EVENT_GADGETACTION
					SetGadgetText textfield,host.GetCommandLine()
					Hide
				EndIf
			Default
				Return 0
		End Select
		Return 1
	End Method
	
	Method Show()
		SetGadgetText textfield,host.GetCommandLine()
		Super.Show()
		ActivateGadget textfield
	End Method

	Function Create:TCmdLineRequester(host:TCodePlay)
		Local	cmd:TCmdLineRequester = New TCmdLineRequester
		cmd.initrequester(host,"Program Command Line",260,60,STYLE_OK|STYLE_CANCEL|STYLE_DIVIDER|STYLE_MODAL)
		cmd.label=CreateLabel("Program command line",6,8,260,20,cmd.window)
		cmd.textfield=CreateTextField(6,30,ClientWidth(cmd.window)-12,21,cmd.window)
		Return cmd
	End Function
End Type

Type TGotoRequester Extends TRequester
	Field	linenumber:TGadget

	Method Show()
		Super.Show()
		ActivateGadget linenumber
	End Method

	Method Poll()
		Local	Line,data,Text$
		Select EventSource()
			Case linenumber
				If EventID() = EVENT_GADGETACTION
					Text = GadgetText(linenumber)
					If Text And (Int(Text) <> Text) Then SetGadgetText linenumber, Int(Text)
				EndIf
			Case window
				If EventID()=EVENT_WINDOWCLOSE
					Hide
				EndIf
			Case ok
				Line=Int(GadgetText(linenumber))
				Hide
				host.activepanel.Invoke TOOLGOTO,String(Line)
			Case cancel
				Hide
			Default
				Return 0
		End Select
		Return 1
	End Method

	Function Create:TGotoRequester(host:TCodePlay)
		Local	seek:TGotoRequester = New TGotoRequester
		seek.initrequester(host,"Goto Line",260,66,STYLE_OK|STYLE_CANCEL|STYLE_DIVIDER|STYLE_MODAL,"Goto")
		CreateLabel("Line Number",6,8+4,114,20,seek.window)
		seek.linenumber=CreateTextField(150,8,ClientWidth(seek.window)-(150+6),21,seek.window)
		SetGadgetFilter( seek.linenumber, IntegerFilter )
		Return seek
	End Function
	
	Function IntegerFilter:Int( event:TEvent, context:Object )
		Select event.id
			Case EVENT_KEYCHAR
				If event.data >= Asc("0") And event.data <= Asc("9") Return True
				If event.data = 8 Or event.data = 127 Or event.data = 13 Return True
				Return False
			Case EVENT_KEYDOWN
				Return True
		EndSelect
	EndFunction
	
End Type

Type TColor
	Field	red,green,blue

	Method Set(rgb)
		red=(rgb Shr 16)&$FF
		green=(rgb Shr 8)&$FF
		blue=rgb&$FF
	End Method

	Method ToString$()
		Return ""+red+","+green+","+blue
	End Method

	Method FromString(s$)
		Local	p=s.Find(",")+1
		If Not p Return
		Local q=s.Find(",",p)+1
		If Not q Return
		red=Int(s[..p-1])
		green=Int(s[p..q-1])
		blue=Int(s[q..])
	End Method

	Method Request()
		If RequestColor(red,green,blue)
			red=RequestedRed()
			green=RequestedGreen()
			blue=RequestedBlue()
			Return True
		EndIf				
	End Method	
End Type

Type TTextStyle

	Field	label:TGadget,panel:TGadget,combo:TGadget
	Field	underline:TGadget, Color:TColor
	Field	flags
	
	Method Set(rgb,bolditalic)
		Color.set(rgb)
		flags=bolditalic
	End Method

	Method Format(textarea:TGadget,pos,length,emphasise:Int = False)
		Local tmpFlags:Int = flags
		If emphasise Then tmpFlags:|TEXTFORMAT_BOLD
		FormatTextAreaText textarea,Color.red,Color.green,Color.blue,tmpFlags,pos,length
	End Method

	Method ToString$()
		Return ""+Color.red+","+Color.green+","+Color.blue+","+flags
	End Method

	Method FromString(s$)
		Local	p,q,r
		p=s.Find(",")+1;If Not p Return
		q=s.Find(",",p)+1;If Not q Return
		r=s.Find(",",q)+1;If Not r Return
		Color.red=Int(s[..p-1])
		Color.green=Int(s[p..q-1])
		Color.blue=Int(s[q..r-1])
		flags=Int(s[r..])
	End Method

	Method Poll()
		Select EventSource()
			Case panel
				If EventID()=EVENT_MOUSEDOWN
					Return Color.Request()
				EndIf
			Case combo
				flags=(flags&~3)|SelectedGadgetItem(combo)
				Return True
			Case underline
				If EventData() Then flags:|TEXTFORMAT_UNDERLINE Else flags:&~TEXTFORMAT_UNDERLINE
				Return True
		End Select
	End Method
	
	Method Refresh()
		SetPanelColor panel,Color.red,Color.green,Color.blue
		SelectGadgetItem combo,flags&3
		SetButtonState(underline,(flags&TEXTFORMAT_UNDERLINE <> 0))
	End Method

	Function Create:TTextStyle(name$,xpos,ypos,window:TGadget)
		Local	s:TTextStyle
		s=New TTextStyle
		s.Color=New TColor
		s.label=CreateLabel(name,xpos,ypos+4,90,24,window)
		s.panel=CreatePanel(xpos+94,ypos,24,24,window,PANEL_BORDER|PANEL_ACTIVE)
		SetPanelColor s.panel,255,255,0
		s.combo=CreateComboBox(xpos+122,ypos,96,24,window)
		s.underline=CreateButton("Underline",xpos+226,ypos,ClientWidth(window)-(xpos+220),24,window,BUTTON_CHECKBOX)
		AddGadgetItem s.combo,"Normal"
		AddGadgetItem s.combo,"Bold"
		AddGadgetItem s.combo,"Italic"
		AddGadgetItem s.combo,"Bold + Italic"
		Return s
	End Function
End Type

Function SetContainerColor(gadget:TGadget,c:TColor,level)
	Local p:TGadget
	
	If level=1 p=gadget.parent.parent.parent
	If level=2 p=gadget.parent.parent
	If level=3 p=gadget.parent

	If c
		SetGadgetColor p,c.red,c.green,c.blue,True
	Else
		RemoveGadgetColor p
	EndIf

End Function

Type TGadgetStyle
	
	Global fntLibrary:TGUIFont[] =	[TGuiFont(Null), LookupGuiFont(GUIFONT_SYSTEM), LookupGuiFont(GUIFONT_MONOSPACED), ..
							LookupGuiFont(GUIFONT_SANSSERIF), LookupGuiFont(GUIFONT_SERIF), ..
							LookupGuiFont(GUIFONT_SCRIPT) ]

	Field label:TGadget,fpanel:TGadget,bpanel:TGadget,fcombo:TGadget,fbutton:TGadget
	Field font_name$
	Field font_size:Double
	Field fg:TColor
	Field bg:TColor
	Field font_type = GUIFONT_SYSTEM, font:TGUIFont = fntLibrary[font_type]

	Method Apply(gadget:TGadget,container=0,colorcontainer=False)
		SetGadgetFont gadget,font
		SetGadgetColor gadget,bg.red,bg.green,bg.blue,True
		SetGadgetColor gadget,fg.red,fg.green,fg.blue,False
		If container
			If colorcontainer		
				SetContainerColor gadget,bg,container
			Else
				SetContainerColor gadget,Null,container
			EndIf			
		EndIf
	End Method
	
	Method Set(fg_rgb,bg_rgb,ftype,fname$="",fsize=0)
		fg.set(fg_rgb)
		bg.set(bg_rgb)
		If Not fntLibrary[ftype] Then
			font_name=fname
			font_size=fsize
		Else
			font_name=FontName(fntLibrary[ftype])
			font_size=FontSize(fntLibrary[ftype])
		EndIf
		font_type=ftype
	End Method

	Method ToString$()
		Return font_name+","+font_size+","+fg.ToString()+","+bg.ToString()+","+font_type
	End Method
	
	Function GetArg$(a$ Var)
		Local p = a.Find(",")
		If p=-1 Then p=a.length
		Local r$ = a$[..p]
		a$=a$[p+1..]
		Return r$
	End Function
	
	Method FromString(s$)		
		font_name=GetArg(s$)
		font_size=Double(GetArg(s$))
		fg.red=Int(GetArg(s$))
		fg.green=Int(GetArg(s$))
		fg.blue=Int(GetArg(s$))
		bg.red=Int(GetArg(s$))
		bg.green=Int(GetArg(s$))
		bg.blue=Int(GetArg(s$))
		font_type=Int(GetArg(s$))
		If fntLibrary[font_type] Then
			font_name=FontName(fntLibrary[font_type])
			font_size=FontSize(fntLibrary[font_type])
		EndIf
	End Method

	Method Poll()
		Local	f:TGUIFont
		Select EventSource()
			Case fpanel
				If EventID()=EVENT_MOUSEDOWN
					Return fg.Request()
				EndIf
			Case bpanel
				If EventID()=EVENT_MOUSEDOWN
					Return bg.Request()
				EndIf
			Case fcombo, fbutton
				If EventSource() = fcombo Then
					If Not (EventData() < 0) Then
						font_type = EventData()
						f = fntLibrary[font_type]
					EndIf
				Else
					font_type = 0
					SelectGadgetItem fcombo, font_type
				EndIf
				If Not f Then f=RequestFont(font)
				If f
					font_name=FontName(f)
					font_size=FontSize(f)
					Return True
				EndIf				
		End Select
	End Method
	
	Method Refresh()
		font=fntLibrary[font_type]
		If Not font Then font=LoadGuiFont(font_name,font_size)
		SetPanelColor fpanel,fg.red,fg.green,fg.blue
		SetPanelColor bpanel,bg.red,bg.green,bg.blue
		SelectGadgetItem fcombo, font_type
		Local tmpFloatText$[] = String(font_size).Split(".")
		If tmpFloatText.length > 1 Then tmpFloatText[1] = tmpFloatText[1][..Min(2,tmpFloatText[1].length)]
		SetGadgetText fbutton,font_name+" : "+".".Join(tmpFloatText)+"pt"
	End Method

	Function Create:TGadgetStyle(name$,xpos,ypos,window:TGadget)
		Local	s:TGadgetStyle
		s=New TGadgetStyle
		s.fg=New TColor
		s.bg=New TColor
		s.label=CreateLabel(name,xpos,ypos+LABELOFFSET,66,50,window)
		s.fpanel=CreatePanel(xpos+68,ypos,24,24,window,PANEL_BORDER|PANEL_ACTIVE)
		s.bpanel=CreatePanel(xpos+96,ypos,24,24,window,PANEL_BORDER|PANEL_ACTIVE)
		s.fbutton=CreateButton("..",xpos+122,ypos+30,ClientWidth(window)-(xpos+128),24,window)
		s.fcombo=CreateComboBox(xpos+122,ypos,ClientWidth(window)-(xpos+128),24,window)
		AddGadgetItem s.fcombo, "User Defined Font", GADGETITEM_DEFAULT
		AddGadgetItem s.fcombo, "GUI Default Font"
		AddGadgetItem s.fcombo, "Monospaced Font"
		AddGadgetItem s.fcombo, "Sans Serif Font"
		AddGadgetItem s.fcombo, "Serif Font"
		AddGadgetItem s.fcombo, "Script Font"
		Return s
	End Function
End Type

Const NORMAL=0
Const COMMENT=1
Const QUOTED=2
Const KEYWORD=3
Const NUMBER=4
Const MATCHING=5

Type TOptionsRequester Extends TPanelRequester
' panels
	Field configpanel:TGadget
	Field optionspanel:TGadget
	Field editorpanel:TGadget
	Field toolpanel:TGadget
' settings
	Field showtoolbar,restoreopenfiles,autocapitalize,syntaxhighlight,autobackup,autoindent,hideoutput
	Field bracketmatching, externalhelp,systemkeys,sortcode,archivecode,runserver,colorcontainers,offlinedocs
	Field tabsize
	Field editfontname$,editfontsize
	Field editcolor1:TColor
	Field editcolor2:TColor
	Field outputfontname$,outputfontsize,outputcolor:TColor
' exter tools	
	Field activetarget$
	Field activetemplate$
' states
	Field editfont:TGUIFont
' gadgets
	Field bmxfolder:TGadget[2]
	Field monkeyfolder:TGadget[2]

	Field tabbutton:TGadget
	Field editpanel1:TGadget
	Field editpanel2:TGadget
	Field editbutton:TGadget
	Field buttons:TGadget[16]
	Field styles:TTextStyle[]
	Field textarea:TGadget
	Field outputstyle:TGadgetStyle
	Field navstyle:TGadgetStyle
	Field dirty
	Field undo:TBank

	Method Show()
		RefreshGadgets()
		Super.Show()
	EndMethod
	
	Method Snapshot()
		If Not undo undo=CreateBank(8192)
		Local stream:TStream=CreateBankStream(undo)
		Write stream
		stream.close
	End Method
	
	Method Restore()
		If Not undo Return
		Local stream:TStream=CreateBankStream(undo)
		Read stream
		stream.close
	End Method

	Method SetDefaults()
		
		archivecode=True
		bracketmatching=True
		showtoolbar=True
		colorcontainers=False
		offlinedocs=False
		
		restoreopenfiles=True
		autocapitalize=True 
		syntaxhighlight=True
		autobackup=False
		
		autoindent=True
		tabsize=4
		activetarget="html5"
		activetemplate="monkey app"

		'marks!
		?Win32
		editfontname$="Courier New"
		editfontsize=12
		
		?Macos
		editfontname$="Monaco"
		editfontsize=12
		?
		
		editcolor1.set( $f0f8ff )		'non-monkey
		editcolor2.set( $ffffff )		'monkey
		styles[NORMAL].set( $000000,0 )
		styles[COMMENT].set( $ff0000,0 )
		styles[QUOTED].set( $ff00ff,0 )
		styles[KEYWORD].set( $0000ff,0 )
		styles[NUMBER].set( $000000,0 )
		styles[MATCHING].set( $000000,0 )
		
		Rem
		editfontname$=FontName(TGadgetStyle.fntLibrary[GUIFONT_MONOSPACED])
		editfontsize=FontSize(TGadgetStyle.fntLibrary[GUIFONT_MONOSPACED])
		editcolor1.set( $334455 )
		editcolor2.set( $404040 )
		styles[NORMAL].set( $ffffff,0 )
		styles[COMMENT].set( $bbeeff,0 )
		styles[QUOTED].set( $00ff66,0 )
		styles[KEYWORD].set( $ffff00,0 )
		styles[NUMBER].set( $40ffff,0 )
		styles[MATCHING].set( $99aadd,0 )
		EndRem
		
		outputstyle.set(0,-1,GUIFONT_MONOSPACED)
		navstyle.set(0,-1,GUIFONT_SYSTEM)
		RefreshGadgets
	End Method

	Method Write(stream:TStream)
		stream.WriteLine "[Options]"
		stream.WriteLine "showtoolbar="+showtoolbar
		stream.WriteLine "restoreopenfiles="+restoreopenfiles
		stream.WriteLine "autoformat="+autocapitalize
		stream.WriteLine "syntaxhighlight="+syntaxhighlight
		stream.WriteLine "bracketmatching="+bracketmatching
		stream.WriteLine "autobackup="+autobackup
		stream.WriteLine "autoindent="+autoindent
		stream.WriteLine "tabsize="+tabsize
		stream.WriteLine "activetarget="+activetarget
		stream.WriteLine "activetemplate="+activetemplate
		stream.WriteLine "editfontname="+editfontname
		stream.WriteLine "editfontsize="+editfontsize
		stream.WriteLine "editcolor="+editcolor1.ToString()
		stream.WriteLine "editcolor2="+editcolor2.ToString()
		stream.WriteLine "normal_style="+styles[NORMAL].ToString()
		stream.WriteLine "comment_style="+styles[COMMENT].ToString()
		stream.WriteLine "quote_style="+styles[QUOTED].ToString()
		stream.WriteLine "keyword_style="+styles[KEYWORD].ToString()
		stream.WriteLine "number_style="+styles[NUMBER].ToString()
		stream.WriteLine "matched_style="+styles[MATCHING].ToString()
		stream.WriteLine "console_style="+outputstyle.ToString()	'Renamed from 'output_style' to bump users to default monospace font.
		stream.WriteLine "navi_style="+navstyle.ToString()	'Renamed from 'nav_style' to bump users to default treeview font.
		stream.WriteLine "hide_output="+hideoutput
		stream.WriteLine "external_help="+externalhelp
		stream.WriteLine "system_keys="+systemkeys
		stream.WriteLine "sort_code="+sortcode
		stream.WriteLine "archive_code="+archivecode
		stream.WriteLine "run_server="+runserver
		stream.WriteLine "color_containers="+colorcontainers
		stream.WriteLine "offline_docs="+offlinedocs
	End Method

	Method Read(stream:TStream)
		Local	f$,p,a$,b$,t
		While Not stream.Eof()
			f$=stream.ReadLine()
			If f$="" Or (f$[..1]="[" And f$<>"[Options]") Exit
			p=f.find("=")
			a$=f[..p]
			b$=f[p+1..]
			t=Int(b)
			Select a$
				Case "showtoolbar" showtoolbar=t
				Case "restoreopenfiles" restoreopenfiles=t
				Case "autoformat" autocapitalize=t
				Case "syntaxhighlight" syntaxhighlight=t
				Case "bracketmatching" bracketmatching=t
				Case "autobackup" autobackup=t
				Case "autoindent" autoindent=t
				Case "tabsize" tabsize=t		
				Case "activetarget" activetarget=b
				Case "activetemplate" activetemplate=b
				Case "editfontname" editfontname=b
				Case "editfontsize" editfontsize=t
				Case "editcolor" editcolor1.FromString(b)		
				Case "editcolor2" editcolor2.FromString(b)		
				Case "normal_style" styles[NORMAL].FromString(b)
				Case "comment_style" styles[COMMENT].FromString(b)
				Case "quote_style" styles[QUOTED].FromString(b)
				Case "keyword_style" styles[KEYWORD].FromString(b)
				Case "number_style" styles[NUMBER].FromString(b)
				Case "matched_style" styles[MATCHING].FromString(b)
				Case "console_style" outputstyle.FromString(b)	'Renamed from 'output_style' to bump users to default monospace font.
				Case "navi_style" navstyle.FromString(b)	'Renamed from 'nav_style' to bump users to default treeview font.
				Case "hide_output" hideoutput=t
				Case "external_help" externalhelp=t
				Case "system_keys" systemkeys=t
				Case "sort_code" sortcode=t
				Case "archive_code" archivecode=t
				Case "run_server" runserver=t
				Case "color_containers" colorcontainers=t
				Case "offline_docs" offlinedocs=t
			End Select
		Wend		
		RefreshGadgets
	End Method
	
	Method RefreshGadgets()
		Local rgb:TColor,flags
		editfont=LoadGuiFont(editfontname,editfontsize)

		SetGadgetText(bmxfolder[0], host.bmxpath)
		SetGadgetText(monkeyfolder[0], host.monkeypath)
				
		SetButtonState buttons[0],showtoolbar
		SetButtonState buttons[1],restoreopenfiles
		SetButtonState buttons[2],autocapitalize
		SetButtonState buttons[3],syntaxhighlight
		SetButtonState buttons[4],bracketmatching
		SetButtonState buttons[5],autobackup
		SetButtonState buttons[6],autoindent
		SetButtonState buttons[7],hideoutput
		SetButtonState buttons[8],externalhelp
		SetButtonState buttons[9],systemkeys
		SetButtonState buttons[10],sortcode
		SetButtonState buttons[11],archivecode
		SetButtonState buttons[12],runserver
		SetButtonState buttons[13],colorcontainers
		SetButtonState buttons[14],offlinedocs
		
		SelectGadgetItem tabbutton,Min(Max(tabsize/2-1,0),7)
		SetPanelColor editpanel1,editcolor1.red,editcolor1.green,editcolor1.blue
		SetPanelColor editpanel2,editcolor2.red,editcolor2.green,editcolor2.blue
		SetGadgetText editbutton,editfontname+" : "+editfontsize + "pt"
		For Local i:Int = 0 Until styles.length
			styles[i].Refresh
		Next
		LockTextArea textarea
		SetTextAreaColor textarea,editcolor2.red,editcolor2.green,editcolor2.blue,True
		SetGadgetFont textarea,editfont
		styles[NORMAL].format(textarea,0,TEXTAREA_ALL)
		styles[COMMENT].format(textarea,0,12)
		styles[MATCHING].format(textarea,24,1)
		styles[NUMBER].format(textarea,25,3)
		styles[NUMBER].format(textarea,31,1)
		styles[MATCHING].format(textarea,32,1)
		styles[NUMBER].format(textarea,36,1)
		styles[KEYWORD].format(textarea,39,5)
		styles[QUOTED].format(textarea,46,10)
		UnlockTextArea textarea
		outputstyle.Refresh
		navstyle.Refresh
		dirty=True
	End Method

	Method Poll()
		Local font:TGUIFont
		Local refresh
		Local processed = 1
		Local path$
		For Local i:Int = 0 Until styles.length
			refresh:|styles[i].Poll()
		Next
		refresh:|outputstyle.Poll()
		refresh:|navstyle.Poll()
		Select EventID()
			Case EVENT_GADGETACTION, EVENT_WINDOWCLOSE
				Select EventSource()
				
					Case bmxfolder[1]
						path=RequestDir("Locate BlitzMax Installation")
						If path And FileType(path)=FILETYPE_DIR
							host.bmxpath=path
							SetGadgetText bmxfolder[0],path
							host.InitBMXPaths
						EndIf
					
					Case monkeyfolder[1]
						path=RequestDir("Locate Monkey Installation")
						If path And FileType(path)=FILETYPE_DIR
							host.monkeypath=path
							SetGadgetText monkeyfolder[0],path
							host.InitMonkeyPaths
						EndIf				
				
					Case buttons[0];showtoolbar=ButtonState(buttons[0]);dirty=1
					Case buttons[1];restoreopenfiles=ButtonState(buttons[1])
					Case buttons[2];autocapitalize=ButtonState(buttons[2]);dirty=1
					Case buttons[3];syntaxhighlight=ButtonState(buttons[3]);dirty=1
					Case buttons[4];bracketmatching=ButtonState(buttons[4])
					Case buttons[5];autobackup=ButtonState(buttons[5])
					Case buttons[6];autoindent=ButtonState(buttons[6])
					Case buttons[7];hideoutput=ButtonState(buttons[7])
					Case buttons[8];externalhelp=ButtonState(buttons[8])
					Case buttons[9];systemkeys=ButtonState(buttons[9]);dirty=2
					Case buttons[10];sortcode=ButtonState(buttons[10]);dirty=3
					Case buttons[11];archivecode=ButtonState(buttons[11]);dirty=3
					Case buttons[12];runserver=ButtonState(buttons[12]);dirty=3
					Case buttons[13];colorcontainers=ButtonState(buttons[13]);dirty=1
					Case buttons[14];offlinedocs=ButtonState(buttons[14])
					Case tabber;SetPanelIndex SelectedGadgetItem(tabber)
					Case ok
						Hide()
						Select dirty
							Case 1
								host.RefreshAll
							Case 2
								host.Restart
							Case 3
								host.Rethink
						End Select
						dirty=False
						SnapShot()
					Case window
						If EventID()=EVENT_WINDOWCLOSE
							Restore()
							dirty=False
							Hide()
						EndIf
					Case cancel
						Restore()
						dirty=False
						Hide()
					Case tabbutton
						tabsize=(SelectedGadgetItem(tabbutton)+1)*2
						refresh=True
					Case editpanel1
						If EventID()=EVENT_MOUSEDOWN
							refresh=editcolor1.Request()
						EndIf
					Case editpanel2
						If EventID()=EVENT_MOUSEDOWN
							refresh=editcolor2.Request()
						EndIf
					Case editbutton
						font=RequestFont(editfont)
						If font
							editfontname=FontName(font)
							editfontsize=FontSize(font)
							refresh=True
						EndIf
					Default
						processed = 0
				EndSelect
			Case EVENT_MOUSEDOWN
				Select EventSource()
					Case editpanel1
						If EventID()=EVENT_MOUSEDOWN
							editcolor1.Request()
							refresh=True
						EndIf
					Case editpanel2
						If EventID()=EVENT_MOUSEDOWN
							editcolor2.Request()
							refresh=True
						EndIf
					Default
						processed = 0
				EndSelect
		EndSelect
		If refresh Then RefreshGadgets()
		Return processed
	End Method
	
	Method InitOptionsRequester(host:TCodePlay)		
		Local w:TGadget
		Local cw
		InitPanelRequester(host,"Options",380,430)
' init values for text background
		editcolor1=New TColor
		editcolor2=New TColor
' init gadgets
		configpanel=AddPanel("Tools")
		optionspanel=AddPanel("Options")
		editorpanel=AddPanel("Editor")
		toolpanel=AddPanel("Tools")
		
		w=configpanel		
		cw=ClientWidth(w)
		Local cy
		
		cy=6		
		CreateLabel("BlitzMax Path",6,cy,90,24,w)
		bmxfolder[0]=CreateComboBox(6,cy+32,cw-70,26,w,COMBOBOX_EDITABLE)
		bmxfolder[1]=CreateButton("..",cw-50,CY+30,34,26,w)

		cy:+80
		CreateLabel("Monkey Path",6,cy,90,24,w)
		monkeyfolder[0]=CreateComboBox(6,cy+32,cw-70,26,w,COMBOBOX_EDITABLE)
		monkeyfolder[1]=CreateButton("..",cw-50,cy+30,34,26,w)	

		w=optionspanel		
		cw=ClientWidth(w)
		buttons[0]=CreateButton("Show Toolbar",6,6,cw-12,26,w,BUTTON_CHECKBOX)
		buttons[1]=CreateButton("Open Files at Startup",6,34,cw-12,26,w,BUTTON_CHECKBOX)
		buttons[2]=CreateButton("Auto Capitalize",6,60,cw-12,26,w,BUTTON_CHECKBOX)
		buttons[3]=CreateButton("Syntax Highlighting",6,86,cw-12,26,w,BUTTON_CHECKBOX)
		buttons[4]=CreateButton("Enable .bmx Bracket Matching",6,112,cw-12,26,w,BUTTON_CHECKBOX)
		buttons[5]=CreateButton("Auto Backup"+" to .bak",6,138,cw-12,26,w,BUTTON_CHECKBOX)
		buttons[6]=CreateButton("Auto Indent",6,164,cw-12,26,w,BUTTON_CHECKBOX)
		buttons[7]=CreateButton("Hide Output When Process Completes",6,190,cw-12,26,w,BUTTON_CHECKBOX)
		buttons[8]=CreateButton("Use External Help Browser",6,216,cw-12,26,w,BUTTON_CHECKBOX)
		buttons[9]=CreateButton("Use OS Specific Shortcut Keys",6,242,cw-12,26,w,BUTTON_CHECKBOX)
		buttons[10]=CreateButton("Sort Nodes in Code View",6,268,cw-12,26,w,BUTTON_CHECKBOX)
		buttons[11]=CreateButton("Archive Code",6,292,cw-12,26,w,BUTTON_CHECKBOX)
		buttons[12]=CreateButton("Internal HTTP Server on localhost:8080",6,316,cw-12,26,w,BUTTON_CHECKBOX)
		buttons[13]=CreateButton("Color Containers",6,340,cw-12,26,w,BUTTON_CHECKBOX)
		buttons[14]=CreateButton("Offline Docs",6,364,cw-12,26,w,BUTTON_CHECKBOX)

		w=editorpanel
		cw=ClientWidth(w)
		CreateLabel("Background",6,6+4,90,24,w)
		editpanel1=CreatePanel(100,6,24,24,w,PANEL_BORDER|PANEL_ACTIVE)
		editpanel2=CreatePanel(100,32,24,24,w,PANEL_BORDER|PANEL_ACTIVE)
		editbutton=CreateButton("..",128,6,cw-134,24,w)
		
		tabbutton=CreateComboBox(128,36,cw-134,24,w)
		For Local i=1 To 8
			AddGadgetItem tabbutton,"Tab Size:"+(i*2)
		Next
		
		styles=New TTextStyle[6]
		styles[NORMAL]=TTextStyle.Create("Plain Text",6,66,w)
		styles[COMMENT]=TTextStyle.Create("Remarks",6,96,w)
		styles[QUOTED]=TTextStyle.Create("Strings",6,126,w)
		styles[KEYWORD]=TTextStyle.Create("Keywords",6,156,w)
		styles[NUMBER]=TTextStyle.Create("Numbers",6,186,w)
		styles[MATCHING]=TTextStyle.Create("Matchings",6,216,w)
		
		textarea=CreateTextArea(6,250,cw-12,ClientHeight(w)-256,w,TEXTAREA_READONLY)
		SetGadgetText textarea,"'Sample Code~n~nresult = ((2.0 * 4) + 1)~nPrint( ~qResult: ~q + result )~n"
		
		w=toolpanel
		cw=ClientWidth(w)
		outputstyle=TGadgetStyle.Create("Output: ",6,6,w)
		navstyle=TGadgetStyle.Create("Navbar: ",6,66,w)

		SetDefaults()
		SetPanel configpanel
		
		SnapShot
	End Method
	
	Function Create:TOptionsRequester(host:TCodePlay)
		Local	o:TOptionsRequester
		o=New TOptionsRequester
		o.InitOptionsRequester host
		Return o
	End Function
	
End Type


Type TFindRequester Extends TRequester

	Field	combo:TGadget

	Function Create:TFindRequester(host:TCodePlay)

		Local	seek:TFindRequester

		seek=New TFindRequester
		seek.initrequester(host,"Find",280,66,STYLE_OK|STYLE_CANCEL|STYLE_DIVIDER|STYLE_MODAL,"Find")

		CreateLabel("Find",6,12,82,24,seek.window)		
		seek.combo=CreateComboBox(88,8,ClientWidth(seek.window)-(88+6),26,seek.window,COMBOBOX_EDITABLE)

'		seek.findterm=CreateTextField(88,8,ClientWidth(seek.window)-(88+6),21,seek.window)
		Return seek
	End Function
	
	Method ShowFind(term$="")
		Local previous$=GadgetText(combo)				
		If previous			
			For Local item=0 Until CountGadgetItems(combo)
				If previous=GadgetItemText(combo,item)
					RemoveGadgetItem combo,item
					Exit 
				EndIf
			Next					
			InsertGadgetItem combo,0,previous
		EndIf		
		SetGadgetText(combo,term)
		Super.Show()
		ActivateGadget combo
	End Method

	Method Poll()
		Local	find$,data		
		Select EventSource()
			Case window
				If EventID()=EVENT_WINDOWCLOSE
					Hide()
				EndIf
			Case ok
				If EventID() = EVENT_GADGETACTION
					find=GadgetText(combo)
					If find
						Hide()
						host.activepanel.Invoke TOOLFINDNEXT,find
					Else
						Notify "You must enter a search string to find!", True
						ActivateGadget combo
					EndIf
				EndIf
			Case cancel
				If EventID() = EVENT_GADGETACTION Then Hide()
			Default
				Return 0
		End Select
		Return 1
	End Method

End Type

Type TFindRequesterOLD Extends TRequester
	Field	findterm:TGadget
	
	Method ShowFind(term$="")
		If term SetGadgetText(findterm,term)
		Super.Show()
		ActivateGadget findterm
	End Method

	Method Poll()
		Local	find$,data		
		Select EventSource()
			Case window
				If EventID()=EVENT_WINDOWCLOSE
					Hide()
				EndIf
			Case ok
				If EventID() = EVENT_GADGETACTION
					If TextFieldText(findterm)
						find=TextFieldText(findterm)
						Hide()
						host.activepanel.Invoke TOOLFINDNEXT,find
					Else
						Notify "You must enter a search string to find!", True
						ActivateGadget findterm
					EndIf
				EndIf
			Case cancel				
				'If EventID() = EVENT_GADGETACTION Then 
				Hide()
			Default
				Return 0
		End Select
		Return 1
	End Method

	Function Create:TFindRequester(host:TCodePlay)
		Local	seek:TFindRequester
		seek=New TFindRequester
		seek.initrequester(host,"Find",280,66,STYLE_OK|STYLE_CANCEL|STYLE_DIVIDER|STYLE_MODAL,"Find")
		CreateLabel("Find",6,12,82,24,seek.window)

'		seek.findterm=CreateTextField(88,8,ClientWidth(seek.window)-(88+6),21,seek.window)
		seek.combo=CreateComboBox(88,8,ClientWidth(seek.window)-(88+6),21,seek.window)

		Return seek
	End Function
End Type

Type TNewRequester Extends TRequester
	Field	target:TGadget
	Field fullpath$
	
	Method Poll()
		Local	find$,data		
		Select EventSource()
			Case window
				If EventID()=EVENT_WINDOWCLOSE
					Hide()
				EndIf
			Case ok
				If EventID() = EVENT_GADGETACTION
					Hide
					'NewFile
				EndIf
			Case cancel
				If EventID() = EVENT_GADGETACTION Then Hide()
			Default
				Return 0
		End Select
		Return 1
	End Method
	
	Function ReadNewTemplates(monkeypath$,target:TGadget,activetemplate$)
		Local t$[]		
		Local flags
		t=LoadDir(monkeypath+"/templates")
		For Local i$=EachIn t
			flags=0
			If i=activetemplate flags=GADGETITEM_DEFAULT
			AddGadgetItem target," "+i.ToUpper(),flags,-1,"",i
		Next
	End Function

	Function Create:TNewRequester(host:TCodePlay)
		Local	seek:TNewRequester
		seek=New TNewRequester
		seek.initrequester(host,"New File",280,66,STYLE_OK|STYLE_CANCEL|STYLE_DIVIDER|STYLE_MODAL,"Create")
		CreateLabel("Template:",4,14,82,28,seek.window)		
		seek.target=CreateComboBox(92,10,ClientWidth(seek.window)-(92+6),28,seek.window)
		ReadNewTemplates(host.monkeypath,seek.target,host.options.activetemplate)		
		Return seek
	End Function
End Type


Type TMonkeyRequester Extends TRequester
	Field target:TGadget
	Field fullpath$
	Field runmonkey
	Field debugmonkey
		
	Method ShowMonkey(path$,run,debug)
		fullpath=host.FullPath(path)
		runmonkey=run
		debugmonkey=debug
		Show()
		ActivateGadget target		
	End Method
	
	Method Build()
		Local cmd$
		Local xtra$
		cmd$=quote(host.transpath)		
		If Not debugmonkey cmd$:+" -config=release"
		xtra$=String(GadgetItemExtra(target,SelectedGadgetItem(target)))
		cmd$:+" -target="+xtra
		host.options.activetarget=xtra
		If runmonkey
			cmd$:+" -run"
		EndIf
		cmd$:+" "+quote(fullpath)
		host.execute cmd,"Translating "+StripExt(StripDir(fullpath))+"~n"+cmd+"~n"
	End Method
	
	Method Poll()
		Local	find$,data		
		Select EventSource()
			Case window
				If EventID()=EVENT_WINDOWCLOSE
					Hide()
				EndIf
			Case ok
				If EventID() = EVENT_GADGETACTION
					Hide
					Build
				EndIf
			Case cancel
				If EventID() = EVENT_GADGETACTION Then Hide()
			Default
				Return 0
		End Select
		Return 1
	End Method
	
	Function ReadMonkeyTargets( monkeypath$,target:TGadget,activetarget$ )
		Local cd$=CurrentDir()
		ChangeDir monkeypath+"/bin"

		Local cmd$
?win32
		cmd="transcc_winnt"
?macos
		cmd="./transcc_macos"
?
		Local process:TProcess=CreateProcess( cmd$,HIDECONSOLE )
		If Not process
			'ERROR! can't run trans?
			Return
		EndIf
		
		Local output$
		Repeat
			Delay 10
			Local bytes:Byte[]=process.pipe.ReadPipe()
			If bytes
				output:+String.FromBytes( bytes,bytes.length )
			EndIf
		Until Not process.Status()
		
		ChangeDir cd
		
		For Local t$=EachIn output.Split( "~n" )
			t=t.Trim()
			If Not t.StartsWith( "Valid targets: " ) Continue
			Local bits$[]=t.Split( " " )
			For Local i=2 Until bits.length
				Local flags
				If bits[i]=activetarget flags=GADGETITEM_DEFAULT
				AddGadgetItem target," "+bits[i].ToUpper(),flags,-1,"",bits[i]
			Next
			Return
		Next

	End Function

	Function Create:TMonkeyRequester(host:TCodePlay)
		Local	seek:TMonkeyRequester
		seek=New TMonkeyRequester
		seek.initrequester(host,"Monkey Build",280,66,STYLE_OK|STYLE_CANCEL|STYLE_DIVIDER|STYLE_MODAL,"Build")
		CreateLabel("Target:",4,14,82,28,seek.window)		
		seek.target=CreateComboBox(92,10,ClientWidth(seek.window)-(92+6),28,seek.window)
		ReadMonkeyTargets(host.monkeypath,seek.target,host.options.activetarget)		
		Return seek
	End Function
End Type

Type TReplaceRequester Extends TRequester
	Field	findterm:TGadget,replaceterm:TGadget
	Field	findnext:TGadget,replaceit:TGadget,replaceall:TGadget
	
	Method Show()
		Super.Show()
		ActivateGadget findterm
	End Method

	Method Poll()
		Local	find$,Replace$
		Select EventSource()
			Case window
				If EventID()=EVENT_WINDOWCLOSE
					Hide()
				EndIf
			Case cancel
				If EventID() = EVENT_GADGETACTION Then Hide
			Case ok
				If EventID() = EVENT_GADGETACTION Then
					If TextFieldText(findterm) Then
						find=TextFieldText(findterm)
						host.activepanel.Invoke TOOLFINDNEXT,find
					Else
						Notify "You must enter a search string to find!", True
						ActivateGadget findterm
					EndIf
				EndIf
			Case replaceit
				If EventID() = EVENT_GADGETACTION Then
					Replace=TextFieldText(replaceterm)
					If host.activepanel.Invoke(TOOLREPLACE,Replace)
						host.activepanel.Invoke TOOLFINDNEXT,find
					EndIf
				EndIf
			Case replaceall
				If EventID() = EVENT_GADGETACTION Then
					find=TextFieldText(findterm)
					Replace=TextFieldText(replaceterm)
					host.activepanel.Invoke TOOLREPLACE,find+Chr(0)+Replace
				EndIf
			Default
				Return 0
		End Select
		Return 1
	End Method

	Function Create:TReplaceRequester(host:TCodePlay)
		Local x,y
		Local	seek:TReplaceRequester
		seek=New TReplaceRequester
		seek.initrequester(host,"Find and Replace",380,80,STYLE_OK|STYLE_CANCEL|STYLE_DIVIDER,"Find Next")
		
		y=11
		CreateLabel( "Find",6,y+4,88,24,seek.window )
		seek.findterm=CreateTextField( 96,y,168,21,seek.window )

		y:+32		
		CreateLabel( "Replace With",6,y+4,88,24,seek.window )
		seek.replaceterm=CreateTextField( 96,y,168,21,seek.window )

		x=ClientWidth(seek.window)-102
		y=8
		seek.replaceit=CreateButton("Replace",x,y,96,26,seek.window)
		seek.replaceall=CreateButton("Replace All",x,y+32,96,26,seek.window)
		
		Return seek
	End Function
End Type

Type TEventHandler Extends TTool
	Method OnEvent() Abstract
End Type

Type TToolPanel Extends TEventHandler
	Field	name$,path$
	Field	panel:TGadget
	Field	index
	Field	active
	
	Method Show()
	End Method
End Type

Type TView
	Field	node:TGadget
	Field	state
End Type

Type TNode Extends TTool
	Const	HIDESTATE=0
	Const	CLOSEDSTATE=1
	Const	OPENSTATE=2

	Field	name$,sortname$
	Field	parent:TNode
	Field	kids:TList=New TList
	Field	views:TView[]
' activate program	
	Field	target:TTool
	Field	action
	Field	argument:Object

	Method SortKids( ascending=True )
		Local term:TLink=kids._head
		Repeat
			Local link:TLink=kids._head._succ
			Local sorted=True
			Repeat
				Local succ:TLink=link._succ
				If succ=term Exit
				Local cc=TNode(link._value).sortname.Compare( TNode(succ._value).sortname )
				If (cc>0 And ascending) Or (cc<0 And Not ascending)
					Local link_pred:TLink=link._pred
					Local succ_succ:TLink=succ._succ
					link_pred._succ=succ
					succ._succ=link
					succ._pred=link_pred
					link._succ=succ_succ
					link._pred=succ
					succ_succ._pred=link
					sorted=False
				Else
					link=succ
				EndIf
			Forever
			If sorted Return
			term=link
		Forever
	End Method

	Method FindArgument:TNode(arg:Object)
		Local	n:TNode,r:TNode,a$
		If arg.Compare(argument)=0 Return Self
		a$=(String(arg)).ToLower()
		If a And a=(String(argument)).toLower() Return Self
		For n=EachIn kids
			r=n.FindArgument(arg)
			If r Return r
		Next
	End Method
	
	?Debug
	Method Dump(indent$="")
		Local	n:TNode		
		Print indent+name
		indent:+"~t"
		For n=EachIn kids
			n.Dump indent
		Next
	End Method		
	?
	
	Method IsHidden()
		Local	v:TView
		If Not parent Return False
		For v=EachIn parent.views
			If v.state=OPENSTATE Return False
		Next
		Return True
	End Method
	
	Method SetAction(tool:TTool,cmd,arg:Object=Null)
		target=tool
		action=cmd
		argument=arg
	End Method

	Method Hide(v:TView=Null)	'null means hide in all views
		For Local n:TNode = EachIn kids
			n.hide v
		Next
		If v
			If v.node FreeTreeViewNode v.node;v.node=Null
		Else
			For v=EachIn views
				If v.node FreeTreeViewNode v.node;v.node=Null
			Next
		EndIf
	End Method
	
	Method Detach()
		Hide()
		If parent parent.kids.remove Self;parent=Null
	End Method
	
	Method FreeKids()
		For Local n:TNode = EachIn kids
			n.free
		Next
	End Method
	
	Method Free()
		FreeKids()
		Detach()
		target=Null;argument=Null;views=Null
	End Method
	
	Method Invoke(command,arg:Object=Null)
		Select command
		Case TOOLACTIVATE,TOOLMENU
			If target Return target.Invoke(action,argument)
		End Select
	End Method
	
	Method Find:TNode(treeviewnode:TGadget,view=0)
		Local	n:TNode,r:TNode
		Local	v:TView
		v=getview(view)
		If v And v.node=treeviewnode Return Self
		For n=EachIn kids
			r=n.Find(treeviewnode,view)
			If r Return r
		Next
	End Method
	
	Method SetNode(treeviewnode:TGadget,view=0)
		Local	v:TView = getview(view)
		v.node=treeviewnode
		open view
	End Method
	
	Method HighLight(view=-1)
		Local	v:TView
		If view=-1
			For view=0 Until views.length
				HighLight view
			Next
			Return
		EndIf
		v=GetView(view)
		If v.node SelectTreeViewNode v.node
	End Method
	
	Method Open(view=-1)
		Local	v:TView
		If view=-1
			For view=0 Until views.length
				Open view
			Next
			Return
		EndIf
		v=GetView(view)
		If v.state<>OPENSTATE
			v.state=OPENSTATE
			RefreshView view
'			If v.node ExpandTreeViewNode v.node
		EndIf
	End Method
	
	Method Close(view=0)
		Local	v:TView = GetView(view)
		If v.state<>CLOSEDSTATE
			v.state=CLOSEDSTATE
'			If v.node CollapseTreeViewNode v.node
		EndIf
	End Method
	
	Method GetState(view=0)
		Return GetView(view).state
	End Method

	Method GetView:TView(view=0)
		If view>=views.length
			views=views[..view+1]
		EndIf
		If Not views[view] views[view] = New TView
		Return views[view]
	End Method
	
	Method GetIndex()
		Local	node:TNode
		Local	i		
		If parent
			For node=EachIn parent.kids
				If node=Self Return i
				i:+1
			Next
		EndIf
	End Method
	
	Method Refresh()
		For Local i:Int = 0 Until views.length
			RefreshView i
		Next
	End Method
	
	Method RefreshView(view=0)
		Local	n:TNode,quick,nodeToOpen:TGadget
		Local	v:TView,vv:TView
		Local	node
		If parent And parent.getstate(view)=CLOSEDSTATE quick=True		
		v=getview(view)
		If v.node And parent
			If GadgetText(v.node) <> name Then
				ModifyTreeViewNode v.node,name
			EndIf
			If v.state=OPENSTATE nodeToOpen = v.node;quick = False
		Else
			If parent And name
				vv=parent.getview(view)
				If vv.node
					v.node=InsertTreeViewNode(GetIndex(),name,vv.node)
					If v.state=HIDESTATE v.state=CLOSEDSTATE					
					If vv.state=OPENSTATE nodeToOpen = vv.node
					quick=False
				EndIf
			EndIf
		EndIf
		If quick Return
		If Not kids Return
		For n=EachIn kids
			n.RefreshView view
		Next
		If nodeToOpen Then ExpandTreeViewNode nodeToOpen
	End Method

	Method NodeAfter:TNode(node:TNode)
		Local	link:TLink
		If node	link=kids.FindLink(node)
		If link link=link.NextLink()
		If link Return TNode(link.Value())	
	End Method

	Method Sync(snap:TNode)
		Local	snapkid:TNode
		Local	currentkid:TNode
		Local	kid:TNode
		Local	t:TNode
		Local	link:TLink

		If snap.name<>name Return
		If kids.Count() currentkid=TNode(kids.First())
		For snapkid=EachIn snap.kids
' if same name in list
			kid=currentkid
			While kid
				If kid.name=snapkid.name Exit
				kid=NodeAfter(kid)
			Wend
' then remove entries in front			
			If kid
				While currentkid<>kid
					t=currentkid
					currentkid=NodeAfter(currentkid)			
					t.free()
				Wend
			EndIf
' if same name sync else insert
			If currentkid And currentkid.name=snapkid.name	'merge values if same name
				currentkid.Sync snapkid
				currentkid=NodeAfter(currentkid)
			Else
				snapkid.detach
				If currentkid
					link=kids.FindLink(currentkid)
					kids.InsertBeforeLink snapkid,link
				Else
					kids.AddLast snapkid
				EndIf
				snapkid.parent=Self
			EndIf
		Next
' remove any entries at end
		While currentkid
			t=currentkid
			currentkid=NodeAfter(currentkid)			
			t.free()
		Wend
		Refresh()
	End Method

	Method SetName(n$)
		name=n
	End Method
		
	Method AddNode:TNode(name$)
		Local	v:TNode
		v=New TNode
		v.setname name
		Append v
		Return v
	End Method
	
	Method Append(v:TNode)
		v.parent=Self
		kids.AddLast v
	End Method	
	
	Method AddFirst(kid:TNode)
		kid.Detach
		kid.parent=Self
		kids.AddFirst kid
	End Method	

	Method FindNode:TNode(withname$)
		Local kid:TNode,node:TNode
		If name=withname Return Self
		For kid=EachIn kids
			node=kid.FindNode(withname)
			If node Return node
		Next		
	End Method

	Function CreateNode:TNode(name$)
		Local	node:TNode
		node=New TNode
		node.setname name
		Return node
	End Function
	
End Type

Type TServerPanel Extends TToolPanel
	Field host:TCodePlay
	Field resetbutton:TGadget
	Field htmlview:TGadget
	Field portnumber

	Method Invoke(command,argument:Object=Null)
		Local	href$
		If Not htmlview Return
		Select command
			Case TOOLCUT
				GadgetCut htmlview
			Case TOOLCOPY
				GadgetCopy htmlview
			Case TOOLPASTE
				GadgetPaste htmlview
			Case TOOLSHOW
				ActivateGadget htmlview	
				host.SetTitle
				host.options.outputstyle.Apply htmlview,1,host.options.colorcontainers
			Case TOOLNAVIGATE
				href$=String(argument)
				If href Go href
			Case TOOLPRINT
				GadgetPrint htmlview
		End Select
	End Method

	Method OnEvent()
		Local	url$,p,t$
		If htmlview 
'			PollServer
			If EventSource()=htmlview
				Select EventID()
					Case EVENT_GADGETACTION				'NAVIGATEREQUEST
						url$=String( EventExtra() )
				End Select			
			EndIf
		EndIf
	End Method
		
	Method Go(url$,internal=False)
		Local	node:TNode
'		DebugLog "Go!"
		HtmlViewGo htmlview,url
		host.SelectPanel Self
		ActivateGadget htmlview			
	End Method
	
	Method Home()
		Go "http://localhost:8080/index.htm",True
	End Method
	
	Method Forward()
		HtmlViewForward htmlview
	End Method

	Method Back()
		HtmlViewBack htmlview
	End Method
	
	Method Open(port)	
		If htmlview And portnumber=port
			codeplay.SelectPanel Self
			Return
		EndIf		
		portnumber=port
'		RunServer port
		codeplay.addpanel(Self)		
		Local style=0 'HTMLVIEW_NONAVIGATE		'HTMLVIEW_NOCONTEXTMENU
		htmlview=CreateHTMLView(0,0,ClientWidth(panel),ClientHeight(panel),panel,style)		
		SetGadgetLayout htmlview,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED
		Home
		Hide()
	End Method

	Method Hide()
		If htmlview
			host.RemovePanel Self
		EndIf
	End Method
	
	Method Close()
		If htmlview
			If panel host.RemovePanel Self
			FreeGadget htmlview
			htmlview=Null
			DebugLog "closing server"
'			CloseServer
		EndIf
	End Method	

	Function Create:TServerPanel(host:TCodePlay)
		Local root
		Local p:TServerPanel = New TServerPanel
		p.host=host
		p.name="localhost"
		Return p
	End Function

End Type


Type THelpPanel Extends TToolPanel

	Field host:TCodePlay
	Field htmlview:TGadget
	Field oldpanel:TToolPanel

	Method AddLink:TNode(parent:TNode,name$,href$)
		Local	n:TNode
		If parent
			n=parent.AddNode(name)
		Else
			n=host.helproot
		EndIf
		If href href=RealPath(href)
		n.SetAction(Self,TOOLNAVIGATE,href)
		Return n
	End Method

	Method AddBMXLink:TNode(parent:TNode,name$,href$)
		Local	n:TNode
		If parent
			n=parent.AddNode(name)
		Else
			n=host.bmxhelproot
		EndIf
		If href href=RealPath(href)
		n.SetAction(Self,TOOLNAVIGATE,href)
		Return n
	End Method


	Method ImportLinks( node:TNode,path$ )

		Local t$=path+"/index.html"
		If FileType( t )<>FILETYPE_FILE Return

		node=AddBMXLink( node,StripDir( path ),t )

		Local map:TMap=New TMap
		
		'scan for html files
		For Local e$=EachIn LoadDir( path )
			If e="index.html" Continue
			Local p$=path+"/"+e
			Select FileType( p )
			Case FILETYPE_DIR
				ImportLinks node,p
			Case FILETYPE_FILE
				If Not e.StartsWith( "_" ) And ExtractExt( e ).Tolower()="html"
					map.Insert StripExt( e ),p
				EndIf
			End Select
		Next

		'scan for anchors in index.html...
		'
		'note: anchors must be quote enclosed and of simple form <a name="blah">
		Local c$=CacheAndLoadText( t ),i
		Repeat
			i=c.Find( "<a name=~q",i )
			If i=-1 Exit
			i:+9
			Local i2=c.Find( "~q>",i )
			If i2=-1 Exit
			Local q$=c[i..i2]
			If q.StartsWith( "_" ) Continue
			map.Insert q,t+"#"+q
			i=i2+1
		Forever

		For Local kv:TKeyValue=EachIn map
			AddBMXLink node,String( kv.Key() ),String( kv.Value() )
		Next

	End Method

	Method SyncDocs()
		If Not host.bmxpath Return
	
		host.bmxhelproot.FreeKids

		ImportLinks Null,host.bmxpath+"/docs/html"

		Local link:TNode
		For Local m$=EachIn EnumModules()
			If m.StartsWith( "brl." ) Or m.StartsWith( "pub." ) Or m.StartsWith("maxgui.") Continue
			Local p$=ModulePath( m )+"/doc/commands.html"
			If FileType( p )<>FILETYPE_FILE Continue
			If Not link link=AddBMXLink( host.bmxhelproot,"Third party modules","" )
			AddBMXLink link,m,p
		Next

		link=AddBMXLink( host.bmxhelproot,"Index","" )
		
		If FileType( host.bmxpath+"/docs/html/Modules/commands.txt" )=FILETYPE_FILE
			Local comm$=CacheAndLoadText( host.bmxpath+"/docs/html/Modules/commands.txt" )
			For Local Line$=EachIn comm.Split( "~n" )
				Local bits$[]=Line.Split( "|" )
				If bits.length<>2 Continue
				Local i=bits[0].Find( " : " )
				If i<>-1 bits[0]=bits[0][..i]
				AddBMXLink link,bits[0],host.bmxpath+bits[1]
			Next
		EndIf
			
		host.bmxhelproot.Refresh
	End Method

	Method Invoke(command,argument:Object=Null)
		Local	href$
		If Not htmlview Return
		Select command
			Case TOOLFIND
				host.findreq.ShowFind
			Case TOOLESCAPE
				If oldpanel host.SelectPanel oldpanel
			Case TOOLBACKSPACE
				Back			
			Case TOOLCUT
				GadgetCut htmlview
			Case TOOLCOPY
				GadgetCopy htmlview
			Case TOOLPASTE
				GadgetPaste htmlview
			Case TOOLSHOW
'				ActivateGadget htmlview	
				host.SetTitle
				host.options.outputstyle.Apply htmlview,1,host.options.colorcontainers
			Case TOOLREFRESH
				host.options.outputstyle.Apply htmlview,1,host.options.colorcontainers
			Case TOOLNAVIGATE
				href$=String(argument)
				If href Go href
			Case TOOLPRINT
				GadgetPrint htmlview
		End Select
	End Method

	Method OnEvent()
		Local	url$,p,t$
		If EventSource()=htmlview
			Select EventID()
				Case EVENT_GADGETMENU
					DebugLog CurrentEvent.toString()
					
				Case EVENT_GADGETDONE
'					DebugLog "GadgetDone!"
				Case EVENT_GADGETACTION				'NAVIGATEREQUEST
'					DebugLog "GadgetAction!"
					url$=String( EventExtra() )
					
					
					If url[..5]="http:" And Not url.StartsWith(WIKI_URL) And Not url.StartsWith(CLOUD)
						OpenURL url
					'Else If url.EndsWith( "\modules\index.html" )
					'	OpenURL url
					Else
						p=url.findlast(".")
						If p>-1
							t$=url[p..].tolower()
							If t$=".bmx" Or t$=".monkey"
								If url.Find( "file://" )=0
									url=url[7..]
									?Win32
									url=url[1..]
									?
								EndIf
								url=url.Replace("%20"," ")
								Local source:TOpenCode=host.OpenSource(url)
								'If source source.MakePathTemp
							Else
								url=url.Replace("\","/")
								Go url$
							EndIf
						EndIf
					EndIf
			End Select			
		EndIf
	End Method
	
	
	Method Home()		
		Local url$		
		url="monkey:/docs/html/Home.html"
		Go url
	End Method
	
	Method Go(url$,internal=False)
		Local	node:TNode
		
		If url.startsWith("monkey:")
			If Not host.monkeypath Return	'silent fail			
			url="file://"+host.monkeypath+url[7..]
		EndIf

		DebugLog "url="+url
		
		If url.startsWith("wiki:")
			url=url[5..]
			If host.options.offlinedocs
				url=host.monkeypath+WIKI_LOCAL+url+WIKI_LOCAL_SUFFIX
			Else
				url=WIKI_URL+url+WIKI_ARGS
			EndIf
		EndIf

		If host.options.externalhelp And Not internal
			PollSystem
			OpenURL url
			MinimizeWindow host.window
			PollSystem
			Return
		EndIf
		
		DebugLog "go:"+url

		HtmlViewGo htmlview,url
	
		If host.currentpanel<>Self oldpanel=host.currentpanel

		host.SelectPanel Self
		
		If host.helproot
			node=host.helproot.FindArgument(RealPath(url))
		EndIf
		
		If node
			node.Highlight
'		Else
'			print "node not found"
		EndIf		
		ActivateGadget htmlview			
	End Method
		
	Method Forward()
		HtmlViewForward htmlview
	End Method

	Method Back()
		HtmlViewBack htmlview
	End Method

	Function Create:THelpPanel(host:TCodePlay)
		Local	root,style
		Local	p:THelpPanel = New THelpPanel
		p.host=host
		p.name="Docs"
		codeplay.addpanel(p)
?win32
		style=HTMLVIEW_NONAVIGATE		'HTMLVIEW_NOCONTEXTMENU
?macos
		style=HTMLVIEW_NONAVIGATE		'HTMLVIEW_NOCONTEXTMENU
?
		p.htmlview=CreateHTMLView(0,0,ClientWidth(p.panel),ClientHeight(p.panel),p.panel,style)		
		SetGadgetLayout p.htmlview,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED
'		p.Home
		p.SyncDocs
		Return p
	End Function

End Type

Type TSearchResult
	
	Field filepath$
	Field char%, Line%
	Field linestring$
	
	Method AddToListbox( pGadget:TGadget )
		AddGadgetItem pGadget, "[" + Line + ", " + char + "] " + filepath, 0, -1, StripWhitespace(linestring,char), Self
	EndMethod
	
	Method Set:TSearchResult(pFilePath$,pChar%,pLine%,pLineString$)
		filepath = pFilePath
		char = pChar
		Line = pLine
		linestring = pLineString
		Return Self
	EndMethod
	
	Function StripWhitespace$(pString$,pChar%)
		If pString.length < pChar Then Return pString
		Local outString$
		For Local i:Int = 0 Until pString.length
			Select pString[i]
				Case Asc(" "), Asc("~t"), Asc("~n"), Asc("~r")
					If outString And Not outString.EndsWith(" ") Then outString:+" "
				Default
					outString:+pString[i..i+1]
			EndSelect
		Next
		Return outString
	EndFunction
	
EndType

Type TSearchRequester Extends TRequester
	
	Const strSearchText$ = "Search"
	Const strStopSearchText$ = "Stop Search"
	
'	Global strFileExts$[][] = [["bmx"],filetypes.Split(","),String[](Null)]
	Global strFileExts$[][] = [["monkey"],filetypes.Split(","),String[](Null)]
	
	Field	findbox:TGadget,typebox:TGadget,pathbox:TGadget,pathbutton:TGadget,pathsubdir:TGadget,results:TGadget
	Field lstSearchResults:TList = New TList
	
	Field safetyCount% = -1, safetyThreshold = 500, safetyResetCount% = 0
	
	Method Poll()
		Local id:Int = EventID()
		Local data:Int = EventData()
		Select EventSource()
			Case results
				Select id
					Case EVENT_GADGETACTION
						Local tmpSearchResult:TSearchResult = TSearchResult(EventExtra())
						If tmpSearchResult Then
							host.DebugSource( tmpSearchResult.filepath, tmpSearchResult.Line, tmpSearchResult.char )
							'Hide()
						EndIf
				EndSelect
			Case pathbutton
				If EventID()=EVENT_GADGETACTION
					Local tmpString$ = RequestDir( "Choose a folder to search...",GadgetText(pathbox))
					If tmpString Then SetGadgetText(pathbox,tmpString)
				EndIf
			Case window
				If EventID()=EVENT_WINDOWCLOSE Then Hide()
			Case findbox
				If EventID() = EVENT_GADGETACTION Then
					If GadgetText(findbox) Then EnableGadget(ok) Else DisableGadget(ok)
				EndIf
			Case ok
				If EventID()=EVENT_GADGETACTION
					If safetyCount < 0 Then StartSearch() Else safetyCount = -2
				EndIf
			Case cancel
				If EventID()=EVENT_GADGETACTION Then Hide()
		End Select
	End Method
	
	Method Hide()
		safetyCount = -2
		Super.Hide()
	EndMethod
	
	Method ShowWithPath( pPath$ )
		If pPath Then SetGadgetText( pathbox, pPath )
		Show()
		ActivateGadget( findbox )
	EndMethod
	
	Method StartSearch()
		
		PollSystem()
		
		Select FileType(RealPath(GadgetText(pathbox)))
			Case FILETYPE_NONE
				Notify "The specified path does not exist!",True
				ActivateGadget(pathbox)
				Return
			Case FILETYPE_FILE
				Notify "The path entered is for a file, please enter the path of a directory.",True
				ActivateGadget(pathbox)
				Return
		EndSelect
		
		If Not GadgetText(findbox) Then
			Notify "You must enter a search string to find!",True
			ActivateGadget(findbox);Return
		EndIf
		
		safetyResetCount = 0
		safetyCount = 0
		SetGadgetText ok, strStopSearchText;
		ClearGadgetItems results
		SearchPath( GadgetText(pathbox), strFileExts[SelectedGadgetItem(typebox)], GadgetText(findbox).ToLower(), ButtonState(pathsubdir) )
		SetGadgetText ok, strSearchText
		safetyCount = -1
		SetStatusText window, "Search complete! Found "+CountGadgetItems(results)+" instance(s)!"
		
	EndMethod
	
	Method SearchPath(pPath$,pFileType$[],pString$,pRecurse% = True)
		
		pPath$ = RealPath(pPath)						'Make sure we are using a real path
		
		Local tmpSearchDir$[] = LoadDir(pPath,True)			'Load directors contents into string array
		If Not tmpSearchDir Then Return					'Return if the directory is invalid
		tmpSearchDir.Sort()							'Sort the contents alphabetically
		
		SetStatusText window, "Searching: "+ pPath			'And let user know which directory is being searched
		
		Local tmpFullPath$
		
		For Local tmpItem$ = EachIn tmpSearchDir
			
			tmpFullPath = pPath + "/" + tmpItem
			
			Select FileType(tmpFullPath)
				Case FILETYPE_NONE;Continue                              'Skip item if, for whatever reason, it doesn't exist
				Case FILETYPE_FILE                                       'If file, then check extension and search if valid
					If Not pFileType
						SearchFile(tmpFullPath,pString)
					Else
						Local tmpExt$ = ExtractExt(tmpFullPath).ToLower$()
						For Local tmpValidExt$ = EachIn pFileType
							If tmpExt = tmpValidExt Then SearchFile(tmpFullPath,pString)
						Next
					EndIf
				Case FILETYPE_DIR                                        'If folder, then we might have to search recursively
					If pRecurse Then SearchPath(tmpFullPath,pFileType,pString,pRecurse)
			EndSelect
			
			If Not ShouldContinue() Then Return
			
		Next
		
		PollSystem();If PeekEvent() Then host.Poll()			'Let the system update as we could be searching a while
		
	EndMethod
	
	Method SearchFile(pPath$,pString$)
		Local tmpText$ = CacheAndLoadText( pPath ), tmpLines$[], tmpFindPos%, tmpCharCount%, tmpLineNo%
		Local tmpStringLength% = pString.length, tmpChunkLines$[], tmpPrevLines$
		
		If tmpText Then
			tmpLines = tmpText.Split("~n")
			tmpText = tmpText.ToLower()
			tmpFindPos = tmpText.Find(pString)
			While ShouldContinue() And tmpFindPos > -1
				tmpChunkLines = tmpText[..tmpFindPos].Split("~n")
				tmpPrevLines = "~n".Join(tmpChunkLines[..tmpChunkLines.length-1])
				tmpLineNo:+(tmpChunkLines.length)-1
				Local tmpSearchResult:TSearchResult = New TSearchResult.Set(pPath,tmpFindPos-tmpPrevLines.length,tmpLineNo+1,tmpLines[tmpLineNo])
				tmpSearchResult.AddToListbox(results);safetyCount:+1
				tmpCharCount:+tmpFindPos+tmpStringLength
				tmpText = tmpText[tmpFindPos+tmpStringLength..]
				tmpFindPos = tmpText.Find(pString)
			Wend
		EndIf
	EndMethod
	
	Method ShouldContinue()
		If safetyCount < 0 Then Return False
		If safetyCount >= safetyThreshold Then
			Local instances=safetyResetCount*safetyThreshold+safetyCount
			If Confirm( "There have been "+instances+" instances found.~n~nWould you like To Continue?") Then
				safetyCount = 0
				safetyResetCount:+1
			Else
				safetyCount = -1
				Return False
			EndIf
		EndIf
		Return True
	EndMethod
	
	Function Create:TSearchRequester(host:TCodePlay)
		Local	search:TSearchRequester = New TSearchRequester
		search.initrequester(host,"Find In Files",440,280,STYLE_CANCEL|STYLE_DIVIDER|STYLE_OK|STYLE_STATUS|STYLE_RESIZABLE,strSearchText)
		DisableGadget(search.ok)
		
		SetGadgetLayout(CreateLabel("Find",6,8+4,95,24,search.window),EDGE_ALIGNED,EDGE_CENTERED,EDGE_ALIGNED,EDGE_CENTERED)
		search.findbox=CreateTextField(103,8,ClientWidth(search.window)-(103+6),21,search.window);SetGadgetLayout(search.findbox,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_CENTERED)
		
		
		SetGadgetLayout(CreateLabel("File Types",6,42,95,24,search.window),EDGE_ALIGNED,EDGE_CENTERED,EDGE_ALIGNED,EDGE_CENTERED)
		search.typebox=CreateComboBox(103,38,ClientWidth(search.window)-(103+6),24,search.window);SetGadgetLayout(search.typebox,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_CENTERED)
		
		AddGadgetItem( search.typebox, "Monkey Files",GADGETITEM_DEFAULT,-1,"*.monkey" )
		AddGadgetItem( search.typebox, "BlitzMax Files",0,-1,"*.bmx" )
		AddGadgetItem( search.typebox, "Code Files",0,-1,fileTypes )
		AddGadgetItem( search.typebox, "All Files (Warning: Includes Binary Files)",0,-1,"*")
		
		SetGadgetLayout(CreateLabel("Search Path",6,72,95,48,search.window),1,0,1,0)
		search.pathbox=CreateTextField(103,68,ClientWidth(search.window)-(103+6+30+6),21,search.window);SetGadgetLayout(search.pathbox,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_CENTERED)
		search.pathbutton=CreateButton("..",ClientWidth(search.window)-(34+6),65,34,26,search.window);SetGadgetLayout(search.pathbutton,EDGE_CENTERED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_CENTERED)
		SetGadgetText(search.pathbox, CurrentDir())
		
		search.pathsubdir=CreateButton("Search sub-directories",103,98,ClientWidth(search.window)-(103+6),20,search.window,BUTTON_CHECKBOX);SetGadgetLayout(search.pathsubdir,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_CENTERED)
		SetButtonState(search.pathsubdir,True)
		
		search.results=CreateListBox(6,128,ClientWidth(search.window)-12,280-(128+6),search.window);SetGadgetLayout(search.results,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED)
		
		Return search
	End Function
End Type


Type TProjectRequester Extends TRequester
	Field	projects:TProjects
	Field	listbox:TGadget
	Field	add:TGadget
	Field	remove:TGadget
	Field	props:TGadget
	Field	moveup:TGadget
	Field	movedown:TGadget
	Field	Current:TProjectFolderNode

	Method Invoke(command,arg:Object=Null)
		Select command
		Case TOOLACTIVATE
			Refresh
		End Select
	End Method
	
	Method SetCurrent(i)
		If i=-1
			DisableGadget remove
			DisableGadget moveup
			DisableGadget movedown
			DisableGadget props
			Current=Null
		Else
			Current=TProjectFolderNode(GadgetItemExtra(listbox,i))
			If Current
				EnableGadget remove
				EnableGadget props
				EnableGadget moveup
				EnableGadget movedown
			EndIf
		EndIf
	End Method

	Method Poll()
		Local	index
		Select EventSource()
			Case window
				If EventID()=EVENT_WINDOWCLOSE Then Hide()
			Case add
				If EventID() = EVENT_GADGETACTION Then
					projects.NewProject
					Refresh
				EndIf
			Case remove
				If EventID() = EVENT_GADGETACTION Then
					projects.RemoveProject SelectedGadgetItem(listbox)
					Refresh
				EndIf
			Case cancel
				If EventID() = EVENT_GADGETACTION Then Hide
			Case props
				If EventID() = EVENT_GADGETACTION And Current
					host.projectprops.Open(Current)
				EndIf
			Case listbox
				If EventID()=EVENT_GADGETSELECT
					SetCurrent SelectedGadgetItem(listbox)	'EventData()
				ElseIf EventID()=EVENT_GADGETACTION
					SetCurrent SelectedGadgetItem(listbox)
					host.projectprops.Open(Current)
				EndIf
			Case moveup
				If EventID()=EVENT_GADGETACTION Then
					index=projects.MoveProject(SelectedGadgetItem(listbox),-1)
					Refresh
					SelectGadgetItem listbox,index
					SetCurrent(index)
				EndIf
			Case movedown
				If EventID()=EVENT_GADGETACTION Then
					index=projects.MoveProject(SelectedGadgetItem(listbox),1)
					Refresh
					SelectGadgetItem listbox,index
					SetCurrent(index)
				EndIf
		End Select
	End Method

	Method Refresh()
		ClearGadgetItems listbox
		For Local node:TNode = EachIn projects.kids
			If TFolderNode(node)'node.argument
				AddGadgetItem listbox,node.name,0,-1,"",node
			EndIf
		Next
		SetCurrent -1
	End Method
	
	Method Open(projnode:TProjects)
		projects=projnode
		Refresh
		Show
	End Method
	
	Function Create:TProjectRequester(host:TCodePlay)
		Local x,y
		Local	proj:TProjectRequester = New TProjectRequester
	
		proj.initrequester(host,"Project Manager",400,168,STYLE_CANCEL|STYLE_DIVIDER|STYLE_MODAL)
		proj.listbox=CreateListBox( 6,8,244,154,proj.window )
		
		x=ClientWidth(proj.window)-144
		proj.add=CreateButton("Add Project",x,8,138,26,proj.window)
		proj.remove=CreateButton("Remove Project",x,40,138,26,proj.window)

		proj.moveup=CreateButton("Move Up",x,72,138,26,proj.window)
		proj.movedown=CreateButton("Move Down",x,104,138,26,proj.window)

		proj.props=CreateButton("Properties",x,136,138,26,proj.window)

		DisableGadget proj.remove
		DisableGadget proj.moveup
		DisableGadget proj.movedown
		DisableGadget proj.props
		Return proj
	End Function
End Type

Type TProjectProperties Extends TRequester
	Field proj:TProjectFolderNode
	Field newproj:Int = False				'If 'True' then cancel/close deletes project.
	Field localname:TGadget
	Field localpath:TGadget
	Field pathbutton:TGadget
	Field path:TGadget
	Field user:TGadget
	Field password:TGadget
	Field checkout:TGadget
	Field update:TGadget
	Field commit:TGadget
	Field poprequester:TRequester	'hack for restoring to projectmanager requester
	Field dirty
	
	Method Invoke(command,arg:Object=Null)
		Select command
		Case TOOLACTIVATE
			Refresh
		End Select
	End Method
	
	Method Tidy()
		newproj = False
		If dirty
			proj.Set GadgetText(localname),GadgetText(localpath),GadgetText(path),GadgetText(user),GadgetText(password)
			dirty=False
		EndIf
	End Method
	
	Method Poll()
		If (EventID() <> EVENT_GADGETACTION) And (EventID() <> EVENT_WINDOWCLOSE) Then Return
		Select EventSource()
			Case localname,localpath,path,user,password
				dirty=True
			Case pathbutton
				Local dir$=RequestDir("Select the project folder")
				If dir
					If dir[dir.length-1..]="/"	'fltk hack
						dir=dir[..dir.length-1]
					EndIf
					SetGadgetText localpath,dir
					If GadgetText(localname)=""
						SetGadgetText localname,StripDir(dir)
					EndIf
					dirty=True
				EndIf				
			Case checkout
				Tidy()
				Hide()
				proj.CheckoutVersion()
Rem
			Case commit
				Tidy
				Hide				
				proj.CommitVersion		
			Case update
				Tidy
				Hide				
				proj.UpdateVersion		
EndRem
			Case ok
				Tidy()
				Hide()
			Case cancel
				Hide()
			Case window
				If EventID()=EVENT_WINDOWCLOSE
					Hide()
				EndIf
		End Select
	End Method
	
	Method Hide()
		If proj And newproj Then proj.Free()
		EnableGadget host.window
		HideGadget window
		host.UnhookRequester Self'poprequester
		If poprequester poprequester.Show
	End Method

	Method Refresh()
		SetGadgetText localname,proj.GetName()
		SetGadgetText localpath,proj.path
		SetGadgetText path,proj.svnpath
		SetGadgetText user,proj.svnuser
		SetGadgetText password,proj.svnpass
	End Method
	
	Method Open(projnode:TProjectFolderNode, newproject:Int = False)
		newproj=newproject
		proj=projnode
		Refresh()
		Show()
	End Method
	
	Function Create:TProjectProperties(host:TCodePlay)
		Local	proj:TProjectProperties = New TProjectProperties
		proj.initrequester(host,"Project Properties",480,250,STYLE_OK|STYLE_CANCEL|STYLE_DIVIDER|STYLE_MODAL)
		proj.modal = True
		
		Local projectdetails:TGadget = CreatePanel(6,8,ClientWidth(proj.window)-12,85,proj.window,PANEL_GROUP,"Project Details")
		
		Local i,n,y
		y=4

		CreateLabel("Name",6,y+4,72,24,projectdetails)
		proj.localname=CreateTextField(88,y,ClientWidth(projectdetails)-(88+6),21,projectdetails)
'		proj.pathbutton=CreateButton("..",434,y,34,28,projectdetails)
		y:+30

		CreateLabel("Path",8,y+4,72,24,projectdetails)
		proj.localpath=CreateTextField(88,y,ClientWidth(projectdetails)-(88+34+6+6),21,projectdetails)
		proj.pathbutton=CreateButton("..",ClientWidth(projectdetails)-(34+6),y-3,34,26,projectdetails)
		y:+30


		Local svnbox:TGadget = CreatePanel(6,101,ClientWidth(proj.window)-12,144,proj.window,PANEL_GROUP,"Subversion Control")
		y=4
		CreateLabel("URL",8,y+LABELOFFSET,72,24,svnbox)
		proj.path=CreateTextField(88,y,ClientWidth(svnbox)-92,21,svnbox)
		y:+30
		CreateLabel("Username",8,y+LABELOFFSET,72,24,svnbox)
		proj.user=CreateTextField(88,y,ClientWidth(svnbox)-92,21,svnbox)
		y:+30
		CreateLabel("Password",8,y+LABELOFFSET,72,24,svnbox)
		proj.password=CreateTextField(88,y,ClientWidth(svnbox)-92,21,svnbox,TEXTFIELD_PASSWORD)		
		y:+30
		proj.checkout=CreateButton("Check Out Project",ClientWidth(svnbox)-154,ClientHeight(svnbox)-32,150,28,svnbox)
'		proj.update=CreateButton("Update Project",180,y+10,150,28,svnbox)
'		proj.commit=CreateButton("Commit Project",340,y+10,150,28,svnbox)
		y:+40

		Return proj
	End Function
End Type

Function GetInfo$(a$ Var)
	Local p,r$
	p=a.Find("|")+1
	If p=0 p=a.length+1
	r$=a$[..p-1]
	a$=a$[p..]
	Return r$	
End Function

Type TFolderNode Extends TNode
	Field	owner:TNode
	Field	path$
	Field	scanned
	Field	version
	Field	foldertype
	
	Const PROJECTFOLDER=0
	Const DIRECTORYFOLDER=1
	Const FILEFOLDER=2

	Method FindFolderFromPath:TFolderNode(dir$)
		Local result:TFolderNode
		If path=dir Return Self
		For Local folder:TFolderNode = EachIn kids
			result=folder.FindFolderFromPath(dir)
			If result Return result
		Next
	End Method
	
	Method SetName(n$)
		If version Then n:+"("+version+")"
		Super.SetName( n )
		Refresh
	End Method
		
	Method SetVersion(ver)
		version=ver
		SetName StripDir(path)
	End Method
	
	Method Write(stream:TStream)
		Local isopen
		If GetState()=OPENSTATE isopen=True
		If version Or isopen
			stream.WriteLine "proj_data="+path+"|"+isopen+"|"+version+"|"
		EndIf
		For Local folder:TFolderNode = EachIn kids
			folder.Write(stream)
		Next
	End Method

	Method ProjectHost:TCodePlay()
		Local n:TNode = Self
		While n
			If TProjects(n) Return TProjects(n).host
			n=n.parent
		Wend
	End Method

	Method ProjectNode:TProjectFolderNode()
		Local n:TNode = Self
		While n
			If TProjectFolderNode(n) Return TProjectFolderNode(n)
			n=n.parent
		Wend
	End Method

	Method RunSVN(cmd$,about$,refresh)
		
		Local host:TCodePlay = ProjectHost()
		If Not host Notify "Node host not found.";Return
		
		Local project:TProjectFolderNode = ProjectNode()
		If Not project Notify "Node project not found.";Return
		
		If project.svnuser
			cmd:+" --username "+project.svnuser
			If project.svnpass cmd:+" --password "+project.svnpass
		EndIf

		If refresh
			host.execute cmd,about,MENUREFRESH,True,Self
		Else
			host.execute cmd,about,0,0,Self
		EndIf
	End Method
	
	Method UpdateVersion()
		Local cmd$=svncmd+" update"
		cmd:+" "+quote(path)
		RunSVN cmd,"Updating "+path,True
	End Method
	
	Method CommitVersion()
		Local cmd$=svncmd+" commit"
		cmd:+" -m ~qmy comment~q"
		cmd:+" "+quote(path)
		RunSVN cmd,"Committing "+path,False
	End Method
	
	Method Remove()
		
	End Method
	
	Method Open(view=-1)
		Update(True)
		Super.Open view
	End Method

	Method AddFileNode:TNode(file$)
		Local	n:TNode
		Local ext$	
		If (","+FileTypes+",").Contains(","+ExtractExt(file).toLower()+",") Then
			n=AddNode(StripDir(file))
			n.SetAction(owner,TOOLOPEN,file)
			ext=ExtractExt(file$).ToLower()
			n.sortname=ext+n.name
			Return n
		EndIf
	End Method

	Method AddFolderNode:TNode(path$)
		Local	n:TFolderNode = TFolderNode.CreateFolderNode(path,DIRECTORYFOLDER)
		n.owner = owner
		n.sortname=" "+n.name
		Append n
		Return n
	End Method

	Method Scan(o:TNode)
		Local p$
		Local flist:TList = New TList
		
		owner=o
		
		For Local f$ = EachIn LoadDir(path,True)
			If f[..1] = "." Then Continue
			p$=path+"/"+f
			Select FileType(p$)
				Case FILETYPE_FILE
					AddFileNode p$
				Case FILETYPE_DIR
					AddFolderNode p$
			End Select	
		Next
		
		SortKids
		scanned = True
		
	End Method
	
	Method ScanKids()
		For Local f:TFolderNode = EachIn kids
			f.owner = owner
			f.Update(False)
		Next
	End Method
	
	Method Rescan()
		scanned = False
		Update()
	EndMethod
	
	Method Update( alwaysScanKids:Int = False )
		If Not scanned Then
			FreeKids()
			Scan owner
		EndIf
		If alwaysScanKids Or Not IsHidden() Then ScanKids()
		Refresh()
	End Method
	
	Method Invoke(command,argument:Object=Null)
		Local host:TCodePlay
		Local cmd,p
		Local Line$
	
		host=ProjectHost()

		If Not host 
			DebugStop
			Notify "Node host not found."
			Return
		EndIf
		
		Select command
		Case TOOLOUTPUT
			Line$=String(argument)
			p=Line.find(" revision ")
			If p>-1
				SetVersion Int(Line[p+10..])
			EndIf
'			If line[..12]="At revision "
'			DebugLog "TOOLOUTPUT:"+line
			Return
		Case TOOLERROR
			Line$=String(argument)
'			DebugLog "TOOLERROR:"+line
			Return
		Case TOOLMENU
			cmd=Int(String(argument))
			Select cmd
			Case 0		'special toolmenu-command=0 fired by rightbutton node context
				Highlight			
				Local menu:TGadget
				menu=host.projects.projmenu
				PopupWindowMenu host.window,menu,Self
			Case MENUREFRESH
				Rescan()
			Case MENUBROWSE
				OpenURL RealPath(path)
			Case MENUSHELL
				Local cd$=CurrentDir()
				ChangeDir RealPath(path)
?MacOS
				host.execute "/bin/bash","Shell Terminal"
?Linux
				host.execute "/bin/bash","Shell Terminal"
?Win32
				host.execute "cmd","Shell Terminal - Type Exit To End"
?
				ChangeDir cd
			Case MENUUPDATE
				UpdateVersion
			Case MENUCOMMIT
				CommitVersion
'			Case MENUPROPS
'				host.projectprops.Open(Self)
			Case MENUFINDINFILES
				host.searchreq.ShowWithPath( RealPath(path) )
			End Select
		End Select
	End Method	

	Function CreateFolderNode:TFolderNode(path$,foldertype)
		Local	n:TFolderNode = New TFolderNode
'		n.host=host
		n.SetName( StripDir(path) )
		n.path = path
		n.foldertype = foldertype
		Return n
	End Function
End Type

Type TProjectFolderNode Extends TFolderNode
	
	Field owner:TProjects
	Field svnpath$,svnuser$,svnpass$,svnversion
	Field svnerr$
	
	Method CheckoutVersion()	'to do - needs to move old version to temp?
		Local cmd$ = svncmd+" checkout"
		cmd:+" "+quote(svnpath)
		cmd:+" "+quote(path)
		RunSVN cmd,"Checking out "+svnpath+" to "+path,True
	End Method

	Function Crypt$(a$)
		Local b$,c
		For Local i:Int = 0 Until a.length
			c=a[i]
			If c>31 c:~((i*-5)&31)
			b:+Chr(c&255)
		Next
		Return b
	End Function
	
	Method GetName$()
		If name="." Return ""
		Return name
	End Method

	Method ToString$()
		Local prj$
		Local isopen
		If GetState()&OPENSTATE isopen=True
		prj=name+"|"+path+"|"+svnpath+"|"+svnuser+"|"+crypt(svnpass)+"|"+isopen+"|"+version
		Return prj
	End Method

	Method Write(stream:TStream)
		stream.WriteLine "proj_node="+ToString()
		For Local folder:TFolderNode = EachIn kids
			folder.Write(stream)
		Next
	End Method
	
	Method FromString(info$)
		Local n$ = GetInfo(info)
		If Not n Then n = "."
		SetName( n )
		path=GetInfo(info)
		If path path=owner.host.FullPath(path)
		svnpath=GetInfo(info)
		svnuser=GetInfo(info)
		svnpass=GetInfo(info)
		Scan(owner)
		Local isopen,vers
		isopen=Int(GetInfo(info))
		If isopen
			Open
		EndIf	
		vers=Int(GetInfo(info))
		If vers
			SetVersion vers
		EndIf
	End Method
	
	Method Remove()
		owner.RemoveProject(GetIndex())
	End Method
	
	Method Invoke(command,argument:Object=Null)
		Local cmd
		Select command
		Case TOOLMENU
			cmd=Int(String(argument))
			Select cmd
			Case MENUPROPS
				Return owner.host.projectprops.Open(Self)				
			Case MENUREMOVE
				Remove
				Return
			End Select
		End Select
		Return Super.Invoke(command,argument)
	End Method

	Method Set(n$,p$,s$,user$,pass$)
		path=owner.host.FullPath(p)
		setname n
		svnpath=s
		svnuser=user
		svnpass=pass
		Rescan()
		owner.host.projectreq.Refresh()
	End Method

	Function CreateProjectNode:TProjectFolderNode(projects:TProjects,info$)
		Local n:TProjectFolderNode = New TProjectFolderNode
		n.owner=projects
		n.FromString(info)
		n.foldertype=PROJECTFOLDER
		Return n
	End Function

End Type

Type TProjects Extends TNode
	Field host:TCodePlay
	Field addproj:TNode
	Field projmenu:TGadget
	Field projmenuprops:TGadget

	Method RemoveProject(index)
		Local	node:TNode
		If index<0 Or index>=kids.Count() Return
		node=TNode(kids.ValueAtIndex(index))
		If node node.Free
		Refresh
	End Method			
	
	Method MoveProject(index,dir)
		Local node:TNode
		Local link:TLink
		If index<0 Or index>=kids.Count() Return index
		node=TNode(kids.ValueAtIndex(index))
		If node
			addproj.Detach
			node.Hide
			link=kids.FindLink(node)
			If dir>0
				If link link=link._succ
				If link
					kids.Remove node
					kids.InsertAfterLink node,link
					index:+1
				EndIf
			Else
				If link link=link._pred
				If link
					kids.Remove node
					kids.InsertBeforeLink node,link			
					index:-1
				EndIf
			EndIf		
			Append addproj
			Refresh
		EndIf
		Return index
	End Method			

	Method NewProject()
		addproj.Detach
		Local proj:TProjectFolderNode = TProjectFolderNode.CreateProjectNode(Self,"")
'		proj.scan(Self)
		Append proj
		Append addproj
		host.projectprops.Open(proj, True)
		Refresh
	End Method

	Method AddProject(data:TList)
		Local project:TProjectFolderNode
		Local folder:TFolderNode
		For Local info$ = EachIn data
			If Not project
				addproj.Detach
				project=TProjectFolderNode.CreateProjectNode(Self,info)
				Append project
				Append addproj
				Refresh
			Else
				Local path$
				Local popen
				Local pversion
				path=GetInfo(info)
				popen=Int(GetInfo(info))
				pversion=Int(GetInfo(info))
				folder=project.FindFolderFromPath(path)
				If folder
					folder.SetVersion pversion
					folder.ReScan()
					If popen Then folder.Open()
				EndIf		
			EndIf
		Next
	End Method

	Method Write(stream:TStream)
		For Local project:TProjectFolderNode = EachIn kids
			project.Write(stream)		
		Next
	End Method

	Method Invoke(command,argument:Object=Null)
		Select command
		Case TOOLNEW
			NewProject
		Case TOOLOPEN
			host.OpenSource String(argument)
		End Select
	End Method
				
	Function CreateProjects:TProjects(host:TCodePlay)
		Local p:TProjects = New TProjects
		p.SetName("Projects")
		p.host=host		
		p.addproj=p.AddNode("Add Project")
		p.addproj.SetAction p,TOOLNEW

		p.projmenu=CreateMenu("Proj",0,Null)
		CreateMenu "Refresh",MENUREFRESH,p.projmenu
		CreateMenu "Find in Files",MENUFINDINFILES,p.projmenu
		CreateMenu "Explore",MENUBROWSE,p.projmenu
		CreateMenu "Shell",MENUSHELL,p.projmenu
		CreateMenu "",0,p.projmenu
		CreateMenu "Update Version",MENUUPDATE,p.projmenu
		CreateMenu "Commit Version",MENUCOMMIT,p.projmenu
		CreateMenu "",0,p.projmenu
		CreateMenu "Remove",MENUREMOVE,p.projmenu
		p.projmenuprops=CreateMenu("Properties",MENUPROPS,p.projmenu)
		host.projectreq.projects=p
		Return p
	End Function
End Type

Type TByteBuffer Extends TStream
	Field	bytes:Byte[]
	Field	readpointer

	Method Read( buf:Byte Ptr,count )
		If count>readpointer count=readpointer
		If Not count Return
		MemCopy buf,bytes,count
		readpointer:-count
		If readpointer MemMove bytes,Varptr bytes[count],readpointer
		Return count
	End Method
	
	Method ReadLine$()
		For Local i:Int = 0 Until readpointer
			If bytes[i]=10 Or bytes[i] = 0 Then
				Local tmpBytes:Byte[] = New Byte[i+1]
				If i And bytes[i-1] = 13 Then i:-1
				Read(tmpBytes,tmpBytes.length)
				Return String.FromBytes(tmpBytes, i)
			EndIf
		Next
	EndMethod
	
	Method WriteFromPipe( pipe:TPipeStream )
		Local	n,m,count = pipe.ReadAvail()
		n=readpointer+count
		If n>bytes.length
			m=Max(bytes.length*1.5,n)
			bytes=bytes[..m]
		EndIf
		pipe.Read( Varptr bytes[readpointer], count )
		readpointer=n
		Return count
	EndMethod
	
	Method Write( buf:Byte Ptr,count )
		Local	n,m
		n=readpointer+count
		If n>bytes.length
			m=Max(bytes.length*1.5,n)
			bytes=bytes[..m]
		EndIf
		MemCopy Varptr bytes[readpointer],buf,count
		readpointer=n
		Return count
	End Method	
	
	Method LineAvail()
		For Local i:Int = 0 Until readpointer
			If bytes[i]=10 Return True
		Next
	End Method

	Method FlushBytes:Byte[]()
		Local res:Byte[] = bytes[..readpointer]
		readpointer = 0
		Return res
	End Method
End Type

Type TObj
	Field	addr$,sync,refs,syncnext
	Method ShouldSync( pDebugTree:TDebugTree )
		If sync < pDebugTree.sync Then pDebugTree.QueueSync( Self )
	EndMethod
	Method HasSynced( pSync% )
		sync = pSync;syncnext = False
	EndMethod
End Type

Type TVar Extends TNode

	Field	owner:TDebugTree
	Field	obj:Object

	Method Free()
		If TObj(obj) owner.RemoveObj TObj(obj)
		obj=Null
		Super.Free()
	End Method

	Method SetVarName(n$)
		Local	p
		name=n
' if object ref set addr$ field	
		If name.find("$=")=-1 And name.find( ":String=" )=-1 And name.find(")=$")=-1
			p=name.find("=$")
			If p<>-1
				If TObj(obj) Then
					If TObj(obj).addr <> name[p+2..] Then
						TDebugTree.RemoveObj TObj(obj)
					Else
						TObj(obj).refs:-1
					EndIf	
				EndIf				
				obj=TDebugTree.AddObj(name[p+2..])
				'Request object dump if we are visible now that
				'we have updated our own object pointer.
				If Not IsHidden() Then Request()
				Return
			EndIf
			p=name.find("=Null")
			If p<>-1
				FreeKids
				TDebugTree.RemoveObj TObj(obj)
				obj=Null
			EndIf
		EndIf
	End Method
	
	Method AddVar(name$)
		Local	v:TVar=New TVar
		v.owner=owner
		Append v
		v.setvarname name
	End Method
	
	Method SetValue(val:TVar)
		Local	v:TVar,w:TVar,i,kidsarray:Object[]
' if this is a reference to same object refresh values
		If obj And obj=val.obj
			If kids.IsEmpty()
				For v=EachIn val.kids
					AddVar v.name
				Next
			Else
				kidsarray = kids.ToArray()
				For v=EachIn val.kids
					If i<kidsarray.length
						w=TVar(kidsarray[i])
						If w w.SetVarName v.name
					Else
						AddVar v.name
					EndIf
					i:+1
				Next
				kidsarray = Null	
			EndIf
			Refresh
		EndIf	
' recurse so all references are updated
		If IsHidden() Then Return				'parent And parent.state=CLOSEDSTATE Return
		For v=EachIn kids
			v.SetValue val
		Next
	End Method
	
	Method Open(open=-1)
		For Local kid:TVar = EachIn kids
			kid.Request()
		Next
		Super.Open(open)
	EndMethod
	
	Method Request()
		If TObj(obj) Then TObj(obj).ShouldSync(owner)
	EndMethod
	
End Type

Type TScope Extends TVar
	Field	tree:TDebugTree
	Field	file$,Line,column

	Method Invoke(command,argument:Object=Null)
		Select command
			Case TOOLACTIVATE
				tree.SelectScope Self,True
		End Select
	End Method
	
	Method SetScope(s:TScope)
		Local	v:TVar
		file=s.file
		Line=s.Line
		column=s.column
		s.obj=Self
		SetValue s
	End Method
	
	Method SetFile(debugtree:TDebugTree,f$)
		tree=debugtree
		Local p=f.Find("<")+1
		Local q=f.Find(">")+1
		Local r=f.Find(",")+1
		If p And q And r
			file=f[..p-1]
			Line=Int(f[p..r-1])
			column=Int(f[r..q-1])
		EndIf
		obj=Self
	End Method
	
	Method Request()
		For Local kid:TVar = EachIn kids
			kid.Request()
		Next
	EndMethod
	
End Type

Type TDebugTree Extends TVar
	Global	sync
	Global	objmap:TMap = CreateMap()
	Field	host:TCodePlay
	Field	instack:TList
	Field	inscope:TScope
	Field	invar:TVar
	Field	infile$
	Field	inexception$
	Field	firststop
	Field	cancontinue
	
	Method Reset()
'		host.SetMode host.DEBUGMODE
		SetStack( New TList )
		ClearMap objmap
		instack=Null
		inscope=Null
		invar=Null
		infile=""
		inexception=""
		sync=0
		firststop=True
		cancontinue=False
	End Method

	Function AddObj:TObj(addr$)
		Local	o:TObj = TObj(MapValueForKey( objmap, addr ))
		If o Then
			o.refs:+1
		Else
			o=New TObj
			o.addr=addr
			o.refs=1
			MapInsert objmap, addr, o
		EndIf
		Return o
	End Function

	Function FindObj:TObj(addr$)
		Return TObj(MapValueForKey( objmap, addr ))
	End Function
	
	Function RemoveObj(obj:TObj)		':TObj
		If obj Then
			obj.refs:-1
			If Not obj.refs Then MapRemove objmap, obj.addr
		EndIf
	End Function

	Method SyncVars()
		sync:+1
		For Local tmpVar:TVar = EachIn kids
			tmpVar.Request()
		Next
	End Method
	
	Method QueueSync( pObj:TObj )
		If Not pObj Then Return
		'Sync as soon as the debug pipe is clear
		'(see TOuputPanel.SendDumpRequests()).
		pObj.syncnext = True
	EndMethod
			
	Method SetStack(list:TList)
		Local	openscope:TScope
		Local	s:TScope
		Local	count,i

		count=kids.count()			'root.varlist.count()
		For Local scope:TScope = EachIn list
			If i>=count
				Append scope		'root.Append scope
				s=scope
			Else
				s=TScope(kids.ValueAtIndex(i))
' simon was here				
				If s.name=scope.name
					s.SetScope scope
					scope.Free
				Else
					While kids.count()>i
						s=TScope(kids.Last())
						s.free
					Wend
					Append scope
					s=scope
					count=i+1
				EndIf
				
			EndIf
			If firststop
				If host.IsSourceOpen(s.file) openscope=s
			Else
				openscope=s
			EndIf
			i:+1
		Next
		While kids.count()>i
			s=TScope(kids.Last())
			s.free
		Wend
		If list.IsEmpty() Return
		If Not openscope openscope=TScope(list.First())
		If openscope SelectScope openscope,True
		Refresh
		firststop=False
	End Method

	Method SelectScope(scope:TScope,open)
		If Not scope Return		
		host.SetMode host.DEBUGMODE	' simon was here, smoved from reset
		If scope.file host.DebugSource scope.file,scope.Line,scope.column
		scope.Open()
'		If open
'			SelectTreeViewNode scope.node
'			scope.open
'		EndIf
	End Method
	
	Method ProcessError$(Line$)
		Local	p
		
		While p < Line.length
			If Line[p]=$3E Then p:+1 Else Exit		'">"
		Wend
		
		If p = Line.length Return
		If p Then Line = Line[p..]

		If Not Line.StartsWith("~~>") Return Line
		Line=Line[2..]

		If invar
			If Line="}"
				SetValue invar		'root
				invar.Free
				invar=Null
			Else
'				If Not invar.name
'					invar.name=line
'				Else
					invar.AddVar Line
'				EndIf
			EndIf
			Return
		EndIf
		
		If instack 			
			If Line="}"
				
				SetStack instack
				instack=Null
				inscope=Null
				'Request first object dumps, and bump sync count
				SyncVars
				If inexception
					Notify inexception
					inexception=""
				EndIf
				Return
			EndIf
			
			If infile
				If Line="Local <local>"
				Else
					inscope=New TScope
'					Print "inscope.line="+line
					inscope.name=Line
					inscope.owner=Self
					instack.AddLast inscope
				EndIf
				If inscope inscope.setfile Self,infile
				infile=""
				Return
			EndIf

			If Line.StartsWith("@") And Line.Contains("<")
				infile=Line[1..]
			Else
				If inscope inscope.AddVar Line
			EndIf

			Return
		EndIf

		If Line.StartsWith("Unhandled Exception:")
			inexception=Line
			host.output.WritePipe "t"
			cancontinue=False
			Return
		EndIf

		If Line="StackTrace{"
			instack=New TList
			Return
		EndIf

		If Line="Debug:" Or Line="DebugStop:"
			host.output.WritePipe "t"
			If Not cancontinue Then
				cancontinue=True
				host.RefreshToolbar()
			EndIf
			Return
		EndIf					
		
		If Line.StartsWith("ObjectDump@")
			p=Line.find("{",11)
			If p=-1 Return Line
			Line=Line[11..p]
			invar=New TVar
			invar.obj=FindObj(Line)
			invar.owner=Self
			Return
		EndIf
		
	End Method

	Function CreateDebugTree:TDebugTree(host:TCodePlay)
		Local	d:TDebugTree = New TDebugTree
		d.owner=d
		d.SetName "Debug"
		d.host=host
		d.Open
		Return d		
	End Function
End Type

Type TNodeView
	Field	owner:TNavBar
	Field	root:TNode
	Field	treeview:TGadget
	Field	index
	
	Method NewView()
		Local	n:TNode,hnode:TGadget
		hnode=SelectedTreeViewNode(treeview)
		n=root.Find(hnode,index)
		If n And n.parent owner.AddView n
	End Method

	Method OnEvent()
		Local	n:TNode = root.Find(TGadget(EventExtra()),index)
		If Not n Return	'probably an eventgadgetselect -1 Notify("could not find in root");Return

		Select EventID()
			Case EVENT_GADGETSELECT
				n.invoke(TOOLSELECT)				
			Case EVENT_GADGETACTION
				n.invoke(TOOLACTIVATE)				
			Case EVENT_GADGETMENU
				n.invoke(TOOLMENU,Self)
			Case EVENT_GADGETOPEN
				n.open index
			Case EVENT_GADGETCLOSE
				n.close index
		End Select
	End Method
End Type

Type TNavBar Extends TEventHandler
	Field	host:TCodePlay
	Field	tabber:TGadget
	Field	viewlist:TList=New TList
	Field	selected:TNodeView
	Field	navmenu:TGadget
	
	Method SelectedView()
		If selected Return selected.index
	End Method
		
	Method SelectView(index)
		Local	n:TNodeView
		If index>=viewlist.count() Return
		n=TNodeView(viewlist.ValueAtIndex(index))
		If Not n Print "selectview failed";Return
		If n<>selected
			If selected HideGadget selected.treeview
			selected=n
		EndIf
		ShowGadget n.treeview
		SelectGadgetItem tabber,index
	End Method
	
	Method AddView(node:TNode)
		Local	n:TNodeView
		Local	index,root:TGadget
		For n=EachIn viewlist
			If n.root=node SelectView n.index;Return
		Next
		n=New TNodeView
		n.owner=Self
		n.root=node
		n.treeview=CreateTreeView(0,0,ClientWidth(tabber),ClientHeight(tabber),tabber)
		host.options.navstyle.Apply n.treeview,1,host.options.colorcontainers
		SetGadgetLayout n.treeview,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED
		HideGadget n.treeview

		n.index=viewlist.Count()
		viewlist.AddLast n		
		
		AddGadgetItem tabber,node.name
		root=TreeViewRoot(n.treeview)
		node.setnode root,n.index
		SelectView n.index
		Return n.index
	End Method

	Method OnEvent()
		If EventSource()=tabber
			SelectView SelectedGadgetItem(tabber)				
		End If
		If selected And EventSource()=selected.treeview
			selected.OnEvent
		EndIf
	End Method

	Method Refresh()
		For Local view:TNodeView = EachIn viewlist
			host.options.navstyle.Apply view.treeview,1,host.options.colorcontainers
		Next
	End Method

	Method Invoke(command,argument:Object=Null)
		If command=TOOLREFRESH Refresh()		
		If command=TOOLNEWVIEW And selected selected.NewView
	End Method

	Function CreateNavMenu:TGadget()
		Local	edit:TGadget = CreateMenu("&Nav",0,Null)
		CreateMenu "&New View",MENUNEWVIEW,edit
		Return edit
	End Function

	Function Create:TNavBar(host:TCodePlay, parent:TGadget)	',root:TNode)
		Local	n:TNavBar = New TNavBar
		n.host=host	
		n.tabber=CreateTabber(0,0,ClientWidth(parent),ClientHeight(parent),parent)
		SetGadgetLayout(n.tabber,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED)
'		n.AddView root
		n.navmenu=CreateNavMenu()
		Return n		
	End Function

End Type

Type TOutputPanel Extends TToolPanel	'used build and run

	Field	host:TCodePlay
	Field	output:TGadget
	
	Field	process:TProcess
	Field	pipe:TStream

	Field	wpipe:TTextStream

	Field	user$,cmdline$,err$,post$
	Field	errbuffer:TByteBuffer
	Field	outputmenu:TGadget
	Field	posttool:TTool
	
	Field transerror

	Method ClearDumpRequests()
		For Local o:TObj = EachIn MapValues(host.debugtree.objmap)
			o.HasSynced(o.sync)
		Next
	EndMethod
	
	Method SendDumpRequests()
		For Local o:TObj = EachIn MapValues(host.debugtree.objmap)
			If o.syncnext Then
				If o.addr <> "00000000" Then WritePipe "d"+o.addr
				o.HasSynced( host.debugtree.sync )
			EndIf
		Next
	EndMethod
	
	Method Clear()
		If Not output Open()
		SetGadgetText output,""
	End Method
	
	Method WriteAscii(mess$)
		If Not output Open()
		AddTextAreaText output,mess.Replace("~0","")
	End Method

	Method Write(utf8$)
		Local mess$,c,d		
		If Not output Open()
		For Local i:Int = 0 Until utf8.Length		
			c=utf8[i]
			If c<128
				mess:+Chr(c)
				d=0
				Continue
			EndIf
			If d
				mess:+Chr((d-192)*64+(c-128))				
				d=0
				Continue
			EndIf
			d=c
		Next
		AddTextAreaText output,mess.Replace("~0","")
	End Method

	Method Execute(cmd$,mess$="",exe$="",home=True,owner:TTool=Null)
		If Not output Open()
		If Not mess$ mess$=cmd$
		err$=""
		post$=exe
		posttool=owner
		host.SelectPanel Self
		host.debugtree.Reset
				
		If process And ProcessStatus(process)
			Delay 500
			If ProcessStatus(process)
				Notify "Current process still busy "+cmdline+"."
				Return
			EndIf
		EndIf
		cmd=cmd.Trim()
		process=CreateProcess(cmd$,HIDECONSOLE)
				
		If Not process Then Notify "Process failed to start "+cmd+".";Return

		pipe=Process.pipe
		wpipe=TTextStream.Create(pipe,TTextStream.UTF8)

		cmdline=cmd
		If home Clear
		Write( mess+"~n" )
		errbuffer = New TByteBuffer
		host.RefreshToolbar	

	End Method

	Method WritePipe(l$)	
		Try
			If pipe pipe.WriteLine(l)
		Catch ex:TStreamWriteException
			Write "Process debug failure. Cannot write:~n"+l+"~n"
			Stop
		EndTry	
	End Method

	Method Go()
		WritePipe "r"
		host.debugtree.cancontinue = False
		host.SelectPanel Self
		host.RefreshToolbar()
	End Method
	
	Method StepOver()
		ClearDumpRequests()
		WritePipe "s"
	End Method
	
	Method StepIn()
		ClearDumpRequests()
		WritePipe "e"
	End Method

	Method StepOut()
		ClearDumpRequests()
		WritePipe "l"
	End Method
	
	Method Stop()
		If Not process Return		
		process.Terminate()
		FlushPipes process.pipe,process.err		
		process.Close()
		process=Null
		Write "~nProcess Terminated~n"
		host.DebugExit()
		Close()
	End Method
	
	Method Wait()
		While process And process.status()
			PollSystem
		Wend
	End Method
	
	Method Invoke(command,argument:Object=Null)
		Select command
			Case TOOLSHOW
				host.SetTitle()
				If output 
					ActivateGadget output	
					host.options.outputstyle.apply output,1,host.options.colorcontainers
				EndIf
			Case TOOLREFRESH
				host.options.outputstyle.apply output,1,host.options.colorcontainers
			Case TOOLCLOSE
				host.RemovePanel Self
				output=Null
			Case TOOLCUT
				GadgetCut output
			Case TOOLCOPY
				GadgetCopy output
			Case TOOLPASTE
				GadgetPaste output
			Case TOOLSELECTALL
				If output SelectTextAreaText output
			Case TOOLESCAPE
				Escape
'			Case TOOLBACKSPACE
'				out.writechar(KEY_BACKSPACE)
		End Select
	End Method
	
	Method Close()
		host.SelectPanel host.activepanel
	End Method
	
	Method Escape()
		Stop
		Close
	End Method
	
	Function outputfilter(event:TEvent,context:Object)
		Local out:TOutputPanel=TOutputPanel(context)
		If Not out Return
		Select event.id
			Case EVENT_KEYDOWN
				If event.data=27
					out.Escape()
					Return 0
				EndIf
			Case EVENT_KEYCHAR
'				Print "output_keychar "+event.data
				out.writechar(event.data)
		End Select
		Return 1
	End Function
	
	Method OnEvent()
		If EventSource()=output
			If EventID()=EVENT_GADGETMENU
				PopupWindowMenu host.window,outputmenu
			EndIf
		EndIf
' Case EVENT_TIMERTICK
		If Not process Return		
		
		ReadPipes process.pipe,process.err
		
		If Not process.status()
			process.terminate
			FlushPipes process.pipe,process.err
			process.close()
			process = Null
			Write "~nProcess Complete~n"
			host.DebugExit
			
			If transerror
				transerror=False
			Else
				host.SelectPanel Self
			EndIf

			If err
				host.ParseError err
			Else
				If post$
					Local menuaction=Int(post)
					If menuaction
						host.OnMenu menuaction,posttool
'					Else				
'						Execute post$,"","",False,0
					EndIf
				Else
					If host.options.hideoutput Close()
				EndIf
			EndIf
		EndIf	
		
	End Method
		
	Method FlushPipes(pipe:TPipeStream,errpipe:TPipeStream)
		ReadPipes(pipe,errpipe)
		Local bytes:Byte[] = errbuffer.flushbytes()
		If bytes
			Local Line$=String.FromBytes(bytes,Len bytes)
			Line=Line.Replace(Chr(13),"")
			If Line<>">" Write Line
		EndIf
	End Method

	Method ProcessTransOutput(line$)
		Local file$,row,mess$
		Local p,q,r
		
		q=line.find( "<" )
		If q=-1 Return False
		p=line.find( "> : Error : ",q+1 )
		If p=-1 Return False
		
		file=line[..q]
		r=file.findlast("~n")
		file=file[r+1..]
	
		row=Int(line[q+1..p])
		mess=line[p+12..]

		host.SelectError file,1,row
		Notify "Compile Error~n~n"+mess
		host.SetStatus mess		
		
		transerror=True
		
		Return True
	End Method

		
	Method ReadPipes(pipe:TPipeStream,errpipe:TPipeStream)
		Local	status
		Local	bytes:Byte[],line$

		bytes=pipe.ReadPipe()
		If bytes
			Line$=String.FromBytes(bytes,Len bytes)
			line=line.Replace(Chr(13),"")
			If Not ProcessTransOutput(line)	'todo: if ismonkey only
				Write line
			EndIf
		EndIf
		
		If errpipe.ReadAvail() Then
			errbuffer.WriteFromPipe(errpipe)
		Else
			SendDumpRequests()
		EndIf
		
'		If bytes Write String.FromBytes(bytes,bytes.length)
		While errbuffer.LineAvail()
			line$=errbuffer.ReadLine()
			line=host.debugtree.ProcessError(line)
			If line
				Write line+"~n"
				err:+line+"~n"
			EndIf
		Wend
		
	End Method
	
	Method WriteChar(char)
		Local	pipe:TPipeStream
				
		If Not process Return		
		pipe=process.pipe
		If char=3			'CTRL-C
			Stop()
		EndIf
		If char=13			'ENTER
'			Write Chr(10)
			pipe.WriteLine user$
			user=""
		EndIf
		If char=8 And user.length			'DELETE
'			Local pos=TextAreaLen(output)
'			If pos SetTextAreaText output,"",pos-1,1,TEXTAREA_CHARS
			user=user[..user.length-1]
		EndIf
		If char>31
'			Write Chr(char)
			user:+Chr(char)
		EndIf
	End Method
		
	Method Open()
		If output Then
			codeplay.SelectPanel Self
			Return
		EndIf
		codeplay.addpanel(Self)		
		output=CreateTextArea(0,0,ClientWidth(panel),ClientHeight(panel),panel,TEXTAREA_WORDWRAP)
		SetGadgetLayout output,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED
		SetGadgetFilter output,outputfilter,Self		
		SetGadgetText output," "	'simon was here		
		host.options.outputstyle.apply output,1,host.options.colorcontainers
	End Method

	Function CreateOutputMenu:TGadget()
		Local	edit:TGadget = CreateMenu("Edit",0,Null)
		CreateMenu "Cut",MENUCUT,edit
		CreateMenu "Copy",MENUCOPY,edit
		CreateMenu "Paste",MENUPASTE,edit
		CreateMenu "",0,edit
		CreateMenu "Stop",MENUSTOP,edit
		Return edit
	End Function

	Function Create:TOutputPanel(host:TCodePlay)
		Local	o:TOutputPanel = New TOutputPanel
		o.host=host		
		o.name="Output"
		o.outputmenu=CreateOutputMenu()
'		o.Open
		Return o
	End Function

End Type

Type TCodeNode Extends TNode
	Field	owner:TOpenCode
	Field	pos,count
	'Field	groups:TMap=New TMap

	Method Invoke(command,argument:Object=Null)
		Select command
			Case TOOLACTIVATE
				owner.ShowPos(pos)
		End Select
	End Method

	Method Sync(snap:TNode)	
		If snap.name<>name SetName(snap.name)
		Local	n:TCodeNode = TCodeNode(snap)
		If n pos=n.pos;count=n.count
		Super.Sync(snap)
	End Method
	
	Method SetName(n$)
		Local	p = n.find("'")
		If p<>-1 n=n[..p]
		name=n.Trim()
'		If owner.host.options.sortcode
		sortname=n
	End Method
	
	Method Free()
		owner = Null
		Super.Free()
	End Method
	
	Method AddCodeNode:TCodeNode(n$,p0,p1)
		
		Local t$
		Local i:Int = n.find(" ")	'if space then group
		
		If i>0
			t=n[..i]
			n=n[i+1..]
Rem
			p=TNode(groups.ValueForKey(t))
			If Not p
				p=AddNode(t+"s")
				p.Open
				groups.insert t,p
			EndIf
EndRem
		EndIf
		
		Local c:TCodeNode = New TCodeNode
		c.owner=owner
		c.setname n$
		c.pos=p0
		c.count=p1-p0
		Append(c)
		
		Return c
		
	End Method
End Type

Type TDiff
	Field	pos,count,del$,add$,pos0,count0,pos1,textchange = True
End Type

Type TOpenCode Extends TToolPanel
		
	Field host:TCodePlay
	Field textarea:TGadget
	Field dirty=True
	Field filesrc$,cleansrc$,cleansrcl$
	Field Current:TDiff
	Field undolist:TList=New TList
	Field redolist:TList=New TList
	Field helpcmd$,helpstring$
	Field seek$
	Field cursorpos,cursorlen,cursorline
	Field oldpos,oldlen
	Field isbmx,isc,iscpp,ishtml,ismonkey
	Field deferpos = -1
	Field tidyqueue1 = -1, tidyqueue2 = -1
	Field editmenu:TGadget
	Field codenode:TCodeNode
	Field dirtynode,uc
	
	Function IsNotAlpha(c)
		If c<48 And c<>35 Return True
		If c>=58 And c<65 Return True
		If c>=91 And c<95 Return True
		If c>=96 And c<97 Return True
		If c>=123 Return True
	End Function
	
	Function WordAtPos$(a$,p)
		Local	c,q,r,n
	' string literal
		q=a.findlast(EOL$,a.length-p)
		If q=-1 q=0
		For q=q To p-1
			If a[q]=34 Then
				n=Not n
				r=q
			EndIf
		Next
		If n	
			q=a.Find("~q",r+1)+1
			If q=0 q=a.length
			Return a[r..q]
		EndIf
	' alphanumeric
		p=Min(p,a.length-1)	'simon was here - crash when checking at last char
		For p=p Until 0 Step -1	'simon was here unto->to
			If IsNotAlpha(a$[p]) Continue
			Exit
		Next
		For q=p-1 To 0 Step -1
			If IsNotAlpha(a$[q]) Exit
		Next
		For r=p To a.length-1
			If IsNotAlpha(a$[r]) Exit
		Next
		Return a[q+1..r]
	End Function
	
	Function FirstDiff(s0$,s1$)
		Local	n = Min(s0.length,s1.length)
		For Local i:Int = 0 Until n
			If s0[i]<>s1[i] Return i
		Next
		Return n		
	End Function
	
	Function LastDiff(s0$,s1$)
		Local n = Min(s0.length,s1.length)
		Local i = s0.length-1
		Local j = s1.length-1
		While n>0
			If s0[i]<>s1[j] Exit
			i:-1;j:-1;n:-1
		Wend
		Return i+1
	End Function
	
	Method parsebmx(n:TCodeNode)
		Local	src$,Line,col
		Local	p,p1,r,t,m,f,l,e

		src=cleansrcl
		p1=src.length
		p=-1;r=-1;t=-1;m=-1;f=-1;l=-1
		While p<p1			'update rem,type,method,function,label pointers
			While r<=p
				r=FindToken("rem",src,r+1)
			Wend
			While t<=p
				t=FindToken("type",src,t+1)
			Wend
			While m<=p
				m=FindToken("method",src,m+1)
			Wend
			While f<=p
				f=FindToken("function",src,f+1)
			Wend
			While l<=p
				l=FindLabel(src,l+1)
			Wend
			If r<t And r<m And r<f And r<l
				p=FindEndToken("rem",src,r+1,True)
				Continue
			EndIf
			p=Min(t,Min(m,Min(f,l)))
			If p=src.length Exit		
			While (n And n.parent And p>n.pos+n.count)
				If Not TCodeNode(n.parent)
					If n.parent.parent
						n = TCodeNode(n.parent.parent)
					Else
						n = Null
					EndIf
				Else
					n=TCodeNode(n.parent)
				EndIf
			Wend
			If t<m And t<f And t<l
				e=src.find(EOL,t)
				n=n.AddCodeNode(cleansrc[t..e],t,FindEndToken("type",src,t,True))
				p=t+1
				Continue
			EndIf
			If m<f And m<l
				e=src.find(EOL,m)
				n.AddCodeNode(cleansrc[m..e],m,e)
				p=m+1
				Continue
			EndIf
			If f<l
				e=src.find(EOL,f)
				n.AddCodeNode(cleansrc[f..e],f,e)
				p=f+1
				Continue		
			Else
				e=src.find(EOL,l)
				n.AddCodeNode(cleansrc[l..e],l,e)
				p=l+1
				Continue				
			EndIf
		Wend
	End Method

	Method parsemonkey(root:TCodeNode)
		Local src$,Line,col
		Local p,p1,r,t,m,f,l,e
		Local n:TCodeNode

		n=root
		src=cleansrcl
		p1=src.length
		p=-1;r=-1;t=-1;m=-1;f=-1;
		l=p1
		While p<p1			'update rem,type,method,function,label pointers
			While r<=p
				r=FindToken("#rem",src,r+1)
			Wend
			While t<=p
				t=FindToken("class",src,t+1)
			Wend
			While m<=p
				m=FindToken("method",src,m+1)
			Wend
			While f<=p
				f=FindToken("function",src,f+1)
			Wend
			If r<t And r<m And r<f And r<l
				p=FindToken("#end",src,r+1)
				Continue
			EndIf
			p=Min(t,Min(m,Min(f,l)))
			If p=src.length Exit		
			If t<m And t<f And t<l
				e=src.find(EOL,t)
				n=root.AddCodeNode(cleansrc[t..e],t,p1)     'FindEndToken2("class",src,t,True))
				p=t+1
				Continue
			EndIf
			If m<f And m<l
				e=src.find(EOL,m)
				n.AddCodeNode(cleansrc[m..e],m,e)
				p=m+1
				Continue
			EndIf
			If f<l
				e=src.find(EOL,f)
				n.AddCodeNode(cleansrc[f..e],f,e)
				p=f+1
				Continue		
			Else
				e=src.find(EOL,l)
				n.AddCodeNode(cleansrc[l..e],l,e)
				p=l+1
				Continue				
			EndIf
		Wend
	End Method
	
	Method GetNode:TNode()
		Local	root:TCodeNode = New TCodeNode
		root.name = StripDir(path)
		root.owner = Self
		root.count = cleansrc.length
		If isbmx parsebmx(root)
		If ismonkey parsemonkey(root)
		If codenode
			If host.options.sortcode root.sortkids
			codenode.Sync(root)	
			root.Free()
		Else
			codenode=root
		EndIf
		Return codenode
	End Method
		
	Method ShowPos(pos)
		host.SelectPanel( Self )
		Local line=TextAreaLine(textarea,pos)
		SelectTextAreaText textarea,line,1,TEXTAREA_LINES		
		UpdateCursor()
		ActivateGadget( textarea )
	End Method

	Method Debug(Line,column)
		If line>0 line:-1
		SelectTextAreaText textarea,line,1,TEXTAREA_LINES		
		UpdateCursor()
	End Method

	Method Edit()
		SelectTextAreaText( textarea,cursorpos,0,TEXTAREA_CHARS )
		ActivateGadget( textarea )
		UpdateStatus()
	End Method
	
	Method UpdateStatus()
		Local	c = cursorpos+cursorlen
		If cursorline Then c:-TextAreaChar(textarea,cursorline-1)
		host.SetStatus helpstring+"~t~t"+"Line: "+cursorline+" Char: "+(c+1)
	End Method
	
	Method UpdateCursor()
		oldpos=cursorpos
		oldlen=cursorlen
		cursorpos=TextAreaCursor(textarea,TEXTAREA_CHARS)
		cursorlen=TextAreaSelLen(textarea,TEXTAREA_CHARS)
		If cursorpos<>oldpos Or cursorlen<>oldlen
			Local l = TextAreaLine(textarea,cursorpos)+1
			If l<>cursorline And dirtynode
				GetNode().Refresh
				dirtynode=False
				If (deferpos>=0) UpdateCode	'SetCode cleansrc
			EndIf
			cursorline=l
			UpdateStatus()
			BracketMatching(cleansrcl)
			If (tidyqueue1 >= 0 Or tidyqueue2 >= 0) Then UpdateCode()
			PollSystem
		EndIf
	End Method

' tdiff - pos del$ add$

	Method CalcDiff:TDiff(src$)
		Local	d:TDiff
		If src.length<>cleansrc.length
			d=New TDiff
			d.pos0=cursorpos
			d.count0=cursorlen
			d.pos=oldpos
			d.count=oldlen
			If cursorlen And oldlen							'block modified
				d.del=cleansrc[oldpos..oldpos+oldlen]
				d.add=src[oldpos..cursorpos+cursorlen]
				d.pos1=oldpos
			Else
				If cursorpos<=oldpos And cursorlen<=oldlen	'backspace
					d.del=cleansrc[cursorpos..cursorpos+cleansrc.length-src.length]
					d.pos1=cursorpos
				Else										'insert
					d.del=cleansrc[oldpos..oldpos+oldlen]
					d.add=src[oldpos..cursorpos+cursorlen]
					d.pos1=oldpos
				EndIf
			EndIf	
		Else		
			If cursorpos>oldpos									'overwrite
				d=New TDiff
				d.pos0=cursorpos
				d.count0=cursorlen
				d.pos=oldpos
				d.count=oldlen
				d.del=cleansrc[oldpos..cursorpos]
				d.add=src[oldpos..cursorpos]
				d.pos1=oldpos
				If d.del = d.add Then d.textchange=False
			EndIf
		EndIf
		Return d	
	End Method

	Method UpdateCode(makeundo=True)
		Local cpos
		Local src$ = TextAreaText(textarea)
		Local d:TDiff = CalcDiff(src)
		If d
			If makeundo And d.textchange
				undolist.AddLast d
				redolist.Clear
			EndIf
			SetCode src,d
			If d.textchange Then dirtynode=True
		EndIf
		If (deferpos >= 0) Or (tidyqueue1 >= 0) Or (tidyqueue2 >= 0) Then SetCode src
	End Method
	
	Method Undo()
		Local	d:TDiff
		If undolist.IsEmpty() Return
		d=TDiff(undolist.RemoveLast())
		redolist.AddLast d
		SetTextAreaText textarea,d.del,d.pos1,d.add.length
		SelectTextAreaText(textarea,d.pos,d.count)
		SetCode TextAreaText(textarea),d
		UpdateCursor
	End Method

	Method Redo()
		Local	d:TDiff
		If redolist.IsEmpty() Return
		d=TDiff(redolist.RemoveLast())
		undolist.AddLast d
		SetTextAreaText textarea,d.add,d.pos,d.del.length
		SelectTextAreaText(textarea,d.pos0,d.count0)
		UpdateCursor
		SetCode TextAreaText(textarea),d
	End Method
	
	Method RefreshContainers()
		Local rgb:TColor
		If ismonkey
			rgb=host.options.editcolor2
		Else
			rgb=host.options.editcolor1
		EndIf
		If host.options.colorcontainers
			SetContainerColor textarea,rgb,1 
		Else
			SetContainerColor textarea,Null,1 
		EndIf
	End Method
		
	Method RefreshStyle()
	
		Local rgb:TColor
		Local charwidth=host.options.editfont.CharWidth(32)
		
		SetTextAreaTabs textarea,host.options.tabsize*charwidth
		SetTextAreaFont textarea,host.options.editfont
		
		If ismonkey
			rgb=host.options.editcolor2
		Else
			rgb=host.options.editcolor1
		EndIf
		SetTextAreaColor textarea,rgb.red,rgb.green,rgb.blue,True
	
	End Method

	Method Refresh()
		Local rgb:TColor
		Local src$
		RefreshStyle
		RefreshContainers
		rgb=host.options.styles[0].Color
		SetTextAreaColor textarea,rgb.red,rgb.green,rgb.blue,False
		src=cleansrc
		cleansrc=""
		cleansrcl=""
		cursorpos=0
		SetCode(src)
	End Method

	Function IsntAlphaNumeric(c)		'lowercase test only
		If c=35 Return False '# is now special
		If c<48 Return True
		If c>=58 And c<95 Return True
		If c=96 Return True
		If c>=123 Return True
	End Function
	
	Function IsntAlphaNumericOrQuote(c)		'lowercase test only
		If c=35 Return False '# is now special
		If c=34 Return False
		If c<48 Return True
		If c>=58 And c<95 Return True
		If c=96 Return True
		If c>=123 Return True
	End Function

	Function IsCode(src$,p)
		Local n
		Local l = src.FindLast(EOL$,src.length-p)
		If l=-1 l=0
		Local q = src.Find("'",l)
		If q<>-1 And q<p Return
		q=l
		While q<p
			q=src.Find(QUOTES$,q)+1
			If q=0 Exit
			If q<=p n:+1
		Wend
		Return Not(n&1)
	End Function

	Function FindLabel(src$,pos)
		Local	p,q,c
		While pos>=0
			p=src.Find("#",pos)
			If p=-1 Exit
			q=p
			While q>0
				q:-1
				c=src[q]
				If c=13 Return p
				If c=10 Return p
				If c=32 Or c=9 Continue
				Exit
			Wend
			If q<0 Return p
			pos=p+1
		Wend
		Return src.length	
	End Function
	
	Function FindToken(token$,src$,pos)	'lowercase src only!
		Local p,c
		Local n=token.length
		While pos>=0
			p=src.Find(token,pos)
			If p=-1 Exit
			c=10 If p>0 c=src[p-1]
			If isntalphanumeric(c)
				If p+n<src.length c=src[p+n]
				If isntalphanumeric(c)
					If iscode(src,p)
						If p<4 Or src[p-4..p]<>"end " Return p
					EndIf
				EndIf
			EndIf
			pos=p+1
		Wend
		Return src.length
	End Function

	Function FindEndToken(token$,src$,pos,returnlast=False)	'if true returns first character after endtoken
		Local	p,q,e$,n
		
		p=pos
		e$="end"+token
		n=e.length
		While p<src.length
			p=src.Find(e$,p)
			If p=-1 Exit
			If p+n=src.length Or isntalphanumeric(src[p+n])
				If iscode(src,p)
					If p=0 Or isntalphanumeric(src[p-1]) Exit
				EndIf
			EndIf
			p=p+n
		Wend
		If p=-1 p=src.length Else If returnlast p:+n
		q=pos
		e$="end "+token
		n=e.length
		While q<src.length
			q=src.Find(e$,q)
			If q=-1 Exit
			If q+n=src.length Or isntalphanumeric(src[q+n])
				If iscode(src,q)
					If q=0 Or isntalphanumeric(src[q-1]) Exit
				EndIf
			EndIf
			q=q+n
		Wend
		If q=-1 q=src.length Else If returnlast q:+n
		Return Min(p,q)
	End Function

' class,method,function,
' if,for,while,repeat
' endif,next,wend,until,forever

	Function FindEndToken2(token$,src$,pos,returnlast=False)
		Local	p,q,e$,n
		
		p=pos
		e$="end"+token
		n=e.length
		While p<src.length
			p=src.Find(e$,p)
			If p=-1 Exit
			If p+n=src.length Or isntalphanumeric(src[p+n])
				If iscode(src,p)
					If p=0 Or isntalphanumeric(src[p-1]) Exit
				EndIf
			EndIf
			p=p+n
		Wend
		If p=-1 p=src.length Else If returnlast p:+n
		q=pos
		e$="end "+token
		n=e.length
		While q<src.length
			q=src.Find(e$,q)
			If q=-1 Exit
			If q+n=src.length Or isntalphanumeric(src[q+n])
				If iscode(src,q)
					If q=0 Or isntalphanumeric(src[q-1]) Exit
				EndIf
			EndIf
			q=q+n
		Wend
		If q=-1 q=src.length Else If returnlast q:+n
		Return Min(p,q)
	End Function


	Function IsFirstCharOnLine(src$,pos)
		Local	c
		For Local i:Int = 1 To pos
			c=src[pos-i]
			If c=10 Or c=13 Return True
			If c>32 Return False
		Next
		Return True
	End Function

' rem and endrem must be first nonwhitespace on line - following funcs are for lowercase src only

	Method FindRem(src$,pos)
		Local remtoken$
		DebugStop
		If ismonkey remtoken="#rem" Else remtoken="rem" 
		While pos<src.length
			pos=FindToken(remtoken,src,pos)
			If pos=src.length Exit
			If IsFirstCharOnLine(src,pos) Return pos
			pos:+1
		Wend
		Return pos
	End Method

	Method FindEndRem(src$,pos,returnlast=False)
		Local	i,c		
		Local remtoken$
		If ismonkey 
			While pos<src.length
				pos=FindToken("#end",src,pos)
				If pos=src.length Exit
				If IsFirstCharOnLine(src,pos)
					If returnlast
						pos:+4
					EndIf
					Return pos
				EndIf
				pos:+1
			Wend		
		Else		
			While pos<src.length
				pos=FindEndToken("rem",src,pos)
				If pos=src.length Exit
				If IsFirstCharOnLine(src,pos)
					If returnlast
						If src[pos+5]=Asc("e") Or src[pos+5]=Asc("E") pos:+1
						pos:+6
					EndIf
					Return pos
				EndIf
				pos:+1
			Wend
		EndIf
		Return src.length
	End Method

	Method FindPrevRem(src$,pos)	'lowercase src only!
		Local p,c
		Local remtoken$
		If ismonkey remtoken="#rem" Else remtoken="rem" 
		While pos>0
			If pos>src.length Exit	'fixed endrem on lastline overrun
			p=src.FindLast(remtoken,src.length-pos)
			If p=-1 Exit						
			If ismonkey And IsFirstCharOnLine(src,p) Return p			
			If isntalphanumeric(src[p+3]) And IsFirstCharOnLine(src,p) Return p			
			pos=p-1
		Wend
		Return -1
	End Method
	
	Method IsRemmed(pos,src$)
		Local p = FindPrevRem(src$,Min(pos+3,src.length))
		If p<0 Return
		p=FindEndRem(src$,p)
		If p<0 Or pos<p Return True
	EndMethod
	
	Method WasRemmed(pos,src$)
		Local s$ = cleansrcl
		Local p = (src.length-s.length)
		If p<0 pos:-p
		p=FindPrevRem(s$,Min(pos+3,s.length))
		If p<0 Return
		p=FindEndRem(s$,p)
		If pos<p Return True
	End Method

	Method CheckDirty(src$)
		SetDirty (Not (src=filesrc And undolist.IsEmpty()))
	End Method
	
	Method HasTidyQueue()
		Return ((deferpos >= 0) Or (tidyqueue1 >= 0) Or (tidyqueue2 >= 0))
	EndMethod
	
	Method ClearTidyQueue(start,endpos)
		If start<=deferpos And deferpos < endpos Then deferpos = -1
		If start<=tidyqueue1 And tidyqueue1 < endpos Then tidyqueue1 = -1
		If start<=tidyqueue2 And tidyqueue2 < endpos Then tidyqueue2 = -1
	EndMethod
	
	Method SetCode(src$,diff:TDiff=Null)
		Local	same,i,p,startp,p1,q,r,a,n,t$,h$,lsrc$,r0,r1,cpos,autocap
		Local	style:TTextStyle[5],s:TTextStyle
' update dirty flag	
		CheckDirty src
		same = Not ((diff) Or (src<>cleansrc))
		If same And Not (diff Or HasTidyQueue()) Then Return	
		If (Not isbmx And Not ismonkey) Or Not host.options.syntaxhighlight	'Or Not host.quickhelp
			If Not same Then
				cleansrc=src
				cleansrcl=src.ToLower()
			EndIf
			Return
		EndIf
' doit
		autocap=host.options.autocapitalize
		If same Then lsrc = cleansrcl Else lsrc=src.ToLower()
		cpos=TextAreaCursor(textarea,TEXTAREA_CHARS)
		LockTextArea textarea
		style=host.options.styles
' calculate highlight region
		
		If diff
			p=diff.pos
			p1=p+diff.add.length
			If Not diff.add.length Then
				p:-diff.del.length
			EndIf
		ElseIf HasTidyQueue()
			p=src.length
			If (deferpos>=0) Then
				p = Min(p,deferpos)
				p1 = Max(p1,deferpos+1)
			EndIf
			If (tidyqueue1>=0) Then
				p = Min(p,tidyqueue1)
				p1 = Max(p1, tidyqueue1+1)
			EndIf
			If (tidyqueue2>=0) Then
				p = Min(p,tidyqueue2)
				p1 = Max(p1, tidyqueue2+1)
			EndIf
		Else
			p=firstdiff(src,cleansrc)
			p1=lastdiff(src,cleansrc)
		EndIf
		q=src.length-cleansrc.length
		If p1-p<q p1=p+q
		If p1<p p1=p
		
' round region to line breaks
		'Print "p="+p+" p1="+p1
		If p>src.length p=src.length
		p=src.findlast(EOL,src.length-(p-1))+1
		p1=src.find(EOL,p1)+1
		If p1=0 p1=src.length
' if endrem between p0,p1 and next rem after p1 move p1 forwards
		r1=FindEndRem(lsrc,p)
		If r1<p1 And wasremmed(r1+6,lsrc)
			r0=FindRem(lsrc,r1+6)
			If r0>p1 p1=r0
		EndIf
' if rem between p0,p1 and matching endrem after p1 move p1 forewards
		r0=FindPrevRem(lsrc,p1)
		If r0>=p And r0+3<>cpos	'defer fix
			r1=FindEndRem(lsrc,r0,True)
			If r1>p1 p1=r1
		EndIf
' if rem before p0 and matching endrem after p0 highlight to endrem and move p0 forwards
		r0=FindPrevRem(lsrc,p)
		If r0<>-1 And r0<p
			r1=FindEndRem(lsrc,r0,True)
			If r1>p
				s=style[COMMENT]
				If r1>p s.Format(textarea,p,r1-p)
				If autocap And r1<src.length
					If lsrc[r1-6..r1]="endrem" And src[r1-6..r1]<>"EndRem" SetTextAreaText textarea,"EndRem",r1-6,6
					If lsrc[r1-7..r1]="end rem" And src[r1-7..r1]<>"End Rem" SetTextAreaText textarea,"End Rem",r1-7,7
				EndIf
				ClearTidyQueue(p,r1)
				p=r1
			EndIf
		EndIf	
' if was remmed and now isn't move p1 down to nearest rem or endrem
		If WasRemmed(p,lsrc)
			r0=FindRem(lsrc,p)
			r1=FindEndRem(lsrc,r0,True)
			p1=Max(p1,Min(r0,r1))	
		EndIf
' highlight code
		ClearTidyQueue(p,p1)
		
		s=style[NORMAL]
		If p1>p s.format(textarea,p,p1-p)
		startp = p
		
		While p<p1
			a=src[p]
' quoted strings
			If a=34
				q=p1

' use a quotecount to block unformed string tokenizing				
				n=src.Find(EOL,p+1)
				If n>p1 n=p1
				Local quotecount=0
				For Local odd=p Until n
					If src[odd]=34 quotecount:+1
				Next
				
				r=src.Find(Chr(34),p+1)
' closing quote to 
				If r>-1 And r<q And (quotecount&1=0) q=r+1

				r=src.Find(EOL,p+1)
				If r>-1 And r<q q=r

				s=style[QUOTED]
				s.format(textarea,p,q-p)
				p=q
				Continue
			EndIf
' single line comments
			If a=39
				q=p1
				r=src.Find(EOL,p+1)
				If r>-1 And r<q q=r
				s=style[COMMENT]
				s.format(textarea,p,q-p)
				p=q
				Continue				
			EndIf
' tokens
			If (a>=65 And a<91) Or (a>=97 And a<123) Or (a=95) Or (a=35) '# now valid
				q=p+1
				While q<p1
					a=src[q]
					If a<48 And a<>35 Exit	'changed to include dot (chr 47)
					If a>=58 And a<65 Exit
					If a>=91 And a<95 Exit
					If a=96 Exit
					If a>122 Exit
					q:+1
				Wend
				t$=src[p..q]
				Local remtoken$="Rem"
				If isbmx And host.quickhelp h$=host.quickhelp.token(t$)
				If ismonkey h$=host.monkeyhelp.token(t$);remtoken="#rem"
				If h$
					If h$<>t$ And autocap 'And isbmx
						If cpos<p Or cpos>q
							SetTextAreaText textarea,h,p,h.length
						Else
							deferpos=q
						EndIf
					EndIf
					s=style[KEYWORD]
					If h$=remtoken And IsFirstCharOnLine(lsrc,p)	' Not (p>4 And lsrc[p-4..p]="End ")
						If q<>cpos
							q=FindEndRem(lsrc,p,True)
							s=style[COMMENT]
						Else
							deferpos=q
						EndIf						
					EndIf
					s.format(textarea,p,q-p)
				EndIf
				p=q
				Continue
			EndIf
' numbers
			If (p=0 Or IsntAlphaNumeric(lsrc[p-1])) And ((a>=$30 And a<$3A) Or (a=$24) Or (a=$25) Or (a=$2E))	'0-9, $, %, .
				q=p+1
				Local hexed:Int = (a=$24), binaried:Int = (a=$25), dots:Int = (a=$2E)
				Local valid:Int = Not(hexed Or binaried Or dots)
				
				While q<(p1)
					a=lsrc[q]
					q:+1
					If (a>=$30 And a<$3A) Then
						valid = True
						Continue	'0-9
					EndIf
					If hexed
						If (a>=$61 And a<$67) Then	'a-f (only test lower as 'a' var is from lsrc)
							valid = True
							Continue
						EndIf
					EndIf
					If (a=$2E) Then
						'Hex or Binary literals don't support decimal points
						If Not (hexed Or binaried) Then
							dots:+1
							'Fix for slicing '..' syntax
							If src[q-2] = $2E Then
								dots:-2
								q:-2
								Exit
							EndIf
							'End Fix
							Continue
						EndIf
					EndIf
					If Not IsntAlphaNumeric(a) Then valid = False
					q:-1
					Exit
				Wend
				If valid And dots < 2 Then style[NUMBER].format(textarea,p,(q-p))
				'Fix for slicing '..' syntax
				If q<src.length And (src[q]=Asc(".")) Then q:+1
				If q<src.length And (src[q]=Asc(".")) Then q:+1
				'End Fix
				p=q
				Continue
			EndIf
			p:+1
		Wend
		BracketMatching(lsrc,startp,p1,True)
		UnlockTextArea textarea
		If Not same
			cleansrc=src
			cleansrcl=lsrc
		EndIf
'		CheckDirty src	simon was here
	End Method
	
	Field currentbrackets:Int[]
	
	Method BracketMatching(lsrc$,cln1=-1,cln2=-1,alwaysfind:Int = False)
		
		Local check:Int, depth:Int, style:TTextStyle[] = host.options.styles
		Local otherchar:Int = 0, absotherchar:Int = 0, othercharpos:Int = 0, limit:Int
		Local currentchar:Int = 0, currentcharpos:Int = Max(cursorpos-1,0)
		
		If cursorlen Then Return
		
		If currentbrackets Then
			If Not(cln2 > currentbrackets[0] And cln1 <= currentbrackets[0]) Then
				If currentbrackets[0]>-1 Then tidyqueue1 = currentbrackets[0]
			EndIf
			If Not(cln2 > currentbrackets[1] And cln1 <= currentbrackets[1]) Then
				If currentbrackets[1]>-1 Then tidyqueue2 = currentbrackets[1]
			EndIf
			currentbrackets = Null
			If Not alwaysfind Then Return
		EndIf
		
		If host.options.bracketmatching And isbmx And Not IsRemmed(currentcharpos,lsrc) Then
			
			limit = Min(lsrc.length,currentcharpos+2)
			
			While currentcharpos >= 0 And currentcharpos < limit
				If IsCode(lsrc,currentcharpos) Then
					Select lsrc[currentcharpos]
						Case Asc("(");otherchar = Asc(")");Exit
						Case Asc("{");otherchar = Asc("}");Exit
						Case Asc("[");otherchar = Asc("]");Exit
						' Negate char code to search backwards
						Case Asc(")");otherchar = -Asc("(");Exit
						Case Asc("}");otherchar = -Asc("{");Exit
						Case Asc("]");otherchar = -Asc("[");Exit
					EndSelect
				EndIf
				currentcharpos:+1
			Wend
			
			If otherchar Then
				
				absotherchar = (Abs otherchar)
				currentchar = lsrc[currentcharpos]
				
				LockTextArea textarea
				style[MATCHING].format(textarea, currentcharpos, 1)
				currentbrackets = [currentcharpos,-1]
				
				othercharpos =  currentcharpos+(otherchar/absotherchar)
				
				While othercharpos < lsrc.length And othercharpos >= 0
					
					If IsCode(lsrc,othercharpos) Then
						Select lsrc[othercharpos]
							Case Asc(" "), Asc("~t")
								'Do nothing
							Case Asc("'")
								Exit
							Case absotherchar
								If check < 0 Then Exit Else check = 0
								If depth Then
									depth:-1
								Else
									style[MATCHING].format(textarea, othercharpos, 1)
									currentbrackets[1] = othercharpos
									UnlockTextArea textarea
									Return
								EndIf
							Case Asc("~n")
								If (otherchar/absotherchar) > 0 Then
									If check = 2 Then check = 0 Else Exit
								Else
									If check < 0 Then Exit Else check = -2
								EndIf
							Case Asc(".")	
								check:+1
							Default
								If check < 0 Then Exit Else check = 0
								If lsrc[othercharpos] = lsrc[currentcharpos] Then depth:+1
						EndSelect
					EndIf
					
					othercharpos:+(otherchar/absotherchar)
					
				Wend
				
				UnlockTextArea textarea
				
			EndIf
			
		EndIf
		
	EndMethod
	
	Method AutoIndent()
		Local	p,q
		Local c = TextAreaCursor(textarea,TEXTAREA_CHARS)
		Local n = TextAreaSelLen(textarea,TEXTAREA_CHARS)
		If c<cleansrc.length
			p=cleansrc.FindLast(EOL,cleansrc.length-(c-1))+1
			q=p
			While cleansrc[q]=9 And q<c
				q:+1
			Wend
			If q>c q=c
		EndIf
		SetTextAreaText textarea,EOL$+cleansrc[p..q],c,n
		SelectTextAreaText textarea,c+1+q-p,0			
		UpdateCursor
		UpdateCode
	End Method
	
	Method IndentCode()
		Local	a$
' blockindent
		Local p0 = TextAreaCursor(textarea,TEXTAREA_LINES)
		Local p1 = TextAreaSelLen(textarea,TEXTAREA_LINES)
' v122: make sure the entire block is selected (start cursor pos may in the middle of the line)
		SelectTextAreaText textarea , p0 , p1 , TEXTAREA_LINES
		UpdateCursor
		For Local i:Int = 0 Until p1
			a$="~t"+TextAreaText(textarea,p0+i,1,TEXTAREA_LINES)
			SetTextAreaText textarea,a$,p0+i,1,TEXTAREA_LINES
		Next
		SelectTextAreaText textarea,p0,p1,TEXTAREA_LINES
		UpdateCursor
		UpdateCode
	End Method

	Method OutdentCode()
		Local	a$,modified
' blockoutdent
		Local p0 = TextAreaCursor(textarea,TEXTAREA_LINES)
		Local p1 = TextAreaSelLen(textarea,TEXTAREA_LINES)
' v122: make sure the entire block is selected (start cursor pos may in the middle of the line)
		SelectTextAreaText textarea , p0 , p1 , TEXTAREA_LINES
		UpdateCursor
		For Local i:Int = 0 Until p1
			a$=TextAreaText(textarea,p0+i,1,TEXTAREA_LINES)
			If a[0]=9 a$=a$[1..];modified=True
			SetTextAreaText textarea,a$,p0+i,1,TEXTAREA_LINES
		Next
		If Not modified
			For Local i:Int = 0 Until p1
				a$=TextAreaText(textarea,p0+i,1,TEXTAREA_LINES)
				If a[0]=32 a$=a$[1..]
				SetTextAreaText textarea,a$,p0+i,1,TEXTAREA_LINES
			Next	
		EndIf
		SelectTextAreaText textarea,p0,p1,TEXTAREA_LINES
		UpdateCursor
		UpdateCode
	End Method

	Function FilterKey(event:TEvent,context:Object)
'		If event.id<>EVENT_KEYCHAR Return 1
		Local id=event.id
		Local key=event.data
		Local mods=event.mods
		Local this:TOpenCode=TOpenCode(context)
?MacOS
		If key=25 And mods=MODIFIER_SHIFT key=KEY_TAB
?
		If id=EVENT_KEYCHAR And this And key=KEY_TAB And TextAreaSelLen( this.textarea,TEXTAREA_CHARS )
			Select mods
				Case MODIFIER_NONE
					this.IndentCode
				Case MODIFIER_SHIFT
					this.OutdentCode
			End Select
			Return 0
		EndIf

		If id=EVENT_KEYDOWN And key=KEY_ENTER And this And this.host.options.autoindent
			this.AutoIndent()
			Return 0
		EndIf
		
		Return 1
	End Function

	Method OnEvent()
 		Select EventSource()
			Case textarea
				Select EventID()
					Case EVENT_GADGETMENU
						PopupWindowMenu host.window,editmenu
					Case EVENT_GADGETACTION
						UpdateCode
					Case EVENT_GADGETSELECT
						UpdateCursor
				End Select
		End Select
	End Method
			
	Method SetDirty( bool )
		If dirty=bool Return
		dirty=bool
		name=StripDir(path)
		If (dirty) name:+"*"
		If (host.lockedpanel=Self) name="build:"+name
		host.RefreshPanel Self
		PollSystem
	End Method
	
	Method SetLocked( bool )
		Local locked:TOpenCode = TOpenCode(host.lockedpanel)
		If locked And locked<>Self locked.SetLocked False
		name=StripDir(path)
		If (dirty) name:+"*"
		If (bool)
			name="build:"+name
			host.lockedpanel=Self
		Else
			host.lockedpanel=Null
		EndIf
		host.RefreshPanel Self
	End Method
	
	Method Help()
		If isbmx And Not host.quickhelp Return
		If ismonkey And Not host.monkeyhelp Return
		Local p = TextAreaCursor(textarea,TEXTAREA_CHARS)
		Local a$ = WordAtPos(cleansrc,p)
		
		helpcmd=a	' quick help disabled in monk, straight to real help
		
		If a=helpcmd
			
			Local l$
			If isbmx 
				l$ = host.quickhelp.link(a$)
				If l
					host.helppanel.go host.bmxpath+l$
				EndIf
			EndIf
			If ismonkey 
				l$ = host.monkeyhelp.link(a$)				
				If l<>"" host.helppanel.go l$
			EndIf
		Else
			helpcmd=a$
			If isbmx helpstring$=host.quickhelp.help(a$)
			If ismonkey helpstring$=host.monkeyhelp.help(a$)
			UpdateStatus	'host.setstatus helpstring$
		EndIf
	End Method

	Method Find()
		Local p=TextAreaCursor(textarea,TEXTAREA_CHARS)
		Local term$=""
		If cleansrc[p]<>32 term=WordAtPos(cleansrc,p)
		host.findreq.ShowFind term
	End Method
		
	Method FindNext(s$)
		If s seek=s Else s=seek
		Local p = TextAreaCursor(textarea,TEXTAREA_CHARS)
		p:+TextAreaSelLen(textarea,TEXTAREA_CHARS)
' case insensitive
		Local l$ = s.toLower()
		p=cleansrcl.Find(l$,p)
		If p=-1 p=cleansrcl.Find(l$)
' case sensitive
'		p=cleansrc.Find(s$,p+1)
'		if p=-1 p=cleansrc.Find(s$)
		If p=-1
			Notify "Could not find '"+s+"'."
			Return False
		Else
			SelectTextAreaText textarea,p,Len s,TEXTAREA_CHARS
			UpdateCursor
			Return True
		EndIf
	End Method

	Method ReplaceAll(s$,r$)
		Local t$ = TextAreaText( textarea ).ToLower()
		Local c = TextAreaCursor(textarea,TEXTAREA_CHARS),i,p
		s = s.ToLower()
		Repeat
			Local i2=t.Find( s,i )
			If i2=-1 Exit
			p:+i2-i
			i=i2+s.length
			SelectTextAreaText textarea,p,s.length
			UpdateCursor
			UpdateCode		
			SetTextAreaText textarea,r,p,s.length
			If p<c c=c+r.length-s.length			
			p:+r.length
			SelectTextAreaText textarea,p,0
			UpdateCursor
			UpdateCode
		Forever
		SelectTextAreaText textarea,c,0
		UpdateCursor
	End Method
	
	Method FindReplace(r$)
		Local n, f$, x$
		Local p = r.Find("~0")
		If p>0
			f$=r[..p]
			r$=r[p+1..]
			ReplaceAll f$,r$
		Else
			p=TextAreaCursor(textarea,TEXTAREA_CHARS)
			n=TextAreaSelLen(textarea,TEXTAREA_CHARS)
			If Not n Return
			SetTextAreaText textarea,r$,p,n
			SelectTextAreaText textarea,p+r.length,0
			UpdateCursor
			UpdateCode		
		EndIf
		Return True
	End Method
	
	Method ReadSource(path$)
		Local	src$		
		src=CacheAndLoadText(path)
		src=src.Replace(Chr(13),"")
		src=src.Replace(Chr(11),"")
		LockTextArea textarea
		SetTextAreaText textarea,src
		UnlockTextArea textarea
		filesrc=TextAreaText(textarea)
		cleansrc=""
		cleansrcl=""
		ActivateGadget textarea		
	End Method
	
	Method SaveSource(file$)
		If host.options.autobackup
			DeleteFile file+".bak"
			RenameFile file,file+".bak"
		EndIf
		Local src$ = TextAreaText(textarea)

Rem
		If ismonkey	'new non-ascii strip search monkey patrol
			Local i
			Local notascii
			For i=0 Until src.Length
				If src[i]>127 Or src[i]<0 
					notascii=True
				EndIf
			Next
			If notascii And Confirm("Strip non-ascii characters found in~n"+file+"?")
				For i=0 Until src.Length
					If src[i]>127 Or src[i]<0 
						src=src.Replace(src[i..i+1]," ")
					EndIf
				Next

				LockTextArea textarea
				SetTextAreaText textarea,src
				UnlockTextArea textarea

			EndIf
			
		EndIf
EndRem

		filesrc=src
		src=src.Replace(Chr(13),Chr(10))
		src=src.Replace(Chr(11),"")
		Local txt$ = src.Replace$(Chr(10),Chr(13)+Chr(10))		

' let archiver back up old
		If host.history
			Local pathdata:Object[2]
			pathdata[0]=path
			pathdata[1]=txt
			host.history.Invoke TOOLARCHIVE,pathdata
		EndIf
		
		Try
			SaveText txt,file
		Catch exception:Object
			Local err$=String(exception)
			Notify "Save Error~n"+err
			Return False
		EndTry
				
		path=host.FullPath$(file)
		dirty=True
		SetDirty False
		host.AddRecent(path$)
		Return True
	End Method

	Method BuildSource(quick,debug,threaded,gui,run)
		Local cmd$,out$,arg$		
		
		If ismonkey
			host.monkeyreq.ShowMonkey path,run,debug
			Return
		Else If isbmx Or isc Or iscpp
			cmd$=quote(host.bmkpath)
			cmd$:+" makeapp"
			If run cmd$:+" -x"
			If debug cmd$:+" -d" Else cmd$:+" -r"	'-v
			If threaded cmd$:+" -h"
			If gui cmd$:+" -t gui"
			If Not quick cmd$:+" -a"
			If debug Or threaded
				out=StripExt(host.FullPath(path))
				If debug out:+".debug"
				If threaded out:+".mt"
				cmd:+" -o "+quote(out$)+" "
			EndIf		
			cmd$:+" "+quote(host.FullPath(path))
			If run
				arg$=host.GetCommandLine()
				If arg cmd$:+" "+arg
			EndIf
			host.execute cmd,"Building "+StripExt(StripDir(path))	',exe$
		Else
			If ishtml
				host.helppanel.Go "file://"+path
			Else
'see what the system shell thinks of the file
				Local cd$=CurrentDir()
				ChangeDir ExtractDir(path)
				cmd=StripDir(path)
				host.execute cmd,"Building "+cmd
				ChangeDir cd
			EndIf			
		EndIf
'		print cmd
	End Method
	
	Method Save()
		Local	file$ = path
		If host.IsTempPath(path)
			file=RequestFile("Save As",FileTypeFilters,True,"")
			If file="" Return False
			If ExtractExt(file)="" file=file+".monkey"		'".bmx"
			dirty=True
		EndIf
		If dirty SaveSource(file)
		Return True
	End Method
' common command interface

	Method Invoke(command,argument:Object=Null)
		Local	file$,ex$
		Local	p,res
		Select command
			Case TOOLSHOW
				host.SetCodeNode GetNode()
				host.SetTitle path				
				If textarea 
					ActivateGadget textarea				
					RefreshContainers
				EndIf
			Case TOOLCLOSE
				If dirty 'Or host.IsTempPath(path)
					Invoke(TOOLSHOW)
					p=Proceed("Save changes to "+name+"?")	'the current file?
					If p=-1 Return True
					If p=1
						If Not Save() Return True
					EndIf
				EndIf
				If codenode Then
					codenode.Free()
					codenode=Null
				EndIf
				'Added just in case MaxGUI driver doesn't handle properly.
				SetGadgetFilter textarea,Null,Null
				'Seb gone.
				host.RemovePanel Self
				FreeGadget(editmenu)
			Case TOOLSAVE
				Save
			Case TOOLQUICKSAVE
				file=path
				If dirty SaveSource(file)
			Case TOOLSAVEAS
				file=path
				If host.IsTempPath(path) file$=""
				file=RequestFile("Save As",FileTypeFilters,True,file)
				If file="" Return
				ex$=ExtractExt(file)
				If ex$=""
					file=file+".monkey"
					ismonkey=True
				Else
					If host.bmxpath isbmx=(ex.ToLower()="bmx")
					ishtml=(ex.ToLower()="html")
					isc=(ex.ToLower()="c")
					iscpp=(ex.ToLower()="cpp" Or ex.ToLower()="cxx")
					ismonkey=(ex.ToLower()="monkey")
				EndIf				
				SaveSource(file$)
				Refresh()
				GetNode().Refresh
				SetDirty False
				host.SetTitle path
			Case TOOLGOTO
				Local Line=Int(String(argument))
				SelectTextAreaText textarea,Line-1,0,TEXTAREA_LINES				
				UpdateCursor
				ActivateGadget textarea		
			Case TOOLFIND
				Find
			Case TOOLFINDNEXT
				Return FindNext(String(argument))
			Case TOOLREPLACE
				Return FindReplace(String(argument))	
			Case TOOLBUILD
				BuildSource host.quickenabled,host.debugenabled,host.threadedenabled,host.guienabled,False
			Case TOOLRUN
				BuildSource host.quickenabled,host.debugenabled,host.threadedenabled,host.guienabled,True
			Case TOOLLOCK
				SetLocked True
			Case TOOLUNLOCK
				SetLocked False			
			Case TOOLHELP
				Help()
			Case TOOLUNDO
				Undo()
			Case TOOLREDO
				Redo()
			Case TOOLREFRESH
				Refresh()
			Case TOOLCUT
				GadgetCut textarea
				UpdateCursor()
				UpdateCode()
			Case TOOLCOPY
				GadgetCopy textarea
			Case TOOLPASTE
				GadgetPaste textarea
				UpdateCursor()
				UpdateCode()
			Case TOOLSELECTALL
				SelectTextAreaText textarea
				UpdateCursor()
			Case TOOLINDENT
				IndentCode()
			Case TOOLOUTDENT
				OutdentCode()
			Case TOOLPRINT
				GadgetPrint textarea
		End Select
	End Method
		
	Function CreateEditMenu:TGadget()
		Local	edit:TGadget = CreateMenu("Edit",0,Null)
		CreateMenu "Quick Help",MENUQUICKHELP,edit
		CreateMenu "",0,edit
		CreateMenu "Cut",MENUCUT,edit
		CreateMenu "Copy",MENUCOPY,edit
		CreateMenu "Paste",MENUPASTE,edit
		CreateMenu "",0,edit
		CreateMenu "Select All",MENUSELECTALL,edit
		CreateMenu "",0,edit
		CreateMenu "Block Indent",MENUINDENT,edit
		CreateMenu "Block Outdent",MENUOUTDENT,edit
		CreateMenu "",0,edit
		CreateMenu "Find",MENUFIND,edit
		CreateMenu "Find Next",MENUFINDNEXT,edit
		CreateMenu "Replace",MENUREPLACE,edit
		CreateMenu "Goto Line",MENUGOTO,edit
		Return edit
	End Function
	
	Method MakePathTemp()
' prepends "." to file name with code borrowed from SaveAs		
		Local file$=ExtractDir(path)+"/."+StripDir(path)
		SaveSource(file$)
'		Refresh
		GetNode().Refresh
'		setdirty False
		host.SetTitle path
	End Method
	
	Function Create:TOpenCode(path$,host:TCodePlay)
		Local	code:TOpenCode
		Local	stream:TStream
		Local	isnew
		If path
			If FileType(path)<>FILETYPE_FILE
				Return Null
			EndIf
			stream=ReadFile(path)
			If Not stream
'				Notify "Open could not read from "+path		
				Return Null
			EndIf
			CloseFile stream
		Else
			TEMPCOUNT:+1
'			path=host.bmxpath+"/tmp/untitled"+TEMPCOUNT+".bmx"
'			path=host.monkpath+"/tmp/untitled"+TEMPCOUNT+".monkey"
			path=RequestFile("Create New File","",True,"untitled"+TEMPCOUNT+".monkey")
			isnew=True
		EndIf
		code=New TOpenCode
		code.host=host
		code.active=True
		code.path=host.FullPath(path)
		code.editmenu=CreateEditMenu()
		codeplay.addpanel(code)
		
		Local margin=12	
?win32
		margin=0
?		
		code.textarea=CreateTextArea(margin,0,ClientWidth(code.panel)-margin,ClientHeight(code.panel),code.panel,0)
		
'		code.textarea=CreateTextArea(0,0,ClientWidth(code.panel),ClientHeight(code.panel),code.panel,0)
		SetGadgetFilter code.textarea,code.FilterKey,code
		SetTextAreaText code.textarea,"~n"
		SetGadgetLayout code.textarea,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED

		If ExtractExt(path).toLower()="bmx" code.isbmx=True
		If ExtractExt(path).toLower()="c" code.isc=True
		If ExtractExt(path).toLower()="cpp" code.iscpp=True
		If ExtractExt(path).toLower()="cxx" code.iscpp=True
		If ExtractExt(path).toLower()="html" code.ishtml=True
		If ExtractExt(path).toLower()="htm" code.ishtml=True
		If ExtractExt(path).toLower()="monkey" code.ismonkey=True

		code.Refresh()
		
		If isnew
			code.SaveSource path
			code.filesrc="~n"
			ActivateGadget code.textarea
		Else
			host.UpdateProgress "Reading Stream"
			code.ReadSource(path)
		EndIf
		
				
		code.UpdateCode False
		code.filesrc=TextAreaText(code.textarea)
		Return code
	End Function

End Type

Type TRect
	Field		x,y,w,h

	Method Set(xpos,ypos,width,height)
		x=xpos;y=ypos;w=width;h=height
	End Method
	
	Method ToString$()
		Return ""+x+","+y+","+w+","+h
	End Method

	Method FromString(s$)
		Local	p,q,r
		p=s.Find(",")+1;If Not p Return
		q=s.Find(",",p)+1;If Not q Return
		r=s.Find(",",q)+1;If Not r Return
		x=Int(s[..p-1])
		y=Int(s[p..q-1])
		w=Int(s[q..r-1])
		h=Int(s[r..])
	End Method
	
	Method IsOutside(tx,ty,tw,th)
		If x+w<=tx Or y+h<=ty Return True
		If x>=tx+tw Or y>=ty+th Return True	
	End Method

End Type

Type THistoryNode Extends TNode
	Field owner:THistoryPlugin
	Field path$
	Field archive$

	Method Invoke(command,argument:Object=Null)
		Select command
			Case TOOLACTIVATE
				codeplay.OpenSource archive
		End Select
	End Method

	Method SetDetails(o:THistoryPlugin,n$,p$,a$)
		owner=o
		SetName n
		path=p
		archive=a
		SetAction(owner,TOOLACTIVATE,Self)
	End Method
End Type

Type THistoryPlugin Extends TTool

	Field	historycommand
	Field	historyroot:TNode
	Field	versions:TMap
	Field	locations:TMap

	Function FindValue( list:TList,value:Object )
		Local index
		For Local value2:Object=EachIn list
			If value.Compare( value2 )=0 Return index
			index:+1
		Next			
		Return -1
	End Function

	Method Archive(path$,Text$)
		Local dest$,version$,location$,hpath$
		
		hpath=HistoryPath()
		If hpath="" Return
		
		version=String(versions.ValueForKey(path))
		version=String(1+Int(version))
		versions.Insert path,version
		
		dest=StripAll(path)
		
		Local paths:TList
		paths=TList(locations.ValueForKey(dest))
		If Not paths
			paths=New TList
			locations.Insert dest,paths
		EndIf
		
		Local index=FindValue(paths,path)+1
		If index=0
			paths.AddLast path
			index=paths.Count()
		EndIf	
		location=String(index)
			
		dest=StripAll(path)
		dest:+"_"+location
		dest:+"_"+version
		dest:+"."+ExtractExt(path)		

		dest$=hpath+"/"+dest
		SaveText Text,dest

'		DebugLog "history:path="+path+"~ntext="+text
		
		Local n:THistoryNode
		Local o:THistoryNode
		Local filename$

		filename=StripDir(path)

		n=THistoryNode(historyroot.FindNode(filename))
		
		If Not n n=New THistoryNode
		n.setdetails(Self,filename,"",path$)
		
		o=New THistoryNode
		o.setdetails(Self,filename+"("+version+")",path,dest$)
		n.AddFirst o
	
		historyroot.AddFirst n
		historyroot.Refresh
		
		WriteHistory
	End Method

	Method ReadHistory()
		Local path$,vers$
		Local dest$,destlist:TList,d$
		Local node:THistoryNode
		Local nodee:THistoryNode
		Local n$,p$,a$,hpath$
		
		hpath=HistoryPath()
		
		If Not hpath Return
		Local f:TStream=ReadFile(hpath+"/history.txt")
		If f 
			While Not Eof(f)
				Local l$=ReadLine(f)
				Select l
					Case "version"
						path$=ReadLine(f)
						vers$=ReadLine(f)
						ReadLine f
						versions.Insert path,vers
					Case "location"					
						dest$=ReadLine(f)
						destlist=New TList
						While True
							d$=ReadLine(f)
							If Not d$ Exit
							destlist.AddLast d
						Wend
					Case "history"
						n$=ReadLine(f)
						p$=ReadLine(f)
						a$=ReadLine(f)
						node=New THistoryNode
						node.setdetails Self,n,p,a
						historyroot.Append node
						While True
							n$=ReadLine(f)
							If Not n Exit
							p$=ReadLine(f)
							a$=ReadLine(f)
							nodee=New THistoryNode
							nodee.setdetails Self,n,p,a
							node.Append nodee
						Wend				
				End Select
			Wend
			CloseStream f
		EndIf
	End Method
	
	Method WriteHistory()
		Local hpath$
		hpath=HistoryPath()
		If Not hpath Return
		Local f:TStream=WriteFile(hpath+"/history.txt")
		If f 
'versions		
			Local path$
			For path=EachIn versions.keys()
				WriteLine f,"version"
				WriteLine f,path
				WriteLine f,String(versions.ValueForKey(path))
				WriteLine f,""
			Next
'locations
			Local dest$,loc$
			Local paths:TList
			For dest$=EachIn locations.keys()
				WriteLine f,"location"
				WriteLine f,dest
				paths=TList(locations.ValueForKey(dest))
				For loc=EachIn paths
					WriteLine f,loc
				Next
				WriteLine f,""
			Next
'historyroot			
			Local nodee:THistoryNode			
			Local node:THistoryNode			
			For node=EachIn historyroot.kids
				WriteLine f,"history"
				WriteLine f,node.name
				WriteLine f,node.path
				WriteLine f,node.archive
				For nodee=EachIn node.kids
					WriteLine f,nodee.name
					WriteLine f,nodee.path
					WriteLine f,nodee.archive
				Next			
				WriteLine f,""
			Next
			CloseStream f
		EndIf
	End Method

	Method Invoke(command,argument:Object=Null)	
		Select command
'			Case "RESET"	'new for 9.06
			Case TOOLARCHIVE
				Local pathdata:Object[]=Object[](argument)
				If Not pathdata Or pathdata.length<>2 Return
				Local path$=String(pathdata[0])
				Local Text$=String(pathdata[1])
				Archive path,Text
			Case TOOLHISTORY
				' do history requester
				Notify "History Requester coming soon..."		
			Default
				Notify "history invoke with unknown command "+command
		End Select
	End Method
		
	Method Open:Object(path$)
	End Method

'Historyrequester.Show

	Method HistoryPath$()
		Local h$
		h=""
		If codeplay.options.archivecode
			h=codeplay.monkpath+"/history"
			If FileType(h)=0 
				If Not CreateDir(h) 
					Notify "Unable to create history directory "+h
					h=""
				EndIf
			EndIf
		EndIf
		Return h
	End Method
	
	Method EnableHistory(host:TCodePlay)
		If historyroot Return
		historyroot=host.root.AddNode("History")
		versions=New TMap
		locations=New TMap
		ReadHistory
		historyroot.Refresh		
		host.root.Refresh
	End Method
	
	Method DisableHistory()
		If historyroot 
			historyroot.free
			historyroot=Null
		EndIf
	End Method

End Type


Type TCodePlay

	Const EDITMODE=1
	Const DEBUGMODE=2
	
	Field bmxpath$
	Field bmkpath$
	Field monkeypath$
	Field transpath$
	Field monkpath$
	Field inipath$
	
	Field panels:TToolPanel[]
	Field helppanel:THelpPanel
	Field currentpanel:TToolPanel

	Field output:TOutputPanel
	Field serverpanel:TServerPanel

	Field lockedpanel:TToolPanel
	Field activepanel:TToolPanel
	
	Field cmdlinereq:TCmdLineRequester
	Field cmdline$
'	Field syncmodsreq:TSyncModsRequester
	Field gotoreq:TGotoRequester
	Field monkeyreq:TMonkeyRequester
	Field findreq:TFindRequester
	Field replacereq:TReplaceRequester
	Field options:TOptionsRequester
'	Field progress:TProgressRequester
	Field activerequesters:TList = New TList
	Field projectreq:TProjectRequester
	Field projectprops:TProjectProperties
	Field searchreq:TSearchRequester	
	
	Field eventhandlers:TList=New TList
	Field window:TGadget,menubar:TGadget,toolbar:TGadget,client:TGadget,tabbar:TGadget
	Field split:TSplitter
	Field debugtree:TDebugTree
	
	Field root:TNode
	Field helproot:TNode
	Field bmxhelproot:TNode
	Field monkeyhelproot:TNode
	Field wiki:TWiki
	Field projects:TProjects
	Field coderoot:TNode
	Field navbar:TNavBar	

	Field mode
	Field debugcode:TOpenCode

	Field quickenable:TGadget,quickenabled	'menu,state
	Field debugenable:TGadget,debugenabled	'menu,state
	Field threadedenable:TGadget,threadedenabled
	Field guienable:TGadget,guienabled		'menu,state
	Field quickhelp:TQuickHelp
	Field monkeyhelp:TQuickHelp
	Field running
	Field recentmenu:TGadget
	Field recentfiles:TList=New TList
	Field recentmenus:TGadget[]
	Field openlist:TList=New TList
	Field openlock$
	Field projlist:TList=New TList
	Field winsize:TRect=New TRect
	Field winmax,tooly,splitpos,debugview,navtab
	Field progress,splitorientation

	Field history:THistoryPlugin

?MacOS	
	Method RanlibMods()
		Local cmd$=Quote( bmxpath+"/bin/bmk" )+" ranlibdir "+Quote( bmxpath+"/mod" )
		system_ cmd
	End Method
?

	Method CheckBMXVersion$()
		Local	process:TProcess
		Local	bytes:Byte[]
		Local	cmd$,version$

		BCC_VERSION=""
		cmd$=bmxpath+"/bin/bcc"
		
?win32
		cmd:+".exe"
?
		
		cmd=Quote(cmd)
		process=CreateProcess(cmd$,HIDECONSOLE)
		If process
			Repeat
				Delay 10
				bytes=process.pipe.ReadPipe()
				If bytes
					version:+String.FromBytes(bytes,bytes.length)
				EndIf
			Until Not process.Status()
		EndIf

		BCC_VERSION=version.Trim()
		
	End Method
	
	Method OpenProgress(message$)
'		progress.Open message
		DisableGadget window
		SetStatus message
		progress=-1
	End Method

	Method CloseProgress()
'		progress.Hide
		SetStatus ""
		EnableGadget window
		progress=0
	End Method
	
	Method UpdateProgress(message$,value=0)		'returns false if cancelled
'		Return progress.Update(message,value)
		If progress
			If progress/5<>value/5
				SetStatus message+" "+value+"%"
				progress=value
'				Pollsystem
			EndIf
		EndIf
	End Method

	Method FullPath$(path$)
		If path[..8]="$BMXPATH" path=bmxpath+path[8..]
		If Not path.Contains("::") Then path = RealPath(path)
?win32
		path=path.Replace("\","/")
?
		Return path
	End Method

	Method IsTempPath(path$)
		If path[..bmxpath.length+5]=monkpath+"/tmp/" Return True
	End Method
	
	Method AddDefaultProj(p$)
		Local projdata:TList = New TList
		projdata.AddLast p
		projlist.AddLast projdata
	End Method

	Method ReadConfig()
		Local	stream:TStream
		Local	f$,p,a$,b$
' defaults		
		Local wh=GadgetHeight(Desktop())-80'32
		Local ww=wh
		Local wx=(GadgetWidth(Desktop())-ww)/2
		Local wy=(GadgetHeight(Desktop())-wh)/2
		winsize.set( wx,wy,ww,wh )
		quickenabled=False
		debugenabled=True
		threadedenabled=False
		guienabled=True	
		splitpos=200;splitorientation = SPLIT_VERTICAL
' read ini
		stream=ReadFile(inipath)
		If Not stream
			AddDefaultProj "monkey|."
			Return
		EndIf
		
		options.read(stream)		
		options.Snapshot

		Local projdata:TList
		
		While Not stream.Eof()
			f$=stream.ReadLine()
			p=f.find("=")
			If p=-1 Continue
			a$=f[..p]
			b$=f[p+1..]
			Select a$
				Case "ide_version"
					' bump upgrade tricks				
				Case "monkey_path"
					monkeypath=b$
				Case "blitzmax_path"
					bmxpath=b$
				Case "file_recent"
					recentfiles.addlast b$
				Case "file_open"
					openlist.addlast b$
				Case "prg_quick"
					quickenabled=Int(b$)
				Case "prg_debug"
					debugenabled=Int(b$)
				Case "prg_threaded"
					threadedenabled=Int(b$)
				Case "prg_gui"
					guienabled=Int(b$)
				Case "cmd_line"
					cmdline=b$
				Case "prg_locked"
					openlock=b$
				Case "win_size"
					winsize.FromString(b$)
				Case "win_max"
					winmax=Int(b$)
				Case "split_position"
					splitpos=Int(b$)
				Case "split_orientation"
					splitorientation=Int(b$)
				Case "proj_node"
					projdata=New TList
					projdata.AddLast b
					projlist.AddLast projdata
				Case "proj_data"
					If projdata projdata.AddLast b
				'Case "sync_state"
					'syncmodsreq.FromString b$
			End Select
		Wend
		stream.close()		
	End Method
	
	Method WriteConfig()
		Local	panel:TToolPanel
		Local	node:TNode
		Local	f$
		
		Local	stream:TStream = WriteFile(inipath)
		If Not stream Return
' options
		options.Write(stream)
' defaults		
		stream.WriteLine "[Defaults]"
		stream.WriteLine "ide_version="+VERSION
		stream.WriteLine "monkey_path="+monkeypath
		stream.WriteLine "blitzmax_path="+bmxpath
		stream.WriteLine "prg_quick="+quickenabled
		stream.WriteLine "prg_debug="+debugenabled
		stream.WriteLine "prg_threaded="+threadedenabled
		stream.WriteLine "prg_gui="+guienabled
		stream.WriteLine "win_size="+winsize.ToString()
		stream.WriteLine "win_max="+winmax
		stream.WriteLine "split_position="+SplitterPosition(split)
		stream.WriteLine "split_orientation="+SplitterOrientation(split)
		stream.WriteLine "cmd_line="+cmdline
		'stream.WriteLine "sync_state="+syncmodsreq.ToString()
		If lockedpanel stream.WriteLine "prg_locked="+lockedpanel.path
		For f$=EachIn recentfiles
			stream.WriteLine "file_recent="+f$
		Next
		For Local panel:TToolPanel = EachIn panels
			f$=panel.path
			If f$ And Not IsTempPath(f$) stream.WriteLine "file_open="+f$
		Next
		projects.Write(stream)	
		stream.close
	End Method
	
	Method CloseAll(dontask,inccurrent=True)	'returns true if successful
		Local	count, cancel
		For Local panel:TToolPanel = EachIn panels
			If TOpenCode(panel) And (inccurrent Or currentpanel <> panel) count:+1
		Next
		If (Not count) Or dontask Or Confirm("Monk needs to close all documents before continuing.")
			For Local panel:TToolPanel = EachIn panels[..]	'Use a copy of the original array for iterating.
				If (inccurrent Or currentpanel <> panel) And panel.invoke(TOOLCLOSE) Then
					cancel=True
					Exit
				EndIf
			Next
			Return Not cancel
		EndIf
	End Method

	Method Quit()
		WriteConfig()
		If CloseAll(True) 
			serverpanel.Close
			running=False
		EndIf
	End Method

	Method DebugExit()
		If debugcode
			debugtree.cancontinue = False
			debugcode.Edit		'restore cursor etc.	
			debugcode=Null
		EndIf
		SetMode EDITMODE
		RefreshToolbar()
	End Method
		
	Method DebugSource(path$,Line,column)
		Local	code:TOpenCode
		path=FullPath(path)
		code=OpenSource(path)
		If Not code Then
			Notify("Failed to open '"+path+"'.", True)
			Return
		EndIf
		If debugcode And debugcode<>code Then debugcode.Edit()	'restore cursor etc.
		debugcode=code
		debugcode.debug(Line,column)	
		ActivateWindow window
		PollSystem
	End Method
	
	Method SetMode(m)
		If mode=m Return
		ActivateWindow window
		Select m
		Case DEBUGMODE
			navtab=navbar.SelectedView()
			navbar.SelectView debugview
		Case EDITMODE
			navbar.SelectView navtab
		End Select
		mode=m
		RefreshToolbar
	End Method
	
	Method RefreshMenu()
		UpdateWindowMenu window
	EndMethod
	
	Method RefreshToolbar()
		Local	i
' sourceedit buttons
		If THelpPanel(CurrentPanel)
			DisableGadgetItem toolbar,TB_CLOSE
		Else
			EnableGadgetItem toolbar,TB_CLOSE
		EndIf
		If TOpenCode(CurrentPanel)
			EnableGadgetItem toolbar,TB_SAVE
			For i=TB_CUT To TB_FIND
				EnableGadgetItem toolbar,i
			Next
		Else
			DisableGadgetItem toolbar,TB_SAVE
			For i=TB_CUT To TB_FIND
				DisableGadgetItem toolbar,i
			Next			
		EndIf
' debug buttons
		If mode = DEBUGMODE And debugtree.cancontinue Then
			If GadgetItemIcon( toolbar, TB_BUILDRUN ) = TB_BUILDRUN Then
				ModifyGadgetItem( toolbar, TB_BUILDRUN, "", 0, TB_CONTINUE, "Continue" )
			EndIf
		Else
			If GadgetItemIcon( toolbar, TB_BUILDRUN ) <> TB_BUILDRUN Then
				ModifyGadgetItem( toolbar, TB_BUILDRUN, "", 0, TB_BUILDRUN, "Build and Run" )
			EndIf
		EndIf
		For i=TB_STEP To TB_STEPOUT
			If mode=DEBUGMODE And debugtree.cancontinue Then
				EnableGadgetItem toolbar,i
			Else
				DisableGadgetItem toolbar,i
			EndIf
		Next
' stop button		
		If output And output.process
			EnableGadgetItem toolbar,TB_STOP
		Else
			DisableGadgetItem toolbar,TB_STOP
		EndIf		
	End Method
	
	Method IsSourceOpen(path$)
		Local	p$ = FullPath(path)
		For Local panel:TToolPanel = EachIn panels
			If panel.path=p Return True
		Next
	End Method
	
	Method OpenSource:TOpenCode(path$)
		Local	code:TOpenCode
		Local	ext$,p$
		If path$="."
			path$=RequestFile("Open File",FileTypeFilters )
			If path$="" Return
		EndIf
' check if already open
		p$=FullPath(path).ToLower()
		For Local panel:TToolPanel = EachIn panels
			If panel.path.ToLower()=p
				SelectPanel panel
				Return TOpenCode(panel)
			EndIf
		Next
' open based on extension		
'		Select ExtractExt(Upper(path$))
'		Case "BMX","TXT","BB","CPP","C","S","I","H","HTML","CSS","BAT","FS","VS","README",""
			OpenProgress "Loading "+StripDir(path)
			code=TOpenCode.Create(path,Self)
			If code
				AddRecent code.path
			EndIf
			CloseProgress
			If code
				ActivateGadget code.textarea
				code.GetNode().Refresh
			EndIf
			Return code
'		end select
	End Method
	
	Method AddRecent(path$)
		For Local f$ = EachIn recentfiles
			If f$=path$ recentfiles.Remove(f$);Exit
		Next
		recentfiles.AddFirst(path$)
		RefreshRecentFiles
		UpdateWindowMenu window
	End Method
	
	Method RefreshRecentFiles()
		Local	n
		For Local m:TGadget = EachIn recentmenus
			FreeMenu m
		Next
		n=Min(recentfiles.count(),16)
		recentmenus=New TGadget[n]
		n=0
		For Local f$ = EachIn recentfiles
			recentmenus[n]=CreateMenu(f$,MENURECENT+n,recentmenu)
			n:+1
			If n=16 Exit
		Next
	End Method
	
	Method BuildModules(buildall)
		Local cmd$,out$,exe$
		output.Stop
		SaveAll
		cmd$=quote(bmkpath)
		cmd$:+" makemods "
		
		If buildall cmd$:+"-a "
		If threadedenabled cmd:+"-h "
		
		Execute cmd,"Building Modules"
	End Method

	Method ImportBB()
		Local f$ = RequestFile("Import .bb file","bb" )
		If Not f$ Return
		Local cmd$ = Quote(bmkpath$)
		cmd$:+" convertbb "
		cmd$:+quote(FullPath(f$))
		Execute cmd,"Converting "+StripExt(StripDir(f$))
		output.wait
		OpenSource(StripExt(f$)+".bmx")
	End Method

	Method GetCommandLine$()
		Return cmdline
	End Method

	Method SetCommandLine(Text$)
		cmdline=Text
	End Method
	
	Method SetStatus(Text$)
		SetStatusText window,Text
	End Method

	Method Execute(cmd$,mess$="",post$="",home=True,tool:TTool=Null)
		If Not output output=TOutputPanel.Create(Self)
		output.execute cmd$,mess$,post$,home,tool
	End Method

	Method SelectError(path$,column,Line)
		Local	panel:TOpenCode,found
		For panel=EachIn panels
			If panel.path=path found=True;Exit
		Next
		If Not found panel=OpenSource(path)
		If panel
			SelectPanel panel
			panel.Debug Line,column
		EndIf
	End Method
	
	Method ParseError(err$)
		Local		mess$,file$,p,q
		Local		Line,column
		
' bcc error
		If err$[..13]="Compile Error"
			err=err[14..]
			p=err.find(EOL$)
			If p=-1 p=err.length
			mess=err[..p]
			err=err[p+1..]
			If err[..1]="["
				p=err.find("]")
				If p=-1 p=err.length
				file$=err[1..p]
				p=file.find(";")+1
				If p=0 p=err.length
				q=file.find(";",p)+1
				If q=0 q=err.length
				Line=Int(file[p..q-1])
				column=Int(file[q..])
				file=FullPath(file[..p-1])				
				SelectError file,column,Line
			EndIf
			Notify "Compile Error~n~n"+mess
			SetStatus mess
			Return
		EndIf
		
		Return

' gcc error
		err=err.Replace(EOL+"   "," ")
		While err
			p=err.find(EOL)
			If p=-1 p:+err.length	'equiv. to p=err.length-1 ;-)
			mess=err[..p]
			err=err[p+1..]
			p=0
			Repeat
				p=mess.Find(":",p)+1
				If p=0 Exit
				q=mess.Find(":",p)
				If q<>-1
					file=mess[..p-1]
					Line=Int(mess[p..q])
					If Line
						mess=mess[q+1..]
						SelectError file,column,Line
						Notify "Compile Error~n~n"+mess
						Return
					EndIf
					p=q+1
				EndIf
			Forever
		Wend
	End Method
		
	Method AddPanel(tabpanel:TToolPanel)
		Local panel:TGadget,index
		
		index=CountGadgetItems(tabbar)
		If panels.length<=index panels=panels[..index+1]
		AddGadgetItem(tabbar,tabpanel.name$,GADGETITEM_DEFAULT)
		
		Local margin=0
		Local style=0'PANEL_GROUP
		
		panel=CreatePanel(margin,0,ClientWidth(tabbar)-margin,ClientHeight(tabbar),tabbar,style)
		SetGadgetLayout panel,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED

		tabpanel.panel=panel
		
		tabpanel.index=index
		panels[index]=tabpanel
		SelectPanel tabpanel

		AddHandler tabpanel
	End Method

	Method InsertPanel(tabpanel:TToolPanel,index)
		Local panel:TGadget,count,n,i

		count=CountGadgetItems(tabbar)
		If index>count index=count
		
		n=panels.length
		panels=panels[..n+1]
		For i=n Until index Step -1		
			panels[i]=panels[i-1]
			panels[i].index=i
		Next
		
		InsertGadgetItem tabbar,index,tabpanel.name$,GADGETITEM_DEFAULT 
		
		Local margin=0
		Local style=0'PANEL_GROUP
		
		panel=CreatePanel(margin,0,ClientWidth(tabbar)-margin,ClientHeight(tabbar),tabbar,style)
		SetGadgetLayout panel,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED

		tabpanel.panel=panel
		
		tabpanel.index=index
		panels[index]=tabpanel
		SelectPanel tabpanel

		AddHandler tabpanel
	End Method

	Method AddHandler(handler:TEventHandler)
		eventhandlers.addlast handler
	End Method

	Method RemovePanel(tabpanel:TToolPanel)
		Local p:TToolPanel[]
		Local index

		eventhandlers.remove tabpanel
' unset debugcode
		If debugcode=tabpanel debugcode=Null
' activate next panel
		If tabpanel=activepanel activepanel=helppanel
		If tabpanel=lockedpanel lockedpanel=Null
		If tabpanel=currentpanel
			index=tabpanel.index+1
			If index>=panels.length index=panels.length-2
			SelectPanel panels[index]
		EndIf
' remove from array
		p=panels
		panels=panels[..panels.length-1]
		For index=tabpanel.index To panels.length-1
			panels[index]=p[index+1]
			panels[index].index=index
		Next
' remove gadget	- simon come here,  placing before remove needs fix in fltk
		FreeGadget tabpanel.panel
		RemoveGadgetItem tabbar,tabpanel.index
		tabpanel.panel=Null
		RefreshBuildOptions		
	End Method
		
	Method HookRequester(req:TRequester)
		If Not activerequesters.Contains(req) Then
			If req.IsModal() Then
				For Local tmpRequester:TRequester = EachIn activerequesters
					DisableGadget tmpRequester.window
				Next
				DisableGadget window
			EndIf
			activerequesters.AddFirst(req)
		EndIf
	End Method
	
	Method UnhookRequester(req:TRequester)
		If activerequesters.Contains(req) Then
			activerequesters.Remove(req)
			If req.IsModal() Then
				For Local tmpRequester:TRequester = EachIn activerequesters
					EnableGadget tmpRequester.window
				Next
				EnableGadget window
			EndIf
		EndIf
	EndMethod
	
	Method SetTitle(title$="")
		If title title=" - "+title
		SetGadgetText window,"Monk"+title
	End Method
	
	Method SelectPanel(panel:TToolPanel)	
		Local	curr:TToolPanel = currentpanel
		currentpanel=panel
		If curr And curr<>currentpanel
			SelectGadgetItem tabbar,panel.index
			ShowGadget panel.panel
			If panel.active activepanel=panel
			HideGadget curr.panel
			RefreshToolbar
		EndIf
		currentpanel.Invoke TOOLSHOW
		RefreshBuildOptions
	End Method
		
	Method RefreshPanel(panel:TToolPanel)	'call after a name change
		ModifyGadgetItem( tabbar,panel.index,panel.name )	
		RefreshBuildOptions		
	End Method

	Function OutsideDesktop(winrect:TRect)
		Local x,y,w,h
		Local desk:TGadget = Desktop()
		x=GadgetX(desk)
		y=GadgetY(desk)
		w=GadgetWidth(desk)
		h=GadgetHeight(desk)
		Return winrect.IsOutside(x,y,w,h)
	End Function

	Method SetCodeNode(code:TNode)
		Local node:TNode
		If coderoot.kids.count() node=TNode(coderoot.kids.First())
		If node=code Return
		If node node.Detach
		If code
			coderoot.Append code
			coderoot.Refresh
			coderoot.Open
			code.Open
		EndIf
	End Method
	
	Method MakeDocs()	
		Local mkdocs
		If FileType( bmxpath+"/docs/html/User Guide/index.html" )<>FILETYPE_FILE
			CreateDir bmxpath+"/docs/html"
			CreateFile bmxpath+"/docs/html/index.html"
			mkdocs=True
		EndIf
'build docs if not there		
' simon was here: no docmods
'		If mkdocs
'			If Confirm( "Documentation not found.~n~nWould you like to rebuild documentation now?") ) And CloseAll( False ) DocMods
'		EndIf
	End Method
	
	Method InitMonkeyPaths()
		If Not monkeypath Return		
?win32
		transpath=monkeypath+"/bin/transcc_winnt"
?macos
		transpath=monkeypath+"/bin/transcc_macos"		
'A bit rude! This turns off the 'app was downloaded from the internet' warning
'that prevents MServer from running cleanly.
'
'		system_ "xattr -d com.apple.quarantine ~q"+monkeypath+"/bin/mserver_macos.app~q"
?
	End Method
	
	Method InitBMXPaths()	
		If Not bmxpath Return
		bmkpath=bmxpath+"/bin/bmk"	
'		TestBCC()
		CheckBMXVersion()
	End Method

	Method Initialize()		
		Local	open:TOpenCode
		Local	dir$,nomods,pname$,p
		Local	stream:TStream

		monkpath=AppDir
		CreateDir monkpath+"/tmp"
		If FileType( monkpath+"/tmp" )<>FILETYPE_DIR
			Notify "Unable to create Monk 'tmp' directory."
			End
		EndIf
				
		inipath=monkpath+"/monk."+ComputerName$()+".ini"
				
		window=CreateWindow("Monk",20,20,760,540,Null,WINDOW_TITLEBAR|WINDOW_RESIZABLE|WINDOW_STATUS|WINDOW_HIDDEN|WINDOW_ACCEPTFILES|WINDOW_MENU)
		
		?Linux
		SetGadgetPixmap(window, LoadPixmapPNG("incbin::window_icon.png"), GADGETPIXMAP_ICON )
		?
		
		options=TOptionsRequester.Create(Self)
		ReadConfig()		
		InitMonkeyPaths
		InitBMXPaths
			
		cmdlinereq=TCmdLineRequester.Create(Self)
		'syncmodsreq=TSyncModsRequester.Create(Self)
		gotoreq=TGotoRequester.Create(Self)
		findreq=TFindRequester.Create(Self)
		replacereq=TReplaceRequester.Create(Self)
		projectreq=TProjectRequester.Create(Self)
		projectprops=TProjectProperties.Create(Self)
		searchreq=TSearchRequester.Create(Self)
		monkeyreq=TMonkeyRequester.Create(Self)
	

		toolbar=CreateToolbar("incbin::monktoolbar.png",0,0,0,0,window )
		RemoveGadgetItem toolbar, TB_CONTINUE
		
		SetToolbarTips toolbar, ["New","Open","Close","Save","","Cut","Copy","Paste","Find","",..
		                         "Build","Build and Run","Step","Step In","Step Out","Stop","","Home","Back","Forward"]

		If Not options.showtoolbar Then HideGadget toolbar
		
		If OutsideDesktop(winsize)
			winsize.set(20,20,760,540)		
		EndIf
				
		SetGadgetShape(window, winsize.x, winsize.y, winsize.w, winsize.h)

		client=window
		
		split=CreateSplitter(0,0,ClientWidth(client),ClientHeight(client),client,SPLIT_VERTICAL)
		SetGadgetLayout(split,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED)
		
		tabbar=CreateTabber(0,0,ClientWidth(SplitterPanel(split,SPLITPANEL_MAIN)),ClientHeight(SplitterPanel(split,SPLITPANEL_MAIN)),SplitterPanel(split,SPLITPANEL_MAIN))
		SetGadgetLayout(tabbar,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED)

		InitMenu
		InitHotkeys
		
		debugtree=TDebugTree.CreateDebugTree(Self)

		root=TNode.CreateNode("Project")
										
		projects=TProjects.CreateProjects(Self)		
		root.Append projects

'		wikiroot=root.AddNode("Wiki")
	
'		opencoderoot=root.AddNode("Open")
		coderoot=TNode.CreateNode("Code")
		coderoot.Open()

		helproot=root.AddNode("Docs")

		If monkeypath
			monkeyhelproot=helproot.AddNode("Monkey")
		EndIf

		If bmxpath
			bmxhelproot=helproot.AddNode("BlitzMax")
		EndIf

		history=New THistoryPlugin
		navbar=TNavBar.Create(Self,SplitterPanel(split,SPLITPANEL_SIDEPANE))

		navbar.AddView root
		navbar.AddView coderoot
		debugview=navbar.AddView(debugtree)
		navbar.SelectView 0

		If helproot helproot.Open
		projects.Open

		AddHandler navbar
	
		SetMode EDITMODE
					
		If bmxpath quickhelp=TQuickHelp.LoadCommandsTxt(bmxpath)

		monkeyhelp=TQuickHelp.LoadMonkeyCommands(monkeypath,Self)

		helppanel=THelpPanel.Create(Self)
		output=TOutputPanel.Create(Self)
		serverpanel=TServerPanel.Create(Self)
				
		activepanel=helppanel

'		wiki=TWiki.CreateWiki(Self)
'		root.Append wiki

		Rethink
		RefreshAll
		
		If bmxpath MakeDocs
						
		helppanel.Home()
				
' scan projects in projlist
		For Local pdata:TList = EachIn projlist
			projects.AddProject pdata
		Next
		
'open files from .ini restorelist		
		If options.restoreopenfiles
			For Local f$=EachIn openlist
				open=OpenSource(f$)
				If open And f$=openlock open.SetLocked(True)
			Next
		EndIf
				
' open files specified in command line		
		For Local i:Int = 1 Until AppArgs.length
			open=OpenSource(AppArgs[i])
		Next
		
		PollSystem
		
		SetSplitterPosition(split,splitpos);SetSplitterOrientation(split,splitorientation)
		
		If winmax MaximizeWindow(window)
		ShowGadget window	
		
		PollSystem
		running=True
		
		CreateTimer(TIMER_FREQUENCY)
		
		'If nomods syncmodsreq.Show		
	End Method
Rem	
	Method TestBCC()
		Local dir$
?Win32
		CreateFile bmxpath+"/tmp/t.exe"
		If FileType( bmxpath+"/tmp/t.exe" ) <> FILETYPE_FILE
			Notify "Unable to write Monk files in current directory.~n"+..
			"Please run Monk as administrator or vacate to more permissable environment."
			End
		DeleteFile bmxpath+"/tmp/t.exe"
?


		bmkpath=bmxpath+"/bin/bmk"

?Win32
		bmkpath:+".exe"
?
		dir$=bmxpath+"/mod"
		If FileType(dir)=FILETYPE_NONE
			If Not CreateDir(dir)
				Notify "Failed to create %1 directory:~n%2".Replace("%1","Module").Replace("%2",dir)
				End
			EndIf
			nomods=True
		EndIf
		dir$=bmxpath+"/tmp"
		If FileType(dir)=FILETYPE_NONE
			If Not CreateDir(dir)
				Notify "Failed to create %1 directory:~n%2".Replace("%1","Temp").Replace("%2",dir)
				End
			EndIf
		EndIf
		dir$=bmxpath+"/cfg"
		If FileType(dir)=FILETYPE_NONE
			If Not CreateDir(dir)
				Notify "Failed to create %1 directory:~n%2".Replace("%1","Config").Replace("%2",dir)
				End
			EndIf
		EndIf
	End Method
EndRem
	
	Method DocMods()
		Local cmd$=quote(bmxpath+"/bin/makedocs")
		execute cmd,"Rebuilding documentation...",MENUTRIGGERSYNCDOCS
	?MacOS
		RanLibMods()
	?
	End Method
		
	Method SyncDocs()
		helppanel.SyncDocs()
		quickhelp=TQuickHelp.LoadCommandsTxt(bmxpath)
		helppanel.Home
	End Method

	Method InitMenu()
		Local menu:TGadget
		Local file:TGadget
		Local edit:TGadget
		Local program:TGadget
		Local tools:TGadget
		Local help:TGadget
		Local buildoptions:TGadget
		Local buildmods:TGadget
		Local buildallmods:TGadget
		Local syncmods:TGadget
		Local docmods:TGadget
		Local importbb:TGadget

		Local MENUMOD=MODIFIER_COMMAND

		If options.systemkeys
			MENUMOD=MODIFIER_CONTROL
		EndIf

		menu=WindowMenu(window)

		file=CreateMenu("&File",0,menu)
		CreateMenu "&New",MENUNEW,file,KEY_N,MENUMOD
		CreateMenu "&Open...",MENUOPEN,file,KEY_O,MENUMOD
		recentmenu=CreateMenu("Open &Recent",0,file)
		CreateMenu "",0,file
		CreateMenu "&Close Tab",MENUCLOSE,file,KEY_W,MENUMOD
		CreateMenu "Close All Tabs",MENUCLOSEALL,file,KEY_W,MENUMOD|MODIFIER_SHIFT
		CreateMenu "Close Other Tabs",MENUCLOSEOTHERS,file,KEY_W,MENUMOD|MODIFIER_ALT
		CreateMenu "",0,file
		CreateMenu "&Save",MENUSAVE,file,KEY_S,MENUMOD
		CreateMenu "Save &As",MENUSAVEAS,file,KEY_S,MENUMOD|MODIFIER_SHIFT
		CreateMenu "Save A&ll",MENUSAVEALL,file
		CreateMenu "",0,file

		If options.systemkeys
?MacOS
			CreateMenu "&Next Tab",MENUNEXT,file,KEY_RIGHT,MENUMOD
			CreateMenu "&Previous Tab",MENUPREV,file,KEY_LEFT,MENUMOD
?Not MacOS
			CreateMenu "&Next Tab",MENUNEXT,file,KEY_RIGHT,MODIFIER_ALT
			CreateMenu "&Previous Tab",MENUPREV,file,KEY_LEFT,MODIFIER_ALT
?
		Else
			CreateMenu "&Next Tab",MENUNEXT,file,KEY_RIGHT,MENUMOD
			CreateMenu "&Previous Tab",MENUPREV,file,KEY_LEFT,MENUMOD		
		EndIf
		CreateMenu "",0,file
		importbb=CreateMenu("Import BB Project...",MENUIMPORTBB,file)
		CreateMenu "",0,file
		CreateMenu "IDE Options",MENUOPTIONS,file
		CreateMenu "&Project Manager",MENUPROJECTMANAGER,file	
		CreateMenu "",0,file
		CreateMenu "Print",MENUPRINT,file,KEY_P,MENUMOD
?Not MacOS
		CreateMenu "",0,file
		CreateMenu "Exit",MENUQUIT,file
?
		edit=CreateMenu("&Edit",0,menu)
		CreateMenu "&Undo",MENUUNDO,edit,KEY_Z,MENUMOD
?MacOS
		CreateMenu "&Redo",MENUREDO,edit,KEY_Z,MENUMOD|MODIFIER_SHIFT
?Not MacOS
		CreateMenu "&Redo",MENUREDO,edit,KEY_Y,MENUMOD
?
		CreateMenu "",0,edit
		CreateMenu "Cu&t",MENUCUT,edit,KEY_X,MENUMOD
		CreateMenu "&Copy",MENUCOPY,edit,KEY_C,MENUMOD
		CreateMenu "&Paste",MENUPASTE,edit,KEY_V,MENUMOD
		CreateMenu "",0,edit
		CreateMenu "Select &All",MENUSELECTALL,edit,KEY_A,MENUMOD
		CreateMenu "",0,edit
		CreateMenu "Block Indent",MENUINDENT,edit,KEY_CLOSEBRACKET,MENUMOD
		CreateMenu "Block Outdent",MENUOUTDENT,edit,KEY_OPENBRACKET,MENUMOD
		CreateMenu "",0,edit
		CreateMenu "&Find...",MENUFIND,edit,KEY_F,MENUMOD
?MacOS
		CreateMenu "Find Next",MENUFINDNEXT,edit,KEY_G,MENUMOD
		CreateMenu "&Replace...",MENUREPLACE,edit,KEY_H,MENUMOD
		CreateMenu "&Goto Line...",MENUGOTO,edit,KEY_L,MENUMOD
?Not MacOS
		CreateMenu "Find Next",MENUFINDNEXT,edit,KEY_F3
		CreateMenu "&Replace...",MENUREPLACE,edit,KEY_H,MENUMOD
		CreateMenu "&Goto Line...",MENUGOTO,edit,KEY_G,MENUMOD
?
		CreateMenu "",0,edit
		CreateMenu "Find in F&iles",MENUFINDINFILES,edit,KEY_F,MENUMOD|MODIFIER_SHIFT
		
		program=CreateMenu("&Program",0,menu)
		CreateMenu "&Build",MENUBUILD,program,KEY_B,MENUMOD
		CreateMenu "Build and &Run",MENURUN,program,KEY_R,MENUMOD

		buildoptions=CreateMenu("Build Options",0,program)
		debugenable=CreateMenu("Debug Build",MENUDEBUGENABLED,buildoptions)
		quickenable=CreateMenu("Quick Build",MENUQUICKENABLED,buildoptions)
		threadedenable=CreateMenu("Threaded Build",MENUTHREADEDENABLED,buildoptions)

		CreateMenu "Command &Line",MENUCOMMANDLINE,program
		CreateMenu "",0,program
		CreateMenu "&Step",MENUSTEP,program,KEY_F9
		CreateMenu "Step &In",MENUSTEPIN,program,KEY_F10
		CreateMenu "Step &Out",MENUSTEPOUT,program,KEY_F11
		CreateMenu "&Terminate",MENUSTOP,program

		guienable=CreateMenu("Build GUI App",MENUGUIENABLED,buildoptions)
		CreateMenu "",0,program
		CreateMenu "&Lock Build File",MENULOCKBUILD,program
		CreateMenu "&Unlock Build File",MENUUNLOCKBUILD,program
		CreateMenu "",0,program
		'syncmods=CreateMenu("Synchronize Modules...",MENUSYNCMODS,program)
		'CreateMenu "",0,program
		buildmods=CreateMenu("Build &Modules",MENUBUILDMODULES,program,KEY_D,MENUMOD)
		buildallmods=CreateMenu("Rebuild &All Modules",MENUBUILDALLMODULES,program)
		docmods=CreateMenu("&Rebuild Documentation",MENUDOCMODS,program)
		
		help=CreateMenu("&Help",0,menu)
		CreateMenu "&Home",MENUHOME,help
		CreateMenu "&Back",MENUBACK,help
		CreateMenu "&Forward",MENUFORWARD,help
		CreateMenu "&Quick Help",MENUQUICKHELP,help,KEY_F1
		CreateMenu "About Monk",MENUABOUT,help
		
		If quickenabled CheckMenu quickenable
		If debugenabled CheckMenu debugenable
		If threadedenabled CheckMenu threadedenable
		If guienabled CheckMenu guienable

		If Not bmxpath
			DisableMenu buildmods
			DisableMenu buildallmods
			DisableMenu docmods
			DisableMenu importbb
		EndIf
		
?Win32		
		Local mingw$=getenv_("MINGW")
		If Not mingw
			DisableMenu buildmods
			DisableMenu buildallmods
		EndIf
?		
		If is_demo
			DisableMenu syncmods
		EndIf
		
		RefreshRecentFiles
		UpdateWindowMenu window
	End Method

	Method RunCode()
		If mode=DEBUGMODE And debugtree.cancontinue
			output.Go()
			Return
		EndIf
		output.Stop()
		SaveAll()
		If lockedpanel
			lockedpanel.invoke TOOLRUN
		Else
			activepanel.invoke TOOLRUN
		EndIf
	End Method
	
	Method BuildCode()
		output.Stop()
		SaveAll()
		If lockedpanel
			lockedpanel.invoke TOOLBUILD
		Else
			activepanel.invoke TOOLBUILD
		EndIf
	End Method
		
	Method RefreshBuildOptions()
		Local monkeybuild
		Local codepanel:TOpenCode
				
		If lockedpanel
			codepanel=TOpenCode(lockedpanel)
		Else
			codepanel=TOpenCode(activepanel)
		EndIf
		
		If codepanel And codepanel.ismonkey
			DisableMenu quickenable
			DisableMenu threadedenable
			DisableMenu guienable
		Else
			EnableMenu quickenable
			EnableMenu threadedenable
			EnableMenu guienable
		EndIf

		UpdateWindowMenu window

	End Method
	
	Method ShowAbout()
		Notify (ABOUT.Replace( "{bcc_version}",BCC_VERSION ))
	End Method
		
	Method AddEventHotKey(key,mods,id,data)
		SetHotKeyEvent key,mods,CreateEvent(id,Null,data)
	End Method
		
	Method InitHotkeys()
		AddEventHotKey KEY_F5,MODIFIER_NONE,EVENT_MENUACTION,MENURUN
		AddEventHotKey KEY_F7,MODIFIER_NONE,EVENT_MENUACTION,MENUBUILD
		AddEventHotKey KEY_ESCAPE,MODIFIER_NONE,EVENT_MENUACTION,MENUESCAPE
'		AddEventHotKey KEY_BACKSPACE,MODIFIER_NONE,EVENT_MENUACTION,MENUBACKSPACE
	End Method
		
	Method SaveAll()
		For Local panel:TToolPanel = EachIn panels
			panel.invoke TOOLQUICKSAVE						
		Next
	End Method
	
	Method Rethink()
		If options.archivecode
			history.EnableHistory(Self)
		Else
			history.DisableHistory
		EndIf
		
		If options.runserver 
			serverpanel.Open(8080)
		Else
			serverpanel.Close()
		EndIf
		
	End Method
	
	Method Restart()
		If Confirm("Monk would like to restart.")
			Quit
		EndIf
	End Method
	
	Method RefreshAll()	
' hide/show toolbar
		If options.showtoolbar Then ShowGadget toolbar Else HideGadget toolbar
' refresh panels
		For Local panel:TToolPanel = EachIn panels
			panel.invoke TOOLREFRESH						
		Next
' refresh navbar
		navbar.invoke TOOLREFRESH
	End Method

	Method SnapshotWindow()
		If WindowMaximized(window)
			winmax=True
		Else
			If Not WindowMinimized(window)
				winmax=False
				winsize.x=GadgetX(window)
				winsize.y=GadgetY(window)
				winsize.w=GadgetWidth(window)
				winsize.h=GadgetHeight(window)
			EndIf
		EndIf
		options.showtoolbar = Not GadgetHidden(toolbar)
	End Method
	
	Method OnMenu(menu,extra:Object=Null)
		Local	index
		
		Local	tool:TTool = TTool(extra)
		If tool
			tool.invoke(TOOLMENU,""+menu)
			Return
		EndIf
	
		Select menu
			Case MENUESCAPE
				currentpanel.invoke TOOLESCAPE
'			Case MENUBACKSPACE
'				currentpanel.invoke TOOLBACKSPACE
			Case MENUNEW
				OpenSource ""
			Case MENUOPEN
				OpenSource "."
			Case MENUCLOSE
				currentpanel.invoke TOOLCLOSE
			Case MENUCLOSEALL
				CloseAll True
			Case MENUCLOSEOTHERS
				CloseAll True, False
			Case MENUSAVE
				currentpanel.invoke TOOLSAVE						
			Case MENUSAVEAS			
				currentpanel.invoke TOOLSAVEAS						
			Case MENUSAVEALL
				SaveAll()
			Case MENUPRINT
				currentpanel.invoke TOOLPRINT						
			Case MENUQUIT,MENUESCAPE
				Quit()
			Case MENUGOTO
				gotoreq.Show()
			Case MENUFIND
				currentpanel.invoke TOOLFIND
			Case MENUFINDNEXT
				currentpanel.invoke TOOLFINDNEXT
			Case MENUREPLACE
				replacereq.Show()

			Case MENUUNDO currentpanel.invoke TOOLUNDO
			Case MENUREDO currentpanel.invoke TOOLREDO

			Case MENUCUT currentpanel.invoke TOOLCUT
			Case MENUCOPY currentpanel.invoke TOOLCOPY
			Case MENUPASTE currentpanel.invoke TOOLPASTE
			Case MENUSELECTALL currentpanel.invoke TOOLSELECTALL
										
			Case MENUBUILD
				BuildCode()
			Case MENURUN
				RunCode()

			Case MENUBUILDMODULES
				If CheckDemo() BuildModules False
			Case MENUBUILDALLMODULES
				If CheckDemo() BuildModules True	
			'Case MENUSYNCMODS
			'	If CheckDemo() And CloseAll(False) syncmodsreq.Show
			Case MENUDOCMODS
				If CheckDemo() And CloseAll(False) DocMods
			Case MENUTRIGGERDOCMODS
				DocMods()
			Case MENUTRIGGERSYNCDOCS
				SyncDocs()
				
			Case MENUSTEP If output output.StepOver()
			Case MENUSTEPIN If output output.StepIn()
			Case MENUSTEPOUT If output output.StepOut()
			Case MENUSTOP If output output.Stop()

			Case MENULOCKBUILD
				activepanel.invoke TOOLLOCK
			Case MENUUNLOCKBUILD
				If lockedpanel lockedpanel.invoke TOOLUNLOCK
			
			Case MENUCOMMANDLINE cmdlinereq.Show
			
			Case MENUQUICKENABLED
				If quickenabled
					quickenabled=False
					UncheckMenu quickenable							
				Else
					quickenabled=True
					CheckMenu quickenable
				EndIf
				UpdateWindowMenu window

			Case MENUDEBUGENABLED
				If debugenabled
					debugenabled=False
					UncheckMenu debugenable							
				Else
					debugenabled=True
					CheckMenu debugenable
				EndIf
				UpdateWindowMenu window
				
			Case MENUTHREADEDENABLED
				If threadedenabled
					threadedenabled=False
					UncheckMenu threadedenable							
				Else
					threadedenabled=True
					CheckMenu threadedenable
				EndIf
				UpdateWindowMenu window
				
			Case MENUGUIENABLED
				If guienabled
					guienabled=False
					UncheckMenu guienable							
				Else
					guienabled=True
					CheckMenu guienable
				EndIf
				UpdateWindowMenu window

			Case MENUIMPORTBB
				ImportBB
				
			Case MENUFINDINFILES
				If activepanel Then searchreq.ShowWithPath( ExtractDir(activepanel.path) ) Else searchreq.Show()
				
			Case MENUPROJECTMANAGER
				projectreq.Open projects
			Case MENUSHOWCONSOLE
				If output Then output.Open()

			Case MENUOPTIONS
				options.Show()
				
			Case MENUNEXT
				If Not currentpanel Return
				index=currentpanel.index+1
				If index=panels.length index=0
				SelectPanel panels[index]

			Case MENUPREV
				If Not currentpanel Return
				index=currentpanel.index-1
				If index<0 index=panels.length-1
				SelectPanel panels[index]
			
			Case MENUQUICKHELP
				currentpanel.invoke TOOLHELP
			
			Case MENUHOME
				helppanel.Home()
				SelectPanel helppanel
			Case MENUBACK
				helppanel.Back()
				SelectPanel helppanel
			Case MENUFORWARD
				helppanel.Forward()
				SelectPanel helppanel
			Case MENUABOUT
				ShowAbout
			Case MENUINDENT
				currentpanel.invoke TOOLINDENT
			Case MENUOUTDENT
				currentpanel.invoke TOOLOUTDENT
				
			Case MENUNEWVIEW
				navbar.invoke TOOLNEWVIEW
				
		End Select
		
		If menu>=MENURECENT
			Local f:String = String(recentfiles.ValueAtIndex(menu-MENURECENT))
			If f$ OpenSource f$
		EndIf
	End Method
	
	Method poll()
		
		Local	src:TGadget
		Local event = WaitEvent()
				
		If Not activerequesters.IsEmpty()
			Select event
				Case EVENT_MENUACTION
					src = ActiveGadget()
					If src And (GadgetClass(src) = GADGET_TEXTFIELD) Then
						Select EventData()
							Case MENUSELECTALL
								ActivateGadget(src)
							Case MENUCOPY
								GadgetCopy(src)
							Case MENUPASTE
								GadgetPaste(src)
							Case MENUCUT
								GadgetCut(src)								
						EndSelect
						Return
					EndIf
					src = Null					
					Select EventData()
						Case MENUESCAPE
							For Local activerequester:TRequester = EachIn activerequesters
								activerequester.Hide
							Next
							Return
					End Select
					
				Case EVENT_MOUSEENTER,EVENT_MOUSELEAVE,EVENT_GADGETLOSTFOCUS
					Return
			End Select
			
			For Local activerequester:TRequester = EachIn activerequesters
				If activerequester.Poll() Then Return
			Next
		EndIf
		
		For Local handler:TEventHandler = EachIn eventhandlers
			handler.OnEvent()
		Next
		
		src = TGadget(EventSource())

		Select event
			Case EVENT_GADGETACTION
				Select EventSource()
					Case toolbar
						Select EventData()
							Case TB_NEW OpenSource ""
							Case TB_OPEN OpenSource "."
							Case TB_CLOSE currentpanel.invoke TOOLCLOSE
							Case TB_SAVE currentpanel.invoke TOOLSAVE	
							Case TB_CUT currentpanel.invoke TOOLCUT
							Case TB_COPY currentpanel.invoke TOOLCOPY
							Case TB_PASTE currentpanel.invoke TOOLPASTE
							Case TB_FIND currentpanel.invoke TOOLFIND
							Case TB_BUILD BuildCode
							Case TB_BUILDRUN RunCode
							Case TB_STEP If output output.stepover
							Case TB_STEPIN If output output.stepin
							Case TB_STEPOUT If output output.stepout
							Case TB_STOP If output output.Stop
							Case TB_HOME helppanel.Home;SelectPanel helppanel
							Case TB_BACK helppanel.Back;SelectPanel helppanel
							Case TB_FORWARDS helppanel.Forward;SelectPanel helppanel
						End Select
						
					Case tabbar
						Local index = EventData()
						If index>=0 And index<panels.length
							SelectPanel panels[index]
						EndIf
				End Select
				
			Case EVENT_WINDOWACCEPT, EVENT_APPOPENFILE
				OpenSource EventText()
				
			Case EVENT_APPTERMINATE
				Quit()
				
			Case EVENT_WINDOWACTIVATE
				If (src=window) Then SelectPanel currentpanel
				
			Case EVENT_WINDOWCLOSE
				If (src=window) Then Quit()
				
			Case EVENT_WINDOWMOVE, EVENT_WINDOWSIZE
				If (src=window) Then SnapshotWindow()
				
			Case EVENT_MENUACTION
				OnMenu EventData(),EventExtra()

		EndSelect
	EndMethod

EndType

Function CacheAndLoadText$(url:Object)
	Local tmpResult$
	Local tmpBytes:Byte[] = LoadByteArray(url)
	url = CreateRamStream( tmpBytes, tmpBytes.length, True, False )
	tmpResult = LoadText(url)
	TRamStream(url).Close()
	Return tmpResult
EndFunction


Type TWiki Extends TNode

	Field host:TCodePlay
	
	Field indexnode:TNode
	Field wikinode:TNode
	Field filesnode:TNode
	
	Field menunode:TNode
	
	Field wikimenu:TGadget

	Field spider:TCrawler
	
	Field wikidir$

	Const ALOOF=0
	Const INDEXING=1
	Const CRAWLING=2

	Field state

	Field crawlcount

	Field totalloads
	Field totalbytes
	
	Field dirtytree
			
	Method FetchDir(dir$,node:TNode)
		For Local file$=EachIn LoadDir(wikidir+"/"+dir)
			Local f:TNode
			f=node.FindNode(file)					
			If f=Null
				f=node.AddNode(file)				
				dirtytree=True
			EndIf
			Local path$=file
			If dir.Length>0 path=dir+"/"+file
			Select FileType(wikidir+"/"+path)
				Case FILETYPE_DIR
					FetchDir(path,f)
				Case FILETYPE_FILE
					spider.LinkFile(path)
			End Select
		Next
	End Method
	
	Method OnLoad(dir$,url$,content$)

		SaveText content,wikidir+"/"+url				

		totalloads:+1
		totalbytes:+content.Length
		
		Local parts$[]
		parts=(dir+"/"+url).Split("/")
		
		Local n:TNode
		n=wikinode
		For Local part$=EachIn parts	'url.Split("/")
			Local f:TNode
			f=n.FindNode(part)
			If f=Null
				f=n.AddNode(part)				
				dirtytree=True
			EndIf
			n=f			
		Next

	End Method
	
	Function CreateWiki:TWiki(host:TCodePlay)
		Local p:TWiki = New TWiki

		p.wikimenu=CreateMenu("Wiki",0,Null)
		CreateMenu "Refresh",MENUREFRESH,p.wikimenu

		p.wikidir=AppDir+"/wiki"
		
		p.SetName("Wiki")
		p.host=host		

		p.indexnode=p.AddNode("Index")

		p.wikinode=p.AddNode("Offline")

'		p.wikinode=TFolderNode.CreateFolderNode(p.wikidir,TFolderNode.DIRECTORYFOLDER)
'		p.wikinode.owner=p
'		p.Append(p.wikinode)

		p.filesnode=p.AddNode("Files")
		
		p.setAction(p,TOOLMENU,p)

		p.indexnode.SetAction(p,TOOLMENU,p.indexnode)
		p.wikinode.SetAction(p,TOOLMENU,p.wikinode)
		p.filesnode.SetAction(p,TOOLMENU,p.filesnode)
		
		p.wikimenu=CreateMenu("Wiki",0,Null)
		CreateMenu "Refresh",MENUREFRESH,p.wikimenu
		CreateMenu "Cancel",MENUCANCEL,p.wikimenu
		
		p.spider=New TCrawler
		p.spider.setOwner p

		p.FetchDir "",p.wikinode
		p.BuildIndex
		
		Return p
	End Function

	Method Invoke(command,argument:Object)
	
		DebugLog "Invoke:"+command+","+String(Argument)

		Select command
		
			Case TOOLMENU			
				Local cmd=Int(String(argument))
				
				Select cmd				
					Case 0
						menunode=TNode(argument)		
						Select menunode
							Case Self
								Return
								Highlight			
							Case indexnode
								indexnode.Highlight
							Case wikinode
								wikinode.Highlight
							Case filesnode
								filesnode.Highlight
						End Select		
						PopupWindowMenu host.window,wikimenu,Self
					Case MENUREFRESH					
						Select menunode				
							Case indexnode
								Select state
									Case ALOOF
										PullIndex
									Case INDEXING
										StopIndex
									Case CRAWLING
										StopCrawl
								End Select							
							Case wikinode
								Select state
									Case ALOOF
										CrawlWiki
									Case INDEXING
										StopIndex
									Case CRAWLING
										StopCrawl
								End Select							
						End Select
					Case MENUCANCEL			
							Select menunode								
								Case indexnode
									If state=INDEXING StopIndex
								Case wikinode
									If state=CRAWLING StopCrawl
							End Select
				End Select
		End Select
	End Method

	Method BuildFiles()
	End Method
	
	Method BuildIndex()
		Local index$
		Local dir$
		dir=wikidir+"/"+WIKI_SITE_INDEX	
		If FileType(dir)<>FILETYPE_FILE
			DebugLog "Problem building wiki index"
			Return
		EndIf				
		indexnode.FreeKids		
		index=LoadString(dir)					
		Local words$[]
		Local i		
		words=index.Split("<loc>")		
		For i=1 Until words.Length
			Local word$=words[i]
			Local p=word.find("</loc>")
			If p=-1 Continue			
			Local title$=word[..p]			
			If title.startsWith(WIKI_URL)
				title=title[WIKI_URL.Length..]				
				Local n:TNode
				Local href$=WIKI_URL+title+WIKI_ARGS
				n=indexnode.AddNode(title)				
				n.SetAction(host.helppanel,TOOLNAVIGATE,href)								
			EndIf			
		Next		
		indexnode.Refresh
	End Method
		
	Method Poll()
	
		Select state
			Case INDEXING
				If spider.Busy()
					spider.Poll()
				Else
					DebugLog "Finished Index"
					BuildIndex
					StopIndex
				EndIf				
			Case CRAWLING
				If spider.Busy()
					spider.Poll()					
					crawlcount:+1
					If crawlcount&31=1						
						Local count=spider.filelist.Count()						
						wikinode.SetName "Crawling... "+totalloads+"/"+(count+totalloads)
						wikinode.Refresh						
					EndIf
				Else
					DebugLog "Finished Crawl"
					StopCrawl					
				EndIf
		End Select
	End Method
	
	Method PullIndex()
		Local dir$=wikidir
		
		If FileType(dir)=FILETYPE_NONE
			CreateDir dir
		EndIf			

		If FileType(dir)=FILETYPE_NONE
			Notify "Wiki unable to use dir "+dir
			Return
		EndIf
		
		spider.Crawl(WIKI_HOST,WIKI_SITE_INDEX,dir,False)

		state=INDEXING
			
		indexnode.SetName "Indexing..."
		indexnode.Refresh

	End Method
	
	Method CrawlWiki()
		Local dir$=wikidir
		
		If FileType(dir)=FILETYPE_NONE
			CreateDir dir
		EndIf			

		If FileType(dir)=FILETYPE_NONE
			Notify "Wiki unable to use dir "+dir
			Return
		EndIf
		
		spider.Crawl(WIKI_HOST,WIKI_INDEX+WIKI_ARGS,dir,True)
		state=CRAWLING
			
		wikinode.SetName "Crawling..."
		wikinode.Refresh
	End Method
	
	Method StopCrawl()
		spider.Stop
		state=ALOOF
		wikinode.SetName "Wiki"
		wikinode.Refresh
		
		wikinode.RefreshView
	End Method

	Method StopIndex()
		state=ALOOF
		indexnode.SetName "Index"
		indexnode.Refresh
	End Method

End Type


Type TCrawler
	Const CRAWLERLEGS=5

	Field owner:TWiki
	
	Field host$
	Field legs:TGet[CRAWLERLEGS]		
	Field busycount
	Field filelist:TList	
	Field names:TMap	
	Field cachepath$	
	Field recurse

	Method New()
		For Local i=0 Until CRAWLERLEGS
			legs[i]=New TGet
		Next
		filelist=New TList
		names=New TMap
	End Method
	
	Method SetOwner(wiki:TWiki)
		owner=wiki
	End Method
	
	Method Stop()
		Local get:TGet
		For get=EachIn legs
			get.Stop
		Next
	End Method
		
	Method Busy()
		If filelist.Count()>0 Or busycount>0 Return True
		Return False
	End Method

	Method Crawl(host0$,path$,dir0$,recurse0=True)
		host=host0
		cachepath=dir0
		filelist.AddLast(path)
		recurse=recurse0
	End Method
	
	Method LinkFile(url$)
		names.Insert url,Null				
	End Method 
	
	Method UpdateContent(url$,content$,headers$)	
		names.Insert url,content		
		url=url.Replace("?","%3F")			

		Local cachedir$=cachepath		
		Local dir$=""

		Local d=url.FindLast("/")		
		If d>-1
			dir=url[..d]			
			url=url[d+1..]

			cachedir$:+cachepath+"/"+dir						
			If FileType(cachedir)=FILETYPE_NONE
				CreateDir cachedir
			EndIf			
		EndIf		
		
		owner.OnLoad dir,url,content

'		DebugLog "wrote "+dir+"/"+url		
'		DebugLog content

		If Not recurse Return

		Local srch$="href=~q"
		Local p=0
		Local q=0
		While p<content.Length	
			p=content.Find(srch,p)
			If p=-1 Exit			
			p:+srch.Length
			q=content.Find("~q",p+1)
			If q=-1 Exit			
			Local ref$=content[p..q]						
			If ref.StartsWith("http:") Continue
			If ref.StartsWith("https:") Continue			

			If ref.Find("?r=")>-1 Continue
			If ref.Find("?page=")>-1 Continue
			If ref.EndsWith(".rss") Continue

			If ref.StartsWith("/")
				ref=ref[1..]				
				
				If names.Contains(ref) Continue								
				
				DebugLog "crawling "+ref

				names.Insert ref,Null
				filelist.AddLast ref
			EndIf						
		Wend		
	End Method
				
	Method Poll()	
		Local get:TGet
		For get=EachIn legs		
			get.Poll
			If get.finished And get.url<>Null
				Local result$=get.result
				Local url$=get.url				
				get.url=Null
				busycount:-1
				Local header$				
				Local p=result.Find("~r~n~r~n")				
				If p<>-1		
					header=result[..p]
					result=result[p+4..]					
					UpdateContent url,result,header										
				EndIf				
			EndIf
		Next
				
		For get=EachIn legs
			If get.url=Null And filelist.Count()>0		
				Local path$=String(filelist.RemoveFirst())				
				get.fromHost(host,path)
				busycount:+1
			EndIf
		Next		
		
	End Method	

End Type
	

Type TGet

	Const GETBUFFERSIZE=1200000
	Const MAXREADSIZE=65536
	
	Field socket:TSocket
	Field ip
	Field host$
	Field url$	
	Field disconnected
	Field finished
	Field result$

	Field bytebuffer:Byte[GETBUFFERSIZE+1]
	Field bytepos
	
	Method New()
	End Method
	
	Method fromHost:TGet(host0$,path$,port=80)
		socket=CreateTCPSocket() 
		host=host0
		ip=HostIp(host)
		url=path
		disconnected=True
		bytepos=0
		finished=False
		result=""		
		ConnectSocket socket,ip,port	

'		socket.SetNonBlocking 1

		Return Self
	End Method
	
	Method Stop()
		CloseSocket socket
		finished=True
		url=Null
	End Method
	
	Method Poll()		
		If finished Return		
		If url=Null Return		

		If disconnected
			Local isconnected=SocketConnected(socket)		
			If isconnected
				disconnected=False
				Local msg$				
				msg = "GET /"+url+" HTTP/1.0~r~n"
				msg :+ "Host: "+host+"~r~n"
				msg :+ "User-Agent: MonkClient~r~n"
				msg :+ "Accept: */*~r~n"
				msg :+ "~r~n"				
				Local cmsg:Byte Ptr
				Local bytes				
				cmsg=msg.ToCString()
				bytes=msg.Length				
				socket.Send(cmsg,bytes)				
			Else			
				Return
			EndIf
		EndIf
				
		Local n=SocketReadAvail(socket)		

		If n>0			
			If bytepos+n>GETBUFFERSIZE n=GETBUFFERSIZE-bytepos			

			If n=0 'we have buffer overflow
				DebugLog "Buffer Overflow url="+url+" bytepos="+bytepos
				finished=True	
				Return
			EndIf			
			
			If n>MAXREADSIZE n=MAXREADSIZE
			
			n=socket.Recv(Varptr bytebuffer[bytepos],n)			

			bytepos:+n		
		Else
			Local isconnected=SocketConnected(socket)		
			If Not isconnected			
				bytebuffer[bytepos]=0				
				result=String.FromCString(bytebuffer)
				finished=True				
				Return			
			EndIf
		EndIf
				
	End Method
	
End Type




