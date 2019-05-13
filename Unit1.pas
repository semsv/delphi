unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent, IdTCPServer, IdFTPServer, IdFTPList,
  StdCtrls, Spin;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ListBox1: TListBox;
    Edit1: TEdit;
    SpinEdit1: TSpinEdit;
    Label1: TLabel;
    procedure IdFTPServer1ListDirectory(ASender: TIdFTPServerThread;
      const APath: String; ADirectoryListing: TIdFTPListItems);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure IdFTPServer1Status(ASender: TObject;
      const AStatus: TIdStatus; const AStatusText: String);
    procedure IdFTPServer1Connect(AThread: TIdPeerThread);
    procedure IdFTPServer1UserLogin(ASender: TIdFTPServerThread;
      const AUsername, APassword: String; var AAuthenticated: Boolean);
    procedure IdFTPServer1ChangeDirectory(ASender: TIdFTPServerThread;
      var VDirectory: String);
    procedure IdFTPServer1StoreFile(ASender: TIdFTPServerThread;
      const AFileName: String; AAppend: Boolean; var VStream: TStream);
    procedure IdFTPServer1RetrieveFile(ASender: TIdFTPServerThread;
      const AFileName: String; var VStream: TStream);
    procedure FormCreate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure IdFTPServer1Disconnect(AThread: TIdPeerThread);
    procedure SpinEdit1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    IdFTPServer1 : TIdFTPServer;
  end;

  var
    Form1: TForm1;

implementation
{$R *.dfm}
  Var
    RootPath      : string;
    vConnectCount : integer;
    vDataPort     : integer;
    vPort         : integer;

function replace_chr(schr, dchr : CHAR; InStr : String) : String;
  Var
    S : String;
begin
  S := InStr;
  While POS(schr, S) > 0 do
    S[POS(schr, S)] := dchr;
  result := s;  
end;

procedure TForm1.IdFTPServer1ListDirectory(ASender: TIdFTPServerThread;
  const APath: String; ADirectoryListing: TIdFTPListItems);
  var
    Item : TIdFTPListItem;
    F    : TSearchRec;
    res  : integer;
    curr_path : string;
begin
  Listbox1.Items.Add('ListDirectory: ' +  APath);
  ADirectoryListing.Clear;
  if APath = '\' then
  begin
    res := FindFirst(RootPath + '*', faDirectory, F);
     while res = 0 do
     begin
       if (f.attr and faDirectory) = faDirectory then
         begin
           Item              := ADirectoryListing.Add;
           Item.Size         := F.Size;
           Item.ModifiedDate := FileDateToDateTime(F.Time);
           Item.FileName     := F.Name;
           Item.ItemType     := ditDirectory;
         end;
       res := FindNext(F);
     end;

     res := FindFirst(RootPath + '*', faAnyFile, F);
     while res = 0 do
     begin
       if ((f.attr and faDirectory) <> faDirectory) and
          (F.Name <> '.') and
          (F.Name <> '..') then
         begin
           Item              := ADirectoryListing.Add;
           Item.FileName     := F.Name;
           Item.Size         := F.Size;
           Item.ModifiedDate := FileDateToDateTime(F.Time);
           Item.ItemType     := ditFile;
         end;
       res := FindNext(F);
     end;
  end else
  begin
     curr_path := APath;

     if Length(curr_path) > 1 then
      if curr_path[1] = '\' then
        curr_path := copy(curr_path, 2, Length(curr_path)-1);

     if Length(curr_path) > 1 then
      if curr_path[Length(curr_path)] = '\' then
        curr_path := copy(curr_path, 1, Length(curr_path)-1);

     form1.Caption := replace_chr('/', '\', RootPath + curr_path + '*');

     res := FindFirst(RootPath + curr_path + '*', faDirectory, F);
     while res = 0 do
     begin
       if ((f.attr and faDirectory) = faDirectory) and
          (F.Name <> '.') and
          (F.Name <> '..') then
         begin
           Item := ADirectoryListing.Add;
           Item.Size     := F.Size;
           Item.FileName := F.Name;
           Item.ModifiedDate := FileDateToDateTime(F.Time);
           Item.ItemType := ditDirectory;
         end;
       res := FindNext(F);
     end;

     res := FindFirst(RootPath + curr_path + '*', faAnyFile, F);
     while res = 0 do
     begin
       if ((f.attr and faDirectory) <> faDirectory) and
          (F.Name <> '.') and
          (F.Name <> '..') then
         begin
           Item := ADirectoryListing.Add;
           Item.FileName     := F.Name;
           Item.Size         := F.Size;
           Item.ModifiedDate := FileDateToDateTime(F.Time);
           Item.ItemType     := ditFile;
         end;
       res := FindNext(F);
     end;

  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if Assigned(IdFTPServer1) then
  begin
    IdFTPServer1.Destroy;
    IdFTPServer1 := nil;
  end;
  IdFTPServer1 := TIdFTPServer.Create(self);
  IdFTPServer1.DefaultDataPort := vDataPort;
  IdFTPServer1.DefaultPort     := vPort;
  IdFTPServer1.OnConnect         := IdFTPServer1Connect;
  IdFTPServer1.OnUserLogin       := IdFTPServer1UserLogin;
  IdFTPServer1.OnChangeDirectory := IdFTPServer1ChangeDirectory;
  IdFTPServer1.OnListDirectory   := IdFTPServer1ListDirectory;
  IdFTPServer1.OnRetrieveFile    := IdFTPServer1RetrieveFile;
  IdFTPServer1.OnStoreFile       := IdFTPServer1StoreFile;

  IdFTPServer1.Active := true;
  Button1.Enabled     := not IdFTPServer1.Active;
  Button2.Enabled     := IdFTPServer1.Active;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if Assigned(IdFTPServer1) then
  begin
    IdFTPServer1.Active := false;
    Application.ProcessMessages;
    IdFTPServer1        := nil;
  end;
  Button1.Enabled     := true;
  Button2.Enabled     := false;
  vConnectCount       := 0;
end;

procedure TForm1.IdFTPServer1Status(ASender: TObject;
  const AStatus: TIdStatus; const AStatusText: String);
begin
  form1.Caption :=  AStatusText;
end;

procedure TForm1.IdFTPServer1Connect(AThread: TIdPeerThread);
begin
  form1.Caption := 'OnConnect';

  Listbox1.Items.Add( 'OnConnect: ' +   AThread.Connection.Socket.SocksInfo.LocalName );
end;

procedure TForm1.IdFTPServer1UserLogin(ASender: TIdFTPServerThread;
  const AUsername, APassword: String; var AAuthenticated: Boolean);
begin
  Listbox1.Items.Add('UserName: ' + '"' + AUsername + '"' + '; APassword: ' + '"' + APassword + '"');
  AAuthenticated := true;
  vConnectCount := vConnectCount + 1;
end;

procedure TForm1.IdFTPServer1ChangeDirectory(ASender: TIdFTPServerThread;
  var VDirectory: String);
  var curr_path : string;
begin
  curr_path := VDirectory;
  while pos('\', curr_path) > 0 do
   delete(curr_path, 1, pos('\', curr_path));
  VDirectory := curr_path;
  Listbox1.Items.Add('ChangeDirectory: ' + '"' + VDirectory + '"' + '; UserName: ' + '"' + ASender.Username + '"');
end;

procedure TForm1.IdFTPServer1StoreFile(ASender: TIdFTPServerThread;
  const AFileName: String; AAppend: Boolean; var VStream: TStream);
begin
  Listbox1.Items.Add('StoreFile: ' + '"' + AFileName + '"');
end;

procedure TForm1.IdFTPServer1RetrieveFile(ASender: TIdFTPServerThread;
  const AFileName: String; var VStream: TStream);
  var FileStream : TFileStream;
begin
  Listbox1.Items.Add('RetrieveFile: ' +  AFileName);
  FileStream := TFileStream.Create(RootPath + AFileName, fmopenread or fmShareDenyWrite);
  VStream    := FileStream;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  IdFTPServer1 := nil;
  RootPath := edit1.Text;
  if length(RootPath) > 0 then
    if RootPath[length(RootPath)] <> '\' then
      RootPath := RootPath + '\';
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
  RootPath := edit1.Text;
  if length(RootPath) > 0 then
    if RootPath[length(RootPath)] <> '\' then
      RootPath := RootPath + '\';
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 CanClose := (vConnectCount = 0);
end;

procedure TForm1.IdFTPServer1Disconnect(AThread: TIdPeerThread);
begin
  vConnectCount := vConnectCount - 1;
end;

procedure TForm1.SpinEdit1Change(Sender: TObject);
begin
  if (Length(SpinEdit1.Text) > 0) then
  begin
    vPort     := SpinEdit1.Value;
    vDataPort := SpinEdit1.Value-1;
  end;
end;

end.
