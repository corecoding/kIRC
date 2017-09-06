unit qDcc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, WSocket, Gauges, Buttons,
  ExtCtrls;

type
  TDccSend = class(TForm)
    Percent: TGauge;
    WSocket1: TWSocket;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Filename: TLabel;
    Size: TLabel;
    Timeleft: TLabel;
    Label4: TLabel;
    Status: TLabel;
    Label5: TLabel;
    Sent: TLabel;
    Label6: TLabel;
    Actual: TLabel;
    Close: TBitBtn;
    Timer1: TTimer;
    Timer2: TTimer;
    CPS: TLabel;
    function SendFile(Nick, Fle, IP: String): String;
    procedure CloseClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure WSocket1SessionAvailable(Sender: TObject; Error: Word);
    procedure WSocket1ChangeState(Sender: TObject; OldState,
      NewState: TSocketState);
    procedure WSocket1DataAvailable(Sender: TObject; Error: Word);
    procedure FormCreate(Sender: TObject);
    procedure WndProc(var Message: TMessage); override;
    procedure ChangeColor(Sender: TObject; Msg: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure WSocket1SessionClosed(Sender: TObject; Error: Word);
    procedure Timer2Timer(Sender: TObject);
    function Avg: Integer;
  private
    { Private declarations }
  public
    InData: String;
    Counter: Byte;
    DeCPS: Array[1..10] Of Integer;
    DePos: Byte;
    DeTimeOut: Byte;
//tues at 8
    { Public declarations }
  end;

var
  DccSend: TDccSend;

implementation

uses qIRCMain;

{$R *.DFM}

function TDccSend.SendFile(Nick, Fle, IP: String): String;
var
  K: String;
  PORT: Integer;
  F: File of Char;
begin
  If (Not FileExists(Fle)) Then Self.Release;
  Self.Caption := 'DCC To ' + Nick;
  K := IntToStr(IRCMain.IpToInt(IP));
  Randomize;
  PORT := Random(60000) + 2000;

  AssignFile(F, Fle);
  Reset(F);
  Self.Filename.Caption := Fle;
  Self.Size.Caption := IntToStr(FileSize(F));
  CloseFile(F);  
  Result := 'PRIVMSG ' + Nick + ' :DCC SEND ' + ExtractFileName(Fle) + ' ' + K + ' ' + IntToStr(PORT) + ' ' + Self.Size.Caption + '';
  Self.Status.Caption := 'Waiting for remote user.';

  WSocket1.Close;
  WSocket1.Addr := '0.0.0.0';
  WSocket1.Port := IntToStr(PORT);
  WSocket1.Listen;
end;

procedure TDccSend.CloseClick(Sender: TObject);
begin
  WSocket1.Close;
  Self.Release;
end;

procedure TDccSend.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := False;
end;

procedure TDccSend.WSocket1SessionAvailable(Sender: TObject; Error: Word);
begin
  WSocket1.HSocket := WSocket1.Accept;
  Self.Status.Caption := 'Acknowledge from remote user.';
end;

procedure TDccSend.WSocket1ChangeState(Sender: TObject; OldState,
  NewState: TSocketState);
var
  F: File of Char;
  Ch: Array[1..1024] Of Char;
  HowMuch, X: Cardinal;
begin
  If (WSocket1.State = wsConnected) Then Begin
    Timer2.Enabled := True;
    Self.Status.Caption := 'Session established.';
    AssignFile(F, Self.Filename.Caption);
    Reset(F);
    X := 0;
    While (Not Eof(F)) Do Begin
      If ((StrToInt(Self.Actual.Caption) + (1024 * 5)) > X) Then Begin
        BlockRead(F, Ch, SizeOf(Ch), HowMuch);
        Inc(X, HowMuch);
        WSocket1.Send(Addr(Ch), HowMuch);
      End;
      Application.ProcessMessages;
      Self.Sent.Caption := IntToStr(X);
    End;
    CloseFile(F);
    If (X = 0) Then Begin
      WSocket1.Close;
      Self.Status.Caption := 'Transfer completed!';
      Timer1.Enabled := True;
    End;
  End;
end;

procedure TDccSend.WSocket1DataAvailable(Sender: TObject; Error: Word);
var
  X: Cardinal;
  Y: Array[1..4] of Char;
begin
  InData := InData + WSocket1.ReceiveStr;
  DeTimeOut := 0;
  While (Length(InData) <> 0) Do Begin
    Y[1] := InData[4];
    Y[2] := InData[3];
    Y[3] := InData[2];
    Y[4] := InData[1];
    Move(Y, X, SizeOf(Cardinal));

    Inc(DeCPS[DePos], X - StrToInt(Self.Actual.Caption));

    Self.Actual.Caption := IntToStr(X);
    Percent.Progress := Trunc((StrToInt(Self.Actual.Caption) / StrToInt(Self.Size.Caption)) * 100);
    Delete(InData, 1, 4);
  End;
  If (X = StrToInt(Self.Size.Caption)) Then Begin
    WSocket1.Close;
    Self.Status.Caption := 'Transfer completed!';
    Counter := 0;
    Timer1.Enabled := True;
  End;
end;

procedure TDccSend.FormCreate(Sender: TObject);
begin
  InData := '';
  DePos := 0;
  DeTimeOut := 0;
end;

procedure TDccSend.WndProc(var Message : TMessage);
begin
  If (Message.LParam = LongInt(Close)) Then
    ChangeColor(Close, Message.Msg);

  Inherited WndProc(Message);
end;

procedure TDccSend.ChangeColor(Sender : TObject; Msg : Integer);
Begin
  If (Sender Is TBitBtn) Then Begin
    If (Msg = CM_MOUSELEAVE) Then
      (Sender As TBitBtn).Font.Color := clWindowText;
    If (Msg = CM_MOUSEENTER) Then Begin
      (Sender As TBitBtn).Font.Color := clRed;
    End;
  End;
End;

procedure TDccSend.Timer1Timer(Sender: TObject);
begin
  If (Counter = 5) Then
    Self.Status.Caption := 'Closing in 5 secs...';
  If (Counter = 10) Then Begin
    WSocket1.Close;
    Self.Release;
  End;
  Inc(Counter);
end;

procedure TDccSend.WSocket1SessionClosed(Sender: TObject; Error: Word);
begin
  Timer2.Enabled := False;
  Self.Status.Caption := 'Transfer error';
  Counter := 0;
  Timer1.Enabled := True;
end;

procedure TDccSend.Timer2Timer(Sender: TObject);
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

  Self.CPS.Caption := IntToStr(Avg);
end;

function TDccSend.Avg: Integer;
var
  I, Amt: Integer;
begin
  Amt := 0;
  For I := 1 To 10 Do
    Inc(Amt, DeCPS[I]);
  Result := Amt Div 10;
end;

end.
