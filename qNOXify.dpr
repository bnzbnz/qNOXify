program qNOXify;
uses
  {$IFDEF VER340}
  REST.Json.Types in 'qBit4Delphi\API\JSON\21\REST.Json.Types.pas',
  {$ENDIF }
  {$IFDEF VER350}
  REST.Json.Types in 'qBit4Delphi\API\JSON\22\REST.Json.Types.pas',
  REST.JsonReflect in 'qBit4Delphi\API\JSON\22\REST.JsonReflect.pas',
  System.JSON in 'qBit4Delphi\API\JSON\22\System.JSON.pas',
  REST.Json in 'qBit4Delphi\API\JSON\22\REST.Json.pas',
  {$ENDIF }
  uqBitPatchChecker in 'qBit4Delphi\Demos\common\uqBitPatchChecker.pas',
  Vcl.Forms,
  uqNOXify in 'Files\uqNOXify.pas' {qBitMainForm},
  uqBitAPITypes in 'qBit4Delphi\API\uqBitAPITypes.pas',
  uqBitAPI in 'qBit4Delphi\API\uqBitAPI.pas',
  uqBitObject in 'qBit4Delphi\API\uqBitObject.pas',
  uAppTrackMenus in 'Files\uAppTrackMenus.pas',
  uGrid in 'Files\uGrid.pas' {SGFrm: TFrame},
  uqBitAddTorrentDlg in 'Files\uqBitAddTorrentDlg.pas' {qBitAddTorrentDlg},
  uSetLocation in 'Files\uSetLocation.pas' {SetLocationDlg},
  uSpeedLimitsDlg in 'Files\uSpeedLimitsDlg.pas' {SpeedLimitsDlg},
  uqBitAddServerDlg in 'qBit4Delphi\Demos\common\uqBitAddServerDlg.pas' {qBitAddServerDlg},
  uqBitSelectServerDlg in 'qBit4Delphi\Demos\common\uqBitSelectServerDlg.pas' {qBitSelectServerDlg},
  uTorrentReader in 'qBit4Delphi\API\Tools\uTorrentReader.pas',
  uBEncode in 'qBit4Delphi\API\Tools\uBEncode.pas',
  uqBitFormat in 'qBit4Delphi\Demos\common\uqBitFormat.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TqBitMainForm, qBitMainForm);
  Application.CreateForm(TqBitAddTorrentDlg, qBitAddTorrentDlg);
  Application.CreateForm(TSetLocationDlg, SetLocationDlg);
  Application.CreateForm(TSpeedLimitsDlg, SpeedLimitsDlg);
  Application.CreateForm(TqBitAddServerDlg, qBitAddServerDlg);
  Application.CreateForm(TqBitSelectServerDlg, qBitSelectServerDlg);
  Application.CreateForm(TqBitAddTorrentDlg, qBitAddTorrentDlg);
  Application.Run;
end.

  {$IFDEF VER340}
    REST.Json.Types in 'qBit4Delphi\API\JSON\21\REST.Json.Types.pas',
    REST.JsonReflect in 'qBit4Delphi\API\JSON\21\REST.JsonReflect.pas',
    System.JSON in 'qBit4Delphi\API\JSON\21\System.JSON.pas',
    REST.Json in 'qBit4Delphi\API\JSON\21\REST.Json.pas',
  {$ENDIF }
  {$IFDEF VER350}
    REST.Json.Types in 'qBit4Delphi\API\JSON\22\REST.Json.Types.pas',
    REST.JsonReflect in 'qBit4Delphi\API\JSON\22\REST.JsonReflect.pas',
    System.JSON in 'qBit4Delphi\API\JSON\22\System.JSON.pas',
    REST.Json in 'qBit4Delphi\API\JSON\22\REST.Json.pas',
  {$ENDIF}


