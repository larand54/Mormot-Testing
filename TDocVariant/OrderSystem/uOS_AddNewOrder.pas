unit uOS_AddNewOrder;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, uOS_Server

    ;

type
  TfrmAddOrder = class(TForm)
    btnAddOrder: TBitBtn;
    cbClient: TComboBox;
    Label1: TLabel;
    edOrderNo: TEdit;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnAddOrderClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    OS_Server: TOS_Client;
  public
    { Public declarations }
  end;

var
  frmAddOrder: TfrmAddOrder;

implementation

uses
  uOS_Data;

{$R *.dfm}

procedure TfrmAddOrder.btnAddOrderClick(Sender: TObject);
var
  OSClient: TOrmClient;
  newOrder: TOrmOSOrder;
  OS_Server: TOS_Client;
begin
  newOrder := nil;
  OS_Server := initServer;
  newOrder := TOrmOSOrder.Create;
  newOrder.orderNo := edOrderNo.text;
  newOrder.ClientID := getNewClientID(OSClient.Name);
  newOrder.nextorderLineNo := 1;
  addOrder(OS_Server, newOrder);

  if newOrder <> nil then
    newOrder.Free;
  OS_Server.Model.Free;
  OS_Server.Free;
end;

procedure TfrmAddOrder.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: integer;
begin
  for i := cbClient.Items.Count - 1 to 0 do
    TOrmClient(cbClient.Items.Objects[i]).Free;
  OS_Server.Model.Free;
  OS_Server.Free;
end;

procedure TfrmAddOrder.FormCreate(Sender: TObject);
var
  clientArray: TClientArray;
  i: integer;
  j: integer;
begin
  cbClient.Items.Clear;
  OS_Server := initServer;
  OS_Server.server.RetrieveListObjArray(clientArray, TOrmClient, '', ['*']);
  for i := 0 to high(clientArray) do
  begin
    caption := TOrmClient(clientArray[0]).Name;
    cbClient.Items.AddObject(clientArray[i].ClientID, clientArray[i]);
    if i = 0 then
      cbClient.text := clientArray[i].ClientID;
  end;
  for i := high(clientArray) downto 0 do
  begin
    clientArray[i].Free;
  end;

end;

end.
