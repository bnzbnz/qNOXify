unit uqNOXify;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Generics.Collections,
  uqBitAPITypes, uqBitAPI, uqBitObject, Vcl.ExtCtrls, uqBitFormat, Vcl.Menus,
  Vcl.ComCtrls, uGrid, Vcl.StdCtrls, Vcl.Buttons, Vcl.Grids, uSetLocation, uSelectServer, uAddServer,
  uExternalIP;

const
  THREAD_WAIT_TIME_ME = 1500;

type
  TqBitThread = class(TThread)
    Refresh: boolean; // Thread Safe
    Hash: string;
    qBTh: TqBitObject;
  end;

  TqBitTPeersThread = class(TqBitThread)
    qBTPeers: TqBitTorrentPeersDataType;
    procedure Execute; override;
  end;

  TqBitTTrkrsThread = class(TqBitThread)
    qBTTrkrs: TqBitTrackersType;
    procedure Execute; override;
  end;

  TqBitTInfosThread = class(TqBitThread)
    qBTInfo: TqBitTorrentInfoType;
    procedure Execute; override;
  end;

  TqBitMainThread = class(TqBitThread)
    qBMain: TqBitMainDataType;
    procedure Execute; override;
  end;

  TqBitMainForm = class(TForm)
    MainFrame: TSGFrm;
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TrkrFrame: TSGFrm;
    PeersFrame: TSGFrm;
    Label1: TLabel;
    EditSearch: TEdit;
    BitBtn1: TBitBtn;
    Label2: TLabel;
    CBStatus: TComboBox;
    Label3: TLabel;
    CBCat: TComboBox;
    StatusBar: TStatusBar;
    Splitter1: TSplitter;
    Label4: TLabel;
    CBTag: TComboBox;
    SGDetails: TStringGrid;
    PMMain: TPopupMenu;
    ITMSelectAll: TMenuItem;
    SelectAll2: TMenuItem;
    ITMPause: TMenuItem;
    ITMResume: TMenuItem;
    N1: TMenuItem;
    ITMAdd: TMenuItem;
    ITMDelete: TMenuItem;
    ITMDelTOnly: TMenuItem;
    ITMDelWithData: TMenuItem;
    ITMAddTFile: TMenuItem;
    ITMAddMagnetURL: TMenuItem;
    OpenTorrent: TFileOpenDialog;
    N2: TMenuItem;
    ITMSetLoc: TMenuItem;
    PMStatus: TPopupMenu;
    PMIToggleSpeedLimits: TMenuItem;
    N7: TMenuItem;
    PMISpeedLimits: TMenuItem;
    ITMRename: TMenuItem;
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure ITMSelectAllClick(Sender: TObject);
    procedure ITMResumeClick(Sender: TObject);
    procedure ITMPauseClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure ITMAddTFileClick(Sender: TObject);
    procedure StatusBarClick(Sender: TObject);
    procedure ITMDelWithDataClick(Sender: TObject);
    procedure ITMDelTOnlyClick(Sender: TObject);
    procedure ITMSetLocClick(Sender: TObject);
    procedure PMISpeedLimitsClick(Sender: TObject);
    procedure ITMAddMagnetURLClick(Sender: TObject);
    procedure ITMRenameClick(Sender: TObject);
  private
    { Private declarations }
    FMainLock : Boolean;
    FCurrentSelectedHash: string;
    ThPeers: TqBitTPeersThread;
    ThInfo: TqBitTInfosThread;
    ThMain: TqBitMainThread;
    ThTrkrs: TqBitTTrkrsThread;
    qB: TqBitObject;
    qBPrefs: TqBitPreferencesType;

    function GetGridSelHashes: TStringList;
    function GetGridSelTorrents: TObjectList<TqBitTorrentType>;
    function GetLastGridSelTorrent: TqBitTorrentType;
  protected
     procedure WMDropFiles(var Msg: TMessage); message WM_DROPFILES;
  public
    { Public declarations }

    IP: TExternalIP;
    qBMain: TqBitMainDataType;
    qBTPeers: TqBitTorrentPeersDataType;
    qBTTrkrs: TqBitTrackersType;
    qBTInfo: TqBitTorrentInfoType;


    // UI
    procedure UpdateMainUI;
    procedure UpdatePeersUI;
    procedure UpdateTrkrsUI;
    procedure UpdateTinfosUI;

    // MainGrid Frame Callbacks
    procedure DoUpdateMainUI(Sender: TObject);
    procedure DoRowsSelectedMain(Sender: TObject);
    procedure DoUpdatePeersUI(Sender: TObject);
    procedure DoRowsSelectedPeers(Sender: TObject);
    procedure DoUpdateTrkrsUI(Sender: TObject);
    procedure DoUpdateTinfoUI(Sender: TObject);
    procedure DoMainEventPopup(Sender: TObject; X, Y, aCol, aRow: integer);

    // Threads Syncs
    procedure ThreadDisconnect(Sender: TThread);
    procedure ThreadGetSelectedHash(Sender: TqBitThread);
    procedure ThreadTPeersUpdated(Sender: TqBitTPeersThread);
    procedure ThreadTInfoUpdated(Sender: TqBitTInfosThread);
    procedure ThreadMainUpdated(Sender: TqBitMainThread);
    procedure ThreadTTrkrUpdated(Sender: TqBitTTrkrsThread);
  end;

var
  qBitMainForm: TqBitMainForm;


implementation
uses RTTI, System.Generics.Defaults, uAddTorrent, uSpeedLimitsDlg, ShellAPI;

{$R *.dfm}

procedure TqBitMainForm.FormShow(Sender: TObject);
begin
  SGDetails.Selection := NoSelection;
  DragAcceptFiles (Self.handle, True);

  if SelectServerDlg.ShowModal = mrCancel then
  begin
    Close;
    Exit;
  end;
  var Srv := SelectServerDlg.GetServer;
  qB := TqBitObject.Connect(Srv.FHP, Srv.FUN, Srv.FPW);
  if not assigned(qB) then Exit;

  qBPrefs := qB.GetPreferences;

  ThPeers := TqBitTPeersThread.Create;
  ThPeers.qBTh := qB.Clone;

  ThMain := TqBitMainThread.Create;
  ThMain.qBTh := qB.Clone;

  ThInfo := TqBitTInfosThread.Create;
  ThInfo.qBTh := qB.Clone;

  ThTrkrs := TqBitTTrkrsThread.Create;
  ThTrkrs.qBTh := qB.Clone;

  IP := TExternalIP.FromURL();

  FCurrentSelectedHash := '';
  FMainLock := False;
  // Init Frames :

  MainFrame.DoCreate;
  MainFrame.OnUpdateUIEvent := Self.DoUpdateMainUI;
  MainFrame.OnRowsSelectedEvent := Self.DoRowsSelectedMain;
  MainFrame.OnPopupEvent := Self.DoMainEventPopup;

  var Row := -1;
  Inc(Row); MainFrame.AddCol(Row, 'Name', 'Fname', VarFormatString, 240, True);
  Inc(Row); MainFrame.AddCol(Row, 'Size', 'Fsize', VarFormatBKM, 84, True);
  Inc(Row); MainFrame.AddCol(Row, 'Total Size', 'Ftotal_size', VarFormatBKM, -1, True);
  Inc(Row); MainFrame.AddCol(Row, 'Progress', 'Fprogress', VarFormatPercent, 84, True);
  Inc(Row); MainFrame.AddCol(Row, 'Status', 'Fstate', VarFormatString, 84, True);
  Inc(Row); MainFrame.AddCol(Row, 'Seeds', 'Fnum_seeds', VarFormatString, 84, True);
  Inc(Row); MainFrame.AddCol(Row, 'Peers', 'Fnum_leechs', VarFormatString, 84, True);
  Inc(Row); MainFrame.AddCol(Row, 'Down Speed', 'Fdlspeed', VarFormatBKMPerSec, 84, True);
  Inc(Row); MainFrame.AddCol(Row, 'Upload Speed', 'Fupspeed', VarFormatBKMPerSec, 84, True);
  Inc(Row); MainFrame.AddCol(Row, 'ETA', 'Feta', VarFormatDeltaSec, 128, True);
  Inc(Row); MainFrame.AddCol(Row, 'Ratio', 'Fratio', VarFormatFloat2d, 84, True);
  Inc(Row); MainFrame.AddCol(Row, 'Category', 'Fcategory', VarFormatString, 84, True);
  Inc(Row); MainFrame.AddCol(Row, 'Tags', 'Ftags', VarFormatString, 84, True);
  Inc(Row); MainFrame.AddCol(Row, 'Added On', 'Fadded_on', VarFormatDate, 128, True);
  Inc(Row); MainFrame.AddCol(Row, 'Completed On', 'Fcompletion_on', VarFormatDate, -1, True);
  Inc(Row); MainFrame.AddCol(Row, 'Tracker', 'Ftracker', VarFormatString, -1, True);
  Inc(Row); MainFrame.AddCol(Row, 'Down Limit', 'Fdl_limit', VarFormatLimit, -1, True);
  Inc(Row); MainFrame.AddCol(Row, 'Up Limit', 'Fdl_limit', VarFormatLimit, -1, True);
  Inc(Row); MainFrame.AddCol(Row, 'Downloaded', 'Fdownloaded', VarFormatBKM, -1, True);
  Inc(Row); MainFrame.AddCol(Row, 'Uploaded  ', 'Fuploaded', VarFormatBKM, -1, True);
  Inc(Row); MainFrame.AddCol(Row, 'Session Downloaded', 'Fdownloaded_session', VarFormatBKM, -1, True);
  Inc(Row); MainFrame.AddCol(Row, 'Session Uploaded  ', 'Fuploaded_session', VarFormatBKM, -1, True);
  Inc(Row); MainFrame.AddCol(Row, 'Availability', 'Favailability', VarFormatMulti, -1, True);

  var rttictx := TRttiContext.Create();
  var rttitype := rttictx.GetType(TqBitTorrentType);
  for var field in rttitype.GetFields do
  begin
    var Title := 'Raw: ' + field.Name;
    Inc(Row); MainFrame.AddCol(Row, Title, field.Name, VarFormatString, -2, False);
  end;
  rttictx.Free;


  PeersFrame.DoCreate;
  PeersFrame.OnUpdateUIEvent := Self.DoUpdatePeersUI;
  PeersFrame.OnRowsSelectedEvent := Self.DoRowsSelectedPeers;
  Row := -1;
  Inc(Row); PeersFrame.AddCol(Row, 'IP', 'Fip', VarFormatString, 84, True);
  Inc(Row); PeersFrame.AddCol(Row, 'Port', 'Fport', VarFormatString, 84, True);
  Inc(Row); PeersFrame.AddCol(Row, 'Country', 'Fcountry', VarFormatString, 84, True);
  Inc(Row); PeersFrame.AddCol(Row, 'Connection', 'Fconnection', VarFormatString, 72, True);
  Inc(Row); PeersFrame.AddCol(Row, 'Flags', 'Fflags', VarFormatString, 72, True);
  Inc(Row); PeersFrame.AddCol(Row, 'Client', 'Fclient', VarFormatString, 100, True);
  Inc(Row); PeersFrame.AddCol(Row, 'Progress', 'Fprogress', VarFormatPercent, 72, True);
  Inc(Row); PeersFrame.AddCol(Row, 'Down Speed', 'Fdl_speed', VarFormatBKMPerSec, 72, True);
  Inc(Row); PeersFrame.AddCol(Row, 'Up Speed', 'Fup_speed', VarFormatBKMPerSec, 72, True);
  Inc(Row); PeersFrame.AddCol(Row, 'Downloaded', 'Fdownloaded', VarFormatBKM, 72, True);
  Inc(Row); PeersFrame.AddCol(Row, 'Uploaded', 'Fuploaded', VarFormatBKM, 72, True);

  TrkrFrame.DoCreate;
  TrkrFrame.OnUpdateUIEvent := Self.DoUpdateTrkrsUI;
  Row := -1;
  Inc(Row); TrkrFrame.AddCol(Row, 'URL', 'Furl', VarFormatString, 208, True);
  Inc(Row); TrkrFrame.AddCol(Row, 'Tier', 'Ftier', VarFormatString, 32, True);
  Inc(Row); TrkrFrame.AddCol(Row, 'Status', 'Fstatus', VarFormatTrackerStatus, 84, True);
  Inc(Row); TrkrFrame.AddCol(Row, 'Peers', 'Fnum_peers', VarFormatString, 84, True);
  Inc(Row); TrkrFrame.AddCol(Row, 'Seeds', 'Fnum_seeds', VarFormatString, 84, True);
  Inc(Row); TrkrFrame.AddCol(Row, 'Leeches', 'Fnum_leeches', VarFormatString, 84, True);
  Inc(Row); TrkrFrame.AddCol(Row, 'Donwloaded', 'Fnum_downloaded', VarFormatBKM, 84, True);
  Inc(Row); TrkrFrame.AddCol(Row, 'Message', 'Fmsg', VarFormatString, 128, True);

end;

function TqBitMainForm.GetGridSelHashes: TStringList;
begin
  var Sel := Self.MainFrame.GetGridSel;
  Result := TStringList.Create;
  for var v in Sel do
    Result.Add(TqBitTorrentType(TSGData(v).Obj)._FKey);
  Sel.Free;
end;

function TqBitMainForm.GetGridSelTorrents: TObjectList<TqBitTorrentType>;
begin
  var Sel := Self.MainFrame.GetGridSel;
  Result := TObjectList<TqBitTorrentType>.Create(False);
  for var v in Sel do
    Result.Add(TqBitTorrentType(TSGData(v).Obj));
  Sel.Free;
end;

function TqBitMainForm.GetLastGridSelTorrent: TqBitTorrentType;
begin
  Result := nil;
  var Sel := GetGridSelTorrents;
  if (Sel <> nil) and (Sel.Count > 0) then
    Result := Sel[ Sel.Count -1 ];
  Sel.Free;
end;

procedure TqBitMainForm.ITMAddMagnetURLClick(Sender: TObject);
begin
  var URI := InputBox('Magnet URL Download :', 'URL : ', '');
  if URI <> '' then qB.AddNewTorrentUrl(URI);
end;

procedure TqBitMainForm.ITMAddTFileClick(Sender: TObject);
begin
  if OpenTorrent.Execute then
  begin
    AddTorrentDlg.qB := qB;
    AddTorrentDlg.FileList := OpenTorrent.Files;
    AddTorrentDlg.ShowModal;
  end;
end;

procedure TqBitMainForm.WMDropFiles(var Msg: TMessage);
var
  hDrop: THandle;
  FileNAme: string;
begin
  var FL := TStringList.Create;
  hDrop:= Msg.wParam;
  var FileCount := DragQueryFile (hDrop , $FFFFFFFF, nil, 0);
  for var i := 0 to FileCount - 1 do
  begin
    var namelen := DragQueryFile(hDrop, I, nil, 0) + 1;
    SetLength(FileName, namelen);
    DragQueryFile(hDrop, I, Pointer(FileName), namelen);
    SetLength(FileName, namelen - 1);
    FL.Add(FileName);
  end;
  if FL.Count > 0 then
  begin
    AddTorrentDlg.qB := qB;
    AddTorrentDlg.FileList := FL;
    AddTorrentDlg.ShowModal;
  end;
  FL.Free;
  DragFinish(hDrop);
end;


procedure TqBitMainForm.ITMDelTOnlyClick(Sender: TObject);
begin
  var SH := GetGridSelHashes;
  qB.DeleteTorrents(SH, False);
  Self.FCurrentSelectedHash := '';
  SH.Free;
end;

procedure TqBitMainForm.ITMDelWithDataClick(Sender: TObject);
begin
  FMainLock := True;
  var SH := GetGridSelHashes;
  qB.DeleteTorrents(SH, True);
  SH.Free;
  FMainLock := False;
end;

procedure TqBitMainForm.ITMPauseClick(Sender: TObject);
begin
  var SH := GetGridSelHashes;
  qB.PauseTorrents(SH);
  SH.Free;
end;

procedure TqBitMainForm.ITMRenameClick(Sender: TObject);
begin
  var T := GetLastGridSelTorrent;
  if not assigned(T) then Exit;
  var K := T._Fkey;
  var NewName := InputBox('Rename', 'New Name :', T.Fname);
  if  NewName <> '' then qB.SetTorrentName(K, NewName);
end;

procedure TqBitMainForm.ITMResumeClick(Sender: TObject);
begin
  var SH := GetGridSelHashes;
  qB.ResumeTorrents(SH);
  SH.Free;
end;

procedure TqBitMainForm.ITMSelectAllClick(Sender: TObject);
begin
  Self.MainFrame.SelectAll
end;

procedure TqBitMainForm.ITMSetLocClick(Sender: TObject);
begin
  var SH := GetGridSelHashes;
  if SH.Count = 1 then
    SetLocationDlg.Location.Text := Self.GetLastGridSelTorrent.Fsave_path
  else
    SetLocationDlg.Location.Text := qBPrefs.Fsave_path;
  if (SetLocationDlg.ShowModal = mrOk) then
     qB.SetTorrentLocation(SH, SetLocationDlg.Location.Text);
  SH.Free;
end;

procedure TqBitMainForm.PageControl1Change(Sender: TObject);
begin
  case PageControl1.ActivePageIndex of
  0: Self.ThInfo.Refresh := True;
  1: Self.ThPeers.Refresh := True;
  2: Self.ThTrkrs.Refresh := True;
  end;
end;

procedure TqBitMainForm.PMISpeedLimitsClick(Sender: TObject);
begin
  SpeedLimitsDlg.SetSpeedLimits(
    qBPrefs.Fup_limit,
    qBPrefs.Fdl_limit,
    qBPrefs.Falt_up_limit,
    qBPrefs.Falt_dl_limit
  );
  if SpeedLimitsDlg.ShowModal = mrOk then
  begin
    var NewPrefs := TqBitPreferencesType.Create;
    SpeedLimitsDlg.GetSpeedLimits(
      NewPrefs.Fup_limit,
      NewPrefs.Fdl_limit,
      NewPrefs.Falt_up_limit,
      NewPrefs.Falt_dl_limit
    );
    qB.SetPreferences(NewPrefs);
    qBPrefs.Free;
    qBPrefs := qB.GetPreferences;
    NewPrefs.Free;
  end;
end;

procedure TqBitMainForm.StatusBarClick(Sender: TObject);
begin
  Qb.ToggleAlternativeSpeedLimits;
  Self.ThMain.Refresh := True;
end;

procedure TqBitMainForm.UpdatePeersUI;
begin
  var RttiCtx := TRttiContext.Create();
  var RttiType := RttiCtx.GetType(TqBitTorrentPeerDataType);

  var TSortList := TObjectList<TqBitTorrentPeerDataType>.Create(False);
  for var T in qBTPeers.Fpeers do
  begin
    TqBitTorrentPeerDataType(T.Value)._FKey := T.Key;
    TSortList.Add(TqBitTorrentPeerDataType(T.Value));
  end;

  TSortList.Sort(TComparer<TqBitTorrentPeerDataType>.Construct(
    function (const L, R: TqBitTorrentPeerDataType): integer
    begin
      Result := 0;
      for var Field in RttiType.GetFields do
      begin
        if Field.Name = Self.PeersFrame.SortField then
        begin
          var LVal := Field.GetValue(L).asVariant;
          var RVal := Field.GetValue(R).asVariant;
          if LVal > RVal then
            if Self.PeersFrame.SortReverse then Result := -1 else Result := 1;
          if RVal > LVal then
            if Self.PeersFrame.SortReverse then Result := 1 else Result := -1;
        end;
      end;
    end
  ));

  PeersFrame.RowUpdateStart;
  for var T in TSortList do
    PeersFrame.AddRow(TqBitTorrentPeerDataType(T).Fip, T);
  PeersFrame.RowUpdateEnd;

  TSortList.Free;
  RttiCtx.Free;

end;

procedure TqBitMainForm.UpdateMainUI;
begin
  if FMainLock then exit;

  var RttiCtx := TRttiContext.Create();
  var RttiType := RttiCtx.GetType(TqBitTorrentType);

  var TSortList := TObjectList<TqBitTorrentType>.Create(False);

  if Assigned(qBMain.Ftorrents) then
  for var T in qBMain.Ftorrents do
  begin
    TqBitTorrentType(T.Value)._FKey := T.Key;
    TSortList.Add(TqBitTorrentType(T.Value));
  end;

  // Filtering Categories
  for var i := TSortList.Count - 1 downto 0 do
  begin
    var ToDelete := False;
    if CBCat.ItemIndex > 0  then
    begin
      if (CBCat.ItemIndex = 1)
          and (TqBitTorrentType(TSortList[i]).Fcategory <> '')
      then
        ToDelete := True;
      if (CBCat.ItemIndex > 1)
          and (TqBitTorrentType(TSortList[i]).Fcategory <> CBCat.Items[CBCat.ItemIndex])
      then
        ToDelete := True;
     end;

     // Filtering Tags
     if CBTag.ItemIndex > 0  then
     begin
      var Tag := TqBitTorrentType(TSortList[i]).Ftags;
      if (CBTag.ItemIndex = 1) then
          if (TqBitTorrentType(TSortList[i]).Ftags <> '')
      then
        ToDelete := True;
      if (CBTag.ItemIndex > 1)
          and (Pos(CBTag.Items[CBTag.ItemIndex], TqBitTorrentType(TSortList[i]).Ftags) = 0)
      then
        ToDelete := True;
     end;

     if ToDelete then TSortList.Delete(i);
  end;

  // Filtering Status
  for var j := 0 to CBStatus.Items.Count -1 do
    CBStatus.Items.Objects[j] := Nil;
  for var i := TSortList.Count - 1 downto 0 do
  begin
    var ToKeep := False;
    var Status := lowerCase(TqBitTorrentType(TSortList[i]).Fstate);
    for var j := 0 to CBStatus.Items.Count -1 do
    begin
      case j of
        0: begin // All
          CBStatus.Items.Objects[j] := Pointer(Integer(CBStatus.Items.Objects[j]) + 1);
          ToKeep := ToKeep or (CBStatus.ItemIndex = j);
        end;
        1: begin // downloading
          if (Status = 'downloading') or (Status = 'stalleddl') then
          begin
            CBStatus.Items.Objects[j] := Pointer(Integer(CBStatus.Items.Objects[j]) + 1);
            ToKeep := ToKeep or (CBStatus.ItemIndex = j);
          end;
        end;
        2: begin // uploading
          if (Status = 'uploading') or (Status = 'stalledup') then
          begin
            CBStatus.Items.Objects[j] := Pointer(Integer(CBStatus.Items.Objects[j]) + 1);
            ToKeep := ToKeep or (CBStatus.ItemIndex = j);;
          end;
        end;
        3: begin // completed
          if (Status = 'uploading') or (Status = 'stalledup') or (Status = 'pausedup') then
          begin
            CBStatus.Items.Objects[j] := Pointer(Integer(CBStatus.Items.Objects[j]) + 1);
            ToKeep := ToKeep or (CBStatus.ItemIndex = j);
          end;
        end;
        4: begin // paused;
          if (Status = 'pausedup') or (Status = 'pauseddl') then
          begin
            CBStatus.Items.Objects[j] := Pointer(Integer(CBStatus.Items.Objects[j]) + 1);
            ToKeep := ToKeep or (CBStatus.ItemIndex = j);
          end;
        end;
        5: begin // Stalled
          if (Status = 'stalledup') or (Status = 'stalleddl') then
          begin
            CBStatus.Items.Objects[j] := Pointer(Integer(CBStatus.Items.Objects[j]) + 1);
            ToKeep := ToKeep or (CBStatus.ItemIndex = j);;
          end;
        end;
        6: begin // Errored
          if (Status = 'missingfiles') then
          begin
            CBStatus.Items.Objects[j] := Pointer(Integer(CBStatus.Items.Objects[j]) + 1);
            ToKeep := ToKeep or (CBStatus.ItemIndex = j);;
          end;
        end;

      end;
    end;
    if not ToKeep then TSortList.Delete(i);
  end;

  // Filtering String
  if EditSearch.Text <> '' then
    for var i := TSortList.Count - 1 downto 0 do
    begin
      if Pos(LowerCase(Trim(EditSearch.Text)), LowerCase(TqBitTorrentType(TSortList[i]).Fname)) = 0 then
        TSortList.Delete(i);
  end;

  // Sorting
  TSortList.Sort(TComparer<TqBitTorrentType>.Construct(
      function (const L, R: TqBitTorrentType): integer
      begin
        Result := 0;
        for var Field in RttiType.GetFields do
        begin
          if Field.Name = Self.MainFrame.SortField then
          begin
            var LVal := Field.GetValue(L).asVariant;
            var RVal := Field.GetValue(R).asVariant;
            if LVal > RVal then
              if Self.MainFrame.SortReverse then Result := -1 else Result := 1;
            if RVal > LVal then
              if Self.MainFrame.SortReverse then Result := 1 else Result := -1;
          end;
        end;
      end
  ));

  // Displaying Grid

  MainFrame.RowUpdateStart;
  for var T in TSortList do
    MainFrame.AddRow(TqBitTorrentType(T)._FKey, T);
  MainFrame.RowUpdateEnd;

  // Displaying Tags
  if qBMain.Ffull_update or qBMain._Ftags_changed then
  begin
    CBTag.Items.Clear;
    CBTag.Items.Add('All');
    CBTag.Items.Add('Unassigned');
    for var Tag in qBMain.Ftags do CBTag.Items.Add(Tag);
    CBTag.ItemIndex := 0;
  end;

  // Displaying Status
  var StatusIndex := CBStatus.ItemIndex;
  for var i := 0 to CBStatus.Items.Count -1 do
  case i of
    0: CBStatus.Items[i] := Format('All (%d)', [Integer(CBStatus.Items.Objects[i])]);
    1: CBStatus.Items[i] := Format('Downloading (%d)', [Integer(CBStatus.Items.Objects[i])]);
    2: CBStatus.Items[i] := Format('Seeding (%d)', [Integer(CBStatus.Items.Objects[i])]);
    3: CBStatus.Items[i] := Format('Completed (%d)', [Integer(CBStatus.Items.Objects[i])]);
    4: CBStatus.Items[i] := Format('Paused (%d)', [Integer(CBStatus.Items.Objects[i])]);
    5: CBStatus.Items[i] := Format('Stalled (%d)', [Integer(CBStatus.Items.Objects[i])]);
    6: CBStatus.Items[i] := Format('Errored (%d)', [Integer(CBStatus.Items.Objects[i])]);
  end;
  CBStatus.ItemIndex := StatusIndex;

    // Displaying Categories

  if qBMain.Ffull_update or qBMain._Fcategories_changed then
  begin
    CBCat.Items.Clear;
    CBCat.Items.Add('All');
    CBCat.Items.Add('Unassigned');
    for var Cat in qBMain.Fcategories do CBCat.Items.Add(Cat.Key);
    CBCat.ItemIndex := 0;
  end;


  // StatusBar;

  StatusBar.Panels[0].Text := TitleCase( qBMain.Fserver_state.Fconnection_status );
  StatusBar.Panels[1].Text := ' Free space: ' + VarFormatBKM(qBMain.Fserver_state.Ffree_space_on_disk);
  StatusBar.Panels[2].Text := Format('DHT: %s nodes', [VarToStr(qBMain.Fserver_state.Fdht_nodes)]);
  if qBMain.Fserver_state.Fuse_alt_speed_limits then
    StatusBar.Panels[3].Text := ' @ ' // ' ? '
  else
    StatusBar.Panels[3].Text := '  '; // ' ? ';
  if qBMain.Fserver_state.Fdl_rate_limit > 0 then
    StatusBar.Panels[4].Text :=
      Format('🡻 %s [%s]', [
         VarFormatBKMPerSec(qBMain.Fserver_state.Fdl_info_speed),
         VarFormatBKMPerSec(qBMain.Fserver_state.Fdl_rate_limit)
      ])
  else
    StatusBar.Panels[4].Text :=
      Format('🡻 %s [?]', [
         VarFormatBKMPerSec(qBMain.Fserver_state.Fdl_info_speed)
      ]);
  if qBMain.Fserver_state.Fup_rate_limit > 0 then
    StatusBar.Panels[5].Text :=
      Format('🡹 %s [%s]', [
         VarFormatBKMPerSec(qBMain.Fserver_state.Fup_info_speed),
         VarFormatBKMPerSec(qBMain.Fserver_state.Fup_rate_limit)
      ])
  else
    StatusBar.Panels[5].Text :=
      Format('🡹 %s [?]', [
         VarFormatBKMPerSec(qBMain.Fserver_state.Fup_info_speed)
      ]);
  if assigned(IP) then
    StatusBar.Panels[6].Text := 'IP : ' + IP.Fip + ' / ' + IP.Fcountry;
  // Caption := qBMain.Ftorrents.Count.ToString;
  Caption :=  Format('qNOXify : %s - %s/%s Torrents',
              [
                qB.HostPath,
                TSortList.Count.ToString,
                qBMain.Ftorrents.Count.ToString
              ]);

  TSortList.Free;
  RttiCtx.Free;
end;

procedure TqBitMainForm.UpdateTrkrsUI;
var
  LVal, RVal : variant;
begin
  var RttiCtx := TRttiContext.Create();
  var RttiType := RttiCtx.GetType(TqBitTrackerType);

  var TSortList := TObjectList<TqBitTrackerType>.Create(False);
  for var T in qBTTrkrs.Ftrackers do TSortList.Add(TqBitTrackerType(T));

  TSortList.Sort(TComparer<TqBitTrackerType>.Construct(
    function (const L, R: TqBitTrackerType): integer
    begin
      Result := 0;
      for var Field in RttiType.GetFields do
      begin
        if Field.Name = Self.TrkrFrame.SortField then
        begin
          if Field.Name = 'Ftier' then  // Ftier can be real and/or string : force to string
          begin
             LVal := VarToStr(Field.GetValue(L).asVariant);
            RVal := VarToStr(Field.GetValue(R).asVariant);
          end else begin
            LVal := Field.GetValue(L).asVariant;
            RVal := Field.GetValue(R).asVariant;
          end;
          if LVal > RVal then
            if Self.TrkrFrame.SortReverse then Result := -1 else Result := 1;
          if RVal > LVal then
            if Self.TrkrFrame.SortReverse then Result := 1 else Result := -1;
        end;
      end;
    end
  ));

  TrkrFrame.RowUpdateStart;
  for var T in TSortList do
    TrkrFrame.AddRow(TqBitTrackerType(T).Ftier, T);
  TrkrFrame.RowUpdateEnd;

  TSortList.Free;
  RttiCtx.Free;
end;

procedure TqBitMainForm.UpdateTInfosUI;
begin
    //if Self.MainFrame.LastSelectedData then

    SGDetails.ColAlignments[0] := taRightJustify;
    SGDetails.ColWidths[0] := 128;
    SGDetails.ColAlignments[1] := taLeftJustify;
    SGDetails.ColWidths[1] := 200;
    SGDetails.ColAlignments[2] := taRightJustify;
    SGDetails.ColWidths[2] := 128;
    SGDetails.ColAlignments[3] := taLeftJustify;
    SGDetails.ColWidths[3] := 200;
    SGDetails.ColAlignments[4] := taRightJustify;
    SGDetails.ColWidths[4] := 128;
    SGDetails.ColAlignments[5] := taLeftJustify;
    SGDetails.ColWidths[5] := 200;

    SGDetails.Cells[0, 1] := 'Time Active : '; SGDetails.RowHeights[1] := 20;
    SGDetails.Cells[0, 2] := 'Downloaded : '; SGDetails.RowHeights[2] := 20;
    SGDetails.Cells[0, 3] := 'Download Speed : '; SGDetails.RowHeights[3] := 20;
    SGDetails.Cells[0, 4] := 'Download Limit : '; SGDetails.RowHeights[4] := 20;
    SGDetails.Cells[0, 5] := 'Share Ratio : '; SGDetails.RowHeights[5] := 20;
    SGDetails.RowHeights[6] := 20;
    SGDetails.Cells[0, 7] := 'Total Size : '; SGDetails.RowHeights[7] := 20;
    SGDetails.Cells[0, 8] := 'Added On : '; SGDetails.RowHeights[8] := 20;
    SGDetails.Cells[0, 9] := 'Hash : '; SGDetails.RowHeights[9] := 20;
    SGDetails.Cells[0, 10] := 'Save Path : '; SGDetails.RowHeights[10] := 20;
    SGDetails.Cells[0, 11] := 'Comment : '; SGDetails.RowHeights[11] := 20;

    SGDetails.Cells[2, 1] := 'ETA : ';
    SGDetails.Cells[2, 2] := 'Uploded : ';
    SGDetails.Cells[2, 3] := 'Upload Speed : ';
    SGDetails.Cells[2, 4] := 'Upload Limit : ';
    SGDetails.Cells[2, 5] := 'Reannounce In : ';
    SGDetails.Cells[2, 7] := 'Pieces :';
    SGDetails.Cells[2, 8] := 'Completed On :';

    SGDetails.Cells[4, 1] := 'Connections : ';
    SGDetails.Cells[4, 2] := 'Seeds : ';
    SGDetails.Cells[4, 3] := 'Peers : ';
    SGDetails.Cells[4, 4] := 'Wasted : ';
    SGDetails.Cells[4, 5] := 'Last Seen Complete : ';

    var T := GetLastGridSelTorrent;
    if T = nil then Exit;

    SGDetails.Cells[1, 1] := VarFormatDuration(T.Ftime_active);
    SGDetails.Cells[1, 2] := Format('%s (%s this session)',
      [VarFormatBKM(T.Fdownloaded), VarFormatBKM(T.Fdownloaded_session)]);
    SGDetails.Cells[1, 3] := VarFormatBKMPerSec(T.Fdlspeed);
    SGDetails.Cells[1, 4] := VarFormatLimit(T.Fdl_limit);
    SGDetails.Cells[1, 5] := VarFormatFloat2d(T.Fratio);
    SGDetails.Cells[1, 7] := VarFormatBKM(T.Fsize);
    SGDetails.Cells[1, 8] := VarFormatDate(T.Fadded_on);
    SGDetails.Cells[1, 9] := VarFormatString(T._Fkey);
    SGDetails.Cells[1, 10] := VarFormatString(T.Fsave_path);
    SGDetails.Cells[1, 11] := VarFormatString(qbTInfo.Fcomment);

    SGDetails.Cells[3, 1] := VarFormatDeltaSec(T.Feta);
    SGDetails.Cells[3, 2] := Format('%s (%s this session)',
      [VarFormatBKM(T.Fuploaded), VarFormatBKM(T.Fuploaded_session)]);
    SGDetails.Cells[3, 3] := VarFormatBKMPerSec(T.Fupspeed);
    SGDetails.Cells[3, 4] := VarFormatLimit(T.Fup_limit);
      SGDetails.Cells[3, 5] := VarFormatDuration(qBTInfo.Freannounce);
    SGDetails.Cells[3, 7] :=
      Format('%s x %s (have %s )', [VarToStr(qBTInfo.Fpieces_num), VarFormatBKM(qBTInfo.Fpiece_size), VarToStr(qBTInfo.Fpieces_have)]);
    SGDetails.Cells[3, 8] := VarFormatDate(T.Fcompletion_on);

    SGDetails.Cells[5, 1] := Format('%s (%s max)', [VarToStr(qBTInfo.Fnb_connections), VarFormatLimit(qBTInfo.Fnb_connections_limit)]);
    SGDetails.Cells[5, 2] := Format('%s (%s total)', [VarToStr(T.Fnum_seeds), qBTInfo.Fseeds_total]);
    SGDetails.Cells[5, 3] := Format('%s (%s total)', [VarToStr(T.Fnum_leechs), qBTInfo.Fpeers_total]);
    SGDetails.Cells[5, 4] := VarFormatBKM(qBTInfo.Ftotal_wasted);
    SGDetails.Cells[5, 5] := VarFormatDate(qBTInfo.Flast_seen);
end;

procedure TqBitMainForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(IP);
  FreeAndNil(qBPrefs);
  FreeAndNil(ThMain);
  FreeAndNil(ThInfo);
  FreeAndNil(ThPeers);
  FreeAndNil(ThTrkrs);
  FreeAndNil(qBMain);
  FreeAndNil(qBTPeers);
  FreeAndNil(qBTTrkrs);
  FreeAndNil(qBTinfo);
  TrkrFrame.DoDestroy;
  PeersFrame.DoDestroy;
  MainFrame.DoDestroy;
  FreeAndNil(qB);
end;

{$REGION 'Frames callbacks'}

procedure TqBitMainForm.BitBtn1Click(Sender: TObject);
begin
  Self.EditSearch.Clear
end;

procedure TqBitMainForm.DoMainEventPopup(Sender: TObject; X, Y, aCol,
  aRow: integer);
begin
  //FMainLock := True;
  try
    PMMain.Popup(X,Y);
  finally
    //FMainLock := False;
  end;
end;

procedure TqBitMainForm.DoRowsSelectedMain(Sender: TObject);
begin
  var SelHashes := GetGridSelHashes;
  if SelHashes.Count = 0 then
  begin
    FCurrentSelectedHash := '';
  end else begin
    if FCurrentSelectedHash <> SelHashes[ SelHashes.Count -1 ] then
    begin
      FCurrentSelectedHash := SelHashes[ SelHashes.Count -1 ];
      Self.ThPeers.Refresh := True;
      Self.ThTrkrs.Refresh := True;
      Self.ThInfo.Refresh := True;
    end;
  end;
  SelHashes.Free;
end;

procedure TqBitMainForm.DoRowsSelectedPeers(Sender: TObject);
begin
//
end;

procedure TqBitMainForm.DoUpdateMainUI(Sender: TObject);
begin
  Self.UpdateMainUI;
end;

procedure TqBitMainForm.DoUpdatePeersUI(Sender: TObject);
begin
  Self.UpdatePeersUI;
end;

procedure TqBitMainForm.DoUpdateTrkrsUI(Sender: TObject);
begin
  Self.UpdateTrkrsUI;
end;

procedure TqBitMainForm.DoUpdateTinfoUI(Sender: TObject);
begin
  Self.UpdateTinfosUI;
end;

{$ENDREGION}

{$REGION 'TqBitThread Sync callbacks'}

procedure TqBitMainForm.ThreadDisconnect(Sender: TThread);
begin
  //
end;

procedure TqBitMainForm.ThreadMainUpdated(Sender: TqBitMainThread);
begin
  FreeAndNil(qBMain);
  qBMain := TqBitMainDataType( Sender.qBMain.Clone );
  UpdateMainUI;
end;

procedure TqBitMainForm.ThreadGetSelectedHash(Sender: TqBitThread);
begin
  Sender.Hash :='';
  case PageControl1.ActivePageIndex of
  0: begin
     if Sender is TqBitTInfosThread then
       Sender.Hash := Self.FCurrentSelectedHash;
  end;
  1: begin
     if Sender is TqBitTPeersThread then
       Sender.Hash := Self.FCurrentSelectedHash;
  end;
  2: begin
     if Sender is TqBitTTrkrsThread then
       Sender.Hash := Self.FCurrentSelectedHash;
  end;
  end;
end;

procedure TqBitMainForm.ThreadTPeersUpdated(Sender: TqBitTPeersThread);
begin
  FreeAndNil(qBTPeers);
  qBTPeers := TqBitTorrentPeersDataType( Sender.qBTPeers.Clone );
  UpdatePeersUI;
end;

procedure TqBitMainForm.ThreadTTrkrUpdated(Sender: TqBitTTrkrsThread);
begin
  FreeAndNil(qBTTrkrs);
  qBTTrkrs := TqBitTrackersType( Sender.qBTTrkrs.Clone );
  UpdateTrkrsUI;
end;

procedure TqBitMainForm.ThreadTInfoUpdated(Sender: TqBitTInfosThread);
begin
  FreeAndNil(Self.qBTInfo);
  qBTInfo := TqBitTorrentInfoType( Sender.qBTInfo.Clone );
  UpdateTinfosUI;
end;

{$ENDREGION}

{$REGION 'TqBitThreads Implementation'}

{ TqBitTPeersThread }

procedure TqBitTPeersThread.Execute;
begin
  var CurrentHash := '';
  while not Terminated do
  begin
    Refresh := False;
    var Tme := GetTickCount;
    Synchronize( procedure begin qBitMainForm.ThreadGetSelectedHash(Self); end );
    if Hash <> '' then
    begin
      if Hash <> CurrentHash then
      begin
        CurrentHash := Hash;
        FreeAndNil(qBTPeers);
        qBTPeers := qBTh.GetTorrentPeersData(Hash, 0);
        if qBTPeers = Nil then
                          beep;
      end else begin
        if qBTPeers = Nil then
                          beep;
        var U := qBTh.GetTorrentPeersData(Hash, qBTPeers.Frid);
        if U = nil then
        begin
          //Synchronize( procedure begin qBitMainForm.ThreadDisconnect(Self); end );
          //Terminate;
        end else begin
          qBTPeers.Merge(U);
          FreeAndNil(U);
        end;
      end;
      Synchronize( procedure begin qBitMainForm.ThreadTPeersUpdated(Self); end );
    end else begin
      CurrentHash := '';
      FreeAndNil(qBTPeers);
    end;
    while
      (GetTickCount - Tme < THREAD_WAIT_TIME_ME)
      and (not Terminated) and (not Refresh)
    do
      Sleep(250);
  end;
  FreeAndNil(qBTPeers);
  FreeAndNil(qBTh);
end;

{ TqBitTInfoThread }

procedure TqBitTInfosThread.Execute;
begin
  var CurrentHash := '';
  while not Terminated do
  begin
    Refresh := False;
    var Tme := GetTickCount;
    Synchronize( procedure begin qBitMainForm.ThreadGetSelectedHash(Self); end );
    FreeAndNil(qBTInfo);
    if Hash <> '' then
    begin
        qBTInfo := qBTh.GetTorrentGenericProperties(Hash);
        if qBTInfo = nil then
        begin
          // Synchronize( procedure begin qBitMainForm.ThreadDisconnect(Self); end );
          // Terminate;
        end else
          Synchronize( procedure begin qBitMainForm.ThreadTInfoUpdated(Self); end );
    end;
    while
      (GetTickCount - Tme < THREAD_WAIT_TIME_ME)
      and (not Terminated) and (not Refresh)
    do
      Sleep(250);
  end;
  FreeAndNil(qBTInfo);
  FreeAndNil(qBTh);
end;


{ TqBitMainThread }

procedure TqBitMainThread.Execute;
begin
  qBMain := qBTh.GetMainData(0); // Full server data update
  Synchronize( procedure begin qBitMainForm.ThreadMainUpdated(Self); end );
  while not Terminated do
  begin
    Refresh := False;
    var Tme := GetTickCount;
    var U := qBTh.GetMainData(qBMain.Frid); // get differential data from last call
    if U = nil then
    begin
      Synchronize( procedure begin qBitMainForm.ThreadDisconnect(Self); end );
      Terminate;
    end else begin
      qBMain.Merge(U); // Merge to qBMain to be update to date
      U.Free;
      Synchronize( procedure begin qBitMainForm.ThreadMainUpdated(Self); end );
      while
        (GetTickCount - Tme < THREAD_WAIT_TIME_ME)
        and (not Terminated) and (not Refresh)
      do
        Sleep(250);
    end;
  end;
  FreeAndNil(qBMain);
  FreeAndNil(qBTh);
end;

{ TqBitTTrkrsThread }

procedure TqBitTTrkrsThread.Execute;
begin
  var CurrentHash := '';
  while not Terminated do
  begin
    Refresh := False;
    var Tme := GetTickCount;
    Synchronize( procedure begin qBitMainForm.ThreadGetSelectedHash(Self); end );
    FreeAndNil(qBTTrkrs);
    if Hash <> '' then
    begin
        qBTTrkrs := qBTh.GetTorrentTrackers(Hash);
        if qBTTrkrs = nil then
        begin
          // Synchronize( procedure begin qBitMainForm.ThreadDisconnect(Self); end );
          // Terminate;
        end else
          Synchronize( procedure begin qBitMainForm.ThreadTTrkrUpdated(Self); end );
    end;
    while
      (GetTickCount - Tme < THREAD_WAIT_TIME_ME)
      and (not Terminated) and (not Refresh)
    do
      Sleep(250);
  end;
  FreeAndNil(qBTTrkrs);
  FreeAndNil(qBTh)

end;

{$ENDREGION}


end.
