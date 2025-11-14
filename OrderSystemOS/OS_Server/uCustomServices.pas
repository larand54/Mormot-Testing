unit uCustomServices;

{$I mormot.defines.inc}
interface
uses
  {$I mormot.uses.inc}
  system.SysUtils
  , mormot.core.base
  , mormot.core.interfaces
  , mormot.db.sql                    // TSqlDBConnection
  , mormot.soa.server
  , uOS_Data                         // Packed records and some help functions
  , ICustomServices
;

type
  TCustomService = class (TInterfacedObject, ICustomService)
    function GetConnection(out pmoConnection: TSqlDBConnection): Boolean;
    function AddCustomer(const pmcCustomer: TCustomer): Boolean;
    function AddProduct(const pmcProduct: TProduct): Boolean;
    function AddOrder(const pmcOrdemer: TOrder): Boolean;
    function AddOrderLine(const pmcOrdeLine: TOrderLine): Boolean;
end;
implementation
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
