unit qLinks;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ComCtrls;

type
  TLinks = class(TForm)
    Close: TButton;
    Tree: TTreeView;
    Expand: TButton;
    Collapse: TButton;
    procedure CloseClick(Sender: TObject);
    Procedure MakeTree(Source : TStrings);
    procedure CollapseClick(Sender: TObject);
    procedure ExpandClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public

    { Public declarations }
  end;

var
  Links: TLinks;

implementation

Uses qIRCMain;

{$R *.DFM}

Type
  TString = Class(TObject)
  Private
    fString : String;
  Public
    Constructor Create(AString : String);
    property Text : String Read fString;
  End;

Constructor TString.Create(AString : String);

Begin
  Inherited Create;
  fString := aString;
End;

procedure TLinks.CloseClick(Sender: TObject);
begin
  Self.Release;
end;

Function GetFrag(Var S : String) : String;

Var
  At                    : Integer;

Begin
  At := Pos(' ',S);
  If (At<>0) Then
  Begin
    Result := Copy(S,1,At-1);
    Delete(S,1,At);
    S:= TrimLeft(S);
  End
  Else
  Begin
    Result := S;
    S := '';
  End;
End;

Procedure TLinks.MakeTree(Source : TStrings);

Var
  Loop                  : Integer;
  InnerLoop             : Integer;
  Work                  : String;
  Description           : String;
  Hop                   : String;
  IP                    : String;
  Host                  : String;
  HostParent            : String;
  Str                   : String;
  S                     : TStringList;
  M                     : TMemoryStream;

Begin
  Tree.Items.Clear;
  If Source.Count=0 Then Exit;

  S := TStringList.Create;
  M := TMemoryStream.Create;
  Try
    For Loop := Source.Count-1 Downto 0 Do
    Begin
      Work := Source[Loop];
  // Delete the leading  :
      Delete(Work,1,1);
      GetFrag(Work);  // Server
      GetFrag(Work);  // Code
      GetFrag(Work);  // Nick
      Host := GetFrag(Work);
      HostParent := GetFrag(Work);
  // Delete the leading  :
      Delete(Work,1,1);

      Hop := GetFrag(Work);
      GetFrag(Work);
  // IP is optional.
      If (Copy(Work,1,1)='[') Then
      Begin
        IP := GetFrag(Work);
      End
      Else
      begin
        IP := '';
      End;
      If (Hop='') Or (Host='') Or (Work='') Then Continue;
      Description := Work;
      Str := Hop + ' '+Host + '    (' + Description;
      If (IP <> '') Then
        Str := Str + ' ' + IP;
      Str := Str + ')';
      S.AddObject(Str,TString.Create(HostParent));
    End;

    S.Sort;
    For loop := 1 To S.Count-1 Do
    Begin
      HostParent := TString(S.Objects[Loop]).Text;
      For InnerLoop := 0 TO Loop-1 Do
      Begin
        Work := S[InnerLoop];
        GetFrag(Work);
        Host := GetFrag(Work);
        If (Host=HostParent) Then
        Begin
          S.Move(Loop,InnerLoop+1);
          Break;
        End;
      End;
    End;
    For loop := 0 To S.Count-1 Do
    Begin
      S.Objects[Loop].Free;
      Work := S[Loop];
      S[Loop] := StringOfChar(#9,StrToIntDef(GetFrag(Work),0))+Work;
    End;
    S.SaveToStream(M);
    M.Position := 0;
    Tree.LoadFromStream(M);
    Tree.SortType := stText;

    If (Tree.Items.GetFirstNode<>Nil) Then
    Begin
      Tree.Items.GetFirstNode.Expand(True);
      Tree.Selected := Tree.Items.GetFirstNode;
    End;
  Finally
    M.Free;
    S.Free;
  End;
  Self.Caption := 'Links - ' + IntToStr(Self.Tree.Items.Count)
   + ' servers';
end;

procedure TLinks.CollapseClick(Sender: TObject);
begin
  Self.Tree.FullCollapse;
end;

procedure TLinks.ExpandClick(Sender: TObject);
begin
  If (Tree.Items.GetFirstNode<>Nil) Then
  Begin
    Tree.Items.GetFirstNode.Expand(True);
    Tree.Selected := Tree.Items.GetFirstNode;
  End;
end;

procedure TLinks.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := False;
  Self.Release;
end;

end.
