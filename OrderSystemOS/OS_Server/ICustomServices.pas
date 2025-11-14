unit ICustomServices;

{$I mormot.defines.inc}
interface
// --- Unit  ICustomServices   -- Interface spec
  //  CustomService as follows:
uses
  {$I mormot.uses.inc}
  system.SysUtils
  , mormot.core.base
  , mormot.core.interfaces
  , mormot.db.sql                    // TSqlDBConnection
  , uOS_Data                         // Packed records and some help functions
;
type
  ICustomService = interface(IInvokable)
  ['{2EF6038C-FCD1-4B5C-B0B7-75C5EBD15B79}']
    function GetConnection(out pmoConnection: TSqlDBConnection): Boolean;
    function AddCustomer(const pmcCustomer: TCustomer): Boolean;
    function AddProduct(const pmcProduct: TProduct): Boolean;
    function AddOrder(const pmcOrdemer: TOrder): Boolean;
    function AddOrderLine(const pmcOrdeLine: TOrderLine): Boolean;
  end;

implementation

initialization

  TInterfaceFactory.RegisterInterfaces([
    TypeInfo(ICustomService)]);
end.
