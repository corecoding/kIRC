unit qMaintenance;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Registry;

type
  TMaintenance = class(TForm)
    Regather: TButton;
    Button2: TButton;
    Close: TButton;
    GroupBox1: TGroupBox;
    procedure Button2Click(Sender: TObject);
    procedure CloseClick(Sender: TObject);
    procedure RegatherClick(Sender: TObject);
  private
    FIniFile: TRegIniFile;
  public
    { Public declarations }
  end;

var
  Maintenance: TMaintenance;

implementation

uses qIRCMain, qSettins, qSettings;

{$R *.DFM}

procedure TMaintenance.Button2Click(Sender: TObject);
begin
  Settins.Server.Clear;
  IRCMain.StartNew;
  IRCMain.UpdateSvrBox(Settins.Server.ItemIndex);  
  ShowMessage('Defaults were loaded.  If you wish to UNDO'#13'this, please click Cancel down below.');
end;

procedure TMaintenance.CloseClick(Sender: TObject);
begin
  Settins.CloseMaintenance;
end;

procedure TMaintenance.RegatherClick(Sender: TObject);

Var
  Done    : Boolean;
  I       : Integer;
  P       : Integer;
  Tmp     : String;

begin
  ShowMessage('fix me');
  Exit;
  Done := False;
  FIniFile := TRegIniFile.Create('Software');
  P := Settins.Server.Items.Count;
  I := P;
  Repeat
    Tmp := IRCMain.ReadStr('Servers', 'Server_' + IntToStr(I));
    If (Tmp = '') Then Break;
    IRCMain.AddToServerList(Tmp);
    Inc(I);
  Until Done;
  If (P = I) Then
    ShowMessage('No previous servers found.  Sorry!')
  Else
    ShowMessage('Found ' + IntToStr(I - P) + ' previous servers.');
  Settins.Server.ItemIndex := FIniFile.ReadInteger('Servers', 'Selected', 0);
  FIniFile.Free;
end;

end.
