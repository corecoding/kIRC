unit qFavorites;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ElTree;

type
  TChanList = class(TForm)
    AddBtn: TButton;
    EditBtn: TButton;
    DeleteBtn: TButton;
    SortBtn: TButton;
    CloseBtn: TButton;
    Chans: TElTree;
    procedure AddBtnClick(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure EditBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ChanList: TChanList;

implementation

{$R *.DFM}

procedure TChanList.AddBtnClick(Sender: TObject);
var
  Str1             : String;
  Str2             : String;
  X                : Integer;
  DeItem           : TELTreeItem;
begin
  Str1 := InputBox('Adding a channel', 'Please enter a channel, space,'#13#10' and then a description of it:', '');
  If (Str1 <> '') Then
  Begin
    X := Pos(' ', Str1);
    If (X <> 0) Then
    Begin
      Str2 := Copy(Str1, X + 1, MaxInt);
      Delete(Str1, X, MaxInt);
    End;
    If (Copy(Str1, 1, 1) <> '#') Then
      Str1 := '#' + Str1;
    DeItem := Chans.Items.AddItem(DeItem);
//    DeItem.Text := Trim(Str1);
//    DeItem.ColumnText.Add(Str2);
  End;
end;

procedure TChanList.CloseBtnClick(Sender: TObject);
begin
  Self.Release;
end;

procedure TChanList.EditBtnClick(Sender: TObject);
var
  Str1             : String;
  Str2             : String;
  X                : Integer;
  DeItem           : TELTreeItem;
begin
  DeItem := Chans.Selected;
  Str1 := DeItem.Text;
  Str2 := DeItem.ColumnText.Strings[0];

  Str1 := InputBox('Editing a channel', 'You may change the channel name and description here:', Str1 + ' ' + Str2);
  If (Str1 <> '') Then
  Begin
    X := Pos(' ', Str1);
    If (X <> 0) Then
    Begin
      Str2 := Copy(Str1, X + 1, MaxInt);
      Delete(Str1, X, MaxInt);
    End;
    If (Copy(Str1, 1, 1) <> '#') Then
      Str1 := '#' + Str1;
    DeItem := Chans.Items.AddItem(DeItem);
    DeItem.Text := Trim(Str1);
    DeItem.ColumnText.Add(Str2);
  End;
end;

end.
