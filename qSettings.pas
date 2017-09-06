unit qSettings;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, AnimBtn, lmdctrl, lmdbtn, ExtCtrls,
  CoolForm, StdCtrls, ComCtrls, RichEdit2,
  Buttons, Tokens, lmdclass, lmdformA, lmdstdcA;

type
  TSettins = class(TForm)
    Selector: TTreeView;
    Tabs: TPageControl;
    tab_srv: TTabSheet;
    Server: TComboBox;
    tab_ui: TTabSheet;
    tab_idnt: TTabSheet;
    tab_sck: TTabSheet;
    TabSheet1: TTabSheet;
    tab_other: TTabSheet;
    TabSheet2: TTabSheet;
    Label29: TLabel;
    StartMode: TComboBox;
    ListNames: TCheckBox;
    BeepNotice: TCheckBox;
    HidePing: TCheckBox;
    CancelAway: TCheckBox;
    Con2Svr: TCheckBox;
    tab_encr: TTabSheet;
    tab_bot: TTabSheet;
    tab_info: TTabSheet;
    Label1: TLabel;
    Add: TBitBtn;
    Edit: TBitBtn;
    Del: TBitBtn;
    Sort: TBitBtn;
    Connect: TBitBtn;
    Maintain: TBitBtn;
    UseEnc: TCheckBox;
    Label24: TLabel;
    EncLevel: TComboBox;
    Label2: TLabel;
    NickText: TEdit;
    AltNickText: TEdit;
    Label3: TLabel;
    Label17: TLabel;
    RealText: TEdit;
    IDENT: TCheckBox;
    Label8: TLabel;
    IdntText: TEdit;
    SysType: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    PortText: TEdit;
    ShowIdent: TCheckBox;
    UseSocks: TCheckBox;
    SocksServer: TComboBox;
    SEdit: TButton;
    SAdd: TButton;
    SDel: TButton;
    SSort: TButton;
    Label21: TLabel;
    CheckBox1: TCheckBox;
    QuitText: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    PartText: TEdit;
    VersText: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    MailText: TEdit;
    AwayText: TEdit;
    Label22: TLabel;
    Label25: TLabel;
    KickText: TEdit;
    Label12: TLabel;
    IP: TLabel;
    HOST: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Offset: TLabel;
    LTU: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    TU: TLabel;
    SM: TLabel;
    Label28: TLabel;
    Label27: TLabel;
    Size: TLabel;
    ListBox1: TListBox;
    Label11: TLabel;
    AddB: TButton;
    DelB: TButton;
    CheckLag: TCheckBox;
    LagSecs: TLMDSpinEdit;
    Label18: TLabel;
    RoundPing: TCheckBox;
    UseLights: TCheckBox;
    C1: TCheckBox;
    C2: TCheckBox;
    C3: TCheckBox;
    C4: TCheckBox;
    C5: TCheckBox;
    Label26: TLabel;
    Label23: TLabel;
    AwayMins: TLMDSpinEdit;
    UseAway: TCheckBox;
    NickHighlight: TCheckBox;
    UseHints: TCheckBox;
    Label20: TLabel;
    UserLevel: TComboBox;
    ShowSend: TCheckBox;
    UseRaw: TCheckBox;
    Bevel3: TBevel;
    Bevel2: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Bevel8: TBevel;
    Bevel7: TBevel;
    Bevel6: TBevel;
    Bevel1: TBevel;
    Notice: TEdit;
    OK: TLMDExplorerButton;
    Cancel: TLMDExplorerButton;
    Help: TLMDExplorerButton;
    CoolForm1: TCoolForm;
    Caption: TLabel;
    LMDFormShadow1: TLMDFormShadow;
    procedure SelectorClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CloseAdd;
    procedure CloseEdit;
    procedure CloseMaintenance;
    procedure OKClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure HelpClick(Sender: TObject);
    procedure AddClick(Sender: TObject);
    procedure EditClick(Sender: TObject);
    procedure DelClick(Sender: TObject);
    procedure SortClick(Sender: TObject);
    procedure ConnectClick(Sender: TObject);
    procedure MaintainClick(Sender: TObject);
    procedure IDENTClick(Sender: TObject);
    procedure UseSocksClick(Sender: TObject);
    procedure SAddClick(Sender: TObject);
    procedure SEditClick(Sender: TObject);
    procedure SDelClick(Sender: TObject);
    procedure SSortClick(Sender: TObject);
    procedure CheckLagClick(Sender: TObject);
    procedure UseRawClick(Sender: TObject);
    procedure ShowSendClick(Sender: TObject);
    procedure UseHintsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure UseAwayClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Settins: TSettins;

implementation

uses qAdd, qEdit, qMaintenance, qIRCMain;

{$R *.DFM}

procedure FrameWindow(Wnd: HWnd);
var
  Rect: TRect;
  DC: hDC;
  OldPen, Pen: hPen;
  OldBrush, Brush: hBrush;
  X2, Y2: Integer;
begin
  { Get the target window's rect and DC }
  GetWindowRect(Wnd, Rect);
  DC := GetWindowDC(Wnd);
  { Set ROP appropriately for highlighting }
  SetROP2(DC, R2_NOT);
  { Select brush and pen }
  Pen := CreatePen(PS_InsideFrame, 4, 0);
  OldPen := SelectObject(DC, Pen);
  Brush := GetStockObject(Null_Brush);
  OldBrush := SelectObject(DC, Brush);
  { Set dimensions of highlight }
  X2 := Rect.Right - Rect.Left;
  Y2 := Rect.Bottom - Rect.Top;
  { Draw highlight box }
  Rectangle(DC, 0, 0, X2, Y2);
  { Clean up }
  SelectObject(DC, OldBrush);
  SelectObject(DC, OldPen);
  ReleaseDC(Wnd, DC);
  { Do NOT delete the brush, because it was a stock object }
  DeleteObject(Pen);
end;

procedure TSettins.SelectorClick(Sender: TObject);
var
  DeItem           : TTreeNode;
begin
  DeItem := Selector.Selected;
  If (DeItem.Text = 'Connectivity') Then
    Self.Tabs.ActivePage := tab_srv;
  If (DeItem.Text = 'IDENT') Then
    Self.Tabs.ActivePage := tab_idnt;
  If (DeItem.Text = 'User info') Then
    Self.Tabs.ActivePage := tab_ui;
  If (DeItem.Text = 'Firewall') Then
    Self.Tabs.ActivePage := tab_sck;
  If (DeItem.Text = 'Replies') Then
    Self.Tabs.ActivePage := TabSheet1;
  If (DeItem.Text = 'Bot') Then
    Self.Tabs.ActivePage := tab_bot;
  If (DeItem.Text = 'Encryption') Then
    Self.Tabs.ActivePage := tab_encr;
  If (DeItem.Text = 'Info') Then
    Self.Tabs.ActivePage := tab_info;
  If (DeItem.Text = 'Options #1') Then
    Self.Tabs.ActivePage := tab_other;
  If (DeItem.Text = 'Options #2') Then
    Self.Tabs.ActivePage := TabSheet2;
end;

procedure TSettins.FormCreate(Sender: TObject);
begin
  Self.Tabs.Height := Self.Selector.Height;
  FrameWindow(Self.handle);
end;

procedure TSettins.CloseAdd;
begin
  Settins.Enabled := True;
  Settins.SetFocus;
  AddServer.Release;
end;

procedure TSettins.CloseEdit;
begin
  Settins.Enabled := True;
  Settins.SetFocus;
  EditServer.Release;
end;

procedure TSettins.CloseMaintenance;
begin
  Settins.Enabled := True;
  Settins.SetFocus;
  Maintenance.Release;
end;

procedure TSettins.OKClick(Sender: TObject);
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

procedure TSettins.CancelClick(Sender: TObject);
begin
  IRCMain.LoadFromRegistry;
  IRCMain.Settings.Enabled := True;
  IRCMain.Settings1.Enabled := True;
  IRCMain.UpdateSvrBox(Settins.Server.ItemIndex);
  Self.Hide;
end;

procedure TSettins.HelpClick(Sender: TObject);
begin
  ShowMessage('help');
end;

procedure TSettins.AddClick(Sender: TObject);
begin
  Settins.Enabled := False;
  AddServer := TAddServer.Create(Settins);
end;

procedure TSettins.EditClick(Sender: TObject);
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

procedure TSettins.DelClick(Sender: TObject);
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

procedure TSettins.SortClick(Sender: TObject);
begin
  ShowMessage('Not implimented yet!');
end;

procedure TSettins.ConnectClick(Sender: TObject);
begin
  IRCMain.SaveToRegistry;
  Self.Hide;
  IRCMain.Settings.Enabled := True;
  IRCMain.Settings1.Enabled := True;
  IRCMain.InstantConnect('', '');
end;

procedure TSettins.MaintainClick(Sender: TObject);
begin
  Settins.Enabled := False;
  Maintenance := TMaintenance.Create(Settins);
end;

procedure TSettins.IDENTClick(Sender: TObject);
begin
  IdntText.Enabled := IDENT.Checked;
  SysType.Enabled := IDENT.Checked;
  PortText.Enabled := IDENT.Checked;
  Label8.Enabled := IDENT.Checked;
  Label9.Enabled := IDENT.Checked;
  Label10.Enabled := IDENT.Checked;
  ShowIdent.Enabled := IDENT.Checked;
end;

procedure TSettins.UseSocksClick(Sender: TObject);
begin
  SocksServer.Enabled := UseSocks.Checked;
  SAdd.Enabled := UseSocks.Checked;
  SEdit.Enabled := UseSocks.Checked;
  SDel.Enabled := UseSocks.Checked;
  SSort.Enabled := UseSocks.Checked;
end;

procedure TSettins.SAddClick(Sender: TObject);
begin
  Settins.Enabled := False;
  AddServer := TAddServer.Create(Settins);
end;

procedure TSettins.SEditClick(Sender: TObject);
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

procedure TSettins.SDelClick(Sender: TObject);
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

procedure TSettins.SSortClick(Sender: TObject);
begin
  ShowMessage('help');
end;

procedure TSettins.CheckLagClick(Sender: TObject);
begin
  LagSecs.Enabled := CheckLag.Checked;
  RoundPing.Enabled := CheckLag.Checked;
  Label18.Enabled := CheckLag.Checked;
end;

procedure TSettins.UseRawClick(Sender: TObject);
begin
  If (UserLevel.ItemIndex = 0) Then
    If (UseRaw.Checked) Then
      ShowMessage('You probably won''t need the the effect that this creates.');
end;

procedure TSettins.ShowSendClick(Sender: TObject);
begin
  If (UserLevel.ItemIndex = 0) Then
    If (ShowSend.Checked) Then ShowMessage('You probably won''t need the the effect that this creates.');
end;

procedure TSettins.UseHintsMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Application.ShowHint := UseHints.Checked;
end;

procedure TSettins.UseAwayClick(Sender: TObject);
begin
  Self.AwayMins.Enabled := Self.UseAway.Checked;
  Self.Label23.Enabled := Self.UseAway.Checked;
end;

end.
