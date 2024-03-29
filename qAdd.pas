unit qAdd;

interface

uses
  Windows, SysUtils, Classes, Forms, StdCtrls, Controls;

type
  TAddServer = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Desc: TEdit;
    Host: TEdit;
    Port: TEdit;
    Pass: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Cancel: TButton;
    Add: TButton;
    procedure AddClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AddServer: TAddServer;

implementation

uses qSettins, qIRCMain, qSettings;

{$R *.DFM}

procedure TAddServer.AddClick(Sender: TObject);
begin
  If (Desc.Text = '') Then Begin Beep; Desc.SetFocus; Exit; End;
  If (Host.Text = '') Then Begin Beep; Host.SetFocus; Exit; End;
  If (Port.Text = '') Then Begin Beep; Port.SetFocus; Exit; End;
  IRCMain.ServerList.Add(Desc.Text + #255 + Host.Text + #255 + Port.Text + #255 + Pass.Text);
  Settins.Server.ItemIndex := Settins.Server.Items.Add(Desc.Text);
  IRCMain.UpdateSvrBox(Settins.Server.ItemIndex);  
  Settins.CloseAdd;
end;

procedure TAddServer.CancelClick(Sender: TObject);
begin
  Settins.CloseAdd;
end;

procedure TAddServer.FormActivate(Sender: TObject);
begin
  Port.Text := '6667';
end;

end.
