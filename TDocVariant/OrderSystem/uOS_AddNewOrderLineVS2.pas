unit uOS_AddNewOrderLineVS2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons
  , uOS_Server
  , mormot.core.base
;

type
  TfrmAddNewOrderLineVS2 = class(TForm)
    btnAddNewOrderLineVS2: TBitBtn;
    edProduct: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    cbOrder: TComboBox;
    Label3: TLabel;
    edQty: TEdit;
    cbQtyType: TComboBox;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnAddNewOrderLineVS2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    OS_Server: TOS_Client;
  public
    { Public declarations }
  end;

var
  frmAddNewOrderLineVS2: TfrmAddNewOrderLineVS2;

implementation
uses
  uOS_Data
  , TypInfo
  , mormot.core.json
;

{$R *.dfm}

procedure TfrmAddNewOrderLineVS2.btnAddNewOrderLineVS2Click(Sender: TObject);
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
  ol.Measure := getMeasureOfQty(ol.Qtytype);
  olJson := RecordSaveJson(ol, TypeInfo(TOrderLine));
  Order := TOrmOSOrder.Create;
  ord := TOrmOSOrder(cbOrder.Items.Objects[cbOrder.ItemIndex]);
  OrderNo := cbOrder.Text;
  OS_Server.server.Retrieve('OrderNo = ?',[OrderNo],[],Order);
  OS_Server.server.Retrieve(ord.ID,Order);
  Order.OrderLines := olJson;

  if not UpdateOrder(OS_Server, Order) then
    showMessage('*** ERROR ***');
  if assigned(Order) then
    freeandnil(Order);

end;

procedure TfrmAddNewOrderLineVS2.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  i: integer;
begin
  for I := cbOrder.items.Count-1 downto 0 do begin
    cbOrder.Items.Objects[i].free;
  end;
  OS_Server.Model.Free;
  OS_Server.Free;
end;

procedure TfrmAddNewOrderLineVS2.FormCreate(Sender: TObject);
var
  orderArray: TOrderArray;
  i: integer;
  j: integer;
  OrderNo: string;
  qty: TQty;
begin
  cbOrder.Items.Clear;
  cbOrder.Text := '';
  OS_Server := initServer;
  OS_Server.server.RetrieveListObjArray(orderArray, TOrmOSOrder, '',['*']);

  for I := 0 to high(orderArray) do begin
    OrderNo := TOrmOSOrder(orderArray[i]).OrderNo;
    cbOrder.Items.AddObject(OrderNo, orderArray[i]);
  end;
  cbOrder.ItemIndex := 0;

  cbQtyType.Text := '';
  for qty := low(TQty) to high(Tqty) do
    cbQtyType.Items.Add(GetEnumName(TypeInfo(TQty), integer(qty))) ;
  cbQtyType.ItemIndex := 0;
end;

end.
