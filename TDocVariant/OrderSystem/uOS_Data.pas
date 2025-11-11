unit uOS_Data;

interface

uses
  System.SysUtils, mormot.core.base, mormot.orm.base // Required by "AS_UNIQUE"
    , mormot.orm.core;

type

  TQty = (pcs, length, volume, weight);

  TQuantity = packed record
    Qty: TQty;
    measure: RawUTF8;
  end;

  TClientID = RawUTF8;

  TOrmClient = class(TOrm)
  private
    fName: RawUTF8;
    fClientID: TClientID;
    fCreateTime: TCreateTime;
    fModTime: TModTime;
  published
    property Name: RawUTF8 read fName write fName;
    property ClientID: RawUTF8 read fClientID write fClientID stored AS_UNIQUE;
    property CreateTime: TCreateTime read fCreateTime write fCreateTime;
    property ModTime: TModTime read fModTime write fModTime;
  end;

  TClientArray = array of TOrmClient;

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

  TOrderLine = packed record
    OLNo: integer;
    Product: RawUTF8;
    Qty: double;
    QtyType: TQty;
    measure: RawUTF8;
  end;

  TObjOrderLine = class
  public
    OLNo: integer;
    Product: RawUTF8;
    Qty: double;
    QtyType: TQty;
    measure: RawUTF8;
  end;

  TOrmOSOrder = class(TOrm)
  private
    fOrderNo: RawUTF8;
    fClientID: TClientID;
    fOrderLines: variant;
    fNextOrderLineNo: integer;
    fCreateTime: TCreateTime;
    fModTime: TModTime;
  public
      procedure AddOrderLine(pmcOrderLine: TOrderLine);
  published
    property OrderNo: RawUTF8 read fOrderNo write fOrderNo;
    property ClientID: TClientID read fClientID write fClientID;
    property OrderLines: variant read fOrderLines write fOrderLines;
    property NextOrderLineNo: integer read fNextOrderLineNo write fNextOrderLineNo;
    property CreateTime: TCreateTime read fCreateTime write fCreateTime;
    property ModTime: TModTime read fModTime write fModTime;
  end;

  TOrderArray = array of TOrmOSOrder;

function CreateOSModel: TOrmModel;
function getNewClientID(const pmcName: RawUTF8): RawUTF8;
function getMeasureOfQty(const pmcQty: TQty): RawUTF8;

implementation
uses
  mormot.core.variants
  , mormot.core.json
;

function getNewClientID(const pmcName: RawUTF8): RawUTF8;
begin
  result := pmcName + IntToStr(Random(1000));
end;

function CreateOSModel: TOrmModel;
begin
  result := TOrmModel.Create([TOrmClient, TOrmProduct, TOrmOSOrder]);
end;

function getMeasureOfQty(const pmcQty: TQty): RawUTF8;
begin
  case pmcQty of
    pcs:
      result := 'styck';
    length:
      result := 'm';
    volume:
      result := 'm3';
    weight:
      result := 'kg';
  end;
end;

{ TOrmOSOrder }

procedure TOrmOSOrder.AddOrderLine(pmcOrderLine: TOrderLine);
begin
  TDocVariantData(fOrderLines).AddItem(_JsonFast(RecordSaveJson(pmcOrderLine, TypeInfo(TOrderLine))));
end;

initialization

TJSONSerializer.RegisterObjArrayForJSON([TypeInfo(TClientArray), TOrmClient,
  TypeInfo(TOrderArray), TOrmOSOrder]);

end.
