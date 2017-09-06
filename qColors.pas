unit qColors;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, RichEdit2, Buttons, ExtCtrls;

type
  TColors = class(TForm)
    OK: TBitBtn;
    Cancel: TBitBtn;
    Defaults: TBitBtn;
    Help: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    procedure WndProc(var Message: TMessage); override;
    procedure ChangeColor(Sender: TObject; Msg: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure OKClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure MainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Label1Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    Pos: Byte;
  end;

var
  Colors: TColors;

implementation

uses qIRCMain;

{$R *.DFM}

procedure TColors.WndProc(var Message : TMessage);
begin
  If (Message.LParam = LongInt(OK)) Then
    ChangeColor(OK, Message.Msg);
  If (Message.LParam = LongInt(Cancel)) Then
    ChangeColor(Cancel, Message.Msg);
  If (Message.LParam = LongInt(Defaults)) Then
    ChangeColor(Defaults, Message.Msg);
  If (Message.LParam = LongInt(Help)) Then
    ChangeColor(Help, Message.Msg);

  Inherited WndProc(Message);
end;

procedure TColors.ChangeColor(Sender : TObject; Msg : Integer);
Begin
  If (Sender Is TBitBtn) Then Begin
    If (Msg = CM_MOUSELEAVE) Then
      (Sender As TBitBtn).Font.Color := clWindowText;
    If (Msg = CM_MOUSEENTER) Then Begin
      (Sender As TBitBtn).Font.Color := clRed;
    End;
  End;
End;

procedure TColors.FormCreate(Sender: TObject);
begin
  Pos := 1;
  IRCMain.Colors1.Enabled := False;
end;

procedure TColors.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := False;
end;

procedure TColors.OKClick(Sender: TObject);
begin
  Self.Release;
end;

procedure TColors.CancelClick(Sender: TObject);
begin
  Self.Release;
end;

procedure TColors.MainMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Self.OK.SetFocus;
end;

procedure TColors.Label1Click(Sender: TObject);
begin
  Pos := 1;
end;

procedure TColors.Label2Click(Sender: TObject);
begin
  Pos := 2;
end;

procedure TColors.FormDestroy(Sender: TObject);
begin
  IRCMain.Colors1.Enabled := True;
end;

end.
