unit uOrmOS_Data;

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
  , uOS_Data
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

  TCustomerArray = array of TOrmCustomer;

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

  TOrderArray = array of TOrmOSOrder;

function CreateOSModel: TOrmModel;

implementation

function CreateOSModel: TOrmModel;
begin
  result := TOrmModel.Create([TOrmCustomer, TOrmProduct, TOrmOSOrder]);
end;

{ TOrmOSOrder }

procedure TOrmOSOrder.AddOrderLine(pmcOrderLine: TOrderLine);
begin
  TDocVariantData(fOrderLines).AddItem(_JsonFast(RecordSaveJson(pmcOrderLine, TypeInfo(TOrderLine))));
end;


initialization

TJSONSerializer.RegisterObjArrayForJSON([TypeInfo(TCustomerArray), TOrmCustomer,
  TypeInfo(TOrderArray), TOrmOSOrder]);
end.
