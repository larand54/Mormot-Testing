unit uOS_AddNewOrderLine;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons
  , mormot.core.base
  , mormot.net.client
  , mormot.rest.http.client
  , uClient_OrderService
  , IOrderSystemInterfaces, Vcl.Grids
;

type
  TfrmAddNewOrderLine = class(TForm)
    btnAddNewOrderLine: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    cbOrder: TComboBox;
    Label3: TLabel;
    edQty: TEdit;
    cbQtyType: TComboBox;
    Label4: TLabel;
    cbProduct: TComboBox;
    strngrdOrderLines: TStringGrid;
    btnClose: TBitBtn;
    procedure btnAddNewOrderLineClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    fOSService: TOrderSystemService;
    fService: IOrderSystem;
    fOS_Client: TRestHttpClient;
    function fillProductCombo(const pmcCbo: TComboBox): integer;  // Returns number of loaded products
    function fillOrderCombo(const pmcCbo: TComboBox): integer;  // Returns number of loaded orders
  public
    { Public declarations }
    constructor Create(Sender: TComponent; const pmcServer: TOrderSystemService); reintroduce;
  end;

var
  frmAddNewOrderLine: TfrmAddNewOrderLine;

implementation

uses
  uOS_Data, TypInfo, mormot.core.json;

{$R *.dfm}

procedure TfrmAddNewOrderLine.btnAddNewOrderLineClick(Sender: TObject);
var
  Order: TOrder;
  ol: TOrderLine;
  olJson: RawUTF8;
  ols: RawUTF8;
  ord: TOrder;
  OrderNo: TOrderNo;
begin
  ol.Product := cbProduct.Text;
  ol.QtyType := TQty(cbQtyType.ItemIndex);
  ol.Qty := StrToFloat(edQty.Text);
  ol.Measure := getMeasureOfQty(ol.QtyType);
  ord := TOrder(cbOrder.Items.Objects[cbOrder.ItemIndex]);
  orderNo := ord.OrderNo;
  if not fService.AddOrderLine(ol, OrderNo) then
    showMessage('*** ERROR ***');
  if assigned(Ord) then
    freeandnil(Ord);
end;

function TfrmAddNewOrderLine.fillOrderCombo(const pmcCbo: TComboBox): integer;
var
  orderArray: TOrderArray;
  i: integer;
  OrdNo: RawUTF8;
begin
  result := -1;
  pmcCbo.items.clear;
  fService.RetrieveOrders(OrderArray);
  for i := 0 to high(orderArray) do
  begin
    OrdNo := TOrder(orderArray[i]).OrderNo;
    pmcCbo.Items.AddObject(OrdNo, orderArray[i]);
  end;
  result := high(orderArray);
end;

function TfrmAddNewOrderLine.fillProductCombo(const pmcCbo: TComboBox): integer;
var
  productArray: TProductArray;
  i: integer;
  prod: RawUTF8;
begin
  result := -1;
  cbProduct.items.clear;
  fService.RetrieveProducts(ProductArray);
  for i := 0 to high(productArray) do
  begin
    Prod := TProduct(productArray[i]).Name;
    cbProduct.Items.AddObject(Prod, productArray[i]);
  end;
  result := high(productArray);
end;

procedure TfrmAddNewOrderLine.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  i: integer;
begin
end;

constructor TfrmAddNewOrderLine.Create(Sender: TComponent; const pmcServer: TOrderSystemService);
var
  Qty: TQty;
begin
  inherited create(sender);
  if not pmcServer.client.Resolve(IOrderSystem, fService) then
    Exit;
  if fillOrderCombo(cbOrder) < 0 then
    exit;
  if fillProductCombo(cbProduct) < 0 then
    exit;
  cbQtyType.Text := '';
  for Qty := low(TQty) to high(TQty) do
    cbQtyType.Items.Add(GetEnumName(TypeInfo(TQty), integer(Qty)));
  cbQtyType.ItemIndex := 0;
end;

end.
