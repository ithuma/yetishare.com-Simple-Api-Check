unit apicheck;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, REST.Types, REST.Client, inifiles, coffee,
  Data.Bind.Components, Data.Bind.ObjectScope, Vcl.Buttons,
  StrUtils, Vcl.Menus, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Labelkey1: TLabel;
    Labelkey2: TLabel;
    EditKey1: TEdit;
    EditKey2: TEdit;
    ComboBoxListOfWebsites: TComboBox;
    Memo1: TMemo;
    ButtonGetToken: TButton;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    LabelChooseWebsite: TLabel;
    BitBtnAddWebsite: TBitBtn;
    MemoResult: TMemo;
    MainMenu1: TMainMenu;
    System1: TMenuItem;
    Settings1: TMenuItem;
    About1: TMenuItem;
    ClearData1: TMenuItem;
    ProgramClose1: TMenuItem;
    ButtonAccountInfo: TButton;
    TimerToken: TTimer;
    BitBtnDeleteWebsite: TBitBtn;
    EditLink: TEdit;
    ButtonFileCheck: TButton;
    MemoToken: TMemo;
    AboutInfo1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure ButtonGetTokenClick(Sender: TObject);
    procedure BitBtnAddWebsiteClick(Sender: TObject);
    procedure ComboBoxListOfWebsitesChange(Sender: TObject);
    procedure EditKey1Change(Sender: TObject);
    procedure EditKey2Change(Sender: TObject);
    procedure TimerTokenTimer(Sender: TObject);
    procedure BitBtnDeleteWebsiteClick(Sender: TObject);
    procedure ButtonAccountInfoClick(Sender: TObject);
    procedure ButtonFileCheckClick(Sender: TObject);
    procedure ProgramClose1Click(Sender: TObject);
    procedure ClearData1Click(Sender: TObject);
    procedure AboutInfo1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  folder, value, token, accountid, username : string;
  websitesdetails : TINIFile;
  admin : boolean;
implementation

{$R *.dfm}

procedure TForm1.AboutInfo1Click(Sender: TObject);
begin
showmessage (' easy API check for  https://yetishare.com/' + #13+
             ' build @ https://www.embarcadero.com/products/Delphi');
end;

procedure TForm1.BitBtnAddWebsiteClick(Sender: TObject);
begin
value := InputBox('Add new website', 'Please type your website address', 'http://website.com/');
if value <>'' then
   begiN
   ComboBoxListOfWebsites.Text := value;
   ComboBoxListOfWebsites.Items.Add( value );
   websitesdetails.WriteString( ComboBoxListOfWebsites.Text, 'key1', ''  );
   websitesdetails.WriteString( ComboBoxListOfWebsites.Text, 'key2', ''  );
   websitesdetails.UpdateFile;
   enD
   else showmessage('field cannot be empty');
end;

procedure TForm1.BitBtnDeleteWebsiteClick(Sender: TObject);
begin
websitesdetails.EraseSection( ComboBoxListOfWebsites.Text );
websitesdetails.UpdateFile;
showmessage ( 'You have deleted: ' + ComboBoxListOfWebsites.Text );
ComboBoxListOfWebsites.Text := '';
end;

procedure TForm1.ButtonAccountInfoClick(Sender: TObject);
begin

  memo1.Clear;
  RESTClient1.BaseURL := ComboBoxListOfWebsites.Text + 'api/v2/account/info';
  Restrequest1.AddParameter( 'access_token', token );
  Restrequest1.AddParameter( 'account_id', accountID );
  restrequest1.Execute;
  memo1.text :=  restresponse1.Content;
  memoResult.Lines.Insert(0, 'Your username @ '+ ComboBoxListOfWebsites.Text +' is: ' +  (usrname (memo1.Text) ) );
  username :=  usrname (memo1.Text);

end;

procedure TForm1.ButtonFileCheckClick(Sender: TObject);
begin

if admin = true then memoResult.Lines.Insert(0 , nrid( EditLink.Text, length(ComboBoxListOfWebsites.Text)+1 ) );

if EditLink.text <> '' then
  begiN
  memo1.Clear;
  RESTClient1.BaseURL := ComboBoxListOfWebsites.Text + 'api/v2/file/info';
  Restrequest1.AddParameter( 'access_token', token );
  Restrequest1.AddParameter( 'account_id', accountID );
  Restrequest1.AddParameter( 'file_id', nrid( EditLink.Text, length(ComboBoxListOfWebsites.Text)+1 ) );
  restrequest1.Execute;
  memo1.text :=  restresponse1.Content;
  if posEx('status":"error"',memo1.Text) > 0 then memoResult.Lines.Insert(0, 'there is inActive files database');
  enD else
      begin
      showmessage( 'no link to read file information ' ) ;
      EditLink.SetFocus;
      end;

end;

procedure TForm1.ButtonGetTokenClick(Sender: TObject);
begin
if ComboBoxListOfWebsites.Text ='' then showmessage(' choose website or add new to the list ' ) else
if EditKey1.Text ='' then showmessage(' add your API key1 to the field ' ) else
if EditKey2.Text ='' then showmessage(' add your API key2 to the field ' ) else
  Begin
  memo1.Clear;
  RESTClient1.BaseURL := ComboBoxListOfWebsites.Text + 'api/v2/authorize';
  Restrequest1.AddParameter( 'key1', EditKey1.Text );
  Restrequest1.AddParameter( 'key2', EditKey2.Text );
  restrequest1.Execute;
  memo1.text :=  restresponse1.Content;

  if PosEx('account level does not have access', memo1.text) > 0 then memoResult.Lines.Insert(0, 'account level does not have active API access');
  if PosEx('access_token', memo1.Lines.Strings[0]) > 0 then
    begin
    accountid := accid ( memo1.Text);
    memoResult.Lines.Insert(0, 'Your account @ '+ ComboBoxListOfWebsites.Text +' have active Token');
    token := nrtoken( memo1.Text);
    ButtonAccountInfo.visible := true;
    ButtonFileCheck.Visible := true;
    EditLink.Visible := true;
    if admin = true then memoResult.Lines.Insert(0, 'nr id numer is: '+accountID);
    if admin = true then memoResult.Lines.Insert(0, 'nr token is: '+token);
    end;
  End;

end;

procedure TForm1.ClearData1Click(Sender: TObject);
begin
memo1.Clear;
memo1.Lines.SaveToFile( folder + 'details.xml' );
end;

procedure TForm1.ComboBoxListOfWebsitesChange(Sender: TObject);
begin
EditKey1.Text := websitesdetails.ReadString( ComboBoxListOfWebsites.Text, 'key1', ''  );
EditKey2.Text := websitesdetails.ReadString( ComboBoxListOfWebsites.Text, 'key2', ''  );
end;

procedure TForm1.EditKey1Change(Sender: TObject);
begin
websitesdetails.WriteString( ComboBoxListOfWebsites.Text, 'key1', EditKey1.Text  );
websitesdetails.UpdateFile;
end;

procedure TForm1.EditKey2Change(Sender: TObject);
begin
websitesdetails.WriteString( ComboBoxListOfWebsites.Text, 'key2', EditKey2.Text  );
websitesdetails.UpdateFile;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
admin := false;
folder := getcurrentdir;
folder := folder + '\';

token := '';

ComboBoxListOfWebsites.Clear;
// ComboBoxListOfWebsites.Items.LoadFromFile( folder + 'websites.xml' );

websitesdetails := TINIFile.Create(folder + 'details.xml');
websitesdetails.ReadSections( ComboBoxListOfWebsites.Items );

if fileexists( 'apicheck.dcu' ) then admin := true;

if admin = true then
    BEGIN
    memo1.Visible := true;
    END;
end;

procedure TForm1.ProgramClose1Click(Sender: TObject);
begin
application.Terminate;
end;

procedure TForm1.TimerTokenTimer(Sender: TObject);
begin
if ComboBoxListOfWebsites.Text <>'' then
  Begin
  memoToken.Clear;
  RESTClient1.BaseURL := ComboBoxListOfWebsites.Text + 'api/v2/authorize';
  Restrequest1.AddParameter( 'key1', EditKey1.Text );
  Restrequest1.AddParameter( 'key2', EditKey2.Text );
  restrequest1.Execute;
  memoToken.text :=  restresponse1.Content;
  if PosEx('access_token', memoToken.Lines.Strings[0]) > 0 then
    token := nrtoken( memoToken.Text);
  memoResult.Lines.Insert(0, 'Token @ '+ ComboBoxListOfWebsites.Text +' was updated');
  End;
end;

end.
