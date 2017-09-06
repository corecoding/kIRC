unit qFeatures;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, SyntaxEd, StdCtrls, Buttons, SynParse, ComCtrls;

type
  TFeatures = class(TForm)
    OK: TBitBtn;
    Cancel: TBitBtn;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Memo: TSyntaxMemo;
    SyntaxMemoParser1: TSyntaxMemoParser;
    Help: TBitBtn;
    TabSheet3: TTabSheet;
    procedure FormCreate(Sender: TObject);
    procedure OKClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure WndProc(var Message: TMessage); override;
    procedure ChangeColor(Sender: TObject; Msg: Integer);
    procedure CancelClick(Sender: TObject);
    procedure HelpClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TabSheet2Show(Sender: TObject);
    procedure TabSheet1Show(Sender: TObject);
    procedure TabSheet3Show(Sender: TObject);
    procedure TabSheet1Hide(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Features: TFeatures;

implementation

uses qIRCMain;

{$R *.DFM}

procedure TFeatures.FormCreate(Sender: TObject);
begin
  IRCMain.Aliases1.Enabled := False;
  Self.Caption := IRCMain.APPNAME + ' features setup';
end;

procedure TFeatures.OKClick(Sender: TObject);
var
  I: Cardinal;
begin
  IRCMain.SaveToRegistry;
  Self.Release;
end;

procedure TFeatures.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := False;
end;

procedure TFeatures.WndProc(var Message : TMessage);
begin
  If (Message.LParam = LongInt(OK)) Then
    ChangeColor(OK, Message.Msg);
  If (Message.LParam = LongInt(Cancel)) Then
    ChangeColor(Cancel, Message.Msg);
  If (Message.LParam = LongInt(Help)) Then
    ChangeColor(Help, Message.Msg);

  Inherited WndProc(Message);
end;

procedure TFeatures.ChangeColor(Sender : TObject; Msg : Integer);
Begin
  If (Sender Is TBitBtn) Then Begin
    If (Msg = CM_MOUSELEAVE) Then
      (Sender As TBitBtn).Font.Color := clWindowText;
    If (Msg = CM_MOUSEENTER) Then Begin
      (Sender As TBitBtn).Font.Color := clRed;
    End;
  End;
End;

procedure TFeatures.CancelClick(Sender: TObject);
begin
  Self.Release;
end;

procedure TFeatures.HelpClick(Sender: TObject);
begin
  ShowMessage('HELP'#13'Use $* for all Text'#13'Use $X, X being a number of the word you want to use.');
end;

procedure TFeatures.FormDestroy(Sender: TObject);
begin
  IRCMain.Aliases1.Enabled := True;
end;

procedure TFeatures.TabSheet2Show(Sender: TObject);
begin
  Self.Memo.Lines.Clear;
end;

procedure TFeatures.TabSheet1Show(Sender: TObject);
var
  I: Cardinal;
begin
  Self.Memo.Lines.Clear;
  For I := 0 to IRCMain.AliasList.Count - 1 Do Begin
    Self.Memo.SelText := IRCMain.AliasList.Strings[I];
    If (I <> IRCMain.AliasList.Count - 1) Then
      Self.Memo.SelText := #13#10;
  End;
end;

procedure TFeatures.TabSheet3Show(Sender: TObject);
begin
  Self.Memo.Lines.Clear;
end;

procedure TFeatures.TabSheet1Hide(Sender: TObject);
var
  I: Cardinal;
begin
  IRCMain.AliasList.Clear;
  For I := 0 To Self.Memo.Lines.Count - 1 Do
    IRCMain.AliasList.Add(Self.Memo.Lines[I]);
end;

end.
