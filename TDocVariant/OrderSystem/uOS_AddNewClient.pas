unit uOS_AddNewClient;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;

type
  TfrmAddClient = class(TForm)
    edClientName: TEdit;
    edClientID: TEdit;
    BitBtn1: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
    constructor create;
  public
    { Public declarations }
  end;

var
  frmAddClient: TfrmAddClient;

implementation

uses
  uOS_Server, uOS_Data;

{$R *.dfm}

procedure TfrmAddClient.BitBtn1Click(Sender: TObject);
var
  OS_Server: TOS_Client;
  newClient: TOrmClient;
begin
  OS_Server := initServer;
  newClient := TOrmClient.create;
  newClient.Name := edClientName.text;
  newClient.ClientID := getNewClientID(newClient.Name);
  addClient(OS_Server, newClient);

  newClient.Free;
  OS_Server.Model.Free;
  OS_Server.Free;
end;

constructor TfrmAddClient.create;
begin
  Randomize;
end;

end.
