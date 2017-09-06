unit qIRCMain;

interface

uses
  WSocket, Tokens, Forms, Windows, Messages, Dialogs,
  Menus, ImgList, Controls, Classes, ToolWin, SysUtils,
  lmdnonvS, lmdclass, StdCtrls, ExtCtrls, lmdctrl, ComCtrls,
  ElStatBar, lmdextcS, RichEdit2, DDUStandard, lmddlgS;

Type
  TMyTabSheet=Class(TTabSheet)
  Public
    Form : TForm;
  End;

type
  TIRCMain = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    NewWindow: TMenuItem;
    Exit1: TMenuItem;
    Settings1: TMenuItem;
    N1: TMenuItem;
    Help1: TMenuItem;
    Window1: TMenuItem;
    Tile1: TMenuItem;
    Cascade1: TMenuItem;
    Arrangeicons1: TMenuItem;
    TBImages: TImageList;
    ToolBar1: TToolBar;
    Toggles1: TMenuItem;
    CreateStatus: TToolButton;
    SelBar: TMenuItem;
    WrapText1: TMenuItem;
    BUIC1: TMenuItem;
    View1: TMenuItem;
    Toolbar2: TMenuItem;
    Statusbar2: TMenuItem;
    N2: TMenuItem;
    ToolbarProperties1: TMenuItem;
    Settings: TToolButton;
    QuitButton: TToolButton;
    About: TToolButton;
    Contents1: TMenuItem;
    About1: TMenuItem;
    CloseAll1: TMenuItem;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    Tile2: TToolButton;
    Cascade2: TToolButton;
    Arrange2: TToolButton;
    Maximize2: TToolButton;
    CloseWindows: TToolButton;
    ToolButton4: TToolButton;
    Contents2: TToolButton;
    Maximizeall1: TMenuItem;
    Options1: TMenuItem;
    Aliases1: TMenuItem;
    Colors1: TMenuItem;
    LMDShapeHint1: TLMDShapeHint;
    TabPage: TPageControl;
    PopupMenu1: TPopupMenu;
    Close1: TMenuItem;
    InfoBars1: TMenuItem;
    TabBar2: TMenuItem;
    N3: TMenuItem;
    Addservertolist1: TMenuItem;
    Fonts: TFontDialog;
    Changefont1: TMenuItem;
    Reg: TLMDIniCtrl;
    N4: TMenuItem;
    CheckForlatestversion1: TMenuItem;
    UpTimer: TTimer;
    StatusBar: TLMDStatusBar;
    LMDTipDlg1: TLMDTipDlg;
    procedure NewWindowClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Settings1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure InitProg(Sender: TObject);
    procedure Tile1Click(Sender: TObject);
    procedure Cascade1Click(Sender: TObject);
    procedure ArrangeIcons1Click(Sender: TObject);
    procedure Toolbar2Click(Sender: TObject);
    procedure Statusbar2Click(Sender: TObject);
    procedure SelBarClick(Sender: TObject);
    procedure WrapText1Click(Sender: TObject);
    procedure BUIC1Click(Sender: TObject);
    procedure CloseMe;
    procedure QuitButtonClick(Sender: TObject);
    procedure AboutClick(Sender: TObject);
    procedure ShowSettings;
    procedure SettingsClick(Sender: TObject);
    procedure Shutdown(Sender: TObject; var CanClose: Boolean);
    procedure CreateStatusClick(Sender: TObject);
    procedure SaveToRegistry;
    procedure StartNew;
    procedure LoadFromRegistry;
    procedure CloseAll1Click(Sender: TObject);
    procedure UpdateInfo;
    procedure ChangeStatus(S: String);
    procedure AddToServerList(S: String);
    procedure CloseAll;
    procedure CloseSpecific(P: Integer);
    function StripIt(S: String): String;
    function StripColor(S: String): String;    
    procedure SelfPartChan(S: String; P: Integer);
    procedure Tile2Click(Sender: TObject);
    procedure Cascade2Click(Sender: TObject);
    procedure Arrange2Click(Sender: TObject);
    procedure Maximize2Click(Sender: TObject);
    procedure CloseWindowsClick(Sender: TObject);
    procedure Contents2Click(Sender: TObject);
    procedure Contents1Click(Sender: TObject);
    procedure MaximizeAll;
    procedure Maximizeall1Click(Sender: TObject);
    function IsNumeric(S: String): Boolean;
    function IsNumeric01(S: String): Byte;
    function ValIt(S: String): Integer;
    procedure AddGuy(CH, G: String; T: Integer);
    procedure DelGuy(CH, G: String; T: Integer);
    procedure AddTextTo(CH, S: String; P, T: Integer);
    procedure AddTopic(CH, T: String; N: Integer);
    procedure AddTextAll(WH, G: String; C, T: Integer);
    procedure DelGuyAll(G: String; T: Integer);
    procedure ChangeNickAll(Old, New: String; T: Integer);
    procedure AddCHMode(CH, M: String; T: Integer);
    procedure SlashCmd(S, CH: String; P: Integer; FormMain: TRichEdit98);
    procedure InstantConnect(S, P: String);
    function IPToInt(S: String): LongWord;
    procedure SendMsg(WH, S, M: String; P: Integer);
    procedure AddMsgText(WHO, S: String; C, P: Integer);
    procedure Aliases1Click(Sender: TObject);
    procedure AddActionAll(S: String; T: Integer);
    procedure Colors1Click(Sender: TObject);
    procedure WriteStr(Sec, ID, Str: String);
    function ReadStr(Sec, ID: String): String;
    procedure TabBar2Click(Sender: TObject);
    procedure TabPageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PageControlPopup(Sender: TObject);
    procedure UpdateSvrBox(Sel: Integer);
    procedure FormCreate(Sender: TObject);
    procedure SelectSaveMethod(I: Byte);
    procedure FormShow(Sender: TObject);
    procedure CheckForlatestversion1Click(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
    procedure TabPageChange(Sender: TObject);
    procedure UpTimerTimer(Sender: TObject);
    procedure AddNicksTo(CH: String; A1, A2, T: Integer);
    function GetNicksFrom(CH: String; T: Integer): String;
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
  private
    Activated      : Boolean;
  public
    APPNAME        : String[20];
    VER            : String[5];
    ServerList     : TStringList;
    AliasList      : TStringList;
    StartedNew     : Boolean;
    WData          : Char;
    UpTime         : Cardinal;
  end;

var
  IRCMain: TIRCMain;
  MainMenu: TMainMenu;

Const  IRCAction          = #1;
       IRCColor           = #3;
       IRCBold            = #2;
       IRCReverse         = #22;
       IRCUnderline       = #31;
       IRCBeep            = #7;
       IRCBoldCancel      = #15;
       IRCTab             = #8;
       ModeBan            = '+b';

function Un_CTime(Date_and_Time: String): Double;
function CTime(UnixTime: Double): String;
function GetColor(C: Integer): Integer;
function LocalIP: String;
function Ints(S: String): Integer;
function UpStr(S: String): String;
function Ask(S: String): Boolean;
procedure Delay(D: Integer);
Function Encrypt(InText:String): String;
Function Decrypt(InText: String): String;


implementation

uses qAbout, QSettins, qStatus, qCmd, qChannel, qMsgBox,
     qFeatures, qColors, qFavorites, qWelcome, qUpgrade,
     qChanList, qSettings;

{$R *.DFM}

function CTime(UnixTime: Double): string;
var
  DateTime: TDateTime;
  TimeZoneInformation: TTimeZoneInformation;
begin
  GetTimeZoneInformation(TimeZoneInformation);
  DateTime := StrToDate('01/01/1970') + (UnixTime / 86400) - (TimeZoneInformation.Bias / 1440);
  Result := FormatDateTime('m/d/yy h:nn:ss AM/PM', DateTime);
end;

function Un_CTime(Date_and_Time: string): Double;
var
  MyTimeZoneInformation: TTimeZoneInformation;
begin
  GetTimeZoneInformation(MyTimeZoneInformation);
  with MyTimeZoneInformation do
    Result := (StrToDateTime(Date_and_Time) - StrToDate('01/01/1970') + (Bias / 1440)) * 86400;
end;

function UpStr(S: String): String;
var
  I: Integer;
begin
  For I := 1 To Length(S) Do
    Case S[I] Of
      '{': S[I] := '[';
      '}': S[I] := ']';
      '|': S[I] := '\';
    Else
      S[I] := UpCase(S[I]);
    End;
  UpStr := S;
end;

procedure TIRCMain.ShowSettings();
begin
  IRCMain.Settings.Enabled := False;
  IRCMain.Settings1.Enabled := False;
  IRCMain.UpdateInfo;
  Settins.Show;
end;

function TIRCMain.IsNumeric(S: String): Boolean;
var
  I, Code: Integer;
begin
  Val(S, I, Code);
  If (Code = 0) Then
    Result := True
  Else
    Result := False;
end;

function TIRCMain.IsNumeric01(S: String): Byte;
var
  I, Code: Integer;
begin
  Val(S, I, Code);
  If (Code = 0) Then
    Result := 1
  Else
    Result := 0;
end;

procedure TIRCMain.CloseMe;
var
  I: Integer;
begin
  If (Settins.UserLevel.ItemIndex <> 2) Then
    If (Not Ask('Are you sure you want to quit?')) Then
      Exit;

  SaveToRegistry;
  I := Reg.ReadInteger('Miscellaneous', 'Times_Used', 0);
  Reg.WriteInteger('Miscellaneous', 'Times_Used', I + 1);
  ServerList.Free;
  AliasList.Free;

  For I := 0 To MDIChildCount-1 Do
  Begin
    (MDIChildren[I] As TForm).Release;
  End;

  Application.Terminate;
end;

procedure TIRCMain.NewWindowClick(Sender: TObject);
begin
  TStatus.Create(Status);
end;

procedure TIRCMain.Exit1Click(Sender: TObject);
begin
  CloseMe;
end;

procedure TIRCMain.Settings1Click(Sender: TObject);
begin
  ShowSettings;
end;

procedure TIRCMain.About1Click(Sender: TObject);
begin
  Application.CreateForm(TAboutBox, AboutBox);
end;

procedure TIRCMain.SaveToRegistry;
Var
  I: Integer;
begin
  For I := 0 to ServerList.Count - 1 Do
    WriteStr('Servers', 'Server_' + IntToStr(I), ServerList.Strings[I]);
  Reg.WriteInteger('Servers', 'Amount', ServerList.Count - 1);
  Reg.WriteInteger('Servers', 'Selected', Settins.Server.ItemIndex);

  For I := 0 to AliasList.Count - 1 Do
    WriteStr('Aliases', 'Alias_' + IntToStr(I), AliasList.Strings[I]);
  Reg.WriteInteger('Aliases', 'Amount', AliasList.Count - 1);

  WriteStr('User_Info', 'Nickname', Settins.NickText.Text);
  WriteStr('User_Info', 'Alternate_Nick', Settins.AltNickText.Text);
  WriteStr('User_Info', 'Real_Name', Settins.RealText.Text);
  WriteStr('Strings', 'Quit_Message', Settins.QuitText.Text);
  WriteStr('Strings', 'Part_Message', Settins.PartText.Text);
  WriteStr('Strings', 'Version_Reply', Settins.VersText.Text);
  WriteStr('Strings', 'EMail_Address', Settins.MAILText.Text);
  WriteStr('Strings', 'Away_Message', Settins.AwayText.Text);
  WriteStr('Strings', 'Kick_Message', Settins.KickText.Text);
  Reg.WriteBool('IDENT', 'IDENT_Enabled', Settins.IDENT.Checked);
  WriteStr('IDENT', 'IDENT_Response', Settins.IdntText.Text);
  WriteStr('IDENT', 'System_Type', Settins.SysType.Text);
  WriteStr('IDENT', 'Listen_Port', Settins.PortText.Text);
  Reg.WriteBool('IDENT', 'Show_Requests', Settins.ShowIdent.Checked);
  WriteStr('Miscellaneous', 'Last_Time_Used', DateToStr(Date) + ' ' + TimeToStr(Time));
  Reg.WriteBool('Options_1', 'Use_Serv_Ping', Settins.CheckLag.Checked);
  WriteStr('Options_1', 'Interval', Settins.LagSecs.Text);
  Reg.WriteBool('Options_1', 'Server_Raw', Settins.UseRaw.Checked);
  Reg.WriteInteger('Options_1', 'User_Level', Settins.UserLevel.ItemIndex);
  Reg.WriteBool('Options_1', 'Show_Hints', Settins.UseHints.Checked);
  Reg.WriteBool('Options_1', 'Show_Sent_Msgs', Settins.ShowSend.Checked);
  Reg.WriteBool('Options_1', 'Round_Ping_Results', Settins.RoundPing.Checked);
  Reg.WriteBool('Options_1', 'Use_Lights', Settins.UseLights.Checked);
  Reg.WriteBool('Options_1', 'Nick_Highlight', Settins.NickHighlight.Checked);
  Reg.WriteBool('Options_1', 'Colors_C1', Settins.C1.Checked);
  Reg.WriteBool('Options_1', 'Colors_C2', Settins.C2.Checked);
  Reg.WriteBool('Options_1', 'Colors_C3', Settins.C3.Checked);
  Reg.WriteBool('Options_1', 'Colors_C4', Settins.C4.Checked);
  Reg.WriteBool('Options_1', 'Colors_C5', Settins.C5.Checked);
  Reg.WriteBool('Socks', 'Use_Socks', Settins.UseSocks.Checked);
  Reg.WriteBool('Toggles', 'Wrap_Text', WrapText1.Checked);
  Reg.WriteBool('Toggles', 'Selection_Bar', SelBar.Checked);
  Reg.WriteBool('Toggles', 'BUIC', BUIC1.Checked);
  Reg.WriteBool('Options_1', 'Use_Away', Settins.UseAway.Checked);
  WriteStr('Options_1', 'Away_Delay', Settins.AwayMins.Text);
  Reg.WriteBool('Encryption', 'Enc_Saves', Settins.UseEnc.Checked);
  Reg.WriteInteger('Encryption', 'Enc_Level', Settins.EncLevel.ItemIndex);
  Reg.WriteBool('Menu_Bar', 'Use_Toolbar', Toolbar2.Checked);
  Reg.WriteBool('Menu_Bar', 'Use_Statusbar', Statusbar2.Checked);
  Reg.WriteBool('Menu_Bar', 'Use_Tabbar', Tabbar2.Checked);
  Reg.WriteString('Program', 'VERSION', VER);
  Reg.WriteInteger('Options_2', 'Startup_Mode', Settins.StartMode.ItemIndex);
  Reg.WriteString('Options_1', 'SNotice', Settins.Notice.Text);
  Reg.WriteBool('Options_2', 'Beep_Notice', Settins.BeepNotice.Checked);
  Reg.WriteBool('Options_2', 'List_Names', Settins.ListNames.Checked);
  Reg.WriteBool('Options_2', 'Hide_Ping', Settins.HidePing.Checked);
  Reg.WriteBool('Options_2', 'Cancel_Away', Settins.CancelAway.Checked);
  Reg.WriteBool('Options_2', 'Startup_Server', Settins.Con2Svr.Checked);
end;

procedure TIRCMain.StartNew;
begin
  ServerList.Clear;
  AliasList.Clear;
  AddToServerList('Undernet (Random)'#255'us.undernet.org'#255'6667'#255);
  AddToServerList('Undernet (LA)'#255'los-angeles.ca.us.undernet.org'#255'6667'#255);
  AddToServerList('EFNet (Primenet)'#255'irc.primenet.com'#255'6667'#255);
  Settins.IDENT.Checked := True;
  Settins.Server.ItemIndex := 0;
  Settins.PortText.Text := '113';
  Settins.SysType.Text := 'UNIX';
  Settins.IdntText.Text := APPNAME;
  Settins.NickText.Text := 'roler_';
  Settins.AltNickText.Text := '[roler]';
  Settins.RealText.Text := APPNAME + ' by roler';
  Settins.QuitText.Text := 'Goodbye people!';
  Settins.VersText.Text := APPNAME + ' ' + VER + ' © roler.';
  Settins.MailText.Text := 'Yeah right!';
  Settins.KickText.Text := 'Get out of here!';
  Settins.PartText.Text := 'Later peeps...';
  Settins.TU.Caption := '0';
  Settins.LTU.Caption := 'Never';
  Settins.CheckLag.Checked := True;
  Settins.LagSecs.Text := '30';
  Settins.UseRaw.Checked := False;
  Settins.UserLevel.ItemIndex := 0;
  Settins.UseHints.Checked := True;
  Settins.ShowSend.Checked := False;
  Settins.ShowIdent.Checked := False;
  Settins.RoundPing.Checked := True;
  Settins.UseLights.Checked := True;
  Settins.UseSocks.Checked := False;
  Settins.NickHighlight.Checked := True;
  BUIC1.Checked := True;
  WrapText1.Checked := True;
  SelBar.Checked := False;
  AliasList.Add('/raw /quote $*');
  AliasList.Add('/j /join $*');
  AliasList.Add('/p /ping $*');
  AliasList.Add('/m /msg $*');
  AliasList.Add('/wi /whois $*');
  AliasList.Add('/ww /whowas $*');  
  AliasList.Add('/uwho /whois $*');
  AliasList.Add('/n /notice $*');
  AliasList.Add('/action /me $*');
  Settins.UseAway.Checked := True;
  Settins.AwayMins.Text := '10';
  Settins.AwayText.Text := 'I am currently away from my keyboard!';
  Settins.UseEnc.Checked := True;
  Settins.EncLevel.ItemIndex := 0;
  Statusbar2.Checked := True;
  Toolbar2.Checked := True;
  Tabbar2.Checked := True;
  Settins.C1.Checked := True;
  Settins.C2.Checked := True;
  Settins.C3.Checked := True;
  Settins.C4.Checked := True;
  Settins.C5.Checked := True;
  Settins.StartMode.ItemIndex := 0;
  Settins.Notice.Text := '*** ';
  Settins.BeepNotice.Checked := True;
  Settins.ListNames.Checked := True;
  Settins.HidePing.Checked := False;
  Settins.CancelAway.Checked := True;
  Settins.Con2Svr.Checked := False;
end;

procedure TIRCMain.LoadFromRegistry;
var
  I, P: Integer;
  Tmp: String;
begin
  ServerList.Clear;
  Settins.Server.Clear;
  AliasList.Clear;

  Settins.UseEnc.Checked := Reg.ReadBool('Encryption', 'Enc_Saves', True);

  P := Reg.ReadInteger('Servers', 'Amount', 0);
  For I := 0 To P Do
  Begin
    Tmp := ReadStr('Servers', 'Server_' + IntToStr(I));
    If (Tmp = '') Then Break;
    AddToServerList(Tmp);
  End;
  Settins.Server.ItemIndex := Reg.ReadInteger('Servers', 'Selected', 0);

  P := Reg.ReadInteger('Aliases', 'Amount', 0);
  For I := 0 To P Do
  Begin
    Tmp := ReadStr('Aliases', 'Alias_' + IntToStr(I));
    If (Tmp = '') Then Break;
    AliasList.Add(Tmp);
  End;

  Settins.NickText.Text := ReadStr('User_Info', 'Nickname');
  Settins.AltNickText.Text := ReadStr('User_Info', 'Alternate_Nick');
  Settins.RealText.Text := ReadStr('User_Info', 'Real_Name');
  Settins.QuitText.Text := ReadStr('Strings', 'Quit_Message');
  Settins.PartText.Text := ReadStr('Strings', 'Part_Message');
  Settins.VersText.Text := ReadStr('Strings', 'Version_Reply');
  Settins.MAILText.Text := ReadStr('Strings', 'EMail_Address');
  Settins.AwayText.Text := ReadStr('Strings', 'Away_Message');
  Settins.KickText.Text := ReadStr('Strings', 'Kick_Message');
  Settins.IDENT.Checked := Reg.ReadBool('IDENT', 'IDENT_Enabled', True);
  Settins.IdntText.Text := ReadStr('IDENT', 'IDENT_Response');
  Settins.SysType.Text := ReadStr('IDENT', 'System_Type');
  Settins.PortText.Text := ReadStr('IDENT', 'Listen_Port');
  Settins.ShowIdent.Checked := Reg.ReadBool('IDENT', 'Show_Requests', False);
  Settins.LTU.Caption := ReadStr('Miscellaneous', 'Last_Time_Used');
  Settins.TU.Caption := ReadStr('Miscellaneous', 'Times_Used');
  Settins.CheckLag.Checked := Reg.ReadBool('Options_1', 'Use_Serv_Ping', True);
  Settins.LagSecs.Text := ReadStr('Options_1', 'Interval');
  Settins.UseRaw.Checked := Reg.ReadBool('Options_1', 'Server_Raw', False);
  Settins.UserLevel.ItemIndex := Reg.ReadInteger('Options_1', 'User_Level', 0);
  Settins.UseHints.Checked := Reg.ReadBool('Options_1', 'Show_Hints', True);
  Settins.ShowSend.Checked := Reg.ReadBool('Options_1', 'Show_Sent_Msgs', False);
  Settins.RoundPing.Checked := Reg.ReadBool('Options_1', 'Round_Ping_Results', True);
  Settins.UseLights.Checked := Reg.ReadBool('Options_1', 'Use_Lights', True);
  Settins.NickHighlight.Checked := Reg.ReadBool('Options_1', 'Nick_Highlight', True);
  Settins.C1.Checked := Reg.ReadBool('Options_1', 'Colors_C1', True);
  Settins.C2.Checked := Reg.ReadBool('Options_1', 'Colors_C2', True);
  Settins.C3.Checked := Reg.ReadBool('Options_1', 'Colors_C3', True);
  Settins.C4.Checked := Reg.ReadBool('Options_1', 'Colors_C4', True);
  Settins.C5.Checked := Reg.ReadBool('Options_1', 'Colors_C5', True);
  Settins.UseSocks.Checked := Reg.ReadBool('Socks', 'Use_Socks', False);
  WrapText1.Checked := Reg.ReadBool('Toggles', 'Wrap_Text', True);
  SelBar.Checked := Reg.ReadBool('Toggles', 'Selection_Bar', True);
  BUIC1.Checked := Reg.ReadBool('Toggles', 'BUIC', True);
  Settins.UseAway.Checked := Reg.ReadBool('Options_1', 'Use_Away', True);
  Settins.AwayMins.Text := ReadStr('Options_1', 'Away_Delay');
  Settins.EncLevel.ItemIndex := Reg.ReadInteger('Encryption', 'Enc_Level', 0);
  Toolbar2.Checked := Reg.ReadBool('Menu_Bar', 'Use_Toolbar', True);
  Statusbar2.Checked := Reg.ReadBool('Menu_Bar', 'Use_Statusbar', True);
  Tabbar2.Checked := Reg.ReadBool('Menu_Bar', 'Use_Tabbar', True);
  Settins.StartMode.ItemIndex := Reg.ReadInteger('Options_2', 'Startup_Mode', 0);
  Settins.Notice.Text := Reg.ReadString('Options_1', 'SNotice', '');
  Settins.BeepNotice.Checked := Reg.ReadBool('Options_2', 'Beep_Notice', True);
  Settins.ListNames.Checked := Reg.ReadBool('Options_2', 'List_Names', True);
  Settins.HidePing.Checked := Reg.ReadBool('Options_2', 'Hide_Ping', False);
  Settins.CancelAway.Checked := Reg.ReadBool('Options_2', 'Cancel_Away', True);
  Settins.Con2Svr.Checked := Reg.ReadBool('Options_2', 'Startup_Server', False);
end;

procedure TIRCMain.InitProg(Sender: TObject);
begin
  If (Activated) Then Exit;
  Activated := True;
  Self.Caption := APPNAME;
  QuitButton.Hint := 'Quit ' + APPNAME;
  About.Hint := 'About ' + APPNAME;
  ServerList := TStringList.Create;
  AliasList := TStringList.Create;

  If (StartedNew) Then
  Begin
    StartNew;
    SaveToRegistry;
  End
  Else
  Begin
    LoadFromRegistry;
  End;

  Toolbar1.Visible := Toolbar2.Checked;
  Statusbar.Visible := Statusbar2.Checked;
  TabPage.Visible := TabBar2.Checked;

  {Ping settings in Other tab}
  Settins.LagSecs.Enabled := Settins.CheckLag.Checked;
  Settins.RoundPing.Enabled := Settins.CheckLag.Checked;
  Settins.Label18.Enabled := Settins.CheckLag.Checked;

  {Ident settings}
  Settins.IdntText.Enabled := Settins.IDENT.Checked;
  Settins.SysType.Enabled := Settins.IDENT.Checked;
  Settins.PortText.Enabled := Settins.IDENT.Checked;
  Settins.Label8.Enabled := Settins.IDENT.Checked;
  Settins.Label9.Enabled := Settins.IDENT.Checked;
  Settins.Label10.Enabled := Settins.IDENT.Checked;
  Settins.ShowIdent.Enabled := Settins.IDENT.Checked;

  {Socks settings}
  Settins.SocksServer.Enabled := Settins.UseSocks.Checked;
  Settins.SAdd.Enabled := Settins.UseSocks.Checked;
  Settins.SEdit.Enabled := Settins.UseSocks.Checked;
  Settins.SDel.Enabled := Settins.UseSocks.Checked;
  Settins.SSort.Enabled := Settins.UseSocks.Checked;

  ChangeStatus('Welcome to ' + APPNAME + ', the #1 irc client!');

  If (Settins.Con2Svr.Checked) Then
    InstantConnect('', '');
end;

procedure TIRCMain.Tile1Click(Sender: TObject);
begin
  Tile;
end;

procedure TIRCMain.Cascade1Click(Sender: TObject);
begin
  Cascade;
  ArrangeIcons;
end;

procedure TIRCMain.Arrangeicons1Click(Sender: TObject);
begin
  ArrangeIcons;
end;

procedure TIRCMain.Toolbar2Click(Sender: TObject);
begin
  Toolbar2.Checked := Not Toolbar2.Checked;
  Toolbar1.Visible := Toolbar2.Checked;
end;

procedure TIRCMain.Statusbar2Click(Sender: TObject);
begin
  Statusbar2.Checked := Not Statusbar2.Checked;
  Statusbar.Visible := Statusbar2.Checked;
end;

procedure TIRCMain.SelBarClick(Sender: TObject);
begin
  SelBar.Checked := Not SelBar.Checked;
end;

procedure TIRCMain.WrapText1Click(Sender: TObject);
var
  I: Integer;
begin
  WrapText1.Checked := Not WrapText1.Checked;
  For I := 0 to MDIChildCount-1 Do
    (MDIChildren[I] As TStatus).Main.WordWrap := WrapText1.Checked;
end;

procedure TIRCMain.BUIC1Click(Sender: TObject);
begin
  BUIC1.Checked := Not BUIC1.Checked;
end;

procedure TIRCMain.QuitButtonClick(Sender: TObject);
begin
  CloseMe;
end;

procedure TIRCMain.AboutClick(Sender: TObject);
begin
  Application.CreateForm(TAboutBox, AboutBox);
end;

procedure TIRCMain.SettingsClick(Sender: TObject);
begin
  ShowSettings;
end;

procedure TIRCMain.Shutdown(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := False;
  CloseMe;
end;

function Ints(S: String): Integer;
var
  I, Code: Integer;
begin
  Val(S, I, Code);
  If (Code <> 0) Then I := 0;
  Ints := I;
end;

procedure TIRCMain.CreateStatusClick(Sender: TObject);
begin
  NewWindowClick(nil);
end;

procedure TIRCMain.CloseAll1Click(Sender: TObject);
begin
  CloseAll;
end;

function LocalIP: String;
var
  LocalIPs: TStrings;
begin
  LocalIPs := WSocket.LocalIPList;
  LocalIP := LocalIPs[LocalIPs.Count - 1];
end;

procedure TIRCMain.UpdateInfo;
var
  DeHeap           : THeapStatus;
begin
  Settins.IP.Caption := LocalIP;
  Settins.HOST.Caption := WSocket.LocalHostName;
  Settins.TU.Caption := IntToStr(Reg.ReadInteger('Miscellaneous', 'Times_Used', 0));
  If (Reg.Target = itIniFile) Then
    Settins.SM.Caption := 'INI file'
  Else
    Settins.SM.Caption := 'Registry';

  DeHeap := GetHeapStatus;
  Settins.Size.Caption := IntToStr(DeHeap.TotalAllocated);
end;

procedure TIRCMain.ChangeStatus(S: String);
var
  I: Integer;
begin
//This is a nice effect, however kind of slow.
//Will fix later
//  For I := 1 To Length(S) Do
//  Begin
//    StatusBar1.SimpleText := Copy(S, 1, I);
//    Delay(5);
//  End;

//  For I := 255 DownTo 0 Do
//  Begin
//    StatusBar.Font.Color := RGB(I, I, I);
    StatusBar.SimpleText := S + '       [NEWS HERE]';
//    Application.ProcessMessages;
//    Sleep(1);
//  End;
end;

function GetColor(C: Integer): Integer;
begin
  Case C Mod 16 Of
    0: Result := RGB(255, 255, 255);
    1: Result := RGB(0, 0, 0);
    2: Result := RGB(0, 0, 127);
    3: Result := RGB(0, 147, 0);
    4: Result := RGB(255, 0, 0);
    5: Result := RGB(127, 0, 0);
    6: Result := RGB(156, 0, 156);
    7: Result := RGB(252, 127, 0);
    8: Result := RGB(255, 255, 0);
    9: Result := RGB(0, 252, 0);
    10: Result := RGB(0, 147, 147);
    11: Result := RGB(0, 255, 255);
    12: Result := RGB(0, 0, 252);
    13: Result := RGB(255, 0, 255);
    14: Result := RGB(127, 127, 127);
    15: Result := RGB(210, 210, 210);
  End;
end;

procedure TIRCMain.AddToServerList(S: String);
begin
  If (S = '') Then Exit;
  ServerList.Add(S);
  If (Pos(#255, S) <> 0) Then S := Copy(S, 1, Pos(#255, S) - 1);
  Settins.Server.Items.Add(S);
end;

procedure TIRCMain.AddTextTo(CH, S: String; P, T: Integer);
var
  I                : Integer;
  K                : String;
begin
  CH := UpStr(CH);
  For I := 0 to MDIChildCount-1 Do
  Begin
    K := StripIt(MDIChildren[I].Caption);
    If (UpStr(K) = CH) And ((MDIChildren[I] As TForm).Tag = T) Then
      (MDIChildren[I] as TChannel).AddText(S, P);
  End;
end;

procedure TIRCMain.AddNicksTo(CH: String; A1, A2, T: Integer);
var
  I                : Integer;
  K                : String;
begin
  CH := UpStr(CH);
  For I := 0 to MDIChildCount-1 Do
  Begin
    K := StripIt(MDIChildren[I].Caption);
    If (UpStr(K) = CH) And ((MDIChildren[I] As TForm).Tag = T) Then
      (MDIChildren[I] as TChannel).AddNicks(A1, A2);
  End;
end;

function TIRCMain.GetNicksFrom(CH: String; T: Integer): String;
var
  I                : Integer;
  K                : String;
begin
  CH := UpStr(CH);
  For I := 0 to MDIChildCount-1 Do
  Begin
    K := StripIt(MDIChildren[I].Caption);
    If (UpStr(K) = CH) And ((MDIChildren[I] As TForm).Tag = T) Then
      Result := (MDIChildren[I] as TChannel).GetNicks;
  End;
end;

procedure TIRCMain.AddCHMode(CH, M: String; T: Integer);
var
  I                : Integer;
  X                : Integer;
  K                : String;
  P                : String;
  Str              : String;
  Z                : TTokenizer;
begin
  If (M = '') Then
    Exit;
  P := '';
  CH := UpStr(CH);
  For I := 0 to MDIChildCount-1 Do
  Begin
    K := StripIt(MDIChildren[I].Caption);
    If (UpStr(K) = CH) And ((MDIChildren[I] As TForm).Tag = T) Then
    Begin
      Z := TTokenizer.Create;
      Z.InitTokenStr(MDIChildren[I].Caption);
      For X := 2 To Z.TokenCount-1 Do
        P := P + Z.Token[X] + ' ';
      Str := Z.Token[1];
      If (M[1] = '-') Then
        Delete(Str, Pos(M[2], Str), 1);
      If (M[1] = '+') Then
        Insert(Copy(M, 2, MaxInt), Str, 3);
      MDIChildren[I].Caption := K + ' ' + Str + ' ' + P;
      Z.Free;
    End;
  End;
end;

procedure TIRCMain.CloseAll;
var
  I, X: Integer;
  K: String;
begin
  X := 0;
  For I := 0 to MDIChildCount-1 Do
  Begin
    K := Copy(MDIChildren[I].Caption, 1, 1);
    If (K = '') Then Exit;
    If (K = '#') Or (K = '&') Then
      SelfPartChan(StripIt(MDIChildren[I].Caption), 32767);
    MDIChildren[I].Release;
  End;
end;

procedure TIRCMain.CloseSpecific(P: Integer);
var
  I: Integer;
begin
  For I := 0 to MDIChildCount-1 Do
    If (MDIChildren[I].Caption[1] = '#') Or (MDIChildren[I].Caption[1] = '&') Then
      If ((MDIChildren[I] as TChannel).Tag = P) Then
      Begin
        SelfPartChan(StripIt(MDIChildren[I].Caption), P);
        MDIChildren[I].Release;
      End;
end;

function TIRCMain.StripIt(S: String): String;
begin
  If (S[1] = '@') And (S <> '') Then Delete(S, 1, 1);
  If (S[1] = '+') And (S <> '') Then Delete(S, 1, 1);
  If (S[1] = ':') And (S <> '') Then Delete(S, 1, 1);
  If (Pos(' ', S) > 0) Then
    S := Copy(S, 1, Pos(' ', S) - 1);
  If (S[Length(S)] = ' ') Then
    Delete(S, Length(S), 1);
  Result := S;
End;

function TIRCMain.StripColor(S: String): String;
var
  UseMe            : Boolean;
  Str              : String;
begin
  Str := '';
  Repeat
    UseMe := True;
    Case S[1] Of
      IRCColor: Begin
                  UseMe := False;
//                  If (Copy(S, 2, 1) = '
                End;
      IRCBold:      UseMe := False;
      IRCReverse:   UseMe := False;
      IRCUnderline: UseMe := False;
    End;
    If (UseMe) Then
      Str := Str + S[1];
    Delete(S, 1, 1);
  Until (S = '');
  If (Str[Length(Str)] = ' ') Then
    Delete(Str, Length(Str), 1);
  Result := Str;
End;

procedure TIRCMain.SelfPartChan(S: String; P: Integer);
var
  I: Integer;
begin
  For I := 0 to MDIChildCount-1 Do
    If (MDIChildren[I].Caption[1] = 'S') Then
      If (P = (MDIChildren[I] as TStatus).Tag) Or (P = 32767) Then
        (MDIChildren[I] as TStatus).Send('PART ' + S + ' :' + Settins.PartText.Text);
end;

procedure TIRCMain.AddTopic(CH, T: String; N: Integer);
var
  I: Integer;
  K, P: String;
begin
  P := '';
  CH := UpStr(CH);
  For I := 0 to MDIChildCount-1 Do
  Begin
    K := StripIt(MDIChildren[I].Caption);
    If (UpStr(K) = CH) And ((MDIChildren[I] As TChannel).Tag = N) Then Begin
      K := MDIChildren[I].Caption;
      K := Copy(K, 1, Pos(']:', K) + 2);
      MDIChildren[I].Caption := K + StripColor(T);
    End;
  End;
end;

procedure TIRCMain.AddGuy(CH, G: String; T: Integer);
var
  I                : Integer;
  A1               : Integer;
  A2               : Integer;
  K                : String;
begin
  If (G = '') Then Exit;
  CH := UpStr(CH);
  If (G[1] = ':') Then Delete(G, 1, 1);
  For I := 0 to MDIChildCount-1 Do
  Begin
    K := StripIt(MDIChildren[I].Caption);
    If (UpStr(K) = CH) And ((MDIChildren[I] As TChannel).Tag = T) Then
    Begin
      (MDIChildren[I] As TChannel).NameList.Items.Add(G);
      K := GetNicksFrom(CH, T);
      A1 := StrToInt(Copy(K, 1, Pos(':', K) - 1));
      A2 := StrToInt(Copy(K, Pos(':', K) + 1, MaxInt));
      If (G[1] = '@') Then
        Inc(A1)
      Else
        Inc(A2);
      (MDIChildren[I] As TChannel).UpdateNicks(A1, A2);
    End;
  End;
end;

procedure TIRCMain.DelGuy(CH, G: String; T: Integer);
var
  I                : Integer;
  P                : Integer;
  A1               : Integer;
  A2               : Integer;
  K                : String;
begin
  If (G = '') Then Exit;
  CH := UpStr(CH);
  G := StripIt(G);
  For I := 0 to MDIChildCount-1 Do
  Begin
    K := StripIt(MDIChildren[I].Caption);
    If (UpStr(K) = CH) And ((MDIChildren[I] As TChannel).Tag = T) Then
      For P := 0 To (MDIChildren[I] as TChannel).NameList.Items.Count - 1 Do
      Begin
        If (StripIt((MDIChildren[I] as TChannel).NameList.Items[P]) = G) Then
        Begin
          (MDIChildren[I] as TChannel).NameList.Items.Delete(P);
          K := GetNicksFrom(CH, T);
          A1 := StrToInt(Copy(K, 1, Pos(':', K) - 1));
          A2 := StrToInt(Copy(K, Pos(':', K) + 1, MaxInt));
          If (G[1] = '@') Then
            Dec(A1)
          Else
            Dec(A2);
          (MDIChildren[I] As TChannel).UpdateNicks(A1, A2);
          Exit;
        End;
      End;
  End;
end;

procedure TIRCMain.AddTextAll(WH, G: String; C, T: Integer);
var
  I, P: Integer;
  K: String;
begin
  If (G = '') Then Exit;
  WH := StripIt(WH);
  If (G[1] = ':') Then Delete(G, 1, 1);

  For I := 0 To MDIChildCount-1 Do
  Begin
    K := StripIt(MDIChildren[I].Caption);
    If ((K[1] = '#') Or (K[1] = '&')) And ((MDIChildren[I] As TChannel).Tag = T) Then
      For P := 0 To (MDIChildren[I] as TChannel).NameList.Items.Count - 1 Do
        If (StripIt((MDIChildren[I] as TChannel).NameList.Items[P]) = WH) Then
          AddTextTo(K, G, C, T);
  End;
end;

procedure TIRCMain.Tile2Click(Sender: TObject);
begin
  Tile;
end;

procedure TIRCMain.Cascade2Click(Sender: TObject);
begin
  Cascade;
  ArrangeIcons;
end;

procedure TIRCMain.Arrange2Click(Sender: TObject);
begin
  ArrangeIcons;
end;

procedure TIRCMain.Maximize2Click(Sender: TObject);
begin
  MaximizeAll;
end;

procedure TIRCMain.CloseWindowsClick(Sender: TObject);
begin
  CloseAll;
end;

procedure TIRCMain.Contents2Click(Sender: TObject);
begin
  Application.CreateForm(TContents, Contents);
end;

procedure TIRCMain.Contents1Click(Sender: TObject);
begin
  Application.CreateForm(TContents, Contents);
end;

procedure TIRCMain.MaximizeAll;
var
  I: Integer;
begin
  For I := 0 to MDIChildCount-1 Do
    MDIChildren[I].WindowState := wsMaximized;
end;

procedure TIRCMain.Maximizeall1Click(Sender: TObject);
begin
  MaximizeAll;
end;

function TIRCMain.ValIt(S: String): Integer;
var
  I, Code: Integer;
begin
  Val(S, I, Code);
  If (Code = 0) Then
    Result := I
  Else
    Result := 0;
end;

procedure TIRCMain.DelGuyAll(G: String; T: Integer);
var
  I, P: Integer;
  K: String;
begin
  If (G = '') Then Exit;
  G := StripIt(G);
  For I := 0 to MDIChildCount-1 Do
  Begin
    K := StripIt(MDIChildren[I].Caption);
    If ((K[1] = '#') Or (K[1] = '&')) And ((MDIChildren[I] As TChannel).Tag = T) Then
      For P := 0 To (MDIChildren[I] as TChannel).NameList.Items.Count - 1 Do
        If (StripIt((MDIChildren[I] as TChannel).NameList.Items[P]) = G) Then Begin
          (MDIChildren[I] as TChannel).NameList.Items.Delete(P);
          Exit;
        End;
  End;
end;

procedure TIRCMain.ChangeNickAll(Old, New: String; T: Integer);
var
  I, P: Integer;
  K: String;
begin
  If (Old = '') Then Exit;
  Old := StripIt(Old);
  For I := 0 to MDIChildCount-1 Do
  Begin
    K := StripIt(MDIChildren[I].Caption);

    If (K[1] = '#') Or (K[1] = '&') Then
    Begin
      For P := 0 To (MDIChildren[I] As TChannel).NameList.Items.Count - 1 Do
        If (StripIt((MDIChildren[I] As TChannel).NameList.Items[P]) = Old) And ((MDIChildren[I] As TForm).Tag = T) Then Begin
          K := (MDIChildren[I] As TChannel).NameList.Items[P];
          If (Copy(K, 1, 1) = '@') Then K := '@'
          Else If (Copy(K, 1, 1) = '+') Then K := '+'
          Else K := '';
          (MDIChildren[I] As TChannel).NameList.Items[P] := K + New;
        End;
    End;
  End;
end;

function Ask(S: String): Boolean;
begin
  If ((MessageDlg(S, mtConfirmation, [mbYes, mbNo], 0)) = MrYes) Then
    Result := True
  Else
    Result := False;
end;

procedure TIRCMain.SendMsg(WH, S, M: String; P: Integer);
var
  I: Integer;
begin
  For I := 0 to MDIChildCount-1 Do
    If (MDIChildren[I].Caption[1] = 'S') Then
      If (P = (MDIChildren[I] as TForm).Tag) Then
        (MDIChildren[I] as TStatus).Msg(WH, S, M);
end;

procedure TIRCMain.SlashCmd(S, CH: String; P: Integer; FormMain: TRichEdit98);
var
  I: Integer;
begin
  For I := 0 to MDIChildCount-1 Do
    If (MDIChildren[I].Caption[1] = 'S') Then Begin
      If (P = (MDIChildren[I] as TStatus).Tag) Then
        (MDIChildren[I] as TStatus).SlashCmd(S, CH, P, FormMain);
      If (P - 10000 = (MDIChildren[I] as TStatus).Tag) Then
        (MDIChildren[I] as TStatus).SlashCmd(S, CH, P, FormMain);
    End;
end;

procedure TIRCMain.InstantConnect(S, P: String);
begin
  Status := TStatus.Create(IRCMain);
  Application.ProcessMessages;
  Status.DoConnect(S, P);
end;

function TIRCMain.IPToInt(S: String): LongWord;
var
  Z: TTokenizer;
  Res: LongInt;
begin
  Z := TTokenizer.Create;
  Z.TokenChr := '.';
  Z.InitTokenStr (S);
  Res := StrToInt(Z.Token[0]) Shl 24;
  Inc(Res, StrToInt(Z.Token[1]) Shl 16);
  Inc(Res, StrToInt(Z.Token[2]) Shl 8);
  Inc(Res, StrToInt(Z.Token[3]));
  Z.Free;
  Result := Res;
end;

procedure TIRCMain.AddMsgText(WHO, S: String; C, P: Integer);
var
  I: Integer;
  K: String;
begin
  WHO := UpStr(WHO);
  For I := 0 to MDIChildCount-1 Do
  Begin
    K := UpStr(MDIChildren[I].Caption);
    If (K = WHO) And ((MDIChildren[I] As TMsgBox).Tag = P) Then
      (MDIChildren[I] as TMsgBox).AddText(S, C);
  End;
end;

procedure TIRCMain.Aliases1Click(Sender: TObject);
begin
  Application.CreateForm(TFeatures, Features);
end;

procedure Delay(D: Integer);
var
  Start: Integer;
begin
  Start := GetTickCount;
  While GetTickCount - Start < D Do
    Application.ProcessMessages;
end;

procedure TIRCMain.AddActionAll(S: String; T: Integer);
var
  I, X: Integer;
  K, U: String;
begin
  For I := 0 To MDIChildCount-1 Do
  Begin
    K := StripIt(MDIChildren[I].Caption);
    If (MDIChildren[I].Tag = T) And (K[1] = 'S') Then
      For X := 0 To MDIChildCount-1 Do
        If (MDIChildren[X].Tag = T) Then Begin
          U := StripIt(MDIChildren[X].Caption);
          If (U[1] <> 'S') Then
            (MDIChildren[I] As TStatus).DoAction(U, S);
        End;
  End;
end;

procedure TIRCMain.Colors1Click(Sender: TObject);
begin
  Application.CreateForm(TColors, Colors);
end;

Function Encrypt(InText:String): String;
var
  R, I, CharVal: Integer;
  OutText: String;
begin
  InText := Trim(InText);
  If (InText = '') Then Exit;
  OutText := '';
  Randomize;
  R := Random(8) + 2;
  For I := 1 To Length(InText) Do
  Begin
    CharVal := Ord(InText[I]);
    CharVal := CharVal Xor (I Mod R);
    CharVal := CharVal Xor (I Xor 1);
    If (CharVal < 32) Or (CharVal > 126) Then CharVal := Ord(InText[I]);
    OutText := OutText + Chr(CharVal);
  End;
  Result := OutText + Chr(R + 32);
end;

Function Decrypt(InText: String): String;
var
  R, I, CharVal: Integer;
  OutText: String;
begin
  InText := Trim(InText);
  If (InText = '') Then Exit;
  OutText := '';
  R := Ord(InText[Length(InText)]) - 32;
  For I := 1 To Length(InText) - 1 Do
  Begin
    CharVal := Ord(InText[I]);
    CharVal := CharVal Xor (I Mod R);
    CharVal := CharVal Xor (I Xor 1);
    If (CharVal < 32) Or (CharVal > 126) Then CharVal := Ord(InText[I]);
    OutText := OutText + Chr(CharVal);
  End;
  Result := OutText;
end;

function TIRCMain.ReadStr(Sec, ID: String): String;
var
  Tmp: String;
begin
  Tmp := Reg.ReadString(Sec, ID, '');
  If (Settins.UseEnc.Checked) And (Tmp <> '') Then
    Tmp := Decrypt(Tmp);
  Result := Tmp;
end;

procedure TIRCMain.WriteStr(Sec, ID, Str: String);
begin
  If (Settins.UseEnc.Checked) Then Str := Encrypt(Str);
  Reg.WriteString(Sec, ID, Str);
end;

procedure TIRCMain.TabBar2Click(Sender: TObject);
begin
  TabBar2.Checked := Not TabBar2.Checked;
  TabPage.Visible := TabBar2.Checked;
end;

procedure TIRCMain.TabPageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  If (Button=mbRight) Then
  Begin
    SendMessage((Sender As TWinControl).Handle,wm_LButtonDown,mk_LButton,
                (((Y*$10000) And $ffff0000) Or (X And $ffff)));
    SendMessage((Sender As TWinControl).Handle,wm_LButtonUp,mk_LButton,
                (((Y*$10000) And $ffff0000) Or (X And $ffff)));
  End;
end;

procedure TIRCMain.PageControlPopup(Sender: TObject);
var
  Str             : String;
  Svr             : String;
  Prt             : String;
  Z               : TTokenizer;

begin
  Case (Sender as TMenuItem).Tag Of
  0: Begin
       If Assigned(TabPage.ActivePage) then
       Begin
         With (TabPage.ActivePage As TMyTabSheet).Form Do
         Begin
           Destroy;
         End;
       End;
     End;
  1: Begin
       Z := TTokenizer.Create;
       Z.InitTokenStr(((TabPage.ActivePage As TMyTabSheet).Form).Caption);
       Svr := Z.Token[5];
       Z.Free;
       If (Svr = '') Then Exit;
       Prt := Copy(Svr, Pos(':', Svr) + 1, MaxInt);
       Delete(Prt, Length(Prt), 1);
       Delete(Svr, Pos(':', Svr), MaxInt);
       Str := InputBox('Server name', 'Enter a name for ' + Svr, Svr);
       If (Str = '') Then Exit;
       AddToServerList(Str + #255 + Svr + #255 + Prt + #255);
       UpdateSvrBox(Settins.Server.Items.Count-1);
       SaveToRegistry;
     End;
  2: Begin
       Fonts.Execute;
       ((TabPage.ActivePage As TMyTabSheet).Form).Font.Name := Fonts.Font.Name;
       ((TabPage.ActivePage As TMyTabSheet).Form).Font.Size := Fonts.Font.Size;
       (((TabPage.ActivePage As TMyTabSheet).Form) As TStatus).Main.Font.Name := Fonts.Font.Name;
     End;
  End;
end;

procedure TIRCMain.UpdateSvrBox(Sel: Integer);
var
  I: Integer;
begin
  For I := 0 to MDIChildCount-1 Do
    If (MDIChildren[I].Caption[1] = 'S') Then
      (MDIChildren[I] as TStatus).UpdateSvrBox(Sel);
end;

procedure TIRCMain.FormCreate(Sender: TObject);
var
  Str              : String;
  Path             : Array[0..MAX_PATH] Of Char;
  X                : Integer;
  Y                : Integer;
  Label              TheEnd;

begin
  UpTime := 0;
//  WindowState := wsNormal;
  StartedNew := False;
  VER := 'v0.8';
  APPNAME := StripIt(Application.Title);
  X := 0;
  Str := APPNAME + VER;
  For Y := 1 To Length(Str) Do
    Inc(X, Ord(Str[Y]));
  If (X <> 698) Then
  Begin
    ShowMessage('Now that you''ve hacked the name, you''ve got to hack this.  :)');
    Application.Terminate;
    Halt(255);
  End;

  Str := '';
  Reg.IniFile := APPNAME + '.INI';
  Str := Reg.ReadString('Program', 'VERSION', '');

  If (Str <> '') And (Str = VER) Then
  Begin
    SelectSaveMethod(0);
    Goto TheEnd;
  End;

  If (Str = '') Then
  Begin
    SelectSaveMethod(1);
    Str := Reg.ReadString('Program', 'VERSION', '');
  End;

  If (Str <> '') And (Str = VER) Then
  Begin
    SelectSaveMethod(1);
    Goto TheEnd;
  End;

  If (Str = '') Or (Str <> VER) Then
  Begin
    Application.CreateForm(TWelcome, Welcome);
    Welcome.DeText.Caption := 'Welcome to ' + APPNAME;
    If (Str <> VER) And (Str <> '') Then
    Begin
      Welcome.DeText.Caption := Welcome.DeText.Caption + ', upgrade from ' + Str;
      Welcome.ExistingBtn.Enabled := True;
      Welcome.ExistingBtn.Checked := True;
      Welcome.ExistingBtn.SetFocus;
    End;
    Repeat
      Application.ProcessMessages;
    Until (WData <> '');
    Welcome.Free;
    If (WData = '3') Then
    Begin
      Application.Terminate;
      Halt(255);
    End;
    If (WData <> '2') Then
    Begin
      StartedNew := True;
      SelectSaveMethod(StrToInt(WData));
    End;
  End;

TheEnd:
  Y := Reg.ReadInteger('Options_2', 'Startup_Mode', 0);
  If (Y<>0) Then
  Begin
    Self.Width := 640;
    Self.Height := 480;
  End;

  Case Y Of
    0: WindowState := wsMaximized;
    1: WindowState := wsNormal;
    2: WindowState := wsMinimized;
  End;
end;

procedure TIRCMain.SelectSaveMethod(I: Byte);
begin
  Case I Of
    0: Self.Reg.Target := itIniFile;
    1: Self.Reg.Target := itRegistry;
  End;
end;

procedure TIRCMain.FormShow(Sender: TObject);
begin
  Activated := False;
end;

procedure TIRCMain.CheckForlatestversion1Click(Sender: TObject);
begin
  Application.CreateForm(TUpgradeCheck, UpgradeCheck);
end;

procedure TIRCMain.ToolButton5Click(Sender: TObject);
begin
  Application.CreateForm(TCHList, CHList);
end;

procedure TIRCMain.TabPageChange(Sender: TObject);
begin
  If Assigned(TabPage.ActivePage) then
  Begin
    With (TabPage.ActivePage As TMyTabSheet).Form Do
    Begin
      ShowWindow(Handle, sw_Show);
      WindowState := wsNormal;
      BringToFront;
    End;
  End;
end;

procedure TIRCMain.UpTimerTimer(Sender: TObject);
begin
  Inc(UpTime);
end;

procedure TIRCMain.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
var
  MousePoint       : TPoint;
  Wnd              : hWnd;
  Buf              : Array[0..255] Of Char;
  X                : Integer;
  Y                : Integer;
begin
  GetCursorPos(MousePoint);
  Wnd := WindowFromPoint(MousePoint);
  GetClassName(Wnd, @Buf, 255);
  If (Buf = 'TRichEdit98') Then
  Begin
    For X := 1 To 3 Do
    (FindControl(Wnd) As TRichEdit98).Perform(EM_SCROLL, SB_LINEUP, 0);
  End;
  If (Buf = 'TListBox') Then
    For X := 1 To 3 Do
    (FindControl(Wnd) As TListBox).Perform(EM_SCROLL, SB_LINEUP, 0);
{  If (Buf = 'TDDUEdit') Then
    (FindControl(Wnd) As TDDUEdit).Text := chr(72);
    status.prompt.
}
end;

procedure TIRCMain.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
var
  MousePoint       : TPoint;
  Wnd              : hWnd;
  Buf              : Array[0..255] Of Char;
  X                : Integer;
  Y                : Integer;
  Cnt              : Integer;
begin
  GetCursorPos(MousePoint);
  Wnd := WindowFromPoint(MousePoint);
  GetClassName(Wnd, @Buf, 255);
  If (Buf = 'TRichEdit98') Then
    For Cnt := 1 To 3 Do
    Begin
      X := GetScrollPos(Wnd, SB_VERT);
      Y := Abs((FindControl(Wnd) As TRichEdit98).Font.Height);
      X := X Div Y;
      Inc(X, ((FindControl(Wnd) As TRichEdit98).Height) Div Y);
      Y := (FindControl(Wnd) As TRichEdit98).Line;
      If (Y=X) Then
        (FindControl(Wnd) As TRichEdit98).Perform(EM_SCROLLCARET, SB_LINEDOWN, 0)
      Else
      If (Y > X) Then
        (FindControl(Wnd) As TRichEdit98).Perform(EM_SCROLL, SB_LINEDOWN, 0);
    End;
  If (Buf = 'TListBox') Then
    For X := 1 To 3 Do
    (FindControl(Wnd) As TListBox).Perform(EM_SCROLL, SB_LINEDOWN, 0);
end;

end.
