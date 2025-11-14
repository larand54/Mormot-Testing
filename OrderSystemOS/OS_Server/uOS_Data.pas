unit uOS_Data;
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

  TQty = (pcs, length, volume, weight);

  TQuantity = packed record
    Qty: TQty;
    measure: RawUTF8;
  end;

  TCustomer = packed record
    fName: RawUTF8;
    fCustomerID: TCustomerID;
  end;

  TProduct = packed record
    fName: RawUTF8;
    fPrice: Currency;
    fCurrency: RawUTF8;
    fData: variant;
  end;

  TOrderLine = packed record
    OLNo: integer;
    Product: RawUTF8;
    Qty: double;
    QtyType: TQty;
    measure: RawUTF8;
  end;

  TOrder = packed record
    fOrderNo: RawUTF8;
    fClientID: TCustomerID;
    fOrderLines: variant;
    fNextOrderLineNo: integer;
  end;

function getNewCustomerID(const pmcName: RawUTF8): RawUTF8;
function getMeasureOfQty(const pmcQty: TQty): RawUTF8;

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
