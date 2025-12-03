unit uOS_Data;
//
// Contains datastructures used on the client side and some common types used in the order system.
// Also some special functions.
//
{$I mormot.defines.inc}

interface

uses
  {$I mormot.uses.inc}
  System.SysUtils
  , mormot.core.base
  , mormot.orm.core
;

type

  TCustomerID = RawUTF8;
  TOrderNo = RawUTF8;

  TQty = (pcs, length, volume, weight);

  TQuantity = packed record
    Qty: TQty;
    measure: RawUTF8;
  end;

  TCustomer = class
  private
   fName: RawUTF8;
   fCustomerID: TCustomerID;
  published
    property Name: RawUTF8 read fName write fName;
    property CustomerID: TCustomerID read fCustomerID write fCustomerID;
  end;
  TCustomerArray = array of TCustomer;

  TProduct = class
  private
    fName: RawUTF8;
    fPrice: Currency;
    fCurrency: RawUTF8;
    fData: variant;
  published
    property Name: RawUTF8 read fName write fName;
    property Price: Currency read fPrice write fPrice;
    property Currcy: RawUTF8 read fCurrency write fCurrency;
    property Data: variant read fData write fData;
  end;
  TProductArray = array of TProduct;

  TOrderLine = packed record
    OLNo: integer;
    Product: RawUTF8;
    Qty: double;
    QtyType: TQty;
    measure: RawUTF8;
  end;
  TOrderLineArray = array of TOrderLine;

  TOrder = class
  private
    fOrderNo: RawUTF8;
    fCustomerID: TCustomerID;
    fOrderLines: variant;
    fNextOrderLineNo: integer;
  published
    property OrderNo: RawUTF8 read fOrderNo write fOrderNo;
    property CustomerID: TCustomerID read fCustomerID write fCustomerID;
    property OrderLines: variant read fOrderLines write fOrderLines;                     // Json formatted array of orderlines.
    property NextOrderLineNo: integer read fNextOrderLineNo write fNextOrderLineNo;
  end;
  TOrderArray = array of TOrder;

function getNewCustomerID(const pmcName: RawUTF8): TCustomerID;
function getMeasureOfQty(const pmcQty: TQty): RawUTF8;

const
  __TOrderLineArray = 'OLNo integer Product RawUTF8 Qty double QtyType TQty measure RawUTF8';  // Used for serializing TOrderLineArray from the json formated orderlines property.

implementation

function getNewCustomerID(const pmcName: RawUTF8): RawUTF8;
begin
  result := pmcName + IntToStr(Random(1000));
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
end.
