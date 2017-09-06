unit qCmd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ComCtrls, Buttons, ImgList,
  ElURLLabel, lmdbtn, lmdctrl;

type
  TContents = class(TForm)
    CloseBtn: TLMDExplorerButton;
    PageControl1: TPageControl;
    TabSheet6: TTabSheet;
    Label12: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    URL: TElURLLabel;
    Label45: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Label66: TLabel;
    Label72: TLabel;
    TabSheet1: TTabSheet;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label13: TLabel;
    Label16: TLabel;
    Label15: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label32: TLabel;
    Label34: TLabel;
    Label27: TLabel;
    TabSheet4: TTabSheet;
    Label31: TLabel;
    Label33: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label38: TLabel;
    Label21: TLabel;
    Label14: TLabel;
    Label46: TLabel;
    TabSheet5: TTabSheet;
    Label47: TLabel;
    Label48: TLabel;
    TabSheet7: TTabSheet;
    Label70: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    Label56: TLabel;
    Label64: TLabel;
    Label65: TLabel;
    Label67: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label37: TLabel;
    Label30: TLabel;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    Label5: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label44: TLabel;
    TabSheet3: TTabSheet;
    Label40: TLabel;
    Label69: TLabel;
    Label68: TLabel;
    Label63: TLabel;
    Label62: TLabel;
    Label55: TLabel;
    Label54: TLabel;
    Label53: TLabel;
    Label52: TLabel;
    Label51: TLabel;
    Label39: TLabel;
    Label17: TLabel;
    Label73: TLabel;
    Label71: TLabel;
    Label74: TLabel;
    Label75: TLabel;
    Label76: TLabel;
    Label77: TLabel;
    Label78: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseMe;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Contents: TContents;

implementation

uses qIRCMain;

{$R *.DFM}

procedure TContents.FormCreate(Sender: TObject);
begin
  IRCMain.Contents1.Enabled := False;
  IRCMain.Contents2.Enabled := False;
end;

procedure TContents.CloseBtnClick(Sender: TObject);
begin
  Self.Release;
end;

procedure TContents.FormDestroy(Sender: TObject);
begin
  CloseMe;
end;

procedure TContents.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CloseMe;
end;

procedure TContents.CloseMe;
begin
  IRCMain.Contents2.Enabled := True;
  IRCMain.Contents1.Enabled := True;
end;

end.
