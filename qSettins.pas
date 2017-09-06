unit qSettins;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Tokens, Buttons,
  lmdstdcA, lmdctrl, lmdbtn, ComCtrls;

type
  TSettins1 = class(TForm)
    Tabs: TPageControl;
    tab_srv: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Server: TComboBox;
    tab_ui: TTabSheet;
    GroupBox2: TGroupBox;
    tab_idnt: TTabSheet;
    GroupBox3: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    SysType: TEdit;
    PortText: TEdit;
    IdntText: TEdit;
    IDENT: TCheckBox;
    tab_bot: TTabSheet;
    GroupBox4: TGroupBox;
    Label11: TLabel;
    ListBox1: TListBox;
    AddB: TButton;
    DelB: TButton;
    tab_info: TTabSheet;
    GroupBox5: TGroupBox;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    IP: TLabel;
    HOST: TLabel;
    Offset: TLabel;
    LTU: TLabel;
    TU: TLabel;
    tab_other: TTabSheet;
    GroupBox6: TGroupBox;
    CheckLag: TCheckBox;
    Label18: TLabel;
    Bevel1: TBevel;
    UseRaw: TCheckBox;
    Bevel3: TBevel;
    UserLevel: TComboBox;
    Label20: TLabel;
    Bevel2: TBevel;
    UseHints: TCheckBox;
    Bevel4: TBevel;
    ShowSend: TCheckBox;
    ShowIdent: TCheckBox;
    RoundPing: TCheckBox;
    Bevel5: TBevel;
    UseLights: TCheckBox;
    Bevel6: TBevel;
    tab_sck: TTabSheet;
    GroupBox7: TGroupBox;
    UseSocks: TCheckBox;
    SocksServer: TComboBox;
    SAdd: TButton;
    SEdit: TButton;
    SDel: TButton;
    SSort: TButton;
    Label21: TLabel;
    tab_encr: TTabSheet;
    GroupBox8: TGroupBox;
    CheckBox1: TCheckBox;
    NickHighlight: TCheckBox;
    Bevel7: TBevel;
    Maintain: TBitBtn;
    Connect: TBitBtn;
    Add: TBitBtn;
    Edit: TBitBtn;
    Del: TBitBtn;
    Sort: TBitBtn;
    C1: TCheckBox;
    C2: TCheckBox;
    C3: TCheckBox;
    C4: TCheckBox;
    C5: TCheckBox;
    UseAway: TCheckBox;
    Label23: TLabel;
    Bevel8: TBevel;
    UseEnc: TCheckBox;
    Label24: TLabel;
    EncLevel: TComboBox;
    OK: TLMDExplorerButton;
    Cancel: TLMDExplorerButton;
    Help: TLMDExplorerButton;
    AwayMins: TLMDSpinEdit;
    LagSecs: TLMDSpinEdit;
    TabSheet1: TTabSheet;
    GroupBox9: TGroupBox;
    NickText: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    AltNickText: TEdit;
    RealText: TEdit;
    Label17: TLabel;
    QuitText: TEdit;
    Label4: TLabel;
    PartText: TEdit;
    Label5: TLabel;
    VersText: TEdit;
    Label6: TLabel;
    MailText: TEdit;
    Label7: TLabel;
    Label22: TLabel;
    AwayText: TEdit;
    Label25: TLabel;
    KickText: TEdit;
    Label26: TLabel;
    TabSheet2: TTabSheet;
    Label28: TLabel;
    SM: TLabel;
    StartMode: TComboBox;
    Label29: TLabel;
    Notice: TEdit;
    ListNames: TCheckBox;
    BeepNotice: TCheckBox;
    HidePing: TCheckBox;
    CancelAway: TCheckBox;
    Label27: TLabel;
    Size: TLabel;
    Con2Svr: TCheckBox;
    procedure OKClick(Sender: TObject);
    procedure IDENTClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure ConnectClick(Sender: TObject);
    procedure CheckLagClick(Sender: TObject);
    procedure UseRawMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure UseHintsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AddClick(Sender: TObject);
    procedure ShowSendMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CloseAdd;
    procedure CloseEdit;
    procedure EditClick(Sender: TObject);
    procedure DelClick(Sender: TObject);
    procedure UseSocksClick(Sender: TObject);
    procedure MaintainClick(Sender: TObject);
    procedure CloseMaintenance;
    procedure WndProc(var Message: TMessage); override;
    procedure ChangeColor(Sender: TObject; Msg: Integer);
    procedure SortClick(Sender: TObject);
    procedure UseAwayClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure SSortClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Settins1: TSettins1;

implementation

Uses qIRCMain, qAdd, qEdit, qMaintenance, qStatus, qSettings;

{$R *.DFM}

procedure TSettins1.OKClick(Sender: TObject);
begin
  If (Not IRCMain.IsNumeric(Self.LagSecs.Text)) Then
    Self.LagSecs.Text := '30';
  If (Not IRCMain.IsNumeric(Self.AwayMins.Text)) Then
    Self.AwayMins.Text := '10';
  If (Self.LagSecs.Text = '0') Then Begin
    Self.LagSecs.Text := '30';
    Self.CheckLag.Checked := False;
  End;

  IRCMain.SaveToRegistry;
  IRCMain.Settings.Enabled := True;
  IRCMain.Settings1.Enabled := True;
  IRCMain.UpdateSvrBox(Settins.Server.ItemIndex);
  Self.Hide;
end;

procedure TSettins1.IDENTClick(Sender: TObject);
begin
  IdntText.Enabled := IDENT.Checked;
  SysType.Enabled := IDENT.Checked;
  PortText.Enabled := IDENT.Checked;
  Label8.Enabled := IDENT.Checked;
  Label9.Enabled := IDENT.Checked;
  Label10.Enabled := IDENT.Checked;
  ShowIdent.Enabled := IDENT.Checked;
end;

procedure TSettins1.CancelClick(Sender: TObject);
begin
  IRCMain.LoadFromRegistry;
  IRCMain.Settings.Enabled := True;
  IRCMain.Settings1.Enabled := True;
  IRCMain.UpdateSvrBox(Settins.Server.ItemIndex);
  Self.Hide;
end;

procedure TSettins1.ConnectClick(Sender: TObject);
begin
  IRCMain.SaveToRegistry;
  Self.Hide;
  IRCMain.Settings.Enabled := True;
  IRCMain.Settings1.Enabled := True;
  IRCMain.InstantConnect('', '');
end;

procedure TSettins1.CheckLagClick(Sender: TObject);
begin
  LagSecs.Enabled := CheckLag.Checked;
  RoundPing.Enabled := CheckLag.Checked;
  Label18.Enabled := CheckLag.Checked;
end;

procedure TSettins1.UseRawMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  If (UserLevel.ItemIndex = 0) Then
    If (UseRaw.Checked) Then
      ShowMessage('You probably won''t need the the effect that this creates.');
end;

procedure TSettins1.UseHintsMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Application.ShowHint := UseHints.Checked;
end;

procedure TSettins1.AddClick(Sender: TObject);
begin
  Settins.Enabled := False;
  AddServer := TAddServer.Create(Settins);
end;

procedure TSettins1.ShowSendMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  If (UserLevel.ItemIndex = 0) Then
    If (ShowSend.Checked) Then ShowMessage('You probably won''t need the the effect that this creates.');
end;

procedure TSettins1.CloseAdd;
begin
  Settins.Enabled := True;
  Settins.SetFocus;
  AddServer.Release;
end;

procedure TSettins1.EditClick(Sender: TObject);
var
  I: Integer;
  Z: TTokenizer;
begin
  Settins.Enabled := False;
  EditServer := TEditServer.Create(Settins);
  I := Server.ItemIndex;
  Z := TTokenizer.Create;
  Z.TokenChr := #255;
  Z.InitTokenStr(IRCMain.ServerList.Strings[I]);
  EditServer.Desc.Text := Z.Token[0];
  EditServer.Host.Text := Z.Token[1];
  EditServer.Port.Text := Z.Token[2];
  EditServer.Pass.Text := Z.Token[3];
  Z.Free;
end;

procedure TSettins1.CloseEdit;
begin
  Settins.Enabled := True;
  Settins.SetFocus;
  EditServer.Release;
end;

procedure TSettins1.DelClick(Sender: TObject);
var
  I: Integer;
begin
  If (Settins.Server.Items.Count <> 0) Then Begin
    I := Settins.Server.ItemIndex;
    If (Ask('Are you sure you want to delete: "' + Settins.Server.Items[I] + '"?')) Then Begin
      IRCMain.ServerList.Delete(I);
      Settins.Server.Items.Delete(I);
      Dec(I);
      If (I < 0) Then I := 0;
      Settins.Server.ItemIndex := I;
      IRCMain.UpdateSvrBox(Settins.Server.ItemIndex);
    End;
  End Else
    ShowMessage('The server list is empty!');
end;

procedure TSettins1.UseSocksClick(Sender: TObject);
begin
  SocksServer.Enabled := UseSocks.Checked;
  SAdd.Enabled := UseSocks.Checked;
  SEdit.Enabled := UseSocks.Checked;
  SDel.Enabled := UseSocks.Checked;
  SSort.Enabled := UseSocks.Checked;
end;

procedure TSettins1.MaintainClick(Sender: TObject);
begin
  Settins.Enabled := False;
  Maintenance := TMaintenance.Create(Settins);
end;

procedure TSettins1.CloseMaintenance;
begin
  Settins.Enabled := True;
  Settins.SetFocus;
  Maintenance.Release;
end;

procedure TSettins1.WndProc(var Message : TMessage);
begin
  If (Message.LParam = LongInt(OK)) Then
    ChangeColor(OK, Message.Msg);
  If (Message.LParam = LongInt(Cancel)) Then
    ChangeColor(Cancel, Message.Msg);
  If (Message.LParam = LongInt(Help)) Then
    ChangeColor(Help, Message.Msg);

  Inherited WndProc(Message);
end;

procedure TSettins1.ChangeColor(Sender : TObject; Msg : Integer);
Begin
  If (Sender Is TBitBtn) Then Begin
    If (Msg = CM_MOUSELEAVE) Then
      (Sender As TBitBtn).Font.Color := clWindowText;
    If (Msg = CM_MOUSEENTER) Then Begin
      (Sender As TBitBtn).Font.Color := clRed;
    End;
  End;
End;

procedure TSettins1.SortClick(Sender: TObject);
begin
  ShowMessage('Not implimented yet!');
end;

procedure TSettins1.UseAwayClick(Sender: TObject);
begin
  Self.AwayMins.Enabled := Self.UseAway.Checked;
  Self.Label23.Enabled := Self.UseAway.Checked;
end;

procedure TSettins1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := False;
end;

procedure TSettins1.SSortClick(Sender: TObject);
begin
  ShowMessage('help');
end;

end.
