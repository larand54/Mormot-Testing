unit uOS_AddNewOrderLineVS1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons
  , uOS_Server
  , mormot.core.base
  , uOS_Data
;

type
  TfrmAddNewOrderLineVS1 = class(TForm)
    btnAddNewOrderLine: TBitBtn;
    cbQtyType: TComboBox;
    Label4: TLabel;
    Label1: TLabel;
    edQty: TEdit;
    edProduct: TEdit;
    Label2: TLabel;
    cbOrder: TComboBox;
    Label3: TLabel;
    ListBox3: TListBox;
    ListBox2: TListBox;
    ListBox1: TListBox;
    btnAddNewOrderLine_Quick: TBitBtn;
    procedure btnAddNewOrderLineClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbOrderChange(Sender: TObject);
    procedure btnAddNewOrderLine_QuickClick(Sender: TObject);
  private
    { Private declarations }
    OS_Server: TOS_Client;
    selectedOrder: TOrmOSOrder;
  public
    { Public declarations }
  end;

var
  frmAddNewOrderLineVS1: TfrmAddNewOrderLineVS1;

implementation

uses
  TypInfo
  , mormot.core.json
  , mormot.core.Variants
  , System.Generics.Collections
;

{$R *.dfm}

procedure TfrmAddNewOrderLineVS1.btnAddNewOrderLineClick(Sender: TObject);
var
  js, js2: RawByteString;     // Contains the jsonstring stored in the order class
  val, newLine: variant;      // Orderline of format used by IDocList
  list: IDocList;             // Contains the json array suitable for appending more orderlines
  Dict: IDocDict;             // Not used here
  f: TDocDictFields;          // Not used here
  Obj: TOrderLine;            // Packed record to hold data for an orderline

begin
  Obj.Product := edProduct.Text;
  Obj.QtyType := TQty(cbQtyType.ItemIndex);
  Obj.Qty := StrToFloat(edQty.Text);
  Obj.Measure := getMeasureOfQty(obj.QtyType);
  Obj.OlNo := SelectedOrder.NextOrderLineNo;
  js := RecordSaveJson(Obj, TypeInfo(TOrderLine));
  newLine := _JsonFast(js);

  if VarIsNull(selectedOrder.OrderLines) then    // On a new order this is allways NULL
  begin
    list := DocList(js);                         // we need to create new list and then append the first OL.
    list.Append(newLine);                        //After append the first line we are ready to update the database
  end
  else
  begin
    js2 := _JsonFast(selectedOrder.OrderLines);  // New lines except for the first one will be added here.
    list := DocList(js2);
    list.Append(newLine);
  end;

  val := list.AsVariant;                  // Order lines are stored as variants.
  selectedOrder.OrderLines := val;
  SelectedOrder.NextOrderLineNo := SelectedOrder.NextOrderLineNo + 1;
  if not UpdateOrder(OS_Server, selectedOrder) then
    showMessage('*** ERROR ***');
end;

procedure TfrmAddNewOrderLineVS1.btnAddNewOrderLine_QuickClick(Sender: TObject);
var
  Obj: TOrderLine;            // Packed record to hold data for an orderline
begin
  Obj.Product := edProduct.Text;
  Obj.QtyType := TQty(cbQtyType.ItemIndex);
  Obj.Qty := StrToFloat(edQty.Text);
  Obj.Measure := getMeasureOfQty(obj.QtyType);
  Obj.OlNo := SelectedOrder.NextOrderLineNo;
  selectedOrder.AddOrderLine(Obj);
  SelectedOrder.NextOrderLineNo := SelectedOrder.NextOrderLineNo + 1;
  if not UpdateOrder(OS_Server, selectedOrder) then
    showMessage('*** ERROR ***')
  else begin
  end;
end;


procedure TfrmAddNewOrderLineVS1.cbOrderChange(Sender: TObject);
begin
  selectedOrder := TOrmOSOrder.Create;
  OS_Server.server.Retrieve(TOrmOSOrder(cbOrder.Items.Objects[cbOrder.itemIndex]).ID, selectedOrder);
end;

procedure TfrmAddNewOrderLineVS1.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  i: integer;
begin
  for i := cbOrder.Items.Count - 1 downto 0 do
  begin
    cbOrder.Items.Objects[i].free;
  end;
  SelectedOrder.free;
  OS_Server.Model.free;
  OS_Server.free;
end;

procedure TfrmAddNewOrderLineVS1.FormCreate(Sender: TObject);
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
  cbOrder.OnChange(self);
end;

end.
