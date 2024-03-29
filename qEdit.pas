unit qEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  StdCtrls;

type
  TEditServer = class(TForm)
    Desc: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Host: TEdit;
    Port: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Pass: TEdit;
    Save: TButton;
    Cancel: TButton;
    procedure SaveClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EditServer: TEditServer;

implementation

uses qSettins, qIRCMain, qSettings;

{$R *.DFM}

procedure TEditServer.SaveClick(Sender: TObject);
var
  I: Integer;
begin
  If (Desc.Text = '') Then Begin Beep; Desc.SetFocus; Exit; End;
  If (Host.Text = '') Then Begin Beep; Host.SetFocus; Exit; End;
  If (Port.Text = '') Then Begin Beep; Port.SetFocus; Exit; End;
  I := Settins.Server.ItemIndex;
  Settins.Server.Items[I] := Desc.Text;
  IRCMain.ServerList.Strings[I] := Desc.Text + #255 + Host.Text + #255 + Port.Text + #255 + Pass.Text;
  Settins.Server.ItemIndex := I;
  IRCMain.UpdateSvrBox(Settins.Server.ItemIndex);
  Settins.CloseEdit;
end;

procedure TEditServer.CancelClick(Sender: TObject);
begin
  Settins.CloseEdit;
end;

end.
