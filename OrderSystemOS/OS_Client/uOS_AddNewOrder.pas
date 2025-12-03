unit uOS_AddNewOrder;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons
  , mormot.net.client
  , mormot.rest.http.client
  , uClient_OrderService
  , IOrderSystemInterfaces
;

type
  TfrmAddOrder = class(TForm)
    btnAddOrder: TBitBtn;
    cbCustomer: TComboBox;
    Label1: TLabel;
    edOrderNo: TEdit;
    Label2: TLabel;
    procedure btnAddOrderClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    fOSService: TOrderSystemService;
    fOS_Client: TRestHttpClient;
  public
    { Public declarations }
    constructor create(owner: TComponent; const pmcServer: TOrderSystemService); reintroduce;
    property OS_Server: TOrderSystemService read fOSService;
  end;

var
  frmAddOrder: TfrmAddOrder;

implementation

uses
  uOS_Data
;

{$R *.dfm}

procedure TfrmAddOrder.btnAddOrderClick(Sender: TObject);
var
  newOrder: TOrder;
  service: IOrderSystem;
begin
  newOrder := TOrder.create;
  newOrder.orderNo := edOrderNo.text;
  newOrder.CustomerID := getNewCustomerID(cbCustomer.Text);
  newOrder.nextorderLineNo := 0;  // Will be set in the server
  if not fOSService.Client.Resolve(IOrderSystem, service) then Exit; //=>
  service.addOrder(newOrder);
  newOrder.Free;
end;

procedure TfrmAddOrder.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: integer;
begin
end;

constructor TfrmAddOrder.Create(owner: TComponent; const pmcServer: TOrderSystemService);
var
  service: IOrderSystem;
  customerArray: TCustomerArray;
  customer: TCustomer;
  i: integer;
  j: integer;
begin
  inherited create(owner);
  fOSService := pmcServer;
  cbCustomer.Items.Clear;
  if not fOSService.Client.Resolve(IOrderSystem, service) then Exit; //=>
  service.RetrieveCustomers(customerArray);
  for i := 0 to high(customerArray) do
  begin
    customer := customerArray[i];
    cbCustomer.Items.AddObject(customerArray[i].CustomerID, TObject(customer));
    if i = 0 then
      cbCustomer.text := customerArray[i].CustomerID;
  end;
  for i := high(customerArray) downto 0 do
  begin
    customerArray[i].Free;
  end;
end;

end.
