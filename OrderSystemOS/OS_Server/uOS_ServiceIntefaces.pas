unit uOS_ServiceIntefaces;

{$I mormot.defines.inc}

interface
uses
  System.SysUtils
  , mormot.core.base
  , mormot.core.rtti
  , mormot.core.interfaces
  , uOS_Data
;

const
  ROOT_NAME_FILE = 'OrderSystem';
type
  IDocument = interface(IInvokable)
  ['{691473CE-1695-440A-A212-F334C466974A}']
    function AddOrder(const pmcOrder: TOrder): Boolean;
    function AddClient(const pmcClient: TClient): Boolean;
    procedure AddProdukt(out pmcProduct: TProduct);
    procedure AddOrderLine(out pmcOL: TOrderLine);
  end;

implementation

end.
