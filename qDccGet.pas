unit qDccGet;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, Gauges, WSocket, StdCtrls, Buttons,
  ExtCtrls;

type
  TDccGet = class(TForm)
    Close: TBitBtn;
    Label1: TLabel;
    Filename: TLabel;
    Size: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Received: TLabel;
    Label3: TLabel;
    Timeleft: TLabel;
    Status: TLabel;
    Label4: TLabel;
    WSocket1: TWSocket;
    Percent: TGauge;
    Timer1: TTimer;
    Timer2: TTimer;
    CPS: TLabel;
    procedure WndProc(var Message: TMessage); override;
    procedure ChangeColor(Sender: TObject; Msg: Integer);
    procedure GetFile(Nick, Fle, Host: String; Port: Integer; Size: Cardinal);
    procedure WSocket1SessionConnected(Sender: TObject; Error: Word);
    procedure WSocket1SessionClosed(Sender: TObject; Error: Word);
    procedure FormCreate(Sender: TObject);
    procedure WSocket1DataAvailable(Sender: TObject; Error: Word);
    procedure Send(A: String);
    procedure CloseClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Timer2Timer(Sender: TObject);
    function Avg: Integer;
  private
  public
    AmountGot, OldAmount: Cardinal;
    F: File Of Char;
    DeCPS: Array[1..10] Of Integer;
    DePos: Byte;
    DeTimeOut: Byte;
  end;

var
  DccGet: TDccGet;

implementation

{$R *.DFM}

procedure TDccGet.GetFile(Nick, Fle, Host: String; Port: Integer; Size: Cardinal);
begin
  Self.Caption := 'DCC From ' + Nick;
  Fle := ExtractFileName(Fle);
  AssignFile(F, 'C:\' + Fle);
  Rewrite(F);
  Self.Size.Caption := IntToStr(Size);
  Self.Filename.Caption := Fle;
  Self.Status.Caption := 'Connecting to remote host.';
  WSocket1.Addr := Host;
  WSocket1.Port := IntToStr(Port);
  WSocket1.Connect;
end;

procedure TDccGet.WndProc(var Message : TMessage);
begin
  If (Message.LParam = LongInt(Close)) Then
    ChangeColor(Close, Message.Msg);

  Inherited WndProc(Message);
end;

procedure TDccGet.ChangeColor(Sender : TObject; Msg : Integer);
Begin
  If (Sender Is TBitBtn) Then Begin
    If (Msg = CM_MOUSELEAVE) Then
      (Sender As TBitBtn).Font.Color := clWindowText;
    If (Msg = CM_MOUSEENTER) Then Begin
      (Sender As TBitBtn).Font.Color := clRed;
    End;
  End;
End;

procedure TDccGet.WSocket1SessionConnected(Sender: TObject; Error: Word);
begin
  Self.Status.Caption := 'Session established!';
  Timer2.Enabled := True;
end;

procedure TDccGet.WSocket1SessionClosed(Sender: TObject; Error: Word);
begin
  If (AmountGot = StrToInt(Self.Size.Caption)) Then Begin
    Self.Status.Caption := 'File transfer complete!';
  End Else
    Self.Status.Caption := 'File transfer error!';
  CloseFile(F);
  Timer1.Enabled := True;
  AmountGot := 0;
  Timer2.Enabled := False;
end;

procedure TDccGet.FormCreate(Sender: TObject);
begin
  Self.AmountGot := 0;
  DePos := 0;
  DeTimeOut := 0;
end;

procedure TDccGet.WSocket1DataAvailable(Sender: TObject; Error: Word);
var
  S: String;
  G, K: Array[1..4] of Char;
  I: Integer;
begin
  S := WSocket1.ReceiveStr;
  If (Length(S) = 0) Then Exit;
  OldAmount := AmountGot;
  For I := 1 To Length(S) Do Begin
    Write(F, S[I]);
    Inc(AmountGot);
  End;
  Self.Percent.Progress := Trunc((AmountGot / StrToInt(Self.Size.Caption)) * 100);
  Self.Received.Caption := IntToStr(AmountGot);

  Move(AmountGot, G, SizeOf(Cardinal));
  K[1] := G[4];
  K[2] := G[3];
  K[3] := G[2];
  K[4] := G[1];
  Self.Send(K);

  DeTimeOut := 0;
  DeCPS[DePos] := AmountGot - OldAmount;
  Self.CPS.Caption := IntToStr(Avg);

  Application.ProcessMessages;
end;

procedure TDccGet.Send(A: String);
begin
  If (WSocket1.State = wsConnected) Then
    WSocket1.SendStr(A);
end;

procedure TDccGet.CloseClick(Sender: TObject);
begin
  WSocket1.Close;
  CloseFile(F);
  Self.Release;
end;

procedure TDccGet.Timer1Timer(Sender: TObject);
begin
  If (AmountGot = 5) Then
    Self.Status.Caption := 'Closing in 5 secs...';
  If (AmountGot = 10) Then Begin
    WSocket1.Close;
    Self.Release;
  End;
  Inc(AmountGot);
end;

procedure TDccGet.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := False;
end;

procedure TDccGet.Timer2Timer(Sender: TObject);
var
  I: Integer;
begin
  Inc(DePos);
  Inc(DeTimeOut);
  If (DePos = 11) Then DePos := 1;
  I := DePos + 1;
  If (I = 11) Then I := 1;
  If (DeTimeOut > 1) Then
    DeCPS[I] := 0;
end;

function TDccGet.Avg: Integer;
var
  I, Amt: Integer;
begin
  Amt := 0;
  For I := 1 To 10 Do
    Inc(Amt, DeCPS[I]);
  Result := Amt Div 10;
end;

end.
