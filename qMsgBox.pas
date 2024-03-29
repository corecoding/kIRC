unit qMsgBox;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, RichEdit2, DDUStandard, ComCtrls;

type
  TMsgBox = class(TForm)
    Main: TRichEdit98;
    Prompt: TDDUEdit;
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AddText(A: String; J: Integer);
    procedure PromptKeyPress(Sender: TObject; var Key: Char);
    procedure AddPromptLine(S: String);
    procedure PromptKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MainMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure MainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    procedure WMSysCommand(Var Msg : TWMSysCommand); Message WM_SysCommand;
  public
    PromptList: Array[0..30] Of String;
    LineNumber: Integer;
    MySheet: TTabSheet;
  end;

var
  MsgBox: TMsgBox;

implementation

uses qIRCMain, qSupport;

{$R *.DFM}

procedure TMsgBox.FormResize(Sender: TObject);
begin
  Self.Main.Height := Self.Prompt.Top + 1;
  Self.Main.Width := Self.Width - 6;
end;

procedure TMsgBox.FormCreate(Sender: TObject);
begin
//  ShowWindow(Handle, sw_Hide);
  Self.LineNumber := -1;

  Self.Prompt.Height := (Self.Prompt.Font.Size * 2) + 1;
  Self.Prompt.Top := (Self.Height - Self.Prompt.Height * 2) - (Self.Prompt.Font.Size + 1);
  Self.Main.Height := Self.Prompt.Top + 1;
  Self.Main.Width := Self.Width - 6;
  Self.Prompt.Width := Self.Width - 6;

  MySheet := TMyTabSheet.Create(Self);
  (MySheet As TMyTabSheet).Form := Self;
  MySheet.PageControl := IRCMain.TabPage;
  MySheet.Caption := Caption;
end;

procedure TMsgBox.WMSysCommand(var Msg : TWMSysCommand);
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

procedure TMsgBox.AddText(A: String; J: Integer);
begin
  AddTextToWindow(Self.Main, A, J);
end;

procedure TMsgBox.PromptKeyPress(Sender: TObject; var Key: Char);
var
  K                : String;
begin
  If (Key = #13) Then
  Begin
    If (Length(Self.Prompt.Text) <> 0) Then Key := #0;
    K := Self.Caption;
    Delete(K, 1, Pos(' ', K));
    K := Copy(K, 1, Pos(' ', K) - 1);
    If (Self.Prompt.Text <> '') Then Begin
      Self.AddPromptLine(Self.Prompt.Text);
      If (Self.Prompt.Text[1] = '/') Then
        IRCMain.SlashCmd(Self.Prompt.Text, K, Self.Tag + 10000, Self.Main)
      Else
        IRCMain.SendMsg(K, Self.Prompt.Text, Self.Caption, Self.Tag);
    End;
    Self.Prompt.Text := '';
  End;
end;

procedure TMsgBox.AddPromptLine(S: String);
var
  I                : Integer;
begin
  For I := 29 DownTo 0 Do
    Self.PromptList[I + 1] := Self.PromptList[I];

  Self.PromptList[0] := S;
  Self.LineNumber := -1;
end;

procedure TMsgBox.PromptKeyDown(Sender: TObject; var Key: Word;
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

procedure TMsgBox.MainMouseUp(Sender: TObject; Button: TMouseButton;
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

procedure TMsgBox.FormDestroy(Sender: TObject);
begin
  MySheet.Destroy;
end;

procedure TMsgBox.FormActivate(Sender: TObject);
begin
  IRCMain.TabPage.ActivePage := MySheet;
end;

procedure TMsgBox.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MySheet.Destroy;
end;

procedure TMsgBox.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := False;
  Self.Release;
end;

procedure TMsgBox.MainMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  If (Button = mbMiddle) Then
  Begin
    Self.Main.HideSelection := True;
    Self.Main.SetFocus;
  End;
end;

end.
