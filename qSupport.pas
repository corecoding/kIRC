unit qSupport;

interface

uses
  Classes, DDUStandard, qIRCMain, RichEdit2, Graphics,
  Dialogs, Messages, Windows, SysUtils;


function DoPromptKeyDown(Shift: TShiftState; Prompt: TDDUEdit;
 Key: Word; LineNumbah: Integer; PromptList: Array Of String;
  FormMain: TRichEdit98): String;
procedure InsertChar(Prompt: TDDUEdit; Str: String);
procedure AddTextToWindow(FormMain: TRichEdit98; A: String;
 J: Integer);

implementation

function DoPromptKeyDown(Shift: TShiftState; Prompt: TDDUEdit;
 Key: Word; LineNumbah: Integer; PromptList: Array Of String;
  FormMain: TRichEdit98): String;
begin
//  showmessage(IntToStr(Ord(Key)));
//  for X := 0 To 5 Do
//    Showmessage(PromptList[X]);
  If (ssAlt In Shift) Then
  Begin
    Case Key Of
      49..57: If (IRCMain.TabPage.PageCount > (Key-49)) Then
              Begin
                IRCMain.TabPage.ActivePage :=
                 IRCMain.TabPage.Pages[Key-49];
                IRCMain.TabPageChange(nil);
              End;
    End;
  End;
  If (ssCtrl In Shift) Then
  Begin
    Case Key Of
      71: InsertChar(Prompt, IRCBeep);
      75: InsertChar(Prompt, IRCColor);
      66: InsertChar(Prompt, IRCBold);
      82: InsertChar(Prompt, IRCReverse);
      85: InsertChar(Prompt, IRCUnderline);
    End;
  End;

  If (Key = 33) Then
  Begin
    FormMain.Perform(EM_SCROLL, SB_PAGEUP, 0);
  End;
  If (Key = 34) Then
  Begin
    FormMain.Perform(EM_SCROLL, SB_PAGEDOWN, 0);
  End;
  If (Key = 38) Then
  Begin
    If (PromptList[LineNumbah + 1] <> '') And (LineNumbah < 29) Then
      Inc(LineNumbah);
    Prompt.Text := PromptList[LineNumbah];
    Result := IntToStr(LineNumbah) + #1 + IntToStr(Length(Prompt.Text));
  End;
  If (Key = 40) Then
  Begin
    If (LineNumbah = -1) Then
    Begin
      Prompt.Text := '';
      Exit;
    End;
    Dec(LineNumbah);
    If (LineNumbah <> -1) Then
    Begin
      Prompt.Text := PromptList[LineNumbah];
    End
    Else
    Begin
      Prompt.Text := '';
    End;
    Result := IntToStr(LineNumbah) + #1 + IntToStr(Length(Prompt.Text));
  End;
end;

procedure InsertChar(Prompt: TDDUEdit; Str: String);

var
  Tmp              : String;
  X                : Integer;

begin
  Tmp := Prompt.Text;
  X := Prompt.SelStart + 1;
  Insert(Str, Tmp, X);
  Prompt.Text := Tmp;
  Prompt.SelStart := X;
end;

procedure AddTextToWindow(FormMain: TRichEdit98; A: String; J: Integer);

var
  I                : Integer;
  Z                : Integer;
  P                : Integer;
  OldFore          : Integer;
  OldFill          : Integer;
  X                : Integer;
  Y                : Integer;
  C                : String;
  Inverse          : Boolean;
  Underline        : Boolean;
  AColor           : Boolean;

begin
  If (A = '') Then Exit;

  X := GetScrollPos(FormMain.Handle, SB_VERT);
  Y := Abs(FormMain.Font.Height);
  X := X Div Y;
  Inc(X, (FormMain.Height) Div Y);
  Y := FormMain.Line;
  If (Y>X) Then
  Begin
    FormMain.HideSelection := True;
    SysUtils.Beep;
  End;
  If (Y=X) Then
    FormMain.HideSelection := False;

  If (Copy(A, Length(A), 1) = ' ') Then
    Delete(A, Length(A), 1);
  If (FormMain.Text <> '') Then
    FormMain.SelText := #13#10;
  I := 0;
  Inverse := False;
  Underline := False;
  AColor := False;
  FormMain.SelAttributes.Color := J;
//  FormMain.SelAttributes.BackColor := GetColor(1);
  FormMain.SelAttributes.Bold := False;
  FormMain.SelAttributes.Italic := False;
  FormMain.SelAttributes.Outline := False;
  Repeat
  Inc(I);

    If (A[I] = IRCColor) Then
    Begin
      If (A[I + 1] = IRCColor) Then Continue;
      Z := -1;
      C := Copy(A, I + 1, 1 + IRCMain.IsNumeric01(A[I + 2]));
      If (Not IRCMain.IsNumeric(C)) Then Continue;
      P := 0;
      If (A[I + 1 + Length(C)] = ',') Then
      Begin
        If (IRCMain.IsNumeric(A[I + 3 + Length(C)])) Then
          P := 1;
        Z := IRCMain.ValIt(Copy(A, I + 2 + Length(C), P + 1));
      End;

      If (IRCMain.IsNumeric(C)) Then
        Inc(I, Length(C) + 1);
      If (Z <> -1) Then
        Inc(I, Length(IntToStr(Z)) + 1);

      AColor := True;
    End;

    If (Inverse) Then
    Begin
      AColor := False;
      FormMain.SelAttributes.Color := GetColor(0);
      FormMain.SelAttributes.BackColor := GetColor(1);
      OldFore := GetColor(IRCMain.ValIt(C));
      If (Z <> -1) Then
        OldFill := GetColor(Z)
      Else
        OldFill := clWhite;
    End;

    If (Not Inverse) And (AColor) Then
    Begin
      AColor := False;
      FormMain.SelAttributes.Color := GetColor(IRCMain.ValIt(C));
      If (Z <> -1) Then
        FormMain.SelAttributes.BackColor := GetColor(Z);
    End;

    If (IRCMain.BUIC1.Checked) Then
    Begin
      Case A[I] Of
        IRCBeep: Beep;
        IRCTab: FormMain.SelText := ' ';
        IRCBold: FormMain.SelAttributes.Bold := Not FormMain.SelAttributes.Bold;
        IRCBoldCancel: FormMain.SelAttributes.Bold := False;
        IRCReverse: Inverse := Not Inverse;
//        IRCReverse: FormMain.SelAttributes.Italic := Not FormMain.SelAttributes.Italic;
        IRCUnderline: Begin
          Underline := Not Underline;
          FormMain.SelAttributes.UnderlineType := TUnderlineType(Underline);
        End;
      Else
        FormMain.SelText := A[I];
      End;
    End Else
      FormMain.SelText := A[I];

  Until (I > Length(A) - 1);
end;

end.
