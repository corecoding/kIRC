unit qChannel;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ComCtrls, RichEdit2, Tokens,
  Menus, DDUStandard;

type
  TChannel = class(TForm)
    NameList: TListBox;
    Main: TRichEdit98;
    Prompt: TDDUEdit;
    NickListOpts: TPopupMenu;
    Controls1: TMenuItem;
    bleh1: TMenuItem;
    OP1: TMenuItem;
    procedure ResizeMe(Sender: TObject);
    procedure MainMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AddText(A: String; J: Integer);
    procedure NameListMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PromptKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PromptKeyPress(Sender: TObject; var Key: Char);
    procedure AddPromptLine(S: String);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Topic(Str: String);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    function CompleteName(S: String; I: Integer): String;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure AddNicks(A1, A2: Integer);
    procedure UpdateNicks(A1, A2: Integer);
    function GetNicks: String;
    procedure MainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ClearWindow;
  private
    Chops: Integer;
    Nops: Integer;
    procedure WMSysCommand(Var Msg : TWMSysCommand); Message WM_SysCommand;
  public
    PromptList: Array[0..30] Of String;
    LineNumber: Integer;
    MySheet: TTabSheet;    
  end;

var
  Channel: TChannel;

implementation

uses qIRCMain, qStatus, qSupport;

{$R *.DFM}

procedure TChannel.ResizeMe(Sender: TObject);
begin
  Self.Main.Height := Self.Prompt.Top + 1;
  Self.Main.Width := Self.NameList.Left + 2;
  Self.NameList.Height := Self.Prompt.Top + 1;
end;

procedure TChannel.MainMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  If (Button = mbMiddle) Then
  Begin
    Self.Main.HideSelection := False;  
    Self.Prompt.SetFocus;
    Exit;
  End;

  If (Self.Main.SelLength > 0) Then
  Begin
    Self.Main.CopyToClipboard;
    IRCMain.ChangeStatus('Copied ' + IntToStr(Self.Main.SelLength) + ' bytes to the clipboard.');
  End;

  Self.Main.SelStart := MaxInt;
  Self.Prompt.SetFocus;
  Self.Prompt.SelStart := MaxInt;
end;

procedure TChannel.AddText(A: String; J: Integer);
begin
  AddTextToWindow(Self.Main, A, J);
end;

procedure TChannel.NameListMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Self.Prompt.SetFocus;
  Self.Prompt.SelStart := MaxInt;
end;

procedure TChannel.PromptKeyDown(Sender: TObject; var Key: Word;
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

procedure TChannel.PromptKeyPress(Sender: TObject; var Key: Char);
var
  K                : String;

begin
  If (Key = #9) Then
  Begin
    If (Prompt.Text <> '') Then
    Begin
      K := CompleteName(Prompt.Text, Prompt.SelStart);
      Prompt.Text := Copy(K, 1, Pos(#1, K) - 1);
      Prompt.SelStart := StrToInt(Copy(K, Pos(#1, K) + 1,  Length(K) - Length(Prompt.Text)));
    End;
    Key := #0;
  End;
  If (Key = #13) Then
  Begin
    If (Length(Self.Prompt.Text) <> 0) Then
      Key := #0;
    K := IRCMain.StripIt(Self.Caption);
    If (Prompt.Text <> '') Then
    Begin
      AddPromptLine(Self.Prompt.Text);
      IRCMain.SlashCmd(Self.Prompt.Text, K, Self.Tag + 10000, Self.Main)
    End;
    Prompt.Text := '';
  End;
end;

procedure TChannel.AddPromptLine(S: String);
var
  I                : Integer;
begin
  For I := 29 DownTo 0 Do
    Self.PromptList[I + 1] := Self.PromptList[I];

  Self.PromptList[0] := S;
  Self.LineNumber := -1;
end;

procedure TChannel.FormCreate(Sender: TObject);
begin
  Chops := 0;
  Nops := 0;
  Self.LineNumber := -1;

  Self.Prompt.Height := (Self.Prompt.Font.Size * 2) + 1;
  Self.Prompt.Top := (Self.Height - Self.Prompt.Height * 2) - 1;
  Self.NameList.Left := Self.Width - (Self.NameList.Width + 7);
  Self.NameList.Height := Self.Prompt.Top + 1;
  Self.Main.Height := Self.Prompt.Top + 1;
  Self.Main.Width := Self.NameList.Left + 2;
  Self.Prompt.Width := Self.Width - 4;

  MySheet := TMyTabSheet.Create(Self);
  (MySheet As TMyTabSheet).Form := Self;
  MySheet.PageControl := IRCMain.TabPage;
end;

procedure TChannel.Topic(Str: String);
begin
  Self.Caption := Str;
  MySheet.Caption := IRCMain.StripIt(Str);
end;

procedure TChannel.WMSysCommand(var Msg : TWMSysCommand);
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

procedure TChannel.FormDestroy(Sender: TObject);
begin
  IRCMain.SelfPartChan(IRCMain.StripIt(Self.Caption), Self.Tag);
  MySheet.Destroy;
end;

procedure TChannel.FormActivate(Sender: TObject);
begin
  IRCMain.TabPage.ActivePage := MySheet;
end;

procedure TChannel.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  IRCMain.SelfPartChan(IRCMain.StripIt(Self.Caption), Self.Tag);
  MySheet.Destroy;
end;

function TChannel.CompleteName(S: String; I: Integer): String;
var
  Str              : String;
  Tmp              : String;
  Z                : TTokenizer;
  X                : Integer;
  Where            : Integer;
begin
  Tmp := '';
  Insert(#1, S, I);
  Z := TTokenizer.Create;
  Z.InitTokenStr(S);
  For X := 0 To Z.TokenCount - 1 Do
    If (Pos(#1, Z.Token[X]) <> 0) Then
      Where := X;
  Str := Z.Token[Where];
  If (Pos(#1, Str) <> 0) Then
    Delete(Str, Pos(#1, Str), 1);
  Tmp := Str;
  Dec(I, Length(Tmp));
  Str := AnsiUpperCase(Str);
  For X := 0 To Self.NameList.Items.Count-1 Do
  Begin
    If (Pos(Str, AnsiUpperCase(IRCMain.StripIt(Self.NameList.Items[X]))) = 1) Then
      Tmp := Self.NameList.Items[X];
  End;
  Tmp := IRCMain.StripIt(Tmp) + ' ';
  Str := '';
  For X := 0 To Z.TokenCount - 1 Do
    If (X <> Where) Then
      Str := Str + Z.Token[X] + ' '
    Else
      Str := Str + Tmp;
  Delete(Str, Length(Str), 1);
  Inc(I, Length(Tmp));
  Result := Str + #1 + IntToStr(I);
  Z.Free;
end;

procedure TChannel.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := False;
  Self.Release;
end;

procedure TChannel.AddNicks(A1, A2: Integer);
begin
  Inc(Chops, A1);
  Inc(Nops, A2);
end;

procedure TChannel.UpdateNicks(A1, A2: Integer);
begin
  Chops := A1;
  Nops := A2;
end;

function TChannel.GetNicks: String;
begin
  Result := IntToStr(Chops) + ':' + IntToStr(Nops);
end;

procedure TChannel.MainMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  If (Button = mbMiddle) Then
  Begin
    Self.Main.HideSelection := True;
    Self.Main.SetFocus;
  End;
end;

procedure TChannel.ClearWindow;
begin
  Self.Main.Clear;
end;

end.
