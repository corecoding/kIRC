unit qWelcome;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, lmdctrl, lmdstdcS;

type
  TWelcome = class(TForm)
    DeText: TLMDLabel;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    RegBtn: TRadioButton;
    IniBtn: TRadioButton;
    ProBtn: TButton;
    Label4: TLabel;
    LaterBtn: TButton;
    ExistingBtn: TRadioButton;
    procedure LaterBtnClick(Sender: TObject);
    procedure ProBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Welcome: TWelcome;

implementation

uses qIRCMain;

{$R *.DFM}

procedure TWelcome.LaterBtnClick(Sender: TObject);
begin
  If (Ask('Are you sure you want to cancel the setup of ' + IRCMain.APPNAME + '?')) Then
  Begin
    IRCMain.WData := '3';
  End;
end;

procedure TWelcome.ProBtnClick(Sender: TObject);
begin
  If (Self.RegBtn.Checked) Then
    IRCMain.WData := '1';
  If (Self.IniBtn.Checked) Then
    IRCMain.WData := '0';
  If (Self.ExistingBtn.Checked) Then
    IRCMain.WData := '2';
end;

procedure TWelcome.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := False;
end;

end.
