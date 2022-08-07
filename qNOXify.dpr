program qNOXify;
uses

  {$IFDEF DEBUG}
    FastMM4,    // Can be removed if not present
  {$ENDIF}

  {$DEFINE USEDEVAPI} // Switch between last Release and Main Dev.

  {$IFDEF VER340}  // Delphi 10.4 Sydney
    {$IFNDEF USEDEVAPI}
      REST.Json.Types in 'qBit4Delphi\API\JSON\21\REST.Json.Types.pas',
      REST.JsonReflect in 'qBit4Delphi\API\JSON\21\REST.JsonReflect.pas',
      System.JSON in 'qBit4Delphi\API\JSON\21\System.JSON.pas',
      REST.Json in 'qBit4Delphi\API\JSON\21\REST.Json.pas',
      uqBitAPITypes in 'qBit4Delphi\API\uqBitAPITypes.pas',
      uqBitAPI in 'qBit4Delphi\API\uqBitAPI.pas',
      uqBitObject in 'qBit4Delphi\API\uqBitObject.pas',
    {$ELSE}
      REST.Json.Types in '..\qBit4Delphi\API\JSON\21\REST.Json.Types.pas',
      REST.JsonReflect in '..\qBit4Delphi\API\JSON\21\REST.JsonReflect.pas',
      System.JSON in '..\qBit4Delphi\API\JSON\21\System.JSON.pas',
      REST.Json in '..\qBit4Delphi\API\JSON\21\REST.Json.pas',
      uqBitAPITypes in '..\qBit4Delphi\API\uqBitAPITypes.pas',
      uqBitAPI in '..\qBit4Delphi\API\uqBitAPI.pas',
      uqBitObject in '..\qBit4Delphi\API\uqBitObject.pas',
    {$ENDIF}
  {$ENDIF}
  {$IFDEF VER350} // Delphi 11 Alexandria
    {$IFNDEF USEDEVAPI}
      REST.Json.Types in 'qBit4Delphi\API\JSON\22\REST.Json.Types.pas',
      REST.JsonReflect in 'qBit4Delphi\API\JSON\22\REST.JsonReflect.pas',
      System.JSON in 'qBit4Delphi\API\JSON\22\System.JSON.pas',
      REST.Json in 'qBit4Delphi\API\JSON\22\REST.Json.pas',
      uqBitAPITypes in 'qBit4Delphi\API\uqBitAPITypes.pas',
      uqBitAPI in 'qBit4Delphi\API\uqBitAPI.pas',
      uqBitObject in 'qBit4Delphi\API\uqBitObject.pas',
    {$ELSE}
      REST.Json.Types in '..\qBit4Delphi\API\JSON\22\REST.Json.Types.pas',
      REST.JsonReflect in '..\qBit4Delphi\API\JSON\22\REST.JsonReflect.pas',
      System.JSON in '..\qBit4Delphi\API\JSON\22\System.JSON.pas',
      REST.Json in '..\qBit4Delphi\API\JSON\22\REST.Json.pas',
      uqBitAPITypes in '..\qBit4Delphi\API\uqBitAPITypes.pas',
      uqBitAPI in '..\qBit4Delphi\API\uqBitAPI.pas',
      uqBitObject in '..\qBit4Delphi\API\uqBitObject.pas',
    {$ENDIF}
  {$ENDIF}

  uqBitPatchChecker in 'qBit4Delphi\Demos\common\uqBitPatchChecker.pas',
  Vcl.Forms,
  uqNOXify in 'Files\uqNOXify.pas' {qBitMainForm},
  uAppTrackMenus in 'Files\uAppTrackMenus.pas',
  uGrid in 'Files\uGrid.pas' {SGFrm: TFrame},
  uqBitAddTorrentDlg in 'Files\uqBitAddTorrentDlg.pas' {qBitAddTorrentDlg},
  uSetLocation in 'Files\uSetLocation.pas' {SetLocationDlg},
  uSpeedLimitsDlg in 'Files\uSpeedLimitsDlg.pas' {SpeedLimitsDlg},
  uqBitAddServerDlg in 'qBit4Delphi\Demos\common\uqBitAddServerDlg.pas' {qBitAddServerDlg},
  uqBitSelectServerDlg in 'qBit4Delphi\Demos\common\uqBitSelectServerDlg.pas' {qBitSelectServerDlg},
  uTorrentReader in 'qBit4Delphi\API\Tools\uTorrentReader.pas',
  uBEncode in 'qBit4Delphi\API\Tools\uBEncode.pas',
  uqBitFormat in 'qBit4Delphi\Demos\common\uqBitFormat.pas',
  uqBitUtils in 'Files\uqBitUtils.pas';

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



  {$IFDEF DEBUG}
    FastMM4,    // Can be removed if not available
  {$ENDIF}

  {$DEFINE USEDEVAPI}   // Switch between last Release and Main Dev.

  {$IFDEF VER340}  // Delphi 10.4 Sydney
    {$IFNDEF USEDEVAPI}
      REST.Json.Types in 'qBit4Delphi\API\JSON\21\REST.Json.Types.pas',
      REST.JsonReflect in 'qBit4Delphi\API\JSON\21\REST.JsonReflect.pas',
      System.JSON in 'qBit4Delphi\API\JSON\21\System.JSON.pas',
      REST.Json in 'qBit4Delphi\API\JSON\21\REST.Json.pas',
      uqBitAPITypes in 'qBit4Delphi\API\uqBitAPITypes.pas',
      uqBitAPI in 'qBit4Delphi\API\uqBitAPI.pas',
      uqBitObject in 'qBit4Delphi\API\uqBitObject.pas',
    {$ELSE}
      REST.Json.Types in '..\qBit4Delphi\API\JSON\21\REST.Json.Types.pas',
      REST.JsonReflect in '..\qBit4Delphi\API\JSON\21\REST.JsonReflect.pas',
      System.JSON in '..\qBit4Delphi\API\JSON\21\System.JSON.pas',
      REST.Json in '..\qBit4Delphi\API\JSON\21\REST.Json.pas',
      uqBitAPITypes in '..\qBit4Delphi\API\uqBitAPITypes.pas',
      uqBitAPI in '..\qBit4Delphi\API\uqBitAPI.pas',
      uqBitObject in '..\qBit4Delphi\API\uqBitObject.pas',
    {$ENDIF}
  {$ENDIF}
  {$IFDEF VER350} // Delphi 11 Alexandria
    {$IFNDEF USEDEVAPI}
      REST.Json.Types in 'qBit4Delphi\API\JSON\22\REST.Json.Types.pas',
      REST.JsonReflect in 'qBit4Delphi\API\JSON\22\REST.JsonReflect.pas',
      System.JSON in 'qBit4Delphi\API\JSON\22\System.JSON.pas',
      REST.Json in 'qBit4Delphi\API\JSON\22\REST.Json.pas',
      uqBitAPITypes in 'qBit4Delphi\API\uqBitAPITypes.pas',
      uqBitAPI in 'qBit4Delphi\API\uqBitAPI.pas',
      uqBitObject in 'qBit4Delphi\API\uqBitObject.pas',
    {$ELSE}
      REST.Json.Types in '..\qBit4Delphi\API\JSON\22\REST.Json.Types.pas',
      REST.JsonReflect in '..\qBit4Delphi\API\JSON\22\REST.JsonReflect.pas',
      System.JSON in '..\qBit4Delphi\API\JSON\22\System.JSON.pas',
      REST.Json in '..\qBit4Delphi\API\JSON\22\REST.Json.pas',
      uqBitAPITypes in '..\qBit4Delphi\API\uqBitAPITypes.pas',
      uqBitAPI in '..\qBit4Delphi\API\uqBitAPI.pas',
      uqBitObject in '..\qBit4Delphi\API\uqBitObject.pas',
    {$ENDIF}
  {$ENDIF}



