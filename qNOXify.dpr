program qNOXify;
uses
  {$IFDEF VER340}
    REST.Json.Types in '..\qBit4Delphi\API\JSON\21\REST.Json.Types.pas',
    REST.JsonReflect in '..\qBit4Delphi\API\JSON\21\REST.JsonReflect.pas',
    System.JSON in '..\qBit4Delphi\API\JSON\21\System.JSON.pas',
    REST.Json in '..\qBit4Delphi\API\JSON\21\REST.Json.pas',
  {$ENDIF }
  {$IFDEF VER350}
    REST.Json.Types in '..\qBit4Delphi\API\JSON\22\REST.Json.Types.pas',
    REST.JsonReflect in '..\qBit4Delphi\API\JSON\22\REST.JsonReflect.pas',
    System.JSON in '..\qBit4Delphi\API\JSON\22\System.JSON.pas',
    REST.Json in '..\qBit4Delphi\API\JSON\22\REST.Json.pas',
  {$ENDIF}

  uPatcherChecker in '..\qBit4Delphi\Demos\common\uPatcherChecker.pas',
  Vcl.Forms,
  uqNOXify in 'Files\uqNOXify.pas' {qBitMainForm},
  uqBitAPI in '..\qBit4Delphi\API\uqBitAPI.pas',
  uqBitAPITypes in '..\qBit4Delphi\API\uqBitAPITypes.pas',
  uqBitObject in '..\qBit4Delphi\API\uqBitObject.pas',
  uqBitFormat in '..\qBit4Delphi\Demos\common\uqBitFormat.pas',
  uAppTrackMenus in '..\qBit4Delphi\Demos\common\uAppTrackMenus.pas',
  uGrid in 'Files\uGrid.pas' {SGFrm: TFrame},
  uAddTorrent in 'Files\uAddTorrent.pas' {AddTorrentDlg},
  uSetLocation in 'Files\uSetLocation.pas' {SetLocationDlg},
  uSpeedLimitsDlg in 'Files\uSpeedLimitsDlg.pas' {SpeedLimitsDlg},
  uSelectServer in '..\qBit4Delphi\Demos\common\uSelectServer.pas' {SelectServerDlg},
  uAddServer in '..\qBit4Delphi\Demos\common\uAddServer.pas' {AddServerDlg},
  uExternalIP in '..\qBit4Delphi\API\Tools\uExternalIP.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TqBitMainForm, qBitMainForm);
  Application.CreateForm(TAddTorrentDlg, AddTorrentDlg);
  Application.CreateForm(TSetLocationDlg, SetLocationDlg);
  Application.CreateForm(TSpeedLimitsDlg, SpeedLimitsDlg);
  Application.CreateForm(TSelectServerDlg, SelectServerDlg);
  Application.CreateForm(TAddServerDlg, AddServerDlg);
  Application.Run;
end.

  {$IFDEF VER340}
    REST.Json.Types in '..\..\API\JSON\21\REST.Json.Types.pas',
    REST.JsonReflect in '..\..\API\JSON\21\REST.JsonReflect.pas',
    System.JSON in '..\..\API\JSON\21\System.JSON.pas',
    REST.Json in '..\..\API\JSON\21\REST.Json.pas',
  {$ENDIF }
  {$IFDEF VER350}
    REST.Json.Types in '..\..\API\JSON\22\REST.Json.Types.pas',
    REST.JsonReflect in '..\..\API\JSON\22\REST.JsonReflect.pas',
    System.JSON in '..\..\API\JSON\22\System.JSON.pas',
    REST.Json in '..\..\API\JSON\22\REST.Json.pas',
  {$ENDIF}

