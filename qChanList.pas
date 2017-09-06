unit qChanList;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, ComCtrls, StdCtrls, ExtCtrls, ElTree;

type
  TCHList = class(TForm)
    Close: TButton;
    Status: TPanel;
    List: TElTree;
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CloseClick(Sender: TObject);
  private
  public
    UserCount: Integer;
  end;

var
  CHList: TCHList;

implementation

{$R *.DFM}

procedure TCHList.FormResize(Sender: TObject);
begin
  Self.List.HeaderSections.Item[2].Width := Self.Width - 140;
  Self.List.Height := Self.Height - 60;
  Self.Close.Top := Self.List.Height + 5;
  Self.Close.Left := 5;
  Self.Status.Top := Self.Close.Top;
  Self.Status.Left := Self.Width - Self.Status.Width - 10;
end;

procedure TCHList.FormCreate(Sender: TObject);
begin
  UserCount := 0;
  Self.List.Width := Self.Width - 8;
  FormResize(Nil);
end;

procedure TCHList.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := False;
  Self.Release;
end;

procedure TCHList.CloseClick(Sender: TObject);
begin
  Self.Release;
end;

end.
