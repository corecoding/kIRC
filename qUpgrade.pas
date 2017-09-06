unit qUpgrade;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, WSocket, StdCtrls;

type
  TUpgradeCheck = class(TForm)
    WSocket1: TWSocket;
    GroupBox1: TGroupBox;
    Status: TLabel;
    Upgrade: TButton;
    Cancel: TButton;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  UpgradeCheck: TUpgradeCheck;

implementation

{$R *.DFM}

procedure TUpgradeCheck.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := False;
  Self.Release;
end;

procedure TUpgradeCheck.CancelClick(Sender: TObject);
begin
  Self.Release;
end;

end.
