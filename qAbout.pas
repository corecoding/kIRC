unit qAbout;

interface

uses
  Windows, SysUtils, Classes, Graphics, Forms, Controls,
  StdCtrls, Buttons, qIRCMain, Messages, Dialogs, ExtCtrls,
  lmdctrl, lmdbtn, lmdextcA;

type
  TAboutBox = class(TForm)
    Comments: TLabel;
    ProgramIcon: TImage;
    ScrollWindow: TLMDGraphicLabel;
    Timer1: TTimer;
    CloseBtn: TLMDExplorerButton;
    procedure OKButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseMe;
    procedure CloseBtnClick(Sender: TObject);
  private
    Count   : Integer;
    Str     : String;
  public
  end;

var
  AboutBox: TAboutBox;

implementation

{$R *.DFM}

procedure TAboutBox.OKButtonClick(Sender: TObject);
begin
  Self.Release;
end;

procedure TAboutBox.FormCreate(Sender: TObject);
begin
  IRCMain.About.Enabled := False;
  IRCMain.About1.Enabled := False;
//  SetWindowRgn(AboutBox.Handle, CreateEllipticRgn(10, 10, 300, 200), True);
  Str := '                    ' + Application.Title + ' ' + IRCMain.VER + ' by Christopher Monahan ';
  Count := 0;
end;

procedure TAboutBox.Timer1Timer(Sender: TObject);
begin
  Inc(Count);
  If (Count = Length(Str)) Then
  Begin
    Count := 1;
    Randomize;
    ScrollWindow.Font.Color := RGB(Random(200), Random(200), Random(200));
  End;
  ScrollWindow.Caption := Copy(Str, Count, 20);
end;

procedure TAboutBox.FormDestroy(Sender: TObject);
begin
  CloseMe;
end;

procedure TAboutBox.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CloseMe;
end;

procedure TAboutBox.CloseMe;
begin
  IRCMain.About.Enabled := True;
  IRCMain.About1.Enabled := True;
end;

procedure TAboutBox.CloseBtnClick(Sender: TObject);
begin
  Self.Release;
end;

end.

