unit OSModelServices;

{$I mormot.defines.inc}

interface

uses
  {$I mormot.uses.inc}
  System.SysUtils
  ,  mormot.core.base
  ,  mormot.core.text
  ,  mormot.core.rtti
  ,  mormot.core.json
  ,  mormot.core.unicode
  ,  mormot.core.datetime
  ,  mormot.core.interfaces
  ,  mormot.rest.core
  ,  mormot.rest.server
  ,  mormot.soa.server
  ,  mormot.core.log
  ,  IOrderSystemInterfaces
  ,  uOS_Data
  , uOrmOS_Data
;

type
  TOrderSystemServiceObject = class(TInjectableObjectRest)
  public
    function GetRoot(out pmoROOT: RawUTF8): Boolean;
  end;

  TOrderSystemService = class (TInjectableObjectRest, IOrderSystem)
    function AddCustomer(const pmcCustomer: TCustomer): Boolean;
    function AddProduct(const pmcProduct: TProduct): Boolean;
    function AddOrder(const pmcOrder: TOrder): Boolean;
    function AddOrderLine(var pmvOrderLine: TOrderLine; const pmcOrderNo: TOrderNo): Boolean;
    function RetrieveOrders(out pmoOrders: TOrderArray): boolean;
    function RetrieveCustomers(out pmoCustomers: TCustomerArray): boolean;
    function RetrieveProducts(out pmoProducts: TProductArray): boolean;
  end;


implementation
uses
  mormot.core.os
  ,  uOS_ServiceServer
;

var
  Log: ISynLog;
  LogFamily: TSynLogFamily;

{ TOrderSystemServiceObject }

function TOrderSystemServiceObject.GetRoot(out pmoROOT: RawUTF8): Boolean;
begin
  pmoROOT := 'ordersystem';
  result := false;
end;


{ TOrderSystemService }

function TOrderSystemService.AddCustomer(const pmcCustomer: TCustomer): Boolean;
var
  n: RawUTF8;
  ormCustomer: TOrmCustomer;
begin
  result := false;
  ormCustomer := TOrmCustomer.create;
  ormCustomer.name := pmcCustomer.Name;
  ormCustomer.CustomerID := pmcCustomer.CustomerID;
  n := pmcCustomer.name;
  TSynLog.add.log(sllinfo,'%',[pmcCustomer.name],nil);
  if fServer.Add(ormCustomer,'*',true) > 0 then
    result := true;
end;

function TOrderSystemService.AddOrder(const pmcOrder: TOrder): Boolean;
var
  ormOrder: TOrmOSOrder;
begin
  result := false;
  ormOrder := TOrmOSOrder.create;
  ormOrder.OrderNo := pmcOrder.OrderNo;
  ormOrder.CustomerID := pmcOrder.CustomerID;
  ormOrder.OrderLines := pmcOrder.OrderLines;
  ormOrder.NextOrderLineNo := 1;
  if fServer.Add(ormOrder,'*',true)  > 0 then
    result := true;
  TSynLog.add.log(sllinfo,'%',[pmcOrder.OrderNo],nil);
end;

function TOrderSystemService.AddOrderLine(
  var pmvOrderLine: TOrderLine; const pmcOrderNo: TOrderNo): Boolean;
var
  ord: TOrmOSOrder;
  nlno: integer;
begin
  ORD := TOrmOSOrder.Create;
  result := false;
// Retrieve existing order
  if fServer.Retrieve('OrderNo='+quotedStr(pmcOrderNo),Ord,'*') then begin
    pmvOrderLine.OLNo := Ord.NextOrderLineNo;
// Add orderline to the order
    ord.AddOrderLine(pmvOrderLine);
// Increment NextOrderLineNo.
    nlno := ord.NextOrderLineNo;
    inc(nlNo);
    ord.NextOrderLineNo := nlno;
// Update database with updated order
    if fServer.Update(ord)then
      result := true;
  end;
end;

function TOrderSystemService.AddProduct(const pmcProduct: TProduct): Boolean;
var
  ormProduct: TOrmProduct;
begin
  result := false;
  OrmProduct := TOrmProduct.create;
  ormProduct.Name := pmcProduct.Name;
  ormProduct.Price := pmcProduct.Price;
  ormProduct.Currency := pmcProduct.Currcy;
  ormProduct.Data := pmcProduct.Data;
  if fServer.Add(OrmProduct, '*', true) > 0 then
    result := true;;
end;

function TOrderSystemService.RetrieveCustomers(
  out pmoCustomers: TCustomerArray): boolean;
var
  ca: TOrmCustomerArray;
  i: integer;
begin
  fServer.RetrieveListObjArray(CA, TOrmCustomer,'',[],'');
  setLength(pmoCustomers, high(CA)+1);                       // Set arraysize
  for i := 0 to high(CA) do begin
    pmoCustomers[i] := TCustomer.create;                     // Create the object
    pmoCustomers[i].CustomerID := CA[i].CustomerID;
    pmoCustomers[i].Name := CA[i].Name;
  end;
end;

function TOrderSystemService.RetrieveOrders(
  out pmoOrders: TOrderArray): boolean;
var
  orders: TOrmOrderArray;
  i: integer;
begin
  fServer.RetrieveListObjArray(orders, TOrmOSOrder, '', [], '');
  setLength(pmoOrders, high(orders)+1);
  for i := 0 to high(orders) do begin
    pmoOrders[i] := TOrder.create;                     // Create the object
    pmoOrders[i].OrderNo := orders[i].OrderNo;
    pmoOrders[i].CustomerID := orders[i].CustomerID;
    pmoOrders[i].OrderLines := orders[i].OrderLines;
    pmoOrders[i].NextOrderLineNo := orders[i].NextOrderLineNo;
  end;
end;

function TOrderSystemService.RetrieveProducts(
  out pmoProducts: TProductArray): boolean;
var
  pr: TOrmProductArray;
  i: integer;
begin
  fServer.RetrieveListObjArray(pr, TOrmProduct, '', [], '');
  setLength(pmoProducts, high(pr)+1);
  for i := 0 to high(pr) do begin
    pmoProducts[i] := TProduct.create;                     // Create the object
    pmoProducts[i].Name := pr[i].name;
    pmoProducts[i].Price := pr[i].Price;
    pmoProducts[i].Currcy := pr[i].Currency;
    pmoProducts[i].Data := pr[i].Data;
  end;

end;
initialization
  LogFamily := TSynLog.Family;
  LogFamily.Level := LOG_VERBOSE;
  LogFamily.PerThreadLog := ptIdentifiedInOnFile;
  LogFamily.EchoToConsole := LOG_VERBOSE;
end.
