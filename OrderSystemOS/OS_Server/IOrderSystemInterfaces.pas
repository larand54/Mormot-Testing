unit IOrderSystemInterfaces;

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
  IOrderSystem = interface(IInvokable)
  ['{2EF6038C-FCD1-4B5C-B0B7-75C5EBD15B79}']
    function AddCustomer(const pmcCustomer: TCustomer): Boolean;
    function AddProduct(const pmcProduct: TProduct): Boolean;
    function AddOrder(const pmcOrder: TOrder): Boolean;
    function AddOrderLine(var pmvOrderLine: TOrderLine; const pmcOrderNo: TOrderNo): Boolean;
    function RetrieveOrders(out pmoOrders: TOrderArray): boolean;
    function RetrieveCustomers(out pmoCustomers: TCustomerArray): boolean;
    function RetrieveProducts(out pmoProducts: TProductArray): boolean;
//    function SaveOrder(const pmcOrder: TOrder): boolean;
  end;

implementation

initialization

  TInterfaceFactory.RegisterInterfaces([
    TypeInfo(IOrderSystem)]);
end.
