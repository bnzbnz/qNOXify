unit uqBitAddTorrentDlg;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uqBitAPITypes, uqBitAPI, uqBitObject,
  Vcl.StdCtrls, Vcl.Samples.Spin, Vcl.ExtCtrls;

type
  TqBitAddTorrentDlg = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    TTM: TComboBox;
    SFL: TEdit;
    RT: TEdit;
    CBCat: TComboBox;
    CBCL: TComboBox;
    Label3: TLabel;
    ChkDefault: TCheckBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    CBST: TCheckBox;
    CBSHT: TCheckBox;
    CBDSO: TCheckBox;
    CBFLP: TCheckBox;
    ComboBox1: TComboBox;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    ComboBox2: TComboBox;
    BtnCancel: TButton;
    BtnOK: TButton;
    Bevel1: TBevel;
    GroupBox1: TGroupBox;
    TILblName: TLabel;
    TILblSize: TLabel;
    TIEditName: TEdit;
    TIEditSize: TEdit;
    TIEditHashV1: TEdit;
    Label8: TLabel;
    TIEditHashV2: TEdit;
    Label11: TLabel;
    TIEditComment: TMemo;
    Panel4: TPanel;
    LBFiles: TListBox;
    Label12: TLabel;
//    Label9: TLabel;
//    Label10: TLabel;
    procedure FormShow(Sender: TObject);
    procedure TTMChange(Sender: TObject);
    procedure LBFilesClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FqB: TqBitObject;
    FqBMain: TqBitMainDataType;
    function UpLoadTorrents: Boolean;
    procedure SetVisible(Visible: Boolean);
    function GetVisible: Boolean;
    function ShowModal: Integer; override;
    procedure ClearLBList;
  public
    { Public declarations }
    //function ShowAsModal(qB: TqBitObject; FileList: TStrings): TModalResult;
    function ShowAsModal(qB: TqBitObject; qBMain: TqBitMainDataType; FileList: TStrings): TModalResult;
    property Visible: Boolean read GetVisible write SetVisible;
  end;

var
  qBitAddTorrentDlg: TqBitAddTorrentDlg;

implementation
uses Math, uTorrentReader, uqBitFormat;

{$R *.dfm}

// https://stackoverflow.com/questions/12946150/how-to-bring-my-application-to-the-front
procedure ForceForegroundNoActivate(hWnd : THandle);
begin
 if IsIconic(Application.Handle) then
  ShowWindow(Application.Handle, SW_SHOWNOACTIVATE);
 SetWindowPos(hWnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOACTIVATE or SWP_NOMOVE);
 SetWindowPos(hWnd, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOACTIVATE or SWP_NOMOVE);
end;

procedure TqBitAddTorrentDlg.FormDestroy(Sender: TObject);
begin
  ClearLBList;
end;

procedure TqBitAddTorrentDlg.FormShow(Sender: TObject);
begin
  ForceForegroundNoActivate(Self.Handle);
end;

function TqBitAddTorrentDlg.GetVisible: Boolean;
begin
  Result := Self.ChkDefault.Checked;
end;

procedure TqBitAddTorrentDlg.LBFilesClick(Sender: TObject);
begin
  var Index := LBFiles.ItemIndex;
  if Index = -1  then  Exit;
  var Name := LBFiles.Items[ Index ];
  var TorrentFData := TTorrentReader.LoadFromFile(Name, []);
  if TorrentFData = nil then Exit;
  if TorrentFData.Data.Info.HasMultipleFiles then
    TIEditName.Text := TorrentFData.Data.Info.Name
  else
    TIEditName.Text := TorrentFData.Data.Info.FileList[0].FullPath;
  TIEditSize.Text := VarFormatBKM(TorrentFData.Data.Info.FilesSize);
  TIEditHashV1.Text := TorrentFData.Data.HashV1;
  TIEditHashV2.Text := TorrentFData.Data.HashV2;
  TIEditComment.Text := TorrentFData.Data.Comment.Text;
  TorrentFData.Free;
end;

procedure TqBitAddTorrentDlg.SetVisible(Visible: Boolean);
begin
  Self.ChkDefault.Checked := Visible;
end;

function TqBitAddTorrentDlg.ShowAsModal(qB: TqBitObject; qBMain: TqBitMainDataType; FileList: TStrings): TModalResult;
begin
  FqB := qB;
  FqBMain := qBMain;
  If (FileList.Count = 0) then Exit;

  ClearLBList;
  for var F in FileList do
  begin
    var TorrentFData := TTorrentReader.LoadFromFile(F, []);
    if TorrentFData <> Nil then LBFiles.Items.AddObject(F, TorrentFData);
  end;
  LBFiles.ItemIndex := 0;
  LBFilesClick(Self);


  RT.Text := '';
  RT.Enabled := FileList.Count = 1;
  if (GetKeyState(VK_CONTROL) < 0) or  (GetKeyState(VK_SHIFT) < 0) then
     ChkDefault.Checked := False;

  if assigned(qBMain.Fcategories) then
  begin
    var CurCat := CBCat.Text;
    CBCat.Clear;
    CBCat.Sorted := True;
    CBCat.items.Add('');
    for var Cat in qBMain.Fcategories do
      CBCat.items.Add(Cat.Key);
    for var I := 0 to  CBCat.Items.Count - 1 do
      if CBCat.Items[I] = CurCat then
         CBCat.ItemIndex := I;
  end;

  if ChkDefault.Checked then
  begin
    UploadTorrents;
    Result := mrOk;
    PostMessage(Handle, WM_CLOSE, 0, 0);
    Exit;
  end else begin
    Result := inherited ShowModal;
    if Result = mrOk then
      UploadTorrents;
  end;
end;

function TqBitAddTorrentDlg.ShowModal: Integer;
begin
  ShowMessage('Please Call TAddTorrentDlg.ShowAsModal instead of ShowModal...');
end;

procedure TqBitAddTorrentDlg.TTMChange(Sender: TObject);
begin
  SFL.Enabled := TTM.ItemIndex = 0;
end;

procedure TqBitAddTorrentDlg.ClearLBList;
begin
   for var i := 0 to LBFiles.Count - 1 do
     LBFiles.Items.Objects[i].Free;
   LBFiles.Clear;
end;

function TqBitAddTorrentDlg.UpLoadTorrents: Boolean;
begin
  for var F in LBFiles.Items do
  begin
    var NewTorrent := TqBitNewTorrentFileType.Create;
    NewTorrent.Ffilename:= F;
    NewTorrent.FautoTMM := TTM.ItemIndex = 1;
    NewTorrent.FsavePath := SFL.Text;
    NewTorrent.Frename := RT.Text;
    NewTorrent.Fcategory := CBCat.Text;
    NewTorrent.Fpaused :=  not CBST.Checked;
    NewTorrent.Fskip_Checking := CBSHT.Checked;
    NewTorrent.FcontentLayout := CBCL.Text;
    NewTorrent.FsequentialDownload := CBDSO.Checked;
    NewTorrent.FfirstLastPiecePrio := CBFLP.Checked;
    NewTorrent.FdlLimit := 1024 * SpinEdit1.Value * Max(ComboBox1.ItemIndex * 1024, 1);
    NewTorrent.FupLimit := 1024 * SpinEdit2.Value * Max(ComboBox2.ItemIndex * 1024, 1);
    Result := FqB.AddNewTorrentFile(NewTorrent);
    NewTorrent.Free;
  end;
end;

end.
