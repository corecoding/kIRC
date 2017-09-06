unit qStatus;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, RichEdit2, WSocket, ExtCtrls,
  Tokens, ImgList, ToolWin, Menus, DDUStandard, ElTree,
  DDUFancy, ComCtrls, lmdctrl, lmdobj;

type
  TStatus = class(TForm)
    WSocket1: TWSocket;
    PingTimer: TTimer;
    Button1: TButton;
    ToolBar1: TToolBar;
    TBConnect: TToolButton;
    ImageList1: TImageList;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    SDTimer: TTimer;
    RDTimer: TTimer;
    Main: TRichEdit98;
    AwayTimer: TTimer;
    Prompt: TDDUEdit;
    WSocket2: TWSocket;
    DDUPanel1: TDDUPanel;
    SDLight: TDDUShape;
    RDLight: TDDUShape;
    SvrBox: TComboBox;
    LagMeter: TLMDMeter;
    IdentSocket: TWSocket;
    procedure FormResize(Sender: TObject);
    procedure MainMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure WSocket1SessionClosed(Sender: TObject; Error: Word);
    procedure WSocket1SessionConnected(Sender: TObject; Error: Word);
    procedure WSocket1DataAvailable(Sender: TObject; Error: Word);
    procedure WSocket1DataSent(Sender: TObject; Error: Word);
    procedure AddStatus(A: String; J: Integer);
    procedure ParseLine(S: String);
    function ParseCode(S: String): String;
    procedure DoConnect(S, P: String);
    procedure Send(A: String);
    procedure PingTimerTimer(Sender: TObject);
    procedure CTCP(U: String; WH:String);
    procedure WSocket1SocksAuthState(Sender: TObject;
      AuthState: TSocksAuthState);
    procedure WSocket1SocksConnected(Sender: TObject; Error: Word);
    procedure WSocket1SocksError(Sender: TObject; Error: Integer;
      Msg: String);
    procedure WSocket1Error(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure TBConnectClick(Sender: TObject);
    procedure SlashCmd(Str: String; CH: String; P: Integer; FormMain: TRichEdit98);
    procedure ToolButton1Click(Sender: TObject);
    procedure SDTimerTimer(Sender: TObject);
    procedure RDTimerTimer(Sender: TObject);
    procedure SDBlink;
    procedure RDBlink;
    procedure Say(CH: String; S: String);
    procedure AddPromptLine(S: String);
    procedure PromptKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PromptKeyPress(Sender: TObject; var Key: Char);
    function MsgBoxExists(WHO: String; P: Integer): Boolean;
    procedure Msg(WH, S, M: String);
    procedure AwayTimerTimer(Sender: TObject);
    procedure ClearAwaySecs;
    procedure ReturnFromAway;    
    procedure DoAction(CH, Str: String);
    procedure CloseMe;
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DisConnect;
    procedure ChangeMode(S: String);
    procedure UpdateSvrBox(Sel: Integer);
    procedure SvrBoxClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    function AwayTime(Secs: Integer): String;
    procedure InsertStr(Str: String);
    procedure AddNotice(S: String; C: Integer);
    procedure WSocket1DnsLookupDone(Sender: TObject; Error: Word);
    procedure WSocket2DnsLookupDone(Sender: TObject; Error: Word);
    procedure EnableIdent;
    procedure SendIdent(S: String);
    procedure IdentSocketDataAvailable(Sender: TObject; Error: Word);
    procedure IdentSocketSessionAvailable(Sender: TObject; Error: Word);
    procedure IdentSocketError(Sender: TObject);
    procedure IdentSocketSessionClosed(Sender: TObject; Error: Word);
    procedure CloseIdent;
    procedure IdentSocketDataSent(Sender: TObject; Error: Word);
    procedure AddCtcpReply(A1, A2, A3: String);
    procedure MainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    DidWhois       : Boolean;
    DidWhowas      : Boolean;
    IdentTextBuf   : String;
    TotalUsers     : Cardinal;
    LinksString    : TStringList;
    DidLinks       : Boolean;
    procedure WMSysCommand(Var Msg : TWMSysCommand); Message WM_SysCommand;
  public
    Connected      : Byte;
    NICK           : String[30];
    PASS           : String[30];
    MODE           : String[30];
    SERVER         : String[100];
    InData         : String;
    PromptList     : Array[0..30] Of String;
    LineNumber     : Integer;
    AwaySecs       : Integer;
    UserAway       : Boolean;
    MySheet        : TTabSheet;
    BanListEntries : Integer;
  end;

var
  Status: TStatus;

implementation

uses qIRCMain, qSettins, qChannel, qMsgBox, qDcc, qDccAccept,
     qSupport, qChanList, qLinks, qSettings;

{$R *.DFM}

procedure TStatus.FormResize(Sender: TObject);
begin
  Self.Main.Height := Self.Prompt.Top - Self.ToolBar1.Height;
  Self.Main.Width := Self.Width - 6;
  Self.Main.SelStart := MaxInt;
  Self.Main.Perform(EM_SCROLLCARET, SB_LINEDOWN, 0);
end;

procedure TStatus.AddPromptLine(S: String);
var
  I: Integer;
begin
  For I := 29 DownTo 0 Do
    Self.PromptList[I + 1] := Self.PromptList[I];

  Self.PromptList[0] := S;
  Self.LineNumber := -1;
end;

procedure TStatus.MainMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  SelStart         : Integer;
begin
  If (Button = mbMiddle) Then
  Begin
    Self.Main.HideSelection := False;
    Self.Prompt.SetFocus;
    Exit;
  End;

  SelStart := Self.Prompt.SelStart;
  If (Self.Main.SelLength > 0) Then
  Begin
    Self.Main.CopyToClipboard;
    IRCMain.ChangeStatus('Copied ' + IntToStr(Self.Main.SelLength) + ' bytes to the clipboard.');
  End;

  Self.Main.SelStart := MaxInt;
  Self.Prompt.SetFocus;
  Self.Prompt.SelStart := SelStart;
end;

procedure TStatus.FormCreate(Sender: TObject);
var
  I, X: Integer;
  Done: Boolean;
begin
  InData := '';
  X := -1;
  Repeat
    Inc(X);
    Done := True;
    For I := 0 to IRCMain.MDIChildCount - 1 Do
      If (IRCMain.MDIChildren[I].Tag = X) Then
        Done := False;
  Until Done;
  Self.Caption := 'Status Window ' + IntToStr(X);
  Self.Tag := X;

  AwaySecs := 0;
  UserAway := False;
  DidWhois := False;
  DidLinks := False;

  Self.SDLight.Left := 0;
  Self.LagMeter.Visible := Settins.CheckLag.Checked;
  Self.SDLight.Visible := Settins.UseLights.Checked;
  Self.RDLight.Visible := Settins.UseLights.Checked;

  Self.LineNumber := -1;

  Self.Prompt.Height := (Self.Prompt.Font.Size * 2) + 1;
  Self.Prompt.Top := Self.Height - (Self.Toolbar1.Height + Self.Prompt.Height);
  Self.Main.Height := Self.Prompt.Top - Self.ToolBar1.Height;
  Self.Main.Width := Self.Width - 6;
  Self.Prompt.Width := Self.Width - 6;

  //Create tab in PageControl from Xepol
  MySheet := TMyTabSheet.Create(Self);
  (MySheet As TMyTabSheet).Form := Self;
  MySheet.PageControl := IRCMain.TabPage;
  MySheet.Caption := Caption;

  UpdateSvrBox(Settins.Server.ItemIndex);
end;

procedure TStatus.WMSysCommand(var Msg : TWMSysCommand);
begin
  If (Msg.CmdType = sc_minimize) Then
  Begin
    ShowWindow(Handle, sw_Hide);
    Msg.Result := 1;
  End
  Else
  Begin
    Inherited;
  End;
end;

procedure TStatus.WSocket1SessionConnected(Sender: TObject; Error: Word);
begin
//  If (Error <> 0) Then
//    ShowMessage(IntToStr(Error));
  TBConnect.Hint := 'Disconnect';
  Connected := 1;
  Self.Caption := 'Status ' + IntToStr(Self.Tag) + ' (Connecting)';
  TBConnect.ImageIndex := 1;
  If (PASS <> '') Then
    Send('PASS ' + PASS);
  Send('NICK ' + NICK);
  Send('USER ' + NICK + ' ' + LocalIP + ' ' + SERVER + ' :' + Settins.RealText.Text);
end;

procedure TStatus.WSocket1SessionClosed(Sender: TObject; Error: Word);
begin
  PingTimer.Enabled := False;
  AwayTimer.Enabled := False;
  TBConnect.Hint := 'Connect';
  TBConnect.ImageIndex := 0;
  AddNotice('Disconnected...', GetColor(10));
  If (Connected > 0) Then
    Self.Caption := 'Status Window ' + IntToStr(Self.Tag);
  Connected := 0;
  Self.LagMeter.PercentValue := 0;
  Self.LagMeter.Caption := '0s';
  CloseIdent;
end;

procedure TStatus.WSocket1DataAvailable(Sender: TObject; Error: Word);
var
  NewData: String;
begin
  RDBlink;

  NewData := WSocket1.ReceiveStr;
  InData := InData + NewData;

  While (Pos(#10, InData) > 0) Do Begin
    If Copy(InData, Pos(#10, Indata) - 1, 1) <> #10 Then
      InData := Copy(InData, 1, Pos(#10, InData) - 1) + #10 + Copy(InData, Pos(#10, InData), Length(InData));
    NewData := Copy(InData, 1, Pos(#10, InData) - 1);
    InData := Copy(InData, Pos(#10, InData) + Length(#10), Length(InData));
    ParseLine(NewData);
  End;
end;

procedure TStatus.WSocket1DataSent(Sender: TObject; Error: Word);
begin
  SDBlink;
end;

procedure TStatus.AddStatus(A: String; J: Integer);
begin
  AddTextToWindow(Self.Main, A, J);
end;


procedure TStatus.ParseLine(S: String);
var
  P                : Integer;
  Q                : Integer;
  Z                : TTokenizer;
  O                : TTokenizer;
  J                : String;
  K                : String;
  W                : String;
  M                : String;
  I                : Char;
  Show             : Boolean;
begin
  If (S = '') Then Exit;
  If (Copy(S, Length(S), 1) = #13) Then
    Delete(S, Length(S), 1);
  Show := True;

  If (Pos('PING', S) = 1) Then
  Begin
    Send('PONG ' + Copy(S, 6, MaxInt));
    If (Not Settins.HidePing.Checked) Then
      AddStatus('PING? PONG!', GetColor(6));
    S := '';
  End;
  If (Settins.UseRaw.Checked) Then
    AddStatus(S, 0);
  If (Pos('NOTICE', S) = 1) Then
  Begin
    Delete(S, 1, Pos(':', S));
    S := Copy(S, Pos(' ', S) + 1, MaxInt);
    AddStatus('!' + SERVER + '! ' + IRCColor + '1' + S, GetColor(4));
    If (Settins.BeepNotice.Checked) Then
      Beep;
    Exit;
  End;
  If (Pos('ERROR', S) = 1) Then
  Begin
    Insert('[', S, 1);
    Insert(']', S, 7);
    Delete(S, 9, 1);
    AddStatus(S, 0);
    Exit;
  End;

  {From FuzyLogic}
  Z := TTokenizer.Create;
  Z.InitTokenStr(S);

  J := Z.Token[1];
  K := '';
  For P := 3 To Z.TokenCount - 1 Do
  Begin
    W := Z.Token[P];
    If (W <> '') Then
      If (P = 4) And (W[1] = ':') Then
        Delete(W, 1, 1);
    If (P > 1) Then
      For Q := 1 To Length(W) Do
        If W[Q] = ' ' Then W[Q] := '!';
    K := K + W + ' ';
  End;
  If (Ints(J) <> 0) Then
    S := ParseCode(S);
  If (J = 'NOTICE') Then
  Begin
    If (Z.Token[2][1] = '#') Or (Z.Token[2][1] = '&') Then
    Begin
      If (Settins.BeepNotice.Checked) Then
        Beep;
      W := Z.Token[0];
      W := Copy(W, 2, Pos('!', W) - 2);
      If (W = '') Then
      Begin
        W := Z.Token[0];
        If (Copy(W, 1, 1) = ':') Then
          Delete(W, 1, 1);
      End;

      M := '';
      For P := 3 To Z.TokenCount - 1 Do
        M := M + Z.Token[P] + ' ';
      If (Copy(M, 1, 1) = ':') Then
        Delete(M, 1, 1);

      IRCMain.AddTextTo(Z.Token[2], '-' + W + '- ' + M, GetColor(5), Self.Tag);
      S := '';
    End;
    If (Z.Token[2][1] <> '#') And (Z.Token[2][1] <> '&') And
     (Z.Token[3][2] <> IRCAction) Then
    Begin
      If (Settins.BeepNotice.Checked) Then
        Beep;
      W := Z.Token[0];
      W := Copy(W, 2, Pos('!', W) - 2);
      If (W = '') Then
      Begin
        W := Z.Token[0];
        If (Copy(W, 1, 1) = ':') Then
          Delete(W, 1, 1);
      End;
      M := '';
      For P := 4 To Z.TokenCount - 1 Do
        M := M + Z.Token[P] + ' ';
      If (Copy(M, 1, 1) = ':') Then
        Delete(M, 1, 1);

      AddStatus('-' + W + '- ' + M, GetColor(3));
      S := '';
    End;
  End;
  If (J = 'MODE') And (Z.Token[2] = NICK) Then
  Begin
    S := Z.Token[3];
    Delete(S, 1, 1);
    ChangeMode(S);
    AddNotice('Personal mode change: ' + S + ' [Now: ' + MODE + ']', 0);
    M := '';
    O := TTokenizer.Create;
    O.InitTokenStr(Self.Caption);
    For P := 0 To O.TokenCount - 1 Do
    Begin
      M := M + O.Token[P] + ' ';
      If (P = 3) Then
      Begin
        Delete(M, Pos('[', M), MaxInt);
        M := M + '[' + MODE + '] ';
      End;
    End;
    O.Free;
    Self.Caption := M;
    S := '';
  End;
  If (J = 'MODE') And ((Z.Token[2][1] = '#') Or
   (Z.Token[2][1] = '&')) Then
  Begin
    P := 1;
    Q := 0;
    K := Z.Token[3];
    I := ' ';
    Repeat
      Case K[P] Of
        '+', '-': I := K[P];
        'o', 'v': Begin
                    M := K[P];
                    Inc(Q);
                  End;
      Else
        IRCMain.AddCHMode(Z.Token[2], I + K[P], Self.Tag);
        Inc(Q);
      End;

      S := Z.Token[Q + 3];

      If (M = 'o') Or (M = 'v') Then
        IRCMain.DelGuy(Z.Token[2], S, Self.Tag);

      If (I + M = '+o') Then
        IRCMain.AddGuy(Z.Token[2], '@' + S, Self.Tag);
      If (I + M = '-o') Then
        IRCMain.AddGuy(Z.Token[2], S, Self.Tag);
      If (I + M = '+v') Then
        IRCMain.AddGuy(Z.Token[2], '+' + S, Self.Tag);
      If (I + M = '-v') Then
        IRCMain.AddGuy(Z.Token[2], S, Self.Tag);

      Inc(P);
    Until (P > Length(K));

    W := Z.Token[0];
    W := Copy(W, 2, Pos('!', W) - 2);
    If (W = '') Then
    Begin
      W := Z.Token[0];
      If (Copy(W, 1, 1) = ':') Then
        Delete(W, 1, 1);
    End;
    M := '';
    For P := 4 To Z.TokenCount - 1 Do
      M := M + Z.Token[P] + ' ';
    If (M <> '') Then
    If (M[1] = ':') Then Delete(M, 1, 1);
    IRCMain.AddTextTo(Z.Token[2], Settins.Notice.Text + W + ' sets mode: ' + K + ' ' + M, GetColor(3), Self.Tag);
    Show := False;
  End;
  If (J = 'PONG') Then Begin
    K := Z.Token[3];
    Delete(K, 1, 1);
    If (Settins.RoundPing.Checked) Then
      P := (Trunc(un_ctime(DateTimeToStr(Now)) - StrToFloat(K)) + LagMeter.PercentValue) Div 2
    Else
      P := Trunc(un_ctime(DateTimeToStr(Now)) - StrToFloat(K));
    Self.LagMeter.PercentValue := P * 10;
    Self.LagMeter.Caption := AwayTime(P);
    Show := False;
  End;
  If (J = 'TOPIC') Then Begin
    W := Z.Token[0];
    W := Copy(W, 2, Pos('!', W) - 2);
    If (W = '') Then
    Begin
      W := Z.Token[0];
      If (Copy(W, 1, 1) = ':') Then
        Delete(W, 1, 1);
    End;
    K := '';
    For P := 3 To Z.TokenCount - 1 Do
      K := K + Z.Token[P] + ' ';
    If (K[1] = ':') Then Delete(K, 1, 1);
    IRCMain.AddTopic(Z.Token[2], K, Self.Tag);
    IRCMain.AddTextTo(Z.Token[2], Settins.Notice.Text + W + ' has changed topic to: ' + K, 0, Self.Tag);
    Show := False;
  End;
  If (J = 'QUIT') Then Begin
    K := '';
    For P := 2 To Z.TokenCount - 1 Do
      K := K + Z.Token[P] + ' ';
    If (K[1] = ':') Then Delete(K, 1, 1);
    Delete(K, Length(K), 1);

    W := Z.Token[0];
    W := Copy(W, 2, Pos('!', W) - 2);
    M := Z.Token[0];
    Delete(M, 1, Pos('!', M));
    IRCMain.AddTextAll(W, Settins.Notice.Text + W + ' [' + M + '] has quit (' + K + ')', GetColor(10), Self.Tag);
    IRCMain.DelGuyAll(W, Self.Tag);
    Show := False;
  End;
  If (J = 'PART') Then Begin
    K := Z.Token[2];
    If (K[1] = ':') Then Delete(K, 1, 1);
    W := Z.Token[0];
    W := Copy(W, 2, Pos('!', W) - 2);
    If (W = NICK) Then Begin
    End;
    IRCMain.DelGuy(K, W, Self.Tag);
    M := Z.Token[0];
    Delete(M, 1, Pos('!', M));
    W := Settins.Notice.Text + W + ' [' + M + '] has left ' + K;
    If (Z.TokenCount > 2) Then
      For P := 3 To Z.TokenCount - 1 Do Begin
        M := Z.Token[P];
        If (Copy(M, 1, 1) = ':') Then Delete(M, 1, 1);
        If (P = 3) Then M := '[' + M;
        If (P = Z.TokenCount - 1) Then M := M + ']';
        W := W + ' ' + M;
      End;
    IRCMain.AddTextTo(K, W, GetColor(10), Self.Tag);
    Show := False;
  End;
  If (J = 'JOIN') Then Begin
    K := Z.Token[2];
    If (K[1] = ':') Then Delete(K, 1, 1);
    W := Z.Token[0];
    W := Copy(W, 2, Pos('!', W) - 2);
    If (W = NICK) Then Begin
      Application.CreateForm(TChannel, Channel);
      Channel.Topic(K + ' [+]: No Topic');
      Send('MODE ' + K);
      Channel.Tag := Self.Tag;
    End Else
      IRCMain.AddGuy(K, W, Self.Tag);
    M := Z.Token[0];
    Delete(M, 1, Pos('!', M));
    IRCMain.AddTextTo(K, Settins.Notice.Text + W + ' [' + M + '] has joined ' + K, GetColor(10), Self.Tag);
    Show := False;
  End;
  If (J = 'KICK') Then
  Begin
    W := Z.Token[0];
    W := Copy(W, 2, Pos('!', W) - 2);
    If (W = '') Then
    Begin
      W := Z.Token[0];
      If (Copy(W, 1, 1) = ':') Then
        Delete(W, 1, 1);
    End;
    K := '';
    For P := 4 To Z.TokenCount - 1 Do
      K := K + Z.Token[P] + ' ';
    Delete(K, 1, 1);
    Delete(K, Length(K), 1);
    IRCMain.AddTextTo(Z.Token[2], Settins.Notice.Text + W + ' has kicked ' + Z.Token[3] + ' (' + K + ')', RGB(204, 53, 163), Self.Tag);
    IRCMain.DelGuy(Z.Token[2], Z.Token[3], Self.Tag);
    S := '';
  End;
  If (J = 'NICK') Then
  Begin
    K := Z.Token[2];
    Delete(K, 1, 1);
    W := Z.Token[0];
    W := Copy(W, 2, Pos('!', W) - 2);
    If (W = NICK) Then Begin
      J := '';
      O := TTokenizer.Create;
      O.InitTokenStr(Self.Caption);
      For P := 0 To O.TokenCount - 1 Do
        If (P <> 2) Then
          J := J + O.Token[P] + ' '
        Else
          J := J + '(' + K + ' ';
      Self.Caption := J;

      O.Free;
      NICK := K;
      AddNotice('Your new nick: ' + K, 0);
    End;
    IRCMain.AddTextAll(W, Settins.Notice.Text + W + ' changes his nick to ' + K, 0, Self.Tag);
    IRCMain.ChangeNickAll(W, K, Self.Tag);
    Show := False;
  End;
  If (J = 'WALLOPS') Then
  Begin
    W := Z.Token[0];
    W := Copy(W, 2, Pos('!', W) - 2);
    If (W = '') Then
    Begin
      W := Z.Token[0];
      If (Copy(W, 1, 1) = ':') Then
        Delete(W, 1, 1);
    End;
    K := '';
    For P := 2 To Z.TokenCount - 1 Do
      K := K + Z.Token[P] + ' ';
    AddNotice('[WALLOP/' + W + '] ' + K, 0);
  End;
  If (J = 'PRIVMSG') Then
  Begin
    If (Pos('ACTION', Z.Token[3]) = 3) Then Begin
      K := '';
      W := Z.Token[0];
      W := Copy(W, 2, Pos('!', W) - 2);
      If (W = '') Then
      Begin
        W := Z.Token[0];
        If (Copy(W, 1, 1) = ':') Then
          Delete(W, 1, 1);
      End;
      W := '* ' + W + ' ';
      For P := 4 To Z.TokenCount - 1 Do
        K := K + Z.Token[P] + ' ';
      Delete(K, Length(K) - 1, 1);
      IRCMain.AddTextTo(Z.Token[2], W + K, GetColor(5), Self.Tag);
      Show := False;
    End
    Else
    If ((Z.Token[2][1] = '#') Or (Z.Token[2][1] = '&')) And
     (Z.Token[3][2] <> IRCAction) Then
    Begin
      K := '';
      W := Z.Token[0];
      W := Copy(W, 2, Pos('!', W) - 2);
      If (W = '') Then
      Begin
        W := Z.Token[0];
        If (Copy(W, 1, 1) = ':') Then
          Delete(W, 1, 1);
      End;
      W := '<' + W + '> ';
      For P := 3 To Z.TokenCount - 1 Do
        K := K + Z.Token[P] + ' ';
      Delete(K, 1, 1);
      Q := 0;
      If (Pos(NICK, K) <> 0) And (Settins.NickHighlight.Checked) Then
        Q := GetColor(3);
      IRCMain.AddTextTo(Z.Token[2], W + K, Q, Self.Tag);
    End;
    If ((Z.Token[2][1] <> '#') And (Z.Token[2][1] <> '&'))
     And (Z.Token[3][2] <> '') Then
    Begin
      W := Z.Token[0];
      W := Copy(W, 2, Pos('!', W) - 2);
      If (W = '') Then
      Begin
        W := Z.Token[0];
        If (Copy(W, 1, 1) = ':') Then
          Delete(W, 1, 1);
      End;
      M := #160 + ' ' + W + ' [' + Copy(Z.Token[0], Pos('!', Z.Token[0]) + 1, Length(Z.Token[0]) - Length(W)) + ']';
      If (Not MsgBoxExists(M, Self.Tag)) Then Begin
        Application.CreateForm(TMsgBox, MsgBox);
        MsgBox.Caption := M;
        MsgBox.Tag := Self.Tag;
      End;
      K := '';
      For P := 3 To Z.TokenCount - 1 Do
        K := K + Z.Token[P] + ' ';
      Delete(K, 1, 1);
      K := '<' + W + '> ' + K;
      IRCMain.AddMsgText(M, K, 0, Self.Tag);
    End;
    If (Pos(IRCAction, Z.Token[3]) = 2) And (Show) Then Begin
      W := Z.Token[0];
      W := Copy(W, 2, Pos('!', W) - 2);
      If (W = '') Then
      Begin
        W := Z.Token[0];
        If (Copy(W, 1, 1) = ':') Then
          Delete(W, 1, 1);
      End;
      K := Z.Token[3];
      If (K <> '') Then Begin
        Delete(K, 1, 2);
        If (K[Length(K)] = IRCAction) Then
          Delete(K, Length(K), 1);
      End;
      AddStatus(Settins.Notice.Text + K + ' request from ' + W, GetColor(12));
    End;
    If (Pos('PING', Z.Token[3]) = 3) Then Begin
      W := Z.Token[0];
      W := Copy(W, 2, Pos('!', W) - 2);
      Send('NOTICE ' + W + ' ' + Z.Token[3] + ' ' + Z.Token[4]);
    End;
    If (Pos('TIME', Z.Token[3]) = 3) Then Begin
      W := Z.Token[0];
      W := Copy(W, 2, Pos('!', W) - 2);
      Send('NOTICE ' + W + ' ' + Z.Token[3] + ' ' + DateTimeToStr(Now) + IRCAction);
    End;
    If (Pos('VERSION', Z.Token[3]) = 3) Then Begin
      W := Z.Token[0];
      W := Copy(W, 2, Pos('!', W) - 2);
      K := Z.Token[3];
      K := Copy(K, 1, Length(K) - 1) + ' ';
      Send('NOTICE ' + W + ' ' + K + Settins.VersText.Text + IRCAction);
    End;
    If (Pos('DCC', Z.Token[3]) = 3) Then Begin
      If (Pos('SEND', Z.Token[4]) = 1) Then Begin
        Application.CreateForm(TDccAccept, DccAccept);
        W := Z.Token[0];
        Delete(W, 1, 1);
        P := Pos('!', W);
        W := Copy(W, 1, P - 1);
        M := W + ' [' + Copy(Z.Token[0], Pos('!', Z.Token[0]) + 1, Length(Z.Token[0]) - Length(W)) + ']';
        DccAccept.From.Caption := 'From: ' + M;
        DccAccept.Filename.Caption := 'Filename: ' + Z.Token[5];
        DccAccept.Size.Caption := 'Size: ' + Copy(Z.Token[8], 1, Length(Z.Token[8]) - 1);
        DccAccept.Tag := StrToInt(Z.Token[7]);
      End;
    End;
    Show := False;
  End;

  If (J = 'NOTICE') Then Begin
    If (Pos('PING', Z.Token[3]) <> 0) Then Begin
      W := Z.Token[0];
      W := Copy(W, 2, Pos('!', W) - 2);
      K := Z.Token[4];
      K := Copy(K, 1, Length(K) - 1);
      P := Trunc(un_ctime(DateTimeToStr(Now)) - StrToFloat(K));
//      M := Format('%3.14f', [un_ctime(DateTimeToStr(Now)) - StrToFloat(K)]);
      If (P < 60) Then
      Begin
        M := FloatToStr(un_ctime(DateTimeToStr(Now)) - StrToFloat(K));
        Delete(M, Pos('.', M) + 4, MaxInt);
      End
      Else
      Begin
        M := AwayTime(P);
      End;
      AddCtcpReply('PING', W, M + ' secs');
      Show := False;
    End;
    If (Pos(IRCAction, Z.Token[3]) = 2) And (Show) Then Begin
      W := Z.Token[0];
      W := Copy(W, 2, Pos('!', W) - 2);
      K := Z.Token[3];
      If (K <> '') Then Begin
        Delete(K, 1, 2);
        If (K[Length(K)] = IRCAction) Then
          Delete(K, Length(K), 1);
      End;
      M := '';
      For P := 4 To Z.TokenCount - 1 Do
        M := M + Z.Token[P] + ' ';
      If (Length(M) > 2) Then Begin
        Delete(M, Length(M) - 1, 2);
      End;
      AddCtcpReply(K, W, M);
      Show := False;
    End;
  End;

{
  If (Show) and (K <> '') Then Begin
    If (K[1] = ':') Then Delete(K, 1, 1);
    AddStatus(K, 0);
  End;
}

  If (Show) And (S <> '') Then
  Begin
    If (Not Settins.UseRaw.Checked) Then
    Begin
      P := Pos(' ', S);
      Delete(S, 1, P);
      P := Pos(' ', S);
      Delete(S, 1, P);
      P := Pos(' ', S);
      Delete(S, 1, P);
      If (Copy(S, 1, 1) = ':') Then
        Delete(S, 1, 1);
      AddStatus(S, 0);
    End;
  End;

  Z.Free;
end;

function TStatus.ParseCode(S: String): String;
var
  Z                : TTokenizer;
  P                : Real;
  I                : Integer;
  B1               : String;
  B2               : String;
  K                : String;
  W                : String;
  CHListItem       : TElTreeItem;
begin
  Result := '';

  Z := TTokenizer.Create;
  Z.InitTokenStr(S);

  Case Ints(Z.Token[1]) Of
    001: Begin
           NICK := Z.Token[Z.TokenCount - 1];
           I := Pos('!', NICK);
           If (I <> 0) Then NICK := Copy(NICK, 1, I - 1);
           Result := S;
         End;
    004: Begin
           Result := S;
           SERVER := Z.Token[3];
         End;
{******* 200 TRACELINK *******}
{******* 201 TRY. *******}
{******* 202 *******}
{******* 203 *******}
{******* 204 *******}
{******* 205 *******}
{******* 206 *******}
{******* 208 *******}
{******* 211 STATS LINK INFO *******}
{******* 212 STATS COMMANDS *******}
{******* 213 STATS *******}
{******* 214 STATS *******}
{******* 215 STATS *******}
{******* 216 STATS *******}
{******* 218 STATS *******}
    219: Begin
           AddNotice('End of /STATS report.', 0);
         End;
{******* 221 UMODEIS *******}
{******* 241 STATS *******}
{******* 242 STATS *******}
{******* 243 STATS *******}
{******* 244 STATS *******}
    251: Begin
           TotalUsers := StrToInt(Z.Token[5]) +
            StrToInt(Z.Token[8]);
           AddStatus('[total users on irc(' + IRCBold +
            IntToStr(TotalUsers) + IRCBold + ')] ' + IRCUnderline + '100' + IRCUnderline + '%', 0);
           P := (StrToInt(Z.Token[5]) / TotalUsers) * 100;
           AddStatus('[normal users on irc(' + IRCBold +
            Z.Token[5] + IRCBold + ')] ' + IRCUnderline + Format('%3.2f', [P]) + IRCUnderline + '%', 0);
           P := (StrToInt(Z.Token[8]) / TotalUsers) * 100;
           AddStatus('[invisible users on irc(' + IRCBold +
            Z.Token[8] + IRCBold + ')] ' + IRCUnderline + Format('%3.2f', [P]) + IRCUnderline + '%', 0);
           I := TotalUsers Div StrToInt(Z.Token[11]);
           B1 := Z.Token[11];
           AddStatus('[total servers on the network(' + IRCBold +
            B1 + IRCBold + ')] (avg. ' + IRCUnderline + IntToStr(I)
             + IRCUnderline + ' user(s) per server)', 0);
           If (B1 = '1') Then
             AddNotice('This server is most likely split from the rest!', GetColor(4));
         End;
    252: Begin
           P := (StrToInt(Z.Token[3]) / TotalUsers) * 100;
           AddStatus('[ircops on irc(' + IRCBold + Z.Token[3]
            + IRCBold + ')] ' + IRCUnderline + Format('%3.2f', [P]) + IRCUnderline + '%', 0);
         End;
    253: Begin
           P := (StrToInt(Z.Token[3]) / TotalUsers) * 100;
           AddStatus('[unknown connections(' + IRCBold + Z.Token[3]
            + IRCBold + ')] ' + IRCUnderline + Format('%3.2f', [P]) + IRCUnderline + '%', 0);
         End;
    254: Begin
           I := TotalUsers Div StrToInt(Z.Token[3]);
           AddStatus('[total channels created(' + IRCBold + Z.Token[3]
            + IRCBold + ')] (avg. ' + IRCUnderline + IntToStr(I) + IRCUnderline + ' user(s) ' +
             'per channel)', 0);
         End;
    255: Begin
           P := (StrToInt(Z.Token[5]) / TotalUsers) * 100;
           AddStatus('[users on this server(' + IRCBold + Z.Token[5]
            + IRCBold + ')] ' + IRCUnderline + Format('%3.2f', [P]) + IRCUnderline + '%', 0);
         End;
    256: Begin
           AddNotice('Administrative info for ' + Z.Token[3] + '.', 0);
         End;
{******* 257 *******}
{******* 258 *******}
{******* 259 *******}
{******* 261 *******}
{******* 300 *******}
    301: Begin
           K := '';
           For I := 4 To Z.TokenCount - 1 Do
             K := K + Z.Token[I] + ' ';
           Delete(K, 1, 1);
           Delete(K, Length(K), 1);
           AddStatus('  away....: ' + K, 0);
         End;
{******* 302 USERHOST *******}
{******* 303 ISON *******}
    305: Begin
//           AddNotice('You are no longer marked as being away.', 0);
           K := '';
           For I := 3 To Z.TokenCount - 1 Do
             K := K + Z.Token[I] + ' ';
           Delete(K, 1, 1);
           AddNotice(K, 0);
           AwaySecs := 0;
         End;
    306: Begin
//           AddNotice('You have been marked as being away.', 0);
           K := '';
           For I := 3 To Z.TokenCount - 1 Do
             K := K + Z.Token[I] + ' ';
           Delete(K, 1, 1);
           AddNotice(K, 0);
         End;
    311: Begin
           AddStatus('[-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-]', 0);
           DidWhois := True;
           K := '  ircname.: ' + Z.Token[3] + ' [' + Z.Token[4] + '@' + Z.Token[5] + ']';
           AddStatus(K, 0);
           K := '';
           For I := 7 To Z.TokenCount - 1 Do
             K := K + Z.Token[I] + ' ';
           Delete(K, 1, 1);
           Delete(K, Length(K), 1);
           AddStatus('  realname: ' + K, 0);
         End;
    312: Begin
           K := '';
           For I := 5 To Z.TokenCount - 1 Do
             K := K + Z.Token[I] + ' ';
           Delete(K, 1, 1);
           Delete(K, Length(K), 1);
           AddStatus('  server..: ' + Z.Token[4] + ' (' + K + ')', 0);
         End;
    313: Begin
           K := '';
           For I := 4 To Z.TokenCount - 1 Do
             K := K + Z.Token[I] + ' ';
           Delete(K, 1, 1);
           Delete(K, Length(K), 1);
           AddStatus('  status..: ' + K, 0);
         End;
    314: Begin
           AddStatus('[-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-]', 0);
           DidWhowas := True;
           K := '  ircname.: ' + Z.Token[3] + ' [' + Z.Token[4] + '@' + Z.Token[5] + ']';
           AddStatus(K, 0);
           K := '';
           For I := 7 To Z.TokenCount - 1 Do
             K := K + Z.Token[I] + ' ';
           Delete(K, 1, 1);
           Delete(K, Length(K), 1);
           AddStatus('  realname: ' + K, 0);
         End;
    369: Begin
           If (DidWhowas) Then
           Begin
             AddStatus('[-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-]', 0);
             DidWhois := False;
           End;
         End;
    315: Begin
           AddNotice('End of /WHO list.', 0);
         End;
    317: Begin
           K := '(' + CTime(StrToFloat(Z.Token[5])) + ')';
           AddStatus('  idle....: (' + AwayTime(StrToInt(Z.Token[4])) +  ')', 0);
           AddStatus('  signon..: ' + K, 0);
         End;
    318: Begin
           If (DidWhois) Then
           Begin
             AddStatus('[-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-]', 0);
             DidWhois := False;
           End;
         End;
    319: Begin
           K := '';
           For I := 4 To Z.TokenCount - 1 Do
             K := K + Z.Token[I] + ' ';
           Delete(K, 1, 1);
           Delete(K, Length(K), 1);
           W := '  channel : ' + K;
           If (Z.TokenCount - 4 > 1) Then
             W[10] := 's';
           AddStatus(W, 0);
         End;
    321: Begin
           Application.CreateForm(TCHList, CHList);
           CHList.Tag := Self.Tag;
           K := Z.Token[0];
           Delete(K, 1, 1);
           CHList.Caption := 'Channel listing for ' + K;
           CHList.Status.Caption := 'Obtaining channels';
         End;
    322: Begin
           K := '';
           For I := 5 To Z.TokenCount - 1 Do
             K := K + Z.Token[I] + ' ';
           Delete(K, 1, 1);
           CHListItem := CHList.List.Items.AddItem(CHListItem);
           CHListItem.Text := Z.Token[3];
           CHListItem.ColumnText.Add(Z.Token[4]);
           CHListItem.ColumnText.Add(K);
           Inc(CHList.UserCount, StrToInt(Z.Token[4]));
           I := CHList.List.Items.Count;
           K := IntToStr(I) + ' channel';
           If (I > 1) Then K := K + 's';
           CHList.Status.Caption := K;
           Application.ProcessMessages;
         End;
    323: Begin
           CHList.Close.Enabled := True;
//           CHList.Status.Caption := 'Completed!';           
         End;
    324: IRCMain.AddCHMode(Z.Token[3], Z.Token[4], Self.Tag);
    329: IRCMain.AddTextTo(Z.Token[3], Settins.Notice.Text + 'Channel created on ' + CTime(StrToFloat(Z.Token[4])), GetColor(3), Self.Tag);
    331: Begin
           IRCMain.AddTextTo(Z.Token[3], Settins.Notice.Text + 'No topic is set on ' + Z.Token[3], 0, Self.Tag);
         End;
    332: Begin
           K := '';
           For I := 4 To Z.TokenCount - 1 Do
             K := K + Z.Token[I] + ' ';
           Delete(K, 1, 1);
           IRCMain.AddTopic(Z.Token[3], K, Self.Tag);
           IRCMain.AddTextTo(Z.Token[3], Settins.Notice.Text + 'Topic: ' + K, 0, Self.Tag);
         End;
    333: Begin
           IRCMain.AddTextTo(Z.Token[3], Settins.Notice.Text + 'Topic set by ' + Z.Token[4] + ' on ' + CTime(StrToFloat(Z.Token[5])), GetColor(3), Self.Tag);
         End;
{******* 341 INVITING A USER *******}
{******* 342 SUMMONING USER *******}
{******* 351 SERVER VERSION DETAILS *******}
{******* 352 WHOREPLY *******}
    353: Begin
           For I := 5 To Z.TokenCount - 1 Do
           Begin
             IRCMain.AddGuy(Z.Token[4], Z.Token[I], Self.Tag);
           End;
         End;
    364: Begin
           If (Not DidLinks) Then
           Begin
             DidLinks := True;
             LinksString := TStringList.Create;
             AddNotice('Receiving links list...', 0);
           End;
           K := '';
           For I := 2 To Z.TokenCount - 1 Do
             K := K + Z.Token[I] + ' ';
//           LinksString.Add(Z.Token[3] + Z.Token[5] + '!' + K);
           LinksString.Add(S);
         End;
    365: Begin
           AddNotice('End of /LINKS list.', 0);
           Application.CreateForm(TLinks, Links);
           Links.MakeTree(LinksString);
           DidLinks := False;
           LinksString.Destroy;
         End;
    366: Begin
           K := IRCMain.GetNicksFrom(Z.Token[3], Self.Tag);
           B1 := Copy(K, 1, Pos(':', K) - 1);
           B2 := Copy(K, Pos(':', K) + 1, MaxInt);
           W := 'There are ' + B1 + ' chops, and ' +
            B2 + ' nops (' + IntToStr(StrToInt(B1) + StrToInt(B2)) + ' total)';
           IRCMain.AddTextTo(Z.Token[3], Settins.Notice.Text + W, GetColor(1), Self.Tag);
           If ((StrToInt(B1) + StrToInt(B2)) = 1) And (Settins.UserLevel.ItemIndex = 0) Then
             IRCMain.AddTextTo(Z.Token[3], Settins.Notice.Text + 'You have just created channel: ' + Z.Token[3] + '.', RGB(34, 132, 100), Self.Tag);
           AddNotice('End of names list on ' + Z.Token[3] + '.', 0);
         End;
    367: Begin
           If (BanListEntries = 0) Then
           Begin
             AddStatus('[-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-]', 0);
           End;
           Inc(BanListEntries);
           AddStatus('WHO: ' + Z.Token[4] + ', BY: ' + Z.Token[5] + ', ON: ' + CTime(StrToFloat(Z.Token[6])), 0);
         End;
    368: Begin
           If (BanListEntries <> 0) Then
           Begin
             AddStatus('[-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-]', 0);
           End
           Else
           Begin
             AddNotice('No bans on ' + Z.Token[3] + '.', 0);
           End;
         End;
{******* 369 End of WHOWAS *******}
{******* 371 INFO LIST *******}
{******* 372 MOTD TEXT (NOT NEEDED) *******}
    374: Begin
           AddNotice('End of /INFO list.', 0);
         End;
{******* 375 MOTD START *******}
    376: Begin
           Connected := 2;
           MODE := '+';
           Self.Caption := 'Status ' + IntToStr(Self.Tag) + ' (' + NICK + ' [' + MODE + '] on ' + SERVER + ':' + Trim(WSocket1.Port) + ')';
           Beep;
           PingTimer.Interval := StrToInt(Settins.LagSecs.Text) * 1000;
           PingTimer.Enabled := Settins.CheckLag.Checked;
           AwayTimer.Enabled := Settins.UseAway.Checked;
           Result := S;
         End;
    381: Begin
           AddNotice('You are now an IRC operator.', 0);
         End;
    382: Begin
           AddNotice('Rehashing ' + Z.Token[3] + '.', 0);
         End;
    391: Begin
           K := '';
           For I := 4 To Z.TokenCount - 1 Do
             K := K + Z.Token[I] + ' ';
           Delete(K, 1, 1);
           AddNotice('[TIME] ' + K, 0);
         End;
{******* 392 USERS START *******}
{******* 393 USERS LIST *******}
    394: Begin
           AddNotice('End of /USERS list.', 0);
         End;
    395: Begin
           AddNotice('Nobody is logged in.', 0);
         End;
    401: Begin
           AddNotice('No such nick: ' + Z.Token[3], 0);
         End;
    402: Begin
           AddNotice('No such server: ' + Z.Token[3] + '.', 0);
         End;
    403: Begin
           AddNotice('No such channel: ' + Z.Token[3] + '.', 0);
         End;
    404: Begin
           AddNotice('Cannot send to channel ' + Z.Token[3] + '.', 0);
         End;
    405: Begin
           AddNotice('Cannot join ' + Z.Token[3] + ', you are on too many channels.', 0);
         End;
    406: Begin
           AddNotice('There was no such nick by the name of ' + Z.Token[3] + '.', 0);
         End;
    407: Begin
           AddNotice('Duplicate recipients, no message delivered to ' + Z.Token[3] + '.', 0);
         End;
{******* 408 *******}
    409: Begin
           AddNotice('No origin specified.', 0);
         End;
    411: Begin
           AddNotice('No recipient given (' + Z.Token[3] + ')', 0);
         End;
    412: Begin
           AddNotice('No text to send.', 0);
         End;
{******* 413 *******}
{******* 414 *******}
    421: Begin
           AddNotice('Unknown command: ' + Z.Token[3], 0);
         End;
    422: Begin
           AddNotice('MOTD File is missing.', 0);
         End;
    423: Begin
           W := Z.Token[0];
           Delete(W, 1, 1);
           AddNotice('No administrative info available for ' + W, 0);
         End;
{******* 424 *******}
    431: Begin
           AddNotice('No nickname given.', 0);
         End;
    432: Begin
           AddNotice('Erroneous nick: ' + Z.Token[3], 0);
         End;
    433: Begin
           If (Connected = 1) Then
           Begin
             Self.Prompt.Text := '/NICK ' + Settins.AltNickText.Text;
             Self.Prompt.SelStart := Length(Self.Prompt.Text);
           End;
           AddNotice('Sorry, "' + Z.Token[3] + '" is in use.', 0);
         End;
    436: Begin
           AddNotice('Nickname collision KILL for ' + Z.Token[3], 0);
         End;
{******* 441 *******}
    442: Begin
           AddNotice('You''re not on ' + Z.Token[3] + '.', 0);
         End;
{******* 443 *******}
    444: Begin
           AddNotice(Z.Token[3] + ' is not logged in for a summons.', 0);
         End;
    445: Begin
           AddNotice('SUMMON has been disabled.', 0);
         End;
    446: Begin
           AddNotice('USERS has been disabled.', 0);
         End;
    451: Begin
           AddNotice('You have not registered!', 0);
         End;
    461: Begin
           AddNotice(Z.Token[3] + ' needs more parameters.', 0);
         End;
    462: Begin
           AddNotice('You may not register.', 0);
         End;
    463: Begin
           AddNotice('Your host isn''t among the privileged.', 0);
         End;
    464: Begin
           AddNotice('Invalid password specifyed.', 0);
         End;
    465: Begin
           AddNotice('You are banned from this server.', 0);
         End;
    467: Begin
           AddNotice('That key is already set on ' + Z.Token[3] + '.', 0);
         End;
    471: Begin
           AddNotice('You can''t join ' + Z.Token[3] + ', it''s full.', 0);
         End;
    472: Begin
           AddNotice('"' + Z.Token[3] + '" is an unknown mode char to me!', 0);
         End;
    473: Begin
           AddNotice('You can''t join ' + Z.Token[3] + ', it''s invite only.', 0);
         End;
    474: Begin
           AddNotice('You can''t join ' + Z.Token[3] + ', you''re banned!', 0);
         End;
    475: Begin
           AddNotice('You can''t join ' + Z.Token[3] + ', wrong key.', 0);
         End;
    481: Begin
           AddNotice('Permission Denied- You''re not an IRC operator.', 0);
         End;
    482: Begin
           AddNotice('You''re not a channel operator on ' + Z.Token[3] + '.', 0);
         End;
    483: Begin
           AddNotice('You can''t kill a server!', 0);
         End;
    491: Begin
           AddNotice('No O-lines for your host!', 0);
         End;
    501: Begin
           AddNotice('Unknown mode flag specified.', 0);
         End;
    502: Begin
           AddNotice('Sorry, you can''t change modes for other users!', 0);
         End;
  Else
    Result := S;
  End;

  Z.Free;
end;

procedure TStatus.DoConnect(S, P: String);
var
  Z: TTokenizer;
  PORT, K: String;
const
    AuthMethod : array [Boolean] of TSocksAuthentication =
        (socksNoAuthentication, socksAuthenticateUsercode);
begin
  If (WSocket1.State = wsConnecting) Then
  Begin
    K := 'This server window is already connecting...';
    If (Settins.UserLevel.ItemIndex = 0) Then ShowMessage(K);
    If (Settins.UserLevel.ItemIndex <> 0) Then AddNotice(K, 0);
    Exit;
  End;
  If (Connected = 1) Then
  Begin
    DisConnect;
    Exit;
  End;
  If (Self.SvrBox.Text = '') Then
  Begin
    ShowMessage('Please select a server first!');
    Exit;
  End;

  If (WSocket1.State = wsConnected) And (Connected = 2) Then
  Begin
    Send('QUIT :' + Settins.QuitText.Text);
    IRCMain.CloseSpecific(Self.Tag);
    Exit;
  End;

  InData := '';

  Z := TTokenizer.Create;
  Z.TokenChr := #255;
  Z.InitTokenStr(IRCMain.ServerList.Strings[Self.SvrBox.ItemIndex]);

  NICK := Settins.NickText.Text;
  SERVER := Z.Token[1];
  PORT := Z.Token[2];
  PASS := Z.Token[3];

  If (S <> '') Then
  Begin
    SERVER := S;
    PORT := P;
    If (PORT = '') Then
      PORT := '6667';
  End;

  AddNotice('Connecting to ' + SERVER + ':' + PORT + '...', GetColor(10));

  If (Settins.UseSocks.Checked) Then Begin
    WSocket1.SocksServer := '195.202.129.243';
    WSocket1.SocksPort := '1080';

    WSocket1.SocksUsercode := '';
    WSocket1.SocksPassword := '';

    WSocket1.SocksAuthentication := AuthMethod[Settins.CheckBox1.Checked];
    WSocket1.Proto := 'tcp';
  End;

  If (Settins.IDENT.Checked) Then
    EnableIdent;

  WSocket1.Addr := SERVER;
  WSocket1.Port := PORT;
//  WSocket1.OnDisplay := DisplayMsg;
  WSocket1.Connect;

  Z.Free;
end;

procedure TStatus.Send(A: String);
begin
  If (WSocket1.State <> wsConnected) Then
  Begin
    AddNotice('You''re not connected to an irc server!', GetColor(4));
    Exit;
  End;

  If (WSocket1.State = wsConnected) Then
  Begin
    If (Settins.ShowSend.Checked) Then
      AddStatus('SENT: ' + A, GetColor(3));

    WSocket1.SendStr(A + #13#10);
  End;
end;

procedure TStatus.PingTimerTimer(Sender: TObject);
begin
  Send('PING ' + FloatToStr(un_ctime(DateTimeToStr(Now))) + ' ' + SERVER);
end;

procedure TStatus.CTCP(U: String; WH: String);
var
  A: String;
begin
  A := U;
  If (Pos(' ', U) > 0) Then A := Copy(U, 1, Pos(' ', U) - 1);
  U := UpStr(U);
  AddNotice('[CTCP/' + UpStr(A) + '] -> ' + WH, GetColor(2));
  Send('PRIVMSG ' + WH + ' :' + IRCAction + U + IRCAction);
end;

procedure TStatus.WSocket1SocksConnected(Sender: TObject; Error: Word);
begin
  AddNotice('Connection with SOCKS server established!', 0);
//  Connect1.Caption := 'Dis&connect';
  TBConnect.Hint := 'Disconnect';
  TBConnect.ImageIndex := 1;
  Connected := 1;
  Send('NICK ' + NICK);
  Send('USER ' + NICK + ' ' + LocalIP + ' ' + SERVER + ' :' + Settins.RealText.Text);
end;

procedure TStatus.WSocket1SocksError(Sender: TObject; Error: Integer;
  Msg: String);
begin
  AddNotice('SOCKS connection error!', 0);
end;

procedure TStatus.WSocket1SocksAuthState(Sender: TObject;
  AuthState: TSocksAuthState);
begin
    case AuthState of
    socksAuthStart:
        AddStatus('Socks authentification start.', 0);
    socksAuthSuccess:
        AddStatus('Socks authentification success.', 0);
    socksAuthFailure:
        AddStatus('Socks authentification failure.', 0);
    socksAuthNotRequired:
        AddStatus('Socks authentification not required.', 0);
    else
        AddStatus('Unknown socks authentification state.', 0)
    end;
end;

procedure TStatus.WSocket1Error(Sender: TObject);
begin
  AddNotice('WSocket1 Error!', 0);
end;

procedure TStatus.Button1Click(Sender: TObject);
begin
  DoConnect('', '');
end;

procedure TStatus.TBConnectClick(Sender: TObject);
begin
  DoConnect('', '');
end;

procedure TStatus.SlashCmd(Str: String; CH: String; P: Integer; FormMain: TRichEdit98);
var
  S                : String;
  Tmp              : String;
  Tmp2             : String;
  Tmp3             : String;
  Z                : TTokenizer;
  A                : TTokenizer;
  X                : Integer;
  IsChan           : Boolean;
  I                : Cardinal;
  Valid            : Boolean;

Label
  Bottom;

begin
    ClearAwaySecs;
    Valid := False;

    If (Str = '') Then Exit;
    If (Str[1] <> '/') Then
    Begin
      If (CH <> '') Then
      Begin
        Self.Say(CH, Str);
      End
      Else
      Begin
        AddNotice('You are not on a channel.', 0);
      End;
      Exit;
    End;

    Z := TTokenizer.Create;
    Z.InitTokenStr(Str);

    S := '';

    Tmp := UpStr(Z.Token[0]);

//Alias support. Will put in its own procedure later on.
    For I := 0 to IRCMain.AliasList.Count - 1 Do
    Begin
      A := TTokenizer.Create;
      A.InitTokenStr(IRCMain.AliasList.Strings[I]);
      If (Tmp = UpStr(A.Token[0])) Then
      Begin
        Valid := True;
        Tmp2 := '';
        S := '';
        For X := 1 To A.TokenCount - 1 Do
          Tmp2 := Tmp2 + A.Token[X] + ' ';
        Repeat
          If (Tmp2[1] = '$') Then
          Begin
            If (IRCMain.IsNumeric(Copy(Tmp2, 2, 2))) Then
            Begin
              X := StrToInt(Copy(Tmp2, 2, 2));
              S := S + Z.Token[X];
              Delete(Tmp2, 1, 1);
            End;
            If (IRCMain.IsNumeric(Copy(Tmp2, 2, 1))) Then
            Begin
              X := StrToInt(Copy(Tmp2, 2, 1));
              S := S + Z.Token[X];
              Delete(Tmp2, 1, 1);
            End;
            If (Copy(Tmp2, 2, 1) = '*') Then
            Begin
              For X := 1 To Z.TokenCount - 1 Do
                S := S + Z.Token[X] + ' ';
              Delete(Tmp2, 1, 1);
            End;
          End
          Else
            S := S + Tmp2[1];
          Delete(Tmp2, 1, 1);
        Until Tmp2 = '';
      End;
      A.Free;
    End;
    If (S <> '') Then Begin
      Z.Free;
      Z := TTokenizer.Create;
      Z.InitTokenStr(S);
    End;
//End support.

    IsChan := False;
    If (P > 99) Then
    Begin
      Dec(P, 10000);
      IsChan := True;
    End;
    S := UpStr(Z.Token[0]);
    Tmp := Z.Token[1];
    Tmp2 := '';
    For X := 1 To Z.TokenCount - 1 Do
      Tmp2 := Tmp2 + Z.Token[X] + ' ';
    Tmp3 := '';
    For X := 2 To Z.TokenCount - 1 Do
      Tmp3 := Tmp3 + Z.Token[X] + ' ';

    Tmp2 := Trim(Tmp2);
    Tmp3 := Trim(Tmp3);

    If (S = '/SV') Then
    Begin
      Valid := True;
      Str := Application.Title + ' ' + IRCMain.VER + ' by Chris Monahan'; 
      If (CH = '') Then
        AddNotice('You are using ' + Str, 0)
      Else
        Say(CH, 'I am using ' + Str);
    End;
    If (S = '/UPTIME') Then
    Begin
      Valid := True;
      Str := 'Uptime: ' + AwayTime(IRCMain.UpTime);
      If (CH = '') Then
        AddNotice(Str, 0)
      Else
        Say(CH, Str);
    End;
    If (S = '/OP') Then
    Begin
      Valid := True;
      Send('MODE ' + CH + ' +' + StringOfChar('o', Z.TokenCount-1) + ' ' + Tmp2);
    End;
    If (S = '/DEOP') Then
    Begin
      Valid := True;
      Send('MODE ' + CH + ' -' + StringOfChar('o', Z.TokenCount-1) + ' ' + Tmp2);
    End;
    If (S = '/VOICE') Then
    Begin
      Valid := True;
      Send('MODE ' + CH + ' +' + StringOfChar('v', Z.TokenCount-1) + ' ' + Tmp2);
    End;
    If (S = '/DEVOICE') Then
    Begin
      Valid := True;
      Send('MODE ' + CH + ' -' + StringOfChar('v', Z.TokenCount-1) + ' ' + Tmp2);
    End;
    If (S = '/KICK') Then
    Begin
      Valid := True;
      If (Tmp3 = '') Then
        Tmp3 := Settins.KickText.Text;
      Send('KICK ' + CH + ' ' + Tmp + ' :' + Tmp3);
    End;
    If (S = '/BAN') Then
    Begin
      Valid := True;
      BanListEntries := 0;
      If (Tmp <> '') Then
      Begin
        If (Tmp[1] = '#') Or (Tmp[1] = '&') Then
        Begin
          Send('MODE ' + Tmp + ' ' + ModeBan + ' ' + Tmp3);
        End
        Else
        Begin
          Send('MODE ' + CH + ' ' + ModeBan + ' ' + Tmp2);
        End;
      End
      Else
      Begin
        Send('MODE ' + CH + ' ' + ModeBan);
      End;
    End;
    If (S = '/BANS') Then
    Begin
      Valid := True;
      If (Tmp <> '') Then
      Begin
        If (Tmp[1] = '#') Or (Tmp[1] = '&') Then
        Begin
          Send('MODE ' + Tmp + ' ' + ModeBan);
        End;
      End
      Else
      Begin
        If (CH = '') Then
        Begin
          AddNotice('You must use /BANS from a channel, or specify one', 0);
        End
        Else
        Begin
          Send('MODE ' + CH + ' ' + ModeBan);
        End;
      End;
    End;
    If (S = '/YNAMES') Then
    Begin
      Valid := True;
      Send('NAMES');
    End;
    If (S = '/NAMES') Then
    Begin
      Valid := True;
      If (Tmp <> '') Then
      Begin
        If (Tmp[1] = '#') Or (Tmp[1] = '&') Then
        Begin
          Send('NAMES ' + Tmp);
        End;
      End
      Else
      Begin
        If (CH = '') Then
        Begin
          AddNotice('If you wish to list all of the nicks on this server, please type /YNAMES', 0);
        End
        Else
        Begin
          Send('NAMES ' + CH);
        End;
      End;
    End;
    If (S = '/ADMIN') Then
    Begin
      Valid := True;
      Send('ADMIN ' + Tmp);
    End;
    If (S = '/TOPIC') Then
    Begin
      Valid := True;
      If (Tmp <> '') Then
      Begin
        If (Tmp[1] = '#') Or (Tmp[1] = '&') Then
        Begin
          Send('TOPIC ' + Tmp + ' :' + Tmp3);
        End
        Else
        Begin
          Send('TOPIC ' + CH + ' :' + Tmp2);
        End;
      End
      Else
      Begin
        Send('TOPIC ' + CH);
      End;
    End;
    If (S = '/INVITE') Then
    Begin
      Valid := True;
      If (Tmp <> '') Then
      Begin
        If (Tmp[1] = '#') Or (Tmp[1] = '&') Then
        Begin
          Send('INVITE ' + Tmp3 + ' ' + Tmp);
        End
        Else
        Begin
          Send('INVITE ' + Tmp2 + ' :' + CH);
        End;
      End
      Else
      Begin
        Send('INVITE ' + CH);
      End;
    End;
    If (S = '/AWAY') Then
    Begin
      Valid := True;
      If (Tmp2 <> '') Then
      Begin
        Send('AWAY :' + Tmp2);
        UserAway := True;
      End;
      AwaySecs := (StrToInt(Settins.AwayMins.Text) * 60);
    End;
    If (S = '/BACK') Then
    Begin
      Valid := True;
      ReturnFromAway;
    End;

    If (S = '/ENCRYPT') Then
    Begin
      Valid := True;
//      Self.Say(CH, Encrypt(Tmp2));
      AddStatus(Encrypt(Tmp2), GetColor(4));
    End;
    If (S = '/DECRYPT') Then
    Begin
      Valid := True;
      AddStatus(Decrypt(Tmp2), GetColor(4));
    End;
    If (S = '/STATS') Then
    Begin
      Valid := True;
      Send('STATS ' + Tmp2);
    End;
    If (S = '/INFO') Then
    Begin
      Valid := True;
      Send('INFO ' + Tmp);
    End;
    If (S = '/CLEAR') Then
    Begin
      Valid := True;
      FormMain.Clear;
    End;

    If (S = '/LINKS') Then
    Begin
      Valid := True;
      AddNotice('Requesting links list...', 0);
      Send('LINKS ' + Tmp2);
    End;
    If (S = '/CONNECT') Then
    Begin
      Valid := True;
      Send('CONNECT ' + Tmp2);
    End;
    If (S = '/YUP') Then
    Begin
      Valid := True;
      AddStatus(IRCMain.GetNicksFrom(Tmp, Self.Tag), GetColor(1));
    End;
    If (S = '/TIME') Then
    Begin
      Valid := True;
      If (Tmp = '') Then
        Send('TIME ' + Tmp)
      Else
        CTCP('TIME', Tmp);
    End;
    If (S = '/TRACE') Then
    Begin
      Valid := True;
      Send('TRACE ' + Tmp);
    End;
    If (S = '/SERVER') Then
    Begin
      Valid := True;
      If (Connected <> 0) Then
        Disconnect;
      X := Pos(':', Tmp);
      If (X <> 0) Then
      Begin
        Tmp3 := Copy(Tmp, X + 1, MaxInt);
        Delete(Tmp, X, MaxInt);
      End;
      DoConnect(Tmp, Tmp3);
    End;
    If (S = '/NEWSERVER') Then
    Begin
      Valid := True;
      X := Pos(':', Tmp);
      If (X <> 0) Then
      Begin
        Tmp3 := Copy(Tmp, X + 1, MaxInt);
        Delete(Tmp, X, MaxInt);
      End;
      IRCMain.InstantConnect(Tmp, Tmp3);
    End;
    If (S = '/MSG') Then
    Begin
      Valid := True;
      Send('PRIVMSG ' + Tmp + ' :' + Tmp3);
      If (IsChan) Then
        IRCMain.AddTextTo(CH, '-> *' + Tmp + '* ' + Tmp3, 0, P)
      Else
        AddStatus('-> *' + Tmp + '* ' + Tmp3, 0);
    End;
    If (S = '/MOTD') Then
    Begin
      Valid := True;
      Send('MOTD');
    End;
    If (S = '/WHOIS') Then
    Begin
      Valid := True;
      If (Tmp2 = '') Then
        Tmp2 := NICK;
      Send('WHOIS ' + Tmp2);
    End;
    If (S = '/LIST') Then
    Begin
      Valid := True;
      Send('LIST ' + Tmp2);
    End;
    If (S = '/NICK') Then
    Begin
      Valid := True;
      Send('NICK ' + Tmp);
    End;

//    If (Tmp = '') Then
//    Begin
//      Goto Bottom;
//    End;

    If (S = '/PING') Then
    Begin
      Valid := True;
      If (CH <> '') And (Tmp = '') Then
        Tmp := CH;
      If (Tmp = '') Then
        AddNotice('Please specify a nickname or channel to ping.', 0)
      Else
        CTCP('PING ' + FloatToStr(un_ctime(DateTimeToStr(Now))), Tmp);
    End;
    If (S = '/VERSION') Then
    Begin
      Valid := True;
      Send('VERSION ' + Tmp);
    End;
    If (S = '/DNS') Then
    Begin
      Valid := True;
      WSocket2.DnsLookup(Tmp);
    End;
    If (S = '/JOIN') Then
    Begin
      Valid := True;
      If (Tmp[1] <> '#') And (Tmp[1] <> '&') Then
       Tmp := '#' + Tmp;
      Send('JOIN ' + Tmp);
    End;
    If (S = '/QUOTE') Then
    Begin
      Valid := True;
      Send(Tmp2);
    End;
    If (S = '/CTCP') Then
    Begin
      Valid := True;
      CTCP(Z.Token[2], Tmp);
    End;
    If (S = '/VER') Then
    Begin
      Valid := True;
      CTCP('VERSION', Tmp);
    End;
    If (S = '/USERS') Then
    Begin
      Valid := True;
      Send('USERS ' + Tmp);
    End;
    If (S = '/WALLOPS') Then
    Begin
      Valid := True;
      Send('WALLOPS ' + Tmp2);
    End;
    If (S = '/WHOWAS') Then
    Begin
      Valid := True;
      Send('WHOWAS ' + Tmp2);
    End;
    If (S = '/WHO') Then
    Begin
      Valid := True;
      Send('WHO ' + Tmp2);
    End;
    If (S = '/OWHO') Then
    Begin
      Valid := True;
      Send('WHO ' + Tmp2 + ' o');
    End;
    If (S = '/OPER') Then
    Begin
      Valid := True;
      Send('OPER ' + Tmp2);
    End;
    If (S = '/KILL') Then
    Begin
      Valid := True;
      Send('KILL ' + Tmp2);
    End;
    If (S = '/SUMMON') Then
    Begin
      Valid := True;
      Send('SUMMON ' + Tmp2);
    End;
    If (S = '/REHASH') Then
    Begin
      Valid := True;
      Send('REHASH');
    End;
    If (S = '/RESTART') Then
    Begin
      Valid := True;
      Send('RESTART');
    End;
    If (S = '/SQUIT') Then
    Begin
      Valid := True;
      Send('SQUIT ' + Tmp2);
    End;
    If (S = '/ISON') Then
    Begin
      Valid := True;
      Send('ISON ' + Tmp2);
    End;
    If (S = '/DCC') Then
    Begin
      Valid := True;
      Application.CreateForm(TDccSend, DccSend);
      Send(DccSend.SendFile(Tmp, Tmp3, LocalIP));
    End;
    If (S = '/ECHO') Then
    Begin
      valid := True;
      AddStatus(Tmp2, 0);
    End;
    If (S = '/AME') Then
    Begin
      Valid := True;
      IRCMain.AddActionAll(Tmp2, Self.Tag);
    End;
    If (S = '/ME') Then
    Begin
      Valid := True;
      DoAction(CH, Tmp2);
    End;
    If (S = '/MODE') Then
    Begin
      Valid := True;
      Send('MODE ' + Tmp2);
    End;
    If (S = '/UMODE') Then
    Begin
      Valid := True;
      Send('MODE ' + NICK + ' ' + Tmp2);
    End;
    If (S = '/CMODE') Then
    Begin
      Valid := True;
      Send('MODE ' + CH + ' ' + Tmp2);
    End;
    If (S = '/NOTICE') Then
    Begin
      Valid := True;
      Send('NOTICE ' + Tmp + ' :' + Tmp3);
      If (IsChan) Then
        IRCMain.AddTextTo(CH, '[> *' + Tmp + '* ' + Tmp3, RGB(64, 0, 64), P)
      Else
        AddStatus('[> *' + Tmp + '* ' + Tmp3, RGB(64, 0, 64));
    End;

Bottom:
  If (Not Valid) Then
  Begin
    If (IsChan) Then
      IRCMain.AddTextTo(CH, Settins.Notice.Text + 'Invalid command: "' + Str + '"', 0, P)
    Else
      AddNotice('Invalid command: "' + Str + '"', 0);
  End;

  Z.Free;
end;

procedure TStatus.ToolButton1Click(Sender: TObject);
begin
  Self.Destroy;
end;

procedure TStatus.SDTimerTimer(Sender: TObject);
begin
  SDTimer.Enabled := False;
  SDLight.Brush.Color := clWhite;
end;

procedure TStatus.RDTimerTimer(Sender: TObject);
begin
  RDTimer.Enabled := False;
  RDLight.Brush.Color := clWhite;
end;

procedure TStatus.SDBlink;
begin
  SDLight.Brush.Color := clRed;
  SDTimer.Enabled := True;
end;

procedure TStatus.RDBlink;
begin
  RDLight.Brush.Color := clRed;
  RDTimer.Enabled := True;
end;

procedure TStatus.Say(CH: String; S: String);
begin
  Send('PRIVMSG ' + CH + ' :' + S);
  IRCMain.AddTextTo(CH, '<' + Self.NICK + '> ' + S, 0, Self.Tag);
end;

procedure TStatus.InsertStr(Str: String);
var
  Tmp              : String;
  X                : Integer;
begin
  Tmp := Self.Prompt.Text;
  X := Self.Prompt.SelStart + 1;
  Insert(Str, Tmp, X);
  Self.Prompt.Text := Tmp;
  Self.Prompt.SelStart := X;
end;

procedure TStatus.PromptKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Str              : String;
  Str2             : String;
begin
  Str2 := Self.Prompt.Text;
  Str := DoPromptKeyDown(Shift, Self.Prompt, Key, LineNumber,
   PromptList, Self.Main);
  If (Str <> '') Then
  Begin
    Key := 0;
    LineNumber := StrToInt(Copy(Str, 1, Pos(#1, Str) - 1));
    Prompt.SelStart := StrToInt(Copy(Str, Pos(#1, Str) + 1, MaxInt));
  End;
end;

procedure TStatus.PromptKeyPress(Sender: TObject; var Key: Char);
begin
  Case Ord(Key) Of
    2, 11, 21, 18: Key := #0;
  End;
  If (Key = #13) And (Self.Prompt.Text <> '') Then
  Begin
    SlashCmd(Self.Prompt.Text, '', Self.Tag, Self.Main);
    Self.AddPromptLine(Self.Prompt.Text);
    Self.Prompt.Text := '';
    Key := #0;
  End;
end;

function TStatus.MsgBoxExists(WHO: String; P: Integer): Boolean;
var
  I: Integer;
  K: String;
begin
  Result := False;
  WHO := UpStr(WHO);
  For I := 0 to IRCMain.MDIChildCount - 1 Do Begin
    K := UpStr(IRCMain.MDIChildren[I].Caption);
    If (K = WHO) And ((IRCMain.MDIChildren[I] As TMsgBox).Tag = P) Then
      Result := True;
  End;
end;

procedure TStatus.Msg(WH, S, M: String);
begin
  IRCMain.AddMsgText(M, '<' + Self.NICK + '> ' + S, 0, Self.Tag);
  Send('PRIVMSG ' + WH + ' :' + S);
end;

procedure TStatus.AwayTimerTimer(Sender: TObject);
var
  S                : String;
  Secs             : Integer;

begin
  If (Not UserAway) And (AwaySecs >= (StrToInt(Settins.AwayMins.Text) * 60)) Then
  Begin
    S := Settins.AwayText.Text;
    Send('AWAY :' + S);
    UserAway := True;
    PingTimer.Enabled := False;

    Secs := StrToInt(Settins.AwayMins.Text) * 60;

    IRCMain.AddActionAll('is away after [' + AwayTime(Secs) + ']...', Self.Tag);
  End;
  Inc(AwaySecs);
end;

procedure TStatus.ClearAwaySecs;
begin
  If (UserAway) And (Not Settins.CancelAway.Checked) Then
    Exit;
  If (UserAway) And (Settins.CancelAway.Checked) Then
    ReturnFromAway;
  AwaySecs := 0;
end;

procedure TStatus.ReturnFromAway;
begin
//  Inc(AwaySecs, StrToInt(Settins.AwayMins.Text) * 60);
  Send('AWAY');
  IRCMain.AddActionAll('has returned... Gone for [' + AwayTime(AwaySecs) + ']', Self.Tag);
  UserAway := False;
  PingTimer.Enabled := Settins.CheckLag.Checked;
end;

procedure TStatus.DoAction(CH: String; Str: String);
begin
  Send('PRIVMSG ' + CH + ' :' + IRCAction + 'ACTION ' + Str + IRCAction);
  IRCMain.AddTextTo(CH, '* ' + NICK + ' ' + Str, GetColor(5), Self.Tag);
end;

procedure TStatus.CloseMe;
var
  Res            : Boolean;
begin
  If (Connected = 2) And (Settins.UserLevel.ItemIndex <> 2) Then
    Res := Ask('Are you sure you want to disconnect from ' + SERVER + ':' + WSocket1.Port + '?')
  Else
    Res := True;

  If (Res) Then
  Begin
    Send('QUIT :' + Settins.QuitText.Text);
    IRCMain.CloseSpecific(Self.Tag);
    MySheet.Destroy;
    CloseIdent;
    Self.Release;
  End;
end;

procedure TStatus.FormDestroy(Sender: TObject);
begin
  CloseMe;
end;

procedure TStatus.FormActivate(Sender: TObject);
begin
  IRCMain.TabPage.ActivePage := MySheet;
end;

procedure TStatus.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CloseMe;
end;

procedure TStatus.Disconnect;
begin
  WSocket1.Close;
  Connected := 0;
//  Connect1.Caption := '&Connect';
  TBConnect.Hint := 'Connect';
  TBConnect.ImageIndex := 0;
end;

procedure TStatus.ChangeMode(S: String);
var
  I                : Integer;
  M                : Char;

begin
  For I := 1 To Length(S) Do
  Begin
    Case S[I] Of
      '-', '+': M := S[I];
    Else
      If (S[I] <> M) Then
      Begin
        If (M = '-') Then
          Delete(MODE, Pos(S[I], MODE), 1);
        If (M = '+') Then
          MODE := MODE + S[I];
      End;
    End;
  End;
end;

procedure TStatus.UpdateSvrBox(Sel: Integer);
var
  X                : Integer;
  OldVal           : Integer;
begin
  OldVal := Self.SvrBox.ItemIndex;
  Self.SvrBox.Items.Clear;

  For X := 0 To Settins.Server.Items.Count-1 Do
  Begin
    Self.SvrBox.Items.Add(Settins.Server.Items[X]);
  End;

  If (Sel <> -1) Then
    OldVal := Sel;

  Self.SvrBox.ItemIndex := OldVal;
end;

procedure TStatus.SvrBoxClick(Sender: TObject);
begin
  Self.Prompt.SetFocus;
end;

procedure TStatus.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := False;
  Self.Release;
end;

function TStatus.AwayTime(Secs: Integer): String;
var
  Str              : String;
  Days             : Integer;
  Hours            : Integer;
  Mins             : Integer;
begin
  If (Secs = 0) Then
  Begin
    Result := '0s';
    Exit;
  End;
  Days := Secs Div 86400;
  Dec(Secs, Days * 86400);
  Hours := Secs Div 3600;
  Dec(Secs, Hours * 3600);
  Mins := Secs Div 60;
  Dec(Secs, Mins * 60);
  Str := '';
  If (Days <> 0) Then
    Str := IntToStr(Days) + 'd ';
  If (Hours <> 0) Then
    Str := Str + IntToStr(Hours) + 'h ';
  If (Mins <> 0) Then
    Str := Str + IntToStr(Mins) + 'm ';
  If (Secs <> 0) Then
    Str := Str + IntToStr(Secs) + 's';

  Result := Trim(Str);
end;

procedure TStatus.AddNotice(S: String; C: Integer);
begin
  AddStatus(Settins.Notice.Text + S, C);
end;

procedure TStatus.WSocket1DnsLookupDone(Sender: TObject; Error: Word);
begin
//
end;

procedure TStatus.WSocket2DnsLookupDone(Sender: TObject; Error: Word);
var
  Str              : String;
  X                : Integer;
  Y                : Integer;
begin
  If (Error = 0) Then
  Begin
    Y := WSocket2.DnsResultList.Count;
    Str := '[Found ' + IntToStr(Y) + ']: ';
    For X := 0 To Y-1 Do
    Begin
      Str := Str + WSocket2.DnsResultList[X];
      If (X <> Y-1) Then
        Str := Str + ', ';
    End;
    AddNotice(Str, 0);
  End
  Else
    AddNotice('Hostname not found, error #' + IntToStr(Error), 0);
end;

procedure TStatus.EnableIdent;
begin
  IdentTextBuf := '';
  Self.IdentSocket.Close;
  Self.IdentSocket.Addr := '0.0.0.0';
  Self.IdentSocket.Port := Settins.PortText.Text;
  Self.IdentSocket.Listen;
end;

procedure TStatus.SendIdent(S: String);
var
  P                : String;
begin
  P := S + ' : USERID : ' + Settins.SysType.Text + ' : ' + Settins.IdntText.Text;
  Self.IdentSocket.SendStr(P + #13#10);

  If (Settins.ShowIdent.Checked) Then
    AddNotice('Replied with "' + P + '"', GetColor(4));
end;

procedure TStatus.IdentSocketDataAvailable(Sender: TObject; Error: Word);
Var
  NewData          : String;
begin
  NewData := Self.IdentSocket.ReceiveStr;
  IdentTextBuf := IdentTextBuf + NewData;

  While (Pos(#10, IdentTextBuf) > 0) Do
  Begin
    If Copy(IdentTextBuf, Pos(#10, IdentTextBuf) - 1, 1) <> #13 Then
      IdentTextBuf := Copy(IdentTextBuf, 1, Pos(#13, IdentTextBuf) - 1) + #13 + Copy(IdentTextBuf, Pos(#10, IdentTextBuf), Length(IdentTextBuf));
    NewData := Copy(IdentTextBuf, 1, Pos(#13#10, IdentTextBuf) - 1);
    IdentTextBuf := Copy(IdentTextBuf, Pos(#13#10, IdentTextBuf) + Length(#13#10), Length(IdentTextBuf));
    SendIdent(NewData);
  End;
end;

procedure TStatus.IdentSocketSessionAvailable(Sender: TObject; Error: Word);
begin
  Self.IdentSocket.HSocket := Self.IdentSocket.Accept;
  If (Settins.ShowIdent.Checked) Then
    AddNotice('Request from ' + Self.IdentSocket.GetPeerAddr +
     ' for Ident...', GetColor(4));
end;

procedure TStatus.IdentSocketError(Sender: TObject);
begin
  AddNotice('WSocket2 Error!', 0);
  WSocket2.Close;
end;

procedure TStatus.IdentSocketSessionClosed(Sender: TObject; Error: Word);
begin
  Self.IdentSocket.Close;
  If (Settins.ShowIdent.Checked) Then
    AddNotice('Ident port closed, operation complete!', GetColor(4));
end;

procedure TStatus.CloseIdent;
begin
  Self.IdentSocket.Close;
  IdentTextBuf := '';
end;

procedure TStatus.IdentSocketDataSent(Sender: TObject; Error: Word);
begin
  SDBlink;
end;

procedure TStatus.AddCtcpReply(A1, A2, A3: String);
begin
  AddNotice('CTCP ' + IRCBold + A1 + IRCBold + ' reply from '
   + A2 + ': ' + A3, GetColor(10));
end;

procedure TStatus.MainMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  If (Button = mbMiddle) Then
  Begin
    Self.Main.HideSelection := True;
    Self.Main.SetFocus;
  End;
end;

end.
