unit qDccAccept;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons;

type
  TDccAccept = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Yes: TBitBtn;
    No: TBitBtn;
    From: TLabel;
    Filename: TLabel;
    Size: TLabel;
    procedure WndProc(var Message: TMessage); override;
    procedure ChangeColor(Sender: TObject; Msg: Integer);
    procedure NoClick(Sender: TObject);
    procedure YesClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DccAccept: TDccAccept;

implementation

uses qDccGet;

{$R *.DFM}

procedure TDccAccept.WndProc(var Message : TMessage);
begin
  If (Message.LParam = LongInt(No)) Then
    ChangeColor(No, Message.Msg);
  If (Message.LParam = LongInt(Yes)) Then
    ChangeColor(Yes, Message.Msg);

  Inherited WndProc(Message);
end;

procedure TDccAccept.ChangeColor(Sender : TObject; Msg : Integer);
Begin
  If (Sender Is TBitBtn) Then Begin
    If (Msg = CM_MOUSELEAVE) Then
      (Sender As TBitBtn).Font.Color := clWindowText;
    If (Msg = CM_MOUSEENTER) Then Begin
      (Sender As TBitBtn).Font.Color := clRed;
    End;
  End;
End;

procedure TDccAccept.NoClick(Sender: TObject);
begin
  Self.Release;
end;

procedure TDccAccept.YesClick(Sender: TObject);
var
  Host, Size, Filename, Nick: String;
begin
  Application.CreateForm(TDccGet, DccGet);
  Host := Self.From.Caption;
  Delete(Host, 1, Pos('@', Host));
  Delete(Host, Length(Host), 1);
  Size := Self.Size.Caption;
  Delete(Size, 1, Pos(' ', Size));
  Filename := Self.Filename.Caption;
  Delete(Filename, 1, Pos(' ', Filename));
  Nick := Self.From.Caption;
  Delete(Nick, 1, 6);
  Nick := Copy(Nick, 1, Pos(' ', Nick));
  DccGet.GetFile(Nick, Filename, Host, Self.Tag, StrToInt(Size));

  Self.Release;
end;

procedure TDccAccept.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := False;
end;

end.
