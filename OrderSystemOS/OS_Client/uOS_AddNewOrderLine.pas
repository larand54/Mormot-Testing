unit uOS_AddNewOrderLine;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons
  , mormot.core.base
  , mormot.orm.base
  , mormot.net.client
  , mormot.rest.http.client
  , uClient_OrderService
  , IOrderSystemInterfaces, Vcl.Grids
  , mormot.ui.grid.orm
  , uOS_Data
  , mormot.core.json
  , mormot.core.variants
  , mormot.core.data
  , mormot.core.text
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
    btnTest1: TButton;
    procedure btnAddNewOrderLineClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnTest1Click(Sender: TObject);
  private
    { Private declarations }
    fOSService: TOrderSystemService;
    fService: IOrderSystem;
    fOS_Client: TRestHttpClient;
    function fillProductCombo(const pmcCbo: TComboBox): integer;  // Returns number of loaded products
    function fillOrderCombo(const pmcCbo: TComboBox): integer;  // Returns number of loaded orders
    function fillGrid(const pmcGrid: TStringGrid; const pmcLineData: RawUTF8): integer;
    function test1: boolean;
  public
    { Public declarations }
    constructor Create(Sender: TComponent; const pmcServer: TOrderSystemService); reintroduce;
  end;

var
  frmAddNewOrderLine: TfrmAddNewOrderLine;

implementation

uses
  TypInfo
//  ,  mormot.core.rtti // Contains RecordLoad functionality

;
type
  TMyRecord = packed record
    Name: RawUTF8;
    Year: Integer;
  end;
  TMyRecordDynArray = array of TMyRecord;

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
end;

function TfrmAddNewOrderLine.fillGrid(const pmcGrid: TStringGrid; const pmcLineData: RawUTF8): integer;
var
  col, row: PtrInt;
  Line: TDocVariant;
  s: string;
  OL: TOrderLineArray;
begin
  if (pmcLineData = '') or
     (pmcGrid = nil) then
    exit; // avoid GPF
  {$ifdef FPC}
  pmcGrid.BeginUpdate;
  try
  {$endif FPC}
    Line := TDocVariant(pmcLineData);
//    if DynArrayLoadJson(pmcLineData, Pointer(line.A['OL'].ToJson), TypeInfo(TOrderLineArray) <> Nil then
(*
    Line.NewArray(pmcLineData, [dvoIsArray])
    pmcGrid.ColCount := Source.FieldCount;
    pmcGrid.RowCount := Source.RowCount + 1;
    for row := 0 to Source.RowCount + 1 do
      for col := 0 to Source.FieldCount-1 do
      begin
        Source.ExpandAsString(row, col, Model, s); // will do all the magic
        pmcGrid.Cells[col, row] := s;
      end;
  {$ifdef FPC}
  finally
    pmcGrid.EndUpdate;
  end;
  {$endif FPC}    *)
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

function TfrmAddNewOrderLine.test1: boolean;
(*
  uses
    mormot.core.variants,
    mormot.core.rtti; // Contains RecordLoad functionality

*)
const
  __TTextMyRecordArray = 'Name RawUTF8 Year cardinal';
var
  V: variant;
  RecordsArray: TMyRecordDynArray;
  DocData: TDocVariantData;
  length, I: integer;
  JsonStr: RawUTF8;
  item: TDocVariantData;
  MyRec: TMyRecord;
begin

  TJsonSerializer.RegisterCustomJSONSerializerFromText(TypeInfo(TMyRecordDynArray), __TTextMyRecordArray);
  JsonStr := '[{"Name":"John","Year":1982},{"Name":"Jane","Year":1985}]';
  RecordLoad(MyRec, @JsonStr[1], TypeInfo(TMyRecordDynArray));
  // Assume V is populated with an array of records data, e.g. from a JSON string:
  V := _Json('[{"Name":"John","Year":1982},{"Name":"Jane","Year":1985}]');
  DynArrayLoadJson(RecordsArray,V,TypeInfo(TMyRecordDynArray));      // Works!
  for i := 0 to high(RecordsArray) do
        Caption := Caption + RecordsArray[i].name;
    // Access the underlying TDocVariantData
    DocData := TDocVariantData(V);
    length := DocData.Count;
 // RecordLoad(MyRec, @(DocData.Items), TypeInfo(TMyRecordDynArray));

    // Use RecordLoad to populate the dynamic array
    // The second parameter specifies the type info of the dynamic array type
//    RecordLoad(DocData, @RecordsArray, TypeInfo(TMyRecordDynArray), @length );
//    RecordsArray.LoadFrom
    // Now RecordsArray contains your data
    // ... use RecordsArray ...
(*
*)

(*
  // 1. Save the TDocVariantData content to a JSON string
  JsonStr := VariantSaveJSON(V);

  // 2. Load the JSON string into the dynamic array using RTTI
  RecordLoad(jsonstr, @RecordsArray, TypeInfo(TMyRecordDynArray), @length );



  if TDocVariantData(V).IsArray then
  begin
    SetLength(RecordsArray, TDocVariantData(V).Count);
    for I := 0 to TDocVariantData(V).Count - 1 do
    begin
//      length:= TDocVariantData(V).GetItemAsInt(I);
//      if Assigned(Item) and Item.IsObject then
      begin
        RecordsArray[I].Name := Item.GetValueOrNull('Name').AsString;
        RecordsArray[I].Year := Item.GetValueOrNull('Year').AsInteger;
      end;
    end;
  end;
*)
//  caption := intToStr(high(RecordsArray));
 end;

procedure TfrmAddNewOrderLine.btnTest1Click(Sender: TObject);
begin
  test1;
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
initialization

end.
