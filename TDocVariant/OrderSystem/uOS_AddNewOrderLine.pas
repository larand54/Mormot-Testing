unit uOS_AddNewOrderLine;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, uOS_Server,
  mormot.core.base;

type
  TfrmAddNewOrderLine = class(TForm)
    btnAddNewOrderLine: TBitBtn;
    edProduct: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    cbOrder: TComboBox;
    Label3: TLabel;
    edQty: TEdit;
    cbQtyType: TComboBox;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnAddNewOrderLineClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    OS_Server: TOS_Client;
  public
    { Public declarations }
  end;

var
  frmAddNewOrderLine: TfrmAddNewOrderLine;

implementation

uses
  uOS_Data, TypInfo, mormot.core.json;

{$R *.dfm}

procedure TfrmAddNewOrderLine.btnAddNewOrderLineClick(Sender: TObject);
var
  Order: TOrmOSOrder;
  ol: TOrderLine;
  olJson: RawUTF8;
  ols: RawUTF8;
  ord: TOrmOSOrder;
  OrderNo: RawUTF8;
begin
  ol.Product := edProduct.Text;
  ol.QtyType := TQty(cbQtyType.ItemIndex);
  ol.Qty := StrToFloat(edQty.Text);
  ol.Measure := getMeasureOfQty(ol.QtyType);
  olJson := RecordSaveJson(ol, TypeInfo(TOrderLine));
  Order := TOrmOSOrder.Create;
  ord := TOrmOSOrder(cbOrder.Items.Objects[cbOrder.ItemIndex]);
  OrderNo := cbOrder.Text;
  OS_Server.server.Retrieve('OrderNo = ?', [OrderNo], [], Order);
  OS_Server.server.Retrieve(ord.ID, Order);
  Order.OrderLines := olJson;

  if not UpdateOrder(OS_Server, Order) then
    showMessage('*** ERROR ***');
  if assigned(Order) then
    freeandnil(Order);

end;

procedure TfrmAddNewOrderLine.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  i: integer;
begin
  for i := cbOrder.Items.Count - 1 downto 0 do
  begin
    cbOrder.Items.Objects[i].free;
  end;
  OS_Server.Model.free;
  OS_Server.free;
end;

procedure TfrmAddNewOrderLine.FormCreate(Sender: TObject);
var
  orderArray: TOrderArray;
  i: integer;
  j: integer;
  OrderNo: string;
  Qty: TQty;
begin
  cbOrder.Items.Clear;
  cbOrder.Text := '';
  OS_Server := initServer;
  OS_Server.server.RetrieveListObjArray(orderArray, TOrmOSOrder, '', ['*']);

  for i := 0 to high(orderArray) do
  begin
    OrderNo := TOrmOSOrder(orderArray[i]).OrderNo;
    cbOrder.Items.AddObject(OrderNo, orderArray[i]);
  end;
  cbOrder.ItemIndex := 0;

  cbQtyType.Text := '';
  for Qty := low(TQty) to high(TQty) do
    cbQtyType.Items.Add(GetEnumName(TypeInfo(TQty), integer(Qty)));
  cbQtyType.ItemIndex := 0;
end;

end.
