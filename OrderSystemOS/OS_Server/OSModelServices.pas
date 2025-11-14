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
  ,  ICustomServices
  ,  uOS_Data
;

type
  TCustomServiceObject = class(TInjectableObjectRest)
  public
    function GetRoot(out pmoROOT: RawUTF8): Boolean;
  end;

  TCustomService = class (TInjectableObjectRest, ICustomServices)
    function GetConnection(out pmoConnection: TSqlDBConnection): Boolean;
    function AddCustomer(const pmcCustomer: TCustomer): Boolean;
    function AddProduct(const pmcProduct: TProduct): Boolean;
    function AddOrder(const pmcOrdemer: TOrder): Boolean;
    function AddOrderLine(const pmcOrdeLine: TOrderLine): Boolean;
  end;


implementation


{ TCustomServiceObject }

function TCustomServiceObject.GetRoot(out pmoROOT: RawUTF8): Boolean;
begin
  pmoROOT := 'ordersystem';
  result := false;
end;

{ TCustomService }

function TCustomService.AddCustomer(const pmcCustomer: TCustomer): Boolean;
begin

end;

function TCustomService.AddOrder(const pmcOrdemer: TOrder): Boolean;
begin

end;

function TCustomService.AddOrderLine(const pmcOrdeLine: TOrderLine): Boolean;
begin

end;

function TCustomService.AddProduct(const pmcProduct: TProduct): Boolean;
begin

end;

function TCustomService.GetConnection(
  out pmoConnection: TSqlDBConnection): Boolean;
begin

end;

end.
