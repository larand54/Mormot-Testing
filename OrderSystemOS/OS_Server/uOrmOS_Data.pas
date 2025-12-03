unit uOrmOS_Data;
//
// Contains ORM-classes used in storage(DB)
// Definition of arrays for each Ormclass.
// In the initialization part we register the arrays for there Json-serializers
//
{$I mormot.defines.inc}
interface
uses
  {$I mormot.uses.inc}
  System.SysUtils
  , mormot.core.base
  , mormot.orm.base // Required by "AS_UNIQUE"
  , mormot.orm.core
  , mormot.core.variants
  , mormot.core.json
  , uOS_Data           // Defines some user types.
;

type
  {$I mormot.uses.inc}

  TOrmCustomer = class(TOrm)
  private
    fName: RawUTF8;
    fCustomerID: TCustomerID;
    fCreateTime: TCreateTime;
    fModTime: TModTime;
  published
    property Name: RawUTF8 read fName write fName;
    property CustomerID: RawUTF8 read fCustomerID write fCustomerID stored AS_UNIQUE;
    property CreateTime: TCreateTime read fCreateTime write fCreateTime;
    property ModTime: TModTime read fModTime write fModTime;
  end;

  TOrmCustomerArray = array of TOrmCustomer;

  TOrmProduct = class(TOrm)
  private
    fName: RawUTF8;
    fPrice: Currency;
    fCurrency: RawUTF8;
    fData: variant;
    fCreateTime: TCreateTime;
    fModTime: TModTime;
  published
    property Name: RawUTF8 read fName write fName stored AS_UNIQUE;
    property Price: Currency read fPrice write fPrice;
    property Currency: RawUTF8 read fCurrency write fCurrency;
    property Data: variant read fData write fData;
    property CreateTime: TCreateTime read fCreateTime write fCreateTime;
    property ModTime: TModTime read fModTime write fModTime;
  end;
  TOrmProductArray = array of TOrmProduct;

  TOrmOSOrder = class(TOrm)
  private
    fOrderNo: RawUTF8;
    fCustomerID: TCustomerID;
    fOrderLines: variant;
    fNextOrderLineNo: integer;
    fCreateTime: TCreateTime;
    fModTime: TModTime;
  public
      procedure AddOrderLine(pmcOrderLine: TOrderLine);
  published
    property OrderNo: RawUTF8 read fOrderNo write fOrderNo;
    property CustomerID: TCustomerID read fCustomerID write fCustomerID;
    property OrderLines: variant read fOrderLines write fOrderLines;
    property NextOrderLineNo: integer read fNextOrderLineNo write fNextOrderLineNo;
    property CreateTime: TCreateTime read fCreateTime write fCreateTime;
    property ModTime: TModTime read fModTime write fModTime;
  end;

  TOrmOrderArray = array of TOrmOSOrder;

function CreateOSModel: TOrmModel;

implementation
uses
  mormot.core.rtti // Rtti used in "AddOrderLine"
;
function CreateOSModel: TOrmModel;
begin
  result := TOrmModel.Create([TOrmCustomer, TOrmProduct, TOrmOSOrder]);   // Create a model for our tables.
end;

{ TOrmOSOrder }

// Add a new orderline to the order.
// All orderlines are stored in the same field as an JSON-array "[{Orderline1}, {Orderline2}..{Last orderline}]"
// The structure of an OrderLine is defined in unit "uOS_Data".
//
procedure TOrmOSOrder.AddOrderLine(pmcOrderLine: TOrderLine);
begin
//  TDocVariantData(fOrderLines).AddItem(_JsonFast(RecordSaveJson(pmcOrderLine, TypeInfo(TOrderLine)))); // Both lines works!
  TDocVariantData(fOrderLines).AddItemRtti(@pmcOrderLine, Rtti.RegisterType(TypeInfo(TOrderLine)));      // But this one is the preferable one.
end;


initialization
//
// Register our arrays for JSON serialization.
TJSONSerializer.RegisterObjArrayForJSON([
  TypeInfo(TOrmCustomerArray), TOrmCustomer,
  TypeInfo(TOrmOrderArray), TOrmOSOrder,
  TypeInfo(TOrmProductArray), TOrmProduct]);
end.
