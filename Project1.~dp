program Project1;

uses
  Forms,
  qIRCMain in 'qIRCMain.pas' {IRCMain},
  qAbout in 'qAbout.pas' {AboutBox},
  qChannel in 'qChannel.pas' {Channel},
  RichEdit2 in 'RichEdit2.pas',
  qStatus in 'qStatus.pas' {Status},
  qAdd in 'qAdd.pas' {AddServer},
  qEdit in 'qEdit.pas' {EditServer},
  qMaintenance in 'qMaintenance.pas' {Maintenance},
  qCmd in 'qCmd.pas' {Contents},
  qMsgBox in 'qMsgBox.pas' {MsgBox},
  qDcc in 'qDcc.pas' {DccSend},
  qDccAccept in 'qDccAccept.pas' {DccAccept},
  qDccGet in 'qDccGet.pas' {DccGet},
  qFeatures in 'qFeatures.pas' {Features},
  qColors in 'qColors.pas' {Colors},
  qFavorites in 'qFavorites.pas' {ChanList},
  qWelcome in 'qWelcome.pas' {Welcome},
  qSupport in 'qSupport.pas',
  qChanList in 'qChanList.pas' {CHList},
  qUpgrade in 'qUpgrade.pas' {UpgradeCheck},
  qLinks in 'qLinks.pas' {Links},
  qSettings in 'qSettings.pas' {Settins};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'kIRC32 (Killer IRC)';
  Application.CreateForm(TIRCMain, IRCMain);
  Application.CreateForm(TSettins, Settins);
  Application.Run;
end.
